#property strict

#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class AccountMarginFreeCalculatorPercentsOfCurrent: public DoubleValueCalculator
{
   private:
      const double m_percents;

   public:
      AccountMarginFreeCalculatorPercentsOfCurrent(const double percents)
      :
         m_percents(percents)
      {
      }

      virtual double Calculate() 
      {
         return (AccountInfoDouble(ACCOUNT_MARGIN_FREE)/100.0) * m_percents;
      }

      virtual DoubleValueCalculator* GetCopy()
      {
         return new AccountMarginFreeCalculatorPercentsOfCurrent(m_percents);
      }
};