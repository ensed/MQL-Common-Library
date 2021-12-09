#property strict

class RSIParameters
{
	private:
		int m_period;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		RSIParameters()
		{
			m_period = 14;
			m_appliedPrice = PRICE_CLOSE;
		}

		RSIParameters(const RSIParameters &another)
		{
			this = another;
		}

		void RSIParameters(const int period, const ENUM_APPLIED_PRICE appliedPrice)
		{
			m_period = period;
			m_appliedPrice = appliedPrice;
		}

		int Period() const { return m_period; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const RSIParameters &another)
		{
			m_period = another.Period();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const RSIParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const RSIParameters &another) const
		{
			return !(another == this);
		}
};