#property strict

#include "..\Models\OrderInfo.mqh"

class OrdersSeriesHelper
{
   public:
      static bool ms_tmpBreakevenUseBothBidAsk;
      static EnumOrderType GetNetDirection(const OrderInfo &orders[])
      {
         double buysVolume = 0.0;
         double sellsVolume = 0.0;
         
         for(int i = 0; i < ArraySize(orders); i++)
         {
            OrderInfo order = orders[i];
            if(order.IsTypeBuy())
            {
               buysVolume += order.Size;
            }
            else if(order.IsTypeSell())
            {
               sellsVolume += order.Size;
            }
         }        
         
         if(buysVolume > sellsVolume)
         {
            return OrderType_Buy;
         }
         else if(buysVolume < sellsVolume)
         {
            return OrderType_Sell;
         }
         
         return OrderType_None;
      }
      
      static double GetNetBreakevenPrice(const string instrument, const OrderInfo &orders[])
      {
      	int spread = (int)SymbolInfoInteger(instrument, SYMBOL_SPREAD);
      	double point = SymbolInfoDouble(instrument, SYMBOL_POINT);
      	int digits = (int)SymbolInfoInteger(instrument, SYMBOL_DIGITS);
      	      	
      	double buysNetPrice = 0, sellsNetPrice = 0;
      	double buysTotalVolume = 0, sellsTotalVolume = 0;
      	double buysTotalSwapAndComissions = 0, sellsTotalSwapAndComissions = 0;
      	
      	const int commissionMultiplier = #ifdef __MQL5__ (ms_tmpBreakevenUseBothBidAsk ? 2 : 1); #else 1; #endif 
      	
         for(int i = 0; i < ArraySize(orders); i++)
         {
            OrderInfo order = orders[i];
      		if(order.IsTypeBuy())
      		{
      			buysNetPrice = ((buysNetPrice * buysTotalVolume) + (order.PriceOpen * order.Size)) / (buysTotalVolume + order.Size);
      			buysTotalVolume = buysTotalVolume + order.Size;
      			buysTotalSwapAndComissions = buysTotalSwapAndComissions + order.Swap + order.Comissions * commissionMultiplier;
      		}
      		else if(order.IsTypeSell())
      		{
      			sellsNetPrice = ((sellsNetPrice * sellsTotalVolume) + (order.PriceOpen * order.Size)) / (sellsTotalVolume + order.Size);
      			sellsTotalVolume = sellsTotalVolume + order.Size;
      			sellsTotalSwapAndComissions = sellsTotalSwapAndComissions + order.Swap + order.Comissions * commissionMultiplier;
      		}
      	}
      	
      	double M2B = 0, M2S = 0, breakEvenPrice = 0.0;
      	if (buysTotalVolume > sellsTotalVolume) // detection breakeven for the net buy case
      	{
      		for (int i = 0; i < 10000; i++)
      		{
      			M2B = i * buysTotalVolume * 10;
      			M2S = ((buysNetPrice - sellsNetPrice + spread * point) / point + i) * (sellsTotalVolume * (-10));
      			if (M2B + M2S + buysTotalSwapAndComissions + sellsTotalSwapAndComissions >= 0)
      			{
      				breakEvenPrice = NormalizeDouble(buysNetPrice + i * point, digits);
      				break;
      			}
      		}
      	}
      	if (sellsTotalVolume > buysTotalVolume) // detection breakeven for the net sell case
      	{
      		for (int i = 0; i < 10000; i++)
      		{
      			M2S = i * sellsTotalVolume * 10;
      			M2B = ((buysNetPrice - sellsNetPrice + spread * point) / point + i) * (buysTotalVolume * (-10));
      			if (M2S + M2B + buysTotalSwapAndComissions + sellsTotalSwapAndComissions >= 0)
      			{
      				breakEvenPrice = NormalizeDouble(sellsNetPrice - i * point, digits);
      				break;
      			}
      		}
      	}
      	
      	return breakEvenPrice;
      }
};
bool OrdersSeriesHelper::ms_tmpBreakevenUseBothBidAsk=false;
