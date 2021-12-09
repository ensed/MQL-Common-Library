#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "VolumeCalculator.mqh"
#include "..\Helpers\VolumeNormalizer.mqh"
#include <Common Library\Value Calculator\DoubleValueCalculator.mqh>

class VolumeCalculatorByPercentsOfFreeMargin: public VolumeCalculator
{
   private:
      string m_instrument;
      double m_percentValue;
      bool m_needNormalizeResult;
      DoubleValueCalculator* m_accountMarginFreeCalculator;

   public:
		VolumeCalculatorByPercentsOfFreeMargin
		(
			const string instrument,
			const double percentValue,
         const bool needNormalizeResult,
         DoubleValueCalculator* accountMarginFreeCalculator
		)
		:
			m_instrument(instrument),
			m_percentValue(percentValue),
			m_needNormalizeResult(needNormalizeResult),
			m_accountMarginFreeCalculator(accountMarginFreeCalculator)
		{
		}
		
		~VolumeCalculatorByPercentsOfFreeMargin()
		{
		   delete m_accountMarginFreeCalculator;
		}
		
      virtual void Calculate() override
      {
         m_volume = (m_accountMarginFreeCalculator.Calculate() / 100.0) * m_percentValue;
         
         if(m_needNormalizeResult)
         {
            m_volume = VolumeNormalizer::Normalize(m_instrument, m_volume);                  
         }
      }
};