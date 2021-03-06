#property strict

#include "ModifiableValueCalculator.mqh"

class TakeProfitCalculatorByRatioFromStopLoss: public ModifiableValueCalculator
{
   private:
      double m_takeProfitRatio;
      ModifiableValueCalculator* m_stopLossCalculator;

   public:
		TakeProfitCalculatorByRatioFromStopLoss
		(
		   const string instrument, const double pipValue,
		   const double takeProfitRatio,
			ModifiableValueCalculator* stopLossCalculator
		)
		:
		   ModifiableValueCalculator(instrument, pipValue),
		   m_takeProfitRatio(takeProfitRatio),
			m_stopLossCalculator(stopLossCalculator)
		{
		}
		
		~TakeProfitCalculatorByRatioFromStopLoss()
		{
		   delete m_stopLossCalculator;
		}
		
      virtual double Calculate(const EnumOrderType type, const double openPrice) override
      {
         double stopLoss = GetStopLossPrice(type, openPrice);
                           
         if(type == OrderType_Buy || type == OrderType_BuyStop || type == OrderType_BuyLimit)
         {
            return openPrice + (openPrice - stopLoss) * m_takeProfitRatio;
         }
         else if(type == OrderType_Sell || type == OrderType_SellStop || type == OrderType_SellLimit)
         {
            return openPrice - (stopLoss - openPrice) * m_takeProfitRatio;
         }
         else
         {
            UnexpectedEnumItemException(type);
            ExpertRemove();
         }
         
         return 0.0;
      }

   private:
      double GetStopLossPrice(const EnumOrderType type, const double openPrice)
      {
         return m_stopLossCalculator.Calculate(type, openPrice);
      }
};