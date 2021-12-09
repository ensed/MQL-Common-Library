#property strict

#include "OrdersGetter.mqh"

class OrdersGetterByCommentPartsOR : public OrdersGetter
{     
   private:
      string m_commentParts[];
      
   public:      
      OrdersGetterByCommentPartsOR(const string &commentParts[], OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         ArraysHelper::CopyArray(commentParts, m_commentParts);
      }
            
      OrdersGetterByCommentPartsOR(const string &commentParts[], OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         ArraysHelper::CopyArray(commentParts, m_commentParts);
      }
      
      OrdersGetterByCommentPartsOR(const string commentPart1, const string commentPart2, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {
         ArraysHelper::AddToArray(commentPart1, m_commentParts);
         ArraysHelper::AddToArray(commentPart2, m_commentParts);
      }
      
      OrdersGetterByCommentPartsOR(const string commentPart1, const string commentPart2, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         ArraysHelper::AddToArray(commentPart1, m_commentParts);
         ArraysHelper::AddToArray(commentPart2, m_commentParts);
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         for(int i = 0; i < ArraySize(m_commentParts); i++)
         {
            if(StringFind(order.Comment(), m_commentParts[i]) != -1)
            {
               return true;
            }
         }
         
         return false;
      }
      
      virtual string Type() override
      {
         return typename(this);
      }
      
   protected:
      virtual bool IsAttributeStatic() override
      {
         return true;
      }
};