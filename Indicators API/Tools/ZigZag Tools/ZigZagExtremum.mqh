#ifdef __MQL4__
#property strict
#endif

#include "EnumZigZagExtremumType.mqh"

class ZigZagExtremum
{
	private:
		int m_shift;
		double m_price;
		EnumZigZagExtremumType m_type;

	public:
		ZigZagExtremum()
		{
			m_shift = -1;
			m_price = 0.0;
			m_type = ZigZagExtremumType_None;
		}

		ZigZagExtremum(const ZigZagExtremum &another)
		{
			this = another;
		}

		ZigZagExtremum
		(
			const int shift, 
			const double price, 
			const EnumZigZagExtremumType type
		)
		{
			Init(shift, price, type);
		}

		void Init
		(
			const int shift, 
			const double price, 
			const EnumZigZagExtremumType type
		)
		{
			m_shift = shift;
			m_price = price;
			m_type = type;
		}

		void Shift(const int value) { m_shift = value; }
		int Shift() const { return m_shift; }

		void Price(const double value) { m_price = value; }
		double Price() const { return m_price; }

		void Type(const EnumZigZagExtremumType value) { m_type = value; }
		EnumZigZagExtremumType Type() const { return m_type; }

		void operator=(const ZigZagExtremum &another)
		{
			m_shift = another.Shift();
			m_price = another.Price();
			m_type = another.Type();
		}

		bool operator==(const ZigZagExtremum &another) const
		{
			if(m_shift != another.Shift()){ return false; }
			if(m_price != another.Price()){ return false; }
			if(m_type != another.Type()){ return false; }

			return true;
		}

		bool operator!=(const ZigZagExtremum &another) const
		{
			return !(another == this);
		}

};