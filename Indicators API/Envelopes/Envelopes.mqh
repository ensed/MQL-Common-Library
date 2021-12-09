#property strict

#include "..\IndicatorAPIBase.mqh"
#include "EnvelopesParameters.mqh"


enum ENUM_ENVELOPES_LINE
{   
   ENVELOPES_LINE_UPPER = 0,
   ENVELOPES_LINE_LOWER = 1
};

#ifdef __MQL5__
class Envelopes : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      EnvelopesParameters m_parameters;
      ENUM_ENVELOPES_LINE m_line;
      int m_handle;
      
   public:
      Envelopes(const string symbol, const ENUM_TIMEFRAMES timeframe, const EnvelopesParameters &parameters, const ENUM_ENVELOPES_LINE line)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
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
         m_handle = iEnvelopes
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.Shift(), m_parameters.Method(), m_parameters.AppliedPrice(), m_parameters.Deviation()
         );
      }
};
#endif

#ifdef __MQL4__
class Envelopes : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      EnvelopesParameters m_parameters;
      
   public:
      Envelopes(const string symbol, const ENUM_TIMEFRAMES timeframe, const EnvelopesParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {		
         return iEnvelopes
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.Shift(), m_parameters.Method(), m_parameters.AppliedPrice(),
            shift
         );
      }
};
#endif