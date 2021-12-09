#property strict

#include "..\IndicatorAPIBase.mqh"

#ifdef __MQL5__
class ATR: public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      int m_period;
      
      int m_handle;
      
   public:
      ATR(const string symbol, const ENUM_TIMEFRAMES timeframe, const int period)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_period = period;
         
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
      
      int GetValueInPips(const int shift)
      {
         double value = GetValue(shift);
                  
         
         int digits = (int)SymbolInfoInteger(m_symbol, SYMBOL_DIGITS);
         double pip = SymbolInfoDouble(m_symbol, SYMBOL_POINT) * ((digits == 3 || digits == 5) ? 10.0 : 1.0);
         
         return (int)(value / pip);
      }
      
   private:
      void InitHandle()
      {
         m_handle = iATR(m_symbol, m_timeframe, m_period);
      }
};
#endif

#ifdef __MQL4__
class ATR: public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      int m_period;
      
   public:
      ATR(const string symbol, const ENUM_TIMEFRAMES timeframe, const int period)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_period = period;
      }
      
      double GetValue(const int shift) override
      {
         return iATR(m_symbol, m_timeframe, m_period, shift);
      }
      
      int GetValueInPips(const int shift)
      {
         double value = GetValue(shift);
                  
         
         int digits = (int)SymbolInfoInteger(m_symbol, SYMBOL_DIGITS);
         double pip = SymbolInfoDouble(m_symbol, SYMBOL_POINT) * ((digits == 3 || digits == 5) ? 10.0 : 1.0);
         
         return (int)(value / pip);
      }
};
#endif