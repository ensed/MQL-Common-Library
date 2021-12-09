#property strict

#include "..\IndicatorAPIBase.mqh"
#include "ZigZagParameters.mqh"

#ifdef __MQL5__
class ZigZag: public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      ZigZagParameters m_parameters;
      
      int m_handle;
      
   public:
      ZigZag(const string symbol, const ENUM_TIMEFRAMES timeframe, const ZigZagParameters &parameters)
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
         
         if(ArraySize(value) == 0)
         {
            return EMPTY_VALUE;
         }
         else
         {
            return value[0];         
         }
      }
      
   private:
      void InitHandle()
      {
         m_handle = iCustom
         (
            m_symbol, m_timeframe, "Examples\\ZigZag",
            m_parameters.InpDepth(), m_parameters.InpDeviation(), m_parameters.InpBackstep()
         );
      }
};
#endif 

#ifdef __MQL4__
class ZigZag: public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      ZigZagParameters m_parameters;
      
   public:
      ZigZag(const string symbol, const ENUM_TIMEFRAMES timeframe, const ZigZagParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {
         return iCustom
         (
            m_symbol, m_timeframe, "ZigZag",
            m_parameters.InpDepth(), m_parameters.InpDeviation(), m_parameters.InpBackstep(),
            0, shift
         );
      }
};
#endif 