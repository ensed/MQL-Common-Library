#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include <PipsMasters Library\Enums\EnumSignalDirection.mqh>   //common references to implementation :(

class SignalChecker
{
   public:
      virtual bool Exists() = 0;

      virtual bool ProhibitsAny()
      {
         return false;
      }

      virtual string TypeName() const
      {
         return typename(this);
      }
      
};