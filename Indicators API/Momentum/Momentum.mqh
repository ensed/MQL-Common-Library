#property strict

#include "..\IndicatorAPIBase.mqh"
#include "MomentumParameters.mqh"

class Momentum : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      MomentumParameters m_parameters;
      
   public:
      Momentum(const string symbol, const ENUM_TIMEFRAMES timeframe, const MomentumParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {		
         return iMomentum
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.AppliedPrice(),
            shift
         );
      }
};