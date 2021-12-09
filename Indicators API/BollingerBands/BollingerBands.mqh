#property strict

#include "..\IndicatorAPIBase.mqh"
#include "BollingerBandsParameters.mqh"

enum ENUM_BANDS_LINE
{   
   BANDS_LINE_BASE = 0,
   BANDS_LINE_UPPER = 1,
   BANDS_LINE_LOWER = 2
};

#ifdef __MQL5__
class BollingerBands : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      BollingerBandsParameters m_parameters;
      ENUM_BANDS_LINE m_line;
      
      int m_handle;
      
   public:
      BollingerBands(const string symbol, const ENUM_TIMEFRAMES timeframe, const BollingerBandsParameters &parameters, const ENUM_BANDS_LINE line)
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
         m_handle = iBands(m_symbol, m_timeframe, m_parameters.BandsPeriod(), m_parameters.BandsShift(), m_parameters.Deviation(), m_parameters.AppliedPrice());
      }
};
#endif

#ifdef __MQL4__
class BollingerBands : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      BollingerBandsParameters m_parameters;
      
   public:
      BollingerBands(const string symbol, const ENUM_TIMEFRAMES timeframe, const BollingerBandsParameters &parameters)
      {
         m_symbol = symbol;
         m_timeframe = timeframe;
         m_parameters = parameters;
      }
      
      double GetValue(const int shift) override
      {		
         return iBollingerBands
         (
            m_symbol, m_timeframe, 
            m_parameters.Period(), m_parameters.Shift(), m_parameters.Method(), m_parameters.AppliedPrice(),
            shift
         );
      }
};
#endif