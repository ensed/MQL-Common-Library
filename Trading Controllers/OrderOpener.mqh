#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "MarketError.mqh"
#ifdef __MQL5__
#include <Trade\Trade.mqh>
#endif 

#include "..\Models\CommonOrderType.mqh"

#include "TradeContext.mqh"

class OrderOpener
{
   protected:
      string m_instrument;
      CommonOrderType m_type;      
      int m_magic;
      double m_volume;
      string m_comment;
      int m_slippage;
      double m_priceOpen;
      uint m_errorCode;
      
      int m_digits;
      #ifdef __MQL5__
      CTrade m_trade;
      #endif 
      
   public:
      OrderOpener
      (
         const string instrument, 
         const EnumOrderType type, 
         const int magic, 
         const double volume, 
         const string comment, 
         const int slippage, 
         const double priceOpen = 0.0
      )
      {
         m_errorCode = 0;
         m_instrument = instrument;
         m_type = type;
         m_magic = magic;
         m_volume = volume;
         m_comment = comment;
         m_slippage = slippage;
         m_priceOpen = priceOpen;
         
         m_digits = (int)SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
         
         #ifdef __MQL5__
         m_trade.SetDeviationInPoints(m_slippage);
         m_trade.SetExpertMagicNumber(m_magic);
         #endif 
      }
      
      OrderOpener
      (
         const string instrument, 
         const CommonOrderType &type, 
         const int magic, 
         const double volume, 
         const string comment, 
         const int slippage, 
         const double priceOpen = 0.0
      )
      {
         m_errorCode = 0;
         m_instrument = instrument;
         m_type = type;
         m_magic = magic;
         m_volume = volume;
         m_comment = comment;
         m_slippage = slippage;
         m_priceOpen = priceOpen;
         
         m_digits = (int)SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
         
         #ifdef __MQL5__
         m_trade.SetDeviationInPoints(m_slippage);
         m_trade.SetExpertMagicNumber(m_magic);
         #endif 
      }
                  
      int Open()
      {      
         #ifdef __MQL5__
            return OpenTroughMQL5API();
         #endif 
         
         #ifdef __MQL4__
            return OpenTroughMQL4API();
         #endif 
      }   
      
      uint ErrorCode() const { return m_errorCode; } 
      
   private:
      #ifdef __MQL5__
      int OpenTroughMQL5API()
      {         
         if(m_type == OrderType_Buy)
         {
            if(m_trade.Buy(m_volume, m_instrument, 0.0, 0.0, 0.0, m_comment))
            {
               return (int)m_trade.ResultOrder();
            }
         }
         if(m_type == OrderType_Sell)
         {
            if(m_trade.Sell(m_volume, m_instrument, 0.0, 0.0, 0.0, m_comment))
            {
               return (int)m_trade.ResultOrder();
            }
         }
         if(m_type == OrderType_BuyStop)
         {
            if(m_trade.BuyStop(m_volume, m_priceOpen, m_instrument, 0.0, 0.0, 0, 0, m_comment))
            {
               return (int)m_trade.ResultOrder();
            }
         }
         if(m_type == OrderType_BuyLimit)
         {
            if(m_trade.BuyLimit(m_volume, m_priceOpen, m_instrument, 0.0, 0.0, 0, 0, m_comment))
            {
               return (int)m_trade.ResultOrder();
            }
         }
         if(m_type == OrderType_SellStop)
         {
            if(m_trade.SellStop(m_volume, m_priceOpen, m_instrument, 0.0, 0.0, 0, 0, m_comment))
            {
               return (int)m_trade.ResultOrder();
            }
         }
         if(m_type == OrderType_SellLimit)
         {
            if(m_trade.SellLimit(m_volume, m_priceOpen, m_instrument, 0.0, 0.0, 0, 0, m_comment))
            {
               return (int)m_trade.ResultOrder();
            }
         }
         m_errorCode = m_trade.ResultRetcode();       
         return -1;
      }
      #endif 
      #ifdef __MQL4__
      int OpenTroughMQL4API()
      {
         if(m_type == OrderType_Buy)
         {
            m_priceOpen = SymbolInfoDouble(m_instrument,SYMBOL_ASK);
         }
         
         if(m_type == OrderType_Sell)
         {
            m_priceOpen = SymbolInfoDouble(m_instrument,SYMBOL_BID);
         }

         int errorCode=0;
         
         for(int i=0; i<=5; i++)
         {
            ResetLastError();
            RefreshRates();            
            
            if(IsTradeContextBusy())
            {
               Sleep(10);
               i--;
               continue;
            }
            
            TradeContext::CaptureTradeContext();
            
            int ticket = OrderSend
               (
                  m_instrument,
                  m_type.ToPlatformType(),
                  m_volume,
                  NormalizeDouble(m_priceOpen, m_digits),
                  m_slippage,
                  0,
                  0,
                  m_comment,
                  m_magic,
                  0,
                  clrNONE
               );
            TradeContext::ReleaseTradeContext();
            
            if(ticket!=-1)
            {               
               return ticket;
            }
            else
            {
               errorCode=GetLastError();
               
               if(!IsTesting())
               {
                  Sleep(i*200);
               }
            }
         }
         
         m_errorCode = errorCode;
         
         if(errorCode!=0)
         {
            MarketError marketError(errorCode);
            
            Print
            (
               "Error in ", __FILE__, " ", __FUNCSIG__, " line #", __LINE__,  ": ", 
               (string)errorCode," (",marketError.ToString() ,")",
               ", order type = ", m_type.ToString(),
               ", price open = ", DoubleToString(m_priceOpen, 6),
               ", current bid = ", DoubleToString(SymbolInfoDouble(m_instrument,SYMBOL_BID), 6),
               ", current ask = ", DoubleToString(SymbolInfoDouble(m_instrument,SYMBOL_ASK), 6)
            );
         }
         
         return -1;
      }        
      #endif 
};