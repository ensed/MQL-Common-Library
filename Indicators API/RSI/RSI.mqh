#property strict

#include "..\IndicatorAPIBase.mqh"
#include "RSIParameters.mqh"
#include <Common Library\Macros\Exceptions\UnexpectedValueException.mqh>

class RSI : public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      RSIParameters m_parameters;
#ifdef __MQL5__
      int m_handle;
#endif 
      
   public:
      string            Symbol()const  {return m_symbol;                }
      ENUM_TIMEFRAMES   TF()const      {return m_timeframe;             }
      RSIParameters    Parameters()   {return m_parameters;}
      
      RSI
      (
         const string symbol,
         const ENUM_TIMEFRAMES timeframe,
         const RSIParameters &parameters
      )
      :
         m_symbol(symbol),
         m_timeframe(timeframe),
         m_parameters(parameters)
      {
#ifdef __MQL5__
         m_handle=-1;
         InitHandle();
#endif 
      }      

      double GetValue(const int shift) override
      {
         double result;
#ifdef __MQL5__
         if(m_handle==INVALID_HANDLE) 
         { 
            InitHandle();
         }
         
         double value[];
         ArraySetAsSeries(value,true);
         if(CopyBuffer(m_handle, 0, shift, 1, value)==-1)
         {
            printf("%i %s: error when copying buffer=%d&index=%d&symbol=%s. error=%d",__LINE__,__FILE__,
                  0, shift, m_symbol, _LastError);
            return EMPTY_VALUE;
         }
         result=value[0];
#else 
         result=iRSI
         (
            m_symbol,
            m_timeframe,
            m_parameters.Period(),
            m_parameters.AppliedPrice(),
            shift
         );
#endif

         #ifdef DEBUG_HERE
            printf("%i %s DEBUG: shift=%d,tf=%d, param=[%d&%.2f] -> %.3f",__LINE__,__FILE__,shift,
                     PeriodSeconds(m_timeframe),m_range,m_filter,result);
         #endif 

         return result;
      }
private:
#ifdef __MQL5__
      void InitHandle()
      {
         m_handle = iRSI
         (
            m_symbol, m_timeframe,
            m_parameters.Period(), m_parameters.AppliedPrice()
         );
         if(m_handle != INVALID_HANDLE)
         {
         }
         else if(_LastError==ERR_INDICATOR_UNKNOWN_SYMBOL)
         {
            UnexpectedValueException(m_symbol);
         }
      }
#endif 

};