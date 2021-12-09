#property strict

#include "..\IndicatorAPIBase.mqh"
#include <Generic\HashMap.mqh>
#include <Common Library\Macros\Exceptions\UnexpectedValueException.mqh>
#include <Common Library\Helpers\CHashMapHelper.mqh>

#ifdef __MQL4__
enum EnumHeikenAshiCandlePrice
{
   HeikenAshiCandlePrice_Open = 2,
   HeikenAshiCandlePrice_High = 0,
   HeikenAshiCandlePrice_Low = 1,
   HeikenAshiCandlePrice_Close = 3 
};
#endif

#ifdef __MQL5__
enum EnumHeikenAshiCandlePrice
{
   HeikenAshiCandlePrice_Open = 0,
   HeikenAshiCandlePrice_High = 1,
   HeikenAshiCandlePrice_Low = 2,
   HeikenAshiCandlePrice_Close = 3 
};
#endif 

#ifdef __MQL4__
class HeikenAshi: public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      EnumHeikenAshiCandlePrice m_candlePrice;
      
      static CHashMap<string, HeikenAshi*>* m_mappedInstances;
   public:
		HeikenAshi
		(
			const string symbol,
			const ENUM_TIMEFRAMES timeframe,
			const EnumHeikenAshiCandlePrice candlePrice
		)
		:
			m_symbol(symbol),
			m_timeframe(timeframe),
			m_candlePrice(candlePrice)
		{
      }
            
      static HeikenAshi* GetInstance // supposed to be used instead of 'new HeikenAshi()'
      (
			const string symbol,
			const ENUM_TIMEFRAMES timeframe,
			const EnumHeikenAshiCandlePrice candlePrice
      )
      {         
         const string hash = symbol + "_" + (string)timeframe + "_" + (string)candlePrice;
         HeikenAshi* result = NULL;
           
         if(!m_mappedInstances.TryGetValue(hash, result))
         {
            result = new HeikenAshi(symbol, timeframe, candlePrice);
            
            m_mappedInstances.TrySetValue(hash, result);
         }
         
         return result;
      }

		static void ReleaseInstances()
		{
		   ClearPointerValuesOfHashMap(m_mappedInstances);
		   delete m_mappedInstances;
		}
      
      double GetValue(const int shift) override
      {         
         return iCustom
         (
            m_symbol, m_timeframe, "Heiken Ashi", m_candlePrice, shift
         );
      }
      
};

CHashMap<string, HeikenAshi*>* HeikenAshi::m_mappedInstances = new CHashMap<string, HeikenAshi*>();
#endif 

#ifdef __MQL5__
class HeikenAshi: public IndicatorAPIBase
{
   private:
      string m_symbol;
      ENUM_TIMEFRAMES m_timeframe;
      EnumHeikenAshiCandlePrice m_candlePrice;
      
      int m_handle;
      bool m_handleWasSet;
      
      static CHashMap<string, int> m_mappedHandlers;
      static CHashMap<string, HeikenAshi*>* m_mappedInstances;

   public:
		HeikenAshi
		(
			const string symbol,
			const ENUM_TIMEFRAMES timeframe,
			const EnumHeikenAshiCandlePrice candlePrice
		)
		:
			m_symbol(symbol),
			m_timeframe(timeframe),
			m_candlePrice(candlePrice),
			m_handle(-1),
			m_handleWasSet(false)
		{
         InitHandle();
      }
            
      static HeikenAshi* GetInstance // supposed to be used instead of 'new HeikenAshi()'
      (
			const string symbol,
			const ENUM_TIMEFRAMES timeframe,
			const EnumHeikenAshiCandlePrice candlePrice
      )
      {         
         const string hash = symbol + "_" + (string)timeframe + "_" + (string)candlePrice;
         HeikenAshi* result = NULL;
           
         if(!m_mappedInstances.TryGetValue(hash, result))
         {
            result = new HeikenAshi(symbol, timeframe, candlePrice);
            
            m_mappedInstances.TrySetValue(hash, result);
         }
         
         return result;
      }

		static void ReleaseInstances()
		{
         ClearPointerValuesOfHashMap(m_mappedInstances);
		   delete m_mappedInstances;
		}
      
      double GetValue(const int shift) override
      {
         double value[];
         ArraySetAsSeries(value,true);
         if(CopyBuffer(m_handle, m_candlePrice, shift, 1, value)==-1)
         {
            if(_LastError == ERR_MARKET_UNKNOWN_SYMBOL)
            {
               UnexpectedValueException(m_symbol);
            }
            else if(!m_handleWasSet)
            { 
               InitHandle();
            }
         
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
         const string hash = m_symbol + "_" + (string)m_timeframe + "_" + (string)m_candlePrice;
         
         if(!m_mappedHandlers.TryGetValue(hash, m_handle))
         {   
            m_handle = iCustom
            (
               m_symbol, m_timeframe, "Examples\\Heiken_Ashi.ex5"
            );
            
            if(m_handle != INVALID_HANDLE)
            {
               m_mappedHandlers.TrySetValue(hash, m_handle);
               m_handleWasSet = true;
            }
            else if(_LastError==ERR_INDICATOR_UNKNOWN_SYMBOL)
            {
               UnexpectedValueException(m_symbol);
            } 
         }
      }
};

CHashMap<string, int> HeikenAshi::m_mappedHandlers(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER);
CHashMap<string, HeikenAshi*>* HeikenAshi::m_mappedInstances = new CHashMap<string, HeikenAshi*>(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER);
#endif 