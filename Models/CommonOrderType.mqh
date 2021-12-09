#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict
#include "..\Macros\Exceptions\UnexpectedEnumItemException.mqh"

enum EnumOrderType
{
   OrderType_None = -1,
   OrderType_Buy,
   OrderType_Sell,
   OrderType_BuyLimit,
   OrderType_SellLimit,
   OrderType_BuyStop,
   OrderType_SellStop
};

class EnumOrderTypeHelper
{
   public:
      static string ToString(const EnumOrderType type)
      {
         if(type == OrderType_None)
         {
            return "None";
         }
         else if(type == OrderType_Buy)
         {
            return "Buy";
         }
         else if(type == OrderType_Sell)
         {
            return "Sell";
         }
         else if(type == OrderType_BuyLimit)
         {
            return "BuyLimit";
         }
         else if(type == OrderType_SellLimit)
         {
            return "SellLimit";
         }
         else if(type == OrderType_BuyStop)
         {
            return "BuyStop";
         }
         else if(type == OrderType_SellStop)
         {
            return "SellStop";
         }
         else
         {
            UnexpectedEnumItemException(type);
            return NULL;            
         }
      }
      
      //EnumOrderType FromENUM_POSITION_TYPE(const ENUM_POSITION_TYPE type)
      //{
      //}
      static EnumOrderType Reverse(const EnumOrderType type)
      {
         if(type == OrderType_None)
         {
            return OrderType_None;
         }
         const int cmd = (int)type, 
                  baseCmd = cmd%2,
                  baseOppositeCmd = (baseCmd == OrderType_Buy) ? OrderType_Sell : OrderType_Buy,
                  OppositeCmd = (cmd-baseCmd+baseOppositeCmd);
         return (EnumOrderType) OppositeCmd;
      }
};

class CommonOrderType
{
   private:
      EnumOrderType m_type;
      
   public:
      void CommonOrderType()
      {
         m_type = OrderType_None;
      }

      void CommonOrderType(const EnumOrderType type)
      {
         m_type = type;
      }

      void CommonOrderType(const CommonOrderType &type)
      {
         m_type = type.Get();
      }

      EnumOrderType Get() const
      {
         return m_type;
      }      

      void operator=(const EnumOrderType type)
      {
         m_type = type;
      }      

      bool operator==(const EnumOrderType type) const
      {
         return (m_type == type);
      }

      bool operator!=(const EnumOrderType type) const
      {
         return !(this == type);
      }
      
      void operator=(const CommonOrderType &type)
      {
         m_type = type.Get();
      }
            
      bool operator==(const CommonOrderType &type) const
      {
         return (m_type == type.Get());
      }
      
      bool operator!=(const CommonOrderType &type) const
      {
         return !(this == type);
      }
      
      string ToString() const
      {
         if(m_type == OrderType_None)
         {
            return "None";
         }
         else if(m_type == OrderType_Buy)
         {
            return "Buy";
         }
         else if(m_type == OrderType_Sell)
         {
            return "Sell";
         }
         else if(m_type == OrderType_BuyLimit)
         {
            return "BuyLimit";
         }
         else if(m_type == OrderType_SellLimit)
         {
            return "SellLimit";
         }
         else if(m_type == OrderType_BuyStop)
         {
            return "BuyStop";
         }
         else if(m_type == OrderType_SellStop)
         {
            return "SellStop";
         }
         else
         {
            UnexpectedEnumItemException(m_type);
            return NULL;            
         }
      }
      
      #ifdef __MQL4__
      void operator=(const int type)
      {
         m_type = (EnumOrderType)type;
      }
      
      bool operator==(const int type)
      {
         if(type == -1)
         {
            return m_type == OrderType_None;
         }
         
         return (ToPlatformType() == type);
      }
      
      bool operator!=(const int type)
      {
         return !(this == type);
      }
      
      int ToPlatformType()
      {
         if(m_type == OrderType_Buy)
         {
            return OP_BUY;
         }
         else if(m_type == OrderType_Sell)
         {
            return OP_SELL;
         }
         else if(m_type == OrderType_BuyLimit)
         {
            return OP_BUYLIMIT;
         }
         else if(m_type == OrderType_SellLimit)
         {
            return OP_SELLLIMIT;
         }
         else if(m_type == OrderType_BuyStop)
         {
            return OP_BUYSTOP;
         }
         else if(m_type == OrderType_SellStop)
         {
            return OP_SELLSTOP;
         }
         else if(m_type == OrderType_None)
         {
            return -1;
         }
         else
         {
            UnexpectedEnumItemException(m_type);
            return -1;            
         }
      }
      #endif
      
      #ifdef __MQL5__
      void operator=(const ENUM_POSITION_TYPE type)
      {
         m_type = (EnumOrderType)type;
      }
      
      bool operator==(const ENUM_POSITION_TYPE type)
      {
         return (ToPositionType() == type);
      }
      
      bool operator!=(const ENUM_POSITION_TYPE type)
      {
         return !(this == type);
      }    
      
      ENUM_POSITION_TYPE ToPositionType() const
      {
         if(m_type == OrderType_Buy)
         {
            return POSITION_TYPE_BUY;
         }
         else if(m_type == OrderType_Sell)
         {
            return POSITION_TYPE_SELL;
         }
         else if(m_type == OrderType_None)
         {
            return (ENUM_POSITION_TYPE)m_type;
         }
         else
         {
            UnexpectedEnumItemException(m_type);
            return NULL;            
         }
      }
      
      void operator=(const ENUM_DEAL_TYPE type)
      {
         m_type = (EnumOrderType)type;
      }
      
      bool operator==(const ENUM_DEAL_TYPE type)
      {
         return (ToDealType() == type);
      }
      
      bool operator!=(const ENUM_DEAL_TYPE type)
      {
         return !(this == type);
      }    
      
      ENUM_DEAL_TYPE ToDealType() const
      {
         if(m_type == OrderType_Buy)
         {
            return DEAL_TYPE_BUY;
         }
         else if(m_type == OrderType_Sell)
         {
            return DEAL_TYPE_SELL;
         }
         else if(m_type == OrderType_None)
         {
            return (ENUM_DEAL_TYPE)m_type;
         }
         else
         {
            UnexpectedEnumItemException(m_type);
            return NULL;            
         }
      }
      
      void operator=(const ENUM_ORDER_TYPE type)
      {
         m_type = (EnumOrderType)type;
      }
      
      bool operator==(const ENUM_ORDER_TYPE type)
      {
         return (ToOrderTypeType() == type);
      }
      
      bool operator!=(const ENUM_ORDER_TYPE type)
      {
         return !(this == type);
      }   
                  
      ENUM_ORDER_TYPE ToOrderTypeType() const
      {
         if(m_type == OrderType_Buy)
         {
            return ORDER_TYPE_BUY;
         }
         else if(m_type == OrderType_Sell)
         {
            return ORDER_TYPE_SELL;
         }
         else if(m_type == OrderType_BuyLimit)
         {
            return ORDER_TYPE_BUY_LIMIT;
         }
         else if(m_type == OrderType_SellLimit)
         {
            return ORDER_TYPE_SELL_LIMIT;
         }
         else if(m_type == OrderType_BuyStop)
         {
            return ORDER_TYPE_BUY_STOP;
         }
         else if(m_type == OrderType_SellStop)
         {
            return ORDER_TYPE_SELL_STOP;
         }
         else if(m_type == OrderType_None)
         {
            return (ENUM_ORDER_TYPE)m_type;
         }
         else
         {
            UnexpectedEnumItemException(m_type);
            return NULL;            
         }
      }
      #endif
};
