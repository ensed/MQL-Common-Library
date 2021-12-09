#property strict

class BollingerBandsParameters
{
	private:
		int m_bandsBandsPeriod;
		int m_bandsBandsShift;
		double m_deviation;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		BollingerBandsParameters()
		{
			m_bandsBandsPeriod = 20;
			m_bandsBandsShift = 0;
			m_deviation = 2.0;
			m_appliedPrice = PRICE_CLOSE;
		}

		BollingerBandsParameters(const BollingerBandsParameters &another)
		{
			this = another;
		}

		void BollingerBandsParameters
		(
			const int bandsBandsPeriod, 
			const int shift, 
			const double deviation, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			m_bandsBandsPeriod = bandsBandsPeriod;
			m_bandsBandsShift = shift;
			m_deviation = deviation;
			m_appliedPrice = appliedPrice;
		}

		int BandsPeriod() const { return m_bandsBandsPeriod; }
		int BandsShift() const { return m_bandsBandsShift; }
		double Deviation() const { return  m_deviation; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const BollingerBandsParameters &another)
		{
			m_bandsBandsPeriod = another.BandsPeriod();
			m_bandsBandsShift = another.BandsShift();
			m_deviation = another.Deviation();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const BollingerBandsParameters &another) const
		{
			if(m_bandsBandsPeriod != another.BandsPeriod()){ return false; }
			if(m_bandsBandsShift != another.BandsShift()){ return false; }
			if(m_deviation != another.Deviation()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const BollingerBandsParameters &another) const
		{
			return !(another == this);
		}
};