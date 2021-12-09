#property strict

#include "SignalChecker.mqh"
#include "SignalsCheckerListAny.mqh"
#include "SignalsCombinerAbstract.mqh"

class SignalsCombinerAND: public SignalsCombinerAbstract
{
   public:      
      SignalsCombinerAND()
      : SignalsCombinerAbstract()
      {
      }
      
      SignalsCombinerAND(SignalChecker* signal1, SignalChecker* signal2)
      : SignalsCombinerAbstract()
      {
         m_signals.Add(signal1);
         m_signals.Add(signal2);
      }
      
      SignalsCombinerAND(SignalChecker* signal1, SignalChecker* signal2, SignalChecker* signal3)
      : SignalsCombinerAbstract()
      {
         m_signals.Add(signal1);
         m_signals.Add(signal2);
         m_signals.Add(signal3);
      }
      
      ~SignalsCombinerAND()
      {
      }
      
      virtual bool Exists() override
      {
         if(m_signals.ItemsCount() == 0)
         {
            return false;
         }

         for(int i = 0; i < m_signals.ItemsCount(); i++)
         {
            if(!m_signals[i].Exists())
            {
               return false;
            }            
         }

         return true;
      }
};