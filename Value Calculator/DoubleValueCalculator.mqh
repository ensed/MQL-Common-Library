#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class DoubleValueCalculator
{
   public:
      virtual double Calculate() = 0;      
      virtual DoubleValueCalculator* GetCopy() = 0;
};