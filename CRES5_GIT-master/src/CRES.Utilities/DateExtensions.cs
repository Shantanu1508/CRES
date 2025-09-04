using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.Utilities
{
    public static class DateExtensions
    {
        private static string msg = "";

        public static string ValidateCalculatorDates(DateTime? date, string name, DateTime? closingdate)
        {
            msg = "";

            if (date == DateTime.MinValue || date == null)
            {
                msg = "Closing date cannot be null.";
            }
            else
            {
                if (name != "Closing Date" && closingdate != null && closingdate != DateTime.MinValue)
                {
                    if (date.Value.Date < closingdate.Value.Date)
                    {
                        msg = msg + "Should be greater than Closing date";
                    }
                }
            }

            return msg;
        }

        public static int YearMonthDiff(DateTime startDate, DateTime endDate)
        {
            int monthDiff = ((endDate.Year * 12) + endDate.Month) - ((startDate.Year * 12) + startDate.Month);
            return monthDiff;
        }

        public static bool CheckForBusinessDay(this DateTime dateTime)
        {
            // return true when date in valid
            DateTime resultDate = dateTime;
            if (resultDate.DayOfWeek != DayOfWeek.Saturday && resultDate.DayOfWeek != DayOfWeek.Sunday)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static DateTime LastDateOfMonth(DateTime anyDt)
        {
            return new DateTime(anyDt.Year, anyDt.Month, DateTime.DaysInMonth(anyDt.Year, anyDt.Month));
        }

        public static DateTime FirstDateOfMonth(DateTime anyDt)
        {
            return new DateTime(anyDt.Year, anyDt.Month, 1);
        }

        public static DateTime CreateNewDate(int year, int months, int days)
        {
            DateTime date = new DateTime(0001, 1, 1).AddYears(year - 1).AddMonths(months - 1).AddDays(days - 1);
            return date;
        }

        public static DateTime GetnextWorkingDays(DateTime date, int days, string datetype = null, List<HolidayListDataContract> ListHoliday = null)
        {
            if (date == DateTime.MinValue || date == null) return date;
            if (days == 0) return date;
            if (days > 0)
            {
                if (date.DayOfWeek == DayOfWeek.Saturday)
                    date = date.AddDays(1);
                int i = 1;
                while (i <= days)
                {
                    date = date.AddDays(1);
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(2);
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(1);

                    if (datetype != null)
                    {
                        if (CheckForHoliday(date, datetype, ListHoliday))
                        {
                            date = date.AddDays(1);
                            i = i - 1;
                        }
                    }
                    i = i + 1;
                }

                return date;
            }
            else
            {
                if (date.DayOfWeek == DayOfWeek.Sunday)
                    date = date.AddDays(-1);
                int i = 1;
                while (i <= -days)
                {
                    date = date.AddDays(-1);
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(-2);
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(-1);
                    if (datetype != null)
                    {
                        if (ListHoliday != null)
                        {
                            if (CheckForHoliday(date, datetype, ListHoliday))
                            {
                                date = date.AddDays(-1);
                                i = i - 1;
                            }
                        }
                    }
                    i = i + 1;
                }
                return date;
            }
        }

        public static bool CheckForHoliday(DateTime refDate, string DateType, List<HolidayListDataContract> ListHoliday = null)
        {
            bool holidayCheck = false;

            foreach (var holiday in ListHoliday)
            {
                if (holiday.HolidayType == DateType && holiday.HolidayDate == refDate)
                {
                    holidayCheck = true;
                    break;
                }
            }
            return holidayCheck;
        }

        public static int GetMonthsDiffIgnoringDays(DateTime from, DateTime to)
        {
            if (from > to) return GetMonthsDiffIgnoringDays(to, from);
            var monthDiff = Math.Abs((to.Year * 12 + (to.Month)) - (from.Year * 12 + (from.Month - 1)));
            return monthDiff;
        }
        public static DateTime GetMinDate(DateTime t1, DateTime t2)
        {
            if (t1 == null && t2 == null) return DateTime.MinValue;
            if (t1 == null || t1 == DateTime.MinValue) return t2;
            if (t2 == null || t2 == DateTime.MinValue) return t1;

            if (DateTime.Compare(t1, t2) > 0)

            {
                return t2;
            }

            return t1;
        }
        public static DateTime GetMaxDate(DateTime t1, DateTime t2)
        {
            if (t1 == null && t2 == null) return DateTime.MinValue;
            if (t1 == null) return t2;
            if (t2 == null) return t1;

            if (DateTime.Compare(t1, t2) > 0)
            {
                return t1;
            }

            return t2;
        }

        public static DateTime GetDealFundingCurrentMaturity(DateTime ActualPayoffDate, DateTime SelectedMaturityDate, DateTime extensiondate, DateTime FullyExtended, List<HolidayListDataContract> ListHoliday)
        {
            DateTime todaydate = DateTime.Now.Date;
            DateTime currentmatdate = DateTime.MinValue;
            DateTime nextMaturityDate = DateTime.MinValue;
            if (ActualPayoffDate != DateTime.MinValue)
            {
                currentmatdate = ActualPayoffDate;
            }
            else if (extensiondate != DateTime.MinValue)
            {
                currentmatdate = extensiondate;
            }
            else
            {
                nextMaturityDate = GetWorkingDayUsingOffset(SelectedMaturityDate, -20, "US", ListHoliday, true);
                if (nextMaturityDate <= todaydate)
                {
                    nextMaturityDate = GetWorkingDayUsingOffset(extensiondate, -20, "US", ListHoliday, true);
                    if (nextMaturityDate < todaydate)
                    {
                        currentmatdate = FullyExtended;
                    }
                    else
                    {
                        currentmatdate = extensiondate;
                    }
                }
                else
                {
                    currentmatdate = SelectedMaturityDate;
                }
            }

            return currentmatdate;
        }
        public static DateTime GetWorkingDayUsingOffset(DateTime date, int offset, string HolidayCalendarType, List<HolidayListDataContract> ListHoliday = null)
        {
            int loopLimitVariable = 0;
            int adjustmentday = 0;
            DateTime nextWorkingDay = date;
            if (date == DateTime.MinValue || date == null) return date;
            if (offset > 0)
            {
                loopLimitVariable = offset * -1;
                adjustmentday = 1;
            }
            else if (offset == 0)
            {
                adjustmentday = 0;
                loopLimitVariable = 0;
            }
            else
            {
                loopLimitVariable = offset;
                adjustmentday = -1;
            }

            nextWorkingDay = GetnextWorkingDays_updated(date, adjustmentday, HolidayCalendarType, ListHoliday);
            if (nextWorkingDay.Date != date.Date)
            {
                for (int i = 0; i < (-loopLimitVariable - 1); i++)
                {
                    nextWorkingDay = nextWorkingDay.AddDays(adjustmentday);
                    nextWorkingDay = GetnextWorkingDays_updated(nextWorkingDay, adjustmentday, HolidayCalendarType, ListHoliday);
                }
            }
            return nextWorkingDay;
        }

        public static DateTime GetnextWorkingDays_updated(DateTime date, int days, string HolidayCalendarType = null, List<HolidayListDataContract> ListHoliday = null)
        {
            if (days == 0) return date;
            if (date == DateTime.MinValue || date == null) return date;
            if (days > 0)
            {
                if (date.DayOfWeek == DayOfWeek.Saturday)
                    date = date.AddDays(2);
                if (date.DayOfWeek == DayOfWeek.Sunday)
                    date = date.AddDays(1);
                int i = 1;
                while (i <= days)
                {
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(2);
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(1);

                    if (HolidayCalendarType != null)
                    {
                        if (CheckForHoliday_updated(date, HolidayCalendarType, ListHoliday))
                        {
                            date = date.AddDays(1);
                            i = i - 1;
                        }
                    }
                    i = i + 1;
                }

                return date;
            }
            else
            {
                if (date.DayOfWeek == DayOfWeek.Sunday)
                    date = date.AddDays(-2);
                if (date.DayOfWeek == DayOfWeek.Saturday)
                    date = date.AddDays(-1);
                int i = 1;
                while (i <= -days)
                {
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(-2);
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(-1);

                    if (HolidayCalendarType != null)
                    {
                        if (CheckForHoliday_updated(date, HolidayCalendarType, ListHoliday))
                        {
                            date = date.AddDays(-1);
                            i = i - 1;
                        }
                    }

                    i = i + 1;
                }
                return date;
            }
        }

        public static bool CheckForHoliday_updated(DateTime refDate, string DateType, List<HolidayListDataContract> ListHoliday = null)
        {
            bool holidayCheck = false;

            foreach (var holiday in ListHoliday)
            {
                if (holiday.HolidayTypeText == DateType && holiday.HolidayDate == refDate)
                {
                    holidayCheck = true;
                    break;
                }
            }
            return holidayCheck;
        }

        public static DateTime GetWorkingDayUsingOffset(DateTime date, int offset, string HolidayCalendarType, List<HolidayListDataContract> ListHoliday = null, bool alwaysadjust = false)
        {
            int loopLimitVariable = 0;
            int adjustmentday = 0;
            DateTime nextWorkingDay = date;
            if (date == DateTime.MinValue || date == null) return date;
            if (offset > 0)
            {
                loopLimitVariable = offset * -1;
                adjustmentday = 1;
            }
            else if (offset == 0)
            {
                adjustmentday = 0;
                loopLimitVariable = 0;
            }
            else
            {
                loopLimitVariable = offset;
                adjustmentday = -1;
            }

            nextWorkingDay = GetnextWorkingDays_updated(date, adjustmentday, HolidayCalendarType, ListHoliday);
            if (nextWorkingDay.Date != date.Date)
            {
                alwaysadjust = true;
            }
            else
            {
                if (alwaysadjust == true)
                {
                    if (nextWorkingDay.Date == date.Date)
                    {
                        if (offset > 0)
                        {
                            loopLimitVariable = loopLimitVariable - 1;
                            //loopLimitVariable = offset * -1;
                            //adjustmentday = 1;

                        }
                        else
                        {
                            loopLimitVariable = loopLimitVariable + 1;

                        }

                    }
                }
            }
            if (alwaysadjust == true)
            {
                for (int i = 0; i < (-loopLimitVariable - 1); i++)
                {
                    nextWorkingDay = nextWorkingDay.AddDays(adjustmentday);
                    nextWorkingDay = GetnextWorkingDays_updated(nextWorkingDay, adjustmentday, HolidayCalendarType, ListHoliday);
                }
            }


            return nextWorkingDay;
        }

        public static DateTime GetNextQuarterEndDate(DateTime dt)
        {
            // DateTime today = DateTime.Today;
            int quatermonth = 0;
            int month = dt.Month;
            if (month > 3 && month <= 6)
            {
                quatermonth = 6;
            }
            else if (month > 6 && month <= 9)
            {
                quatermonth = 9;
            }
            else if (month > 9 && month <= 12)
            {
                quatermonth = 12;
            }
            else if (month >= 1 && month <= 3)
            {
                quatermonth = 3;
            }            
            DateTime LastDateofquater = LastDateOfMonth(CreateNewDate(dt.Year, quatermonth, 1));

            return LastDateofquater;
        }

    }
}