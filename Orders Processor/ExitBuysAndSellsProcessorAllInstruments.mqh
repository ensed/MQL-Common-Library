#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "ExitProcessor.mqh"
#include "..\Signal Checker\SignalsCheckerListAny.mqh"
#include "..\Trading Controllers\OrdersCloser.mqh"

class ExitBuysAndSellsProcessorAllInstruments : public ExitProcessor
{
   protected:     
      SignalsCheckerListAny* m_signalsCheckers;
      
   public:
      ExitBuysAndSellsProcessorAllInstruments
      (
         const int magic,
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters
      )
      : ExitProcessor
      (
         NULL, magic, slippage,
         filters
      )
      {
         m_signalsCheckers = signalsCheckers;
      }
      
      ExitBuysAndSellsProcessorAllInstruments
      (
         const int magic1,
         const int magic2,
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters
      )
      : ExitProcessor
      (
         NULL, magic1, magic2, slippage,
         filters
      )
      {
         m_signalsCheckers = signalsCheckers;
      }
      
      ~ExitBuysAndSellsProcessorAllInstruments()
      {
         PointersReleaser::Release(m_signalsCheckers);
      }
      
   protected:
      #ifdef __MQL4__
      void OnExecute() override
      {         
         if(m_signalsCheckers.ExistsAny())
         {          
           for(int i = OrdersTotal() - 1; i >= 0; i--)
            {
               if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
               {
                  continue;
               }
               
               int magic = OrderMagicNumber();
               
               if(ArraysHelper::ItemExistsInArray(magic, m_magics))
               {               
                  OrderCloser closer(OrderTicket(), m_slippage);
                  closer.Close();
               }
            }
         }
      }
      #endif 
      
      #ifdef __MQL5__
      void OnExecute() override
      {         
         if(m_signalsCheckers.ExistsAny())
         {          
           for(int i = PositionsTotal() - 1; i >= 0; i--)
           {
               ulong ticket = PositionGetTicket(i);
               
               CPositionInfo position;
               if(!position.SelectByTicket(ticket))
               {
                  continue;
               }
               
               int magic = (int)PositionGetInteger(POSITION_MAGIC);
               
               if(ArraysHelper::ItemExistsInArray(magic, m_magics))
               {               
                  CTrade trade;
                  trade.PositionClose(position.Ticket(), m_slippage);
               }
            }
         }
      }
      #endif 
};