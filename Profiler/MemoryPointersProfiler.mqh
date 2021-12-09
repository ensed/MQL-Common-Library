#include <Common Library\Helpers\ArraysHelper.mqh>

//#define UNRELEASED_POINTERS_PROFILING_ENABLED (1)

#ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
   #define UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER __FILE__ + " " + (string)__LINE__
   #define UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER_WITH_COMMA __FILE__ + " " + (string)__LINE__,
   #define UNRELEASED_POINTERS_PROFILING_PRINT_RESULTS MemoryPointersProfiler::PrintUnreleasedPointers()
#else 
   #define UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER 
   #define UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER_WITH_COMMA  
   #define UNRELEASED_POINTERS_PROFILING_PRINT_RESULTS  
#endif 
         
struct MemoryPointersProfilerItem
{
   public:
      MemoryPointersProfilerItem()
      :
         CreatingPoint(""),
         NameOfType(""),
         Instances(0)
      {
      }

      MemoryPointersProfilerItem(const string creatingPoint, const string nameOfType)
      :
         CreatingPoint(creatingPoint),
         NameOfType(nameOfType),
         Instances(1)
      {
      }
      
      string CreatingPoint;
      string NameOfType;
      int Instances;
      
      bool operator ==(const MemoryPointersProfilerItem &node) const
      {
         return CreatingPoint == node.CreatingPoint;
      }
};
                  
class MemoryPointersProfiler
{
   private:
      static MemoryPointersProfilerItem m_memoryPointerProfilerItems[];
   
   public:
      static void AddMemoryPointerProfilerItem(const string creatingPoint, const string nameOfType)
      {
         MemoryPointersProfilerItem item(creatingPoint, nameOfType);
         int itemIndex = ArraysHelper::ItemIndex(item, m_memoryPointerProfilerItems);
         if(itemIndex == -1)
         {
            ArraysHelper::AddToArray(item, m_memoryPointerProfilerItems ADD_TO_ARRAY_TRACING_CALLER);
         }
         else
         {
            m_memoryPointerProfilerItems[itemIndex].Instances++;
         }
      }
   
      static void ReleaseMemoryPointerProfilerItem(const string creatingPoint, const string nameOfType)
      {
         MemoryPointersProfilerItem item(creatingPoint, nameOfType);
         item.Instances = 0;
         int itemIndex = ArraysHelper::ItemIndex(item, m_memoryPointerProfilerItems);
         if(itemIndex == -1)
         {
            ArraysHelper::AddToArray(item, m_memoryPointerProfilerItems ADD_TO_ARRAY_TRACING_CALLER);
         }
         else
         {
            m_memoryPointerProfilerItems[itemIndex].Instances--;
         }
      }
      
      static void PrintUnreleasedPointers()
      {
         Print("*** UNRELEASED POINTERS PROFILER ***");   
         int count = 0;      
         for(int i = 0; i < ArraySize(m_memoryPointerProfilerItems); i++)
         {
            if(m_memoryPointerProfilerItems[i].Instances > 0)
            {
               Print("Unreleased '", m_memoryPointerProfilerItems[i].NameOfType,"' pointer(s) created at ", m_memoryPointerProfilerItems[i].CreatingPoint,", cnt = ", m_memoryPointerProfilerItems[i].Instances);
               count++;
            }
         }
         if(count == 0)
         {
            Print("There are no unreleased pointers");
         }
         else
         {
            Print("There are ", count, " places where were created unreleased pointers");
         }
      }
};

MemoryPointersProfilerItem MemoryPointersProfiler::m_memoryPointerProfilerItems[];