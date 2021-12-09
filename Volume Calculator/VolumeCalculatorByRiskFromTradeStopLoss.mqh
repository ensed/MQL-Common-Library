#property strict

#include "VolumeCalculator.mqh"
#include "..\Helpers\VolumeNormalizer.mqh"
#include "..\PointsValueCalculator\AbstractPointsValueCalculator.mqh"
#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class VolumeCalculatorByRiskFromTradeStopLoss: public VolumeCalculator
{
   private:
      string m_instrument;
      AbstractPointsValueCalculator* m_stopLossInPointsCalculator;      
      double m_losPercents;
      double m_point;
      bool m_needNormalizeResult;
      DoubleValueCalculator* m_accountBalanceCalculator;
      
   public:
      VolumeCalculatorByRiskFromTradeStopLoss
      (
         AbstractPointsValueCalculator* stopLossInPointsCalculator,
         const double losPercents,
         const bool needNormalizeResult,
         DoubleValueCalculator* accountBalanceCalculator
      )
      :
         m_stopLossInPointsCalculator(stopLossInPointsCalculator),
         m_losPercents(losPercents),
         m_needNormalizeResult(needNormalizeResult),
         m_accountBalanceCalculator(accountBalanceCalculator)
      {
      }
      
      ~VolumeCalculatorByRiskFromTradeStopLoss()
      {
         delete m_stopLossInPointsCalculator;
         delete m_accountBalanceCalculator;
      }
      
      virtual void Calculate() override
      {         
         #ifdef __MQL4__
         RefreshRates();
         #endif 
         
         m_stopLossInPointsCalculator.Calculate();
         
         int stopLossInPoints = m_stopLossInPointsCalculator.GetValue();
         
         if(stopLossInPoints == 0)
         {
            m_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
            return;
         }
                  
         m_volume = 
            (
               ((m_accountBalanceCalculator.Calculate() * m_losPercents) / 100.0) 
               / 
               SymbolInfoDouble(m_instrument, SYMBOL_TRADE_TICK_VALUE)
            ) / (stopLossInPoints);
         
         if(m_needNormalizeResult)
         {
            m_volume = VolumeNormalizer::Normalize(m_instrument, m_volume);  
         }
      }
};