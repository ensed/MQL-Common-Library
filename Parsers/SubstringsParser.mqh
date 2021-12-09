#property strict

class SubstringsParser
{
   private:
      string m_text;
      string m_subStart;
      string m_subEnd;
   
   public:
      SubstringsParser(const string text, const string subStart, const string subEnd)
      {
         m_text = m_text;
         m_subStart = m_subStart;
         m_subEnd = m_subEnd;
      }
      
      void Get(string &items[])
      {
         ArrayFree(items);
         
         int startPhraseLengt = StringLen(m_subStart);
         int startPos = StringFind(m_text, m_subStart) + startPhraseLengt;
         int endPos = StringFind(m_text, m_subEnd, startPos);

         while(startPos >= startPhraseLengt && endPos > startPos)
         {
            #ifdef __MQL4__
            string tmp = StringTrimRight(StringTrimLeft(StringSubstr(m_text, startPos, endPos - startPos)));
            #endif 

            #ifdef __MQL5__
            string tmp = StringSubstr(m_text, startPos, endPos - startPos);
            StringTrimRight(tmp);
            StringTrimLeft(tmp);
            #endif 
            
            int index = ArraySize(items);
            ArrayResize(items, index+1);            
            items[index] = tmp;
            
            startPos = StringFind(m_text, m_subStart, endPos + 1) + startPhraseLengt;
            endPos = StringFind(m_text, m_subEnd, startPos);
         }
      }
};