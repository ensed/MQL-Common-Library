#property strict

#include "OrdersGetter.mqh"
#include "..\..\Common Library\Helpers\ArraysHelper.mqh"

class OrdersGetterByMagicsList : public OrdersGetter
{     
   private:
      int m_magicsList[];
      int m_magicsCount;
      
   public:         
      OrdersGetterByMagicsList(const int magic1, const int magic2, OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {         
         InitMagicsList(magic1, magic2);
      }
      
      OrdersGetterByMagicsList(const int magic1, const int magic2, OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         InitMagicsList(magic1, magic2);
      }
      
      OrdersGetterByMagicsList(const int &magicsList[], OrdersGetter* ordersGetter)
      : OrdersGetter(ordersGetter)
      {         
         InitMagicsList(magicsList);
      }
      
      OrdersGetterByMagicsList(const int &magicsList[], OrdersSource* ordersSource)
      : OrdersGetter(ordersSource)
      {
         InitMagicsList(magicsList);
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) override
      {
         for(int i = 0; i < m_magicsCount; i++)
         {
            if(order.Magic == m_magicsList[i])
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
      
      virtual OrdersGetter* GetCopy() override final
      {
         if(CheckPointer(this.GetOrdersGetter()) == POINTER_INVALID)
         {
            return new OrdersGetterByMagicsList(m_magicsList, GetOrdersSource().GetCopy());
         }
         else
         {
            return new OrdersGetterByMagicsList(m_magicsList, GetOrdersGetter().GetCopy());
         }
      }
      
   private:
      void InitMagicsList(const int &magicsList[])
      {
         ArraysHelper::CopyArray(magicsList, m_magicsList);
         m_magicsCount = ArraySize(m_magicsList);
      }
      
      void InitMagicsList(const int magic1, const int magic2)
      {
         ArrayFree(m_magicsList);
         ArraysHelper::AddToArray(magic1, m_magicsList ADD_TO_ARRAY_TRACING_CALLER);
         ArraysHelper::AddToArray(magic2, m_magicsList ADD_TO_ARRAY_TRACING_CALLER);
         m_magicsCount = ArraySize(m_magicsList);
      }
};