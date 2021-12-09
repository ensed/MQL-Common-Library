#property strict

template <typename T>
class ValueCalculator
{
   public:
      virtual T Calculate() = 0;      
      virtual ValueCalculator<T>* GetCopy() = 0;   
};