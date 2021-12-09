#property strict

#include "..\IndicatorAPIBase.mqh"

class AO : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      
   public:
      AO(const string symbol, const ENUM_TIMEFRAMES timeframe)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
      }
      
      double GetValue(const int shift) override
      {		
         return iAO(m_symbol, m_timeframe, shift);
      }
};