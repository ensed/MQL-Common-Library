#property strict

#include "OrdersSource.mqh"
#include <Generic\HashSet.mqh>
class HistoryOrders : public OrdersSource
{
   private:
      static HistoryOrders* m_instance;
      static datetime startSelectionTime;
      
      static CHashSet<ulong> m_ticketsSet;
   public:   
      #ifdef __MQL5__
      virtual void Update() override
      {                  
         if(!MQLInfoInteger(MQL_TESTER))
         {
            ArrayFree(m_orders);
            startSelectionTime = (datetime)0;
            m_count = 0;
         }

         HistorySelect(startSelectionTime, TimeCurrent()+1);         
         
         int index = ArraySize(m_orders);
         
         bool needRecheckForTimeOpen = false;
         for(int i = 0; i < HistoryDealsTotal(); i++)
         {
            ulong ticket = HistoryDealGetTicket(i);
         }
         for(int i = 0; i < HistoryDealsTotal(); i++)
         {
            ulong ticket = HistoryDealGetTicket(i);
            
            if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
            {
               if(HistoryDealGetInteger(ticket, DEAL_TYPE) != DEAL_TYPE_BUY && HistoryDealGetInteger(ticket, DEAL_TYPE) != DEAL_TYPE_SELL)
               {
                  continue;
               }
            }
            else
            {
               if(HistoryDealGetInteger(ticket, DEAL_ENTRY) != DEAL_ENTRY_OUT)
               {
                  continue;
               }
            }            
                              
            if(MQLInfoInteger(MQL_TESTER))
            {            
               if(m_ticketsSet.Contains(ticket))
               {
                  continue;
               }
               
               int ordersCount = ArraySize(m_orders);
               
               if(ordersCount < index + 1)
               {
                  ArrayResize(m_orders, index + 1);    
                  #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
                     m_count = index + 1;
                  #endif               
               }
               else
               {
                  #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
                     m_count = ordersCount;
                  #endif  
               }
               
               if(m_orders[index].TimeOpen == (datetime)0 || m_orders[index].TimeClose == (datetime)0)
               {
                  m_orders[index].InitByHistoryDeal(ticket);
                  if(m_orders[index].TimeClose != (datetime)0)
                  {
                     m_ticketsSet.Add(ticket);
                     startSelectionTime = m_orders[index].TimeClose;
                  }
                  
                  if(m_orders[index].TimeOpen == (datetime)0)
                  {
                     needRecheckForTimeOpen = true;
                  }
               }
               else
               {
                  m_ticketsSet.Add(ticket);
                  break;
               }
               
               index++;
            }
            else
            {
               m_count++;
               OrderInfo order;
               order.InitByHistoryDeal(ticket);               
                  
               ArraysHelper::AddToArray(order, m_orders ADD_TO_ARRAY_TRACING_CALLER);
            }
         }  

         if(MQLInfoInteger(MQL_TESTER))
         {            
            if(needRecheckForTimeOpen)
            {            
               int currentSize = ArraySize(m_orders);
               #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
                  m_count = currentSize;
               #endif 
               for(int i = currentSize - 1; i >=0; i--)
               {
                  if(m_orders[i].TimeOpen != (datetime)0 && m_orders[i].TimeClose != (datetime)0)
                  {  
                     continue;
                  } 
                     
                  int indexForSelection = i;
                  
                  while(indexForSelection >= 0)
                  {
                     indexForSelection--;
                     
                     if(m_orders[i].TimeOpen == (datetime)0 || m_orders[i].TimeClose == (datetime)0)
                     {     
                        datetime startTime = indexForSelection <= 0 ? (datetime)0 : m_orders[indexForSelection].TimeOpen;   
                                                
                        HistorySelect(startTime, TimeCurrent()+1); 
                        
                        m_orders[i].InitByHistoryDeal(m_orders[i].Ticket);
                     } 
                     
                     if(m_orders[i].TimeOpen != (datetime)0 && m_orders[i].TimeClose != (datetime)0)
                     {  
                        break;
                     }                                   
                  }
               }
            }
         }          
      }
      #endif
      
      #ifdef __MQL4__
      virtual void Update() override
      {          
         RefreshRates();
         ArrayFree(m_orders);
         
         for(int i = 0; i < OrdersHistoryTotal(); i++)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            {
               continue;
            }

            OrderInfo order;
            order.InitBySelected();
            
            ArraysHelper::AddToArray(order, m_orders);
         }   
         
         m_count = ArraySize(m_orders);      
      }
      #endif
      
      static HistoryOrders* Instance()
      {
         if(CheckPointer(m_instance) == POINTER_INVALID)
         {
            m_instance = new HistoryOrders();            
         }
         
         return m_instance;
      }
      
      static void ReleaseInstance() 
      {         
         if(CheckPointer(m_instance) != POINTER_INVALID)
         {
            delete m_instance; 
            m_instance = NULL;
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
      HistoryOrders() { }
      ~HistoryOrders() {}
};

HistoryOrders* HistoryOrders::m_instance;
datetime HistoryOrders::startSelectionTime = (datetime)0;
CHashSet<ulong> HistoryOrders::m_ticketsSet;