#property strict

#include "Filter.mqh"
#include "..\Trading Controllers\OrderGetter.mqh"

class FilterByMinimalPositiveDistanceToOpenOrder : public Filter
{
   protected:
      string m_instrument;
      int m_magic;
      int m_type;
      long m_minimalDistance;
      
      double m_pip;
      long m_lowestDistanceToExistingPosition;
      long m_positionsCount;
      
   public:
      FilterByMinimalPositiveDistanceToOpenOrder(const string instrument, const int magic, const int type, const long minimalDistance)
      {
         m_instrument = instrument;
         m_magic = magic;
         m_type = type;
         m_minimalDistance = minimalDistance;
         
         long digits = SymbolInfoInteger(instrument, SYMBOL_DIGITS);
         m_pip = SymbolInfoDouble(instrument, SYMBOL_POINT) * ((digits == 3 || digits == 5) ? 10.0 : 1.0);
      }
      
      bool IsValid() override
      {
         UpdatePositionsInfo();
         
         return m_lowestDistanceToExistingPosition <= m_minimalDistance && m_positionsCount != 0;
      }
      
      void UpdatePositionsInfo()
      {
         m_lowestDistanceToExistingPosition = 0;
         m_positionsCount = 0;
         
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
            
            if(PositionGetInteger(POSITION_TYPE) != m_type)
            {
               continue;
            }           
            
            m_positionsCount++;
            
            if(m_type == POSITION_TYPE_SELL)
            {
               long distance = (long)((PositionGetDouble(POSITION_PRICE_OPEN) - PositionGetDouble(POSITION_PRICE_CURRENT)) / m_pip);
               
               if(m_lowestDistanceToExistingPosition == 0 || m_lowestDistanceToExistingPosition > distance)
               {
                  m_lowestDistanceToExistingPosition = distance;
               }
            }
            else if(m_type == POSITION_TYPE_BUY)
            {
               long distance = (long)((PositionGetDouble(POSITION_PRICE_CURRENT) - PositionGetDouble(POSITION_PRICE_OPEN)) / m_pip);
               
               if(m_lowestDistanceToExistingPosition == 0 || m_lowestDistanceToExistingPosition > distance)
               {
                  m_lowestDistanceToExistingPosition = distance;
               }
            }
         }         
      }
};