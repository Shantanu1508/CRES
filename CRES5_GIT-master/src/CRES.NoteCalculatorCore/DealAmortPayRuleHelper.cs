using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using System.Threading.Tasks;

namespace CRES.NoteCalculator
{
    public class DealAmortPayRuleHelper
    {
        public DealDataContract dealDC = new DealDataContract();
        public AmortDataContract AmortDC = new AmortDataContract();
        public List<AmortTargetNoteFundingScheduleDataContract> _amortTargetNoteFundingScheduleDataContractList = new List<AmortTargetNoteFundingScheduleDataContract>();
        int minFundingPriority = 0;
        int maxFundingPriority = 0;
        int minFundingSequence = 0;
        int maxFundingSequence = 0;
        public DataTable GetStartEndDate(DealDataContract dealDC)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("StartDate");
            dt.Columns.Add("EndDate");
            dt.Columns.Add("FirstStartDate");
            dt.Columns.Add("LastEndDate");

            DateTime Amort_StartDate, Amort_EndDate;
            DateTime? min_InitialInterestAccrualEndDate, max_ActualPayoffDate, max_FullyExtendedMaturityDate, max_InitialMaturityDate;
            int? min_IOTerm = 0;
            // int? max_AmortTerm = 0;
            List<NoteListDealAmortDataContarct> lstnoteDC = new List<NoteListDealAmortDataContarct>();
            lstnoteDC = dealDC.amort.NoteListForDealAmort.FindAll(x => x.UseRuletoDetermineAmortizationText == "Y" || x.UseRuletoDetermineAmortizationText == "3");
            if (lstnoteDC.Count == 0)
            {

            }
            else
            {
                min_InitialInterestAccrualEndDate = lstnoteDC.Select(x => x.InitialInterestAccrualEndDate).Min();
                if (min_InitialInterestAccrualEndDate != null)
                {
                    min_IOTerm = lstnoteDC.Select(x => x.IOTerm).Min().GetValueOrDefault(0);
                    //     max_AmortTerm = lstnoteDC.Select(x => x.AmortTerm).Max().GetValueOrDefault(0);
                    max_ActualPayoffDate = lstnoteDC.Select(x => x.ActualPayoffDate).Max();
                    max_FullyExtendedMaturityDate = lstnoteDC.Select(x => x.FullyExtendedMaturityDate).Max();
                    max_InitialMaturityDate = lstnoteDC.Select(x => x.InitialMaturityDate).Max();
                    Amort_StartDate = Convert.ToDateTime(min_InitialInterestAccrualEndDate).AddMonths(Convert.ToInt32(min_IOTerm));
                    if (max_ActualPayoffDate != null)
                        Amort_EndDate = Convert.ToDateTime(max_ActualPayoffDate);
                    else if (max_FullyExtendedMaturityDate != null)
                        Amort_EndDate = Convert.ToDateTime(max_FullyExtendedMaturityDate);
                    else
                        Amort_EndDate = Convert.ToDateTime(max_InitialMaturityDate);


                    Amort_EndDate = Amort_EndDate.AddMonths(-1);
                    if (Amort_EndDate.Date != System.DateTime.MinValue) 
                    {
                        if (Amort_StartDate.Date != System.DateTime.MinValue) 
                        {
                            Amort_EndDate = DateExtensions.CreateNewDate(Amort_EndDate.Year, Amort_EndDate.Month, Amort_StartDate.Day);
                        }
                        
                    }

                    
                    //  Amort_EndDate = Convert.ToDateTime(Amort_StartDate).AddMonths(Convert.ToInt32(max_AmortTerm));

                    //if (dealDC.amort.BusinessDayAdjustmentForAmortText == "Yes" || dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                    //{
                    //    DateTime dtnxtdate = DateExtensions.CreateNewDate(Amort_StartDate.Year, Amort_StartDate.Month, Amort_StartDate.Day);
                    //    Amort_StartDate = DateExtensions.GetnextWorkingDays(dtnxtdate.AddDays(1), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                    //    DateTime dtenxtdate = DateExtensions.CreateNewDate(Amort_EndDate.Year, Amort_EndDate.Month, Amort_EndDate.Day);
                    //    Amort_EndDate = DateExtensions.GetnextWorkingDays(dtenxtdate.AddDays(1), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                    //}
                    DataRow dr = dt.NewRow();
                    dr["StartDate"] = Amort_StartDate.ToShortDateString(); //Amort_StartDate.ToShortDateString();
                    dr["EndDate"] = Amort_EndDate.ToShortDateString(); //Amort_EndDate.ToShortDateString();
                    dr["FirstStartDate"] = FirstDayOfMonth(Amort_StartDate).ToShortDateString(); //Amort_StartDate.ToShortDateString();
                    dr["LastEndDate"] = LastDayOfMonth(Amort_EndDate).ToShortDateString(); //Amort_EndDate.ToShortDateString();

                    dt.Rows.Add(dr);
                }
            }


            return dt;

        }

