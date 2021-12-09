#property strict

#include "EntryProcessor.mqh"

#include "..\VirtualClosers\HidderSL.mqh"
#include "..\Trading Controllers\OrderOpener.mqh"
#include "..\Trading Controllers\OrderModifier.mqh"
#include "..\Modifiable Value Calculator\StopLossCalculatorFixed.mqh"
#include "..\Signal Checker\SignalCheckerAlwaysTrue.mqh"

class EntryTradeWithVirtualStopLossProcessor : public EntryProcessor
{
   private:
      double m_price;
      int m_digits;
      
   public:
      EntryTradeWithVirtualStopLossProcessor
      (
         const string instrument,
         const EnumOrderType type, 
         const int magic, 
         const string comment,
         const int maxDeviation,
         FiltersList* filters,
         ModifiableValueCalculator* stopLossCalculator,
         ModifiableValueCalculator* takeProfitCalculator,
         VolumeCalculator* volumeCalculator,
         const double price = 0.0
      ) 
      : EntryProcessor
      (
         instrument, magic, type, comment, maxDeviation, 
         new SignalsCheckerListAny(new SignalCheckerAlwaysTrue()), 
         filters, stopLossCalculator, takeProfitCalculator, volumeCalculator
      )
      {
         m_instrument = instrument;
         m_type = type;
         m_magic = magic;
         m_comment = comment;
         m_price = price;
         m_digits = (int)SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
      }
      
      EntryTradeWithVirtualStopLossProcessor
      (
         const string instrument,
         const EnumOrderType type, 
         const int magic, 
         const string comment,
         const int maxDeviation,
         FiltersList* filters,
         ModifiableValueCalculator* stopLossCalculator,
         ModifiableValueCalculator* takeProfitCalculator,
         const double price = 0.0
      ) 
      : EntryProcessor
      (
         instrument, magic, type, comment, maxDeviation, 
         new SignalsCheckerListAny(new SignalCheckerAlwaysTrue()), 
         filters, stopLossCalculator, takeProfitCalculator, NULL
      )
      {
         m_instrument = instrument;
         m_type = type;
         m_magic = magic;
         m_comment = comment;
         m_price = price;
      }
      
      virtual void OnExecute() override
      {
         if(m_volumeCalculator != NULL)
         {
            m_volumeCalculator.Calculate();
            m_volume = m_volumeCalculator.Get();
         }

         OrderOpener opener(m_instrument, m_type, m_magic, m_volume, m_comment, m_slippage, m_price);
         
         long ticket = opener.Open();         
         
         if(ticket != -1)
         {
            double priceOpen = 0.0;
            
            #ifdef __MQL4__
            if(OrderSelect((int)ticket, SELECT_BY_TICKET))
            {
               priceOpen = OrderOpenPrice();
            }
            #endif
            
            #ifdef __MQL5__
            if(PositionSelectByTicket(ticket))
            {
               priceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
            }
            #endif            
            
            double sl = m_stopLossCalculator.Calculate(m_type, priceOpen);            
            double tp = m_takeProfitCalculator.Calculate(m_type, priceOpen);
            if
            (
               NormalizeDouble(sl, m_digits) == NormalizeDouble(0.0, m_digits)
               && NormalizeDouble(tp, m_digits) == NormalizeDouble(0.0, m_digits)
            )
            {
               return;
            }
            
            OrderModifier modifier((int)ticket, m_slippage, sl, tp);
            
            if(!modifier.Modify())
            {
               #ifdef __MQL4__
               if(modifier.ErrorCode() == ERR_INVALID_STOPS)
               #endif 
               
               #ifdef __MQL5__
               if(modifier.ErrorCode() == TRADE_RETCODE_INVALID_STOPS)
               #endif 
               {
                  Print
                  (
                     __FILE__, ", "__FUNCTION__ ", line ", __LINE__,
                     ": stop loss is too close to the current price, will be used virtual stop loss"
                  );
                  
                  CHidderSL::UpdateSL((int)ticket, sl);
               }
            }
         }         
      }
};