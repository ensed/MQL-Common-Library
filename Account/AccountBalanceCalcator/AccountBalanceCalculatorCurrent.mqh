#property strict

#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class AccountBalanceCalculatorCurrent: public DoubleValueCalculator
{
   public:
      virtual double Calculate() 
      {
         return AccountInfoDouble(ACCOUNT_BALANCE);
      }

      virtual DoubleValueCalculator* GetCopy()
      {
         return new AccountBalanceCalculatorCurrent();
      }
};