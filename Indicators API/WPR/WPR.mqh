#property strict

#include "..\IndicatorAPIBase.mqh"
#include "WPRParameters.mqh"

#ifdef __MQL5__
class WPR : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      WPRParameters m_parameters;
      
      int m_handle;
      
   public:
      WPR(const string symbol, const ENUM_TIMEFRAMES timeframe, const WPRParameters &parameters)
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
         m_handle = iWPR(m_symbol, m_timeframe, m_parameters.Period());
      }
};
#endif

#ifdef __MQL4__
class WPR : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      WPRParameters m_parameters;
      
   public:
      WPR(const string symbol, const ENUM_TIMEFRAMES timeframe, const WPRParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      WPR(const string symbol, const ENUM_TIMEFRAMES timeframe, const int wprPeriod)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters.Period(wprPeriod);
      }
      
      double GetValue(const int shift) override
      {  
         return iWPR
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(),
            shift
         );
      }
};
#endif