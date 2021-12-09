#property strict

#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "SignalChecker.mqh"
#include "..\IndicatorsAPI\CCI\CCI.mqh"
#include "..\Helpers\PointersReleaser.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\Validators\PriceOrIndicatorValueValidator.mqh"

enum ENUM_CCI_THRESHOLD_CROSSING_TYPE
{
   CCI_THRESHOLD_CROSSING_TYPE_UP, // Crossing up
   CCI_THRESHOLD_CROSSING_TYPE_DOWN // Crossing down
};

class CCIThresholdCrossing : public SignalChecker
{
   private:
      string m_instrument;
      ENUM_TIMEFRAMES m_timeframe;
      ENUM_CCI_THRESHOLD_CROSSING_TYPE m_crossingType;
      double m_thresholdLevel;
      int m_shift;
      
      CCI* m_cci;
      
   public:
      CCIThresholdCrossing
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const CCIParameters &parameters,
         const ENUM_CCI_THRESHOLD_CROSSING_TYPE crossingType,
         const double thresholdLevel,
         const int shift
      )
      {
         m_instrument = instrument;
         m_timeframe = timeframe;
         m_crossingType = crossingType;
         m_thresholdLevel = thresholdLevel;
         m_shift = shift;
         
         m_cci = new CCI(m_instrument, m_timeframe, parameters);
      }
      
      ~CCIThresholdCrossing()
      {
         PointersReleaser::Release(m_cci);
      }
      
      virtual bool Exists() override
      {                  
         double cciValue = m_cci[m_shift];
         double previousCCIValue = m_cci[m_shift + 1];
         
         if(!IsValueValid(cciValue) || !IsValueValid(previousCCIValue))
         {
            return false;
         }

         if(m_crossingType == CCI_THRESHOLD_CROSSING_TYPE_UP)
         {
            if(cciValue > m_thresholdLevel && previousCCIValue <= m_thresholdLevel)
            {              
               return true;
            }
         }

         if(m_crossingType == CCI_THRESHOLD_CROSSING_TYPE_DOWN)
         {
            if(cciValue < m_thresholdLevel && previousCCIValue >= m_thresholdLevel)
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