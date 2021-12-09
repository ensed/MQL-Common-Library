#property strict

#include "Filter.mqh"
#include "..\Trading Controllers\OrderGetter.mqh"
#include "..\Helpers\ArraysHelper.mqh"

class FilterByBarsShiftFromLastOpenOrder : public Filter
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      int m_magics[];
      int m_shift;
      
   public:
      FilterByBarsShiftFromLastOpenOrder
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int magic, const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArraysHelper::AddToArray(magic, m_magics);
         m_shift = shift;
      }

      FilterByBarsShiftFromLastOpenOrder
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
      
      FilterByBarsShiftFromLastOpenOrder
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
         
         int lastOpenOrderShift = GetLastOpenOrderShift();
         if(lastOpenOrderShift == -1)
         {
            return false;
         }

         return lastOpenOrderShift < m_shift;
      }
      
      virtual Filter* GetCopy() override final
      {
         return new FilterByBarsShiftFromLastOpenOrder
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
      int GetLastOpenOrderShift()
      {
         for(int i = PositionsTotal() - 1; i >= 0; i--)
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
            
            int magic = (int)PositionGetInteger(POSITION_MAGIC);
            
            if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
            {
               continue;
            }
            
            return iBarShift(m_instrument, m_timeframe, PositionGetInteger(POSITION_TIME));
         }
         
         return -1;
      }     
      #endif 
   
      #ifdef __MQL4__
      int GetLastOpenOrderShift()
      {
         for(int i = OrdersTotal() - 1; i >= 0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
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

            return iBarShift(m_instrument, Period(), OrderOpenTime());
         }
         
         return -1;
      }
      #endif 
};