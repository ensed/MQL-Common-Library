#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "Filter.mqh"

class FilterByMaxSpreadValue : public Filter
{
   private:
      string m_instrument;
      int m_maxSpreadValue;
      
   public:
      FilterByMaxSpreadValue(const string instrument, const int maxSpreadValue)
      {
         m_instrument = instrument;
         m_maxSpreadValue = maxSpreadValue;
      }
      
      virtual bool IsValid() override final
      {
         return SymbolInfoInteger(m_instrument, SYMBOL_SPREAD) > m_maxSpreadValue;
      }
      
      virtual Filter* GetCopy() override
      {
         return new FilterByMaxSpreadValue(m_instrument, m_maxSpreadValue);
      }
      
      virtual string TypeName() const override
      {
         return typename(this);
      }
};