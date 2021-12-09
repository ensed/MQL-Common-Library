#property strict

class IndicatorAPIBase
{
   public:
      virtual double GetValue(const int shift) = 0;
      
      double operator [](const int shift)
      {
         return GetValue(shift);
      }
};