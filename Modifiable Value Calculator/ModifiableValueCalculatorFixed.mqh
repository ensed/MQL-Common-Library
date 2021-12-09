#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "ModifiableValueCalculator.mqh"

class ModifiableValueCalculatorFixed : public ModifiableValueCalculator
{       
   protected:
      CommonOrderType m_orderType;
      double m_orderOpenPrice;
      double m_valueInPips;
       
   public:
      ModifiableValueCalculatorFixed
      (
         const double valueInPips, 
         const string instrument
      )
      : ModifiableValueCalculator(instrument)
      {
         m_valueInPips = valueInPips;
      }     
      
      ModifiableValueCalculatorFixed
      (
         const double valueInPips, 
         const double pipValue,
         const string instrument        
      )
      : ModifiableValueCalculator(instrument, pipValue)
      {
         m_valueInPips = valueInPips;
      }  
      
      virtual double Calculate(const EnumOrderType type, const double openPrice) override
      {
         if(IsValueEmpty())
         {
            return 0.0;
         }
         
         m_orderType = type;
         m_orderOpenPrice = openPrice;
                
         #ifdef __MQL4__         
         RefreshRates();
         #endif 
         
         if(m_orderType == OrderType_Buy || m_orderType == OrderType_BuyStop || m_orderType == OrderType_BuyLimit)
         {
            return CalculateForBuy();
         }

         if(m_orderType == OrderType_Sell || m_orderType == OrderType_SellStop || m_orderType == OrderType_SellLimit)
         {
            return CalculateForSell();
         }

         return -1.0;
      }
      
   protected:
      virtual double CalculateForBuy() = 0;      
      virtual double CalculateForSell() = 0;
      
      bool IsValueEmpty()
      {
         return NormalizeDouble(m_valueInPips, 8) == NormalizeDouble(0.0, 8);
      }
};