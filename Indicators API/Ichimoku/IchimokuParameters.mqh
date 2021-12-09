#property strict

#ifdef __MQL4__
#property strict
#endif

class IchimokuParameters
{
	private:
		int m_tenkanSen;
		int m_kijunSen;
		int m_senkouSpanB;

	public:
		IchimokuParameters()
		{
			m_tenkanSen = 9;
			m_kijunSen = 26;
			m_senkouSpanB = 52;
		}

		IchimokuParameters(const IchimokuParameters &another)
		{
			this = another;
		}

		IchimokuParameters
		(
			const int tenkanSen, 
			const int kijunSen, 
			const int senkouSpanB
		)
		{
			Init(tenkanSen, kijunSen, senkouSpanB);
		}

		void Init
		(
			const int tenkanSen, 
			const int kijunSen, 
			const int senkouSpanB
		)
		{
			m_tenkanSen = tenkanSen;
			m_kijunSen = kijunSen;
			m_senkouSpanB = senkouSpanB;
		}

		void TenkanSen(const int value) { m_tenkanSen = value; }
		int TenkanSen() const { return m_tenkanSen; }

		void KijunSen(const int value) { m_kijunSen = value; }
		int KijunSen() const { return m_kijunSen; }

		void SenkouSpanB(const int value) { m_senkouSpanB = value; }
		int SenkouSpanB() const { return m_senkouSpanB; }

		void operator=(const IchimokuParameters &another)
		{
			m_tenkanSen = another.TenkanSen();
			m_kijunSen = another.KijunSen();
			m_senkouSpanB = another.SenkouSpanB();
		}

		bool operator==(const IchimokuParameters &another) const
		{
			if(m_tenkanSen != another.TenkanSen()){ return false; }
			if(m_kijunSen != another.KijunSen()){ return false; }
			if(m_senkouSpanB != another.SenkouSpanB()){ return false; }

			return true;
		}

		bool operator!=(const IchimokuParameters &another) const
		{
			return !(another == this);
		}
};