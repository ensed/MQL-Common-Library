#property strict

#include "VolumeCalculator.mqh"
#include "..\Helpers\VolumeNormalizer.mqh"

class VolumeCalculatorWithNormalization: public VolumeCalculator
{
   private:
      string m_instrument;
      VolumeCalculator* m_volumeCalculator;
   
   public:
		VolumeCalculatorWithNormalization
		(
			const string instrument,
			VolumeCalculator* volumeCalculator
		)
		:
			m_instrument(instrument),
			m_volumeCalculator(volumeCalculator)
		{
		}
		
		~VolumeCalculatorWithNormalization()
		{
		   delete m_volumeCalculator;
		}
		
      virtual void Calculate() override
      {
         m_volumeCalculator.Calculate();
         
         m_volume = VolumeNormalizer::Normalize(m_instrument, m_volumeCalculator.Get());
      }
};