//+------------------------------------------------------------------+
//|                                                 AllUnitTests.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict

#include <Arrays\List.mqh>
#include "BaseTest.mqh"

#define UnitTests_SetOutputAsLogOnly CAllUnitTests::Instance().SetOutputType(UnitTestsOutputType_LogOnly)
#define UnitTests_SetOutputAsCommentAndLog CAllUnitTests::Instance().SetOutputType(UnitTestsOutputType_CommentAndLog)
#define RunUnitTests CAllUnitTests::Instance().Run
#define AddUnitTests CAllUnitTests::Instance().Add

enum EnumUnitTestsOutputType
{
   UnitTestsOutputType_LogOnly, // Log only
   UnitTestsOutputType_CommentAndLog // Comment and log
};

class CAllUnitTests
{      
   public:
      static CAllUnitTests Instance()
      {
         static CAllUnitTests instance;
         return instance;
      }
      
      void Add(CBaseTest &test)
      {         
         m_tests.Add(&test);         
      }
      
      void SetOutputType(const EnumUnitTestsOutputType outputType)
      {
         m_outputType = outputType;
      }
      
      EnumUnitTestsOutputType GetOutputType() const
      {
         return m_outputType;
      }
      
      void Run()
      {   
         if(m_outputType == UnitTestsOutputType_LogOnly)
         {
            Print("Running unit tests... ");
         }
         else if(m_outputType == UnitTestsOutputType_CommentAndLog)
         {
            Comment("Running unit tests... ");
            Sleep(500);
            Comment("");
         }
         
         int counter = 0;               
         for(int i = 0; i < m_tests.Total(); i++)
         {            
            CBaseTest* test = (CBaseTest*)m_tests.GetNodeAtIndex(i);
            if(!test.Run())
            {
               return;
            }
            
            PrintFormat("-- %s - OK\r\n", test.FileName() + " :: " + test.Name());
            counter++;
         }
         
         if(m_outputType == UnitTestsOutputType_LogOnly)
         {
            string messageText = StringFormat
               (
                  "*** Unit tests result (%s): %d tests of %d passed ***", 
                  TimeToString(TimeLocal(), TIME_SECONDS), counter, counter
               );
            
            Print(messageText);
         }
         else if(m_outputType == UnitTestsOutputType_CommentAndLog)
         {
            string messageText = StringFormat
               (
                  "*** Unit tests result (%s) ***\r\n%d tests of %d passed", 
                  TimeToString(TimeLocal(), TIME_SECONDS), counter, counter
               );
            
            Print(messageText);
            Comment(messageText);
            Sleep(3000);
            ChartRedraw(); 
         }                          
      }
      
   private:
      static CList m_tests;
      static EnumUnitTestsOutputType m_outputType;
      
      CAllUnitTests(const CAllUnitTests &root) {  }
      CAllUnitTests() { }
};

CList CAllUnitTests::m_tests;
EnumUnitTestsOutputType CAllUnitTests::m_outputType = UnitTestsOutputType_LogOnly;