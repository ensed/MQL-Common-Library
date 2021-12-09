#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\RVI\RVI.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"

enum ENUM_RVI_CROSSING_TYPE
{
   RVI_CROSSING_TYPE_UP, // Crossing up
   RVI_CROSSING_TYPE_DOWN // Crossing down
};

class RVICrossingOfSignalAndMain : public SignalChecker
{
   private:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      ENUM_RVI_CROSSING_TYPE m_crossingType;
      int m_shift;
      
      RVI* m_rviMain;
      RVI* m_rviSignal;
      
   public:
      RVICrossingOfSignalAndMain
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int period,
         const ENUM_RVI_CROSSING_TYPE crossingType,
         const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         m_crossingType = crossingType;         
         m_shift = shift;
         
         m_rviMain = new RVI(m_instrument, m_timeframe, period, RVI_LINE_MAIN);
         m_rviSignal = new RVI(m_instrument, m_timeframe, period, RVI_LINE_SIGNAL);
      }
      
      ~RVICrossingOfSignalAndMain()
      {
         PointersReleaser::Release(m_rviMain);
         PointersReleaser::Release(m_rviSignal);
      }
      
      virtual bool Exists() override
      {                  
         double rviMainValue = m_rviMain[m_shift];
         double previousRVIMainValue = m_rviMain[m_shift + 1];
         
         double rviSignalValue = m_rviSignal[m_shift];
         double previousRVISignalValue = m_rviSignal[m_shift + 1];
         
         if
         (
            !IsValueValid(rviMainValue) || !IsValueValid(previousRVIMainValue)
            || !IsValueValid(rviSignalValue) || !IsValueValid(previousRVISignalValue)
         )
         {
            return false;
         }

         if(m_crossingType == RVI_CROSSING_TYPE_UP)
         {
            if(rviMainValue > rviSignalValue && previousRVIMainValue <= previousRVISignalValue)
            {              
               return true;
            }
         }

         if(m_crossingType == RVI_CROSSING_TYPE_DOWN)
         {
            if(rviMainValue < rviSignalValue && previousRVIMainValue >= previousRVISignalValue)
            {
               return true;
            }
         }

         return false;
      }
      
   private:
      bool IsValueValid(const double value)
      {
         PriceOrIndicatorValueValidator validator(value);
         validator.Update();
         return validator.IsValueValid();
      }
};