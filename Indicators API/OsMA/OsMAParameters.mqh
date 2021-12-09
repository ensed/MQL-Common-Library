#property strict

class OsMAParameters
{
	private:
		int m_fastEMAPeriod;
		int m_slowEMAPeriod;
		int m_signalPeriod;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		OsMAParameters()
		{
			m_fastEMAPeriod = 12;
			m_slowEMAPeriod = 26;
			m_signalPeriod = 9;
			m_appliedPrice = PRICE_CLOSE;
		}

		OsMAParameters(const OsMAParameters &another)
		{
			this = another;
		}

		void OsMAParameters
		(
			const int fastEMAPeriod, 
			const int flowEMAPeriod, 
			const int signalPeriod, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			m_fastEMAPeriod = fastEMAPeriod;
			m_slowEMAPeriod = flowEMAPeriod;
			m_signalPeriod = signalPeriod;
			m_appliedPrice = appliedPrice;
		}

		int FastEMAPeriod() const { return m_fastEMAPeriod; }
		int SlowEMAPeriod() const { return m_slowEMAPeriod; }
		int SignalPeriod() const { return m_signalPeriod; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const OsMAParameters &another)
		{
			m_fastEMAPeriod = another.FastEMAPeriod();
			m_slowEMAPeriod = another.SlowEMAPeriod();
			m_signalPeriod = another.SignalPeriod();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const OsMAParameters &another) const
		{
			if(m_fastEMAPeriod != another.FastEMAPeriod()){ return false; }
			if(m_slowEMAPeriod != another.SlowEMAPeriod()){ return false; }
			if(m_signalPeriod != another.SignalPeriod()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const OsMAParameters &another) const
		{
			return !(another == this);
		}
};