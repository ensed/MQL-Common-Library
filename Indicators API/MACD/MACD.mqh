#property strict

#include "..\IndicatorAPIBase.mqh"
#include "MACDParameters.mqh"

#ifdef __MQL5__
class MACD : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      MACDParameters m_parameters;
      int m_handle;
      
   public:
      MACD(const string symbol, const ENUM_TIMEFRAMES timeframe, const MACDParameters &parameters)
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
         CopyBuffer(m_handle, m_parameters.Line(), shift, 1, value);
         
         return value[0];
      }
   private:
      void InitHandle()
      {
         m_handle = iMACD
         (
            m_symbol, m_timeframe, 
            m_parameters.FastEMAPeriod(), m_parameters.SlowEMAPeriod(), m_parameters.SignalPeriod(), m_parameters.AppliedPrice()
         );
      }
};
#endif

#ifdef __MQL4__
class MACD : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      MACDParameters m_parameters;
      
   public:
      MACD(const string symbol, const ENUM_TIMEFRAMES timeframe, const MACDParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {
         return iMACD
         (
            m_symbol, m_timeframe, 
            m_parameters.FastEMAPeriod(), 
            m_parameters.SlowEMAPeriod(), 
            m_parameters.SignalPeriod(), 
            m_parameters.AppliedPrice(), 
            m_parameters.Line(), 
            shift
         );
      }
};
#endif