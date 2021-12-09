#property strict

#include "..\IndicatorAPIBase.mqh"
#include "IchimokuParameters.mqh"

enum EnumIchimokuKinkoHyoMode
{
   IchimokuKinkoHyoMode_TenkanSen = 1,
   IchimokuKinkoHyoMode_KijunSen = 2,
   IchimokuKinkoHyoMode_SenkouSpanA = 3,
   IchimokuKinkoHyoMode_SenkouSpanB = 4, 
   IchimokuKinkoHyoMode_ChikouSpan = 5
};

#ifdef __MQL4__
class Ichimoku: public IndicatorAPIBase
{
   private:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      IchimokuParameters m_parameters;
      EnumIchimokuKinkoHyoMode m_line;
      
   public:
		Ichimoku
		(
			const string instrument,
			const ENUM_TIMEFRAMES timeframe,
			const IchimokuParameters &parameters,
			const EnumIchimokuKinkoHyoMode line
		)
		:
			m_instrument(instrument),
			m_timeframe(timeframe),
			m_parameters(parameters),
			m_line(line)
		{
		}
		
      double GetValue(const int shift) override
      {		
         return iIchimoku
         (
            m_instrument, m_timeframe, 
            m_parameters.TenkanSen(), m_parameters.KijunSen(), m_parameters.SenkouSpanB(),
            m_line, shift
         );
      }
};
#endif 