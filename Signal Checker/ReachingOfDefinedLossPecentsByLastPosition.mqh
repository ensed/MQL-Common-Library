#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\MA\MA.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"
#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class ReachingOfDefinedLossPecentsByLastPosition : public SignalChecker
{
   private:
      string m_instrument;
      int m_magic;
      int m_orderType;
      double m_definedLossPercents;
      
      double m_currentProfit;
      int m_positionsCount;
      
      DoubleValueCalculator* m_accountBalanceCalculator;
      
   public:
      ReachingOfDefinedLossPecentsByLastPosition
      (
         const string instrument,
         const int magic,
         const int orderType,
         const double definedLossPercents,
         DoubleValueCalculator* accountBalanceCalculator
      )
      :
         m_accountBalanceCalculator(accountBalanceCalculator)
      {
         m_instrument = instrument;
         m_magic = magic;
         m_orderType = orderType;
         m_definedLossPercents = definedLossPercents;
      }      
      
      virtual bool Exists() override
      {  
         UpdatePositionsInfo();                
         double onePecent = m_accountBalanceCalculator.Calculate() / 100.0;         
         if(m_positionsCount == 0)
         {
            return false;
         }
         return (-1 * m_currentProfit) / onePecent >= m_definedLossPercents * m_positionsCount;
      }
      
   private:
      void UpdatePositionsInfo()
      {      
         m_currentProfit = 0;
         m_positionsCount = 0;
            
         double priceOfLastPosition = 0.0;
         for(int i = 0; i < PositionsTotal(); i++)
         {
            ulong ticket = PositionGetTicket(i);
            
            if(!PositionSelectByTicket(ticket))
            {
               continue;
            }
            
            if(PositionGetString(POSITION_SYMBOL) != m_instrument)
            {
               continue;
            }
            
            if(PositionGetInteger(POSITION_MAGIC) != m_magic)
            {
               continue;
            }
            
            if(PositionGetInteger(POSITION_TYPE) != m_orderType)
            {
               continue;
            }
            
            m_positionsCount++;
            
            if(m_orderType == POSITION_TYPE_BUY)
            {
               if(priceOfLastPosition == 0.0 || priceOfLastPosition > PositionGetDouble(POSITION_PRICE_OPEN))
               {  
                  priceOfLastPosition = PositionGetDouble(POSITION_PRICE_OPEN);
                  
                  m_currentProfit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
               }
            }
            
            if(m_orderType == POSITION_TYPE_SELL)
            {
               if(priceOfLastPosition == 0.0 || priceOfLastPosition < PositionGetDouble(POSITION_PRICE_OPEN))
               {  
                  priceOfLastPosition = PositionGetDouble(POSITION_PRICE_OPEN);
                  
                  m_currentProfit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
               }
            }
         }        
      }
};