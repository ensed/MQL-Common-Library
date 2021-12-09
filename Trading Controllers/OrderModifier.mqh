#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "MarketError.mqh"
#ifdef __MQL5__
#include <Trade\Trade.mqh>
#endif 

#include "TradeContext.mqh"

class OrderModifier
{
   protected:
      long m_ticket;
      int m_slippage;
      double m_newStopLoss;
      double m_newTakeProfit;      
      
      double m_priceOpen;
      double m_takeProfit;
      double m_stopLoss;
      datetime m_expiration;
      
      int m_digits;  
      
      #ifdef __MQL5__
      CTrade m_trade;
      #endif   
      
      uint m_errorCode;  
      
   public:      
      OrderModifier(const long ticket, const int slippage, const double newStopLoss, const double newTakeProfit)
      {
         m_slippage = slippage;
         m_newStopLoss = newStopLoss;
         m_newTakeProfit = newTakeProfit; 
         m_ticket = ticket;    
         
         #ifdef __MQL5__
         m_trade.SetDeviationInPoints(m_slippage);
         #endif     
      }    
      
      OrderModifier(const long ticket, const int slippage, const double newStopLoss, const double newTakeProfit, const double priceOpen)
      {
         m_slippage = slippage;
         m_newStopLoss = newStopLoss;
         m_newTakeProfit = newTakeProfit; 
         m_priceOpen = priceOpen;
         m_ticket = ticket;    
         
         #ifdef __MQL5__
         m_trade.SetDeviationInPoints(m_slippage);
         #endif     
      }         
      
      #ifdef __MQL5__
      bool Modify()
      {  
         bool result = false;
         if(PositionSelectByTicket((ulong)m_ticket))
         { 
            m_digits = (int)SymbolInfoInteger(PositionGetString(POSITION_SYMBOL), SYMBOL_DIGITS);
            m_errorCode = 0;      
            result = m_trade.PositionModify
            (
               (ulong)m_ticket, NormalizeDouble(m_newStopLoss, m_digits), NormalizeDouble(m_newTakeProfit, m_digits)
            );
            
            if(!result)
            {
               m_errorCode = m_trade.CheckResultRetcode();
            }
         }
         else
         {
            if(OrderSelect((ulong)m_ticket))
            {
               if(m_priceOpen == 0)
               {
                  m_priceOpen = OrderGetDouble(ORDER_PRICE_OPEN);
               }
               result = m_trade.OrderModify((ulong)m_ticket, m_priceOpen, m_newStopLoss, m_newTakeProfit, (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME), OrderGetInteger(ORDER_TIME_EXPIRATION), OrderGetDouble(ORDER_PRICE_STOPLIMIT));
            }
         }
         
         return result;
      }
      #endif
      
      #ifdef __MQL4__
      bool Modify()
      {
         if(!InitByTicket())
         {
            return false;
         }
         
         if
         (
            NormalizeDouble(m_stopLoss, m_digits) == NormalizeDouble(m_newStopLoss, m_digits)
            && NormalizeDouble(m_takeProfit, m_digits) == NormalizeDouble(m_newTakeProfit, m_digits)
         )
         {
            return false;
         }
         
         m_errorCode=0;
         
         for(int i=0; i<5; i++)
         {
            ResetLastError();
            RefreshRates();
            
            if(IsTradeContextBusy())
            {
               Sleep(10);
               i--;
               continue;
            }
            
            TradeContext::CaptureTradeContext();
            
            if(OrderModify(m_ticket, m_priceOpen, m_newStopLoss, m_newTakeProfit, m_expiration))
            {
               m_stopLoss = m_newStopLoss;
               m_takeProfit = m_newTakeProfit;
               
               TradeContext::ReleaseTradeContext();
               
               return true;
            }
            
            m_errorCode=GetLastError();
            TradeContext::ReleaseTradeContext();
            
            Sleep(200*i);
         }
         
         if(m_errorCode!=0)
         {
            MarketError marketError(m_errorCode);
            
            Print
            (
               "Error in ", __FILE__, " ", __FUNCSIG__, " line #", __LINE__,  ": ", (string)m_errorCode," (",marketError.ToString() ,");",
               " stop loss = ", DoubleToString(m_newStopLoss, m_digits), ", take profit = ", DoubleToString(m_newTakeProfit, m_digits)
            );
         }
         
         return false;
      }
      #endif 
      
      uint ErrorCode() const { return m_errorCode; }  
      
   private:
      #ifdef __MQL4__
      bool InitByTicket()
      {
         if(OrderSelect((int)m_ticket, SELECT_BY_TICKET))
         {               
            if(m_priceOpen == 0)
            {                
               m_priceOpen = OrderOpenPrice();
            }
            m_takeProfit = OrderTakeProfit();
            m_stopLoss = OrderStopLoss();
            m_digits = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
            m_expiration = OrderExpiration();
            
            return true;
         }
         else
         {
            Print("Error in ", __FILE__, " ", __FUNCSIG__, " line #", __LINE__,  ": cannot select order with ticket #", m_ticket);
            return false;
         }
      }
      #endif 
};