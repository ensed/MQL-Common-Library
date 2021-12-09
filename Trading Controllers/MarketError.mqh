#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class MarketError
{
   private:
      int m_code;
      
   public:
      MarketError(const int code)
      {
         m_code = code;
      }
      
      string ToString()
      {
         #ifdef __MQL5__
            return (string)m_code;
         #endif 
         
         #ifdef __MQL4__
         if(m_code == ERR_NO_ERROR)
         {
            return "No	error returned";
         }         
         else if(m_code == ERR_NO_RESULT)
         {
         	return "No	error returned, but the result is unknown";
         }
         else if(m_code == ERR_COMMON_ERROR)
         {
         	return "Common	error";
         }
         else if(m_code == ERR_INVALID_TRADE_PARAMETERS)
         {
         	return "Invalid trade parameters";
         }
         else if(m_code == ERR_SERVER_BUSY)
         {
         	return "OrderOpener server is busy";
         }
         else if(m_code == ERR_OLD_VERSION)
         {
         	return "Old version of the client terminal";
         }
         else if(m_code == ERR_NO_CONNECTION)
         {
         	return "No connection with trade server";
         }
         else if(m_code == ERR_NOT_ENOUGH_RIGHTS)
         {
         	return "Not enough rights";
         }
         else if(m_code == ERR_TOO_FREQUENT_REQUESTS)
         {
         	return "Too frequent requests";
         }
         else if(m_code == ERR_MALFUNCTIONAL_TRADE)
         {
         	return "Malfunctional trade operation";
         }
         else if(m_code == ERR_ACCOUNT_DISABLED)
         {
         	return "Account disabled";
         }
         else if(m_code == ERR_INVALID_ACCOUNT)
         {
         	return "Invalid account";
         }
         else if(m_code == ERR_TRADE_TIMEOUT)
         {
         	return "OrderOpener timeout";
         }
         else if(m_code == ERR_INVALID_PRICE)
         {
         	return "Invalid price";
         }
         else if(m_code == ERR_INVALID_STOPS)
         {
         	return "Invalid stops";
         }
         else if(m_code == ERR_INVALID_TRADE_VOLUME)
         {
         	return "Invalid trade volume";
         }
         else if(m_code == ERR_MARKET_CLOSED)
         {
         	return "Market is closed";
         }
         else if(m_code == ERR_TRADE_DISABLED)
         {
         	return "OrderOpener is disabled";
         }
         else if(m_code == ERR_NOT_ENOUGH_MONEY)
         {
         	return "Not enough money";
         }
         else if(m_code == ERR_PRICE_CHANGED)
         {
         	return "Price changed";
         }
         else if(m_code == ERR_OFF_QUOTES)
         {
         	return "Off quotes";
         }
         else if(m_code == ERR_BROKER_BUSY)
         {
         	return "Broker is busy";
         }
         else if(m_code == ERR_REQUOTE)
         {
         	return "Requote";
         }
         else if(m_code == ERR_ORDER_LOCKED)
         {
         	return "Order is locked";
         }
         else if(m_code == ERR_LONG_POSITIONS_ONLY_ALLOWED)
         {
         	return "Buy orders only allowed";
         }
         else if(m_code == ERR_TOO_MANY_REQUESTS)
         {
         	return "Too many requests";
         }
         else if(m_code == ERR_TRADE_MODIFY_DENIED)
         {
         	return "Modification denied because order is too close to market";
         }
         else if(m_code == ERR_TRADE_CONTEXT_BUSY)
         {
         	return "Trade context is busy";
         }
         else if(m_code == ERR_TRADE_EXPIRATION_DENIED)
         {
         	return "Expirations are denied by broker";
         }
         else if(m_code == ERR_TRADE_TOO_MANY_ORDERS)
         {
         	return "The amount of open and pending orders has reached the limit set by the broker";
         }
         else if(m_code == ERR_TRADE_HEDGE_PROHIBITED)
         {
         	return "An attempt to open an order opposite to the existing one when hedging is disabled";
         }
         else if(m_code == ERR_TRADE_PROHIBITED_BY_FIFO)
         {
         	return "An attempt to close an order contravening the FIFO rule";
         }
         #endif 
         
         return "N/A";
      }    
};