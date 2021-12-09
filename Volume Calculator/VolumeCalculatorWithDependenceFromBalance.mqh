#property strict

#include "VolumeCalculator.mqh"
#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class VolumeCalculatorWithDependenceFromBalance : public VolumeCalculator
{     
   private:
      string m_instrument;
      double m_volumeBalancePortion;
      double m_volumeStep;
      DoubleValueCalculator* m_accountBalanceCalculator;
      
   public:
      VolumeCalculatorWithDependenceFromBalance
      (
         const string instrument,
         const double volumeBalancePortion,
         const double volumeStep,
         DoubleValueCalculator* accountBalanceCalculator
      )
      :
         m_accountBalanceCalculator(accountBalanceCalculator)
      {
         m_instrument = instrument;
         m_volumeBalancePortion = volumeBalancePortion;
         m_volumeStep = volumeStep;
      }
      
      ~VolumeCalculatorWithDependenceFromBalance()
      {
         delete m_accountBalanceCalculator;
      }
      
      virtual void Calculate() override
      {
         m_volume = MathFloor(m_accountBalanceCalculator.Calculate() / m_volumeBalancePortion) * m_volumeStep;
         
         double volumeStep = SymbolInfoDouble(m_instrument, SYMBOL_VOLUME_STEP);                       
      	m_volume = MathRound(m_volume / volumeStep) * volumeStep;
      	m_volume = MathMin(m_volume, SymbolInfoDouble(m_instrument, SYMBOL_VOLUME_MAX));	
      	m_volume = MathMax(m_volume, SymbolInfoDouble(m_instrument, SYMBOL_VOLUME_MIN));
      }      
};