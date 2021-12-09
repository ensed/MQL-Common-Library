#property strict

#include "..\IndicatorAPIBase.mqh"
#include "OsMAParameters.mqh"

class OsMA : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      OsMAParameters m_parameters;
      
   public:
      OsMA(const string symbol, const ENUM_TIMEFRAMES timeframe, const OsMAParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {
         return iOsMA
         (
            m_symbol, m_timeframe, 
            m_parameters.FastEMAPeriod(), m_parameters.SlowEMAPeriod(), m_parameters.SignalPeriod(), m_parameters.AppliedPrice(), 
            shift
         );
      }
};