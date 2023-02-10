#property strict

#include "AbstractPointsValueCalculator.mqh"

class PointsValueCalculatorWithFixedValue: public AbstractPointsValueCalculator
{    
   public:
      PointsValueCalculatorWithFixedValue(const int value)
      {
         m_value = value;
      }

      virtual void Calculate() override
      {
         ;
      }
};