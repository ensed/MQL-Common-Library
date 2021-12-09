#property strict

class EnvelopesParameters
{
	private:
		int m_period;
		int m_shift;
		ENUM_MA_METHOD m_method;
		ENUM_APPLIED_PRICE m_appliedPrice;
		double m_deviation;		
		
	public:
		EnvelopesParameters()
		{
			m_period = 20;
			m_shift = 0;
			m_deviation = 2.0;
			m_appliedPrice = PRICE_CLOSE;
		}

		EnvelopesParameters(const EnvelopesParameters &another)
		{
			this = another;
		}

		void EnvelopesParameters
		(
			const int period, 
			const int shift, 			
			const ENUM_MA_METHOD method,
			const ENUM_APPLIED_PRICE appliedPrice,
			const double deviation
		)
		{
			m_period = period;
			m_shift = shift;
			m_method = method;			
			m_appliedPrice = appliedPrice;
			m_deviation = deviation;
		}

		int Period() const { return m_period; }
		int Shift() const { return m_shift; }		
		ENUM_MA_METHOD Method() const { return m_method; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }
		double Deviation() const { return  m_deviation; }

		void operator=(const EnvelopesParameters &another)
		{
			m_period = another.Period();
			m_shift = another.Shift();			
			m_method = another.Method();
			m_appliedPrice = another.AppliedPrice();
			m_deviation = another.Deviation();
		}

		bool operator==(const EnvelopesParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_shift != another.Shift()){ return false; }			
			if(m_method != another.Method()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }
			if(m_deviation != another.Deviation()){ return false; }

			return true;
		}

		bool operator!=(const EnvelopesParameters &another) const
		{
			return !(another == this);
		}
};