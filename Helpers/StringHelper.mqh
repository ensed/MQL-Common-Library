#property strict

class StringHelper
{
   public:
      static string Trim(const string value)
      {                  
         #ifdef __MQL4__         
            string result = StringTrimRight(StringTrimLeft(value));
         #endif 
         
         #ifdef __MQL5__
            string result = value;         
            StringTrimRight(result);
            StringTrimLeft(result);
         #endif 
         
         return result;
      }
      
      static bool EndsWith(const string value, const string mathValue)
      {
         int actualIndex = StringFind(value, mathValue);
         
         if(actualIndex == -1)
         {
            return false;
         }
         
         int expectedIndex = StringLen(value) - StringLen(mathValue);
         
         bool result = actualIndex == expectedIndex;
         
         return result;
      }
      
      static string ParseStr(const string text, const string subStart, const string subEnd)
      {
         int startPhraseLengt = StringLen(subStart);
         int startPos = StringFind(text, subStart) + startPhraseLengt;
         int endPos = StringFind(text, subEnd, startPos);
                 
         if(startPos >= startPhraseLengt && endPos > startPos)
         {
            return StringSubstr(text, startPos, endPos - startPos);      
         }
         else
         {
            return "";
         }
      }
      
      static void ParseStr(const string text, const string subStart, const string subEnd, string &items[])
      {
         ArrayFree(items);
         
         int startPhraseLengt = StringLen(subStart);
         int startPos = StringFind(text, subStart) + startPhraseLengt;
         int endPos = StringFind(text, subEnd, startPos);

         while(startPos >= startPhraseLengt && endPos > startPos)
         {
            string tmp = Trim(StringSubstr(text, startPos, endPos - startPos));
            
            int index = ArraySize(items);
            ArrayResize(items, index+1);
            
            items[index] = tmp;
            
            startPos = StringFind(text, subStart, endPos + 1) + startPhraseLengt;
            endPos = StringFind(text, subEnd, startPos);
         }
      }
};