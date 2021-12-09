#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#include "OrdersProcessor.mqh"
#include "..\List\ObjectsList.mqh"

#property strict

class OrdersProcessorsList : public ObjectsList<OrdersProcessor*>
{
   public:
      void ExecuteAll()
      {
         for(int i = 0; i < ItemsCount(); i++)
         {
            if(CheckPointer(this[i]) == POINTER_INVALID)
            {
               continue;
            }

            this[i].Execute();
         } 
      }
      
};