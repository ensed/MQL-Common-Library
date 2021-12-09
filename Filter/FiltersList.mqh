#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "Filter.mqh"
#include "..\List\ObjectsList.mqh"

class FiltersList : public ObjectsList<Filter*>
{      
   public:
      bool IsAnyValid()
      {
         for(int i = 0; i < ItemsCount(); i++)
         {
            if(CheckPointer(this[i]) == POINTER_INVALID)
            {
               continue;
            }

            if(this[i].IsValid())
            {
               return true;
            }
         }         
         
         return false;
      }
      
      Filter* GetItemCopy(const int index)
      {
         return this[index].GetCopy();
      }
};