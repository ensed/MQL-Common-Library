#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "ExitProcessor.mqh"
#include "..\Signal Checker\SignalsCheckerListAny.mqh"
#include "..\Trading Controllers\OrdersCloser.mqh"

class ExitBuysAndSellsProcessor : public ExitProcessor
{
   protected:     
      SignalsCheckerListAny* m_signalsCheckers;
      
   public:
      ExitBuysAndSellsProcessor
      (
         const string instrument,
         const int magic,
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters
      )
      : ExitProcessor
      (
         instrument, magic, slippage,
         filters
      )
      {
         m_signalsCheckers = signalsCheckers;
      }
      
      ExitBuysAndSellsProcessor
      (
         const string instrument,
         const int magic1,
         const int magic2,
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters
      )
      : ExitProcessor
      (
         instrument, magic1, magic2, slippage,
         filters
      )
      {
         m_signalsCheckers = signalsCheckers;
      }
      
      ExitBuysAndSellsProcessor
      (
         const string instrument,
         const int &magics[],
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters
      )
      : ExitProcessor
      (
         instrument, magics, slippage,
         filters
      )
      {
         m_signalsCheckers = signalsCheckers;
      }
      
      ~ExitBuysAndSellsProcessor()
      {
         PointersReleaser::Release(m_signalsCheckers);
      }
      
   protected:
      void OnExecute() override
      {         
         if(m_signalsCheckers.ExistsAny())
         {
            for(int i = 0; i < ArraySize(m_magics); i++)
            {
               OrdersCloser buyOrdersCloser(m_instrument, m_magics[i], OrderType_Buy, m_slippage);
               OrdersCloser sellsOrdersCloser(m_instrument, m_magics[i], OrderType_Sell, m_slippage);
               buyOrdersCloser.Close();
               sellsOrdersCloser.Close();
            }
         }
      }
};