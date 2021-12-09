#property strict

#include "AbstractPointsValueCalculator.mqh"
#include "..\IndicatorsAPI\ATR\ATR.mqh"

class ATRPointsValueCalculator: public AbstractPointsValueCalculator
{
   private:
      ATR* m_atr;
      int m_barShift;
      double m_atrRatio;
      
      double m_point;
      
   public:
      ATRPointsValueCalculator
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int atrPeriod,
         const int barShift,
         const double atrRatio
      )
      :
         m_atr(new ATR(instrument, timeframe, atrPeriod)),
         m_atrRatio(atrRatio),
         m_barShift(barShift)
      {
         m_point = SymbolInfoDouble(instrument, SYMBOL_POINT);
      }
      
      ~ATRPointsValueCalculator()
      {
         delete m_atr;
      }
      
      virtual void Calculate() override
      {
         if(NormalizeDouble(m_point - 0.0, 8) == 0)
         {
            m_value = 0;
            return;
         }

         m_value = (int)((m_atr[m_barShift] / m_point) * m_atrRatio);
      }
};