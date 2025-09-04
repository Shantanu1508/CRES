using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.NoteCalculator;
using CRES.Utilities;
using System.Data;
using Microsoft.AspNetCore.Hosting;
using System.Reflection;
using Newtonsoft.Json;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class GenerateAutomationController : ControllerBase
    {
        private readonly IEmailNotification _iEmailNotification;
        private IHostingEnvironment _env;
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";

        public GenerateAutomationController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }
        public void GenerateFundingAndSaveDataToDatabase(string DealID, int? AutomationRequestsID, int? BatchID, string username, string AutomationType, int BatchTypeID)
        {
            GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
            LoggerLogic Log = new LoggerLogic();
            List<ProjectedPayoffDataContract> ListProjectedPayoff = new List<ProjectedPayoffDataContract>();
            try
            {
                List<AutomationExtensionDataContract> messagelist = new List<AutomationExtensionDataContract>();
                List<IDValueDataContract> ListScheduledPrincipalPaid = new List<IDValueDataContract>();
                string AnalysisID = "c10f3372-0fc2-4861-a9f5-148f1f80804f";

                bool runautospreading = false;
                bool ShowUseRuleN = true;
                bool norecordfound = false;
                bool usePayOffasmaturity = false;

                string validationstring = "";
                string wireconfirmvalidation = "";
                DealLogic dealLogic = new DealLogic();
                NoteLogic nl = new NoteLogic();

                DateTime startdate = DateTime.MinValue;
                DateTime Enddate = DateTime.MinValue;

                DealDataContract dc = new DealDataContract();
                DealDataContract deal = new DealDataContract();

                PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();
                List<NoteUsedInDealDataContract> notelist = new List<NoteUsedInDealDataContract>();
                Decimal endingbalance = 0;
                decimal? sumofFundingseq = 0;
                decimal? sumDealFunding = 0;
                Guid headerUserID = new Guid(username);
                string UserIDString = username;
                int? TotalCount;

                NoteLogic _NoteLogic = new NoteLogic();
                List<HolidayListDataContract> ListHoliday = _NoteLogic.GetHolidayList();
                dc = dealLogic.GetDealByDealId(DealID, headerUserID);

                dc.PayruleDealFundingList = dealLogic.GetDealFundingScheduleByDealID(new Guid(DealID.ToString()));
                if (dc.PayruleDealFundingList.Count == 0)
                {
                    if (dc.EnableAutoSpread != true && dc.EnableAutospreadRepayments != true)
                    {
                        norecordfound = true;
                    }
                }

                if (norecordfound == false)
                {
                    dc.PayruleNoteDetailFundingList = nl.GetNotesForPayruleCalculationByDealID(DealID, headerUserID, 1, 1000, out TotalCount).OrderByDescending(x => x.NoteID).ToList();
                    dc.PayruleNoteAMSequenceList = dealLogic.GetFundingRepaymentSequenceByDealID(new Guid(DealID)).OrderByDescending(x => x.NoteID).ToList();
                    dc.PayruleNoteAMSequenceList = dc.PayruleNoteAMSequenceList.OrderBy(x => x.SequenceNo).ToList();
                    dc.PayruleTargetNoteFundingScheduleList = dealLogic.GetNoteFundingbyDealID(new Guid(DealID.ToString()));
                    ListScheduledPrincipalPaid = dealLogic.GetScheduledPrincipalByDealID(headerUserID, DealID.ToString());

                    dc.ListHoliday = ListHoliday;
                    dc.FirstPaymentDate = dc.FirstPaymentDate;

                    notelist = nl.GetNotesFromDealDetailByDealID(DealID, headerUserID, 1000, 1, out TotalCount);
                    dc.maxMaturityDate = notelist.Max(x => x.FullyExtendedMaturityDate);

                    DateTime? InitialMaturityDate = CommonHelper.ToDateTimeWithMinValue(notelist.Max(x => x.InitialMaturityDate));
                    DateTime? ExtendedMaturityCurrent = CommonHelper.ToDateTimeWithMinValue(notelist.Max(x => x.ExtendedMaturityCurrent));
                    DateTime? ActualPayoffDate = CommonHelper.ToDateTimeWithMinValue(notelist.Max(x => x.ActualPayoffDate));

                    List<NoteUsedInDealDataContract> notelisat = notelist.FindAll(x => x.ActualPayoffDate == null);


                    if (notelisat != null)
                    {
                        if (notelisat.Count == 0)
                        {
                            usePayOffasmaturity = true;
                        }
                    }

                    if (usePayOffasmaturity == false)
                    {
                        ActualPayoffDate = DateTime.MinValue;
                    }
                    DateTime? minclosingdate = CommonHelper.ToDateTimeWithMinValue(notelist.Min(x => x.ClosingDate));
                    DateTime currentmaturity = DateExtensions.GetDealFundingCurrentMaturity(ActualPayoffDate.Value, InitialMaturityDate.Value, ExtendedMaturityCurrent.Value, dc.maxMaturityDate.Value, ListHoliday);

                    // Get 
                    DateTime maxwireconfirmDate = DateTime.MinValue;
                    foreach (var item in dc.PayruleDealFundingList)
                    {
                        if (item.Applied == true)
                        {
                            if (item.Date.Value.Date > maxwireconfirmDate)
                            {
                                maxwireconfirmDate = item.Date.Value.Date;
                            }
                        }
                    }
                    if (AutomationType == "AmortizationAutoWire")
                    {
                        DateTime todaysdate = DateTime.Now.Date;
                        foreach (var item in dc.PayruleDealFundingList)
                        {
                            if (item.Applied != true && item.PurposeID != 631)
                            {
                                if (item.Date < todaysdate)
                                {
                                    string msg = "There are non-wire confirmed records before " + todaysdate.Date.ToString("MM/dd/yyyy") + " Please open the deal and wire confirm the records. ";

                                    AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                    aes.Message = msg;
                                    aes.DealFundingID = null;
                                    messagelist.Add(aes);
                                    wireconfirmvalidation = "hasvalidation";
                                    break;
                                }
                            }
                        }
                        if (wireconfirmvalidation == "")
                        {
                            foreach (var item in dc.PayruleDealFundingList)
                            {
                                if (item.PurposeID == 351)
                                {
                                    if (item.Applied != true)
                                    {
                                        if (item.Date == todaysdate)
                                        {
                                            item.Applied = true;
                                            item.Comment = "Auto wire confirmed by the system";
                                            item.GeneratedBy = 747;

                                            AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                            aes.Message = item.Date.Value.ToString("MM/dd/yyyy") + " auto wire confirmed by the system.";
                                            aes.DealFundingID = item.DealFundingID.ToString();
                                            aes.Date = item.Date;
                                            aes.Amount = item.Value;
                                            aes.PurposeType = item.PurposeText;
                                            messagelist.Add(aes);

                                            foreach (var note in dc.PayruleTargetNoteFundingScheduleList)
                                            {
                                                if (note.DealFundingRowno == item.DealFundingRowno)
                                                {
                                                    note.Applied = true;
                                                    note.Comments = "Auto wire confirmed by the system";
                                                    note.GeneratedBy = 747;
                                                }
                                            }
                                        }

                                    }
                                }
                            }
                        }

                    }
                    if (dc.EnableAutoSpread == true)
                    {
                        dc.AutoSpreadRuleList = dealLogic.GetAutoSpreadRuleByDealID(headerUserID, new Guid(dc.DealID.ToString()));

                        foreach (var item in dc.AutoSpreadRuleList)
                        {
                            if (item.EndDate.Value.Date > currentmaturity.Date)
                            {
                                //End Date 10/07/2022 for Purpose type Force Funding should be less than or equal to current maturity date 11/16/2021 for Auto Spread.
                                string msg = "End Date " + item.EndDate.Value.Date.ToString("MM/dd/yyyy") + " for Purpose type " + item.PurposeTypeText + " should be less than or equal to current maturity date  " + currentmaturity.Date.ToString("MM/dd/yyyy") + " for Auto Spread. ";

                                AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                aes.Message = msg;
                                aes.DealFundingID = null;
                                messagelist.Add(aes);
                                validationstring = "hasvalidation";
                            }

                            if (item.StartDate.Value.Date < minclosingdate.Value.Date)
                            {
                                string msg = "Start Date " + item.StartDate.Value.Date.ToString("MM/dd/yyyy") + " for Purpose type " + item.PurposeTypeText + " should be greater than or equal to Closing Date " + minclosingdate.Value.Date.ToString("MM/dd/yyyy") + " for Auto Spread. ";

                                AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                aes.Message = msg;
                                aes.DealFundingID = null;
                                messagelist.Add(aes);
                                validationstring = "hasvalidation";
                            }
                            //commented validation for per iris request
                            //if (item.EndDate.Value.Date < maxwireconfirmDate)
                            //{
                            //    string msg = "End Date " + item.EndDate.Value.Date.ToString("MM/dd/yyyy") + " should be greater than or equal to Max Wired Confirmed Date " + maxwireconfirmDate.Date.ToString("MM/dd/yyyy") + " for Auto Spread. ";

                            //    AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                            //    aes.Message = msg;
                            //    aes.DealFundingID = null;
                            //    messagelist.Add(aes);
                            //    validationstring = "hasvalidation";
                            //}
                        }
                    }
                    foreach (PayruleNoteAMSequenceDataContract pdc in dc.PayruleNoteAMSequenceList)
                    {
                        //Funding Sequence
                        if (pdc.SequenceTypeText == "Funding sequence")
                        {
                            sumofFundingseq = sumofFundingseq + pdc.Value;
                            pdc.SequenceTypeText = "Funding Sequence";
                        }
                        if (pdc.SequenceTypeText == "Repayment sequence")
                        {
                            pdc.SequenceTypeText = "Repayment Sequence";
                        }
                    }

                    foreach (var pnd in dc.PayruleNoteDetailFundingList)
                    {
                        if (pnd.UseRuletoDetermineNoteFunding == 3)
                        {
                            ShowUseRuleN = false;
                            break;
                        }
                    }
                    DateTime maxDate = DateTime.MinValue;
                    if (ShowUseRuleN == true)
                    {
                        if (dc.EnableAutospreadRepayments == true)
                        {
                            dc.EnableAutospreadUseRuleN = true;
                        }
                    }
                    else
                    {
                        dc.EnableAutospreadUseRuleN = false;
                    }
                    // code required only autospread repayment 
                    if (dc.EnableAutospreadRepayments == true || dc.EnableAutospreadUseRuleN == true)
                    {

                        //to do bring data from  backshop

                        if (dc.AutoUpdateFromUnderwriting == true)
                        {
                            ListProjectedPayoff = dealLogic.GetProjectedPayOffDateByDealID(username, new Guid(DealID), dc.Statusid.Value);

                            if (ListProjectedPayoff.Count > 0)
                            {
                                dc.EarliestPossibleRepaymentDate = ListProjectedPayoff[0].EarliestDate;
                                dc.LatestPossibleRepaymentDate = ListProjectedPayoff[0].LatestDate;
                                dc.ExpectedFullRepaymentDate = ListProjectedPayoff[0].ExpectedDate;
                                dc.AutoPrepayEffectiveDate = ListProjectedPayoff[0].AuditUpdateDate;
                            }

                        }
                        // if no record found from backshop
                        if (ListProjectedPayoff == null || ListProjectedPayoff.Count == 0)
                        {
                            DataTable dt = dealLogic.GetProjectedPayOffDBDataByDealID(dc.DealID, UserIDString);
                            foreach (DataRow dr in dt.Rows)
                            {

                                ProjectedPayoffDataContract projectedpayoffdata = new ProjectedPayoffDataContract();
                                projectedpayoffdata.ProjectedPayoffAsofDate = CommonHelper.ToDateTime(dr["ProjectedPayoffAsofDate"]);
                                projectedpayoffdata.CumulativeProbability = CommonHelper.ToDecimal(dr["CumulativeProbability"]);
                                ListProjectedPayoff.Add(projectedpayoffdata);
                            }
                        }

                        dc.ListProjectedPayoff = ListProjectedPayoff;
                        dc.ListAutoRepaymentBalances = dealLogic.GetAutospreadRepaymentBalancesDealID(dc.DealID);
                        if (dc.ListAutoRepaymentBalances != null)
                        {
                            if (dc.ListAutoRepaymentBalances.Count > 0)
                            {
                                foreach (AutoRepaymentBalancesDataContract arb in dc.ListAutoRepaymentBalances)
                                {
                                    arb.Amount = Math.Round(arb.Amount.Value, 2);
                                }
                                dc.ListNoteRepaymentBalances = dealLogic.GetNoteAutospreadRepaymentBalancesByDealId(dc.DealID);
                            }
                        }
                        if (dc.ListNoteRepaymentBalances == null)
                        {
                            dc.ListNoteRepaymentBalances = new List<AutoRepaymentNoteBalancesDataContract>();
                        }
                        // get ending balance from database           
                        foreach (var funding in dc.PayruleDealFundingList)
                        {

                            if (funding.Applied == true)
                            {
                                if (funding.Date.Value.Date > maxDate)
                                {
                                    maxDate = funding.Date.Value.Date;
                                }
                            }
                            if (funding.Value > 0)
                            {
                                if (funding.AdjustmentType != 834 && funding.AdjustmentType != 835)
                                {
                                    if (funding.Applied == true)
                                    {
                                        sumDealFunding = sumDealFunding.Value + funding.Value.GetValueOrDefault(0);
                                    }
                                    else if (funding.Comment != null && funding.Comment != "")
                                    {
                                        sumDealFunding = sumDealFunding.Value + funding.Value.GetValueOrDefault(0);
                                    }
                                }

                            }
                        }

                        if (ShowUseRuleN != true)
                        {
                            if (sumDealFunding > sumofFundingseq)
                            {
                                string msg = "Total funding in Deal Schedule (" + string.Format("{0:C}", sumDealFunding) + ") cannot be greater than total of Funding Sequences (" + string.Format("{0:C}", sumofFundingseq) + ") included in funding rules.";

                                AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                aes.Message = msg;
                                aes.DealFundingID = null;
                                messagelist.Add(aes);
                                validationstring = "hasvalidation";
                            }
                        }
                        if (maxDate == DateTime.MinValue)
                        {
                            maxDate = DateTime.Now.Date;
                        }
                        if (maxDate != DateTime.MinValue)
                        {
                            dc.MaxWireConfirmRecord = maxDate;
                            dc.maxWiredDatecalculated = maxDate;
                            maxDate = maxDate.AddDays(-1);

                            if (dc.EnableAutospreadRepayments == true)
                            {
                                endingbalance = dealLogic.GetEndingBalanceByDate(dc.DealID, maxDate);
                            }

                            if (dc.EnableAutospreadUseRuleN == true || dc.ApplyNoteLevelPaydowns == true)
                            {
                                dc.ListNoteEndingBalance = dealLogic.GetNoteEndingBalaceByDate(dc.DealID, maxDate);
                            }
                            if (endingbalance == 0)
                            {
                                //Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "Auto Repayment phantom deal starting Balances is 0 ", dc.DealID.ToString(), headerUserID.ToString());
                            }
                            else
                            {
                                dc.Endingbalance = endingbalance;
                            }
                        }
                        else
                        {
                            dc.MaxWireConfirmRecord = Convert.ToDateTime(dc.EstClosingDate);
                            dc.maxWiredDatecalculated = Convert.ToDateTime(dc.EstClosingDate);
                        }
                        runautospreading = true;
                    }
                    // var json = JsonConvert.SerializeObject(dc);
                    if (validationstring == "")
                    {
                        if (runautospreading == true)
                        {
                            deal = pm.StartCalculation(dc);
                        }
                        else
                        {
                            // assging dc to deal as we have not run autospreading as  autospreading is not enabled 
                            deal = dc;
                        }

                        if (deal.PayruleGenerationExceptionMessage == "" || deal.PayruleGenerationExceptionMessage == null)
                        {
                            if (AutomationType == "FundingMoveToNextMonth" || AutomationType == "FundingMoveTo15Businessdays")
                            {
                                DateTime todaysdate = DateTime.Now;
                                startdate = DateExtensions.CreateNewDate(todaysdate.Year, todaysdate.Month, 24);
                                Enddate = DateExtensions.LastDateOfMonth(startdate);

                                // 318 Capital Expenditure ,320 TI / LC, 519 OpEx ,520 Force Funding,581 Capitalized Interest
                                // if (dc.EnableAutoSpread != true)
                                {
                                    foreach (var item in deal.PayruleDealFundingList)
                                    {
                                        if (item.PurposeID == 318 || item.PurposeID == 320 || item.PurposeID == 519 || item.PurposeID == 520 || item.PurposeID == 581)
                                        {
                                            if (item.Applied != true)
                                            {
                                                if (item.Comment == null || item.Comment == "")
                                                {
                                                    if (item.Date <= Enddate)
                                                    {
                                                        DateTime tempdate = DateTime.MinValue;

                                                        DateTime t1 = item.Date.Value.Date;
                                                        if (AutomationType == "FundingMoveToNextMonth")
                                                        {
                                                            tempdate = item.Date.Value.AddMonths(1);
                                                        }
                                                        else if (AutomationType == "FundingMoveTo15Businessdays")
                                                        {
                                                            tempdate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(item.Date.Value), Convert.ToInt16(10), "US", ListHoliday, true).Date;
                                                        }

                                                        if (tempdate > currentmaturity)
                                                        {
                                                            tempdate = currentmaturity;
                                                        }

                                                        item.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(tempdate), Convert.ToInt16(-1), "US", ListHoliday).Date;
                                                        //item.Comment = "Automatically moved to next month";
                                                        item.GeneratedBy = 747;

                                                        AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                                        aes.Message = t1.Date.ToString("MM/dd/yyyy") + " moved to " + item.Date.Value.ToString("MM/dd/yyyy");
                                                        string dfuningid = item.DealFundingID.ToString();
                                                        if (dfuningid == "")
                                                        {
                                                            dfuningid = "00000000-0000-0000-0000-000000000000";
                                                        }
                                                        aes.DealFundingID = dfuningid;
                                                        aes.Date = item.Date;
                                                        aes.Amount = item.Value;
                                                        aes.PurposeType = item.PurposeText;

                                                        messagelist.Add(aes);

                                                        foreach (var note in deal.PayruleTargetNoteFundingScheduleList)
                                                        {
                                                            if (note.DealFundingRowno == item.DealFundingRowno)
                                                            {
                                                                note.Date = item.Date;
                                                                //note.Comments = "Automatically moved to next month";
                                                                note.GeneratedBy = 747;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AutomationType == "FundingMoveTo1BusinessdaysWF" || AutomationType == "FundingMoveTo1BusinessdaysBackDate")
                            {
                                DateTime todaysdate = DateTime.Now.Date;
                                startdate = todaysdate;
                                Enddate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(todaysdate.Date), Convert.ToInt16(2), "US", ListHoliday, true).Date;

                                foreach (var item in deal.PayruleDealFundingList)
                                {
                                    if (item.PurposeID == 317 || item.PurposeID == 318 || item.PurposeID == 320 || item.PurposeID == 519 || item.PurposeID == 520)
                                    {
                                        if (item.Applied != true)
                                        {
                                            if (item.WF_CurrentStatus != "Completed")
                                            {
                                                if (item.Date <= Enddate)
                                                {
                                                    DateTime tempdate = DateTime.MinValue;
                                                    DateTime t1 = item.Date.Value.Date;
                                                    tempdate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(item.Date.Value), Convert.ToInt16(1), "US", ListHoliday, true).Date;

                                                    DateTime nextworkingdatefromtoday = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(todaysdate.Date), Convert.ToInt16(1), "US", ListHoliday, true).Date;
                                                    if (tempdate > currentmaturity)
                                                    {
                                                        tempdate = currentmaturity;
                                                    }
                                                    else if (tempdate < nextworkingdatefromtoday)
                                                    {
                                                        tempdate = nextworkingdatefromtoday;
                                                    }
                                                    item.Date = tempdate;

                                                    //item.Comment = "Auto Kicked Out Fundings to Next Business Day";
                                                    item.GeneratedBy = 822;
                                                    item.GeneratedByUserID = useridforSys_Scheduler;

                                                    AutomationExtensionDataContract aes = new AutomationExtensionDataContract();
                                                    aes.Message = t1.Date.ToString("MM/dd/yyyy") + " moved to " + item.Date.Value.ToString("MM/dd/yyyy");
                                                    string dfuningid = item.DealFundingID.ToString();
                                                    if (dfuningid == "")
                                                    {
                                                        dfuningid = "00000000-0000-0000-0000-000000000000";
                                                    }
                                                    aes.DealFundingID = dfuningid;
                                                    aes.Date = item.Date;
                                                    aes.Amount = item.Value;
                                                    aes.PurposeType = item.PurposeText;

                                                    messagelist.Add(aes);

                                                    foreach (var note in deal.PayruleTargetNoteFundingScheduleList)
                                                    {
                                                        if (note.DealFundingRowno == item.DealFundingRowno)
                                                        {
                                                            note.Date = item.Date;
                                                            note.GeneratedBy = 822;
                                                            //note.Comments = "Auto Kicked Out Fundings to Next Business Day";
                                                        }
                                                    }
                                                }
                                            }

                                        }
                                    }
                                }
                            }

                            if (deal.RepayTobeAdjusted > 1 && ShowUseRuleN != true)
                            {
                                var message = "Total repayments in Deal Schedule (-" + string.Format("{0:C}", deal.SumTotalRepayments) + ") cannot be greater than total of Repayment Sequences (-" + string.Format("{0:C}", deal.TotalRepaymentSequences) + ") included in funding rules.";

                                AutomationExtensionDataContract aes1 = new AutomationExtensionDataContract();
                                aes1.Message = message;
                                messagelist.Add(aes1);
                                validationstring = "hasvalidation";
                            }

                        }
                        else
                        {   //when fail to generate in code 
                            AutomationExtensionDataContract aes1 = new AutomationExtensionDataContract();
                            aes1.Message = deal.PayruleGenerationExceptionMessage;
                            messagelist.Add(aes1);
                            validationstring = "hasvalidation";
                        }

                    }

                }
                else
                {
                    AutomationExtensionDataContract aes1 = new AutomationExtensionDataContract();
                    aes1.Message = "Please enter Deal Funding Schedule before generating funding.";
                    messagelist.Add(aes1);
                    validationstring = "hasvalidation";

                }
                ValidationEngine validationEngine = new ValidationEngine();
                validationstring = validationstring + validationEngine.ValidateCurrenBalanceAndCommitment(notelist, ListScheduledPrincipalPaid, deal.PayruleTargetNoteFundingScheduleList);
                if (validationstring == "" || validationstring == null)
                {

                    if (deal.PayruleDeletedDealFundingList != null)
                    {
                        if (deal.PayruleDeletedDealFundingList.Count > 0)
                        {
                            dealLogic.InsertUpdateDealArchieveFunding_Automation(deal.PayruleDeletedDealFundingList, UserIDString);
                        }
                    }

                    //update deal funding with proper row number
                    foreach (PayruleDealFundingDataContract pd in deal.PayruleDealFundingList)
                    {
                        pd.CreatedBy = UserIDString;
                        pd.UpdatedBy = UserIDString;
                        if (pd.CreatedDate == null)
                        {
                            pd.CreatedDate = System.DateTime.Now;
                        }
                        else
                        {
                            pd.CreatedDate = pd.CreatedDate;
                        }
                        pd.UpdatedDate = System.DateTime.Now;
                        pd.DealID = deal.DealID;
                        pd.EquityAmount = pd.EquityAmount.GetValueOrDefault(0);
                        pd.RemainingFFCommitment = pd.RemainingFFCommitment.GetValueOrDefault(0);
                        pd.RemainingEquityCommitment = pd.RemainingEquityCommitment.GetValueOrDefault(0);
                        pd.RequiredEquity = pd.RequiredEquity.GetValueOrDefault(0);
                        pd.AdditionalEquity = pd.AdditionalEquity.GetValueOrDefault(0);

                        if (pd.AdjustmentType == 836)
                        {
                            pd.AdjustmentType = null;
                        }
                    }
                    //var json = JsonConvert.SerializeObject(deal);
                    dealLogic.InsertUpdateDealFunding(deal.PayruleDealFundingList, UserIDString);

                    foreach (PayruleTargetNoteFundingScheduleDataContract pn1 in deal.PayruleTargetNoteFundingScheduleList)
                    {
                        if (pn1.Value == null || pn1.Value == 0)
                        {
                            pn1.isDeleted = 1;
                        }
                        if (pn1.Value > 0)
                        {
                            var a = "";
                        }
                    }
                    nl.InsertNoteFutureFunding(deal.PayruleTargetNoteFundingScheduleList, UserIDString);


                    //Delete FF record if not exists in dealfunding
                    dealLogic.DeleteNoteFundingDataForDealFundingID(dc.DealID);

                    //update payoff data
                    if (dc.AutoUpdateFromUnderwriting == true)
                    {
                        if (ListProjectedPayoff.Count > 0)
                        {
                            DateTime? EarliestPossibleRepaymentDate = ListProjectedPayoff[0].EarliestDate;
                            DateTime? LatestPossibleRepaymentDate = ListProjectedPayoff[0].LatestDate;
                            DateTime? ExpectedFullRepaymentDate = ListProjectedPayoff[0].ExpectedDate;
                            DateTime? AutoPrepayEffectiveDate = ListProjectedPayoff[0].AuditUpdateDate;

                            dealLogic.UpdateAutoSpreadColumnByDealID(DealID, EarliestPossibleRepaymentDate, LatestPossibleRepaymentDate, ExpectedFullRepaymentDate, AutoPrepayEffectiveDate, UserIDString);
                            dealLogic.SaveProjectedPayOffDateByDealID(ListProjectedPayoff, headerUserID);
                        }

                    }
                    //DealID
                    //re calculate deal Commitment
                    CommitmentEquityHelperLogic ce = new CommitmentEquityHelperLogic();
                    ce.calcNoteCommitment(DealID, headerUserID);

                    GenerateAutomationLogic.UpdateCalculationStatusandTime(AutomationRequestsID.Value, DealID, "Completed", "EndTime", "", useridforSys_Scheduler, "Deal Saved Successfully");

                    AutomationExtensionDataContract aes1 = new AutomationExtensionDataContract();
                    aes1.Message = "Funding schedule generated successfully.";
                    messagelist.Add(aes1);
                    foreach (var item in messagelist)
                    {
                        GenerateAutomationLogic.InsertIntoAutomationExtension(AutomationRequestsID, DealID, BatchID, "", item.Message, useridforSys_Scheduler, item.DealFundingID, item.PurposeType, item.Amount, item.Date);
                    }
                    //update Phantom funding if any 
                    dealLogic.CopyDealFundingFromLegalToPhantom(dc.CREDealID);
                    if (dc.ShowUseRuleN == false || dc.EnableAutospreadRepayments == true)
                    {
                        List<DealDataContract> listDeal = dealLogic.GetLinkedPhantomDealID(dc.CREDealID);
                        List<GenerateAutomationDataContract> list = new List<GenerateAutomationDataContract>();
                        foreach (DealDataContract deal1 in listDeal)
                        {
                            GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                            gad.DealID = Convert.ToString(deal1.DealID);
                            gad.StatusText = "Processing";
                            gad.AutomationType = 807;
                            gad.AutomationTypeText = "Phantom_Deal";
                            gad.BatchType = "Phantom_Deal";
                            list.Add(gad);
                        }
                        //listDeal
                        GenerateAutomationLogic.QueueDealForAutomation(list, username);
                    }

                    if (AutomationType == "Phantom_Deal")
                    {
                        dealLogic.UpdateWireConfirmedForPhantomDeal(dc.LinkedDealID);
                    }
                    //export pik Data to backshop
                    CheckAndExportDataToBackShop(deal.PayruleTargetNoteFundingScheduleList, username, dc);

                    //insert deal for calculation
                    //dealLogic.CallDealForCalculation(dc.DealID.ToString(), headerUserID, AnalysisID, 775);                  

                }
                else
                {
                    GenerateAutomationLogic.UpdateCalculationStatusandTime(AutomationRequestsID.Value, DealID, "Failed", "EndTime", validationstring, useridforSys_Scheduler, "Validation");
                    foreach (var item in messagelist)
                    {
                        GenerateAutomationLogic.InsertIntoAutomationExtension(AutomationRequestsID, DealID, BatchID, "", item.Message, useridforSys_Scheduler, item.DealFundingID, item.PurposeType, item.Amount, item.Date);
                    }

                    Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), validationstring, DealID, "", "GenerateFundingUsingAPI", "Error occurred  while generating future funding for deal id using API" + dc.CREDealID + " " + deal.PayruleGenerationExceptionMessage);
                }

            }
            catch (Exception ex)
            {

                GenerateAutomationLogic.UpdateCalculationStatusandTime(AutomationRequestsID.Value, DealID, "Failed", "EndTime", "", useridforSys_Scheduler, "Error Failed To Save");
                GenerateAutomationLogic.InsertIntoAutomationExtension(AutomationRequestsID, DealID, BatchID, ex.Message, "", useridforSys_Scheduler, null, null, null, null);
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, DealID, "", "GenerateFundingUsingAPI", "Error occurred  while generating future funding for deal id using API" + DealID + " " + ex.Message);
            }
        }

        public void CheckAndExportDataToBackShop(List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleDataContract, string headerUserID, DealDataContract DealDC)
        {
            string AllowBackshopFF = "";
            try
            {
                AppConfigLogic acl = new AppConfigLogic();
                List<AppConfigDataContract> listappconfig = acl.GetAllAppConfig(new Guid(headerUserID));
                foreach (AppConfigDataContract item in listappconfig)
                {
                    if (item.Key == "AllowBackshopFF")
                    {
                        AllowBackshopFF = item.Value;
                    }
                }
                if (AllowBackshopFF == "1")
                {
                    BackShopExportLogic bsl = new BackShopExportLogic();
                    bsl.ExportFutureFundingFromCRES_API(PayruleTargetNoteFundingScheduleDataContract, headerUserID, DealDC);
                }

            }
            catch (Exception ex)
            {

                throw;
            }

        }

        [HttpGet]
        [Route("api/generateautomation/queuesingledealforautomation")]
        public void QueueSingleDealForAutomation(string DealID)
        {
            GenerateFundingAndSaveDataToDatabase(DealID, 1, 1, useridforSys_Scheduler, "All_AutoSpread_Deals", 1);
        }
        [HttpGet]
        [Route("api/generateautomation/queueAllAutoSpreadDeal")]
        public IActionResult QueueAllAutoSpreadDeal()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                //All_AutoSpread_Deals  
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                List<GenerateAutomationDataContract> list = GenerateAutomationLogic.GetDealListForAutomation("All_AutoSpread_Deals");
                if (list != null && list.Count > 0)
                {
                    dealcount = list.Count;
                    GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "QueueAllAutoSpreadDeal ended for " + dealcount + " Deals", "", "");
                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "QueueAllAutoSpreadDeal no record found ", "", "");
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded QueueAllAutoSpreadDeal for deals " + dealcount,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "QueueAllAutoSpreadDeal", "Error occurred " + " " + ex.Message);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/generateautomation/QueueDiscrepancyUnderwritingDealForAutomation")]
        public IActionResult QueueDiscrepancyUnderwritingDealForAutomation()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                List<GenerateAutomationDataContract> list = GenerateAutomationLogic.GetDealListForAutomation("AutoSpread_UnderwritingDataChanged");
                if (list != null && list.Count > 0)
                {
                    dealcount = list.Count;
                    GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "QueueDiscrepancyUnderwritingDealForAutomation end for " + dealcount + " Deals", "", "");
                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "QueueDiscrepancyUnderwritingDealForAutomation no record found ", "", "");
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded AutomaticallyKickOutMonthEndFundings for deals " + dealcount,
                    ErrorDetails = ""
                };

            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "QueueDiscrepancyUnderwritingDealForAutomation", "Error occurred " + " " + ex.Message);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };

            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/generateautomation/generatefundingforalldeals")]
        public void GenerateFundingForAllDeals()
        {
            try
            {
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                List<GenerateAutomationDataContract> listofdeal = GenerateAutomationLogic.GetListOfDealsForAutomation();
                if (listofdeal != null && listofdeal.Count > 0)
                {
                    foreach (var deal in listofdeal)
                    {
                        GenerateAutomationLogic.UpdateCalculationStatusandTime(deal.AutomationRequestsID.Value, deal.DealID, "Running", "StartTime", "", useridforSys_Scheduler, "");
                    }
                    Parallel.ForEach(listofdeal, new ParallelOptions { MaxDegreeOfParallelism = 2 },
                               (item, state) =>
                               {
                                   GenerateFundingAndSaveDataToDatabase(item.DealID, item.AutomationRequestsID, item.BatchID, item.CreatedBy, item.AutomationTypeText, Convert.ToInt16(item.AutomationType));
                               });
                }
                else
                {
                    CheckAndCallDealsForCalculation();
                }

            }
            catch (Exception ex)
            {
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in CalculateAllDeals " + ex.Message, "", "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50", "CalculateAllDeals", "", ex);
            }
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/generateautomation/automaticallykickoutmonthendfundings")]
        public IActionResult AutomaticallyKickOutMonthEndFundings()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                DateTime todaysdate = DateTime.Now.Date;
                int day = todaysdate.Day;
                if (day == 24)
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AutomaticallyKickOutMonthEndFundings called", "", "");
                    //this api will be called once in a month on 24 
                    GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                    List<GenerateAutomationDataContract> list = GenerateAutomationLogic.GetDealListForAutomation("FundingMoveToNextMonth");
                    if (list != null && list.Count > 0)
                    {
                        dealcount = list.Count;
                        GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                        Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AutomaticallyKickOutMonthEndFundings ended for " + list.Count + " Deals", "", "");
                    }
                    else
                    {
                        Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AutomaticallyKickOutMonthEndFundings no record found ", "", "");
                    }

                }
                else
                {
                    MoveFundingToNextMonthAfter10Businessdays();
                }

                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded AutomaticallyKickOutMonthEndFundings for deals " + dealcount,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "AutomaticallyKickOutMonthEndFundings", "Error occurred " + " " + ex.Message);

            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/generateautomation/amortizationautowireconfirmnnpayday")]
        public IActionResult AmortizationAutoWireConfirmOnPayDay()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AmortizationAutoWireConfirmOnPayDay called", "", "");
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                List<GenerateAutomationDataContract> list = GenerateAutomationLogic.GetDealListForAutomation("AmortizationAutoWire");
                if (list != null && list.Count > 0)
                {
                    dealcount = list.Count;
                    GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AmortizationAutoWireConfirmOnPayDay end for " + list.Count + " Deals", "", "");
                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AmortizationAutoWireConfirmOnPayDay no record found ", "", "");
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded AmortizationAutoWireConfirmOnPayDay for deals " + dealcount,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "AmortizationAutoWireConfirmOnPayDay", "Error occurred " + " " + ex.Message);

            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/generateautomation/AutomationCommitmentDiscrepancy")]
        public IActionResult AutomationCommitmentDiscrepancy()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                AppConfigLogic applogic = new AppConfigLogic();
                List<AppConfigDataContract> configlist = applogic.GetAppConfigByKey(new Guid(useridforSys_Scheduler), "AllowDealAutomation");
                Boolean runautomation = false;
                if (configlist != null && configlist.Count > 0)
                {
                    if (configlist[0].Value == "1")
                    {
                        runautomation = true;
                    }
                }
                if (runautomation == true)
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AutomationCommitmentDiscrepancy called", "", "");
                    GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();

                    DataTable dt = GenerateAutomationLogic.GetDiscrepancyForCommitmentData();
                    List<GenerateAutomationDataContract> list = new List<GenerateAutomationDataContract>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                        gad.DealID = Convert.ToString(dr["DealID"]);
                        gad.StatusText = "Processing";
                        gad.AutomationType = 806;
                        gad.AutomationTypeText = "CommitmentDiscrepancy";
                        gad.BatchType = "CommitmentDiscrepancy";
                        list.Add(gad);
                    }

                    DataTable dtbackshop = GenerateAutomationLogic.GetDiscrepancyForAdjCommitmentM61VsBackshop();
                    DataTable dtback = dtbackshop.DefaultView.ToTable(true, "DealID");

                    foreach (DataRow dr in dtback.Rows)
                    {
                        GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                        gad.DealID = Convert.ToString(dr["DealID"]);
                        gad.StatusText = "Processing";
                        gad.AutomationType = 877;
                        gad.AutomationTypeText = "CommitmentDiscrepancyM61VsBackshop";
                        gad.BatchType = "CommitmentDiscrepancyM61VsBackshop";
                        list.Add(gad);
                    }
                    if (list != null && list.Count > 0)
                    {
                        dealcount = list.Count;
                        GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                        Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AutomationCommitmentDiscrepancy end for " + list.Count + " Deals", "", "");
                    }
                    else
                    {
                        Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "AutomationCommitmentDiscrepancy no record found ", "", "");
                    }

                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded AutomationCommitmentDiscrepancy for deals " + dealcount,
                    ErrorDetails = ""
                };


            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "AutomationCommitmentDiscrepancy", "Error occurred " + " " + ex.Message);

            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/generateautomation/CheckAutomation")]
        public IActionResult CheckAutomation(string DealID, string type)
        {
            v1GenericResult _authenticationResult = null;
            try
            {
                //CheckAndCallDealsForCalculation();

                GenerateFundingAndSaveDataToDatabase(DealID, 2, 1, useridforSys_Scheduler, type, 1);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded CheckAutomation for deal " + DealID,
                    ErrorDetails = ""
                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };

            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/generateautomation/generateautomationcombinedAPI")]
        public IActionResult GenerateAutomationCombinedAPI()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "GenerateAutomationCombinedAPI started", "", "");
                AutomationCommitmentDiscrepancy();
                QueueDiscrepancyUnderwritingDealForAutomation();
                AutomaticallyKickOutMonthEndFundings();
                AmortizationAutoWireConfirmOnPayDay();
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "GenerateAutomationCombinedAPI Ended", "", "");

                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded GenerateAutomationCombinedAPI",
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "GenerateAutomationCombinedAPI", "Error occurred " + " " + ex.Message);
            }
            return Ok(_authenticationResult);
        }

        public void CheckAndCallDealsForCalculation()
        {
            string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
            LoggerLogic log = new LoggerLogic();
            try
            {
                GenerateAutomationLogic generateAutomationLogic = new GenerateAutomationLogic();
                string AnalysisID = "c10f3372-0fc2-4861-a9f5-148f1f80804f";


                DataTable dt = generateAutomationLogic.QueueDealForCalcualationAfterDealSaveAutomation();
                if (dt != null && dt.Rows.Count > 0)
                {
                    DealLogic dealLogic = new DealLogic();
                    string DealIDs = "";
                    foreach (DataRow dr in dt.Rows)
                    {
                        DealIDs += dr["DealID"] + "|";
                    }
                    dealLogic.QueueDealForCalculationMultipleDeals(DealIDs, useridforSys_Scheduler, AnalysisID, 775);
                    generateAutomationLogic.UpdateDealSentForCalculationToYes();
                    log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "Calculation request submitted for deals in automation ", "", useridforSys_Scheduler);
                }
            }
            catch (Exception ex)
            {

                log.WriteLogException(CRESEnums.Module.GenerateAutomation.ToString(), "Error in CheckAndCallDealsForCalculation " + ex.Message, "", useridforSys_Scheduler, "CalculateAllDeals", "", ex);
            }

        }

        [HttpGet]
        [Route("api/generateautomation/MoveFundingToNextMonthAfter10Businessdays")]
        public IActionResult MoveFundingToNextMonthAfter10Businessdays()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                List<GenerateAutomationDataContract> listofdeals = new List<GenerateAutomationDataContract>();
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                DataTable dt = GenerateAutomationLogic.GetFundingDrawByBusinessday(10);

                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "MoveFundingToNextMonthAfter10Businessdays Called", "", "");

                DataTable dtUniq = new DataTable();
                dtUniq = dt.DefaultView.ToTable(true, "dealid");

                if (dtUniq != null && dtUniq.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtUniq.Rows)
                    {
                        GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                        gad.DealID = Convert.ToString(dr["DealID"]);
                        gad.StatusText = "Processing";
                        gad.AutomationType = 839;
                        gad.BatchType = "FundingMoveTo15Businessdays";

                        listofdeals.Add(gad);
                    }

                    dealcount = listofdeals.Count;
                    GenerateAutomationLogic.QueueDealForAutomation(listofdeals, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "MoveFundingToNextMonthAfter10Businessdays ended for " + dealcount + " Deals", "", "");

                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "MoveFundingToNextMonthAfter10Businessdays no Funding found", "", "");
                }

                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Total deals " + dealcount + " queued to MoveFundingToNextMonthAfter10Businessdays",
                    ErrorDetails = ""
                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "MoveFundingToNextMonthAfter10Businessdays", "Error occurred " + " " + ex.Message);

            }
            return Ok(_authenticationResult);

        }


        [HttpGet]
        [Route("api/generateautomation/MoveFundingAfterOneBusinessdaysWF")]
        public IActionResult MoveFundingAfterOneBusinessdaysWF()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            int dealcountback = 0;
            try
            {
                List<GenerateAutomationDataContract> listofdeals = new List<GenerateAutomationDataContract>();
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                DataTable dt = GenerateAutomationLogic.GetFundingDrawByOneBusinessdayWF(2);
                DataTable dtback = GenerateAutomationLogic.GetFundingDrawByOneBusinessdayBackDate(7);

                //code for MoveFundingToNextMonthAfter1BusinessdaysWF
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "MoveFundingToNextMonthAfter1BusinessdaysWF Called", "", "");
                DataTable dtUniq = new DataTable();
                dtUniq = dt.DefaultView.ToTable(true, "dealid");
                if (dtUniq != null && dtUniq.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtUniq.Rows)
                    {
                        GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                        gad.DealID = Convert.ToString(dr["DealID"]);
                        gad.StatusText = "Processing";
                        gad.AutomationType = 851;
                        gad.BatchType = "FundingMoveTo1BusinessdaysWF";

                        listofdeals.Add(gad);
                    }
                    dealcount = listofdeals.Count;

                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "MoveFundingToNextMonthAfter1BusinessdaysWF no Funding found", "", "");
                }

                //
                //code for OneBusinessdayBackDate
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "FundingMoveTo1BusinessdaysBackDate Called", "", "");
                DataTable dtUniqback = new DataTable();
                dtUniqback = dtback.DefaultView.ToTable(true, "dealid");
                if (dtUniqback != null && dtUniqback.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtUniqback.Rows)
                    {
                        GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                        gad.DealID = Convert.ToString(dr["DealID"]);
                        gad.StatusText = "Processing";
                        gad.AutomationType = 892;
                        gad.BatchType = "FundingMoveTo1BusinessdaysBackDate";

                        listofdeals.Add(gad);
                    }
                    if (dealcount != 0)
                    {
                        dealcountback = listofdeals.Count - dealcount;
                    }
                    else
                    {
                        dealcountback = listofdeals.Count;
                    }

                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "FundingMoveTo1BusinessdaysBackDate no Funding found", "", "");
                }

                if (listofdeals != null && listofdeals.Count > 0)
                {
                    GenerateAutomationLogic.QueueDealForAutomation(listofdeals, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "FundingMoveTo1BusinessdaysBackDate ended for " + dealcountback + " Deals", "", "");
                    Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "MoveFundingToNextMonthAfter1BusinessdaysWF ended for " + dealcount + " Deals", "", "");
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Total deals " + dealcount + " queued to MoveFundingToNextMonthAfter1BusinessdaysWF",
                    ErrorDetails = ""
                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "MoveFundingToNextMonthAfter1BusinessdaysWF", "Error occurred " + " " + ex.Message);

            }
            return Ok(_authenticationResult);

        }

        [HttpGet]
        [Route("api/generateautomation/APIhealthCheck")]
        public IActionResult APIhealthCheck()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "APIhealthCheck Called", "", "");
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "APIhealthCheck Called",
                    ErrorDetails = ""
                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, "", "", "APIhealthCheck", "Error occurred " + " " + ex.Message);

            }
            return Ok(_authenticationResult);

        }
    }
}
