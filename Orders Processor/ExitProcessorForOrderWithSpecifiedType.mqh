#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "ExitProcessor.mqh"
#include "..\Signal Checker\SignalsCheckerListAny.mqh"
#include "..\Trading Controllers\OrdersCloser.mqh"

class ExitProcessorForOrderWithSpecifiedType: public ExitProcessor
{
   private:
      EnumOrderType m_orderType;     
      SignalsCheckerListAny* m_signalsCheckers;
      
   public:
      ExitProcessorForOrderWithSpecifiedType
      (
         const string instrument,
         const int magic,
         const EnumOrderType orderType,
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
         m_orderType = orderType;
         m_signalsCheckers = signalsCheckers;
      }
      
      ExitProcessorForOrderWithSpecifiedType
      (
         const string instrument,
         const int magic1,
         const int magic2,
         const EnumOrderType orderType,
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
         m_orderType = orderType;
         m_signalsCheckers = signalsCheckers;
      }
      
      ~ExitProcessorForOrderWithSpecifiedType()
      {
         PointersReleaser::Release(m_signalsCheckers);
      } 
      
   protected:
      virtual void OnExecute() override
      {         
         if(m_signalsCheckers.ExistsAny())
         {
            for(int i = 0; i < ArraySize(m_magics); i++)
            {
               OrdersCloser ordersCloser(m_instrument, m_magics[i], m_orderType, m_slippage);
               ordersCloser.Close();
            }
         }
      }
};