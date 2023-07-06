using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.NoteCalculator
{
    public class CalculationTrace
    {
        #region Properties

        public List<ProspectiveCashflow> BalanceCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> BegBalanceCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> FutureAdvCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> BalloonCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> CurtailmentsCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> FeeCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> IntCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> PIKCF = new List<ProspectiveCashflow>();

        public List<ProspectiveCashflow> FeeYieldCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> DiscYieldCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> CapYieldCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> ParYieldCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> AllInYieldCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> LevelYieldCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> PVAllInCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> SLTotalFeeCF = new List<ProspectiveCashflow>();

        public List<ProspectiveCashflow> FeeBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> DiscBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> CapBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> ParBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> AllInBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> LYBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> PVAllInBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> SLBasisCF = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> BasisCF = new List<ProspectiveCashflow>();

        public List<ProspectiveCashflow> FeeAmort = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> DiscAmort = new List<ProspectiveCashflow>();
        public List<ProspectiveCashflow> CapCostAmort = new List<ProspectiveCashflow>();
        #endregion 

        public static DataSet ToDataSet(List<BalanceTab> ListBalTab, List<ProspectiveCashflow> prosCFs)
        {
            string colName = string.Empty;
            string search = string.Empty;
            int rowindex = 0;
            DataSet ds = new DataSet();
            DataTable t = new System.Data.DataTable();
            ds.Tables.Add(t);

            //Add a column to table for each Effective Date 
            t.Columns.Add("Date", typeof(DateTime));
            foreach (ProspectiveCashflow pcf in prosCFs)
            {
                colName = pcf.EffectiveDate.ToString();
                t.Columns.Add(colName, typeof(Decimal));
            }

            //Add the Yield as the first Row.  Date = Current DateTime
            DataRow row0 = t.NewRow();
            row0["Date"] = DateTime.Now;
            foreach (ProspectiveCashflow pcf in prosCFs)
            {
                colName = pcf.EffectiveDate.ToString();
                if (double.IsNaN(pcf.Yield))
                    row0[colName] = 0.99;
                else
                    row0[colName] = pcf.Yield;
            }
            t.Rows.Add(row0);

            //Add the Closing Date - 1 date as the next row
            DataRow row1 = t.NewRow();
            DateTime? minDate = ListBalTab.Min(bal => bal.Date);
            row1["Date"] = minDate.Value.AddDays(-1);
            t.Rows.Add(row1);
            //Add all the dates from Balance tab 
            foreach (BalanceTab bal in ListBalTab)
            {
                DataRow row = t.NewRow();
                row["Date"] = bal.Date;
                t.Rows.Add(row);
            }

            foreach (ProspectiveCashflow pcf in prosCFs)
            {
                string sEffDate = pcf.EffectiveDate.ToString();
                foreach (Cashflow cf in pcf.Cashflows)
                {
                    search = "Date = #" + cf.CFDate + "#";
                    rowindex = t.Rows.IndexOf(t.Select(search)[0]);
                    t.Rows[rowindex][sEffDate] = cf.CFValue.GetValueOrDefault(0);
                }
            }

            return ds;
        }

    }

    public class ProspectiveCashflow
    {
        public DateTime? EffectiveDate { get; set; }
        public Double Yield { get; set; }
        public List<Cashflow> Cashflows = new List<Cashflow>();

        public ProspectiveCashflow(List<BalanceTab> ListBalanceTab, DateTime? EffDate, string field = "EndingBalance")
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;

            foreach (BalanceTab bal in ListBalanceTab)
            {
                switch (field)
                {
                    case "BeginningBalance":
                        Cashflows.Add(new Cashflow(bal.Date.Value.Date, bal.BeginningBalance.GetValueOrDefault(0)));
                        break;

                    case "FutureAdvances":
                        Cashflows.Add(new Cashflow(bal.Date.Value.Date, bal.FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)));
                        break;

                    case "Curtailments":
                        Cashflows.Add(new Cashflow(bal.Date.Value.Date, bal.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)));
                        break;

                    case "ScheduledPrincipal":
                        Cashflows.Add(new Cashflow(bal.Date.Value.Date, bal.PrincipalReceivedperServicing.GetValueOrDefault(0)));
                        break;
                    case "Balloon":
                        Cashflows.Add(new Cashflow(bal.Date.Value.Date, bal.BalloonPayment.GetValueOrDefault(0)));
                        break;

                    case "EndingBalance":
                        Cashflows.Add(new Cashflow(bal.Date.Value.Date, bal.EndingBalance.GetValueOrDefault(0)));
                        break;
                }
            }
        }
        public ProspectiveCashflow(List<CouponTab> ListCouponTab, DateTime? EffDate)
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;

            foreach (CouponTab cpn in ListCouponTab)
                Cashflows.Add(new Cashflow(cpn.Date.Value.Date, cpn.InterestPaidServicingWithDropDate.GetValueOrDefault(0))); ;

        }
        public ProspectiveCashflow(List<FeesTab> ListFeesTab, DateTime? EffDate)
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;

            foreach (FeesTab fee in ListFeesTab)
                Cashflows.Add(new Cashflow(fee.Date.Value.Date, fee.FeeAmountIncludedinLevelYield.GetValueOrDefault(0))); ;

        }
        public ProspectiveCashflow(List<DateTime> Dates, List<Decimal> DValues, DateTime? EffDate, Double Yield)
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;

            for (int i = 0; i < Dates.Count; i++)
            {
                if (i < DValues.Count)
                    Cashflows.Add(new Cashflow(Dates[i], DValues[i]));
                else
                    Cashflows.Add(new Cashflow(Dates[i], 0));
            }
        }

        public ProspectiveCashflow(List<GAAPBasisTab> ListGAAPBasisTab, DateTime? EffDate, Double Yield, string fieldname)
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;
            DateTime dt;

            foreach (GAAPBasisTab gaap in ListGAAPBasisTab)
            {
                dt = gaap.Date.HasValue ? gaap.Date.Value : DateTime.MinValue;
                switch (fieldname)
                {
                    case "Fee":
                        Cashflows.Add(new Cashflow(dt, gaap.DeferredFeeAccrualBasis));
                        break;
                    case "Discount":
                        Cashflows.Add(new Cashflow(dt, gaap.DiscountPremiumAccrualBasis));
                        break;
                    case "CapCost":
                        Cashflows.Add(new Cashflow(dt, gaap.CapitalizedCostsAccrualBasis));
                        break;
                    case "Par":
                        Cashflows.Add(new Cashflow(dt, gaap.ParBasis));
                        break;
                    case "AllIn":
                        Cashflows.Add(new Cashflow(dt, gaap.AllInBasis));
                        break;
                    case "FeeAmort":
                        Cashflows.Add(new Cashflow(dt, gaap.AmortofDeferredFees));
                        break;
                    case "DiscAmort":
                        Cashflows.Add(new Cashflow(dt, gaap.DiscountPremiumAccrual));
                        break;
                    case "CapCostAmort":
                        Cashflows.Add(new Cashflow(dt, gaap.CapitalizedCostAccrual));
                        break;
                }
            }
        }

        public ProspectiveCashflow(List<PVBasisTab> ListPVBasis, DateTime? EffDate, Double Yield, string fieldname)
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;
            DateTime dt;

            foreach (PVBasisTab pv in ListPVBasis)
            {
                dt = pv.Date.HasValue ? pv.Date.Value : DateTime.MinValue;
                switch (fieldname)
                {
                    case "LevelYield":
                        Cashflows.Add(new Cashflow(dt, pv.LockedPreCapBasis));
                        break;
                    case "AllIn":
                        Cashflows.Add(new Cashflow(dt, pv.AllInBasis));
                        break;
                }
            }
        }

        public ProspectiveCashflow(List<SLBasisTab> ListSLBasis, DateTime? EffDate, Double Yield, string fieldname)
        {
            EffectiveDate = EffDate;
            this.Yield = Yield;
            DateTime dt;

            foreach (SLBasisTab sl in ListSLBasis)
            {
                dt = sl.Date.HasValue ? sl.Date.Value : DateTime.MinValue;
                switch (fieldname)
                {
                    case "FeeLY":
                        Cashflows.Add(new Cashflow(dt, sl.SLAmortOfTotalFeesInclInLY));
                        break;
                    case "Fee":
                        Cashflows.Add(new Cashflow(dt, sl.SLAmortOfTotalFees));
                        break;
                    case "SLBasis":
                        Cashflows.Add(new Cashflow(dt, sl.SLBasis));
                        break;
                }
            }
        }
    }

    public struct Cashflow
    {
        public DateTime CFDate;
        public Decimal? CFValue;

        public Cashflow(DateTime date, Decimal? value)
        {
            CFDate = date;
            CFValue = value;
        }

    }
}
