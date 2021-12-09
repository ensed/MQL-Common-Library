#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "StringAsUnsignedIntegerValidator.mqh"

class StringAsCorrectHHMMTimeValidator
{
   private:
      string m_stringValue;
   
   public:
      StringAsCorrectHHMMTimeValidator(const string stringValue)
      {
         m_stringValue = stringValue;
      }
      
      bool IsValueValid()
      {
         if(StringFind(m_stringValue, ":") == -1)
         {
            return false;
         }
         
         string values[];
         StringSplit(m_stringValue, ':', values);
         
         if(ArraySize(values) != 2)
         {
            return false;
         }
         
         for(int i = 0; i < ArraySize(values); i++)
         {
            StringAsUnsignedIntegerValidator validator(values[i]);
            
            if(!validator.IsValueValid())
            {
               return false;
            }
         }
         
         if((uint)values[0] > 23)
         {
            return false;
         }
         
         if((uint)values[1] > 59)
         {
            return false;
         }
                  
         return true;
      }
};