#property strict

#include "DoubleValueValidator.mqh"

class PriceOrIndicatorValueValidator : public DoubleValueValidator
{
   public:
      PriceOrIndicatorValueValidator(const double value)
      : DoubleValueValidator(value)
      {
      }
      
      virtual void Update() override
      {
         m_result 
            = NormalizeDouble(m_value, 8) != NormalizeDouble(0.0, 8) 
              && NormalizeDouble(m_value, 8) != NormalizeDouble(EMPTY_VALUE, 8);
      }
};