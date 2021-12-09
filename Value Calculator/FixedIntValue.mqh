#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "IntValueCalculator.mqh"

class FixedIntValue: public IntValueCalculator
{
   private:
      int m_value;
      
   public:
		FixedIntValue
		(
			const int value
		)
		:
			m_value(value)
		{
		}
		
      virtual int Calculate() override
      {
         return m_value;
      }
      
      virtual IntValueCalculator* GetCopy() override
      {
         return new FixedIntValue(m_value);
      }
};