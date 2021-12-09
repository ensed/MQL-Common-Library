#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByMinimalIndexInSeries : public OrdersGetter
{     
   private:
      int m_minimalIndex;
      long m_sortedTickets[];
      OrderInfo m_candidateOrders[];
      
   public:      
      OrdersGetterByMinimalIndexInSeries(const int minimalIndex, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_minimalIndex = minimalIndex;
      }
      
      OrdersGetterByMinimalIndexInSeries(const int minimalIndex, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_minimalIndex = minimalIndex;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {         
         GetOrdersByOtherGetters();
         SortByTickets();
         
         int orderIndexInSeries = GetOrderIndexInSeries(order);         
         if(orderIndexInSeries == -1)
         {
            return false;
         }
         else
         {
            return orderIndexInSeries >= m_minimalIndex;
         }
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByMinimalIndexInSeries(m_minimalIndex, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByMinimalIndexInSeries(m_minimalIndex, GetOrdersGetter().GetCopy());
         }
      }
      
   private:
      void GetOrdersByOtherGetters()
      {
         ArrayFree(m_candidateOrders);

         m_ordersSource.Update();
         OrderInfo orders[];
         m_ordersSource.Get(orders);
         
         for(int i = 0; i < ArraySize(orders); i++)
         {
            bool isOrderApproachable = true;
            
            OrdersGetter* getter = GetOrdersGetter();
            while(CheckPointer(getter) != POINTER_INVALID)
            {
               if(!getter.IsOrderApproachable(orders[i]))
               {
                  isOrderApproachable = false;
                  break;
               }
                                
               getter = getter.GetOrdersGetter();
            }

            if(isOrderApproachable)
            {               
               ArraysHelper::AddToArray(orders[i], m_candidateOrders);
            }
         }
      }
      
      int GetOrderIndexInSeries(const OrderInfo &order)
      {
         for(int i = 0; i < ArraySize(m_sortedTickets); i++)
         {
            if(m_sortedTickets[i] == order.Ticket)
            {
               return i;
            }
         }
         
         return -1;
      }
      
      void SortByTickets()
      {
         ArrayFree(m_sortedTickets);
         
         long lowestTicket = GetFirstLowestTicket();                         
         
         while(true)
         {
            if(lowestTicket == -1)
            {
               break;
            }
            
            ArraysHelper::AddToArray(lowestTicket, m_sortedTickets);
            
            lowestTicket = GetNextLowestTicket(lowestTicket);
         }
      }
      
      long GetFirstLowestTicket()
      {
         long result = -1;
         
         for(int i = 0; i < ArraySize(m_candidateOrders); i++)
         {
            if(m_candidateOrders[i].Ticket < result || result == -1)
            {
               result = m_candidateOrders[i].Ticket;
            }    
         }
         
         return result;
      }
      
      long GetNextLowestTicket(const long previousTicket)
      {
         long result = -1;
         
         for(int i = 0; i < ArraySize(m_candidateOrders); i++)
         {
            if(previousTicket == -1 || m_candidateOrders[i].Ticket > previousTicket)
            {
               if(m_candidateOrders[i].Ticket < result || result == -1)
               {
                  result = m_candidateOrders[i].Ticket;
               }    
            }
         }
         
         return result;
      }
};