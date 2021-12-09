#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\Indicators API\MA\MA.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"
#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class ReachingOfDefinedLossOnWholeAccount : public SignalChecker
{
   private:
      double m_definedLossPercents;
      
      double m_currentProfit;
      
      DoubleValueCalculator* m_accountBalanceCalculator;
      
   public:
      ReachingOfDefinedLossOnWholeAccount
      (
         const double definedLossPercents, DoubleValueCalculator* accountBalanceCalculator
      )
      :
         m_accountBalanceCalculator(accountBalanceCalculator)
      {
         m_definedLossPercents = definedLossPercents;
      }      
      
      virtual bool Exists() override
      {  
         if(AccountInfoDouble(ACCOUNT_BALANCE) < AccountInfoDouble(ACCOUNT_EQUITY))
         {
            return false;
         }
         UpdatePositionsInfo();     

         return -1 * ( m_currentProfit  / (m_accountBalanceCalculator.Calculate() / 100.0)) >= m_definedLossPercents;
      }
      
   private:
      void UpdatePositionsInfo()
      {      
         m_currentProfit = 0;
            
         for(int i = 0; i < PositionsTotal(); i++)
         {
            ulong ticket = PositionGetTicket(i);
            
            if(!PositionSelectByTicket(ticket))
            {
               continue;
            }
            
            
            m_currentProfit += (PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) + PositionGetDouble(POSITION_COMMISSION)*2.0);
         }         
      }
};