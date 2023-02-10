#property strict

#include "ModifiableValueCalculator.mqh"

class ModifiableValueCalculatorWithPredefinedValue: public ModifiableValueCalculator
{       
   private:
      const double m_value;
       
   public:
      ModifiableValueCalculatorWithPredefinedValue(const double value)
      : ModifiableValueCalculator(""),
        m_value(value)
      {
      }     

      
      virtual double Calculate(const EnumOrderType type, const double openPrice) override
      {
         return m_value;
      }
};