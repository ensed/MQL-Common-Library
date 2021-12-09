#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class TradeContext
{
   public:
      static void CaptureTradeContext()	
      {
         while(!IsStopped())
         {
            if(!GlobalVariableCheck("TradeIsBusy"))
            {
               GlobalVariableSet("TradeIsBusy", 0.0);
            }
            else
            {
               if((long)TimeLocal() - (long)GlobalVariableTime("TradeIsBusy") > 10)
               {
                  GlobalVariableSet("TradeIsBusy", 0.0);
               }               
            }
            
         	for(int i = 0; i < 8; i++)
         	{
         		if(GlobalVariableSetOnCondition("TradeIsBusy", i+1, i))
         		{
         		   return;
         		}
         	}
      	}
      }
      
      static void ReleaseTradeContext()	
      {
         while(!IsStopped())
         {
            if(!GlobalVariableCheck("TradeIsBusy"))
            {
               GlobalVariableSet("TradeIsBusy", 0.0);
               return;
            }
            
         	for(int i = 8; i >= 1; i--)
         	{
         		if(GlobalVariableSetOnCondition("TradeIsBusy", i-1, i))
         		{
         		   return;
         		}
         	}
      	}
      }
};