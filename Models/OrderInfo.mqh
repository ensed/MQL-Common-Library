#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

#include "..\Models\CommonOrderType.mqh"

class OrderInfo
{
	private:
		
	public:
		OrderInfo()
		{
	      Ticket = 0;
   		TimeOpen = (datetime)0;
   		Type = OrderType_None;
   		Size = 0.0;
   		Symbol = "";
   		PriceOpen = 0.0;
   		StopLoss = 0.0;
   		TakeProfit = 0.0;
   		TimeClose = (datetime)0;
   		PriceClose = 0.0;
   		Comissions = 0.0;
   		Swap = 0.0;
   		Profit = 0.0;
   		Magic = 0;
   		Comment = "";
		}

		OrderInfo(const OrderInfo &another)
		{
			this = another;
		}
		
		void Init
		(
   		const long ticket,
   		const datetime timeOpen,
   		const EnumOrderType type,
   		const double size,
   		const string symbol,
   		const double priceOpen,
   		const double stopLoss,
   		const double takeProfit,
   		const datetime timeClose,
   		const double priceClose,
   		const double comissions,
   		const double swap,
   		const double profit,
   		const int magic,
   		const string comment
		)
		{
   		Ticket = ticket;
   		TimeOpen = timeOpen;
   		Type = type;
   		Size = size;
   		Symbol = symbol;
   		PriceOpen = priceOpen;
   		StopLoss = stopLoss;
   		TakeProfit = takeProfit;
   		TimeClose = timeClose;
   		PriceClose = priceClose;
   		Comissions = comissions;
   		Swap = swap;
   		Profit = profit;
   		Magic = magic;
   		Comment = comment;
		}
		
      #ifdef __MQL5__
		void InitByTicket(const int ticket)
		{
			InitBySelected();
		}
   
		void InitBySelected()
		{
			Ticket = PositionGetInteger(POSITION_TICKET);
			TimeOpen = (datetime)PositionGetInteger(POSITION_TIME);
			Type = (EnumOrderType)PositionGetInteger(POSITION_TYPE);
			Size = PositionGetDouble(POSITION_VOLUME);
			Symbol = PositionGetString(POSITION_SYMBOL);
			PriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
			StopLoss = PositionGetDouble(POSITION_SL);
			TakeProfit = PositionGetDouble(POSITION_TP);
			TimeClose = (datetime)0;
			PriceClose = PositionGetDouble(POSITION_PRICE_CURRENT);
			Comissions = GetPositionCommission();
			Swap = PositionGetDouble(POSITION_SWAP);
			Profit = PositionGetDouble(POSITION_PROFIT);
			Magic = (int)PositionGetInteger(POSITION_MAGIC);
			Comment = PositionGetString(POSITION_COMMENT);
		}
		
		void Update(const bool isTester)
		{
		   if(IsTypeMarket())
		   {
		      if(PositionSelectByTicket(Ticket))
		      {
		         UpdateBySelected(isTester);
		      }
		      else
		      {
               InitByHistoryDeal(Ticket);
		      }
		   }
		   else
		   {
		      if(OrderSelect(Ticket))
		      {
		         UpdateBySelectedOrder();
		      }
		   }
		}
		
		void UpdateBySelected(const bool isTester)
		{
			//Ticket = PositionGetInteger(POSITION_TICKET);
			//TimeOpen = (datetime)PositionGetInteger(POSITION_TIME);
			//Type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
			Size = PositionGetDouble(POSITION_VOLUME);
			//Symbol = PositionGetString(POSITION_SYMBOL);
			//PriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
			StopLoss = PositionGetDouble(POSITION_SL);
			TakeProfit = PositionGetDouble(POSITION_TP);
			//TimeClose = (datetime)0;
			PriceClose = PositionGetDouble(POSITION_PRICE_CURRENT);
			//Comissions = GetPositionCommission();
			Swap = PositionGetDouble(POSITION_SWAP);
			Profit = PositionGetDouble(POSITION_PROFIT);
			//Magic = (int)PositionGetInteger(POSITION_MAGIC);
			if(!isTester)
			{
			   Comment = PositionGetString(POSITION_COMMENT);
			}
		}
		
