#property strict

#include "..\IndicatorAPIBase.mqh"

class AC : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      
   public:
      AC(const string symbol, const ENUM_TIMEFRAMES timeframe)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
      }
      
      double GetValue(const int shift) override
      {		
         return iAC(m_symbol, m_timeframe, shift);
      }
};