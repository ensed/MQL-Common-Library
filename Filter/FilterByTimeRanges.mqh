#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "FilterByTimeRange.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Helpers\PointersReleaser.mqh"

class FilterByTimeRanges : public Filter
{
   protected:
      FilterByTimeRange* m_filters[];
      
   public:
      FilterByTimeRanges()
      {
         ArrayFree(m_filters);
      }
      
      FilterByTimeRanges(FilterByTimeRange* &filters[])
      {
         ArrayFree(m_filters);
         ArraysHelper::CopyArray(filters, m_filters);
      }
      
      FilterByTimeRanges
      (
         const int startHour1, const int startMinute1, const int stopHour1, const int stopMinute1,
         const int startHour2, const int startMinute2, const int stopHour2, const int stopMinute2,
         const EnumTimeModeForFilterByTimeRange timeMode
      )
      {
         ArrayFree(m_filters);
         ArraysHelper::AddToArray
         (
            new FilterByTimeRange(startHour1, startMinute1, stopHour1, stopMinute1, timeMode), m_filters
            ADD_TO_ARRAY_TRACING_CALLER
         );
         
         ArraysHelper::AddToArray
         (
            new FilterByTimeRange(startHour2, startMinute2, stopHour2, stopMinute2, timeMode), m_filters
            ADD_TO_ARRAY_TRACING_CALLER
         );
      }
      
      FilterByTimeRanges
      (
         const string startHHMMTime1, const string stopHHMMTime1,
         const string startHHMMTime2, const string stopHHMMTime2,
         const EnumTimeModeForFilterByTimeRange timeMode
      )
      {
         ArrayFree(m_filters);
         ArraysHelper::AddToArray
         (
            new FilterByTimeRange(startHHMMTime1, stopHHMMTime1, timeMode), m_filters
            ADD_TO_ARRAY_TRACING_CALLER
         );
         
         ArraysHelper::AddToArray
         (
            new FilterByTimeRange(startHHMMTime2, stopHHMMTime2, timeMode), m_filters
            ADD_TO_ARRAY_TRACING_CALLER
         );
      }
          
      ~FilterByTimeRanges()
      {
         PointersReleaser::Release(m_filters);
      }
      
      void AddTimeRanges
      (
         const string startHHMMTime, const string stopHHMMTime, const EnumTimeModeForFilterByTimeRange timeMode
      )
      {
         ArraysHelper::AddToArray
         (
            new FilterByTimeRange(startHHMMTime, stopHHMMTime, timeMode), m_filters
            ADD_TO_ARRAY_TRACING_CALLER
         );
      }
      
      bool IsValid() override
      {                  
         for(int i = 0; i < ArraySize(m_filters); i++)
         {
            if(!m_filters[i].IsValid())
            {
               return false;
            }
         }
         
         return true;
      }
      
      virtual Filter* GetCopy() override
      {
         return new FilterByTimeRanges(m_filters);
      }
      
      virtual string TypeName() const override
      {
         return typename(this);
      }

};