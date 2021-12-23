#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#property strict

class SignalChecker
{
   public:
      virtual bool Exists() = 0;

      virtual bool ProhibitsAny()
      {
         return false;
      }

      virtual string TypeName() const
      {
         return typename(this);
      }
      
};