#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "Filter.mqh"

class FilterEmpty : public Filter
{     
   public:
      virtual bool IsValid() override
      {
         return false;
      }
      
      virtual Filter* GetCopy() override final
      {
         return new FilterEmpty();
      }
      
      virtual string TypeName() const override final { return typename(this); }
};