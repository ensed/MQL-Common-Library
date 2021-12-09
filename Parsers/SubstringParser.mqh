#property strict

class SubstringParser
{
   private:
      string m_text;
      string m_subStart;
      string m_subEnd;
   
   public:
      SubstringParser(const string text, const string subStart, const string subEnd)
      {
         m_text = text;
         m_subStart = subStart;
         m_subEnd = subEnd;
      }
      
      string Get()
      {
         int startPhraseLengt = StringLen(m_subStart);
         int startPos = StringFind(m_text, m_subStart) + startPhraseLengt;
         int endPos = StringFind(m_text, m_subEnd, startPos);
                 
         if(startPos >= startPhraseLengt && endPos > startPos)
         {
            return StringSubstr(m_text, startPos, endPos - startPos);      
         }
         else
         {
            return "";
         }
      }
};