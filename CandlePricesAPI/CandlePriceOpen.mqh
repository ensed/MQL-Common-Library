#property strict

#include "CandlePrice.mqh"

class CandlePriceOpen : public CandlePrice
{
   public:
      CandlePriceOpen
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
         m_value = iOpen(m_instrument, m_timeframe, m_shift);
      }
      #endif
      
      #ifdef __MQL5__
      virtual void Update() override
      {
         double Open[];
         ArraySetAsSeries(Open,true);
         CopyOpen(m_instrument,m_timeframe,m_shift,1,Open);
         if(ArraySize(Open) > 0)
         {
            m_value = Open[0];
         }
         else
         {
            m_value = 0;
         }
      }
      #endif
};