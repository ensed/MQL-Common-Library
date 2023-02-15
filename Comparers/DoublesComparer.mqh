#property strict

#include "ComparerBase.mqh"

class DoublesComparer: ComparerBase
{
   private:
      const double m_value1;
      const double m_value2;
      const int m_digits;
      
   public:
      DoublesComparer(const double value1, const double value2, const int digits = 8)
      :
         m_value1(value1),
         m_value2(value2),
         m_digits(digits)
      {
      }
      
      virtual bool Equals() override
      {
         return NormalizeDouble(m_value1 - m_value2, m_digits) == 0;
      }
};