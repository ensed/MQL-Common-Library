#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "Filter.mqh"
#include "..\Parsers\TimeHHMMFromStringParser.mqh"

enum EnumTimeModeForFilterByTimeRange
{
   TimeModeForFilterByTimeRange_Current, // Current
   TimeModeForFilterByTimeRange_Local, // Local
   TimeModeForFilterByTimeRange_GMT // GMT
};

class FilterByTimeRange : public Filter
{
   protected:
      int m_startHour;
      int m_startMinute;
      int m_stopHour;
      int m_stopMinute;
      EnumTimeModeForFilterByTimeRange m_timeMode;
      
   public:
      FilterByTimeRange
      (
         const int startHour, const int startMinute, 
         const int stopHour, const int stopMinute,
         const EnumTimeModeForFilterByTimeRange timeMode
      )
      {
         m_startHour = startHour;
         m_startMinute = startMinute;
         m_stopHour = stopHour;
         m_stopMinute = stopMinute;
         m_timeMode = timeMode;
      }
      
      FilterByTimeRange
      (
         const string startHHMMTime, const string stopHHMMTime,
         const EnumTimeModeForFilterByTimeRange timeMode
      )
      {
         TimeHHMMFromStringParser startTimeParser(startHHMMTime);
         startTimeParser.Parse();
         m_startHour = startTimeParser.Hour();
         m_startMinute = startTimeParser.Minute();
         
         TimeHHMMFromStringParser stopTimeParser(stopHHMMTime);
         stopTimeParser.Parse();                  
         m_stopHour = stopTimeParser.Hour();
         m_stopMinute = stopTimeParser.Minute();
         
         m_timeMode = timeMode;
      }
      
      bool IsValid() override
      {         
         return IsTimeNotInSession(GetTimeToCompare());
      }
      
      virtual Filter* GetCopy() override final
      {
         return new FilterByTimeRange(m_startHour, m_startMinute, m_stopHour, m_stopMinute, m_timeMode);
      }
      
      virtual string TypeName() const override final
      {
         return typename(this);
      }
      
   protected:
      datetime GetTimeToCompare()
      {
         if(m_timeMode == TimeModeForFilterByTimeRange_Current)
         {
            return TimeCurrent();
         }
         else if(m_timeMode == TimeModeForFilterByTimeRange_Local)
         {
            return TimeLocal();
         }
         else if(m_timeMode == TimeModeForFilterByTimeRange_GMT)
         {
            return TimeGMT();
         }
         else
         {
            UnexpectedValueException(m_timeMode);
            return (datetime)0;
         }
      }
      
      bool IsTimeNotInSession(const datetime time)
      {
         double startTime = m_startHour + m_startMinute / 60.0;
         double stopTime = m_stopHour + m_stopMinute / 60.0;
         double curTime = TimeHour(time) + TimeMinute(time) / 60.0;
         
         if(stopTime > startTime)
         {
            if(curTime >= stopTime || curTime < startTime)
         	{
         	   return true;
         	}	
         	else
         	{	   
         	   return false;
         	}
      	}
      	else
      	{
            if(curTime >= stopTime && curTime < startTime)
         	{
         	   return true;
         	}	
         	else
         	{
               return false;
         	}
      	}
      }
      
   private:
      #ifdef __MQL5__
         int TimeHour(const datetime time)
         {
            MqlDateTime dt;
            TimeToStruct(time, dt);
            
            return dt.hour;
         }
         
         int TimeMinute(const datetime time)
         {
            MqlDateTime dt;
            TimeToStruct(time, dt);
            
            return dt.min;
         }
      #endif       
};