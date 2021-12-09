#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByCommentPart : public OrdersGetter
{     
   private:
      string m_commentPart;
      
   public:      
      OrdersGetterByCommentPart(const string commentPart, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_commentPart = commentPart;
      }
      
      OrdersGetterByCommentPart(const string commentPart, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_commentPart = commentPart;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return StringFind(order.Comment, m_commentPart) != -1;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByCommentPart(m_commentPart, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByCommentPart(m_commentPart, GetOrdersGetter().GetCopy());
         }
      } 
};