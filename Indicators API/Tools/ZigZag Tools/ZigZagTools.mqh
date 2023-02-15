#property strict

#include "ZigZagExtremum.mqh"
#include <Common Library\Indicators API\IndicatorAPIBase.mqh>
#include <Common Library\Helpers\PointersReleaser.mqh>

class ZigZagTools
{
   private:
      const string m_instrument;
      const ENUM_TIMEFRAMES m_timeframe;
      IndicatorAPIBase* m_indicator;
      
   public:
      ZigZagTools
      (
         const string instrument, const ENUM_TIMEFRAMES timeframe, IndicatorAPIBase* indicator
      )
      :
         m_instrument(instrument),
         m_timeframe(timeframe),
         m_indicator(indicator)
      {
      }
      
      ~ZigZagTools()
      {
         PointersReleaser::Release(m_indicator);
      }

      ZigZagExtremum GetFirstExtremum(const int shift = 0)
      {
         return GetNextExtremum(shift - 1);
      }
      
      ZigZagExtremum GetNextExtremum(const ZigZagExtremum &extremum)
      {      
         return GetNextExtremum(extremum.Shift());
      }
      
      ZigZagExtremum GetNextExtremum(const int shift)
      {
         for(int i = shift+1; i < iBars(m_instrument, m_timeframe); i++)
         {            
            if(!m_indicator.IsValueEmptyOrZero(i))
            {
               const double value = m_indicator[i];
               const double high = iHigh(m_instrument, m_timeframe, i);
               DoublesComparer comparerToHigh(value, high);
               if(comparerToHigh.Equals())
               {
                  ZigZagExtremum result(i, high, ZigZagExtremumType_Upper);
                  return result;
               }
               
               const double low = iLow(m_instrument, m_timeframe, i);
               DoublesComparer comparerToLow(value, low);
               if(comparerToLow.Equals())
               {
                  ZigZagExtremum result(i, low, ZigZagExtremumType_Lower);
                  return result;
               }
            }
         }

         ZigZagExtremum emptyResult;         
         return emptyResult;
      }
      
};