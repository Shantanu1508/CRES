using System;
using System.Collections.Generic;
using System.Text;

namespace CRES.Utilities
{
    public static class Financial
    {
        public static double cXNPV(double Rate, List<decimal> Values, List<DateTime> Dates)
        {
            double Value = 0, Sum = 0;
            int i = 0;
            foreach (var val in Values)
            {
                Value = NumericExtension.SafeDivision(Convert.ToDouble(Values[i]), NumericExtension.CalcPowAndCheckNaNDouble((1 + Convert.ToDouble(Rate)), ((Dates[i] - Dates[0]).TotalDays) / 365));
                Sum = Sum + Value;
                i = i + 1;
            }
            return Sum;
        }

        public static double cXIRR(List<Decimal> values, List<DateTime> dates, double guess = 0)
        {
            double sumpv = 0, rate = 0, raten1 = 0, raten2 = 0, raten1cxnpv = 0, raten2cxnpv = 0;
            try
            {

                rate = guess;
                raten1 = guess - 0.001;
                sumpv = cXNPV(rate, values, dates);
                int i = 0;
                raten1cxnpv = cXNPV(raten1, values, dates);
                if (Math.Abs(sumpv) != 0)
                {
                    while (Math.Abs(sumpv - 0) > 0.00005)
                    {
                        raten2 = raten1;
                        raten1 = rate;
                        raten2cxnpv = raten1cxnpv;
                        raten1cxnpv = sumpv;
                        rate = raten1 - raten1cxnpv * (raten1 - raten2) / (raten1cxnpv - raten2cxnpv);
                        if (Double.IsNaN(rate) || Double.IsInfinity(rate))
                        {
                            rate = 9999;
                            break;
                        }

                        sumpv = cXNPV(rate, values, dates);
                        i++;
                    };
                }
            }
            catch (Exception ex)
            {
                rate = 9999;

                //throw ex;
            }
            return rate;
        }
    }
}
