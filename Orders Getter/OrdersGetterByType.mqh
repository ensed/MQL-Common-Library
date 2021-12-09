#property strict

#include "OrdersGetter.mqh"
#include "..\Models\CommonOrderType.mqh"

class OrdersGetterByType : public OrdersGetter
{     
   private:
      EnumOrderType m_type;
      
   public:      
      OrdersGetterByType(const EnumOrderType type, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_type = type;
      }
      
      OrdersGetterByType(const EnumOrderType type, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_type = type;
      }
      
      OrdersGetterByType(const CommonOrderType &type, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_type = type.Get();
      }
      
      OrdersGetterByType(const CommonOrderType &type, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_type = type.Get();
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return order.Type == m_type || m_type == OrderType_None;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByType(m_type, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByType(m_type, GetOrdersGetter().GetCopy());
         }
      } 
};