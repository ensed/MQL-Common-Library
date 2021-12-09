#property strict

#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class AccountEquityCalculatorPercentsOfCurrent: public DoubleValueCalculator
{
   private:
      const double m_percents;

   public:
      AccountEquityCalculatorPercentsOfCurrent(const double percents)
      :
         m_percents(percents)
      {
      }

      virtual double Calculate() 
      {
         return (AccountInfoDouble(ACCOUNT_EQUITY)/100.0) * m_percents;
      }

      virtual DoubleValueCalculator* GetCopy()
      {
         return new AccountEquityCalculatorPercentsOfCurrent(m_percents);
      }
};