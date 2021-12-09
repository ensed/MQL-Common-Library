#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

//#define ADD_TO_ARRAY_TRACING_ENABLED (1)

#ifdef ADD_TO_ARRAY_TRACING_ENABLED
   #define ADD_TO_ARRAY_TRACING_CALLER , __FILE__+" " + (string)__LINE__
   #define ADD_TO_ARRAY_TRACING_CALLER_PARAMETER , const string caller
#else 
   #define ADD_TO_ARRAY_TRACING_CALLER  
   #define ADD_TO_ARRAY_TRACING_CALLER_PARAMETER  
#endif 

class ArraysHelper
{
   public:
      template<typename T>
      static void CopyArray(T* &source[], T* &destination[])
      {         
         int size = ArraySize(source);
         
         if(size != ArraySize(destination))
         {
            ArrayFree(destination);
            ArrayResize(destination, size);
         }
         
         for(int i=0; i<size; i++)
         {
            destination[i] = source[i];
         }
      }
      
      template<typename T>
      static void CopyArray(const T &source[], T &destination[])
      {
         int size = ArraySize(source);
         
         if(size != ArraySize(destination))
         {
            ArrayResize(destination, size);
         }
         
         for(int i=0; i<size; i++)
         {
            destination[i] = source[i];
         }
      }
      
      template<typename T>
      static void AddToArray(T* item, T* &array[] ADD_TO_ARRAY_TRACING_CALLER_PARAMETER)
      {
         int index = ArraySize(array);
         ArrayResize(array, index + 1, 1000);
         #ifdef ADD_TO_ARRAY_TRACING_ENABLED
            if(ArraySize(array) <= index)
            {
               Print("Caller = ", caller);
            }
         #endif 
         array[index] = item;
      }
      
      template<typename T>
      static void AddToArray(const T &item, T &array[] ADD_TO_ARRAY_TRACING_CALLER_PARAMETER)
      {
         int index = ArraySize(array);
         ArrayResize(array, index + 1, 1000);
         #ifdef ADD_TO_ARRAY_TRACING_ENABLED
            if(ArraySize(array) <= index)
            {
               Print("Caller = ", caller);
            }
         #endif 
         array[index] = item;
      }
      
      template<typename T>
      static void InsertToArray(T* item, T* &array[], const int index)
      {
         int arraySize = ArraySize(array);
         if(arraySize < index + 1)
         {
            ArrayResize(array, index + 1, 1000);
         }

         array[index] = item;
      }
      
      template<typename T>
      static void InsertToArray(const T &item, T &array[], const int index)
      {
         int arraySize = ArraySize(array);
         if(arraySize < index + 1)
         {
            ArrayResize(array, index + 1, 1000);
         }

         array[index] = item;
      }
      
      template<typename T>
      static bool ItemExistsInArray(const T &item, const T &array[])
      {
         for(int i=0; i<ArraySize(array); i++)
         {
            if(item==array[i])
            {
               return true;
            }
         }
         
         return false;
      }
      
      template<typename T>
      static int ItemIndex(const T &item, const T &array[])
      {
         for(int i=0; i<ArraySize(array); i++)
         {
            if(item==array[i])
            {
               return i;
            }
         }
         
         return -1;
      }
      
      template<typename T>
      static bool ItemRemove(const T &item, T &array[])
      {
         int index = ItemIndex(item, array);
         
         if(index == -1)
         {
            return false;
         }
         
         T newArray[];         
         
         for(int i=0; i<ArraySize(array); i++)
         {
            if(i != index)
            {
               AddToArray(array[i], newArray ADD_TO_ARRAY_TRACING_CALLER);
            }
         }
         
         ArrayFree(array);
         for(int i = 0; i < ArraySize(newArray); i++)
         {
            AddToArray(newArray[i], array ADD_TO_ARRAY_TRACING_CALLER);
         }
         
         return true;
      }
      
      template<typename T>
      static bool ItemRemoveAt(const int index, T &array[])
      {         
         T newArray[];         
         
         for(int i=0; i<ArraySize(array); i++)
         {
            if(i != index)
            {
               AddToArray(array[i], newArray ADD_TO_ARRAY_TRACING_CALLER);
            }
         }
         
         ArrayFree(array);
         for(int i = 0; i < ArraySize(newArray); i++)
         {
            AddToArray(newArray[i], array ADD_TO_ARRAY_TRACING_CALLER);
         }
         
         return true;
      }
      
      template<typename T>
      static void BubbleSort(T &array[])
      {
         // For using this method a class T should have a 'Compare' method with this signature:
         //   int Compare(const T &node,const int mode=0) const
         // and operator '=' with this signature:
         //   void operator = (const T &node)
         // where 'T' is a name of the class.
               
         bool anyValuesSwapped = false;

         for(int i = 0; i < ArraySize(array); i++)
         {
            anyValuesSwapped = false;
      
            for(int j = 0; j < ArraySize(array) - i - 1; j++)
            {
               if(array[j].Compare(array[j + 1]) < 0)
               {
                  T tmp = array[j];
      
                  array[j] = array[j + 1];
                  array[j + 1] = tmp;
      
                  anyValuesSwapped = true;
               }
            }
        
            if(!anyValuesSwapped)
            {
               break;
            } 
         } 
      }
      
      template<typename T>
      static void BubbleSort(T* &array[])
      {
         // For using this method a class T should have a 'Compare' method with this signature:
         //   int Compare(const T &node,const int mode=0) const
         // and operator '=' with this signature:
         //   void operator = (const T &node)
         // where 'T' is a name of the class.
         T* tmp = NULL;
               
         bool anyValuesSwapped = false;

         for(int i = 0; i < ArraySize(array); i++)
         {
            anyValuesSwapped = false;
      
            for(int j = 0; j < ArraySize(array) - i - 1; j++)
            {
               if(array[j].Compare(array[j + 1]) < 0)
               {
                  tmp = array[j];
      
                  array[j] = array[j + 1];
                  array[j + 1] = tmp;
      
                  anyValuesSwapped = true;
               }
            }
        
            if(!anyValuesSwapped)
            {
               break;
            } 
         } 
      }
};