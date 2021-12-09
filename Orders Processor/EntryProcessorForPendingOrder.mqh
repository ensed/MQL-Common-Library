#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "EntryProcessor.mqh"
#include "..\Trading Controllers\OrderOpener.mqh"
#include "..\Trading Controllers\OrderModifier.mqh"
#include "..\ValueCalculator\DoubleValueCalculator.mqh"

class EntryProcessorForPendingOrder : public EntryProcessor
{
   protected:     
      DoubleValueCalculator* m_priceOpenCalculator;
      
   public:
      EntryProcessorForPendingOrder
      (
         const string instrument,
         const int magic,
         const EnumOrderType type,
         DoubleValueCalculator* priceOpenCalculator,
         const string comment,
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters,
         ModifiableValueCalculator* stopLossCalculator,
         ModifiableValueCalculator* takeProfitCalculator,
         VolumeCalculator* volumeCalculator
      )
      : EntryProcessor
      (
         instrument, magic, type, comment, slippage,
         signalsCheckers, filters, stopLossCalculator, takeProfitCalculator, volumeCalculator
      )
      {
         m_priceOpenCalculator = priceOpenCalculator;
      }
      
      ~EntryProcessorForPendingOrder()
      {
         PointersReleaser::Release(m_priceOpenCalculator);
      }
      
   protected:
      void OnExecute() override
      {        
         if(m_signalsCheckers.ExistsAny())
         {
            m_volumeCalculator.Calculate();
            OrderOpener opener
            (
               m_instrument, 
               m_type, m_magic, 
               m_volumeCalculator.Get(), 
               m_comment, 
               m_slippage, 
               m_priceOpenCalculator.Calculate()
            );

            int ticket = opener.Open();
            
            bool tradeWasOpen = false;
            double priceOpen = 0.0;
            
            if(ticket != -1)
            {
               for(int i = 0; i < 10; i++)
               {
                  #ifdef __MQL5__
                  if(OrderSelect((ulong)ticket))
                  {    
                     tradeWasOpen = true;
                     priceOpen = OrderGetDouble(ORDER_PRICE_OPEN);
                     break;
                  }
                  #endif 
                  
                  #ifdef __MQL4__
                  if(OrderSelect(ticket, SELECT_BY_TICKET))
                  {
                     tradeWasOpen = true;
                     priceOpen = OrderOpenPrice();
                     break;
                  }
                  #endif
                  
                  Sleep(500); 
               }
            }
            else
            {
               MarketError me(opener.ErrorCode());
               Print("Error: ", __FILE__, " ", __FUNCTION__, ": ", me.ToString());
            }
            
            double stopLoss = m_stopLossCalculator.Calculate(m_type, priceOpen);
            double takeProfit = m_takeProfitCalculator.Calculate(m_type, priceOpen);
            
            if(
               NormalizeDouble(stopLoss, 8) != NormalizeDouble(0.0, 8) 
               || NormalizeDouble(takeProfit, 8) != NormalizeDouble(0.0, 8)
            )
            {
               if
               (
                  tradeWasOpen
               )
               {
                  OrderModifier orderModifier(ticket, m_slippage, stopLoss, takeProfit);                  
                  orderModifier.Modify();
               }
               else if(ticket != -1)
               {
                  Print("Error: ", __FILE__, " ", __FUNCTION__, ": can't select trade with ticket ", ticket);
               }
            }
            
            if(ticket != -1)
            {
               OrderInfo order;
               order.InitByTicket(ticket);
               
               EntrySuccessEventArgs* args = new EntrySuccessEventArgs(m_filters, m_signalsCheckers, order);
               OnEntrySuccess(args);
            } 
         }
      }
};