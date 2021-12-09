#property strict

class ParabolicSARParameters
{
	private:
		double m_step;
		double m_maximum;
		
	public:
		ParabolicSARParameters()
		{
			m_step = 0.02;
			m_maximum = 0.2;
		}

		ParabolicSARParameters(const ParabolicSARParameters &another)
		{
			this = another;
		}

		void ParabolicSARParameters
		(
			const double step, 
			const double maximum
		)
		{
			m_step = step;
			m_maximum = maximum;
		}

		double Step() const { return m_step; }
		double Maximum() const { return m_maximum; }

		void operator=(const ParabolicSARParameters &another)
		{
			m_step = another.Step();
			m_maximum = another.Maximum();
		}

		bool operator==(const ParabolicSARParameters &another) const
		{
			if(m_step != another.Step()){ return false; }
			if(m_maximum != another.Maximum()){ return false; }

			return true;
		}

		bool operator!=(const ParabolicSARParameters &another) const
		{
			return !(another == this);
		}
};