using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class ValidationEngine
    {
        private bool res;
        private List<ExceptionDataContract> exceptionList = new List<ExceptionDataContract>();

        public List<ExceptionDataContract> ValidateNoteObject(NoteDataContract noteobject)
        {
            try
            {
                //validate  Closing Date msg
                string Summary = DateExtensions.ValidateCalculatorDates(noteobject.ClosingDate, "Closing Date", noteobject.ClosingDate);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Closing Date", noteobject.NoteId.ToString(), "Critical");
                }
                //Check Pay Frequency
                res = NumericExtension.CheckNullOrEmpty<int>(Convert.ToInt32(noteobject.PayFrequency));
                if (res == true)
                {
                    AssignToExceptionsList("Must be greater or equals to 1", "Pay Frequency", noteobject.NoteId.ToString(), "Critical");
                }
                //Initial Interest Accrual End Date
                Summary = DateExtensions.ValidateCalculatorDates(noteobject.InitialInterestAccrualEndDate, "Initial Interest Accrual End Date", noteobject.ClosingDate);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Initial Interest Accrual End Date", noteobject.NoteId.ToString(), "Critical");
                }

                //Accrual Freq
                res = NumericExtension.CheckNullOrEmpty<int>(Convert.ToInt32(noteobject.AccrualFrequency));
                if (res == true)
                {
                    AssignToExceptionsList("Must be greater or equals to 1", "Accrual Frequency", noteobject.NoteId.ToString(), "Critical");
                }

                //Rate Index Reset Freq
                Summary = ValidateRateIndexResetFreq(noteobject.RateIndexResetFreq);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Rate Index Reset Freq", noteobject.NoteId.ToString(), "Critical");
                }

                //Final Interest Accrual End Date Override
                Summary = DateExtensions.ValidateCalculatorDates(noteobject.FinalInterestAccrualEndDateOverride, "Final Interest Accrual End Date Override", noteobject.ClosingDate);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Final Interest Accrual End Date Override", noteobject.NoteId.ToString(), "Critical");
                }
                //First PMT Date
                Summary = DateExtensions.ValidateCalculatorDates(noteobject.FirstPaymentDate, "First Payment Date", noteobject.ClosingDate);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "First Payment Date", noteobject.NoteId.ToString(), "Critical");
                }
                //Initial Funding Amount
                res = NumericExtension.CheckNullOrEmpty<decimal>(Convert.ToDecimal(noteobject.InitialFundingAmount));
                if (res == true)
                {
                    AssignToExceptionsList("The initial funding amount should be greater than 0", "Initial Funding Amount", noteobject.NoteId.ToString(), "Normal");
                }
                //Validate scenario list

                Summary = ValidateNoteMaturityScenarios(noteobject.MaturityScenariosList);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Maturity scenarios List", noteobject.NoteId.ToString(), "Critical");
                }
                //ValidatePrincipalAmortization
                Summary = ValidatePrincipalAmortization(noteobject);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Rate Spread Schedule", noteobject.NoteId.ToString(), "Critical");
                }

                //Initial funding amount or origination fee
                Summary = ValidateAmounts(noteobject);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Initial funding amount or origination fee", noteobject.NoteId.ToString(), "Critical");
                }
                //Total funding greater than fees
                Summary = ValidateInitialfunding(noteobject);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Total funding should be greater than fees", noteobject.NoteId.ToString(), "Normal");
                }
                ValidateNonBusinessDay(noteobject.FirstRateIndexResetDate, noteobject.NoteId, "First rate index reset");
                Summary = ValidateRateSpreadSchedule(noteobject, "CalcMethod");
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Rate Spread Schedule", noteobject.NoteId.ToString(), "Critical");
                }

                Summary = ValidatePikSchedule(noteobject);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "PIK Schedule", noteobject.NoteId.ToString(), "Critical");
                }
                Summary = ValidateMaturityScenarios(noteobject.lstMaturity);
                if (Summary != "")
                {
                    AssignToExceptionsList(Summary, "Maturity scenarios List", noteobject.NoteId.ToString(), "Critical");
                }

                //ValidateNonBusinessDay(noteobject.ExpectedMaturityDate, noteobject.NoteId, "Expected maturity date");
                //ValidateNonBusinessDay(noteobject.ExtendedMaturityScenario1, noteobject.NoteId, "Extended Maturity Scenario 1");
                // ValidateNonBusinessDay(noteobject.ExtendedMaturityScenario2, noteobject.NoteId, "Extended Maturity Scenario 2");
                // ValidateNonBusinessDay(noteobject.ExtendedMaturityScenario3, noteobject.NoteId, "Extended Maturity Scenario 3");
                if (noteobject.ClosingDate != null)
                {
                    ValidatePaymentDate(noteobject);
                }
                return exceptionList;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public void AssignToExceptionsList(string exception, string name, string NoteID, string ActionLevel)
        {
            ExceptionDataContract edc = new ExceptionDataContract();
            edc.ObjectID = new Guid(NoteID);
            edc.ObjectTypeText = "Note";
            edc.FieldName = name;
            edc.Summary = exception;
            edc.ActionLevelText = ActionLevel;
            exceptionList.Add(edc);
        }

        public void ValidateNonBusinessDay(DateTime? date, string noteid, string validationfordate)
        {
            if (date != null)
            {
                res = DateExtensions.CheckForBusinessDay(Convert.ToDateTime(date));
                if (res == false)
                {
                    AssignToExceptionsList(validationfordate + " cannot be on a non-business day.", validationfordate, noteid, "Normal");
                }
            }
        }
        public string ValidateNoteMaturityScenarios(List<MaturityScenariosDataContract> list)
        {
            string msg = "";

            if (list != null && list.Count > 0)
            {
                if (list.Count == 1)
                {
                    if (list[0].EffectiveDate == null || list[0].Date == null)
                    {
                        msg = "Maturity scenario cannot be empty";
                    }
                }
                else
                {
                    foreach (var item in list)
                    {
                        if (item.MaturityID == 708 && item.Date == null)
                        {
                            msg = "initial Maturity Date cannot be empty";
                        }

                    }


                }
            }
            else
            {
                msg = "Maturity scenario cannot be empty";
            }

            return msg;
        }
        public string ValidateAmounts(NoteDataContract noteobject)
        {
            string msg = "";

            decimal a = noteobject.InitialFundingAmount.GetValueOrDefault(0) + noteobject.OriginationFee.GetValueOrDefault(0);

            if (a == 0)
            {
                msg = "Either initial funding amount or origination fee should be non-zero values";
            }

            return msg;
        }
        public string ValidateInitialfunding(NoteDataContract noteobject)
        {
            string msg = "";

            decimal sumtotalfunding;
            decimal? fundingamount = 0;
            if (noteobject.ListFutureFundingScheduleTab != null)
            {
                if (noteobject.ListFutureFundingScheduleTab.Count > 0)
                {
                    fundingamount = noteobject.ListFutureFundingScheduleTab.FindAll(x => x.Value > 0).Sum(y => y.Value);
                }
            }
            sumtotalfunding = fundingamount.GetValueOrDefault(0) + noteobject.InitialFundingAmount.GetValueOrDefault(0);

            if (sumtotalfunding < noteobject.OriginationFee.GetValueOrDefault(0))
            {
                msg = "Total funding should be greater than origination fees";
            }

            return msg;
        }
        public string ValidateRateSpreadSchedule(NoteDataContract noteobject, string validatcol)
        {
            string msg = "";
            bool nullcalcmethod = false;

            List<RateSpreadSchedule> listrate = new List<RateSpreadSchedule>();
            if (noteobject.RateSpreadScheduleList.Count > 0)
            {
                if (validatcol == "Spread")
                {
                    listrate = noteobject.RateSpreadScheduleList.FindAll(x => (x.ValueTypeText == "Spread" || x.ValueTypeID == 151) && x.Value > 0).ToList();
                }
                if (validatcol == "CalcMethod")
                {
                    foreach (var item in noteobject.RateSpreadScheduleList)
                    {
                        if (item.ValueTypeID != 778)
                        {
                            if (item.IntCalcMethodID == null)
                            {
                                nullcalcmethod = true;
                                break;
                            }
                        }
                    }
                }

            }
            if (validatcol == "Spread")
            {
                if (listrate.Count == 0)
                {
                    msg = "Note should have atleast one value for Spread in the Rate Spread Schedule";
                }
            }
            if (validatcol == "CalcMethod")
            {
                if (nullcalcmethod == true)
                {
                    msg = "Note should have atleast one value for Calc Method in the Rate Spread Schedule";
                }
            }

            return msg;
        }

        public string ValidatePikSchedule(NoteDataContract noteobject)
        {
            string msg = "";
            bool intcalcnotfound = false;
            List<RateSpreadSchedule> listrate = new List<RateSpreadSchedule>();

            if (noteobject.NotePIKScheduleList != null)
            {
                if (noteobject.NotePIKScheduleList.Count > 0)
                {
                    foreach (var item in noteobject.NotePIKScheduleList)
                    {
                        if (item.PIKIntCalcMethodID == null)
                        {
                            intcalcnotfound = true;
                            break;
                        }
                    }
                }
                if (intcalcnotfound == true)
                {
                    msg = "Note should have value for PIK Interest Calc method in PIK schedule.";
                }

            }


            return msg;
        }
        public string ValidateRateIndexResetFreq(decimal? amt)
        {
            string msg = "";

            if (amt == 0)
            {
                msg = "Must be greater than 0.";
            }
            return msg;
        }

        public void ValidatePaymentDate(NoteDataContract noteobject)
        {
            string msg = "";
            msg = "Payment date shouldn't be smaller than closing date";
            List<RateSpreadSchedule> listrate = new List<RateSpreadSchedule>();
            List<PrepayAndAdditionalFeeScheduleDataContract> listprepay = new List<PrepayAndAdditionalFeeScheduleDataContract>();
            List<StrippingScheduleDataContract> liststripping = new List<StrippingScheduleDataContract>();
            List<FinancingFeeScheduleDataContract> listfinancingfee = new List<FinancingFeeScheduleDataContract>();
            List<FinancingScheduleDataContract> listfinancing = new List<FinancingScheduleDataContract>();
            List<DefaultScheduleDataContract> listdefault = new List<DefaultScheduleDataContract>();
            List<FutureFundingScheduleTab> listfundingschedule = new List<FutureFundingScheduleTab>();
            List<FixedAmortScheduleTab> listamort = new List<FixedAmortScheduleTab>();

            //Rate spread schedule
            if (noteobject.RateSpreadScheduleList != null && noteobject.RateSpreadScheduleList.Count > 0)
            {


                listrate = noteobject.RateSpreadScheduleList.FindAll(x => x.Date.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listrate.Count != 0)
            {
                AssignToExceptionsList(msg, "Rate Spread Schedule", noteobject.NoteId.ToString(), "Critical");
            }
            //Prepay and additional fee schedule
            if (noteobject.NotePrepayAndAdditionalFeeScheduleList != null && noteobject.NotePrepayAndAdditionalFeeScheduleList.Count > 0)
            {
                listprepay = noteobject.NotePrepayAndAdditionalFeeScheduleList.FindAll(x => x.StartDate.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listprepay.Count != 0)
            {
                AssignToExceptionsList(msg, "Prepay and Additional Fee Schedule", noteobject.NoteId.ToString(), "Critical");
            }
            ////Stripping
            //if (noteobject.NoteStrippingList != null && noteobject.NoteStrippingList.Count > 0)
            //{
            //    liststripping = noteobject.NoteStrippingList.FindAll(x => x.StartDate.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            //}
            //if (liststripping.Count != 0)
            //{
            //    AssignToExceptionsList(msg, "Stripping", noteobject.NoteId.ToString(), "Critical");
            //}

            //Financing fee schedule
            if (noteobject.ListFinancingFeeSchedule != null && noteobject.ListFinancingFeeSchedule.Count > 0)
            {
                listfinancingfee = noteobject.ListFinancingFeeSchedule.FindAll(x => x.Date.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listfinancingfee.Count != 0)
            {
                AssignToExceptionsList(msg, "Financing Fee Schedule", noteobject.NoteId.ToString(), "Critical");
            }

            //Financing Schedule
            if (noteobject.NoteFinancingScheduleList != null && noteobject.NoteFinancingScheduleList.Count > 0)
            {
                listfinancing = noteobject.NoteFinancingScheduleList.FindAll(x => x.Date.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listfinancing.Count != 0)
            {
                AssignToExceptionsList(msg, "Financing Schedule", noteobject.NoteId.ToString(), "Critical");
            }

            //Default schedule
            if (noteobject.NoteDefaultScheduleList != null && noteobject.NoteDefaultScheduleList.Count > 0)
            {
                listdefault = noteobject.NoteDefaultScheduleList.FindAll(x => x.StartDate.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listdefault.Count != 0)
            {
                AssignToExceptionsList(msg, "Default Schedule", noteobject.NoteId.ToString(), "Critical");
            }
            //Funding schedule
            if (noteobject.ListFutureFundingScheduleTab != null && noteobject.ListFutureFundingScheduleTab.Count > 0)
            {
                listfundingschedule = noteobject.ListFutureFundingScheduleTab.FindAll(x => x.Date.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listfundingschedule.Count != 0)
            {
                AssignToExceptionsList(msg, "Funding Schedule", noteobject.NoteId.ToString(), "Critical");
            }
            //Amort schedule 
            if (noteobject.ListFixedAmortScheduleTab != null && noteobject.ListFixedAmortScheduleTab.Count > 0)
            {
                listamort = noteobject.ListFixedAmortScheduleTab.FindAll(x => x.Date.Value.Date < noteobject.ClosingDate.Value.Date).ToList();
            }
            if (listamort.Count != 0)
            {
                AssignToExceptionsList(msg, "Amort Schedule", noteobject.NoteId.ToString(), "Critical");
            }

        }

        //validation principal amortization
        public string ValidatePrincipalAmortization(NoteDataContract noteobject)
        {
            string msg = "";
            int daysdiff = 0;
            if (noteobject.FixedAmortSchedule != 3)
            {
                DateTime closing = DateTime.Now;
                if (noteobject.ClosingDate != null)
                {
                    closing = noteobject.ClosingDate.Value.Date;
                }
                DateTime selectedmat = DateTime.MinValue;
                if (noteobject.MaturityScenariosList != null)
                {
                    if (noteobject.MaturityScenariosList.Count > 0)
                    {
                        int max = noteobject.MaturityScenariosList.Count - 1;
                        if (noteobject.MaturityScenariosList[max].Date != null)
                        {
                            selectedmat = noteobject.MaturityScenariosList[max].Date.Value.Date;
                        }
                    }
                }
                daysdiff = DateExtensions.YearMonthDiff(closing, selectedmat);
                // daysdiff = Convert.ToInt16(selectedmat.Subtract(closing).Days / (365.25 / 12));

                if (daysdiff > noteobject.IOTerm.GetValueOrDefault() && noteobject.MonthlyDSOverridewhenAmortizing == null)
                {
                    msg = "This loan is assumed to have principal amortization based on amortization term specified, however Rate and Spread Schedule is missing value for interest rate for amortization. Please populate the schedule with either value type 'Amort Rate' or 'Amort Spread'";
                    if (noteobject.RateSpreadScheduleList.Count > 0)
                    {
                        foreach (RateSpreadSchedule rss in noteobject.RateSpreadScheduleList)
                        {
                            if (rss.ValueTypeText == "Amort Rate" || rss.ValueTypeText == "Amort Spread")
                            {
                                msg = "";
                            }
                        }
                    }
                }
            }


            return msg;
        }

        public string ValidatePikBalance(Decimal? sumacutal, Decimal? sumCashFlow)
        {
            string validationstring = "";
            if (sumacutal.GetValueOrDefault(0) > sumCashFlow.GetValueOrDefault(0))
            {
                if ((sumacutal.GetValueOrDefault(0) - sumCashFlow.GetValueOrDefault(0)) > 1)
                {
                    validationstring = "PIKPrincipalPaid transaction amount cannot be more than PIK Balance.";
                }
            }
            return validationstring;
        }

        public string ValidateInitialMaturityDate(DateTime? InitialMaturityDate)
        {
            string msg = "";

            if (InitialMaturityDate == DateTime.MinValue || InitialMaturityDate == null)
            {
                msg = "Initial maturity date cannot be null.";
            }

            return msg;
        }

        public string ValidateMaturityScenarios(List<MaturityScenariosDataContract> list)
        {
            string msg = "";

            if (list != null && list.Count > 0)
            {
                List<MaturityScenariosDataContract> listmat = new List<MaturityScenariosDataContract>();

                listmat = list.FindAll(x => x.MaturityID == 708 && x.Date == null).ToList();
                if (listmat.Count > 0)
                {
                    msg = "Initial Maturity Date cannot be empty";
                }
                listmat = list.FindAll(x => x.MaturityID == 708).ToList();
                if (listmat.Count == 0)
                {
                    msg = "Initial Maturity Date cannot be empty";
                }


            }
            else
            {
                msg = "Maturity scenario cannot be empty";
            }

            return msg;
        }
    }
}