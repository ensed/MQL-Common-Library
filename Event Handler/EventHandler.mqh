#ifdef __MQL4__
#property strict
#endif

#include "EventArgs.mqh"

class EventHandler: public CObject
{      
   public:      
      virtual void Handle(EventArgs* eventArgs) = 0;
};