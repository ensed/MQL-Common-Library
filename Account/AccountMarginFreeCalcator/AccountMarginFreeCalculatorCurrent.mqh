#property strict

#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class AccountMarginFreeCalculatorCurrent: public DoubleValueCalculator
{
   public:
      virtual double Calculate() 
      {
         return AccountInfoDouble(ACCOUNT_MARGIN_FREE);
      }

      virtual DoubleValueCalculator* GetCopy()
      {
         return new AccountMarginFreeCalculatorCurrent();
      }
};