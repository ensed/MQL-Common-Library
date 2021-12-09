#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class PointersReleaser
{
   public:
      template<typename T>
      static void Release(T &pointer)
      {
         if(CheckPointer(pointer) != POINTER_INVALID)
         {
            if(CheckPointer(pointer) == POINTER_DYNAMIC)
            {
               delete pointer;
               pointer = NULL;
            }
         }
      }

      template<typename T>
      static void Release(T &pointersArray[])
      {
         for(int i = 0; i < ArraySize(pointersArray); i++)
         {
            Release(pointersArray[i]);
         }
         
         ArrayFree(pointersArray);
      }     
};

