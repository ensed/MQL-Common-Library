#property strict

#include "Filter.mqh"
#include "..\CandlePricesAPI\CandlePriceOpen.mqh"
#include "..\IndicatorsAPI\ParabolicSAR\ParabolicSAR.mqh"
#include "..\Helpers\PointersReleaser.mqh"

class FilterForBuyByPSAR : public Filter
{     
   private:
      ParabolicSAR* m_psar;
      CandlePriceOpen* m_priceOpen;
      
   public:
      FilterForBuyByPSAR
      (
         const string instrument,
         const ENUM_TIMEFRAMES timeframe,
         const ParabolicSARParameters &psarParameters
      )
      {
         m_psar = new ParabolicSAR(instrument, timeframe, psarParameters);
         m_priceOpen = new CandlePriceOpen(instrument, timeframe, 0);
      }
      
      ~FilterForBuyByPSAR()
      {
         PointersReleaser::Release(m_psar);
         PointersReleaser::Release(m_priceOpen);
      }
      
      virtual bool IsValid() override
      {
         m_priceOpen.Update();
         
         return m_psar[0] > m_priceOpen.Value();
      }
};