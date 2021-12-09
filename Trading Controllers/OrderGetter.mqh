#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class OrderGetter
{
   protected:
      string m_instrument;
      int m_type;
      
      int m_magic;
      
      int m_ticket;
      
   public:
      OrderGetter(const string instrument, const int magic, const int type = -1)
      {
         m_instrument = instrument;         
         m_magic = magic;         
         m_type = type;
         
         GetOrder();
      }      
            
      bool IsTicketValid()
      {
         return m_ticket != -1;
      }
      
      int Ticket()
      {
         return m_ticket;
      }
      
   private:
      #ifdef __MQL5__
      void GetOrder()
      {    
         m_ticket = -1;
              
         for(int i = 0; i < PositionsTotal(); i++)
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
            
            if(PositionGetInteger(POSITION_MAGIC) != m_magic)
            {
               continue;
            }
            
            if(PositionGetInteger(POSITION_TYPE) != m_type && m_type != -1)
            {
               continue;
            }
            
            m_ticket = (int)ticket;
            
            break;
         }
      }
      #endif  
      
      #ifdef __MQL4__
      void GetOrder()
      {    
         m_ticket = -1;
              
         for(int i = 0; i < OrdersTotal(); i++)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
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
            
            if(OrderType() != m_type && m_type != -1)
            {
               continue;
            }
            
            m_ticket = OrderTicket();
            
            break;
         }
      }
      #endif   
};