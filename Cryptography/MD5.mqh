#property strict

class MD5
{
   private:
      string m_value;
      string m_hashedValue;
      
   public:
      MD5(const string value)
      {
         m_value = value;
         m_hashedValue = "";
      }
      
      void Calculate()
      {
         const string EMPTY_MD5 = "d41d8cd98f00b204e9800998ecf8427e";
         if(m_value == "")
         {
            m_hashedValue = EMPTY_MD5;
            return;
         }
         
         uchar result[];
         
         const uchar key[1]= {0};
         
         uchar data[];
         StringToCharArray(m_value, data, 0, StringLen(m_value));
         
         CryptEncode(CRYPT_HASH_MD5, data, key, result);

         m_hashedValue = "";
         for(int i = 0; i < ArraySize(result); i++)
         {            
            m_hashedValue += StringFormat("%02x", result[i]);
         }         
      }
      
      string Get()
      {
         return m_hashedValue;
      }
};