//+------------------------------------------------------------------+
//|                                                     BaseTest.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict

#include <Object.mqh>

#define ShowTestFailedMessage(message) \
     { \
      string fullMessage= "Unit test failed!\r\n\r\n"\                         
                         +__PATH__+"\r\n\r\n" \
                         +__FUNCSIG__+", " \
                         +"line: "+(string)__LINE__ \
                         +(message=="" ? "" : "\r\n\r\n"+message); \
      \
      MessageBox(fullMessage, __FUNCTION__, MB_ICONERROR); \
      Comment(fullMessage); \
     }

#define CheckForTrue(value) \
      if(!value) \
        {\
         ShowTestFailedMessage(StringFormat("Expected value: %s\r\nActual value: %s", (string)true, (string)value));\         
         result &= false;\
        }
        
#define CheckForFalse(value) \
      if(value) \
        {\
         ShowTestFailedMessage(StringFormat("Expected value: %s\r\nActual value: %s", (string)false, (string)value));\         
         result &= false;\
        }
        
#define CheckForSubstring(text, match) \
      if(StringFind(text, match) == -1) \
        {\
         ShowTestFailedMessage(StringFormat("Expected \"%s\" in \"%s\", but this value not exists there", match, text));\
         result &= false;\
        }
      
#define CheckForStringsEquivalence(text1, text2) \
      if(text1 != text2) \
        {\
         ShowTestFailedMessage \
         ( \
            StringFormat("Expected that \r\n\r\n\"%s\"\r\n\r\n is equal to \r\n\r\n\"%s\"\r\n\r\nbut this is not true", text1, text2) \
         );\
         result &= false;\
        }
        
#define CheckForIntEquivalence(value1, value2) \
      if(value1 != value2) \
        {\
         ShowTestFailedMessage \
         ( \
            StringFormat("Expected that \r\n\r\n\"%d\"\r\n\r\n is equal to \r\n\r\n\"%d\"\r\n\r\nbut this is not true",\
            value1, value2) \
         );\
         result &= false;\
        }

#define CheckForDoubleEquivalence(value1, value2, digits) \
      if(NormalizeDouble(value1, digits) != NormalizeDouble(value2, digits)) \
        {\
         ShowTestFailedMessage \
         ( \
            StringFormat("Expected that \r\n\r\n\"%s\"\r\n\r\n is equal to \r\n\r\n\"%s\"\r\n\r\nbut this is not true",\
            DoubleToString(value1, digits), DoubleToString(value2, digits)) \
         );\
         result &= false;\
        }

#define TestFileName virtual string FileName() override { return __FILE__; }   
#define TestName virtual string Name() override { return typename(this); }  

#define UnitTestStart(name) class name : public CBaseTest { public: name() {AddUnitTests(this);} TestFileName TestName bool Run() override { bool result = true;
#define UnitTestEnd(name) return result;}}; name testObj_##name;

class CBaseTest : public CObject
{
   public:
      virtual bool Run() { return false; }  
      
      virtual string FileName() { return __FILE__; }  
      virtual string Name() { return typename(this); }  
};