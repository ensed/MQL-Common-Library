#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#define UnexpectedEnumItemException(value) \
{ \
   Print(__FILE__," ", __FUNCTION__,", line ", __LINE__,": unexpected value of ",#value, " (", EnumToString(value), ")"); \
   ExpertRemove(); \
} \