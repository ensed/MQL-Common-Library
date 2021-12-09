#property strict

class ZigZagParameters
{
	private:
		int m_inpDepth;
		int m_inpDeviation;
		int m_inpBackstep;
		
	public:
		ZigZagParameters()
		{
			m_inpDepth = 12;
			m_inpDeviation = 5;
			m_inpBackstep = 3;
		}

		ZigZagParameters(const ZigZagParameters &another)
		{
			this = another;
		}

		void ZigZagParameters(const int inpDepth, const int inpDeviation, const int inpBackstep)
		{
			m_inpDepth = inpDepth;
			m_inpDeviation = inpDeviation;
			m_inpBackstep = inpBackstep;
		}

		int InpDepth() const { return m_inpDepth; }
		int InpDeviation() const { return m_inpDeviation; }
		int InpBackstep() const { return m_inpBackstep; }

		void operator=(const ZigZagParameters &another)
		{
			m_inpDepth = another.InpDepth();
			m_inpDeviation = another.InpDeviation();
			m_inpBackstep = another.InpBackstep();
		}

		bool operator==(const ZigZagParameters &another) const
		{
			if(m_inpDepth != another.InpDepth()){ return false; }
			if(m_inpDeviation != another.InpDeviation()){ return false; }
			if(m_inpBackstep != another.InpBackstep()){ return false; }

			return true;
		}

		bool operator!=(const ZigZagParameters &another) const
		{
			return !(another == this);
		}
};