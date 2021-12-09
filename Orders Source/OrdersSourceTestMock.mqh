#ifdef __MQL4__
#property strict
#endif 

#include "OrdersSource.mqh"

class OrdersSourceTestMock : public OrdersSource
{
   public:
      OrdersSourceTestMock(const OrderInfo &orders[])
      {
         ArrayFree(m_orders);
         ArraysHelper::CopyArray(orders, m_orders);
         #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
            m_count = ArraySize(m_orders);
         #endif 
      }
      
      OrdersSourceTestMock()
      {  
         #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
            m_count = 0;
         #endif 
         ArrayFree(m_orders);
      }
      
      void AddOrder(const OrderInfo &order)
      {
         ArraysHelper::AddToArray(order, m_orders);
         #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
            m_count = ArraySize(m_orders);
         #endif 
      }
      
      
      virtual void Update() override final
      {
         ;
      }
      
      virtual string TypeName() override final
      {
         return typename(this);
      }
      
      virtual OrdersSource* GetCopy() override final
      {
         return new OrdersSourceTestMock(m_orders);
      }
};