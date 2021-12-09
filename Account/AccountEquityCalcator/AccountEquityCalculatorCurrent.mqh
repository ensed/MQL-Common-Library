#property strict

#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class AccountEquityCalculatorCurrent: public DoubleValueCalculator
{
   public:
      virtual double Calculate() 
      {
         return AccountInfoDouble(ACCOUNT_EQUITY);
      }

      virtual DoubleValueCalculator* GetCopy()
      {
         return new AccountEquityCalculatorCurrent();
      }
};