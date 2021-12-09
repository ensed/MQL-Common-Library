#property strict

#include "..\IndicatorAPIBase.mqh"
#include "ParabolicSARParameters.mqh"


#ifdef __MQL5__
class ParabolicSAR : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      ParabolicSARParameters m_parameters;
      int m_handle;
      
   public:
      ParabolicSAR(const string symbol, const ENUM_TIMEFRAMES timeframe, const ParabolicSARParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
         
         InitHandle();
      }
      
      double GetValue(const int shift) override
      {		
         if(m_handle==INVALID_HANDLE) 
         { 
            InitHandle();
         }
         
         double value[];
         ArraySetAsSeries(value,true);
         CopyBuffer(m_handle, 0, shift, 1, value);
         
         return value[0];
      }
   private:
      void InitHandle()
      {
         m_handle = iSAR(m_symbol, m_timeframe, m_parameters.Step(), m_parameters.Maximum());
      }
};
#endif

#ifdef __MQL4__
class ParabolicSAR : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      ParabolicSARParameters m_parameters;
      
   public:
      ParabolicSAR(const string symbol, const ENUM_TIMEFRAMES timeframe, const ParabolicSARParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {		
         return iSAR
         (
            m_symbol, m_timeframe, 
            m_parameters.Step(), m_parameters.Maximum(),
            shift
         );
      }
};
#endif