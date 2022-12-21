using System;
using System.Collections.Generic;
using System.Linq;

namespace CRES.Utilities
{
    public static class NumericExtension
    {
        public static bool CheckNullOrEmpty<T>(T value)
        {
            if (typeof(T) == typeof(string))
                return string.IsNullOrEmpty(value as string);

            return value == null || value.Equals(default(T));
        }

        public static bool ValidateNullList<T>(this IEnumerable<T> source)
        {
            if (source != null && source.Any())
                return true;
            else
                return false;
        }

        public static decimal? CalculatePercentageOf(decimal? value, decimal? percentage)
        {
            if (percentage > 1)
            {
                return (percentage / 100) * value;

            }
            else
            {
                return percentage * value;
            }
        }

        public static Guid ToGuid(this Guid? source)
        {
            return source ?? Guid.Empty;
        }

        static public decimal SafeDivision(this decimal Numerator, decimal Denominator)
        {
            return (Denominator == 0) ? 0 : Numerator / Denominator;
        }

        static public double SafeDivision(this double Numerator, double Denominator)
        {
            return (Denominator == 0 || Double.IsNaN(Denominator)) ? 0 : Numerator / Denominator;
        }

        static public decimal SafeDivision(this int Numerator, int Denominator)
        {
            return (Denominator == 0) ? 0 : Numerator / Denominator;
        }

        static public decimal CalcPowAndCheckNaN(double x, double y)
        {
            if (double.IsNaN(Math.Pow(x, y)))
                return 0;
            else
                return Convert.ToDecimal(Math.Pow(x, y));
        }

        static public double CalcPowAndCheckNaNDouble(double x, double y)
        {
            if (double.IsNaN(Math.Pow(x, y)))
                return 0;
            else
                return Convert.ToDouble(Math.Pow(x, y));
        }
    }
}