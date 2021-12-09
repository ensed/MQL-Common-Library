#property strict

#include "..\Models\OrderInfo.mqh"
#include "..\Cryptography\MD5.mqh"

class CVirtualTSLMaxProfitFixer
{
   public:   
      ~CVirtualTSLMaxProfitFixer()
      {
         if(MQLInfoInteger(MQL_TESTER))
         {
            GlobalVariablesDeleteAll("tsl_t_");  
         }                        
      }  
       
      void UpdateMaxProfit(const OrderInfo &orders[], const double profit, const string caller = "")
      {
         DeleteDataAboutOldSeries(orders, caller);
         
         string seriesName = GetSeriesName(orders, caller);
         
         if(!GlobalVariableCheck(seriesName))
         {
            GlobalVariableSet(GetSeriesName(orders, caller), profit);
         }
         else
         {
            GlobalVariableSet(GetSeriesName(orders, caller), MathMax(GlobalVariableGet(seriesName), profit));
         }
      }
      
      double GetMaxProfit(const OrderInfo &orders[], const string caller = "")
      {
         string seriesName = GetSeriesName(orders, caller);
         
         if(!GlobalVariableCheck(seriesName))
         {
            return 0.0;
         }
         else
         {
            return GlobalVariableGet(seriesName);
         }
      }
      
      void ReleaseValue(const OrderInfo &orders[], const string caller = "")
      {
         string seriesName = GetSeriesName(orders, caller);
         GlobalVariableDel(seriesName);
      }
      
   private:
      string GetSeriesName(const OrderInfo &orders[], const string caller)
      {
         string ticketsStr = "";
         for(int i = 0; i < ArraySize(orders); i++)
         {
            ticketsStr += (string)orders[i].Ticket;
         }
         
         MD5 md5(ticketsStr + "_" + caller);
         md5.Calculate();
         
         return "tsl_" + (MQLInfoInteger(MQL_TESTER) ? "t_" : "") + md5.Get();
      }
      
      void DeleteDataAboutOldSeries(const OrderInfo &orders[], const string caller)
      {
         OrderInfo candidateSeries[];
         for(int i = 0; i < ArraySize(orders) - 1; i++)
         {
            ArrayResize(candidateSeries, i+1);
            candidateSeries[i] = orders[i];
            
            GlobalVariableDel(GetSeriesName(candidateSeries, caller)); 
         }
      }
};

CVirtualTSLMaxProfitFixer VirtualTSLMaxProfitFixer;