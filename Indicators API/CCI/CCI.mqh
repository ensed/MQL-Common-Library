#property strict

#include "..\IndicatorAPIBase.mqh"
#include "CCIParameters.mqh"

#ifdef __MQL5__
class CCI : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      CCIParameters m_parameters;
      int m_handle;
      
   public:
      CCI(const string symbol, const ENUM_TIMEFRAMES timeframe, const CCIParameters &parameters)
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
         m_handle = iCCI(m_symbol, m_timeframe, m_parameters.Period(), m_parameters.AppliedPrice());
      }
};
#endif

#ifdef __MQL4__
class CCI : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      CCIParameters m_parameters;
      
   public:
      CCI(const string symbol, const ENUM_TIMEFRAMES timeframe, const CCIParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {  
         return iCCI
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.AppliedPrice(), 
            shift
         );
      }
};
#endif 