#property strict

#include "Filter.mqh"
#include "..\Trading Controllers\OrderGetter.mqh"
#include "..\Helpers\ArraysHelper.mqh"

class FilterByBarsShiftFromLastClosedOrder : public Filter
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      int m_magics[];
      int m_shift;
      
   public:
      FilterByBarsShiftFromLastClosedOrder
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int magic, const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArraysHelper::AddToArray(magic, m_magics);
         m_shift = shift;
      }

      FilterByBarsShiftFromLastClosedOrder
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, 
         const int magic1, const int magic2, 
         const int shift
      )
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic1, m_magics);
         ArraysHelper::AddToArray(magic2, m_magics);
         m_shift = shift;
      }
      
      FilterByBarsShiftFromLastClosedOrder
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int &magics[], const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         for(int i = 0; i < ArraySize(magics); i++)
         {
            ArraysHelper::AddToArray(magics[i], m_magics);
         }
         m_shift = shift;
      }
      
      bool IsValid() override
      {
         if(m_shift == 0)
         {
            return false;
         }
         
         int lastClosedOrderShift = GetLastClosedOrderShift();
         
         if(lastClosedOrderShift == -1)
         {
            return false;
         }
         
         return lastClosedOrderShift < m_shift;
      }
      
      virtual Filter* GetCopy() override final
      {
         return new FilterByBarsShiftFromLastClosedOrder
         (
            m_instrument,
            m_timeframe,
            m_magics,
            m_shift
         );
      }
      
      virtual string TypeName() const override final { return typename(this); }
      
   private:
      #ifdef __MQL5__
      int GetLastClosedOrderShift()
      {
         HistorySelect(0, TimeCurrent()+1);
         for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
         {
            ulong ticket = HistoryDealGetTicket(i);
            
            if(!HistoryDealSelect(ticket))
            {
               continue;
            }
            
            if(HistoryDealGetString(ticket, DEAL_SYMBOL) != m_instrument)
            {
               continue;
            }
            
            ulong positionId = HistoryDealGetInteger(ticket, DEAL_POSITION_ID);           
            
            if(HistoryDealGetInteger(ticket, DEAL_ENTRY) != DEAL_ENTRY_OUT)
            {
               continue;
            }
            
            int magic = (int)HistoryDealGetInteger(positionId, DEAL_MAGIC);
            
            if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
            {
               continue;
            }
            
            return iBarShift(m_instrument, m_timeframe, HistoryDealGetInteger(ticket, DEAL_TIME));
         }
         
         return -1;
      }     
      #endif 
   
      #ifdef __MQL4__
      int GetLastClosedOrderShift()
      {
         for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            {
               continue;
            }
            
            if(OrderSymbol() != m_instrument)
            {
               continue;
            }
            
            int magic = OrderMagicNumber();
            
            if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
            {
               continue;
            }

            return iBarShift(m_instrument, Period(), OrderCloseTime());
         }
         
         return -1;
      }
      #endif 
};