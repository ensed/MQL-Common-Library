#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "SignalChecker.mqh"
#include "..\Parsers\TimeHHMMFromStringParser.mqh"

class ReachingOfSpecifiedDayOfWeekAndTimeHHMM : public SignalChecker
{
   private:
      ENUM_DAY_OF_WEEK m_dayOfWeek;
      int m_hour;
      int m_minute;
      
   public:
      ReachingOfSpecifiedDayOfWeekAndTimeHHMM
      (
         const ENUM_DAY_OF_WEEK dayOfWeek, const int hour, const int minute
      )
      {
         m_dayOfWeek = dayOfWeek;
         m_hour = hour;
         m_minute = minute;
      }
      
      ReachingOfSpecifiedDayOfWeekAndTimeHHMM
      (
         const ENUM_DAY_OF_WEEK dayOfWeek, const string startHHMMTime
      )
      {
         m_dayOfWeek = dayOfWeek;
         
         TimeHHMMFromStringParser timeParser(startHHMMTime);
         timeParser.Parse();
         m_hour = timeParser.Hour();
         m_minute = timeParser.Minute();
      }
      
      virtual bool Exists() override final
      {
         MqlDateTime dt;
         TimeToStruct(TimeCurrent(), dt);
         
         return dt.day_of_week == m_dayOfWeek && dt.hour == m_hour && dt.min == m_minute;
      }
      
};