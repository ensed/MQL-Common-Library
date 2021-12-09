#property strict

#include "..\IndicatorAPIBase.mqh"
#include "MAParameters.mqh"


#ifdef __MQL5__
class MA : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      MAParameters m_parameters;
      int m_handle;
      
   public:
      MA(const string symbol, const ENUM_TIMEFRAMES timeframe, const MAParameters &parameters)
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
         m_handle = iMA(m_symbol, m_timeframe, m_parameters.Period(), m_parameters.Shift(), m_parameters.Method(), m_parameters.AppliedPrice());
      }
};
#endif

#ifdef __MQL4__
class MA : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      MAParameters m_parameters;
      
   public:
      MA(const string symbol, const ENUM_TIMEFRAMES timeframe, const MAParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {		
         return iMA
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.Shift(), m_parameters.Method(), m_parameters.AppliedPrice(),
            shift
         );
      }
};
#endif