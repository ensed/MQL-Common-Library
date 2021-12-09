#property strict

#include "Filter.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Models\CommonOrderType.mqh"
#include "..\Orders Source\OpenOrders.mqh"
#include "..\Orders Source\ClosedOrders.mqh"
#include <Common Library\Profiler\Profiler.mqh>

#include <Generic\HashMap.mqh>

class FilterByCountOfOpenOrdersAtCurrentBar : public Filter
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      int m_magics[];
      int m_maxOrdersCount;
      CommonOrderType m_type;
      bool m_isTypeNone;
      
      #ifdef __MQL5__
      datetime m_lastPositiveResultsBarTime;
      #endif 

      CHashMap<ulong, datetime>* m_hashedTimeOpen;
      
   public:
      FilterByCountOfOpenOrdersAtCurrentBar
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int magic, const int maxOrdersCount, const EnumOrderType type
      )
      :
         m_hashedTimeOpen(new CHashMap<ulong, datetime>(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER))
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArraysHelper::AddToArray(magic, m_magics ADD_TO_ARRAY_TRACING_CALLER);
         m_maxOrdersCount = maxOrdersCount;
         m_type = type;
         
         m_isTypeNone = (m_type == OrderType_None);
      }
      
      FilterByCountOfOpenOrdersAtCurrentBar
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int magic1, const int magic2, const int maxOrdersCount, const EnumOrderType type
      )
      :
         m_hashedTimeOpen(new CHashMap<ulong, datetime>(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER))
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArraysHelper::AddToArray(magic1, m_magics ADD_TO_ARRAY_TRACING_CALLER);
         ArraysHelper::AddToArray(magic2, m_magics ADD_TO_ARRAY_TRACING_CALLER);
         m_maxOrdersCount = maxOrdersCount;
         m_type = type;
         
         m_isTypeNone = (m_type == OrderType_None);
      }
      
      FilterByCountOfOpenOrdersAtCurrentBar
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, const int &magics[], const int maxOrdersCount, const EnumOrderType type
      )
      :
         m_hashedTimeOpen(new CHashMap<ulong, datetime>(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER))
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         ArrayCopy(m_magics, magics);
         m_maxOrdersCount = maxOrdersCount;
         m_type = type;
         
         m_isTypeNone = (m_type == OrderType_None);
      }
      
      ~FilterByCountOfOpenOrdersAtCurrentBar()
      {
         delete m_hashedTimeOpen;
      }
      
      virtual Filter* GetCopy() override final
      {
         return new FilterByCountOfOpenOrdersAtCurrentBar(m_instrument, m_timeframe, m_magics, m_maxOrdersCount, m_type.Get());
      }
      
      virtual string TypeName() const override final
      {
         return typename(this);
      }
      
      #ifdef __MQL5__
      bool IsValid() override
      {
         const datetime barOpenTime = iTime(m_instrument, m_timeframe, 0);
         
         if(m_lastPositiveResultsBarTime == barOpenTime)
         {
            return true;
         }
         
         int count = 0;
         for(int i = 0; i < PositionsTotal(); i++)
         {
            const ulong ticket = PositionGetTicket(i);
            if(PositionSelectByTicket(ticket))
            {
               if(IsSelectedPositionOpenedAtCurrentBar(barOpenTime))
               {
                  count++;
               }
            }                     
         }
         
         if(count >= m_maxOrdersCount)
         {  
            if(MQLInfoInteger(MQL_TESTER))
            {
               m_lastPositiveResultsBarTime = barOpenTime;
            }
            
            return true;
         }
         
         HistorySelect(barOpenTime, TimeCurrent()+1);
         for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
         {
            const ulong ticket = HistoryDealGetTicket(i);
            if(HistoryDealSelect(ticket))
            {
               if(IsSelectedHistoryDealValid(ticket))
               {
                  const int openBar = SelectedHistoryDealOpenedBar(ticket);
                  if(openBar == 0)
                  {
                     count++;
                  }
                  else if(openBar > 0)
                  {
                     if(MQLInfoInteger(MQL_TESTER))
                     {
                        break;
                     }
                  }
               }
            }                     
         }
         
         bool result = count >= m_maxOrdersCount;
         
         if(result)
         {
            m_lastPositiveResultsBarTime = barOpenTime;
         }
         
         return result;
      }
      #endif
      
      #ifdef __MQL4__
      bool IsValid() override
      {
         int count = 0;
         
         for(int i = 0; i < OrdersTotal(); i++)
         {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               if(IsSelectedOrderOpenedAtCurrentBar())
               {
                  count++;
               }
            }                     
         }
         
         for(int i = 0; i < OrdersHistoryTotal(); i++)
         {
            if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            {
               if(IsSelectedOrderOpenedAtCurrentBar())
               {
                  count++;
               }
            }                     
         }
         
         return count >= m_maxOrdersCount;
      }
      #endif
      
   protected:
      #ifdef __MQL5__
      bool IsSelectedPositionOpenedAtCurrentBar(const datetime barOpenTime)
      {
         if(!m_isTypeNone && PositionGetInteger(POSITION_TYPE) != m_type.ToPositionType())
         {
            return false;
         }
                  
         if(PositionGetString(POSITION_SYMBOL) != m_instrument)
         {
            return false;
         }
         
         const int magic = (int)PositionGetInteger(POSITION_MAGIC);
                           
         if(!ArraysHelper::ItemExistsInArray(magic, m_magics))
         {
            return false;
         }
         
         m_hashedTimeOpen.Add(PositionGetInteger(POSITION_TICKET), (datetime)PositionGetInteger(POSITION_TIME));
         
         if(PositionGetInteger(POSITION_TIME) < barOpenTime)
         {
            return false;
         } 
                 
         return true;
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