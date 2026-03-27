using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;

namespace CRES.NoteCalculator
{
    public class CalculationHelper
    {
        #region Static Variables
        
        public static string DisableBusinessDayAdjustmentText = "N";

        #endregion
        #region Date & Time Helpers

        public static DateTime GetWorkingDayUsingOffset(DateTime date, int offset, string HolidayCalendarType, bool alwaysadjust = false)
        {
            DateTime nextWorkingDay = date;
            if (DisableBusinessDayAdjustmentText != "Y")
            {
                int loopLimitVariable = 0;
                int adjustmentday = 0;
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
                nextWorkingDay = GetnextWorkingDays(date, adjustmentday, HolidayCalendarType);
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
                                loopLimitVariable = loopLimitVariable + 1;

                            }
                            else
                            {
                                loopLimitVariable = loopLimitVariable - 1;
                            }

                        }
                    }
                }
                if (alwaysadjust == true)
                {
                    for (int i = 0; i < (-loopLimitVariable - 1); i++)
                    {
                        nextWorkingDay = nextWorkingDay.AddDays(adjustmentday);
                        nextWorkingDay = GetnextWorkingDays(nextWorkingDay, adjustmentday, HolidayCalendarType);
                    }
                }
            }
            return nextWorkingDay;
        }

        public static DateTime GetWorkingDayUsingOffset(DateTime date, int offset, string HolidayCalendarType)
        {
            DateTime nextWorkingDay = date;

            if (DisableBusinessDayAdjustmentText != "Y")
            {
                int loopLimitVariable = 0;
                int adjustmentday = 0;

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

                nextWorkingDay = GetnextWorkingDays(date, adjustmentday, HolidayCalendarType);
                if (nextWorkingDay.Date != date.Date)
                {
                    for (int i = 0; i < (-loopLimitVariable - 1); i++)
                    {
                        nextWorkingDay = nextWorkingDay.AddDays(adjustmentday);
                        nextWorkingDay = GetnextWorkingDays(nextWorkingDay, adjustmentday, HolidayCalendarType);
                    }
                }
            }
            return nextWorkingDay;
        }

        public static DateTime GetnextWorkingDays(DateTime date, int days, string HolidayCalendarType)
        {
            if (days == 0) return date;
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
                        if (CheckForHoliday(date, HolidayCalendarType))
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
                        if (CheckForHoliday(date, HolidayCalendarType))
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
        public static bool CheckForHoliday(DateTime refDate, string HolidayCalendarType, List<HolidayListDataContract> ListHoliday = null)
        {
            bool holidayCheck = false;
            if (ListHoliday != null)
            {
                foreach (var holiday in ListHoliday)
                {
                    if (holiday.HolidayType == HolidayCalendarType && holiday.HolidayDate == refDate)
                    {
                        holidayCheck = true;
                        break;
                    }
                }
            }
            return holidayCheck;
        }

        #endregion
        public static DataTable ToDataSet<T>(IEnumerable<T> list)
        {
            Type elementType = typeof(T);
            System.Data.DataTable dt = new System.Data.DataTable();

            //add a column to table for each public property on T
            foreach (var propInfo in elementType.GetProperties())
            {
                dt.Columns.Add(propInfo.Name);
            }

            //go through each property on T and add each value to the table
            foreach (T item in list)
            {
                DataRow row = dt.NewRow();
                foreach (var propInfo in elementType.GetProperties())
                {
                    row[propInfo.Name] = propInfo.GetValue(item, null);
                }

                //This line was missing:
                dt.Rows.Add(row);
            }

            return dt;
        }

        public static void CreateCSVFile(System.Data.DataTable dt, string csvname)
        {
            try
            {
                string path = @"C:\temp";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string strFilePath = "C:\\temp\\" + csvname + ".csv";

                StreamWriter sw = new StreamWriter(strFilePath, false);
                int columnCount = dt.Columns.Count;

                for (int i = 0; i < columnCount; i++)
                {
                    sw.Write(dt.Columns[i]);

                    if (i < columnCount - 1)
                    {
                        sw.Write(",");
                    }
                }

                sw.Write(sw.NewLine);

                foreach (DataRow dr in dt.Rows)
                {
                    for (int i = 0; i < columnCount; i++)
                    {
                        if (!Convert.IsDBNull(dr[i]))
                        {
                            sw.Write(dr[i].ToString());
                        }

                        if (i < columnCount - 1)
                        {
                            sw.Write(",");
                        }
                    }

                    sw.Write(sw.NewLine);
                }

                sw.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
