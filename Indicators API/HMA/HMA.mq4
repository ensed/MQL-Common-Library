#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 clrRed

#property strict

input int HMA_Period = 5;
input ENUM_MA_METHOD HMA_Method = MODE_LWMA;
input ENUM_APPLIED_PRICE HMA_PriceType = PRICE_OPEN;

double HMA[];
double data[];

int init() 
{
   IndicatorShortName("HMA (" + (string)HMA_Period + ")");
   IndicatorBuffers(2);
   SetIndexBuffer(0, HMA);
   SetIndexBuffer(1, data);
   SetIndexStyle(1,DRAW_NONE);
   
   SetIndexLabel(0, "Hull Moving Average");
   
   return (0);
}

int start() 
{
   int maPeriod = (int)MathFloor(HMA_Period / 2);
   int maOnArrayPeriod = (int)MathFloor(MathSqrt(HMA_Period));
   int rates_total = IndicatorCounted();
   if (rates_total < 0) return (-1);
   if (rates_total > 0) rates_total--;
   int limit = Bars - rates_total - 1;

   for (int i = limit; i >= 0; i--)
   {
      data[i] = 2.0 * iMA(NULL, 0, maPeriod, 0, HMA_Method, HMA_PriceType, i) - iMA(NULL, 0, HMA_Period, 0, HMA_Method, HMA_PriceType, i);
   }
   
   for (int i = limit; i >= 0; i--) 
   {
      HMA[i] = iMAOnArray(data, 0, maOnArrayPeriod, 0, HMA_Method, i);
   }
   
   return (0);
}

