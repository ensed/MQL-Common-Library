#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "..\Helpers\ArraysHelper.mqh"
#include "..\Helpers\PointersReleaser.mqh"

template <typename T> class ObjectsList
{
   protected:
      T m_items[];
      int m_itemsCount;
//static int ms_counter;
   public:
      ObjectsList()
      {
         ArrayFree(m_items);
         m_itemsCount = 0;
      }
      
      ObjectsList(T &items[])
      {
         ArraysHelper::CopyArray(items, m_items);
         m_itemsCount = ArraySize(m_items);
      }
      
      ~ObjectsList()
      {         
         PointersReleaser::Release(m_items);
         m_itemsCount = 0;
      }
      
      void Add(T item)
      {
         ArraysHelper::AddToArray(item, m_items ADD_TO_ARRAY_TRACING_CALLER);
         m_itemsCount = ArraySize(m_items);
      }
      
      void Add(T &items[])
      {
         for(int i = 0; i < ArraySize(items); i++)
         {
            Add(items[i]);
         }
      }
      
      int ItemsCount() const
      {
         return m_itemsCount;
      }
      
      T operator[](const int index) const
      {
         return m_items[index];
      }
      
      void ItemsClear()
      {
         if(m_itemsCount > 0)
         {
            if(CheckPointer(m_items[0]) == POINTER_DYNAMIC)
            {
               PointersReleaser::Release(m_items);
            }
         }
         
         ArrayFree(m_items);
         m_itemsCount = 0;         
      }
      
      void ItemRemove(const int index)
      {
         ArraysHelper::ItemRemoveAt(index, m_items);
         m_itemsCount = ArraySize(m_items);
      }
};
//template <typename T> int ObjectsList::ms_counter=0;
