#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByAbsenceOfCommentPart : public OrdersGetter
{     
   private:
      string m_commentPart;
      
   public:      
      OrdersGetterByAbsenceOfCommentPart(const string commentPart, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         m_commentPart = commentPart;
      }
      
      OrdersGetterByAbsenceOfCommentPart(const string commentPart, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         m_commentPart = commentPart;
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         return StringFind(order.Comment, m_commentPart) == -1;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByAbsenceOfCommentPart(m_commentPart, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByAbsenceOfCommentPart(m_commentPart, GetOrdersGetter().GetCopy());
         }
      }
};