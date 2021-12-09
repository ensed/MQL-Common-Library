#property strict

enum ENUM_RVI_LINE
{
   RVI_LINE_MAIN, // Main
   RVI_LINE_SIGNAL // Signal
};

class RVIParameters
{
	private:
		int m_period;
		ENUM_RVI_LINE m_mode;
		
	public:
		RVIParameters()
		{
			m_period = 10;
			m_mode = RVI_LINE_SIGNAL;
		}

		RVIParameters(const RVIParameters &another)
		{
			this = another;
		}

		void RVIParameters
		(
			const int period, 
			const ENUM_RVI_LINE mode
		)
		{
			m_period = period;
			m_mode = mode;
		}

		int Period() const { return m_period; }
		ENUM_RVI_LINE Mode() const { return m_mode; }

		void operator=(const RVIParameters &another)
		{
			m_period = another.Period();
			m_mode = another.Mode();
		}

		bool operator==(const RVIParameters &another) const
		{
			if(m_period != another.Period()){ return false; }
			if(m_mode != another.Mode()){ return false; }

			return true;
		}

		bool operator!=(const RVIParameters &another) const
		{
			return !(another == this);
		}
};