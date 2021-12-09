#property strict

class CandlePrice
{
   protected:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      int m_shift;
      
      double m_value;
      
   public:
      CandlePrice
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
      
      double Value() const
      {
         return m_value;
      }
};