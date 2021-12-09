#property strict

//#define PROFILER_ENABLED (1)
#define PROFILER_PRINT_PERCENT

#ifdef PROFILER_ENABLED
   #define PROFILING_START_MEASURE Profiler::StartMeasure(__FILE__ + " (" + __FUNCTION__ + "), line " + (string)__LINE__);
   #define PROFILING_START_MEASURE_ID(id) Profiler::StartMeasure(__FILE__ + " (" + __FUNCTION__ + "), line " + (string)__LINE__+" "+(string)id);
   #define PROFILING_STOP_MEASURE Profiler::StopMeasure();
   #define PROFILING_NEXT PROFILING_STOP_MEASURE PROFILING_START_MEASURE 
   #define PROFILING_NEXT_ID(id) PROFILING_STOP_MEASURE PROFILING_START_MEASURE_ID(id)
   #define PROFILING_PRINT_RESULTS Profiler::PrintResults();
#else 
   #define PROFILING_START_MEASURE ;
   #define PROFILING_STOP_MEASURE ;
   #define PROFILING_NEXT ;
   #define PROFILING_PRINT_RESULTS ;   
#endif 

#include <Generic\HashMap.mqh>

class Profiler
{
   private:
      static CHashMap<string, ulong>* m_items;
      
      static ulong m_startTime;
      static string m_currenItemName;
      
   public:
      static void StartMeasure(const string itemName)
      {
         if(m_items == NULL)
         {
            m_items = new CHashMap<string, ulong>(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER);
         }
         if(!m_items.ContainsKey(itemName))
         {
            m_items.Add(itemName, 0);
         }
         
         m_startTime = GetMicrosecondCount();
         m_currenItemName = itemName;
      }
      
      static void StopMeasure()
      {
         const ulong difference = GetMicrosecondCount() - m_startTime;
         
         ulong currentValue = 0;
         
         if(m_items.TryGetValue(m_currenItemName, currentValue))
         {
            m_items.TrySetValue(m_currenItemName, currentValue + difference);
         }
      }
      
      static void PrintResults()
      {
         Print("==== PROFILER ====");
         
         string keys[];
         ulong values[];
         
         m_items.CopyTo(keys, values);
         
         #ifdef PROFILER_PRINT_PERCENT
            ulong sum = 0;
            for(int i = ArraySize(values)-1; i >= 0; i--)
            {
               sum += values[i];
            }
            for(int i = 0; i < ArraySize(keys); i++)
            {
               Print(keys[i]," \t", values[i]," \t", DoubleToString(values[i]/1./sum*100,2),"%");
            }
            Print("total: \t",sum);
         #else 
            for(int i = 0; i < ArraySize(keys); i++)
            {
               Print(keys[i]," \t", values[i]);
            }
         #endif 
      }
};

CHashMap<string, ulong>* Profiler::m_items = NULL;
ulong Profiler::m_startTime;
string Profiler::m_currenItemName;