#ifdef __MQL4__
#property strict
#endif

// A base class for a trailing stop losses
class TrailingStopLoss
{
   public:
      virtual void Proceed() = 0;
};
