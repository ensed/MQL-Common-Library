#ifdef __MQL4__
#property strict
#endif 

class CandleAPI
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      int m_shift;
      
   public:
      CandleAPI
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         m_shift = shift;
      }    
      
      virtual void Update() = 0;
};