#property strict

class CHMAParameters
{
	private:
		int m_period;
		ENUM_MA_METHOD m_method;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		CHMAParameters()
		{
			m_period = 5;
			m_method = MODE_LWMA;
			m_appliedPrice = PRICE_CLOSE;
		}

		CHMAParameters(const CHMAParameters &another)
		{
			this = another;
		}

		void CHMAParameters
		(
			const int period,  
			const ENUM_MA_METHOD method, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			m_period = period;
			m_method = method;
			m_appliedPrice = appliedPrice;
		}

		int Period() const { return m_period; }
		ENUM_MA_METHOD Method() const { return  m_method; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const CHMAParameters &another)
		{
			m_period = another.Period();
			m_method = another.Method();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const CHMAParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_method != another.Method()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const CHMAParameters &another) const
		{
			return !(another == this);
		}
};