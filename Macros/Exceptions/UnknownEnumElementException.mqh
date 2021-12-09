#property copyright "Sergei Eremin"
#property link      "sergey@ensed.org"

#define UnknownEnumElementException(element) \
{ \
   Print(__FILE__," ", __FUNCTION__,", line ", __LINE__,": unknown element of ",#element, " (", EnumToString(element), ")"); \
   ExpertRemove(); \
} \
