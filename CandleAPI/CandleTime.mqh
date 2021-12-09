#ifdef __MQL4__
#property strict
#endif

#include "CandleAPI.mqh"

class CandleTime : public CandleAPI
{
   private:
      datetime m_value;
      
   public:
      CandleTime
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int shift
      ) : CandleAPI(instrument, timeframe, shift)
      {
         m_value = NULL;
      }
      
      #ifdef __MQL4__
      void Update() override
      {
         m_value = iTime(m_instrument, m_timeframe, m_shift);
      }
      #endif
      
      #ifdef __MQL5__
      virtual void Update() override
      {
         datetime buffer[];
         ArraySetAsSeries(buffer,true);
         CopyTime(m_instrument,m_timeframe,m_shift,1,buffer);
         if(ArraySize(buffer) > 0)
         {
            m_value = buffer[0];
         }
         else
         {
            m_value = 0;
         }
      }
      #endif
      
      datetime Value()
      {
         return m_value;
      } 
};