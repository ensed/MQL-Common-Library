#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include <Common Library\Signal Checker\SignalChecker.mqh>
#include <Common Library\Filter\Filter.mqh>
#include <Common Library\Helpers\PointersReleaser.mqh>

class SignalCheckerByFilter: public SignalChecker
{
   private:
      Filter* m_filter;
      
   public:
      SignalCheckerByFilter(Filter* filter)
      :
         m_filter(filter)
      {
      }
      
      ~SignalCheckerByFilter()
      {
         PointersReleaser::Release(m_filter);
      }
      
      virtual bool Exists() override
      {
         return m_filter.IsValid();
      }
};