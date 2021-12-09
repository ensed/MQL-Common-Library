#property strict

#include "ValueCalculator.mqh"

template <typename T>
class FixedValueCalculator: public ValueCalculator<T>
{
   private:
      T m_value;
      
   public:
      FixedValueCalculator(const T value)
      {
         m_value = value;
      }
      
      virtual T Calculate() override
      {
         return m_value;
      }    
      
      virtual ValueCalculator<T>* GetCopy() override
      {
         return new FixedValueCalculator(m_value);
      }
};