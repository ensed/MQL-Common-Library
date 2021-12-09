#property strict

class SignalsCheckerListAny;
#include "SignalChecker.mqh"
#include "SignalsCheckerListAny.mqh"
#include <Common Library\Profiler\MemoryPointersProfiler.mqh>

class SignalsCombinerAbstract : public SignalChecker
{
   protected:
      SignalsCheckerListAny* m_signals;

   public:
      SignalsCombinerAbstract()
         :  m_signals(new SignalsCheckerListAny(UNRELEASED_POINTERS_PROFILING_CONSTRUCTOR_PARAMETER)){}

     ~SignalsCombinerAbstract()
      {
         delete(m_signals);
      }

      virtual void Add(SignalChecker* signal)
      {
         m_signals.Add(signal);
      }
      
      SignalsCheckerListAny* getSignals()const  {return m_signals;}  //TODO: probably ugly decision
};