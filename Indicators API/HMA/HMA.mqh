#property strict

#include "..\IndicatorAPIBase.mqh"
#include "HMAParameters.mqh"

#resource "\\Indicators\\HMA.ex4" 

class CHMA : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      CHMAParameters m_parameters;
      
   public:
      CHMA(const string symbol, const ENUM_TIMEFRAMES timeframe, const CHMAParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {		
         return iCustom
         (
            m_symbol, m_timeframe, "::Indicators\\HMA.ex4",
            m_parameters.Period(), m_parameters.Method(), m_parameters.AppliedPrice(),
            0, shift
         );
      }      
};