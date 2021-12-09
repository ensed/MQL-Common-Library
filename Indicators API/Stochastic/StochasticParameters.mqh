#property strict

enum ENUM_STOCHASTIC_LINE
{
   STOCHASTIC_LINE_MAIN, // Main
   STOCHASTIC_LINE_SIGNAL // Signal
};

class StochasticParameters
{
	private:
		int m_kPeriod;
		int m_dPeriod;
		int m_slowing;
		ENUM_MA_METHOD m_method;
		ENUM_STO_PRICE m_price;
		ENUM_STOCHASTIC_LINE m_mode;
		
	public:
		StochasticParameters()
		{
			m_kPeriod = 5;
			m_dPeriod = 3;
			m_slowing = 3;
			m_method = MODE_SMA;
			m_price = STO_LOWHIGH;
			m_mode = STOCHASTIC_LINE_MAIN;
		}

		StochasticParameters(const StochasticParameters &another)
		{
			this = another;
		}

		void StochasticParameters
		(
			const int kPeriod, 
			const int dPeriod, 
			const int slowing, 
			const ENUM_MA_METHOD method, 
			const ENUM_STO_PRICE price, 
			const ENUM_STOCHASTIC_LINE mode
		)
		{
			m_kPeriod = kPeriod;
			m_dPeriod = dPeriod;
			m_slowing = slowing;
			m_method = method;
			m_price = price;
			m_mode = mode;
		}

		int KPeriod() const { return m_kPeriod; }
		int DPeriod() const { return m_dPeriod; }
		int Slowing() const { return m_slowing; }
		ENUM_MA_METHOD Method() const { return m_method; }
		ENUM_STO_PRICE Price() const { return m_price; }
		ENUM_STOCHASTIC_LINE Mode() const { return m_mode; }

		void operator=(const StochasticParameters &another)
		{
			m_kPeriod = another.KPeriod();
			m_dPeriod = another.DPeriod();
			m_slowing = another.Slowing();
			m_method = another.Method();
			m_price = another.Price();
			m_mode = another.Mode();
		}

		bool operator==(const StochasticParameters &another) const
		{
			if(m_kPeriod != another.KPeriod()){ return false; }
			if(m_dPeriod != another.DPeriod()){ return false; }
			if(m_slowing != another.Slowing()){ return false; }
			if(m_method != another.Method()){ return false; }
			if(m_price != another.Price()){ return false; }
			if(m_mode != another.Mode()){ return false; }

			return true;
		}

		bool operator!=(const StochasticParameters &another) const
		{
			return !(another == this);
		}
};