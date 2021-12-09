#property strict

#include "..\IndicatorAPIBase.mqh"

enum ENUM_RVI_LINE
{
   RVI_LINE_MAIN, // Main
   RVI_LINE_SIGNAL // Signal
};


#ifdef __MQL5__
class RVI : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      int m_period;
      ENUM_RVI_LINE m_line;
      int m_handle;
      
   public:
      RVI(const string symbol, const ENUM_TIMEFRAMES timeframe, const int period, ENUM_RVI_LINE line)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_period = period;
         m_line = line;
         
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
         CopyBuffer(m_handle, m_line, shift, 1, value);
         
         return value[0];
      }
   private:
      void InitHandle()
      {
         m_handle = iRVI(m_symbol, m_timeframe, m_period);
      }
};
#endif 

#ifdef __MQL4__
class RVI : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      RVIParameters m_parameters;
      
   public:
      RVI(const string symbol, const ENUM_TIMEFRAMES timeframe, const RVIParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {  
         return iRVI
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_line,
            shift
         );
      }
};
#endif 