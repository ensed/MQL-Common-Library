#property strict

#include "Filter.mqh"
#include "..\Trading Controllers\OrderGetter.mqh"

class FilterByAnotherOrders : public Filter
{
   protected:
      string m_instrument;
      int m_magic;
      int m_type;
      
   public:
      FilterByAnotherOrders(const string instrument, const int magic, const int type)
      {
         m_instrument = instrument;
         m_magic = magic;
         m_type = type;
      }
      
      bool IsValid() override
      {
         OrderGetter orderGetter(m_instrument, m_magic, m_type);
         
         return orderGetter.IsTicketValid();
      }
};