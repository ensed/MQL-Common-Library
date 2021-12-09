#property strict

#include "VolumeCalculator.mqh"
#include "..\Helpers\ArraysHelper.mqh"

class VolumeCalculatorByLastOpenTrade : public VolumeCalculator
{
   private:
      string m_instrument;
      int m_magics[];
      double m_initialVolume;
      double m_volumeRatio;
      
   public:
      VolumeCalculatorByLastOpenTrade
      (
         const string instrument, const int magic,
         const double initialVolume, const double volumeRatio
      )
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic, m_magics);
         m_initialVolume = initialVolume;
         m_volumeRatio = volumeRatio;
         
         m_volume = 0.0;
      }
      
      VolumeCalculatorByLastOpenTrade
      (
         const string instrument, const int magic1, const int magic2,
         const double initialVolume, const double volumeRatio
      )
      {
         m_instrument = instrument;
         ArraysHelper::AddToArray(magic1, m_magics);
         ArraysHelper::AddToArray(magic2, m_magics);
         m_initialVolume = initialVolume;
         m_volumeRatio = volumeRatio;
         
         m_volume = 0.0;
      }
      
      virtual void Calculate() override
      {         
         double lastOpenTradeVolume = LastOpenTradeVolume();
         if(NormalizeDouble(lastOpenTradeVolume, 8) == NormalizeDouble(0.0, 8))
         {
            m_volume = m_initialVolume;
         }
         else
         {                        
            m_volume = lastOpenTradeVolume * m_volumeRatio; 
            
            double volumeStep = SymbolInfoDouble(m_instrument, SYMBOL_VOLUME_STEP);                       
         	m_volume = MathRound(m_volume / volumeStep) * volumeStep;
         	m_volume = MathMin(m_volume, SymbolInfoDouble(m_instrument, SYMBOL_VOLUME_MAX));	
         	m_volume = MathMax(m_volume, SymbolInfoDouble(m_instrument, SYMBOL_VOLUME_MIN));
         }
      }
      
   private:
      #ifdef __MQL5__
      double LastOpenTradeVolume()
      {       
         for(int i = PositionsTotal() - 1; i >= 0; i--)
         {
            ulong ticket = PositionGetTicket(i);
            
            if(!PositionSelectByTicket(ticket))
            {
               continue;
            }
            
            if(PositionGetString(POSITION_SYMBOL) != m_instrument)
            {
               continue;
            }
            
            if(!IsMagicValid((int)PositionGetInteger(POSITION_MAGIC)))
            {
               continue;
            }
            
            return PositionGetDouble(POSITION_VOLUME);
         }
         
         return 0.0;
      }
      #endif
      
      #ifdef __MQL4__
      double LastOpenTradeVolume()
      {       
         for(int i = OrdersTotal() - 1; i >= 0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               continue;
            }
            
            if(OrderSymbol() != m_instrument)
            {
               continue;
            }
            
            if(!IsMagicValid((int)OrderMagicNumber()))
            {
               continue;
            }
            
            return OrderLots();
         }
         
         return 0.0;
      }
      #endif
      
      bool IsMagicValid(const int magic)
      {
         return ArraysHelper::ItemExistsInArray(magic, m_magics);
      }
};