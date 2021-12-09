#property strict

#include "VolumeCalculator.mqh"

class VolumeCalculatorByLastCloseTrade : public VolumeCalculator
{
   private:
      string m_instrument;
      int m_magic;
      double m_initialVolume;
      double m_volumeRatio;
      
      bool m_lastCloseTradeWasProfitable;
      
   public:
      VolumeCalculatorByLastCloseTrade
      (
         const string instrument, const int magic,
         const double initialVolume, const double volumeRatio
      )
      {
         m_instrument = instrument;
         m_magic = magic;
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
            if(m_lastCloseTradeWasProfitable)
            {
               m_volume = m_initialVolume;
            }
            else
            {        
               m_volume = lastOpenTradeVolume * m_volumeRatio; 
            }
            
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
         HistorySelect(0, TimeCurrent()+1);
         for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
         {
            ulong ticket = HistoryDealGetTicket(i);
            
            if(!HistoryDealSelect(ticket))
            {
               continue;
            }
            
            if(HistoryDealGetString(ticket, DEAL_SYMBOL) != m_instrument)
            {
               continue;
            }
            
            if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != m_magic)
            {
               continue;
            }
            
            m_lastCloseTradeWasProfitable 
               = HistoryDealGetDouble(ticket, DEAL_PROFIT) 
                 + HistoryDealGetDouble(ticket, DEAL_SWAP) + 
                 HistoryDealGetDouble(ticket, DEAL_COMMISSION)
                  > 0;
            
            return HistoryDealGetDouble(ticket, DEAL_VOLUME);
         }
         
         return -1;
      }
      #endif 
      
      #ifdef __MQL4__
      double LastOpenTradeVolume()
      {       
         for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            {
               continue;
            }
            
            if(OrderSymbol() != m_instrument)
            {
               continue;
            }
            
            if(OrderMagicNumber() != m_magic)
            {
               continue;
            }
            
            m_lastCloseTradeWasProfitable = OrderProfit() + OrderSwap() + OrderCommission() > 0;
            return OrderLots();
         }
         
         return 0.0;
      }
      #endif 
};