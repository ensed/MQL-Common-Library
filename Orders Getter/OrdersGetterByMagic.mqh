#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByMagic : public OrdersGetter
{     
   private:
      int m_magic;
      
   public:      
      OrdersGetterByMagic(const int magic, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {         
         m_magic = magic;
      }
      
      OrdersGetterByMagic(const int magic, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_magic = magic;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return order.Magic == m_magic;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByMagic(m_magic, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByMagic(m_magic, GetOrdersGetter().GetCopy());
         }
      } 
};