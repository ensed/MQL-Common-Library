#property strict

#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class AccountBalanceCalculatorPercentsOfCurrent: public DoubleValueCalculator
{
   private:
      const double m_percents;

   public:
      AccountBalanceCalculatorPercentsOfCurrent(const double percents)
      :
         m_percents(percents)
      {
      }

      virtual double Calculate() 
      {
         return (AccountInfoDouble(ACCOUNT_BALANCE)/100.0) * m_percents;
      }

      virtual DoubleValueCalculator* GetCopy()
      {
         return new AccountBalanceCalculatorPercentsOfCurrent(m_percents);
      }
};