        public DataTable GetAmort(DealDataContract dc, DataTable data)
        {
            dealDC = dc;
            List<DealAmortScheduleDataContract> lstAmortSch = new List<DealAmortScheduleDataContract>();
            List<NoteListDealAmortDataContarct> lstnoteDC = new List<NoteListDealAmortDataContarct>();

            try
            {
                lstnoteDC = dealDC.amort.NoteListForDealAmort.FindAll(x => x.UseRuletoDetermineAmortizationText == "Y" || x.UseRuletoDetermineAmortizationText == "3");
                DateTime Amort_StartDate, Amort_EndDate, Amortdb_StartDate, Amortdb_EndDate;
                DataTable datagen, StartEndDatedt;

                //DateTime? min_InitialInterestAccrualEndDate, max_ActualPayoffDate, max_FullyExtendedMaturityDate, max_InitialMaturityDate;
                //int? min_IOTerm = 0;
                //int? max_AmortTerm = 0;

                if (lstnoteDC.Count == 0)
                {
                    if (dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText != "Y").Count() == dealDC.amort.NoteListForDealAmort.Count())
                    {
                        data = null;
                    }
                }
                else
                {
                    StartEndDatedt = GetStartEndDate(dc);
                    if (StartEndDatedt.Rows.Count > 0)
                    {
                        Amort_StartDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["StartDate"]);
                        Amort_EndDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["EndDate"]);

                        if (data.Rows.Count > 0)
                        {

                            if (lstnoteDC.Count > 0)
                            {

                                var rows = data.AsEnumerable().Where(x => x.Field<DateTime>("Date") >= FirstDayOfMonth(Amort_StartDate) && x.Field<DateTime>("Date") <= LastDayOfMonth(Amort_EndDate));
                                datagen = rows.Any() ? rows.CopyToDataTable() : data.Clone();

                                Amortdb_StartDate = Convert.ToDateTime(datagen.AsEnumerable().Min(row => row["Date"]));
                                Amortdb_EndDate = Convert.ToDateTime(datagen.AsEnumerable().Max(row => row["Date"]));


                                //ex Amortdb_EndDate = 1 Nov 2020 , Amort_EndDate = 1 Dec 2020
                                if (Amortdb_EndDate.Date < Amort_EndDate.Date)
                                {
                                    data = datagen;
                                    var scount = datagen.Rows.Count;

                                    for (DateTime i = Amortdb_EndDate.AddMonths(1); FirstDayOfMonth(i) <= LastDayOfMonth(Amort_EndDate);)
                                    {
                                        DataRow dr = data.NewRow();

                                        {
                                            if (dealDC.amort.BusinessDayAdjustmentForAmortText == "Yes" || dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                                            {
                                                DateTime dtnxtdate = DateExtensions.CreateNewDate(i.Year, i.Month, i.Day);
                                                DateTime dt = DateExtensions.GetWorkingDayUsingOffset(dtnxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;                                                
                                                dr["Date"] = dt;
                                            }
                                            else
                                            {
                                                if (i.Month == Amort_EndDate.Month && i.Year == Amort_EndDate.Year)
                                                    dr["Date"] = Amort_EndDate;
                                                else
                                                    dr["Date"] = i;
                                            }
                                        }
                                        i = i.AddMonths(1);
                                        data.Rows.Add(dr);
                                    }
                                }

                                //ex Amortdb_StartDate = 1 Feb 2020 , Amort_StartDate = 1 Jan 2020
                                if (Amortdb_StartDate.Date < Amort_StartDate.Date)
                                {
                                    data = datagen;
                                    var scount = datagen.Rows.Count;

                                    //sam
                                    for (DateTime i = Amortdb_StartDate.AddMonths(-1); FirstDayOfMonth(i) <= Amort_StartDate;)
                                    {
                                        DataRow dr = data.NewRow();

                                        {
                                            if (dealDC.amort.BusinessDayAdjustmentForAmortText == "Yes" || dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                                            {
                                                DateTime dtnxtdate = DateExtensions.CreateNewDate(i.Year, i.Month, i.Day);
                                                DateTime dt = DateExtensions.GetWorkingDayUsingOffset(dtnxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                                                dr["Date"] = dt;
                                            }
                                            else
                                            {
                                                dr["Date"] = i;
                                            }
                                        }
                                        i = i.AddMonths(1);
                                        data.Rows.InsertAt(dr, 0);
                                    }
                                }

                                //pushp
                                if (Amort_StartDate.Date < Amortdb_StartDate.Date)
                                {
                                    data = datagen;
                                    var scount = datagen.Rows.Count;
                                    var pos = 0;
                                    for (DateTime i = Amort_StartDate.Date; FirstDayOfMonth(i) < FirstDayOfMonth(Amortdb_StartDate).Date;)
                                    {
                                        DataRow dr = data.NewRow();

                                        if (dealDC.amort.BusinessDayAdjustmentForAmortText == "Yes" || dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                                        {
                                            DateTime dtnxtdate = DateExtensions.CreateNewDate(i.Year, i.Month, i.Day);
                                            DateTime dt = DateExtensions.GetWorkingDayUsingOffset(dtnxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
                                            dr["Date"] = dt;
                                        }
                                        else
                                        {
                                            dr["Date"] = i;
                                        }

                                        i = i.AddMonths(1);
                                        data.Rows.InsertAt(dr, pos);
                                        pos++;

                                    }

                                }


                                //ex Amortdb_EndDate = 1 Dec 2020 , Amort_EndDate = 1 Nov 2020
                                //OR Amortdb_StartDate = 1 Jan 2020 , Amort_StartDate = 1 Feb 2020
                                if (Amortdb_EndDate.Date > Amort_EndDate.Date || Amortdb_StartDate.Date < Amort_StartDate.Date)
                                {
                                    foreach (DataRow dr in data.Rows)
                                    {
                                        if (dr["Date"].ToDateTime() < Amort_StartDate)
                                        {
                                            data.Rows.Remove(dr);
                                        }
                                        else if (dr["Date"].ToDateTime() > Amort_EndDate)
                                        {
                                            data.Rows.Remove(dr);
                                        }
                                    }
                                }


                            }
                        }
                        else
                        {
                            data = new DataTable();
                            data.Columns.Add("Date");
                            data.Columns.Add("Amount", typeof(decimal));
                            if (lstnoteDC.Count > 0)
                            {
                                for (var s = 0; s < lstnoteDC.Count; s++)
                                {
                                    data.Columns.Add(lstnoteDC[s].Name);
                                }

                            }

                            for (DateTime i = Amort_StartDate; FirstDayOfMonth(i) <= Amort_EndDate;)
                            {

                                DataRow dr = data.NewRow();
                                if (dealDC.amort.BusinessDayAdjustmentForAmortText == "Yes" || dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                                {
                                    DateTime dtnxtdate = DateExtensions.CreateNewDate(i.Year, i.Month, i.Day);
                                    DateTime dt = DateExtensions.GetWorkingDayUsingOffset(dtnxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
                                    dr["Date"] = dt;
                                }
                                else
                                {
                                    if (i.Month == Amort_EndDate.Month && i.Year == Amort_EndDate.Year)
                                        dr["Date"] = Amort_EndDate;
                                    else
                                        dr["Date"] = i;
                                }

                                i = i.AddMonths(1);
                                data.Rows.Add(dr);
                            }
                        }


                    }


                    if (dealDC.amort.AmortizationMethodText.ToLower() == "Custom Note Amortization".ToLower())
                    {
                        //DataTable dt = new DataTable();
                        int colIndex = 10;
                        if (data != null)
                        {
                            foreach (DataRow dr in data.Rows)
                            {
                                double sumNote = 0.0;
                                foreach (DataColumn dcol in data.Columns)
                                {
                                    if (dcol.ColumnName == "Amount")
                                        colIndex = dcol.Ordinal;

                                    if (dcol.Ordinal > colIndex) // after Amount column
                                    {
                                        double _amount = 0.0;
                                        _amount = dr[dcol] == DBNull.Value ? 0.0 : Convert.ToDouble(dr[dcol]);
                                        sumNote += Convert.ToDouble(_amount);
                                    }
                                    // colIndex++;
                                }
                                if (sumNote > 0)
                                {
                                    dr["Amount"] = sumNote;
                                }
                            }

                            if (data.Rows[0]["Amount"].ToString() == "")
                            {
                                data.Rows[0]["Amount"] = 0;
                            }
                        }
                    }
                    if (dealDC.amort.AmortizationMethodText.ToLower() == "Fixed Payment Amortization".ToLower())
                    {
                        double FixedPeriodicPayment = Convert.ToDouble(dealDC.amort.FixedPeriodicPayment);
                        int colIndex = 10;
                        if (data != null)
                        {
                            foreach (DataRow dr in data.Rows)
                            {
                                double sumNote = 0.0;
                                foreach (DataColumn dcol in data.Columns)
                                {

                                    if (dcol.ColumnName == "Amount")
                                        colIndex = dcol.Ordinal;
                                    if (dcol.Ordinal > colIndex) // after Amount column
                                    {
                                        double _amount = 0.0;
                                        _amount = dr[dcol] == DBNull.Value ? 0.0 : Convert.ToDouble(dr[dcol]);
                                        sumNote += Convert.ToDouble(_amount);
                                    }

                                }
                                dr["Amount"] = sumNote;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                AmortDC.DealAmortGenerationExceptionMessage = "Funding schedule generation failed - " + System.Environment.NewLine + "" + ex.Message;
            }
            return data;
        }

        public void CalculateRatio(DataTable data, List<NoteAmortFundingDataContract> lstNoteEndingBalance, int rowIndex)
        {
            Decimal? _noteAmortSchedleAmountSum = 0;


            //method: Pro - rata by Commitments
            if (dealDC.amort.NoteDistributionMethod == 624)
            {
                var item = dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList();
                item.ForEach(x => x.NoteAmortSchedleAmount = x.TotalCommitment);
            }
            //method: Pro-rata by Ending Balance --> All Note amount before current month
            else if (dealDC.amort.NoteDistributionMethod == 626)
            {
                //dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList().ForEach(x => x.NoteAmortSchedleAmount = x.TotalCommitment);
                //DateTime dtNow = DateTime.Now;
                //DateTime? dtFirstDayOfMonth = FirstDayOfMonth(DateTime.Now);

                DataRow dr = data.Rows[rowIndex];
                foreach (var item in dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList())
                {
                    //take ending balance of perticuler Note
                    item.NoteAmortSchedleAmount = lstNoteEndingBalance.Where(x => x.NoteID.ToString() == item.NoteId && Convert.ToDateTime(x.Date) == Convert.ToDateTime(dr["Date"])).ToList().Sum(y => y.EndingBalance);

                    if (rowIndex > 0)
                    {
                        decimal? _noteAmortAmount = 0;
                        DataRow dr1 = data.Rows[rowIndex - 1];
                        foreach (DataColumn dcol in data.Columns)
                        {
                            if (dcol.ColumnName == item.Name)
                            {
                                _noteAmortAmount = Convert.ToDecimal(dr1[dcol]);
                            }
                        }
                        // reduce previous date Note amort amount from ending balance of perticuler Note
                        item.NoteAmortSchedleAmount = item.NoteAmortSchedleAmount - _noteAmortAmount;
                    }
                }
            }
            //method: Pro-rata by Beginning Balance --> All Note amount before current month + 1 date of current month
            else if (dealDC.amort.NoteDistributionMethod == 627)
            {
                DataRow dr = data.Rows[rowIndex];
                foreach (var item in dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList())
                {
                    //take begining balance(next day ending balance) of perticuler Note
                    item.NoteAmortSchedleAmount = lstNoteEndingBalance.Where(x => x.NoteID.ToString() == item.NoteId && Convert.ToDateTime(x.Date) == Convert.ToDateTime(dr["Date"]).AddDays(1)).ToList().Sum(y => y.EndingBalance);

                    if (rowIndex > 0)
                    {
                        decimal? _noteAmortAmount = 0;
                        DataRow dr1 = data.Rows[rowIndex - 1];
                        foreach (DataColumn dcol in data.Columns)
                        {
                            if (dcol.ColumnName == item.Name)
                            {
                                _noteAmortAmount = Convert.ToDecimal(dr1[dcol]);
                            }
                        }
                        // reduce previous date Note amort amount from begining balance of perticuler Note
                        item.NoteAmortSchedleAmount = item.NoteAmortSchedleAmount - _noteAmortAmount;
                    }
                }

                //DateTime? dtFirstDayOfMonth = FirstDayOfMonth(DateTime.Now);
                //foreach (var item in dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList())
                //{
                //    item.NoteAmortSchedleAmount = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID.ToString() == item.NoteId && Convert.ToDateTime(x.Date).Date <= Convert.ToDateTime(dtFirstDayOfMonth).Date && x.Value > 0).ToList().Sum(y => y.Value);
                //}
            }

            //method: Pro-rata by Ending Funded Balances -->   Initial funding balance+ Sum of Future funding until period end date (funding date).
            else if (dealDC.amort.NoteDistributionMethod == 625)
            {
                //dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList().ForEach(x => x.NoteAmortSchedleAmount = x.TotalCommitment);
                DataRow dr = data.Rows[rowIndex];
                foreach (var item in dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList())
                {
                    decimal? _noteInitialFunding = item.InitialFundingAmount;
                    item.NoteAmortSchedleAmount = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID.ToString() == item.NoteId && x.Value > 0 && Convert.ToDateTime(x.Date) < Convert.ToDateTime(dr["Date"]).AddDays(1)).ToList().Sum(y => y.Value);
                    item.NoteAmortSchedleAmount += _noteInitialFunding;

                    //item.NoteAmortSchedleAmount = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID.ToString() == item.NoteId && x.Applied == true && x.Value > 0).ToList().Sum(y => y.Value);
                }
            }

            /*
         //method: Use Payrules --> use Funding sequence amount and generate ratio

         else if (dealDC.amort.NoteDistributionMethod == 636)
         {
             //DateTime? dtFirstDayOfMonth = FirstDayOfMonth(DateTime.Now);
             //foreach (var item in dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList())
             //{
             //    item.NoteAmortSchedleAmount = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID.ToString() == item.NoteId && Convert.ToDateTime(x.Date).Date <= Convert.ToDateTime(dtFirstDayOfMonth).Date && x.Value > 0).ToList().Sum(y => y.Value);
             //}

             //assign Ratio form NoteListForDealAmort to AmortSequenceList for reduce joins
             Decimal? sum = 0;
             minFundingPriority = dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Min(x => x.Priority).GetValueOrDefault(0);
             maxFundingSequence = Convert.ToInt32(dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.UseRuletoDetermineAmortizationText == "Y")).ToList().Max(x => x.SequenceNo));

             maxFundingPriority = dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Max(x => x.Priority).GetValueOrDefault(0);
             dealDC.amort.NoteListForDealAmort.Where(x => x.Priority == null & x.UseRuletoDetermineAmortizationText == "Y").ToList().ForEach(i => i.Priority = maxFundingPriority + 1);
             maxFundingPriority = (dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Max(x => x.Priority)).GetValueOrDefault(0);


             for (int i = minFundingPriority; i <= maxFundingPriority; i++) //Funding Priority
             {
                 for (int y = 1; y <= maxFundingSequence; y++) //Funding Sequence
                 {
                     //sum = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == y && a.SequenceTypeText == "Funding Sequence") join t in dealDC.PayruleNoteDetailFundingList.Where(b => b.FundingPriority == i) on x.NoteID equals t.NoteID select x.Value.GetValueOrDefault(0)).Sum();
                     sum = (from x in dealDC.amort.AmortSequenceList.Where(a => a.SequenceNo == y) join t in dealDC.amort.NoteListForDealAmort.Where(b => b.Priority == i) on x.NoteID.ToString() equals t.NoteId select x.Value.GetValueOrDefault(0)).Sum();

                     if (sum != 0)
                     {
                         //dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Funding Sequence" && ((from id in dealDC.PayruleNoteDetailFundingList where id.FundingPriority == i && id.NoteID == x.NoteID select true).FirstOrDefault()) == true)
                         //    .ToList().ForEach(r => r.Ratio = r.Value.GetValueOrDefault(0) / sum);

                         dealDC.amort.AmortSequenceList.Where(x => x.SequenceNo == y && ((from id in dealDC.amort.NoteListForDealAmort where id.Priority == i && id.NoteId == x.NoteID.ToString() select true).FirstOrDefault()) == true)
                             .ToList().ForEach(r => r.Ratio = r.Value.GetValueOrDefault(0) / sum);
                     }
                 }
             }
         }
         */

            _noteAmortSchedleAmountSum = dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList().Sum(y => y.NoteAmortSchedleAmount);

            if (_noteAmortSchedleAmountSum != 0)
            {
                dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList().ForEach(y => y.Ratio = y.NoteAmortSchedleAmount / _noteAmortSchedleAmountSum);
            }
            else // when submethod not fetch matching condition then equaliy assign Ratio
            {
                int cntNote = dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList().Count();
                dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList().ForEach(y => y.Ratio = (Math.Round(((decimal)1 / cntNote), 8)));
            }


        }


        //public void SettleAmountByRoundingRule(DataTable)
        //{
        //}

        public void GenerateAmort(DataTable data, List<NoteAmortFundingDataContract> lstNoteEndingBalance)
        {
            //method: Pro - rata by Commitments = 624 || Not Applicable = 635
            if (dealDC.amort.NoteDistributionMethod == 624 || dealDC.amort.NoteDistributionMethod == 635)
            {
                CalculateRatio(null, null, 0);
            }

            //maxFundingPriority = dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Max(x => x.Priority).GetValueOrDefault(0);
            //dealDC.amort.NoteListForDealAmort.Where(x => x.Priority == null & x.UseRuletoDetermineAmortizationText == "Y").ToList().ForEach(i => i.Priority = maxFundingPriority + 1);
            //maxFundingPriority = (dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Max(x => x.Priority)).GetValueOrDefault(0);

            minFundingPriority = dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Min(x => x.Priority).GetValueOrDefault(0);
            maxFundingSequence = 1;

            Decimal? sumFunding = 0, usedFunding = 0, totalFundingSequence = 0;
            minFundingSequence = 1;

            int arrFundingIndex = -1;

            if (dealDC.amort.NoteDistributionMethod == 636) //Distriution method - use payrules
            {
                //maxFundingSequence = dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y").Max(x => x.Priority).GetValueOrDefault(0);

                ////assign Ratio form NoteListForDealAmort to AmortSequenceList for reduce joins
                //foreach (var item in dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText == "Y").ToList())
                //{
                //    dealDC.amort.AmortSequenceList.Where(x => x.NoteID.ToString() == item.NoteId && x.Value > 0).ToList().ForEach(y => y.Ratio = item.Ratio);
                //}


                maxFundingSequence = Convert.ToInt32(dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.UseRuletoDetermineAmortizationText == "Y")).ToList().Max(x => x.SequenceNo));

                foreach (DataRow dr in data.Rows)
                {
                    decimal funding = Convert.ToDecimal(dr["Amount"].ToString());

                    if (funding > 0)
                    {
                        for (int i = minFundingSequence; i <= maxFundingSequence && funding != 0; i++)
                        {
                            ////totalFundingSequence = dealDC.amort.NoteListForDealAmort.Sum(x => x.NoteAmortSchedleAmount);

                            ////totalFundingSequence = Convert.ToDecimal(data.Compute("SUM(Amount)", string.Empty));
                            ////totalFundingSequence = data.AsEnumerable().Sum(x => x.Field<decimal>("Amount"));

                            //totalFundingSequence = 0;
                            //foreach (DataRow dr1 in data.Rows)
                            //{
                            //    totalFundingSequence += Convert.ToDecimal(dr1["Amount"]);
                            //}

                            ////==totalFundingSequence = dealDC.amort.NoteListForDealAmort.Sum(x => x.NoteAmortSchedleAmount);
                            ////totalFundingSequence = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Funding Sequence") select x.Value.GetValueOrDefault(0)).Sum();

                            ////var _endingBalnce = lstNoteEndingBalance.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID && a.UseRuletoDetermineAmortizationText == "Y")).ToList().Sum(x => x.EndingBalance);

                            //samrat latest code
                            totalFundingSequence = dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.UseRuletoDetermineAmortizationText == "Y" && b.SequenceNo == i)).ToList().Sum(x => x.Value);

                            //for (int j = 1; j <= 1 && funding != 0; j++)

                            for (int j = 1; j <= maxFundingPriority && funding != 0; j++)
                            {

                                // except funding sequence approach
                                //sumFunding = dealDC.amort.NoteListForDealAmort.Sum(x => x.NoteAmortSchedleAmount);

                                sumFunding = dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.UseRuletoDetermineAmortizationText == "Y" && b.SequenceNo == i && a.Priority == j)).ToList().Sum(x => x.Value);


                                // sumFunding =  (from x in dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y" ) join t in dealDC.amort.NoteListForDealAmort.Where(b => b.Priority == j) on x.NoteId equals t.NoteId select x.NoteAmortSchedleAmount.GetValueOrDefault(0)).Sum();
                                //sumFunding = Convert.ToDecimal(dr["Amount"].ToString());

                                //var list = (from dw in dealDC.PayruleNoteDetailFundingList orderby dw.FundingPriority, dw.TotalCommitment, dw.CRENoteID, dw.NoteName where dw.FundingPriority == j && dw.TotalCommitment > 0 select dw).ToList();

                                //var list = (from dw in dealDC.amort.NoteListForDealAmort orderby dw.Priority, dw.NoteAmortSchedleAmount, dw.CRENoteID, dw.Name where dw.UseRuletoDetermineAmortizationText == "Y" && dw.Priority == j && dw.NoteAmortSchedleAmount > 0 select dw).ToList();
                                var list = (from dw in dealDC.amort.NoteListForDealAmort orderby dw.Priority, dw.NoteAmortSchedleAmount, dw.CRENoteID, dw.Name where dw.UseRuletoDetermineAmortizationText == "Y" && dw.Priority == j && dw.TotalCommitment > 0 select dw).ToList(); // && dw.NoteAmortSchedleAmount > 0

                                //var list = (from dw in dealDC.amort.NoteListForDealAmort orderby dw.Priority, dw.NoteAmortSchedleAmount, dw.CRENoteID, dw.Name where dw.UseRuletoDetermineAmortizationText == "Y" select dw).ToList(); //&& dw.NoteAmortSchedleAmount > 0

                                usedFunding = 0;
                                int _cntLst = 0;
                                foreach (var lst in list)
                                {
                                    //var _distributedAmount = Math.Round((decimal)(funding * lst.Ratio), 2);

                                    //usedFunding += _distributedAmount;
                                    //foreach (DataColumn c in dr.Table.Columns)
                                    //{
                                    //    if (c.ColumnName == lst.Name)
                                    //    {
                                    //        dr[c.ColumnName] = _distributedAmount;
                                    //    }
                                    //}


                                    ////rounding code comes here
                                    //_cntLst += 1;
                                    //if (_cntLst == list.Count)
                                    //{
                                    //    if ((Math.Round((decimal)(funding), 2)) > usedFunding)
                                    //    {
                                    //        //rounding note amount += funding - usedFunding
                                    //        foreach (var lst1 in list)
                                    //        {
                                    //            //apply loop in row and add rounding difference in rounding 'Y' note
                                    //            if (Convert.ToString(lst1.RoundingNoteText) == "Y")
                                    //            {
                                    //                foreach (DataColumn c1 in dr.Table.Columns)
                                    //                {
                                    //                    if (c1.ColumnName == lst1.Name)
                                    //                    {
                                    //                        dr[c1.ColumnName] = dr[c1.ColumnName].ToDecimal() + (Math.Round((decimal)(funding), 2) - usedFunding);
                                    //                    }
                                    //                }
                                    //            }
                                    //        }
                                    //    }
                                    //}




                                    if (sumFunding == new decimal(.01) && funding > 1)
                                    {
                                        funding += (decimal)sumFunding;
                                        sumFunding = 0;
                                    }


                                    AmortTargetNoteFundingScheduleDataContract _amortTargetNoteFundingScheduleDataContract = new AmortTargetNoteFundingScheduleDataContract();

                                    if (sumFunding <= funding)
                                    {

                                        //PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence") select val.Value.GetValueOrDefault(0)).FirstOrDefault(), 2);

                                        _amortTargetNoteFundingScheduleDataContract.Value = dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.NoteId == lst.NoteId && a.UseRuletoDetermineAmortizationText == "Y" && b.SequenceNo == i)).ToList().Sum(x => x.Value);
                                        //  _amortTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId) select val.NoteAmortSchedleAmount.GetValueOrDefault(0)).FirstOrDefault(), 2); //&& x.SequenceNo == i 


                                        if (_amortTargetNoteFundingScheduleDataContract.Value <= new decimal(.01) && funding > 1)
                                        {
                                            funding -= (decimal)_amortTargetNoteFundingScheduleDataContract.Value;
                                            _amortTargetNoteFundingScheduleDataContract.Value = 0;
                                        }
                                    }
                                    else
                                    {
                                        //samrat start from here
                                        //PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence") select (funding.Value.GetValueOrDefault(0) + usedFunding) * val.Ratio).FirstOrDefault(), 2);

                                        _amortTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.NoteId == lst.NoteId && a.UseRuletoDetermineAmortizationText == "Y" && b.SequenceNo == i)).ToList().Sum(x => (funding + usedFunding) * x.Ratio)), 2);

                                        //_amortTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.NoteId == lst.NoteId && a.UseRuletoDetermineAmortizationText == "Y" && b.SequenceNo == i)).ToList().Sum(x => x.Value + usedFunding * x.Ratio) ), 2); 


                                        //_amortTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(from val in dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId) select (funding + usedFunding) * val.Ratio).FirstOrDefault(), 2); //&& x.SequenceNo == i

                                        if (_amortTargetNoteFundingScheduleDataContract.Value <= 0)
                                        { //sam need to change this
                                            _amortTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId) select val.NoteAmortSchedleAmount.GetValueOrDefault(0)).FirstOrDefault(), 2); //&& x.SequenceNo == i
                                        }
                                    }

