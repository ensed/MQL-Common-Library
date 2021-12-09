#property strict

#include "CandlePrice.mqh"

class CandlePriceLow : public CandlePrice
{
   public:
      CandlePriceLow
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int shift
      )
      : CandlePrice(instrument, timeframe, shift)
      {    
         
      }
      
      #ifdef __MQL4__
      virtual void Update() override
      {
         m_value = iLow(m_instrument, m_timeframe, m_shift);
      }
      #endif
      
      #ifdef __MQL5__
      virtual void Update() override
      {
         double buffer[];
         ArraySetAsSeries(buffer,true);
         CopyLow(m_instrument,m_timeframe,m_shift,1,buffer);
         
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
};