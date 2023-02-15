#property strict

#include <Common Library\Comparers\DoublesComparer.mqh>

class IndicatorAPIBase
{
   public:
      virtual double GetValue(const int shift) = 0;
      
      double operator [](const int shift)
      {
         return GetValue(shift);
      }
      
      bool IsValueEmptyOrZero(const int shift, const int digits = 8)
      {
         const double value = this[shift];
         
         DoublesComparer comparerToZero(value, 0.0, digits);
         DoublesComparer comparerToEmptyValue(value, EMPTY_VALUE, digits);

         return comparerToZero.Equals() || comparerToEmptyValue.Equals();
      }
};