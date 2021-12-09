#property strict

#include "..\..\Filter\FilterByDaysAndTimeRange.mqh"
#include "..\..\UnitTests\AllUnitTests.mqh"


UnitTestStart(DayAndTimeIsInRange_ResultShouldBeInvalid_1)
   FilterByDaysAndTimeRange filter(MONDAY, "03:00", FRIDAY, "23:00", TUESDAY, "02:00");
   CheckForFalse(filter.IsValid());
UnitTestEnd(DayAndTimeIsInRange_ResultShouldBeInvalid_1)

UnitTestStart(DayAndTimeIsInRange_ResultShouldBeInvalid_2)
   FilterByDaysAndTimeRange filter(FRIDAY, "20:00", TUESDAY, "01:00", MONDAY, "02:00");
   CheckForFalse(filter.IsValid());
UnitTestEnd(DayAndTimeIsInRange_ResultShouldBeInvalid_2)

UnitTestStart(DayAndTimeIsInRange_ResultShouldBeInvalid_3)
   FilterByDaysAndTimeRange filter(MONDAY, "03:00", FRIDAY, "23:00", MONDAY, "03:00");
   CheckForFalse(filter.IsValid());
UnitTestEnd(DayAndTimeIsInRange_ResultShouldBeInvalid_3)

UnitTestStart(DayAndTimeIsInRange_ResultShouldBeInvalid_4)
   FilterByDaysAndTimeRange filter(FRIDAY, "20:00", TUESDAY, "01:00", FRIDAY, "20:00");
   CheckForFalse(filter.IsValid());
UnitTestEnd(DayAndTimeIsInRange_ResultShouldBeInvalid_4)

UnitTestStart(DayAndTimeIsNotInRange_ResultShouldBeValid_1)
   FilterByDaysAndTimeRange filter(MONDAY, "03:00", FRIDAY, "23:00", MONDAY, "02:00");
   CheckForTrue(filter.IsValid());
UnitTestEnd(DayAndTimeIsNotInRange_ResultShouldBeValid_1)

UnitTestStart(DayAndTimeIsNotInRange_ResultShouldBeValid_2)
   FilterByDaysAndTimeRange filter(FRIDAY, "03:00", MONDAY, "12:00", MONDAY, "15:00");
   CheckForTrue(filter.IsValid());
UnitTestEnd(DayAndTimeIsNotInRange_ResultShouldBeValid_2)

UnitTestStart(DayAndTimeIsNotInRange_ResultShouldBeValid_3)
   FilterByDaysAndTimeRange filter(MONDAY, "03:00", FRIDAY, "20:00", FRIDAY, "20:00");
   CheckForTrue(filter.IsValid());
UnitTestEnd(DayAndTimeIsNotInRange_ResultShouldBeValid_3)

UnitTestStart(DayAndTimeIsNotInRange_ResultShouldBeValid_4)
   FilterByDaysAndTimeRange filter(FRIDAY, "03:00", MONDAY, "12:00", MONDAY, "12:00");
   CheckForTrue(filter.IsValid());
UnitTestEnd(DayAndTimeIsNotInRange_ResultShouldBeValid_4)