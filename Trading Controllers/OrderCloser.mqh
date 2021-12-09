#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "MarketError.mqh"
#ifdef __MQL5__
#include <Trade\Trade.mqh>
#endif 

#include "TradeContext.mqh"

class OrderCloser
{
   protected:
      long m_ticket;
      int m_slippage;            
      #ifdef __MQL5__
      CTrade m_trade;
      #endif 
      double m_volume;
      
   public:      
      OrderCloser(const long ticket, const int slippage)
      {
         m_ticket = ticket;
         m_slippage = slippage;      
         m_volume = 0.0;
         
         #ifdef __MQL5__
         m_trade.SetDeviationInPoints(m_slippage);
         #endif    
      }     
      
      OrderCloser(const long ticket, const double volume, const int slippage)
      {
         m_ticket = ticket;
         m_slippage = slippage;      
         m_volume = volume;
         
         #ifdef __MQL5__
         m_trade.SetDeviationInPoints(m_slippage);
         #endif    
      }        
      
      #ifdef __MQL5__
      bool Close()
      {
         bool marketWasSelected = PositionSelectByTicket(m_ticket);
         bool pendingWasSelected = false;
         
         if(!marketWasSelected)
         {
            pendingWasSelected = OrderSelect(m_ticket);
         }
         
         if(!marketWasSelected && !pendingWasSelected)
         {
            Print
            (
               "Error in ", __FILE__, " ", __FUNCSIG__, " line #", __LINE__,
               ": cannot select order with ticket #", m_ticket
            );
            
            return false;
         }
         
         if(marketWasSelected)
         {   
            if(NormalizeDouble(m_volume, 3) ==NormalizeDouble(0.0, 3))
            {
               return m_trade.PositionClose(m_ticket, m_slippage);
            }
            else
            {
               return m_trade.PositionClosePartial(m_ticket, m_volume, m_slippage);
            }
         }
         else         
         {            
            if(NormalizeDouble(m_volume, 3) ==NormalizeDouble(0.0, 3))
            {
               return m_trade.OrderDelete(m_ticket);
            }
         }
         
         return false;
      }
      #endif
      
      #ifdef __MQL4__                  
      bool Close()
      {
         if(!OrderSelect((int)m_ticket, SELECT_BY_TICKET, MODE_TRADES))
         {
            Print
            (
               "Error in ", __FILE__, " ", __FUNCSIG__, " line #", __LINE__,
               ": cannot select order with ticket #", m_ticket
            );
            
            return false;
         }
         
         int errorCode = 0;
         
         RefreshRates();
         double closePrice = OrderClosePrice();
         
         for(int i = 0; i < 5; i++)
         {
            ResetLastError();
            RefreshRates();            
            
            if(IsStopped())
            {
               return false;
            }
            
            if(IsTradeContextBusy())
            {
               Sleep(10);
               i--;
               continue;
            }
            
            bool result = false;
            
            TradeContext::CaptureTradeContext();
            
            if(OrderType() <= OP_SELL)
            {
               result = OrderClose(OrderTicket(), OrderLots(), closePrice, m_slippage, clrNONE);
            }
            else
            {
               result = OrderDelete(OrderTicket());
            }
            
            TradeContext::ReleaseTradeContext();
            
            if(result)
            {
               return true;
            }
            
            errorCode = GetLastError();
                                    
            Sleep(200*i);
         }
         
         if(errorCode != 0)
         {
            MarketError marketError(errorCode);
            
            Print
            (
               "Error in ", __FILE__, " ", __FUNCSIG__, " line #", __LINE__,  
               ": ", (string)errorCode," (",marketError.ToString() ,")"
            );
         }
         
         return false;
      }
      #endif 
};