		void InitByHistoryDeal(ulong ticket)
		{
		   HistorySelect(TimeOpen, TimeCurrent()+1);
         
		   ulong positionId = GetHistoryTicket(ticket);
		   if(positionId == 0)
		   {
		      positionId = ticket;
		   }


			Ticket = HistoryDealGetInteger(positionId, DEAL_ORDER);			
			Type = (EnumOrderType)HistoryDealGetInteger(positionId, DEAL_TYPE);
			Size = HistoryDealGetDouble(positionId, DEAL_VOLUME);
			Symbol = HistoryDealGetString(positionId, DEAL_SYMBOL);
			StopLoss = HistoryOrderGetDouble(positionId, ORDER_SL);			                                                         
			TakeProfit = HistoryOrderGetDouble(positionId, ORDER_TP);			
			TimeClose = (datetime)HistoryDealGetInteger(positionId, DEAL_TIME);
			PriceClose = HistoryDealGetDouble(positionId, DEAL_PRICE);
			Comissions = HistoryDealGetDouble(positionId, DEAL_COMMISSION) * 2.0;
			Swap = HistoryDealGetDouble(positionId, DEAL_SWAP);
			Profit = HistoryDealGetDouble(positionId, DEAL_PROFIT);

			Magic = (int)HistoryDealGetInteger(positionId, DEAL_MAGIC);		
				

         long orderTicket = HistoryDealGetInteger(positionId, DEAL_ORDER);
         long entryTicket = HistoryOrderGetInteger(orderTicket, ORDER_POSITION_ID);   
         if(entryTicket == 0)
         {
            entryTicket = HistoryDealGetInteger(orderTicket, DEAL_POSITION_ID);
         }
         
         long historyTicket = 0;
         if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
         {
            historyTicket = (long)positionId;
         }
         else
         {
            historyTicket = GetHistoryTicketByOrderTicket(entryTicket);
            if(historyTicket == 0)
            {
               historyTicket = entryTicket;
            }
         }
         
         TimeOpen = (datetime)HistoryDealGetInteger(historyTicket, DEAL_TIME);
         PriceOpen = HistoryDealGetDouble(historyTicket, DEAL_PRICE);
			Comment = HistoryDealGetString(historyTicket, DEAL_COMMENT);
			
			if(Comment == "")
			{
			   Comment = HistoryOrderGetString(historyTicket, ORDER_COMMENT);	
			}
		}
		
		void InitBySelectedOrder()
		{
			Ticket = OrderGetInteger(ORDER_TICKET);
			TimeOpen = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
			Type = (EnumOrderType)OrderGetInteger(ORDER_TYPE);
			Size = OrderGetDouble(ORDER_VOLUME_CURRENT);
			Symbol = OrderGetString(ORDER_SYMBOL);
			PriceOpen = OrderGetDouble(ORDER_PRICE_OPEN);
			StopLoss = OrderGetDouble(ORDER_SL);
			TakeProfit = OrderGetDouble(ORDER_TP);
			TimeClose = (datetime)0;
			PriceClose = OrderGetDouble(ORDER_PRICE_CURRENT);
			Comissions = 0.0;
			Swap = 0.0;
			Profit = 0.0;
			Magic = (int)OrderGetInteger(ORDER_MAGIC);
			Comment = OrderGetString(ORDER_COMMENT);
		}
		
		void InitBySelectedHistoryOrder(const int ticket)
		{
			Ticket = ticket;//HistoryOrderGetInteger(ORDER_TICKET);
			TimeOpen = (datetime)HistoryOrderGetInteger(ticket, ORDER_TIME_SETUP);
			Type = (EnumOrderType)HistoryOrderGetInteger(ticket, ORDER_TYPE);
			Size = HistoryOrderGetDouble(ticket, ORDER_VOLUME_CURRENT);
			Symbol = HistoryOrderGetString(ticket, ORDER_SYMBOL);
			PriceOpen = HistoryOrderGetDouble(ticket, ORDER_PRICE_OPEN);
			StopLoss = HistoryOrderGetDouble(ticket, ORDER_SL);
			TakeProfit = HistoryOrderGetDouble(ticket, ORDER_TP);
			TimeClose = (datetime)0;
			PriceClose = HistoryOrderGetDouble(ticket, ORDER_PRICE_CURRENT);
			Comissions = 0.0;
			Swap = 0.0;
			Profit = 0.0;
			Magic = (int)HistoryOrderGetInteger(ticket, ORDER_MAGIC);
			Comment = HistoryOrderGetString(ticket, ORDER_COMMENT);			
		}
		
