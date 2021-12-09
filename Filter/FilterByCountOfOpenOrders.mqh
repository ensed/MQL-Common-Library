#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "Filter.mqh"
#include "..\Orders Getter\OrdersGetterByInstrument.mqh"
#include "..\Orders Getter\OrdersGetterByType.mqh"
#include "..\Orders Getter\OrdersGetterByMagic.mqh"
#include "..\Orders Getter\OrdersGetterByMagicsList.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Models\CommonOrderType.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\Orders Source\OpenOrders.mqh"

class FilterByCountOfOpenOrders : public Filter
{
   protected:
      int m_maxOpenOrders;
      string m_instrument;      
      
      OrdersGetter* m_ordersGetter;
      
      // speed optimization for the backtester
      #ifdef __MQL5__ 
      string m_prevMask;
      bool m_prevResult;
      #endif 
            
   public:
      FilterByCountOfOpenOrders
      (
         const string instrument, const int maxOpenOrders, const int magic, const EnumOrderType type
      )
      {
         m_maxOpenOrders = maxOpenOrders;

         m_ordersGetter = new OrdersGetterByMagic
         (
            magic, new OrdersGetterByType(type, new OrdersGetterByInstrument(instrument, OpenOrders::Instance()))
         );
      }
      
      FilterByCountOfOpenOrders
      (
         const string instrument, const int maxOpenOrders, const int magic1, const int magic2, const EnumOrderType type
      )
      {       
         m_maxOpenOrders = maxOpenOrders;
         
         m_ordersGetter = new OrdersGetterByInstrument
         (
            instrument, new OrdersGetterByMagicsList(magic1, magic2, new OrdersGetterByType(type, OpenOrders::Instance()))
         );
      }
      
      FilterByCountOfOpenOrders
      (
         const string instrument, const int maxOpenOrders, const int &magics[], const EnumOrderType type
      )
      {      
         m_maxOpenOrders = maxOpenOrders;
         
         m_ordersGetter = new OrdersGetterByInstrument
         (
            instrument, new OrdersGetterByMagicsList(magics, new OrdersGetterByType(type, OpenOrders::Instance()))
         );
      }
      
      FilterByCountOfOpenOrders(const int maxOpenOrders, OrdersGetter* ordersGetter)
      {
         m_maxOpenOrders = maxOpenOrders;

         m_ordersGetter = ordersGetter.GetCopy();
      }
      
      ~FilterByCountOfOpenOrders()
      {
         PointersReleaser::Release(m_ordersGetter);
      }
      
      string Instrument() const { return m_instrument; }
      
      bool IsValid() override
      {
         // speed optimization for the backtester
         #ifdef __MQL5__               
         if(MQLInfoInteger(MQL_TESTER))
         {
            string mask = "";
            
            for(int j = 0; j < PositionsTotal(); j++)
            {
               mask += "|t"+(string)PositionGetTicket(j);
            }  
            
            for(int j = 0; j < OrdersTotal(); j++)
            {
               mask += "|o"+(string)OrderGetTicket(j);
            }
            
            if(m_prevMask == mask)
            {
               return m_prevResult;
            }
            
            m_prevMask = mask;
         }
         #endif 
         
         m_ordersGetter.Update();
         if(m_ordersGetter.Count() > 0)
         {
            m_instrument = m_ordersGetter[0].Symbol;
         }
         
         bool result = m_ordersGetter.Count() >= m_maxOpenOrders;
         
         // speed optimization for the backtester
         #ifdef __MQL5__    
         m_prevResult = result;
         #endif
         
         return result;
      }  
      
      virtual Filter* GetCopy() override final
      {
         return new FilterByCountOfOpenOrders
         (
   			m_maxOpenOrders,
   			m_ordersGetter
         );
      } 
      
      virtual string TypeName() const override final { return typename(this); }
};