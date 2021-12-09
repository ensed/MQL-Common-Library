#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "SignalChecker.mqh"

class SignalCheckerAlwaysTrue: public SignalChecker
{
   public:
      virtual bool Exists() override
      {
         return true;
      }

};