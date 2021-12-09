#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\MA\MA.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"


class ReachingOfDefinedProfit : public SignalChecker
{
   private:
      string m_instrument;
      int m_magic;
      int m_orderType;
      double m_definedProfit;
      
      double m_currentProfit;
      
   public:
      ReachingOfDefinedProfit
      (
         const string instrument,
         const int magic,
         const int orderType,
         const double definedProfit
      )
      {
         m_instrument = instrument;
         m_magic = magic;
         m_orderType = orderType;
         m_definedProfit = definedProfit;
      }      
      
      virtual bool Exists() override
      {  
         UpdatePositionsInfo();       
         
         return m_currentProfit >= m_definedProfit;
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
            
            m_currentProfit += (PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP));
         }         
      }
};