#property strict

#include "..\OrdersGetter.mqh"

class SingleOrderGetter
{
   protected:
      OrdersGetter* m_ordersGetter;
      OrderInfo m_ordersFromGetter[];
      OrderInfo m_resultOrder;
      
   public:
      SingleOrderGetter(OrdersGetter* ordersGetter)
      {
         m_ordersGetter = ordersGetter;
         ArrayFree(m_ordersFromGetter);                  
      }
      
      ~SingleOrderGetter()
      {
         PointersReleaser::Release(m_ordersGetter);
      }
      
      void Update()
      {
         m_ordersGetter.Update();
         m_ordersGetter.Get(m_ordersFromGetter);
         
         DetectResultOrder();
      }
      
      OrderInfo Get()
      {
         return m_resultOrder;
      }
      
   protected:
      virtual void DetectResultOrder() = 0;
};