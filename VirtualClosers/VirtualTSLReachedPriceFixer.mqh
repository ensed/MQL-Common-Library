#property strict

#include "..\Models\OrderInfo.mqh"
#include "..\Cryptography\MD5.mqh"
#include "..\Helpers\OrdersSeriesHelper.mqh"

class CVirtualTSLReachedPriceFixer
{
   public:   
      ~CVirtualTSLReachedPriceFixer()
      {
         if(MQLInfoInteger(MQL_TESTER))
         {
            GlobalVariablesDeleteAll("tsl_reached_price_t_");  
         }
      }

      void UpdateReachedPrice(const OrderInfo &orders[], const double price)
      {
         DeleteDataAboutOldSeries(orders);

         string seriesName = GetSeriesName(orders);

         if(!GlobalVariableCheck(seriesName))
         {
            GlobalVariableSet(GetSeriesName(orders), price);
         }
         else
         {
            double newValue = 0.0;

            if(OrdersSeriesHelper::GetNetDirection(orders) == OrderType_Buy)
            {
               newValue = MathMax(GlobalVariableGet(seriesName), price);
            }
            else if(OrdersSeriesHelper::GetNetDirection(orders) == OrderType_Sell)
            {
               newValue = MathMin(GlobalVariableGet(seriesName), price);
            }
            
            GlobalVariableSet(GetSeriesName(orders), newValue);
         }
      }
      
      double GetReachedPrice(const OrderInfo &orders[])
      {
         string seriesName = GetSeriesName(orders);
         
         if(!GlobalVariableCheck(seriesName))
         {
            return 0.0;
         }
         else
         {
            return GlobalVariableGet(seriesName);
         }
      }
      
      void ReleaseValue(const OrderInfo &orders[])
      {
         string seriesName = GetSeriesName(orders);
         GlobalVariableDel(seriesName);
      }
      
   private:
      string GetSeriesName(const OrderInfo &orders[])
      {
         string ticketsStr = "";
         for(int i = 0; i < ArraySize(orders); i++)
         {
            ticketsStr += (string)orders[i].Ticket;
         }
         
         MD5 md5(ticketsStr);
         md5.Calculate();
         
         return "tsl_reached_price_" + (MQLInfoInteger(MQL_TESTER) ? "t_" : "") + md5.Get();
      }
      
      void DeleteDataAboutOldSeries(const OrderInfo &orders[])
      {
         OrderInfo candidateSeries[];
         for(int i = 0; i < ArraySize(orders) - 1; i++)
         {
            ArrayResize(candidateSeries, i+1);
            candidateSeries[i] = orders[i];
            
            GlobalVariableDel(GetSeriesName(candidateSeries)); 
         }
      }
};

CVirtualTSLReachedPriceFixer VirtualTSLReachedPriceFixer;