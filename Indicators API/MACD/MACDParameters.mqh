#property strict

enum ENUM_MACD_LINE
{
   MACD_LINE_MAIN = 0,
   MACD_LINE_SIGNAL = 1
};

class MACDParameters
{
	private:
		int m_fastEMAPeriod;
		int m_slowEMAPeriod;
		int m_signalPeriod;
		ENUM_APPLIED_PRICE m_appliedPrice;
		ENUM_MACD_LINE m_line;
		
	public:
		MACDParameters()
		{
			m_fastEMAPeriod = 12;
			m_slowEMAPeriod = 26;
			m_signalPeriod = 9;
			m_appliedPrice = PRICE_CLOSE;
			m_line = MACD_LINE_MAIN;
		}

		MACDParameters(const MACDParameters &another)
		{
			this = another;
		}

		void MACDParameters
		(
			const int fastEMAPeriod, 
			const int flowEMAPeriod, 
			const int signalPeriod, 
			const ENUM_APPLIED_PRICE appliedPrice, 
			const ENUM_MACD_LINE line
		)
		{
			m_fastEMAPeriod = fastEMAPeriod;
			m_slowEMAPeriod = flowEMAPeriod;
			m_signalPeriod = signalPeriod;
			m_appliedPrice = appliedPrice;
			m_line = line;
		}

		int FastEMAPeriod() const { return m_fastEMAPeriod; }
		int SlowEMAPeriod() const { return m_slowEMAPeriod; }
		int SignalPeriod() const { return m_signalPeriod; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }
		ENUM_MACD_LINE Line() const { return m_line; }

		void operator=(const MACDParameters &another)
		{
			m_fastEMAPeriod = another.FastEMAPeriod();
			m_slowEMAPeriod = another.SlowEMAPeriod();
			m_signalPeriod = another.SignalPeriod();
			m_appliedPrice = another.AppliedPrice();
			m_line = another.Line();
		}

		bool operator==(const MACDParameters &another) const
		{
			if(m_fastEMAPeriod != another.FastEMAPeriod()){ return false; }
			if(m_slowEMAPeriod != another.SlowEMAPeriod()){ return false; }
			if(m_signalPeriod != another.SignalPeriod()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }
			if(m_line != another.Line()){ return false; }

			return true;
		}

		bool operator!=(const MACDParameters &another) const
		{
			return !(another == this);
		}
};