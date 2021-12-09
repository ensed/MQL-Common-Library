#property strict

#include "Filter.mqh"
#include "..\Trading Controllers\OrderGetter.mqh"
#include "..\Helpers\ArraysHelper.mqh"

class FilterByLastOpenOrderType : public Filter
{
   protected:
      string m_instrument;
      int m_magics[];
      int m_type;
      
   public:
      FilterByLastOpenOrderType(const string instrument, const int magic, const int type)
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic, m_magics);
         m_type = type;
      }

      FilterByLastOpenOrderType(const string instrument, const int magic1, const int magic2, const int type)
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic1, m_magics);
         ArraysHelper::AddToArray(magic2, m_magics);
         m_type = type;
      }
      
      FilterByLastOpenOrderType(const string instrument, const int &magics[], const int type)
      {
         m_instrument = instrument;
         for(int i = 0; i < ArraySize(magics); i++)
         {
            ArraysHelper::AddToArray(magics[i], m_magics);
         }
         m_type = type;
      }
      
      bool IsValid() override
      {
         int lastOpenOrderType = GetLastOpenOrderType();

         if(lastOpenOrderType == -1)
         {
            return false;
         }
         
         return lastOpenOrderType == m_type;
      }
      
      virtual Filter* GetCopy() override final
      {
         return new FilterByLastOpenOrderType
         (
            m_instrument,
            m_magics,
            m_type
         );
      }
      
      virtual string TypeName() const override final { return typename(this); }
      
   private:
      #ifdef __MQL5__
      int GetLastOpenOrderType()
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
            
            return (int)PositionGetInteger(POSITION_TYPE);
         }
         
         return -1;
      }
      #endif 
   
      #ifdef __MQL4__
      int GetLastOpenOrderType()
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
            
            return OrderType();
         }
         
         return -1;
      }
      #endif 
};