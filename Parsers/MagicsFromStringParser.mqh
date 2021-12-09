//+------------------------------------------------------------------+
//|                                       MagicsFromStringParser.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict

#include "..\Helpers\ArraysHelper.mqh"

class MagicsFromStringParser
{
   private:
      int m_magics[];
      
   public:
      MagicsFromStringParser(const string magicNumbers)
      {
         ArrayFree(m_magics);
         string magics[];
         StringSplit(magicNumbers, ';', magics);
         
         for(int i = 0; i < ArraySize(magics); i++)
         {
            #ifdef __MQL4__
            string magic = StringTrimRight(StringTrimLeft(magics[i]));
            #endif 
            
            #ifdef __MQL5__
            string magic = magics[i]; 
            StringTrimRight(magic);
            StringTrimLeft(magic);
            #endif 
            
            if(magic == "" || magic == "0")
            {
               continue;
            }
            
            int magicAsNumber = (int)StringToInteger(magic);
            
            ArraysHelper::AddToArray(magicAsNumber, m_magics);
         }
      }
      
      void Get(int &magics[])
      {
         ArraysHelper::CopyArray(m_magics, magics);
      }
};