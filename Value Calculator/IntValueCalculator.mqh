#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class IntValueCalculator
{
   public:
      virtual int Calculate() = 0;
      virtual IntValueCalculator* GetCopy() = 0;
};