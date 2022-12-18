#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "SignalChecker.mqh"
#include "..\List\ObjectsList.mqh"
#include "SignalsCombinerAbstract.mqh"
#include <Common Library\Profiler\MemoryPointersProfiler.mqh>

class SignalsCheckerListAny : public ObjectsList<SignalChecker*>
{
   private:
      #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
      const string m_creatingPoint;
      #endif 
      
   private:
      int m_signalIndex;
      int m_prohibitIndex;
   static int numberOfInstnces;
      int m_instanceID;      
   
   public:
      SignalsCheckerListAny
      (
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         const string creatingPoint
         #endif 
      )
      #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
      :
         m_creatingPoint(creatingPoint)
      #endif 
      {     
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         if(CheckPointer(&this) == POINTER_DYNAMIC)
         {
            MemoryPointersProfiler::AddMemoryPointerProfilerItem(creatingPoint, typename(this));
         }
         #endif    
         m_instanceID=++numberOfInstnces;
         m_signalIndex = -1;
         m_prohibitIndex = -1;
      }
      
      SignalsCheckerListAny
      (
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         const string creatingPoint,
         #endif 
         SignalChecker* item
      )
      #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
      :
         m_creatingPoint(creatingPoint)
      #endif 
      {
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         if(CheckPointer(&this) == POINTER_DYNAMIC)
         {
            MemoryPointersProfiler::AddMemoryPointerProfilerItem(creatingPoint, typename(this));
         }
         #endif
         m_instanceID=++numberOfInstnces;
         Add(item);
      }   

      SignalsCheckerListAny(SignalChecker* item1, SignalChecker* item2)
      :
         ObjectsList(item1, item2)
      {
      }

      SignalsCheckerListAny(SignalChecker* item1, SignalChecker* item2, SignalChecker* item3)
      :
         ObjectsList(item1, item2, item3)
      {
      }
      
      SignalsCheckerListAny
      (
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         const string creatingPoint,
         #endif 
         SignalChecker* &items[]
      )
      #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
      :
         m_creatingPoint(creatingPoint)
      #endif 
      {
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         if(CheckPointer(&this) == POINTER_DYNAMIC)
         {
            MemoryPointersProfiler::AddMemoryPointerProfilerItem(creatingPoint, typename(this));
         }
         #endif
         m_instanceID=++numberOfInstnces;
         Add(items);
      }   
      
      ~SignalsCheckerListAny()
      {
         #ifdef UNRELEASED_POINTERS_PROFILING_ENABLED
         if(CheckPointer(&this) == POINTER_DYNAMIC)
         {
            MemoryPointersProfiler::ReleaseMemoryPointerProfilerItem(m_creatingPoint, typename(this));
         }
         #endif 
      }
         
      int GetItemsCount()
      {
         return ItemsCount();
      }
      bool ExistsAny()
      {
         for(int i = 0; i < ItemsCount(); i++)
         {
            if(CheckPointer(this[i]) == POINTER_INVALID)
            {
               continue;
            }

            if(this[i].Exists())
            {
               m_signalIndex = i;
               return true;
            }
         }
         
         m_signalIndex = -1;
         return false;
      }
      
      int GetSignalIndex()
      {
         return m_signalIndex;
      }
      
      bool ProhibitsAny()
      {
         for(int i = ItemsCount()-1; i>=0; i--)
         {
            if(CheckPointer(this[i]) == POINTER_INVALID)
            {
               continue;
            }
            SignalsCombinerAbstract *combiner=dynamic_cast<SignalsCombinerAbstract*>(this[i]);
            if(CheckPointer(combiner) != POINTER_INVALID)
            {
               SignalsCheckerListAny *inner = combiner.getSignals();
               if(inner.ProhibitsAny())
               {
                  m_prohibitIndex = i;
                  return true;
               }
            }
            else
            if(this[i].ProhibitsAny())
            {
               m_prohibitIndex = i;
               return true;
            }
         }
         
         m_prohibitIndex = -1;
         return false;
      }
      
      int GetProhibitIndex()
      {
         return m_prohibitIndex;
      }
};
int SignalsCheckerListAny::numberOfInstnces=0;