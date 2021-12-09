#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByInstrument : public OrdersGetter
{     
   private:
      string m_instrument;
      
   public:      
      OrdersGetterByInstrument(const string instrument, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_instrument = instrument;
      }
      
      OrdersGetterByInstrument(const string instrument, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_instrument = instrument;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return order.Symbol == m_instrument;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByInstrument(m_instrument, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByInstrument(m_instrument, GetOrdersGetter().GetCopy());
         }
      }
};