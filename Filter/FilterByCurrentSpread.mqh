#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#ifdef __MQL4__
#property strict
#endif 

#include "Filter.mqh"

class FilterByCurrentSpread : public Filter
{
   private:
      string m_instrument;
      double m_maxAllowedSpreadValueInPips;
      
      double m_lastSpread;
      double m_pipRatio;
      
   public:
      FilterByCurrentSpread(const string instrument, const double maxAllowedSpreadValueInPips)
      {
         m_instrument = instrument;
         m_maxAllowedSpreadValueInPips = maxAllowedSpreadValueInPips;
         
         m_lastSpread = 0;
         
         int digits = (int)SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
         m_pipRatio = (digits == 3 || digits == 5) ? 10 : 1;
      }
      
      double LastSpread() const { return m_lastSpread; }
      double MaxAllowedSpreadValue() const { return m_maxAllowedSpreadValueInPips; }
      
      virtual bool IsValid() override final
      {
         if(m_maxAllowedSpreadValueInPips <= 0)
         {
            return false;
         }
         
         m_lastSpread = (int)SymbolInfoInteger(m_instrument, SYMBOL_SPREAD) / m_pipRatio;
         
         return m_lastSpread > m_maxAllowedSpreadValueInPips;
      }
      
      virtual Filter* GetCopy() 
      {
         return new FilterByCurrentSpread(m_instrument, m_maxAllowedSpreadValueInPips);
      }
      
      virtual string TypeName() const override final { return typename(this); }
};