#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "..\Filter\FiltersList.mqh"

class OrdersProcessor
{
   protected:
      FiltersList* m_filters;
      
   public:
      OrdersProcessor(FiltersList* filters)
      {
         m_filters = filters;
      }
      
      ~OrdersProcessor()
      {
         PointersReleaser::Release(m_filters);
      }
      
      void Execute()
      {
         if(!m_filters.IsAnyValid())
         {
            OnExecute();
         }
      }
      
      void AddFilter(Filter *filter)
      {
         m_filters.Add(filter);
      }
      
   protected:
      virtual void OnExecute() = 0;
};