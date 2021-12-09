#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\ADX\ADX.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"

enum ENUM_ADX_CROSSING_TYPE
{
   ADX_CROSSING_TYPE_UP, // Crossing up
   ADX_CROSSING_TYPE_DOWN // Crossing down
};

class ADXCrossingOfDILines : public SignalChecker
{
   private:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      ENUM_ADX_CROSSING_TYPE m_crossingType;
      int m_shift;
      
      ADX* m_adxPlusDI;
      ADX* m_adxMinusDI;
      
   public:
      ADXCrossingOfDILines
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const int period,
         const ENUM_ADX_CROSSING_TYPE crossingType,
         const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         m_crossingType = crossingType;         
         m_shift = shift;
         
         m_adxPlusDI = new ADX(m_instrument, m_timeframe, period, ADX_LINE_PLUSDI);
         m_adxMinusDI = new ADX(m_instrument, m_timeframe, period, ADX_LINE_MINUSDI);
      }
      
      ~ADXCrossingOfDILines()
      {
         PointersReleaser::Release(m_adxPlusDI);
         PointersReleaser::Release(m_adxMinusDI);
      }
      
      virtual bool Exists() override
      {                  
         double adxPlusDIValue = m_adxPlusDI[m_shift];
         double previousADXPlusDIValue = m_adxPlusDI[m_shift + 1];
         
         double adxMinusDIValue = m_adxMinusDI[m_shift];
         double previousADXMinusDIValue = m_adxMinusDI[m_shift + 1];
         
         if
         (
            !IsValueValid(adxPlusDIValue) || !IsValueValid(previousADXPlusDIValue)
            || !IsValueValid(adxMinusDIValue) || !IsValueValid(previousADXMinusDIValue)
         )
         {
            return false;
         }

         if(m_crossingType == ADX_CROSSING_TYPE_UP)
         {
            if(adxPlusDIValue > adxMinusDIValue && previousADXPlusDIValue <= previousADXMinusDIValue)
            {              
               return true;
            }
         }

         if(m_crossingType == ADX_CROSSING_TYPE_DOWN)
         {
            if(adxPlusDIValue < adxMinusDIValue && previousADXPlusDIValue >= previousADXMinusDIValue)
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