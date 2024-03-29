#property strict

#include "TrailingStopLoss.mqh"
#include "..\Macros\Exceptions\UnexpectedValueException.mqh"

class TrailingStopLossSimple: public TrailingStopLoss
{
   private:
      string m_instrument;
      int m_orderType;
      int m_magic;
      double m_pipValue;
      int m_trailingStart;
      int m_trailingStop;
      int m_trailingStep;
      
      
   public:
		TrailingStopLossSimple
		(
			const string instrument,
			const int orderType,
			const int magic,
			const double pipValue,
			const int trailingStart,
			const int trailingStop,
			const int trailingStep
		)
		:
			m_instrument(instrument),
			m_orderType(orderType),
			m_magic(magic),
			m_pipValue(pipValue),
			m_trailingStart(trailingStart),
			m_trailingStop(trailingStop),
			m_trailingStep(trailingStep)
		{
		}
		
      virtual void Proceed() override
      {            
         #ifdef __MQL4__
         if(m_instrument != Symbol())
         {
            UnexpectedValueException(m_instrument);
            ExpertRemove();
         }
         
      	for (int i = 0; i < OrdersTotal(); i++)
      	{
      		if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)))
      			continue;
      		if (OrderSymbol() != m_instrument)
      			continue;
      		if (OrderMagicNumber() != m_magic)
      			continue;
      		if (OrderType() == OP_BUY && m_orderType == OP_BUY)
      		{
      			if (NormalizeDouble(Bid - OrderOpenPrice(), Digits) > NormalizeDouble(MathMax(m_trailingStop, m_trailingStart) * m_pipValue, Digits))
      			{
      				if (NormalizeDouble(OrderStopLoss(), Digits) < NormalizeDouble(Bid - (m_trailingStop* m_pipValue + m_trailingStep*m_pipValue - m_pipValue), Digits) || OrderStopLoss() == 0)
      				{
      				   double newSl = NormalizeDouble(Bid - m_trailingStop*m_pipValue, Digits);
      				   if(OrderStopLoss() == 0.0 || OrderStopLoss() < newSl)
      				   {
         					if(OrderModify(OrderTicket(), OrderOpenPrice(), newSl, OrderTakeProfit(), 0, CLR_NONE))
         					{
         					   ;
         					}
      					}
      		      }   
      	      }
      		}
      		else if (OrderType() == OP_SELL && m_orderType == OP_SELL)
   			{
   				if (NormalizeDouble(OrderOpenPrice() - Ask, Digits) > NormalizeDouble(MathMax(m_trailingStop, m_trailingStart) * m_pipValue, Digits))
   				{
   				   
   					if (NormalizeDouble(OrderStopLoss(), Digits) > NormalizeDouble(Ask + (m_trailingStop*m_pipValue + m_trailingStep*m_pipValue - m_pipValue), Digits) || OrderStopLoss() == 0)
   					{
   					   double newSl = NormalizeDouble(Ask + m_trailingStop*m_pipValue, Digits);
      				   if(OrderStopLoss() == 0.0 || OrderStopLoss() > newSl)
      				   {
      						if(OrderModify(OrderTicket(), OrderOpenPrice(), newSl, OrderTakeProfit(), 0, CLR_NONE))
      						{
      						   ;
      						}   
   						}				
   			      }
   			   }
   			}
      	}
      	#endif
      } 
      
};