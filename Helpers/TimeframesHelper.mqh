#property strict

class TimeframesHelper
{
   public:
      static string TimeframeToString(const ENUM_TIMEFRAMES timeframe)
      {
         ENUM_TIMEFRAMES timeframeValue = timeframe;
         
         if(timeframeValue == PERIOD_CURRENT)
         {
            timeframeValue = (ENUM_TIMEFRAMES)Period();
         }
         
         string timeframeStr = EnumToString(timeframeValue);
         #ifdef __MQL4__
         StringReplace(timeframeStr, "PERIOD_", "");
         #endif 
         
         #ifdef __MQL5__
         !to check!StringReplace(timeframeStr, "PERIOD_", "");
         #endif 
         
         return timeframeStr;
      }
};