#property strict

#include "SingleOrderGetter.mqh"

class OrderGetterWithLowestPriceOpen : public SingleOrderGetter
{      
   public:
      OrderGetterWithLowestPriceOpen(OrdersGetter* ordersGetter)
      : SingleOrderGetter(ordersGetter)
      {

      }
      
   protected:
      virtual void DetectResultOrder() override
      {
         int ordersCount = ArraySize(m_ordersFromGetter);
         
         if(ordersCount == 0)
         {
            return;
         }
         
         double minPrice = m_ordersFromGetter[0].PriceOpen();
         m_resultOrder = m_ordersFromGetter[0];
         
         for(int i = 1; i < ordersCount; i++)
         {
            if(m_ordersFromGetter[i].PriceOpen() < minPrice)
            {
               minPrice = m_ordersFromGetter[i].PriceOpen();
               m_resultOrder = m_ordersFromGetter[i];
            }
         }
      }
};