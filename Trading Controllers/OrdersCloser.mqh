#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "OrderCloser.mqh"
#include "..\Models\CommonOrderType.mqh"

class OrdersCloser
{
   protected:
      string m_instrument;
      int m_magic;
      CommonOrderType m_type;   
      int m_slippage;   
                 
   public:      
      OrdersCloser(const string instrument, const int magic, const EnumOrderType type, const int slippage)
      {
         m_instrument = instrument;
         m_magic = magic;
         m_type = type;
         m_slippage = slippage;
      }            
             
            
      #ifdef __MQL5__      
      void Close()
      {        
         if(m_type == OrderType_Buy || m_type == OrderType_Sell)
         {
            for(int i = PositionsTotal() - 1; i >= 0; i--)
            {
               ulong ticket = PositionGetTicket(i);
               
               if(!PositionSelectByTicket(ticket))
               {
                  continue;
               }
               
               if(PositionGetString(POSITION_SYMBOL) != m_instrument && m_instrument != "")
               {
                  continue;
               } 
                          
               if(PositionGetInteger(POSITION_MAGIC) != m_magic && m_magic != 0)
               {
                  continue;
               }
               
               if(PositionGetInteger(POSITION_TYPE) != m_type.ToPositionType() && m_type != OrderType_None)
               {
                  continue;
               }
               
               OrderCloser orderCloser((int)ticket, m_slippage);
               orderCloser.Close();
            }
         }
         else
         {
            for(int i = OrdersTotal() - 1; i >= 0; i--)
            {
               ulong ticket = OrderGetTicket(i);
               
               if(!OrderSelect(ticket))
               {
                  continue;
               }
               
               if(OrderGetString(ORDER_SYMBOL) != m_instrument && m_instrument != "")
               {
                  continue;
               } 
                          
               if(OrderGetInteger(ORDER_MAGIC) != m_magic && m_magic != 0)
               {
                  continue;
               }
               
               if(OrderGetInteger(ORDER_TYPE) != m_type.ToOrderTypeType() && m_type != OrderType_None)
               {
                  continue;
               }
               
               OrderCloser orderCloser((int)ticket, m_slippage);
               orderCloser.Close();
            }
         }
      } 
      #endif  
            
      #ifdef __MQL4__      
      void Close()
      {      
         for(int i = OrdersTotal() - 1; i >= 0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               continue;
            }

            if(OrderSymbol() != m_instrument && m_instrument != "")
            {
               continue;
            } 
       
            if(OrderMagicNumber() != m_magic && m_magic != 0)
            {
               continue;
            }
            
            if(OrderType() != m_type.ToPlatformType() && m_type != OrderType_None)
            {
               continue;
            }
            
            OrderCloser orderCloser(OrderTicket(), m_slippage);
            orderCloser.Close();                        
         }
      } 
      #endif    
};