#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class Filter
{
   public:
      virtual bool IsValid() = 0;      
      virtual Filter* GetCopy() = 0;
      virtual string TypeName() const = 0;
};