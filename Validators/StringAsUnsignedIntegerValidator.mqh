#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class StringAsUnsignedIntegerValidator
{
   private:
      string m_stringValue;
   
   public:
      StringAsUnsignedIntegerValidator(const string stringValue)
      {
         m_stringValue = stringValue;
      }
      
      bool IsValueValid() const
      {
      	if (StringLen(m_stringValue) == 0)
      	{
      		return false;
      	}      
      	
      	for (int i = 0; i < StringLen(m_stringValue); i++)
      	{
      		ushort curChar = StringGetCharacter(m_stringValue, i);
      		if (curChar == '0')
      		{
      			continue;
      		}
      		if (curChar == '1')
      		{
      			continue;
      		}
      		if (curChar == '2')
      		{
      			continue;
      		}
      		if (curChar == '3')
      		{
      			continue;
      		}
      		if (curChar == '4')
      		{
      			continue;
      		}
      		if (curChar == '5')
      		{
      			continue;
      		}
      		if (curChar == '6')
      		{
      			continue;
      		}
      		if (curChar == '7')
      		{
      			continue;
      		}
      		if (curChar == '8')
      		{
      			continue;
      		}
      		if (curChar == '9')
      		{
      			continue;
      		}
      
      		return false;
      	}
      
      	return true;
      }            
};