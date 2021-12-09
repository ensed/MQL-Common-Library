#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "..\Validators\StringAsCorrectHHMMTimeValidator.mqh"
#include "..\Macros\Exceptions\UnexpectedValueException.mqh"

class TimeHHMMFromStringParser
{
   private:
      string m_stringValue;
      
      int m_hour;
      int m_minute;   
   
   public:
      TimeHHMMFromStringParser(const string stringValue)
      {
         m_stringValue = stringValue;
         
         m_hour = -1;
         m_minute = -1;
      }   
      
      void Parse()
      {
         StringAsCorrectHHMMTimeValidator validator(m_stringValue);
         
         if(validator.IsValueValid())
         {
            string values[];
            StringSplit(m_stringValue, ':', values);
            
            m_hour = (int)values[0];
            m_minute = (int)values[1];
         }
         else         
         {
            UnexpectedValueException(m_stringValue);
         }                  
      }
      
      int Hour() const
      {
         return m_hour;
      }
      
      int Minute() const
      {
         return m_minute;
      }
};
      