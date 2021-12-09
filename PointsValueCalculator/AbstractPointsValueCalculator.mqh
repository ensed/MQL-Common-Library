#property strict

class AbstractPointsValueCalculator
{
   protected:
      int m_value;
      
   public:
      AbstractPointsValueCalculator()
      :
         m_value(0)
      {
      }
      
      virtual void Calculate() = 0;
      
      int GetValue()  const
      {
         return m_value;
      }
};