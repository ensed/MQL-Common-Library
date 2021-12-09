#property strict

class DoubleValueValidator
{
   protected:
      double m_value;      
      bool m_result;
      
   public:
      DoubleValueValidator(const double value)
      {
         m_value = value;
      }
      
      bool IsValueValid() const
      {
         return m_result;
      }
      
      virtual void Update() = 0;
};