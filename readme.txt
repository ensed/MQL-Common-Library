This is an open-source common library for MQL4 and MQL5 languages. The main goal of this library is an abstraction from the low-level details of concrete APIs of these languages. Because of this, we can write the same code for both platforms (MetaTrader 4 and MetaTrader 5) at the same time.

For example, if we want to open Buy trade, we can write just:
	OrderOpener opener(Symbol(), OrderType_Buy, 111, 0.1, "Comment", 10); // where 111 -> magic number, 0.1 -> volume, "Comment" -> trade's comment, 10 -> slippage
	int ticket = opener.Open();
	if(ticket == -1)
	{
		MarketError me(opener.ErrorCode());
		Print("Error: ", me.ToString());
	}
And that's all! This code will works on both platforms - MetaTrader 4 and MetaTrader 5.

Also, this library includes some usually required things like signals checkers by the moving averages crossing, filters by existing of another trade(s)/order(s), getters of trade(s)/order(s) by some rules etc

This library proposes some architecture for creating EAs. I hope you'll find it helpful and consider using what I'm using in my real work every day.

© 2018, Sergei Eremin