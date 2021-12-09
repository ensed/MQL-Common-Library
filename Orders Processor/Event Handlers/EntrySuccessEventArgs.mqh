#ifdef __MQL4__
#property strict
#endif

#include "..\..\Event Handler\EventArgs.mqh"
#include "..\..\Models\OrderInfo.mqh"
#include "..\..\Filter\FiltersList.mqh"
#include "..\..\Signal Checker\SignalsCheckerListAny.mqh"

class EntrySuccessEventArgs: public EventArgs
{
	private:
		FiltersList* m_filters;
		SignalsCheckerListAny* m_signalsCheckers;
		OrderInfo m_orderInfo;

	public:
		EntrySuccessEventArgs()
		{
			m_filters = NULL;
			m_signalsCheckers = NULL;
		}

		EntrySuccessEventArgs(const EntrySuccessEventArgs &another)
		{
			this = another;
		}

		EntrySuccessEventArgs
		(
			FiltersList* &filters, 
			SignalsCheckerListAny* &signalsCheckers, 
			const OrderInfo &orderInfo
		)
		{
			Init(filters, signalsCheckers, orderInfo);
		}

		void Init
		(
			FiltersList* &filters, 
			SignalsCheckerListAny* &signalsCheckers, 
			const OrderInfo &orderInfo
		)
		{
			m_filters = filters;
			m_signalsCheckers = signalsCheckers;
			m_orderInfo = orderInfo;
		}

		FiltersList* Filters() const { return m_filters; }
		SignalsCheckerListAny* SignalsCheckers() const { return m_signalsCheckers; }
		OrderInfo OrderInfo() const { return m_orderInfo; }
};