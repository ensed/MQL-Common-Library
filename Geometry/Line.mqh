#property strict

class Line
{
   private:
      double m_startX;
      double m_startY;
      double m_endX;
      double m_endY;      
      
   public:
      Line(const double startX, const double startY, const double endX, const double endY)
      {
         m_startX = startX;
         m_startY = startY;         
         m_endX = endX;
         m_endY = endY;
      }
      
      double GetYValue(const double x)
      {
         if(m_endX-m_startX == 0)
         {
            return EMPTY_VALUE;
         }
         
         double m = (m_endY-m_startY)/(m_endX-m_startX);
         double c = m_startY - m*m_startX;
         
         return m*x + c;
      }
};