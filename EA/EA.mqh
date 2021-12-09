#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include <Object.mqh>

class EA: public CObject
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      
   public:
      EA(const string instrument, const ENUM_TIMEFRAMES timeframe)
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
      }
      
      virtual int OnInit() = 0;
      virtual void OnDeinit(const int reason) = 0;
      virtual void OnTick() = 0;
      
      virtual void OnTimer()
      {
         ;
      }
      
      virtual void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
      {
         ;
      }
      
      virtual string TypeName() const = 0;
};