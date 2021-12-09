#property strict
#ifdef __MQL4__
#ifdef __MQL4__
#property strict
#endif

class ADXParameters
{
	private:
		int m_period;
		ENUM_APPLIED_PRICE m_appliedPrice;

	public:
		ADXParameters()
		{
			m_period = 14;
			m_appliedPrice = PRICE_CLOSE;
		}

		ADXParameters(const ADXParameters &another)
		{
			this = another;
		}

		ADXParameters
		(
			const int period, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			Init(period, appliedPrice);
		}

		void Init
		(
			const int period, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			m_period = period;
			m_appliedPrice = appliedPrice;
		}

		void Period(const int value) { m_period = value; }
		int Period() const { return m_period; }

		void AppliedPrice(const ENUM_APPLIED_PRICE value) { m_appliedPrice = value; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const ADXParameters &another)
		{
			m_period = another.Period();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const ADXParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const ADXParameters &another) const
		{
			return !(another == this);
		}

};
#endif 