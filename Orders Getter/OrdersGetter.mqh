#property strict

#include "..\Models\OrderInfo.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\Orders Source\OrdersSource.mqh"

class OrdersGetter
{
   protected:     
      OrderInfo m_orders[];
      OrdersGetter* m_ordersGetter;
      OrdersSource* m_ordersSource;
      
   public:
      OrdersGetter(OrdersGetter* ordersGetter)
      {      
         m_ordersGetter = ordersGetter;
         m_ordersSource = ordersGetter.GetOrdersSource();            
      }
      
      OrdersGetter(OrdersSource* ordersSource)
      {
         m_ordersSource = ordersSource;
      }
      
      ~OrdersGetter()
      {
         PointersReleaser::Release(m_ordersGetter);
      }
      
      int Count()
      {
         return ArraySize(m_orders);
      }
      
      OrdersSource* GetOrdersSource()
      {
         return m_ordersSource;
      }      
      
      OrdersGetter* GetOrdersGetter()
      {
         return m_ordersGetter;
      }
      
      virtual string Type() = 0;
      
      void Update()
      {
         ArrayFree(m_orders);

         m_ordersSource.Update();
         OrderInfo orders[];
         m_ordersSource.Get(orders);
         
         for(int i = 0; i < ArraySize(orders); i++)
         {
            bool isOrderApproachable = true;
            
            OrdersGetter* getter = GetPointer(this);
            while(CheckPointer(getter) != POINTER_INVALID)
            {
               if(!getter.IsOrderApproachable(orders[i]))
               {
                  isOrderApproachable = false;
                  break;
               }
                                
               getter = getter.GetOrdersGetter();
            }

            if(isOrderApproachable)
            {               
               ArraysHelper::AddToArray(orders[i], m_orders ADD_TO_ARRAY_TRACING_CALLER);
            }
         }
      }
      
      void Get(OrderInfo &orders[])
      {
         ArraysHelper::CopyArray(m_orders, orders);
      }
      
      OrderInfo operator[](const int index)
      {
         return m_orders[index];
      }
      
      virtual bool IsOrderApproachable(const OrderInfo &order) = 0;
      virtual OrdersGetter* GetCopy() = 0;
};