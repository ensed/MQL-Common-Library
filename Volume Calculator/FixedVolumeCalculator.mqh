#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "VolumeCalculator.mqh"

class FixedVolumeCalculator : public VolumeCalculator
{     
   public:
      FixedVolumeCalculator(const double volume)
      {
         m_volume = volume;
      }
      
      virtual void Calculate() override
      {
         ;
      }      
};