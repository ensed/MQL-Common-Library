#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class VolumeCalculator
{
   protected:
      double m_volume;
      
   public:
      virtual void Calculate() = 0;
      
      double Get()
      {        	
         return m_volume;
      }
};