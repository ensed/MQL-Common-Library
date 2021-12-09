#property strict

#include "SignalChecker.mqh"
#include "SignalsCheckerListAny.mqh"
#include "SignalsCombinerAbstract.mqh"

class SignalsCombinerOR: public SignalsCombinerAbstract
{
   public:      
      SignalsCombinerOR()
      : SignalsCombinerAbstract()
      {
      }
      
      SignalsCombinerOR(SignalChecker* signal1, SignalChecker* signal2)
      : SignalsCombinerAbstract()
      {
         m_signals.Add(signal1);
         m_signals.Add(signal2);
      }
      
      SignalsCombinerOR(SignalChecker* signal1, SignalChecker* signal2, SignalChecker* signal3)
      : SignalsCombinerAbstract()
      {
         m_signals.Add(signal1);
         m_signals.Add(signal2);
         m_signals.Add(signal3);
      }
      
      ~SignalsCombinerOR()
      {
      }
      
      virtual bool Exists() override
      {
         for(int i = 0; i < m_signals.ItemsCount(); i++)
         {
            if(m_signals[i].Exists())
            {
               return true;
            }            
         }

         return false;
      }
};