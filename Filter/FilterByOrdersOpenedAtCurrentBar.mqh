#property strict

#include "Filter.mqh"
#include "..\Trading Controllers\OrderGetter.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Models\CommonOrderType.mqh"

class FilterByOrdersOpenedAtCurrentBar : public Filter
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      int m_magics[];
      CommonOrderType m_type;
      
   public:
      FilterByOrdersOpenedAtCurrentBar
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int magic, const EnumOrderType type
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArraysHelper::AddToArray(magic, m_magics);
         m_type = type;
      }
      
      FilterByOrdersOpenedAtCurrentBar
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int magic1, const int magic2, const EnumOrderType type
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArraysHelper::AddToArray(magic1, m_magics);
         ArraysHelper::AddToArray(magic2, m_magics);
         m_type = type;
      }
      
      FilterByOrdersOpenedAtCurrentBar
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int &magics[], const EnumOrderType type
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         for(int i = 0; i < ArraySize(magics); i++)
         {
            ArraysHelper::AddToArray(magics[i], m_magics);
         }
         m_type = type;
      }
      
      #ifdef __MQL5__
      bool IsValid() override
      {
         for(int i = 0; i < PositionsTotal(); i++)
         {
            ulong ticket = PositionGetTicket(i);
            if(PositionSelectByTicket(ticket))
            {
               if(IsSelectedPositionOpenedAtCurrentBar())
               {
                  return true;
               }
            }                     
         }
         
         HistorySelect(0, TimeCurrent()+1);
         for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
         {
            ulong ticket = HistoryDealGetTicket(i);
            if(HistoryDealSelect(ticket))
            {
               if(IsSelectedHistoryDealValid(ticket))
               {
                  if(SelectedHistoryDealOpenedBar(ticket) == 0)
                  {
                     return true;
                  }
                  else
                  {
                     return false;
                  }
               }
            }                     
         }
         
         return false;
      }
      #endif
      
      #ifdef __MQL4__
      bool IsValid() override
      {
         for(int i = 0; i < OrdersTotal(); i++)
         {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               if(IsSelectedOrderOpenedAtCurrentBar())
               {
                  return true;
               }
            }                     
         }
         
         for(int i = 0; i < OrdersHistoryTotal(); i++)
         {
            if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            {
               if(IsSelectedOrderOpenedAtCurrentBar())
               {
                  return true;
               }
            }                     
         }
         
         return false;
      }
      #endif
     
      virtual Filter* GetCopy() override final
      {
         return new FilterByOrdersOpenedAtCurrentBar
         (
            m_instrument,
            m_timeframe,
            m_magics,
            m_type.Get()
         );
      }
      
      virtual string TypeName() override final { return typename(this); }
      
   protected:
      #ifdef __MQL5__
      bool IsSelectedPositionOpenedAtCurrentBar()
      {
         if(m_type != OrderType_None && PositionGetInteger(POSITION_TYPE) != m_type.ToPositionType())
         {
            return false;
         }
         
         if(PositionGetString(POSITION_SYMBOL) != m_instrument)
         {
            return false;
         }
         
         int magic = (int)PositionGetInteger(POSITION_MAGIC);
                           
         if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
         {
            return false;
         }
         
         return iBarShift(m_instrument, m_timeframe, PositionGetInteger(POSITION_TIME)) == 0;
      }
      
      bool IsSelectedHistoryDealValid(ulong ticket)
      {
         if(HistoryDealGetInteger(ticket, DEAL_ENTRY) != DEAL_ENTRY_IN)
         {
            return false;
         }
         
         if(m_type != OrderType_None)
         {
            if(m_type == POSITION_TYPE_BUY && HistoryDealGetInteger(ticket, DEAL_TYPE) != DEAL_TYPE_BUY)
            {
               return false;
            }            
            else if(m_type == POSITION_TYPE_SELL && HistoryDealGetInteger(ticket, DEAL_TYPE) != DEAL_TYPE_SELL)
            {
               return false;
            }
         }
         
         if(HistoryDealGetString(ticket, DEAL_SYMBOL) != m_instrument)
         {
            return false;
         }
         
         ulong positionId = HistoryDealGetInteger(ticket, DEAL_POSITION_ID);
 
         int magic = (int)HistoryDealGetInteger(positionId, DEAL_MAGIC);
                           
         if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
         {
            return false;
         }
         
         return true;
      }
      
      int SelectedHistoryDealOpenedBar(ulong ticket)
      {         
         return iBarShift(m_instrument, m_timeframe, HistoryDealGetInteger(ticket, DEAL_TIME));
      }
      #endif
   
      #ifdef __MQL4__
      bool IsSelectedOrderOpenedAtCurrentBar()
      {
         if(m_type != OrderType_None && OrderType() != m_type.ToPlatformType())
         {
            return false;
         }
         
         if(OrderSymbol() != m_instrument)
         {
            return false;
         }
         
         int magic = (int)OrderMagicNumber();
                           
         if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
         {
            return false;
         }
         
         return iBarShift(m_instrument, m_timeframe, OrderOpenTime()) == 0;
      }
      #endif 
};