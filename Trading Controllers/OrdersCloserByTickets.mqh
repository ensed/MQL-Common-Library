#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "OrderCloser.mqh"
#include "..\Helpers\ArraysHelper.mqh"

class OrdersCloserByTickets
{
   protected:      
      long m_tickets[];
      long m_slippage;
      
   public:      
      OrdersCloserByTickets(const long &tickets[], const long slippage)
      {
         ArraysHelper::CopyArray(tickets, m_tickets);
         m_slippage = slippage;
      }            
                 
      void Close()
      {        
         for(int i = ArraySize(m_tickets) - 1; i >=0 ; i--)
         {            
            OrderCloser orderCloser((int)m_tickets[i], (int)m_slippage);
            orderCloser.Close();
         }
      } 
};