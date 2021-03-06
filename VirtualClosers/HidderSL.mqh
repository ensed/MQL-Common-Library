#property strict

#include "..\Trading Controllers\OrderCloser.mqh"

class CHidderSL
{
   public:
      #ifdef __MQL5__
      static void Proceed(const int m_slippage)
      {         
         for(int i = 0; i < PositionsTotal(); i++)
         {
            ulong ticket = PositionGetTicket(i);
            
            if(!PositionSelectByTicket(ticket))            
            {
               continue;
            }
            
            string globalVariableName = (string)PositionGetInteger(POSITION_TICKET) + "_sl";
            
            if(GlobalVariableCheck(globalVariableName))
            {
               if
               (
                  (
                     PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY 
                     && PositionGetDouble(POSITION_PRICE_CURRENT) <= GlobalVariableGet(globalVariableName)
                  )
                  || 
                  (
                     PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL 
                     && PositionGetDouble(POSITION_PRICE_CURRENT) >= GlobalVariableGet(globalVariableName)
                  )
               )
               {                  
                  OrderCloser closer((int)ticket, m_slippage);
                  
                  if(closer.Close())
                  {                     
                     RemoveSL((int)ticket);
                  }                  
               }
            }
         }
      }
      #endif
      
      #ifdef __MQL4__
      static void Proceed(const int m_slippage)
      {         
         for(int i = 0; i < OrdersTotal(); i++)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               continue;
            }
            
            if(GlobalVariableCheck((string)OrderTicket() + "_sl"))
            {
               if
               (
                  (OrderType() == OP_BUY && OrderClosePrice() <= GlobalVariableGet((string)OrderTicket() + "_sl"))
                  || (OrderType() == OP_SELL && OrderClosePrice() >= GlobalVariableGet((string)OrderTicket() + "_sl"))
               )
               {                  
                  OrderCloser closer(OrderTicket(), m_slippage);
                  
                  if(closer.Close())
                  {                     
                     RemoveSL(OrderTicket());
                  }                  
               }
            }
         }
      }
      #endif
      
      static void UpdateSL(const int ticket, const double value)
      {
         GlobalVariableDel((string)ticket + "_sl");
         GlobalVariableSet((string)ticket + "_sl", value);
      }
      
      static double GetSL(const int ticket)
      {
         return GlobalVariableGet((string)ticket + "_sl");
      }   
      
      static bool RemoveSL(const int ticket)
      {
         return (bool)GlobalVariableDel((string)ticket + "_sl");
      }        
};