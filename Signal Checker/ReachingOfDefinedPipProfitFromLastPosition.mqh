#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\MA\MA.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"


class ReachingOfDefinedPipProfitFromLastPosition : public SignalChecker
{
   private:
      string m_instrument;
      int m_magic;
      int m_orderType;
      int m_definedProfitPips;
      
      int m_currentProfitPips;
      
      double m_pip;
      
   public:
      ReachingOfDefinedPipProfitFromLastPosition
      (
         const string instrument,
         const int magic,
         const int orderType,
         const int definedProfitPips
      )
      {
         m_instrument = instrument;
         m_magic = magic;
         m_orderType = orderType;
         m_definedProfitPips = definedProfitPips;
         
         long digits = SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
         m_pip = SymbolInfoDouble(m_instrument, SYMBOL_POINT) * ((digits == 3 || digits == 5) ? 10.0 : 1.0);
      }      
      
      virtual bool Exists() override
      {  
         UpdatePositionsInfo();                
         return m_currentProfitPips >= m_definedProfitPips;
      }
      
   private:
      void UpdatePositionsInfo()
      {      
         m_currentProfitPips = 0;
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
            
            if(m_orderType == POSITION_TYPE_BUY)
            {
               if(priceOfLastPosition == 0.0 || priceOfLastPosition < PositionGetDouble(POSITION_PRICE_OPEN))
               {  
                  priceOfLastPosition = PositionGetDouble(POSITION_PRICE_OPEN);
                  
                  m_currentProfitPips = (int)((PositionGetDouble(POSITION_PRICE_CURRENT) - PositionGetDouble(POSITION_PRICE_OPEN)) / m_pip);
               }
            }
            
            if(m_orderType == POSITION_TYPE_SELL)
            {
               if(priceOfLastPosition == 0.0 || priceOfLastPosition > PositionGetDouble(POSITION_PRICE_OPEN))
               {  
                  priceOfLastPosition = PositionGetDouble(POSITION_PRICE_OPEN);
                  
                  m_currentProfitPips = (int)((PositionGetDouble(POSITION_PRICE_OPEN) - PositionGetDouble(POSITION_PRICE_CURRENT)) / m_pip);
               }
            }
         }         
      }
};