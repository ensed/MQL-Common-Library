#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "DoubleValueCalculator.mqh"

class FixedDoubleValue: public DoubleValueCalculator
{
   private:
      double m_value;
      
   public:
		FixedDoubleValue
		(
			const double value
		)
		:
			m_value(value)
		{
		}
		
      virtual double Calculate() override
      {
         return m_value;
      }
      
		virtual DoubleValueCalculator* GetCopy() override
		{
		   return new FixedDoubleValue(m_value);
		}
};