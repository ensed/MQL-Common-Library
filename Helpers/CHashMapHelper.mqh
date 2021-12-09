#property strict

#include <Generic\HashMap.mqh>
#include <Common Library\Helpers\PointersReleaser.mqh>

template<typename TKey,typename TValue>
void ClearPointerValuesOfHashMap(CHashMap<TKey, TValue> &hashmap)
{
   TKey keys[];
   TValue values[];
   hashmap.CopyTo(keys, values);

   PointersReleaser::Release(values);
}

template<typename TKey,typename TValue>
void ClearPointerValuesOfHashMap(CHashMap<TKey, TValue>* &hashmap)
{
   if(CheckPointer(hashmap) != POINTER_INVALID)
   {
      if(CheckPointer(hashmap) == POINTER_DYNAMIC)
      {
         TKey keys[];
         TValue values[];
         hashmap.CopyTo(keys, values);
         PointersReleaser::Release(values);
      }
   }
}

template<typename TKey,typename TValue>
void ClearPointerKeysOfHashMap(CHashMap<TKey, TValue> &hashmap)
{
   TKey keys[];
   TValue values[];
   hashmap.CopyTo(keys, values);
   PointersReleaser::Release(keys);
}

template<typename TKey,typename TValue>
void ClearPointerKeysOfHashMap(CHashMap<TKey, TValue>* &hashmap)
{
   if(CheckPointer(hashmap) != POINTER_INVALID)
   {
      if(CheckPointer(hashmap) == POINTER_DYNAMIC)
      {
         TKey keys[];
         TValue values[];
         hashmap.CopyTo(keys, values);
         PointersReleaser::Release(keys);
      }
   }
}