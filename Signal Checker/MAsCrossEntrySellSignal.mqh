#property strict

#include "..\..\Common Library\Signal Checker\SignalChecker.mqh"
#include "..\..\Common Library\Helpers\PointersReleaser.mqh"
#include "..\..\Common Library\IndicatorsAPI\MA\MA.mqh"

class MAsCrossEntrySellSignal : public SignalChecker
{
   protected:
      MA* m_fastMA;
      MA* m_slowMA;
      int m_shift;
      
   public:
      MAsCrossEntrySellSignal
      (
         const string instrument, 
         const ENUM_TIMEFRAMES timeframe,
         MAParameters &fastMAParameters,
         MAParameters &slowMAParameters
      )
      {         
         m_fastMA = new MA(instrument, timeframe, fastMAParameters);
         m_slowMA = new MA(instrument, timeframe, slowMAParameters);
         m_shift = 1;
      }
      
      MAsCrossEntrySellSignal
      (
         const string instrument, 
         const ENUM_TIMEFRAMES timeframe,
         MAParameters &fastMAParameters,
         MAParameters &slowMAParameters,
         const int shift
      )
      {         
         m_fastMA = new MA(instrument, timeframe, fastMAParameters);
         m_slowMA = new MA(instrument, timeframe, slowMAParameters);
         m_shift = shift;
      }
      
      ~MAsCrossEntrySellSignal()
      {
         PointersReleaser::Release(m_fastMA);
         PointersReleaser::Release(m_slowMA);
      }
      
      virtual bool Exists() override
      {
         return m_fastMA[m_shift+1] >= m_slowMA[m_shift+1] && m_fastMA[m_shift] < m_slowMA[m_shift]; 
      }
};