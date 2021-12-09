#property strict

#include "..\Models\OrderInfo.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Helpers\PointersReleaser.mqh"

#define ORDERS_SOURCE_OPTIMIZATIONS (1)

#ifdef ORDERS_SOURCE_OPTIMIZATIONS
   #define ORDERS_SOURCE_OPTIMIZATIONS_001 (1)
#endif 

class OrdersSource
{
   protected:     
      OrderInfo m_orders[];
      #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
         int m_count;
      #endif 
      
   public:
      virtual void Update() = 0;
      
      void Get(OrderInfo &orders[]) const
      {         
         ArraysHelper::CopyArray(m_orders, orders);
      }
      
      // These methods (GetTicket, GetMagic, etc) allows us to get some data without copying the OrderInfo's instance
      long GetTicket(const int index)
      {
         return m_orders[index].Ticket;
      }
      
      int GetMagic(const int index)
      {
         return m_orders[index].Magic;
      }
      
      string GetSymbol(const int index)
      {
         return m_orders[index].Symbol;
      }
      
      EnumOrderType GetType(const int index)
      {
         return m_orders[index].Type;
      }
      
      double GetPriceOpen(const int index)
      {
         return m_orders[index].PriceOpen;
      }
      
      double GetPriceClose(const int index)
      {
         return m_orders[index].PriceClose;
      }
      
      double GetStopLoss(const int index)
      {
         return m_orders[index].StopLoss;
      }
      
      double GetSize(const int index)
      {
         return m_orders[index].Size;
      }
      
      double GetProfit(const int index)
      {
         return m_orders[index].Profit;
      }
      
      double GetSwap(const int index)
      {
         return m_orders[index].Swap;
      }
      
      double GetComissions(const int index)
      {
         return m_orders[index].Comissions;
      }
      
      double GetTakeProfit(const int index)
      {
         return m_orders[index].TakeProfit;
      }

      datetime GetTimeOpen(const int index)
      {
         return m_orders[index].TimeOpen;
      }
      
      datetime GetTimeClose(const int index)
      {
         return m_orders[index].TimeClose;
      }
      
      bool GetIsTypeMarket(const int index)
      {
         return m_orders[index].IsTypeMarket();
      }
      
      bool GetIsTypePending(const int index)
      {
         return m_orders[index].IsTypePending();
      }
      
      bool GetIsTypeBuy(const int index)
      {
         return m_orders[index].IsTypeBuy();
      }
      
      bool GetIsTypeSell(const int index)
      {
         return m_orders[index].IsTypeSell();
      }
      
      int Count() const
      {
         #ifdef ORDERS_SOURCE_OPTIMIZATIONS_001
            return m_count;
         #else 
            return ArraySize(m_orders);
         #endif
      }
      
      OrderInfo operator[](const int index) const
      {
         return m_orders[index];
      }
      
      virtual void GetOrders(OrderInfo &orders[])
      {
         ArraysHelper::CopyArray(m_orders, orders);
      }
      
      virtual string TypeName() = 0;
      virtual OrdersSource* GetCopy() = 0;
};