		void UpdateBySelectedOrder()
		{
			//Ticket = OrderGetInteger(ORDER_TICKET);
			//TimeOpen = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
			//Type = (EnumOrderType)OrderGetInteger(ORDER_TYPE);
			//Size = OrderGetDouble(ORDER_VOLUME_CURRENT);
			//Symbol = OrderGetString(ORDER_SYMBOL);
			PriceOpen = OrderGetDouble(ORDER_PRICE_OPEN);
			StopLoss = OrderGetDouble(ORDER_SL);
			TakeProfit = OrderGetDouble(ORDER_TP);
			//TimeClose = (datetime)0;
			PriceClose = OrderGetDouble(ORDER_PRICE_CURRENT);
			//Comissions = 0.0;
			//Swap = 0.0;
			//Profit = 0.0;
			//Magic = (int)OrderGetInteger(ORDER_MAGIC);
			//Comment = OrderGetString(ORDER_COMMENT);
		}		
		#endif
      
      #ifdef __MQL4__
		void InitByTicket(const int ticket)
		{
		   if(OrderSelect(ticket, SELECT_BY_TICKET))
		   {
			   InitBySelected();
			}
		}

		void Update(const bool isTester)
		{		
		   if(!OrderSelect((int)Ticket, SELECT_BY_TICKET))
		   {
			   return;
			}
			//Ticket = OrderTicket();
			//TimeOpen = OrderOpenTime();
			//Type = (EnumOrderType)OrderType();
			Size = OrderLots();
			//Symbol = OrderSymbol();
			//PriceOpen = OrderOpenPrice();
			StopLoss = OrderStopLoss();
			TakeProfit = OrderTakeProfit();
			TimeClose = OrderCloseTime();
			PriceClose = OrderClosePrice();
			//Comissions = OrderCommission();
			Swap = OrderSwap();
			Profit = OrderProfit();
			//Magic = OrderMagicNumber();
			if(!isTester)
			{
			   Comment = OrderComment();
			}
		}

		void InitBySelected()
		{
			Ticket = OrderTicket();
			TimeOpen = OrderOpenTime();
			Type = (EnumOrderType)OrderType();
			Size = OrderLots();
			Symbol = OrderSymbol();
			PriceOpen = OrderOpenPrice();
			StopLoss = OrderStopLoss();
			TakeProfit = OrderTakeProfit();
			TimeClose = OrderCloseTime();
			PriceClose = OrderClosePrice();
			Comissions = OrderCommission();
			Swap = OrderSwap();
			Profit = OrderProfit();
			Magic = OrderMagicNumber();
			Comment = OrderComment();
		}
		#endif 

		long Ticket;
		datetime TimeOpen;
		EnumOrderType Type;
		
		
		bool IsTypeMarket() const
		{		   
		   return Type == OrderType_Buy || Type == OrderType_Sell;
		}
		
		bool IsTypeBuy() const { return Type == OrderType_Buy; }
		bool IsTypeSell() const { return Type == OrderType_Sell; }
        
		double Size;
		string Symbol;
		double PriceOpen;
		double StopLoss;
		double TakeProfit;
		datetime TimeClose;
		double PriceClose;
		double Comissions;
		double Swap;
		double Profit;
		int Magic;
		string Comment;

