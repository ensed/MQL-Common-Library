#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\BollingerBands\BollingerBands.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"

enum ENUM_PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE
{
   PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE_UP, // Crossing up
   PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE_DOWN // Crossing down
};

class PriceAndBollingerBandsCrossing : public SignalChecker
{
   private:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      ENUM_PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE m_crossingType;
      int m_shift;
      
      BollingerBands* m_bands;
      CandlePriceOpen* m_priceOpen;
      CandlePriceOpen* m_previousPriceOpen;
      
   public:
      PriceAndBollingerBandsCrossing
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const BollingerBandsParameters &maParameters,
         const ENUM_PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE crossingType,
         const ENUM_BANDS_LINE line,
         const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         m_crossingType = crossingType;
         m_shift = shift;
         
         m_bands = new BollingerBands(m_instrument, m_timeframe, maParameters, line);
         m_priceOpen = new CandlePriceOpen(m_instrument, m_timeframe, m_shift);
         m_previousPriceOpen = new CandlePriceOpen(m_instrument, m_timeframe, m_shift + 1);
      }
      
      ~PriceAndBollingerBandsCrossing()
      {
         PointersReleaser::Release(m_bands);
         PointersReleaser::Release(m_priceOpen);
         PointersReleaser::Release(m_previousPriceOpen);
      }
      
      virtual bool Exists() override
      {         
         m_priceOpen.Update();
         m_previousPriceOpen.Update();
         
         if(!IsValueValid(m_priceOpen.Value()) || !IsValueValid(m_previousPriceOpen.Value()))
         {
            return false;
         }
         
         double maValue = m_bands[m_shift];
         double previousBollingerBandsValue = m_bands[m_shift + 1];
         
         if(!IsValueValid(maValue) || !IsValueValid(previousBollingerBandsValue))
         {
            return false;
         }

         if(m_crossingType == PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE_UP)
         {
            if(m_priceOpen.Value() > maValue && m_previousPriceOpen.Value() <= previousBollingerBandsValue)
            {
               return true;
            }
         }

         if(m_crossingType == PRICE_AND_BOLLINGER_BANDS_CROSSING_TYPE_DOWN)
         {
            if(m_priceOpen.Value() < maValue && m_previousPriceOpen.Value() >= previousBollingerBandsValue)
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