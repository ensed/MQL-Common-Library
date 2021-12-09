#property strict

#include "..\IndicatorAPIBase.mqh"
#include "StochasticParameters.mqh"

#ifdef __MQL5__
class Stochastic : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      StochasticParameters m_parameters;
      int m_handle;
      
   public:
      Stochastic(const string symbol, const ENUM_TIMEFRAMES timeframe, const StochasticParameters &parameters)
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
         CopyBuffer(m_handle, m_parameters.Mode(), shift, 1, value);
         
         return value[0];
      }
   private:
      void InitHandle()
      {
         m_handle = iStochastic
         (
            m_symbol, m_timeframe, 
            m_parameters.KPeriod(), m_parameters.DPeriod(), m_parameters.Slowing(), 
            m_parameters.Method(), m_parameters.Price()
         );
      }
};
#endif

#ifdef __MQL4__
class Stochastic : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      StochasticParameters m_parameters;
      
   public:
      Stochastic(const string symbol, const ENUM_TIMEFRAMES timeframe, const StochasticParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {
         return iStochastic
         (
            m_symbol, m_timeframe, 
            m_parameters.KPeriod(), m_parameters.DPeriod(), m_parameters.Slowing(), 
            m_parameters.Method(), m_parameters.Price(), m_parameters.Mode(),
            shift
         );
      }
};
#endif