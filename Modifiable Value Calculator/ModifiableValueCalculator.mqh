#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "..\Helpers\PointersReleaser.mqh"
#include "..\Models\CommonOrderType.mqh"

class ModifiableValueCalculator
{
   protected:   
      string m_instrument;   
      int m_digits;
      double m_pipValue;      
      
   public:
      ModifiableValueCalculator
      (
         const string instrument
      )
      {      
         m_instrument = instrument;
         m_digits = (int)SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
         m_pipValue = SymbolInfoDouble(m_instrument, SYMBOL_POINT) * ((m_digits == 3 || m_digits == 5) ? 10 : 1);
      }
      
      ModifiableValueCalculator
      (
         const string instrument, const double pipValue
      )
      {      
         m_instrument = instrument;
         m_digits = (int)SymbolInfoInteger(m_instrument, SYMBOL_DIGITS);
         m_pipValue = pipValue;
      }
      
      double Calculate(const CommonOrderType &type, const double openPrice)
      {
         return Calculate(type.Get(), openPrice);
      }
      
      virtual double Calculate(const EnumOrderType type, const double openPrice) = 0;     
};