#ifdef __MQL4__
#property strict
#endif 

enum EnumNormalizationRoundingType
{
   ENM_NORMALIZATION_DOWN_DEFAULT = 0, //down - DEFAULT
   ENM_NORMALIZATION_UP           = 1, //up
   ENM_NORMALIZATION_ND           = 2, //NormalizeDouble
};

class VolumeNormalizer
{
   public:
      static double MinStep(const string instrument)
      {
         return SymbolInfoDouble(instrument, SYMBOL_VOLUME_MIN);
      }
      static double Normalize(const string instrument, const double volumeValue,const EnumNormalizationRoundingType roundMode=0)
      {        
         double volumeStep = SymbolInfoDouble(instrument, SYMBOL_VOLUME_STEP);
         double volumeMin = SymbolInfoDouble(instrument, SYMBOL_VOLUME_MIN);
         double volumeMax = SymbolInfoDouble(instrument, SYMBOL_VOLUME_MAX);
         	
         return Normalize(volumeValue, volumeStep, volumeMin, volumeMax, roundMode);
      }
      
      static double Normalize
      ( 
         const double volumeValue, 
         const double volumeStep, 
         const double volumeMin, 
         const double volumeMax,
         const EnumNormalizationRoundingType roundMode
      )
      {
         double result = volumeValue;
         
         if(volumeStep == 0.1)
         {
            result = NormalizeDouble(result, 1);
         }
         else if(volumeStep == 0.01)
         {
            result = NormalizeDouble(result, 2);
         } 
         else if(volumeStep == 0.001)
         {
            result = NormalizeDouble(result, 3);
         }
         
         switch(roundMode)
         {
            case ENM_NORMALIZATION_DOWN_DEFAULT: 
               result = MathFloor(result / volumeStep) * volumeStep;
               break;
            case ENM_NORMALIZATION_UP:
               result = MathCeil(result / volumeStep) * volumeStep;
               break;
            case ENM_NORMALIZATION_ND:
      	      result = NormalizeDouble(result / volumeStep, 0) * volumeStep;
               break;
         }
      	result = MathMin(result, volumeMax);	
      	result = MathMax(result, volumeMin);
         
         return result;
      }
};