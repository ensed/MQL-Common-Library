#property strict

#include "..\IndicatorAPIBase.mqh"

enum EnumADXLine
{
   ADXLine_Main = 0, // Main
   ADXLine_PlusDI = 1, // +DI
   ADXLine_MinusDI = 2 // -DI
};


#ifdef __MQL5__
class ADX : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      int m_period;
      EnumADXLine m_line;
      int m_handle;
      
   public:
      ADX(const string symbol, const ENUM_TIMEFRAMES timeframe, const int period, EnumADXLine line)
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
         m_handle = iADX(m_symbol, m_timeframe, m_period);
      }
};
#endif 

#ifdef __MQL4__
#include "ADXParameters.mqh"

class ADX : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      ADXParameters m_parameters;
      EnumADXLine m_line;
      
   public:
      ADX(const string symbol, const ENUM_TIMEFRAMES timeframe, const ADXParameters &parameters, const EnumADXLine line)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
         m_line = line;
      }
      
      double GetValue(const int shift) override
      {  
         return iADX
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.AppliedPrice(), 
            (int)m_line, shift
         );
      }
};
#endif 