#property strict

class MAParameters
{
	private:
		int m_period;
		int m_shift;
		ENUM_MA_METHOD m_method;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		MAParameters()
		{
			m_period = 14;
			m_shift = 0;
			m_method = MODE_SMA;
			m_appliedPrice = PRICE_CLOSE;
		}

		MAParameters(const MAParameters &another)
		{
			this = another;
		}

		void MAParameters
		(
			const int period, 
			const int shift, 
			const ENUM_MA_METHOD method, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			m_period = period;
			m_shift = shift;
			m_method = method;
			m_appliedPrice = appliedPrice;
		}

		int Period() const { return m_period; }
		int Shift() const { return m_shift; }
		ENUM_MA_METHOD Method() const { return  m_method; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const MAParameters &another)
		{
			m_period = another.Period();
			m_shift = another.Shift();
			m_method = another.Method();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const MAParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_shift != another.Shift()){ return false; }
			if(m_method != another.Method()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const MAParameters &another) const
		{
			return !(another == this);
		}
};