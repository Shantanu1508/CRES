using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using System.Globalization;
using System.Data;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace CRES.Utilities
{
    public static class CommonHelper
    {
        public static string ToXML(this object value)
        {
            var stringwriter = new System.IO.StringWriter();
            var serializer = new XmlSerializer(value.GetType());
            serializer.Serialize(stringwriter, value);
            return stringwriter.ToString();
        }

        public static string ToTitleCase(string value)
        {
            string res = string.Empty;
            if (!String.IsNullOrEmpty(value))
            {
                res = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(value);
            }
            return res;
        }


        public static bool IsEmptyDataset(DataSet dataSet)
        {
            return !dataSet.Tables.Cast<DataTable>().Any(x => x.DefaultView.Count > 0);
        }
        public static string FormatWFStatusName(this object value)
        {
            if (value == null)
            {
                return "";
            }
            var status = value.ToString();
            if (status.Contains("1st"))
            {
                status = "1<sup>st</sup>" + status.Replace("1st", "");
            }
            else if (status.Contains("2nd"))
            {
                status = "2<sup>nd</sup>" + status.Replace("2nd", "");
            }
            else if (status.Contains("3rd"))
            {
                status = "3<sup>rd</sup>" + status.Replace("3rd", "");
            }
            return status;
        }
        public static int? ToInt32(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return Convert.ToInt32(value);
            return null;
        }

        public static DateTime? ToDateTime(this object value)
        {
            try
            {
                if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                    return Convert.ToDateTime(value);
                return null;
            }
            catch (Exception ex)
            {

                return null;
            }
        }
        public static String ToDateTimeStringFormat(this object value)
        {
            try
            {
                if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                {
                    return Convert.ToDateTime(value).ToString("MM/dd/yyyy");
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {

                return null;
            }
        }
        public static decimal? ToDecimalWithRound(this object value, int roundupto)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
            {
                decimal? decimavalue = Convert.ToDecimal(value);
                if (decimavalue != 0)
                {
                    decimavalue = Math.Round(decimavalue.GetValueOrDefault(0), roundupto);
                    if (decimavalue > 9999999999999m)
                    {
                        decimavalue = 9999999999999m;
                    }
                    else if (decimavalue < -9999999999999m)
                    {
                        decimavalue = -9999999999999m;
                    }
                }
                else
                {
                    decimavalue = null;
                }
                return decimavalue;
            }
            else
            {
                return null;
            }


        }
        public static DateTime? ToDateTimeWithMinValue(this object value)
        {
            try
            {
                if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                {
                    return Convert.ToDateTime(value);
                }
                else
                {
                    return DateTime.MinValue.Date;
                }
            }
            catch (Exception ex)
            {

                return DateTime.MinValue.Date;
            }

        }
        //public static decimal? StringToDecimalWithRound(this object value)
        //{
        //    if (value.ToString() != "" && value.ToString() != "NaN" && value.ToString() != null && value.ToString() != "N/A")
        //    {
        //        decimal? retvalue = 0;
        //        retvalue = Math.Round(decimal.Parse(value.ToString(), NumberStyles.Number | NumberStyles.AllowExponent), 8);
        //        if (retvalue > 9999999999999m)
        //        {
        //            retvalue = 9999999999999m;
        //        }

        //        return retvalue;
        //    }
        //    else { return 0; }

        //}
        public static Boolean? ToBoolean(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return Convert.ToBoolean(value);
            return null;
        }
        public static Boolean? ToBooleanNotNullable(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
            {
                return Convert.ToBoolean(value);
            }
            else
            {
                return false;
            }


        }
        public static decimal? ToDecimal(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return Convert.ToDecimal(value);
            return null;
        }
        public static decimal? ValueOrNull(this object value)
        {
            if (value == null || Convert.ToDecimal(value) == 0)
            {
                return null;
            }
            else { return Convert.ToDecimal(value); }


        }

        public static double? ToDouble(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return Convert.ToDouble(value);
            return null;
        }
        public static decimal? StringToDecimal(this object value)
        {
            if (value != null && value.ToString() != "" && value.ToString() != "NaN" && value.ToString() != null && value.ToString() != "N/A")
            {
                return decimal.Parse(value.ToString(), NumberStyles.Number | NumberStyles.AllowExponent);
            }
            else { return 0; }

        }
        public static decimal? StringToDecimalWithNull(this object value)
        {
            if (value != null && value.ToString() != "" && value.ToString() != "NaN" && value.ToString() != null && value.ToString() != "N/A")
            {
                return decimal.Parse(value.ToString(), NumberStyles.Number | NumberStyles.AllowExponent);
            }
            else { return null; }

        }

        public static decimal? StringToDecimalWithRound(this object value)
        {
            if (value.ToString() != "" && value.ToString() != "NaN" && value.ToString() != null && value.ToString() != "N/A")
            {
                decimal? retvalue = 0;
                retvalue = Math.Round(decimal.Parse(value.ToString(), NumberStyles.Number | NumberStyles.AllowExponent), 8);
                if (retvalue > 9999999999999m)
                {
                    retvalue = 9999999999999m;
                }
                else if (retvalue < -9999999999999m)
                {
                    retvalue = -9999999999999m;
                }

                return retvalue;
            }
            else { return 0; }

        }

        public static object CheckDBNull(this object value)
        {
            return (object)value ?? DBNull.Value;
        }

        public static Guid? ToGuid(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return new Guid(value.ToString());
            return null;
        }
        public static int ToInt16_NotNullable(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return Convert.ToInt16(value);
            return 0;
        }

        public static int ToInt32_NotNullable(this object value)
        {
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
                return Convert.ToInt32(value);
            return 0;
        }

        //FormatCustomerForQuickBook
        public static string FormatCustomerForQuickBook(string DealName, string CREDealID)
        {
            // quickbooks only allow 41 character in customer account name so if deal name 
            // is having character length more than 41 than we have to format customer name as
            // CREDealiD-remainign characters from deal deal, complete characters legth should be 41.
            DealName = DealName.Trim();
            string QuickBookCustomerName = DealName;
            int RemainingChar = 0;
            if (DealName.Length > 41)
            {
                RemainingChar = 41 - (CREDealID + "-").Length;
                QuickBookCustomerName = CREDealID + "-" + DealName.Substring(0, RemainingChar);

            }
            return QuickBookCustomerName.Trim();
        }

        public static string AsOrdinal(this int integer)
        {
            switch (integer % 100)
            {
                case 11:
                case 12:
                case 13:
                    return "th";
            }
            switch (integer % 10)
            {
                case 1:
                    return "st";
                case 2:
                    return "nd";
                case 3:
                    return "rd";
                default:
                    return "th";
            }
        }

        public static string ToStringWithOrdinal(this DateTime dateTime, string format)
        {
            return dateTime.ToString(format)
                    .Replace("nn", dateTime.Day.AsOrdinal().ToLower())
                    .Replace("NN", dateTime.Day.AsOrdinal().ToUpper());

        }

        public static dynamic convertValforjson(object obj, string type)
        {
            dynamic result;
            if (type.Contains("nvarchar") || type.Contains("date") || type.Contains("UNIQUEIDENTIFIER"))
            {
                return obj.ToString();
            }
            else if (type.Contains("int") || type.Contains("decimal"))
            {
                return obj;
            }
            else if (type.Contains("bool"))
            {
                return obj.ToBoolean();
            }
            return obj.ToString();
        }

        public static bool ValidateJSON(this string s)
        {
            try
            {
                JsonConvert.DeserializeObject(s);
                //JToken.Parse(s);
                return true;
            }
            catch (JsonReaderException ex)
            {
                //Trace.WriteLine(ex);
                return false;
            }
        }

        public static dynamic convertValToProperFormat(object obj, string type)
        {

            if (obj == DBNull.Value)
            {
                return obj;
            }

            if (!string.IsNullOrEmpty(type))
            {
                type = type.ToLower();
            }
            else
            {
                return obj;
            }

            if (type.Contains("nvarchar") || type.Contains("date") || type.Contains("uniqueidentifier"))
            {
                if (type.Contains("date"))
                {
                    return Convert.ToDateTime(obj).ToString("MM/dd/yyyy");
                }

                return obj.ToString();
            }
            else if (type.Contains("int") || type.Contains("decimal"))
            {
                return obj;
            }
            else if (type.Contains("bool"))
            {
                return obj.ToBoolean();
            }

            return obj.ToString();
        }

    }
}
