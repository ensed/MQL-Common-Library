#property strict

class WPRParameters
{
	private:
		int m_period;
		
	public:
		WPRParameters()
		{
			m_period = 14;
		}

		WPRParameters(const WPRParameters &another)
		{
			this = another;
		}

		void WPRParameters(const int period)
		{
			m_period = period;
		}

		int Period() const { return m_period; }		
		void Period(const int value) { m_period = value; }	

		void operator=(const WPRParameters &another)
		{
			m_period = another.Period();
		}

		bool operator==(const WPRParameters &another) const
		{
			if(m_period != another.Period()){ return false; }

			return true;
		}

		bool operator!=(const WPRParameters &another) const
		{
			return !(another == this);
		}
};