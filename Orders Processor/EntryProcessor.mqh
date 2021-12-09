#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "OrdersProcessor.mqh"
#include "..\Signal Checker\SignalsCheckerListAny.mqh"
#include "..\Modifiable Value Calculator\ModifiableValueCalculator.mqh"
#include "..\Volume Calculator\VolumeCalculator.mqh"
#include "..\Event Handler\EventHandler.mqh"
#include "Event Handlers\EntrySuccessEventArgs.mqh"
#include <Arrays\ArrayObj.mqh>

class EntryProcessor : public OrdersProcessor
{
   protected:
      string m_instrument;
      int m_magic;
      CommonOrderType m_type;
      string m_comment;
      int m_slippage;
      SignalsCheckerListAny* m_signalsCheckers;      
      ModifiableValueCalculator* m_stopLossCalculator;
      ModifiableValueCalculator* m_takeProfitCalculator;
      VolumeCalculator* m_volumeCalculator;
      
      CArrayObj* m_entrySuccessEventHandlers;

      double m_volume;
      
   public:
      EntryProcessor
      (
         const string instrument,
         const int magic,
         const EnumOrderType type,
         const string comment,
         const int slippage,
         SignalsCheckerListAny* signalsCheckers,
         FiltersList* filters,
         ModifiableValueCalculator* stopLossCalculator,
         ModifiableValueCalculator* takeProfitCalculator,
         VolumeCalculator* volumeCalculator
      )
      : 
         OrdersProcessor(filters),
         m_entrySuccessEventHandlers(new CArrayObj())
      {
         m_instrument = instrument;
         m_magic = magic;
         m_type = type;
         m_comment = comment;
         m_slippage = slippage;
         m_signalsCheckers = signalsCheckers;
         m_stopLossCalculator = stopLossCalculator;
         m_takeProfitCalculator = takeProfitCalculator;
         m_volumeCalculator = volumeCalculator;
         m_volume = 0.0;
      } 
      
      ~EntryProcessor()
      {
         PointersReleaser::Release(m_signalsCheckers);
         PointersReleaser::Release(m_stopLossCalculator);
         PointersReleaser::Release(m_takeProfitCalculator);
         PointersReleaser::Release(m_volumeCalculator);
         PointersReleaser::Release(m_entrySuccessEventHandlers);
      }
      
      void Magic(const int value)
      {
         m_magic = value;
      }
      
      void Volume(const double value)
      {
         PointersReleaser::Release(m_volumeCalculator);
         m_volume = value;
      }
      
      void Comment(const string value)
      {
         m_comment = value;
      }     
      
      void AddEntrySuccessEventHandler(EventHandler* handler)
      {
         m_entrySuccessEventHandlers.Add(handler);
      }
      
   protected:
      void OnEntrySuccess(EntrySuccessEventArgs* args)
      {
         for(int i = 0; i < m_entrySuccessEventHandlers.Total(); i++)
         {
            EventHandler* handler = m_entrySuccessEventHandlers.At(i);
            handler.Handle(args);
         }
         
         if(m_entrySuccessEventHandlers.Total() == 0)
         {
            delete args;
         }
      }
};