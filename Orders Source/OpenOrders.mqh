#property strict

#include "OrdersSource.mqh"

#ifdef __MQL5__

class OpenOrders : public OrdersSource
{
   private:
      static OpenOrders* m_instance;            
      
   public:
      virtual void Update() override
      {
         int positionsTotal = PositionsTotal();
         int ordersTotal = OrdersTotal();
         
         static bool isTester = MQLInfoInteger(MQL_TESTER);
         
         if(isTester)
         {            
            static string m_prevMask = "---";
            string mask = "";
            
            for(int j = 0; j < positionsTotal; j++)
            {
               mask += "|t"+(string)PositionGetTicket(j);
            }  
            
            for(int j = 0; j < ordersTotal; j++)
            {
               mask += "|o"+(string)OrderGetTicket(j);
            }
            
            if(m_prevMask == mask)
            {
               int index = 0;
               
               for(int j = 0; j < positionsTotal; j++)
               {
                  ulong ticket = PositionGetTicket(j);
                  
                  if(!PositionSelectByTicket(ticket))
                  {
                     index++;
                     continue;
                  }
      
                  m_orders[index].UpdateBySelected(isTester);
                  index++;
               }  
               
               for(int j = 0; j < ordersTotal; j++)
               {
                  ulong ticket = OrderGetTicket(j);
                  
                  if(!OrderSelect(ticket))
                  {
                     index++;
                     continue;
                  }
      
                  m_orders[index].UpdateBySelectedOrder();
                  index++;
               } 
               
               return;
            }
            else
            {
               m_prevMask = mask;
            }
         }
         
         ArrayResize(m_orders, positionsTotal + ordersTotal);
         #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
            m_count = positionsTotal + ordersTotal;
         #endif 
         int index = 0;
         
         for(int j = 0; j < positionsTotal; j++)
         {
            ulong ticket = PositionGetTicket(j);
            
            if(!PositionSelectByTicket(ticket))
            {
               index++;
               continue;
            }

            m_orders[index].InitBySelected();
            index++;
         }  
         
         for(int j = 0; j < ordersTotal; j++)
         {
            ulong ticket = OrderGetTicket(j);
            
            if(!OrderSelect(ticket))
            {
               index++;
               continue;
            }

            m_orders[index].InitBySelectedOrder();
            index++;
         }      
      }  
      
      double GetPriceOpen(const int index)
      {
         return m_orders[index].PriceOpen;
      }         
            
      static OpenOrders* Instance()
      {
         if(CheckPointer(m_instance) == POINTER_INVALID)
         {
            m_instance = new OpenOrders();            
         }
         
         return m_instance;
      }
      
      static void ReleaseInstance() 
      {         
         if(CheckPointer(m_instance) != POINTER_INVALID)
         {
            delete m_instance; 
         }
      };
      
      virtual string TypeName() override final
      {
         return typename(this);
      }
      
      virtual OrdersSource* GetCopy() override final
      {
         return Instance();
      }
   private:      
      OpenOrders() {}
      ~OpenOrders() {}
};
#endif

#ifdef __MQL4__
class OpenOrders : public OrdersSource
{
   private:
      static OpenOrders* m_instance;
      
   public:
      virtual void Update() override
      {         
         RefreshRates();
         ArrayFree(m_orders);
         
         for(int i = 0; i < OrdersTotal(); i++)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               continue;
            }

            OrderInfo order;
            order.InitBySelected();
            
            ArraysHelper::AddToArray(order, m_orders);
         }   
         
         m_count = ArraySize(m_orders);      
      }
      
      static OpenOrders* Instance()
      {
         if(CheckPointer(m_instance) == POINTER_INVALID)
         {
            m_instance = new OpenOrders();            
         }
         
         return m_instance;
      }
      
      static void ReleaseInstance() 
      {         
            delete m_instance; 
            m_instance = NULL;
      };
      
      virtual string TypeName() override final
      {
         return typename(this);
      }
      
      virtual OrdersSource* GetCopy() override final
      {
         return Instance();
      }
   private:      
      OpenOrders() {}
      ~OpenOrders() {}
};
#endif

OpenOrders* OpenOrders::m_instance;