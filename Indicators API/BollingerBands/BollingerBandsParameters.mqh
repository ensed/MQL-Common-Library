#property strict

/*
Example:

input int InpBollingerBandsPeriod = 20; // Bollinger bands period
input int InpBollingerBandsShift = 0;// Bollinger bands shift
input double InpBollingerBandsDeviation = 2.0; // Bollinger bands deviation
input ENUM_APPLIED_PRICE InpBollingerBandsAppliedPrice = PRICE_CLOSE; // Bollinger bands applied price

...

   BollingerBandsParameters bollingerBandsParameters
   (
      InpBollingerBandsPeriod, InpBollingerBandsShift, InpBollingerBandsDeviation, InpBollingerBandsAppliedPrice
   );
*/

class BollingerBandsParameters
{
	private:
		int m_bandsPeriod;
		int m_bandsShift;
		double m_deviation;
		ENUM_APPLIED_PRICE m_appliedPrice;
		
	public:
		BollingerBandsParameters()
		{
			m_bandsPeriod = 20;
			m_bandsShift = 0;
			m_deviation = 2.0;
			m_appliedPrice = PRICE_CLOSE;
		}

		BollingerBandsParameters(const BollingerBandsParameters &another)
		{
			this = another;
		}

		void BollingerBandsParameters
		(
			const int bandsPeriod, 
			const int bandsShift, 
			const double deviation, 
			const ENUM_APPLIED_PRICE appliedPrice
		)
		{
			m_bandsPeriod = bandsPeriod;
			m_bandsShift = bandsShift;
			m_deviation = deviation;
			m_appliedPrice = appliedPrice;
		}

		int BandsPeriod() const { return m_bandsPeriod; }
		int BandsShift() const { return m_bandsShift; }
		double Deviation() const { return  m_deviation; }
		ENUM_APPLIED_PRICE AppliedPrice() const { return m_appliedPrice; }

		void operator=(const BollingerBandsParameters &another)
		{
			m_bandsPeriod = another.BandsPeriod();
			m_bandsShift = another.BandsShift();
			m_deviation = another.Deviation();
			m_appliedPrice = another.AppliedPrice();
		}

		bool operator==(const BollingerBandsParameters &another) const
		{
			if(m_bandsPeriod != another.BandsPeriod()){ return false; }
			if(m_bandsShift != another.BandsShift()){ return false; }
			if(m_deviation != another.Deviation()){ return false; }
			if(m_appliedPrice != another.AppliedPrice()){ return false; }

			return true;
		}

		bool operator!=(const BollingerBandsParameters &another) const
		{
			return !(another == this);
		}
};