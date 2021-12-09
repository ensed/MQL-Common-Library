#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByTimeOpen : public OrdersGetter
{     
   private:
      datetime m_timeOpen;
      
   public:      
      OrdersGetterByTimeOpen(const datetime timeOpen, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_timeOpen = timeOpen;
      }
      
      OrdersGetterByTimeOpen(const datetime timeOpen, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_timeOpen = timeOpen;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return order.TimeOpen() == m_timeOpen;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
};