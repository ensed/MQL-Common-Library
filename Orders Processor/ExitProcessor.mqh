#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#ifdef __MQL4__
#property strict
#endif

#include "OrdersProcessor.mqh"
#include "..\Modifiable Value Calculator\ModifiableValueCalculator.mqh"
#include "..\Helpers\ArraysHelper.mqh"
#include "..\Trading Controllers\OrdersCloser.mqh"

class ExitProcessor : public OrdersProcessor
{
   protected:
      string m_instrument;
      int m_magics[];
      int m_slippage;
      
   public:
      ExitProcessor
      (
         const string instrument,
         const int magic,
         const int slippage,
         FiltersList* filters
      )
      : OrdersProcessor(filters)
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic, m_magics ADD_TO_ARRAY_TRACING_CALLER);
         m_slippage = slippage;
      }
      
      ExitProcessor
      (
         const string instrument,
         const int magic1,
         const int magic2,
         const int slippage,
         FiltersList* filters
      )
      : OrdersProcessor(filters)
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic1, m_magics ADD_TO_ARRAY_TRACING_CALLER);
         ArraysHelper::AddToArray(magic2, m_magics ADD_TO_ARRAY_TRACING_CALLER);
         m_slippage = slippage;
      }  
      
      ExitProcessor
      (
         const string instrument,
         const int &magics[],
         const int slippage,
         FiltersList* filters
      )
      : OrdersProcessor(filters)
      {
         m_instrument = instrument;
         ArraysHelper::CopyArray(magics, m_magics);
         m_slippage = slippage;
      }
};