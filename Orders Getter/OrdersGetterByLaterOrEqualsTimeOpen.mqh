#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByLaterOrEqualsTimeOpen : public OrdersGetter
{     
   private:
      datetime m_timeOpen;
      
   public:      
      OrdersGetterByLaterOrEqualsTimeOpen(const datetime timeOpen, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_timeOpen = timeOpen;
      }
      
      OrdersGetterByLaterOrEqualsTimeOpen(const datetime timeOpen, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_timeOpen = timeOpen;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return order.TimeOpen >= m_timeOpen;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByLaterOrEqualsTimeOpen(m_timeOpen, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByLaterOrEqualsTimeOpen(m_timeOpen, GetOrdersGetter().GetCopy());
         }
      }
};