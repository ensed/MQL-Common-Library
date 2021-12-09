#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "Filter.mqh"
#include "..\Parsers\TimeHHMMFromStringParser.mqh"

class FilterByDaysOfWeekAndTimeRange : public Filter
{
   protected:
      ENUM_DAY_OF_WEEK m_startDay;
      int m_startHour;
      int m_startMinute;
      
      ENUM_DAY_OF_WEEK m_stopDay;
      int m_stopHour;
      int m_stopMinute;
      
      ENUM_DAY_OF_WEEK m_currentDay;
      int m_currentHour;
      int m_currentMinute;
      bool m_isSetCurrentDayAndTime;
      
   public:
   
      FilterByDaysOfWeekAndTimeRange
      (
         const ENUM_DAY_OF_WEEK startDay, const int startHour, const int startMinute,          
         const ENUM_DAY_OF_WEEK stopDay, const int stopHour, const int stopMinute
      )
      {
         m_startDay = startDay;
         m_startHour = startHour;
         m_startMinute = startMinute;
         
         m_stopDay = stopDay;
         m_stopHour = stopHour;
         m_stopMinute = stopMinute;

         m_isSetCurrentDayAndTime = false;
      }
      
      FilterByDaysOfWeekAndTimeRange
      (
         const ENUM_DAY_OF_WEEK startDay, const string startHHMMTime, 
         const ENUM_DAY_OF_WEEK stopDay, const string stopHHMMTime
      )
      {
         m_startDay = startDay;
         
         TimeHHMMFromStringParser startTimeParser(startHHMMTime);
         startTimeParser.Parse();
         m_startHour = startTimeParser.Hour();
         m_startMinute = startTimeParser.Minute();
         
         m_stopDay = stopDay;
         
         TimeHHMMFromStringParser stopTimeParser(stopHHMMTime);
         stopTimeParser.Parse();                  
         m_stopHour = stopTimeParser.Hour();
         m_stopMinute = stopTimeParser.Minute();

         m_isSetCurrentDayAndTime = false;
      }
      
      FilterByDaysOfWeekAndTimeRange
      (
         const ENUM_DAY_OF_WEEK startDay, const int startHour, const int startMinute,          
         const ENUM_DAY_OF_WEEK stopDay, const int stopHour, const int stopMinute,
         const ENUM_DAY_OF_WEEK currentDay, const int currentHour, const int currentMinute
      )
      {
         m_startDay = startDay;
         m_startHour = startHour;
         m_startMinute = startMinute;
         
         m_stopDay = stopDay;
         m_stopHour = stopHour;
         m_stopMinute = stopMinute;
         
         m_currentDay = currentDay;
         m_currentHour = currentHour;
         m_currentMinute = currentMinute;
         m_isSetCurrentDayAndTime = true;
      }
      
      FilterByDaysOfWeekAndTimeRange
      (
         const ENUM_DAY_OF_WEEK startDay, const string startHHMMTime, 
         const ENUM_DAY_OF_WEEK stopDay, const string stopHHMMTime,
         const ENUM_DAY_OF_WEEK currentDay, const string currentHHMMTime
      )
      {
         m_startDay = startDay;
         
         TimeHHMMFromStringParser startTimeParser(startHHMMTime);
         startTimeParser.Parse();
         m_startHour = startTimeParser.Hour();
         m_startMinute = startTimeParser.Minute();
         
         m_stopDay = stopDay;
         
         TimeHHMMFromStringParser stopTimeParser(stopHHMMTime);
         stopTimeParser.Parse();                  
         m_stopHour = stopTimeParser.Hour();
         m_stopMinute = stopTimeParser.Minute();
         
         m_currentDay = currentDay;
         
         TimeHHMMFromStringParser currentTimeParser(currentHHMMTime);
         currentTimeParser.Parse();                  
         m_currentHour = currentTimeParser.Hour();
         m_currentMinute = currentTimeParser.Minute();
         m_isSetCurrentDayAndTime = true;
      }      
      
      bool IsValid() override
      {         
         return IsTimeNotInSession();
      }
      
   protected:
      bool IsTimeNotInSession()
      {
         int startTime = m_startDay * 24 * 60 + m_startHour * 60 + m_startMinute;
         int stopTime = m_stopDay * 24 * 60 + m_stopHour * 60 + m_stopMinute;
         int currentTime = 0;
         
         if(m_isSetCurrentDayAndTime)
         {
            currentTime = m_currentDay * 24 * 60 + m_currentHour * 60 + m_currentMinute;
         }
         else
         {
            MqlDateTime dt;
            TimeToStruct(TimeCurrent(), dt);
            currentTime = dt.day_of_week * 24 * 60 + dt.hour * 60 + dt.min;
         }

         if(stopTime > startTime)
         {
            if(currentTime >= stopTime || currentTime < startTime)
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
            if(currentTime >= stopTime && currentTime < startTime)
         	{
         	   return true;
         	}	
         	else
         	{
               return false;
         	}
      	}
      }
};