      string ToString() const
      {
         int digits = Symbol == "" ? 8 : (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
         
         return StringFormat
         (
            "<Order>%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%d;%s</Order>",
   			(string)Ticket,
   			(string)((int)TimeOpen),
   			EnumOrderTypeHelper::ToString(Type),
   			DoubleToString(Size, 2),
   			Symbol,
   			DoubleToString(PriceOpen, digits),
   			DoubleToString(StopLoss, digits),
   			DoubleToString(TakeProfit, digits),
   			(string)((int)TimeClose),
   			DoubleToString(PriceClose, digits),
   			DoubleToString(Comissions, 2),
   			DoubleToString(Swap, 2),
   			DoubleToString(Profit, 2),
   			Magic,
   			Comment
         );
      }

		void operator=(const OrderInfo &another)
		{
		   Ticket = another.Ticket;
		   Symbol = another.Symbol;   			
		   Magic = another.Magic;

			TimeOpen = another.TimeOpen;
			Type = another.Type;						
			PriceOpen = another.PriceOpen;			
			StopLoss = another.StopLoss;
			TakeProfit = another.TakeProfit;
			TimeClose = another.TimeClose;
			PriceClose = another.PriceClose;
			Comissions = another.Comissions;
			Swap = another.Swap;
			Profit = another.Profit;
			Size = another.Size;
			Comment = another.Comment;
		}
		
      int Compare(const OrderInfo &node,const int mode=0) const
      {
         if(mode >= 0)
         {
            if(this.TimeOpen > node.TimeOpen)
            {
               return -1;
            }
            else
            {
               return 1;
            }
         }
         else
         {
            if(this.Ticket < node.Ticket)
            {
               return -1;
            }
            else
            {
               return 1;
            }         
         }         
      }
/*
		bool operator==(const OrderInfo &another) const
		{
			if(Ticket != another.Ticket()){ return false; }
			if(TimeOpen != another.TimeOpen()){ return false; }
			if(Type != another.Type()){ return false; }
			if(Size != another.Size()){ return false; }
			if(Symbol != another.Symbol()){ return false; }
			if(PriceOpen != another.PriceOpen()){ return false; }
			if(StopLoss != another.StopLoss()){ return false; }
			if(TakeProfit != another.TakeProfit()){ return false; }
			if(TimeClose != another.TimeClose()){ return false; }
			if(PriceClose != another.PriceClose()){ return false; }
			if(Comissions != another.Comissions()){ return false; }
			if(Swap != another.Swap()){ return false; }
			if(Profit != another.Profit()){ return false; }
			if(Magic != another.Magic()){ return false; }
			if(Comment != another.Comment()){ return false; }

			return true;
		}

		bool operator!=(const OrderInfo &another) const
		{
			return !(another == this);
		}  */
		
   private:   
      #ifdef __MQL5__
      // based on: https://www.mql5.com/en/forum/204807#comment_5327273
      double GetPositionCommission( void )
      {
         double Commission = ::PositionGetDouble(POSITION_COMMISSION);
         
         // For the case if 'POSITION_COMMISSION' does not works
         if (Commission == 0)
         {
            //if(! MQLInfoInteger(MQL_TESTER) )
            //{
            //   if( RealTimeHelper::getCommissionOpenOrder( Ticket, Commission ) )
            //   {
            //      return Commission;
            //   }
            //}
            const ulong ticket = GetPositionDealIn();
            
            if (ticket > 0)
            {
               const double LotsIn = ::HistoryDealGetDouble(ticket, DEAL_VOLUME);
            
               if (LotsIn > 0)
               {
                  Commission = ::HistoryDealGetDouble(ticket, DEAL_COMMISSION) * ::PositionGetDouble(POSITION_VOLUME) / LotsIn;
               }
            }
         }
         
         return(Commission);
      }
      
      ulong GetPositionDealIn( const ulong PositionIdentifier = 0 )
      {
         ulong ticket = 0;
         
         if ((PositionIdentifier == 0) ? ::HistorySelectByPosition(::PositionGetInteger(POSITION_IDENTIFIER)) : ::HistorySelectByPosition(PositionIdentifier))
         {
            const int Total = ::HistoryDealsTotal();
            
            for (int i = 0; i < Total; i++)
            {
               const ulong TicketDeal = ::HistoryDealGetTicket(i);
               
               if (TicketDeal > 0)
               {
                  if ((ENUM_DEAL_ENTRY)::HistoryDealGetInteger(TicketDeal, DEAL_ENTRY) == DEAL_ENTRY_IN)
                  {
                     ticket = TicketDeal;
                     
                     break;
                  }
               }
            }
         }
         
         return(Ticket);
      }
      #endif 
      
      #ifdef __MQL5__
      private:
         ulong GetHistoryTicket(const ulong openedTicket)
         {			   
            if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
            {
               return openedTicket;
            }
            else
            {
      		   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
      		   {
      		      ulong historyTicket = HistoryDealGetTicket(i);
   
      		      if(historyTicket == openedTicket)
      		      {
      		         continue;
      		      }
   
      		      if(openedTicket == HistoryDealGetInteger(historyTicket, DEAL_POSITION_ID))
      		      {
      		         return historyTicket;
      		      }
      		   }
               return 0;
            }
         }
      #endif 
      
      #ifdef __MQL5__
      private:
         long GetHistoryTicketByOrderTicket(const long orderTicket)
         {			   
   		   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
   		   {
   		      long historyTicket = (long)HistoryDealGetTicket(i);

   		      if(orderTicket == HistoryDealGetInteger(historyTicket, DEAL_ORDER))
   		      {
   		         return historyTicket;
   		      }
   		   }
            return 0;
         }
      #endif 
};