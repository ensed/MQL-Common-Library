#property strict

class CCIParameters
{
	private:
		int m_period;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		CCIParameters()
		{
			m_period = 13;
			m_appliedPrice = PRICE_CLOSE;
		}

		CCIParameters(const CCIParameters &another)
		{
			this = another;
		}

		void CCIParameters(const int period, const ENUM_APPLIED_PRICE appliedPrice)
		{
			m_period = period;
			m_appliedPrice = appliedPrice;
		}

		int Period() const { return m_period; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const CCIParameters &another)
		{
			m_period = another.Period();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const CCIParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const CCIParameters &another) const
		{
			return !(another == this);
		}
};