                                    if (_amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0) <= funding)
                                    {
                                        funding = funding - Math.Round(_amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 4);

                                        if (funding == new decimal(.01) && _amortTargetNoteFundingScheduleDataContract.Value > 1)
                                        {
                                            _amortTargetNoteFundingScheduleDataContract.Value += funding;
                                            funding = 0;
                                        }
                                    }
                                    else
                                    {
                                        _amortTargetNoteFundingScheduleDataContract.Value = Math.Round(funding, 2);
                                        funding = funding - (decimal)_amortTargetNoteFundingScheduleDataContract.Value;
                                    }

                                    sumFunding = sumFunding - _amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);

                                    //dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence" && x.NoteID == lst.NoteID).ToList().ForEach(r => r.Value = r.Value - PayruleTargetNoteFundingScheduleDataContract.Value);

                                    dealDC.amort.AmortSequenceList.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID.ToString() && a.NoteId == lst.NoteId && a.UseRuletoDetermineAmortizationText == "Y" && b.SequenceNo == i)).ToList().ForEach(r => r.Value = r.Value - _amortTargetNoteFundingScheduleDataContract.Value);


                                    //dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId).ToList().ForEach(r => r.NoteAmortSchedleAmount = r.NoteAmortSchedleAmount - _amortTargetNoteFundingScheduleDataContract.Value); //x.SequenceNo == i &&
                                    usedFunding = usedFunding + _amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    totalFundingSequence = totalFundingSequence - _amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);

                                    if (Math.Round(_amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 2) != 0)
                                    {
                                        // _amortTargetNoteFundingScheduleDataContract.Date = (DateTime)dr["Date"];
                                        //  _amortTargetNoteFundingScheduleDataContract.NoteID = new Guid(lst.NoteId);
                                        //dr["Amount"] = _amortTargetNoteFundingScheduleDataContract.Value;

                                        //foreach (DataColumn c in dr.Table.Columns)
                                        //{
                                        //    if (c.ColumnName == lst.Name)
                                        //    {
                                        //        dr[c.ColumnName] = _amortTargetNoteFundingScheduleDataContract.Value;
                                        //        //string str = (c.ColumnName);
                                        //    }
                                        //}

                                        dr[lst.Name] = _amortTargetNoteFundingScheduleDataContract.Value;
                                        dr.AcceptChanges();
                                        _amortTargetNoteFundingScheduleDataContractList.Add(_amortTargetNoteFundingScheduleDataContract);

                                    }
                                }
                            }
                            if (totalFundingSequence == 0)
                                minFundingSequence = minFundingSequence + 1;

                        }
                    }
                }

            }
            else
            {
                //DataRow r = data.Rows[1];
                #region use for other distribution methods 
                foreach (DataRow dr in data.Rows)
                {
                    decimal funding = 0;
                    if (!string.IsNullOrEmpty(dr["Amount"].ToString()))
                    {
                        funding = Convert.ToDecimal(dr["Amount"].ToString());
                    }

                    if (funding > 0)
                    {

                        //method: Pro-rata by Beginning Balance = 627 || Pro-rata by Ending Balance = 626 || Pro-rata by Ending Funded Balances = 625
                        if (dealDC.amort.NoteDistributionMethod == 627 || dealDC.amort.NoteDistributionMethod == 626 || dealDC.amort.NoteDistributionMethod == 625)
                        {
                            int rowIndex = data.Rows.IndexOf(dr);
                            CalculateRatio(data, lstNoteEndingBalance, rowIndex);
                        }

                        for (int i = minFundingSequence; i <= maxFundingSequence && funding != 0; i++)
                        {
                            //totalFundingSequence = dealDC.amort.NoteListForDealAmort.Sum(x => x.NoteAmortSchedleAmount);

                            //totalFundingSequence = Convert.ToDecimal(data.Compute("SUM(Amount)", string.Empty));
                            //totalFundingSequence = data.AsEnumerable().Sum(x => x.Field<decimal>("Amount"));

                            totalFundingSequence = 0;
                            foreach (DataRow dr1 in data.Rows)
                            {
                                if (dr1["Amount"].ToString() != "")
                                    totalFundingSequence += Convert.ToDecimal(dr1["Amount"]);
                            }

                            //==totalFundingSequence = dealDC.amort.NoteListForDealAmort.Sum(x => x.NoteAmortSchedleAmount);
                            //totalFundingSequence = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Funding Sequence") select x.Value.GetValueOrDefault(0)).Sum();


                            //for (int j = 1; j <= maxFundingPriority && funding != 0; j++)
                            for (int j = 1; j <= 1 && funding != 0; j++)
                            {

                                // except funding sequence approach
                                //sumFunding = dealDC.amort.NoteListForDealAmort.Sum(x => x.NoteAmortSchedleAmount);

                                //sumFunding =  (from x in dealDC.amort.NoteListForDealAmort.Where(y => y.UseRuletoDetermineAmortizationText == "Y") join t in dealDC.amort.NoteListForDealAmort.Where(b => b.Priority == j) on x.NoteId equals t.NoteId select x.NoteAmortSchedleAmount.GetValueOrDefault(0)).Sum();
                                sumFunding = Convert.ToDecimal(dr["Amount"].ToString());

                                //var list = (from dw in dealDC.PayruleNoteDetailFundingList orderby dw.FundingPriority, dw.TotalCommitment, dw.CRENoteID, dw.NoteName where dw.FundingPriority == j && dw.TotalCommitment > 0 select dw).ToList();
                                //var list = (from dw in dealDC.amort.NoteListForDealAmort orderby dw.Priority, dw.NoteAmortSchedleAmount, dw.CRENoteID, dw.Name where dw.UseRuletoDetermineAmortizationText == "Y" && dw.Priority == j && dw.NoteAmortSchedleAmount > 0 select dw).ToList();

                                var list = (from dw in dealDC.amort.NoteListForDealAmort orderby dw.Priority, dw.NoteAmortSchedleAmount, dw.CRENoteID, dw.Name where dw.UseRuletoDetermineAmortizationText == "Y" select dw).ToList(); //&& dw.NoteAmortSchedleAmount > 0

                                usedFunding = 0;
                                int _cntLst = 0;
                                foreach (var lst in list)
                                {
                                    var _distributedAmount = Math.Round((decimal)(funding * lst.Ratio), 2);

                                    usedFunding += _distributedAmount;
                                    foreach (DataColumn c in dr.Table.Columns)
                                    {
                                        if (c.ColumnName == lst.Name)
                                        {
                                            dr[c.ColumnName] = _distributedAmount;
                                        }
                                    }


                                    //rounding code comes here
                                    _cntLst += 1;
                                    if (_cntLst == list.Count)
                                    {
                                        if ((Math.Round((decimal)(funding), 2)) > usedFunding)
                                        {
                                            //rounding note amount += funding - usedFunding
                                            foreach (var lst1 in list)
                                            {
                                                //apply loop in row and add rounding difference in rounding 'Y' note
                                                if (Convert.ToString(lst1.RoundingNoteText) == "Y")
                                                {
                                                    foreach (DataColumn c1 in dr.Table.Columns)
                                                    {
                                                        if (c1.ColumnName == lst1.Name)
                                                        {
                                                            dr[c1.ColumnName] = dr[c1.ColumnName].ToDecimal() + (Math.Round((decimal)(funding), 2) - usedFunding);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }




                                    //if (sumFunding == new decimal(.01) && funding > 1)
                                    // {
                                    //     funding += (decimal)sumFunding;
                                    //     sumFunding = 0;
                                    // }


                                    //AmortTargetNoteFundingScheduleDataContract _amortTargetNoteFundingScheduleDataContract = new AmortTargetNoteFundingScheduleDataContract();

                                    //if (sumFunding <= funding)
                                    //{
                                    //    _amortTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId) select val.NoteAmortSchedleAmount.GetValueOrDefault(0)).FirstOrDefault(), 2); //&& x.SequenceNo == i 
                                    //    if (_amortTargetNoteFundingScheduleDataContract.Value <= new decimal(.01) && funding > 1)
                                    //    {
                                    //        funding -= (decimal)_amortTargetNoteFundingScheduleDataContract.Value;
                                    //        _amortTargetNoteFundingScheduleDataContract.Value = 0;
                                    //    }
                                    //}
                                    //else
                                    //{
                                    //  _amortTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(from val in dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId) select (funding + usedFunding) * val.Ratio).FirstOrDefault(), 2); //&& x.SequenceNo == i

                                    //    if (_amortTargetNoteFundingScheduleDataContract.Value <= 0)
                                    //    {
                                    //        _amortTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId) select val.NoteAmortSchedleAmount.GetValueOrDefault(0)).FirstOrDefault(), 2); //&& x.SequenceNo == i
                                    //    }
                                    //}

                                    //if (_amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0) <= funding)
                                    //{
                                    //    funding = funding - Math.Round(_amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 4);

                                    //    if (funding == new decimal(.01) && _amortTargetNoteFundingScheduleDataContract.Value > 1)
                                    //    {
                                    //        _amortTargetNoteFundingScheduleDataContract.Value += funding;
                                    //        funding = 0;
                                    //    }
                                    //}
                                    //else
                                    //{
                                    //    _amortTargetNoteFundingScheduleDataContract.Value = Math.Round(funding, 2);
                                    //    funding = funding - (decimal)_amortTargetNoteFundingScheduleDataContract.Value;
                                    //}

                                    //sumFunding = sumFunding - _amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    //dealDC.amort.NoteListForDealAmort.Where(x => x.NoteId == lst.NoteId).ToList().ForEach(r => r.NoteAmortSchedleAmount = r.NoteAmortSchedleAmount - _amortTargetNoteFundingScheduleDataContract.Value); //x.SequenceNo == i &&
                                    //usedFunding = usedFunding + _amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    //totalFundingSequence = totalFundingSequence - _amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);

                                    //if (Math.Round(_amortTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 2) != 0)
                                    //{
                                    //   // _amortTargetNoteFundingScheduleDataContract.Date = (DateTime)dr["Date"];
                                    //  //  _amortTargetNoteFundingScheduleDataContract.NoteID = new Guid(lst.NoteId);
                                    //    //dr["Amount"] = _amortTargetNoteFundingScheduleDataContract.Value;

                                    //    foreach (DataColumn c in dr.Table.Columns)
                                    //    {
                                    //        if (c.ColumnName == lst.Name)
                                    //        {
                                    //            dr[c.ColumnName] = _amortTargetNoteFundingScheduleDataContract.Value;
                                    //            //string str = (c.ColumnName);
                                    //        }
                                    //    }
                                    //    _amortTargetNoteFundingScheduleDataContractList.Add(_amortTargetNoteFundingScheduleDataContract);

                                    //}
                                }
                            }
                            if (totalFundingSequence == 0)
                                minFundingSequence = minFundingSequence + 1;

                        }
                    }
                }
                #endregion
            }
        }


        public DataTable CalculationAmort(DealDataContract dc1, DataTable data, List<NoteAmortFundingDataContract> lstNoteEndingBalance)
        {
            dealDC = dc1;
            List<DealAmortScheduleDataContract> lstAmortSch = new List<DealAmortScheduleDataContract>();
            List<NoteListDealAmortDataContarct> lstnoteDC = new List<NoteListDealAmortDataContarct>();

            try
            {
                lstnoteDC = dealDC.amort.NoteListForDealAmort.FindAll(x => x.UseRuletoDetermineAmortizationText == "Y" || x.UseRuletoDetermineAmortizationText == "3");

                DateTime Amort_StartDate, Amort_EndDate, Amortdb_StartDate, Amortdb_EndDate;
                DataTable datagen, StartEndDatedt;
                DateTime? min_InitialInterestAccrualEndDate;// max_ActualPayoffDate, max_FullyExtendedMaturityDate, max_InitialMaturityDate;

                int max_AmortTerm;
                max_AmortTerm = lstnoteDC.Select(x => x.AmortTerm).Max().Value;

                // Reset funding grid for 'Straight Line Amortization' and 'Full Amortization by Rate & Term' because Date, Amount and Note distribution perform on backend 
                if (dealDC.amort.AmortizationMethodText.ToLower() == "Straight Line Amortization".ToLower() || dealDC.amort.AmortizationMethodText.ToLower() == "Full Amortization by Rate & Term".ToLower())
                {
                    data = null;
                }



                // Reset funding grid when all Rule = N 
                if (lstnoteDC.Count == 0)
                {
                    if (dealDC.amort.NoteListForDealAmort.Where(x => x.UseRuletoDetermineAmortizationText != "Y").Count() == dealDC.amort.NoteListForDealAmort.Count())
                    {
                        data = null;
                    }
                }
                else if (lstnoteDC.Count > 0)
                {
                    StartEndDatedt = GetStartEndDate(dealDC);
                    //if (StartEndDatedt.Rows.Count > 0)
                    //{
                    Amort_StartDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["StartDate"]);
                    Amort_EndDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["EndDate"]);
                    //  }



                    if (data != null && data.Rows.Count > 0)
                    {
                        // code for manage Note column according to Y & N 
                        DataColumnCollection columns = data.Columns;
                        for (var s = 0; s < dealDC.amort.NoteListForDealAmort.Count; s++)
                        {
                            if (dealDC.amort.NoteListForDealAmort[s].UseRuletoDetermineAmortizationText == "Y")
                            {
                                if (!columns.Contains(dealDC.amort.NoteListForDealAmort[s].Name))
                                {
                                    data.Columns.Add(dealDC.amort.NoteListForDealAmort[s].Name);
                                }

                            }
                            else
                            {
                                if (columns.Contains(dealDC.amort.NoteListForDealAmort[s].Name))
                                {
                                    data.Columns.Remove(dealDC.amort.NoteListForDealAmort[s].Name);
                                }

                            }
                        }


                        var rows = data.AsEnumerable().Where(x => x.Field<DateTime>("Date") >= FirstDayOfMonth(Amort_StartDate) && x.Field<DateTime>("Date") <= LastDayOfMonth(Amort_EndDate));
                        datagen = rows.Any() ? rows.CopyToDataTable() : data.Clone();



                        Amortdb_StartDate = Convert.ToDateTime(datagen.AsEnumerable().Min(row => row["Date"]));
                        Amortdb_EndDate = Convert.ToDateTime(datagen.AsEnumerable().Max(row => row["Date"]));

                        if (Amort_StartDate.Date == Amortdb_StartDate.Date && Amort_EndDate.Date == Amortdb_EndDate.Date)
                        {
                            data = datagen;
                        }

                        //ex Amortdb_EndDate = 1 Nov 2020 , Amort_EndDate = 1 Dec 2020
                        if (Amortdb_EndDate.Date < Amort_EndDate.Date)
                        {
                            data = datagen;
                            var scount = datagen.Rows.Count;

                            for (DateTime i = Amortdb_EndDate.AddMonths(1); i.Date <= Amort_EndDate;)
                            {
                                DataRow dr = data.NewRow();
                                dr["Date"] = i;

                                i = i.AddMonths(1);
                                data.Rows.Add(dr);
                            }
                        }

                        //ex Amortdb_StartDate = 1 Feb 2020 , Amort_StartDate = 1 Jan 2020
                        if (Amortdb_StartDate.Date < Amort_StartDate.Date)
                        {
                            data = datagen;
                            var scount = datagen.Rows.Count;

                            //sam
                            for (DateTime i = Amortdb_StartDate.AddMonths(-1); FirstDayOfMonth(i) <= Amort_StartDate;)
                            {
                                DataRow dr = data.NewRow();
                                {
                                    dr["Date"] = i;

                                }
                                i = i.AddMonths(1);
                                data.Rows.InsertAt(dr, 0);
                            }
                        }

                        //pushp
                        //   if (Amort_StartDate.Date < Amortdb_StartDate.Date)
                        if (FirstDayOfMonth(Amort_StartDate).Date < FirstDayOfMonth(Amortdb_StartDate).Date)
                        {
                            data = datagen;
                            var scount = datagen.Rows.Count;
                            var pos = 0;
                            for (DateTime i = Amort_StartDate.Date; i.Date < LastDayOfMonth(Amortdb_StartDate);)
                            {
                                DataRow dr = data.NewRow();
                                dr["Date"] = i;
                                i = i.AddMonths(1);
                                data.Rows.InsertAt(dr, pos);
                                pos++;

                            }
                            data.AcceptChanges();
                        }


                        //ex Amortdb_EndDate = 1 Dec 2020 , Amort_EndDate = 1 Nov 2020
                        //OR Amortdb_StartDate = 1 Jan 2020 , Amort_StartDate = 1 Feb 2020
                        if (LastDayOfMonth(Amortdb_EndDate).Date > LastDayOfMonth(Amort_EndDate).Date || Amortdb_StartDate.Date < Amort_StartDate.Date)
                        {

                            for (int i = 0; i < data.Rows.Count; i++)
                            {
                                if (data.Rows[i]["Date"].ToDateTime() < Amort_StartDate)
                                {
                                    data.Rows[i].Delete();
                                    data.AcceptChanges();
                                }
                                else if (data.Rows[i]["Date"].ToDateTime() > Amort_EndDate)
                                {
                                    //dr.Delete();
                                    data.Rows[i].Delete();
                                    data.AcceptChanges();
                                }
                            }


                        }


                    }
                    else
                    {
                        data = new DataTable();
                        data.Columns.Add("DateWithoutAdjustment", typeof(System.DateTime));
                        data.Columns.Add("Date");
                        data.Columns.Add("Amount", typeof(decimal));
                        if (lstnoteDC.Count > 0)
                        {
                            for (var s = 0; s < lstnoteDC.Count; s++)
                            {
                                data.Columns.Add(lstnoteDC[s].Name);
                            }

                        }

                        for (DateTime i = Amort_StartDate; i.Date <= LastDayOfMonth(Amort_EndDate);)
                        {

                            DataRow dr = data.NewRow();
                            dr["Date"] = i;
                            i = i.AddMonths(1);
                            data.Rows.Add(dr);
                        }
                    }


                    //   if (dealDC.amort.BusinessDayAdjustmentForAmortText == "Yes" && dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                    if (dealDC.amort.BusinessDayAdjustmentForAmort == 571)
                    {
                        data = ManageHolidayAdjustment(data, Amort_EndDate, true);
                    }
                    else
                    {
                        data = ManageHolidayAdjustment(data, Amort_EndDate, false);
                    }


                    //if (dc.amort.AmortizationMethodText == "Custom Note Amortization" || dc.amort.AmortizationMethod == 622)


                    #region Code for generate date range
                    /*
                    if (Amort_StartDate != Amort_EndDate)
                    {
                        var scount = data.Rows.Count;
                        if (scount > 0)
                        {
                          //  Amort_StartDate = Convert.ToDateTime(data.AsEnumerable().Max(row => row["Date"]));
                          ////  Amortdb_StartDate = Convert.ToDateTime(data.AsEnumerable().Min(row => row["Date"]));
                          //  Amort_EndDate = Convert.ToDateTime(Amortdb_StartDate).AddMonths(Convert.ToInt32(max_AmortTerm));
                          ////  Amort_EndDate = LastDayOfMonth(Amort_EndDate);


                        }

                        for (DateTime i = Amort_StartDate; LastDayOfMonth(i) < Amort_EndDate; )
                        {

                            DataRow dr = data.NewRow();

                            if (scount == 0)
                            {
                                if (dc.amort.BusinessDayAdjustmentForAmortText == "Yes")
                                {
                                    DateTime dtnxtdate = DateExtensions.CreateNewDate(Amort_StartDate.Year, Amort_StartDate.Month, Amort_StartDate.Day);
                                    DateTime dt = DateExtensions.GetnextWorkingDays(dtnxtdate.AddDays(1), Convert.ToInt16(-1), "US", dc.ListHoliday).Date;
                                    dr["Date"] = dt;
                                }
                                else
                                {
                                    dr["Date"] = Amort_StartDate;
                                }
                            }
                            else
                            {
                                if (dc.amort.BusinessDayAdjustmentForAmortText == "Yes")
                                {

                                    DateTime dtnxtdate = DateExtensions.CreateNewDate(i.Year, i.Month + 1, i.Day);
                                    DateTime dt = DateExtensions.GetnextWorkingDays(dtnxtdate.AddDays(1), Convert.ToInt16(-1), "US", dc.ListHoliday).Date;
                                    dr["Date"] = dt;
                                }
                                else
                                {
                                    dr["Date"] = i.AddMonths(1);
                                }
                                i = i.AddMonths(1);
                            }
                            scount++;
                            data.Rows.Add(dr);
                        }
                    }
                    else
                    {

                        Amortdb_StartDate = Convert.ToDateTime(data.AsEnumerable().Min(row => row["Date"]));

                        if (Amortdb_StartDate != Amort_StartDate)
                        {
                            DataRow dr = data.NewRow();
                            if (dc.amort.BusinessDayAdjustmentForAmortText == "Yes")
                            {
                                DateTime dtnxtdate = DateExtensions.CreateNewDate(Amort_StartDate.Year, Amort_StartDate.Month, Amort_StartDate.Day);
                                DateTime dt = DateExtensions.GetnextWorkingDays(dtnxtdate.AddDays(1), Convert.ToInt16(-1), "US", dc.ListHoliday).Date;
                                dr["Date"] = dt;
                            }
                            else
                            {
                                dr["Date"] = Amort_StartDate;
                            }

                            data.Rows.Add(dr);
                        }
                    }
                    */
                    #endregion


                    #region Generate Amount for "Custom Note Amortization"
                    if (dealDC.amort.AmortizationMethodText.ToLower() == "Custom Note Amortization".ToLower())
                    {
                        data.Columns.Remove("Amount");
                        data.AcceptChanges();
                        data.Columns.Add("Amount", typeof(decimal));

                        //if (data.Rows[0]["Amount"].ToString() == "")
                        //{
                        //    data.Rows[0]["Amount"] = 0;
                        //}
                        //DataTable dt = new DataTable();

                        foreach (DataRow dr in data.Rows)
                        {
                            double sumNote = 0.0;
                            int DatecolIndex = 10, AmountcolIndex = 50;
                            foreach (DataColumn dcol in data.Columns)
                            {
                                if (dcol.ColumnName == "Date")
                                    DatecolIndex = dcol.Ordinal;

                                if (dcol.ColumnName == "Amount")
                                    AmountcolIndex = dcol.Ordinal;
                                //if (dcol.ColumnName == "Amount")
                                //    colIndex = dcol.Ordinal;

                                if (dcol.Ordinal > DatecolIndex && dcol.Ordinal < AmountcolIndex) // after Amount column
                                {
                                    double _amount = 0.0;
                                    _amount = dr[dcol] == DBNull.Value ? 0.0 : Convert.ToDouble(dr[dcol]);
                                    sumNote += Convert.ToDouble(_amount);
                                }
                                // colIndex++;
                            }
                            //if (sumNote > 0)
                            //{                                   
                            dr["Amount"] = sumNote;
                            // }
                        }
                        data.AcceptChanges();
                    }

                    #endregion

                    #region Generate Amount for "Straight Line Amortization" & "Full Amortization by Rate & Term"

                    if (dealDC.amort.AmortizationMethodText.ToLower() == "Straight Line Amortization".ToLower())
                    {
                        List<PayruleDealFundingDataContract> lstPayruleDealFundingDataContract = new List<PayruleDealFundingDataContract>();


                        if (dealDC.amort.PeriodicStraightLineAmortOverride > 0)
                        {

                            foreach (DataRow dr in data.Rows)
                            {
                                dr["Amount"] = dealDC.amort.PeriodicStraightLineAmortOverride;
                            }
                        }
                        else
                        {

                        }
                        //CalculateRatio();

                        //ManageFundingAmountByCurtelment(data);
                        GenerateAmort(data, lstNoteEndingBalance);

                        /*
                       if (Convert.ToString(dealDC.amort.ReduceAmortizationForCurtailments) == "571") // ReduceAmortizationForCurtailments = Y
                       {



                                                       decimal amort_Amount = 0;
                                                       if (dealDC.amort.PeriodicStraightLineAmortOverride > 0)
                                                       {
                                                           amort_Amount = (decimal)dealDC.amort.PeriodicStraightLineAmortOverride;
                                                       }
                                                       else
                                                       {
                                                           var _endingBalnce = lstNoteEndingBalance.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID && a.UseRuletoDetermineAmortizationText == "Y")).ToList().Sum(x => x.EndingBalance);
                                                           amort_Amount = (Math.Round(Convert.ToDecimal(_endingBalnce), 2));
                                                       }

                                                       amort_Amount = amort_Amount / max_AmortTerm;

                                                       if (amort_Amount > 0)
                                                       {
                                                           foreach (DataRow dr in data.Rows)
                                                           {
                                                               dr["Amount"] = amort_Amount;
                                                           }

                                                           CalculateRatio();
                                                           GenerateAmort(data);
                                                       }
                                                       else
                                                       {
                                                           data = null;
                                                       } 

                       }
                       else // ReduceAmortizationForCurtailments = N or Null
                       {
                           //decimal amort_Amount = 0;

                           //var _endingBalnce = lstNoteEndingBalance.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID && a.UseRuletoDetermineAmortizationText == "Y")).ToList().Sum(x => x.EndingBalance);

                           //Remove all non include Notes
                           lstNoteEndingBalance.RemoveAll(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID && a.UseRuletoDetermineAmortizationText != "Y"));

                           if (lstNoteEndingBalance.ToList().Sum(x => x.EndingBalance) > 0)
                           {
                               //assign Ending balance as of date
                               foreach (DataRow dr in data.Rows)
                               {
                                   dr["Amount"] = 0;
                                   dr["Amount"] = lstNoteEndingBalance.Where(b => b.Date == Convert.ToDateTime(dr["date"])).ToList().Sum(x => x.EndingBalance) / max_AmortTerm;
                                   dr.AcceptChanges();
                               }

                               CalculateRatio();
                               GenerateAmort(data);

                           }
                           else
                           {
                               data = null;
                           }

                           //var _endingBalnce = lstNoteEndingBalance.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID && a.UseRuletoDetermineAmortizationText == "Y")).ToList();
                           //   amort_Amount = (Math.Round(Convert.ToDecimal(_endingBalnce), 2));

                           //if (dealDC.amort.PeriodicStraightLineAmortOverride > 0)
                           //{
                           //    amort_Amount = (decimal)dealDC.amort.PeriodicStraightLineAmortOverride;
                           //}
                           //else
                           //{

                           // var _endingBalnce = lstNoteEndingBalance.Where(b => dealDC.amort.NoteListForDealAmort.Any(a => a.NoteId == b.NoteID && a.UseRuletoDetermineAmortizationText == "Y")).ToList().Sum(x => x.EndingBalance);
                           // amort_Amount = (Math.Round(Convert.ToDecimal(_endingBalnce), 2));
                           //}


                           //if (amort_Amount > 0)
                           //{

                           //    decimal _assignAmount = Math.Round(amort_Amount / data.Rows.Count, 2);
                           //    decimal _allocateAmount = 0;
                           //    foreach (DataRow dr in data.Rows)
                           //    {
                           //        dr["Amount"] = _assignAmount;
                           //        _allocateAmount += _assignAmount;

                           //        //code for manage panney difference in funding amount and assign in last date
                           //        if (data.Rows.IndexOf(dr) == data.Rows.Count - 1)
                           //        {
                           //            if (_allocateAmount < amort_Amount)
                           //            {
                           //                dr["Amount"] = _assignAmount + (amort_Amount - _allocateAmount);
                           //            }
                           //        }
                           //    }

                           //    CalculateRatio();
                           //    GenerateAmort(data);
                           //}
                           //else
                           //{
                           //    data = null;
                           //}

                       }*/

                    }
                    else if (dealDC.amort.AmortizationMethodText.ToLower() == "Fixed Payment Amortization".ToLower())
                    {
                        DataTable dtInterp = new DataTable();
                        DataTable dtnew = new DataTable();
                        //  DateTime Amt_StartDate, Amt_EndDate;

                        if (dealDC.amort.FixedPeriodicPayment != 0 && dealDC.amort.FixedPeriodicPayment != null)
                        {

                            dtInterp = data.Copy();
                            foreach (DataRow dr in data.Rows)
                            {
                                dr["Amount"] = dealDC.amort.FixedPeriodicPayment;
                            }

                            //==ManageFundingAmountByCurtelment(data);
                          //  CalculateRatio();
                          GenerateAmort(data, lstNoteEndingBalance);
                            int row = 0;
                            //Subtract interest paid amount from distributed amount
                            foreach (DataRow dr in data.Rows)
                            {
                                if (Convert.ToDateTime(dr["Date"]).Month == Convert.ToDateTime(dtInterp.Rows[row]["Date"]).Month && Convert.ToDateTime(dr["Date"]).Year == Convert.ToDateTime(dtInterp.Rows[row]["Date"]).Year)
                                {
                                    decimal TotAmount = 0;
                                    for (var col = 3; col < data.Columns.Count; col++)
                                    {
                                        data.Rows[row][col] = Convert.ToDecimal(data.Rows[row][col]) - Convert.ToDecimal(dtInterp.Rows[row][col]);
                                        TotAmount += Convert.ToDecimal(data.Rows[row][col]);
                                    }
                                    dr["Amount"] = TotAmount;
                                }
                                row++;
                            }
                        }
                        else
                        {
                            int row = 0;
                            foreach (DataRow dr in data.Rows)
                            {
                                int cl = 3;
                                decimal TotAmount = 0;
                                var lstnote = dealDC.amort.NoteListForDealAmort.FindAll(x => x.UseRuletoDetermineAmortizationText == "Y" || x.UseRuletoDetermineAmortizationText == "3");
                                for (var col = 0; col < lstnote.Count; col++)
                                {
                                    data.Rows[row][cl] = lstnote[col].StraightLineAmortOverride; //Convert.ToDecimal(data.Rows[row][col]);
                                    TotAmount += Convert.ToDecimal(lstnote[col].StraightLineAmortOverride);
                                    cl++;
                                }
                                dr["Amount"] = TotAmount;

                                row++;
                            }


                        }

                    }


                    else if (dealDC.amort.AmortizationMethodText.ToLower() == "Full Amortization by Rate & Term".ToLower())
                    {
                        List<PayruleDealFundingDataContract> lstPayruleDealFundingDataContract = new List<PayruleDealFundingDataContract>();


                        lstPayruleDealFundingDataContract = dealDC.PayruleDealFundingList.Where(x => x.Value < 0).ToList();


                        if (lstPayruleDealFundingDataContract.Count() > 0)
                        {
                            double _amount = 0.0;
                            lstPayruleDealFundingDataContract.ToList().ForEach(s =>
                            {
                                s.Value1 = s.Value + _amount.ToDecimal();
                                _amount = (double)s.Value1;
                            });

                            foreach (DataRow dr in data.Rows)
                            {
                                //dr["Date"]
                                var lst = lstPayruleDealFundingDataContract.ToList().Where(x => x.Date.ToDateTime() <= dr["Date"].ToDateTime()).ToList().OrderByDescending(d => d.Date).FirstOrDefault();
                                if ((Amort_EndDate - Convert.ToDateTime(dr["Date"])).TotalDays == 0)
                                {
                                    dr["Amount"] = 0;
                                }
                                else
                                {
                                    dr["Amount"] = lst == null ? 0 : Math.Round((decimal)(((lst.Value1 * -1) * 30) / (decimal)((Amort_EndDate - Convert.ToDateTime(dr["Date"])).TotalDays)), 2);
                                }
                            }

                            //CalculateRatio();
                            GenerateAmort(data, lstNoteEndingBalance);
                        }
                        else
                        {
                            data = null;
                        }
                    }
                    //
                    else if (dealDC.amort.AmortizationMethodText.ToLower() == "Custom Deal Amortization".ToLower())
                    {
                        if (data.Rows.Count > 0)
                        {
                            //CalculateRatio();
                            GenerateAmort(data, lstNoteEndingBalance);
                        }
                    }
                    #endregion

                    //Generate Amort schedule data
                    //if (dealDC.amort.AmortizationMethodText.ToLower() == "Straight Line Amortization".ToLower() || dealDC.amort.AmortizationMethodText.ToLower() == "Full Amortization by Rate & Term".ToLower())
                    //{ 

                    //}


                    //if (dealDC.amort.AmortizationMethodText.ToLower() == "Fixed Payment Amortization".ToLower())
                    //{
                    //    double FixedPeriodicPayment = Convert.ToDouble(dealDC.amort.FixedPeriodicPayment);
                    //    int colIndex = 10;
                    //    if (data != null)
                    //    {
                    //        foreach (DataRow dr in data.Rows)
                    //        {
                    //            double sumNote = 0.0;
                    //            foreach (DataColumn dcol in data.Columns)
                    //            {
                    //                if (dcol.ColumnName == "Amount")
                    //                    colIndex = dcol.Ordinal;
                    //                if (dcol.Ordinal > colIndex) // after Amount column
                    //                {
                    //                    double _amount = 0.0;
                    //                    _amount = dr[dcol] == DBNull.Value ? 0.0 : Convert.ToDouble(dr[dcol]);
                    //                    sumNote += Convert.ToDouble(_amount);
                    //                }

                    //            }
                    //            dr["Amount"] = FixedPeriodicPayment - sumNote;

                    //        }

                    //    }
                    //}




                    //// method for "Straight Line Amortization"
                    //else if (dc.amort.AmortizationMethodText.ToLower() == "Straight Line Amortization".ToLower())
                    //{
                    //    double _amount = 0.0;

                    //    dc.PayruleDealFundingList.ToList().Where(x => x.PurposeText == "Amortization").to.ForEach(s =>
                    //    {
                    //        s.Value1 = s.Value + _amount.ToDecimal();
                    //        _amount = (double)s.Value1;
                    //    });                    

                    //    foreach (DataRow dr in data.Rows)
                    //    {
                    //        //dr["Date"]
                    //        var lst = dc.PayruleDealFundingList.ToList().Where(x => x.Date.ToDateTime() <= dr["Date"].ToDateTime()).ToList().OrderByDescending(d => d.Date).FirstOrDefault();
                    //        dr["Amount"] = lst.Value1;
                    //    }
                    //}


                    //if (dc.amort.AmortizationMethodText == "Fixed Payment Amortization" || dc.amort.AmortizationMethod == 619) {
                    //    //if (data.Rows.Count >0)
                    //    //{
                    //    //    DataRow[] result = data.Select("Date => #" + Amort_StartDate + "#");

                    //    //}

                    //    }
                }

            }


            catch (Exception ex)
            {
                AmortDC.DealAmortGenerationExceptionMessage = "Funding schedule generation failed - " + System.Environment.NewLine + "" + ex.Message;
            }


            return data;
        }

        public void ManageFundingAmountByCurtelment(DataTable data)
        {
            try
            {
                if (Convert.ToString(dealDC.amort.ReduceAmortizationForCurtailments) == "571") // ReduceAmortizationForCurtailments = Y
                {
                    foreach (DataRow dr in data.Rows)
                    { //sam
                        // Curtelment - 315 : Property Release || 631 : Paydown || 630	:	Full Payoff
                        decimal curtelmentAmount = Convert.ToDecimal(dealDC.PayruleDealFundingList.Where(x => (x.PurposeID == 315 || x.PurposeID == 631 || x.PurposeID == 630) & x.orgDate == Convert.ToDateTime(dr["DateWithoutAdjustment"])).Sum(y => y.orgValue));
                        dr["Amount"] = Convert.ToDecimal(dr["Amount"]) - curtelmentAmount;
                    }
                }
            }
            catch (Exception ex)
            {
                AmortDC.DealAmortGenerationExceptionMessage = "Funding schedule generation failed - " + System.Environment.NewLine + "" + ex.Message;
            }
        }


        public DateTime FirstDayOfMonth(DateTime dt)
        {
            DateTime ss = new DateTime(dt.Year, dt.Month, 1);
            return ss;  //.AddMonths(1).AddDays(-1);
        }

        public DateTime LastDayOfMonth(DateTime dt)
        {
            DateTime ss = new DateTime(dt.Year, dt.Month, 1);
            return ss.AddMonths(1).AddDays(-1);
        }

        public DataTable ManageHolidayAdjustment(DataTable dt, DateTime EndDate, bool isBusinessDayAdjustment)
        {
            //  DataTable newdt = new DataTable();
            DateTime startdt = Convert.ToDateTime(dt.Rows[0]["Date"]);
            int lastrec = dt.Rows.Count - 1;
            int count = 0;
            DateTime Enddt = Convert.ToDateTime(dt.Rows[lastrec]["Date"]);
            if (isBusinessDayAdjustment == true)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["Amount"].ToString() != "")
                    {
                        dr["Amount"] = Math.Round(Convert.ToDecimal(dr["Amount"].ToString()), 2);
                    }
                    if (dr["Date"] != null)
                    {
                        dr["DateWithoutAdjustment"] = Convert.ToDateTime(dr["Date"]);
                    }
                    if (count == 1)
                    {
                        DateTime i = Convert.ToDateTime(dr["Date"]);
                        DateTime dtnxtdate = DateExtensions.CreateNewDate(i.Year, i.Month, i.Day);
                        DateTime dat = DateExtensions.GetWorkingDayUsingOffset(dtnxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
                        if (dat.Month == EndDate.Month && dat.Year == EndDate.Year)
                        {
                            DateTime ed = EndDate;
                            DateTime ednxtdate = DateExtensions.CreateNewDate(i.Year, i.Month, i.Day);
                            DateTime Enddat = DateExtensions.GetWorkingDayUsingOffset(ednxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                            dr["Date"] = Enddat;
                        }
                        else
                            dr["Date"] = dat;
                    }
                    else
                    {
                        count = 1;
                        DateTime std = Convert.ToDateTime(dr["Date"]);
                        DateTime sdnxtdate = DateExtensions.CreateNewDate(std.Year, std.Month, std.Day);
                        DateTime stdat = DateExtensions.GetWorkingDayUsingOffset(sdnxtdate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
                        dr["Date"] = stdat;

                    }
                }

            }
            else
            {
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["Amount"].ToString() != "")
                    {
                        dr["Amount"] = Math.Round(Convert.ToDecimal(dr["Amount"].ToString()), 2);
                    }

                    if (startdt.Month == EndDate.Month && startdt.Year == EndDate.Year)
                    {
                        dr["Date"] = EndDate;
                        dr["DateWithoutAdjustment"] = EndDate;
                    }
                    else
                    {
                        dr["Date"] = startdt;
                        dr["DateWithoutAdjustment"] = startdt;
                    }

                    startdt = startdt.AddMonths(1);

                }
            }
            return dt;
        }

    }

    //private static List<T> ConvertDataTable<T>(DataTable dt)
    //{
    //    List<T> data = new List<T>();
    //    foreach (DataRow row in dt.Rows)
    //    {
    //        T item = GetItem<T>(row);
    //        data.Add(item);
    //    }
    //    return data;
    //}
    //private static T GetItem<T>(DataRow dr)
    //{
    //    Type temp = typeof(T);
    //    T obj = Activator.CreateInstance<T>();

    //    foreach (DataColumn column in dr.Table.Columns)
    //    {
    //        foreach (PropertyInfo pro in temp.GetProperties())
    //        {
    //            if (pro.Name == column.ColumnName)
    //                pro.SetValue(obj, dr[column.ColumnName], null);
    //            else
    //                continue;
    //        }
    //    }
    //    return obj;
    //}

}
