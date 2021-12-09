#ifdef __MQL4__
#property strict
#endif

#include "TrailingStopLoss.mqh"

// The empty trailing stop loss class
class TrailingStopLossEmpty : public TrailingStopLoss
{
   public:
      virtual void Proceed() override final
      {
         ;
      }
};