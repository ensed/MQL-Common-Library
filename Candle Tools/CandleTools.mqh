#property strict

class CandleTools
{
   protected:
      const string m_instrument;
      const ENUM_TIMEFRAMES m_timeframe;
      int m_shift;
      
   public:
      CandleTools
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int shift = 0         
      )
      :
         m_instrument(instrument),
         m_timeframe(timeframe),
         m_shift(shift)
      {
      }

      void SetShift(const int shift) { m_shift = shift; }

      double Open() { return iOpen(m_instrument, m_timeframe, m_shift); }
      double High() { return iHigh(m_instrument, m_timeframe, m_shift); }
      double Low() { return iLow(m_instrument, m_timeframe, m_shift); }
      double Close() { return iClose(m_instrument, m_timeframe, m_shift); }

      bool IsBullish() { return Open() < Close(); }
      bool IsBearish() { return Open() > Close(); }

      double UpperBodyPrice() { return MathMax(Open(), Close()); }
      double LowerBodyPrice() { return MathMin(Open(), Close()); }
      
      double BodySize() { return UpperBodyPrice() - LowerBodyPrice(); }
      double FullSize() { return High() - Low(); }

      double MiddleFullPrice() { return (High() + Low()) / 2.0; }
      double MiddleBodyPrice() { return (UpperBodyPrice() + LowerBodyPrice()) / 2.0; }
      
      double UpperShadowSize() { return High() - UpperBodyPrice(); }
      double LowerShadowSize() { return LowerBodyPrice() - Low(); }
};