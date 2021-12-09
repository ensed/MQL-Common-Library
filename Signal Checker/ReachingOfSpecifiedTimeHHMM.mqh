#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "SignalChecker.mqh"
#include "..\Parsers\TimeHHMMFromStringParser.mqh"

class ReachingOfSpecifiedTimeHHMM : public SignalChecker
{
   private:
      int m_hour;
      int m_minute;
      
   public:
      ReachingOfSpecifiedTimeHHMM
      (
         const int hour, const int minute
      )
      {
         m_hour = hour;
         m_minute = minute;
      }
      
      ReachingOfSpecifiedTimeHHMM
      (
         const string startHHMMTime
      )
      {
         TimeHHMMFromStringParser timeParser(startHHMMTime);
         timeParser.Parse();
         m_hour = timeParser.Hour();
         m_minute = timeParser.Minute();
      }
      
      virtual bool Exists() override final
      {
         MqlDateTime dt;
         TimeToStruct(TimeCurrent(), dt);
         
         return dt.hour == m_hour && dt.min == m_minute;
      }
      
};