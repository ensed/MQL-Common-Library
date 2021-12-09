#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "ModifiableValueCalculatorFixed.mqh"

class TakeProfitCalculatorFixed : public ModifiableValueCalculatorFixed
{         
   protected:
      bool m_isEnabled;
      
   public:
      TakeProfitCalculatorFixed
      (
         const double valueInPips,
         const string instrument
      )
      : ModifiableValueCalculatorFixed(valueInPips, instrument)
      {

      }
      
      TakeProfitCalculatorFixed
      (
         const double valueInPips,
         const double pipValue,
         const string instrument         
      )
      : ModifiableValueCalculatorFixed(valueInPips, pipValue, instrument)
      {

      }
      
   protected:
      virtual double CalculateForBuy() override
      {
         return NormalizeDouble(m_orderOpenPrice + m_valueInPips * m_pipValue, m_digits);
      }
      
      virtual double CalculateForSell() override
      {
         return NormalizeDouble(m_orderOpenPrice - m_valueInPips * m_pipValue, m_digits);
      }
};