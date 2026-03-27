using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace CRES.NoteCalculator
{
    public class PayruleNoteFutureFundingHelper
    {
        #region Property

        public DealDataContract dealDC = new DealDataContract();
        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleList = new List<PayruleTargetNoteFundingScheduleDataContract>();
        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleListTemp = new List<PayruleTargetNoteFundingScheduleDataContract>();
        public List<PayruleDealFundingDataContract> PayruleDealFundingList = new List<PayruleDealFundingDataContract>();
        public List<AutoSpreadDistributionHelper> ListPurposeMinDate = new List<AutoSpreadDistributionHelper>();

        public List<PayruleNoteAMSequenceDataContract> PayruleNoteAMSequenceList = new List<PayruleNoteAMSequenceDataContract>();
        public List<PayruleNoteAMSequenceDataContract> ListPayruleNoteSequence = new List<PayruleNoteAMSequenceDataContract>();
        public List<Decimal?> SubordinatedCumFundingThreshold = new List<Decimal?>();
        public List<Decimal?> SeniorCumFundingThreshold = new List<Decimal?>();
        public List<Decimal?> PariPassuCumFundingThreshold = new List<Decimal?>();
        public List<Decimal?> TargetNoteFundingThreshold = new List<Decimal?>();
        public List<Decimal?> SubordinatedCumRepayThreshold = new List<Decimal?>();
        public List<Decimal?> SeniorCumRepayThreshold = new List<Decimal?>();
        public List<Decimal?> PariPassuCumRepayThreshold = new List<Decimal?>();
        public List<Decimal?> TargetNoteRepayThreshold = new List<Decimal?>();
        public List<PayruleDealFundingDataContract> PayruleDeletedDealFundingList = new List<PayruleDealFundingDataContract>();
        public List<PayruleDealFundingDataContract> RemainingDealFundingList = new List<PayruleDealFundingDataContract>();
        public List<CummulativeProbabilityDataContract> ListCummulativeProbability = new List<CummulativeProbabilityDataContract>();
        public List<AutoRepaymentBalancesDataContract> ListRepaymentBalances = new List<AutoRepaymentBalancesDataContract>();
        public List<CalculatedAutoRepaymentDataContract> ListCalculatedAutoRepayment = new List<CalculatedAutoRepaymentDataContract>();

        public CalculatedAutoRepaymentDataContract CurrentCalculatedAutoRepayment = new CalculatedAutoRepaymentDataContract();

        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleDeletedTargetNoteFundingScheduleList = new List<PayruleTargetNoteFundingScheduleDataContract>();
        public List<CalculatedNoteRepaymentDataContract> ListCalculatedNoteRepayment = new List<CalculatedNoteRepaymentDataContract>();
        public List<AutoRepaymentNoteBalancesDataContract> ListNoteRepaymentBalances = new List<AutoRepaymentNoteBalancesDataContract>();
        public List<PayruleDealFundingDataContract> DealFundingListExtension = new List<PayruleDealFundingDataContract>();

        public List<int?> DeletedRowNumberList = new List<int?>();
        public decimal ExtraNoteFunding = 0, LessNoteFunding = 0, ExtraNoteRepayment = 0, LessNoteRepayment = 0, totalDealFunding = 0, totalNoteFunding = 0, noteFundingPercentage = 0, totalDealRepayment = 0, totalNoteRepayment = 0, noteRepaymentPercentage = 0;
        public decimal? PreviousEndingBalance = 0, CurrentCPRandSLRFactor = 0, RepayToBeAdjusted = 0, RepayToBeAdjustedUseRuleN = 0, TotalRepaymentasofDate = 0;
        private int dropday = 0, actuallastmonth = 0;
        private Guid? dealid = Guid.Empty;
        private DateTime? AutoSpreadStartDate = DateTime.MinValue;
        private DateTime? maxWireConfirmedDate = DateTime.MinValue;
        private decimal? TotalRequiredEquity = 0;
        private DateTime? maxFundDate = DateTime.MinValue;
        private DateTime? RepaymentEndDate = DateTime.MinValue;
        private DateTime? FirstRepayDate = DateTime.MinValue;
        private Boolean EventTrueup = false;
        DateTime? MinDateWith100CummulativeProbability = DateTime.MinValue;
        private int UseRuleNRowNumber = 0;
        private DateTime? maxLockedDate = DateTime.MinValue;
        Boolean generateonLatestpossibleprepayment = false;
        Boolean datainCumulativeProbability = false;
        private decimal? NonCommitmentAdjTotal = 0;
        private decimal? RevolverTotal = 0;

        private decimal? autoSpreadFundingcmp = 0;
        private decimal? autoSpreadRepaymentcmp = 0;

        public List<PayruleDealFundingDataContract> PayruleDealFundingTempList = new List<PayruleDealFundingDataContract>();
        public List<PayruleDealFundingDataContract> OriginalDealFundingList = new List<PayruleDealFundingDataContract>();
        public List<PayruleTargetNoteFundingScheduleDataContract> OriginalNoteFundingList = new List<PayruleTargetNoteFundingScheduleDataContract>();

        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleTempList = new List<PayruleTargetNoteFundingScheduleDataContract>();
        public List<PayruleNoteAMSequenceDataContract> PayruleNoteAMSequenceTempList = new List<PayruleNoteAMSequenceDataContract>();
        public List<PayruleNoteDetailFundingDataContract> ListNoteDetail = new List<PayruleNoteDetailFundingDataContract>();
        private int createcsv = 0;

        #endregion 
        public DealDataContract StartCalculation(DealDataContract dealObject)
        {
            try
            {
                createcsv = 0;
                dealObject.PayruleDealFundingList.RemoveAll(x => x.Value == null & x.RequiredEquity == null & x.AdditionalEquity == null);
                //to assign $0 in RequiredEquity, AdditionalEquity and Debt amount when any one field contain value
                foreach (var val in dealObject.PayruleDealFundingList)
                {
                    val.Value = val.Value.GetValueOrDefault(0);
                    val.RequiredEquity = val.RequiredEquity.GetValueOrDefault(0);
                    val.AdditionalEquity = val.AdditionalEquity.GetValueOrDefault(0);
                    OriginalDealFundingList.Add(val);
                }
                foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealObject.PayruleTargetNoteFundingScheduleList)
                {
                    notefund.Value = notefund.Value.GetValueOrDefault(0);
                    OriginalNoteFundingList.Add(notefund);
                }
                dealObject.PayruleDealFundingList.RemoveAll(x => x.Value == null);
                dealObject.PayruleDealFundingList.RemoveAll(x => x.Date == null);

                //added code to remove soft holiday from autospreading 
                dealObject.ListHoliday = dealObject.ListHoliday.FindAll(x => x.IsSoftHoliday != 3);

                dealDC = dealObject;
                dealDC.PayruleDealFundingList = dealObject.PayruleDealFundingList.OrderBy(x => x.Date).ToList();
                dealDC.PayruleDealFundingList = dealObject.PayruleDealFundingList.OrderBy(x => x.Date).OrderByDescending(x => x.Applied).ToList();
                //dealDC = dealObject;
                dealid = dealDC.DealID;

                if (dealDC.Blockoutperiod == null)
                {
                    dealDC.Blockoutperiod = 2;
                }

                if (dealDC.EnableAutospreadRepayments == true || dealDC.EnableAutospreadUseRuleN == true)
                {
                    foreach (var amSeq in dealDC.PayruleNoteAMSequenceList)
                    {
                        PayruleNoteAMSequenceDataContract am = new PayruleNoteAMSequenceDataContract();
                        am.NoteID = amSeq.NoteID;
                        am.Ratio = amSeq.Ratio;
                        am.SequenceNo = amSeq.SequenceNo;
                        am.SequenceType = amSeq.SequenceType;
                        am.SequenceTypeText = amSeq.SequenceTypeText;
                        am.Value = amSeq.Value == Convert.ToDecimal(0.01) ? 0 : amSeq.Value;
                        ListPayruleNoteSequence.Add(am);
                    }
                }

                CreateDealandNotedatcsv("Start");
                #region "AdjustmentType"                
                //below list  used in autospread
                dealDC.PayruleDealFundingList_Pwriteoff = dealDC.PayruleDealFundingList.Where(x => x.PurposeID == 840 && x.DealFundingRowno != null).ToList();
                dealDC.DealFundingListAdjustmentTypeAutoSpread = dealDC.PayruleDealFundingList.Where(x => (x.AdjustmentType == 834 || x.AdjustmentType == 896 || x.AdjustmentType == 835)).ToList();

                //remove AdjustmentType
                dealDC.PayruleDealFundingList_AdjustmentType = dealDC.PayruleDealFundingList.Where(x => x.PurposeID != 840 && (x.AdjustmentType == 834 || x.AdjustmentType == 896 || x.AdjustmentType == 835)).ToList();

                for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
                {
                    for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                    {
                        if (dealDC.PayruleDealFundingList[j].DealFundingID != null)
                        {
                            if (dealDC.PayruleDealFundingList[j].DealFundingRowno == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].OrgDealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                            }
                            if (dealDC.PayruleDealFundingList[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].OrgDealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                            }
                        }
                        else
                        {
                            if (dealDC.PayruleDealFundingList[j].DealFundingRowno == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].OrgDealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                            }
                        }
                    }
                    dealDC.PayruleDealFundingList[j].OrgDealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                }

                dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => (x.AdjustmentType == 834 || x.AdjustmentType == 896 || x.AdjustmentType == 835)).ToList();
                dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.PurposeID == 840 && x.DealFundingRowno != null).ToList();
                dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff = dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff.Where(x => x.DealFundingRowno > 0).ToList();
                //below list  used in autospread
                dealDC.NoteFundingScheduleListAdjustmentTypeAutoSpread = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => (x.AdjustmentType == 834 || x.AdjustmentType == 896 || x.AdjustmentType == 835)).ToList();

                IndentifyNCANote();
                // remove AdjustmentType records from list
                dealDC.PayruleDealFundingList.RemoveAll(x => (x.AdjustmentType == 834 || x.AdjustmentType == 896 || x.AdjustmentType == 835));
                dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => (x.AdjustmentType == 834 || x.AdjustmentType == 896 || x.AdjustmentType == 835));

                dealDC.PayruleDealFundingList.RemoveAll(x => x.PurposeID == 840);
                dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.PurposeID == 840);

                CreateDealandNotedatcsv("AfterDataRemoved");
                #endregion
                foreach (var note in dealDC.PayruleNoteDetailFundingList)
                {
                    ListNoteDetail.Add(note);
                }
                //assign Row no in Note funding according to DealFundingID in  Deal funding
                dealDC.PayruleTargetNoteFundingScheduleList = dealDC.PayruleTargetNoteFundingScheduleList.OrderBy(x => x.Date).ToList();
                for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
                {
                    if (dealDC.PayruleDealFundingList[j].DealFundingRowno == 8)
                    {

                    }
                    for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                    {
                        if (dealDC.PayruleDealFundingList[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID & dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID != null)
                        {
                            dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                            dealDC.PayruleTargetNoteFundingScheduleList[i].Applied = dealDC.PayruleDealFundingList[j].Applied;
                            dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                        }
                    }
                }

                if (dealDC.ListNoteEndingBalance != null)
                {
                    foreach (NoteEndingBalanceDataContract res in dealDC.ListNoteEndingBalance)
                    {
                        decimal? notesumseq = 0;
                        Guid noteid = new Guid(res.NoteID);
                        //SumRepaymentSequence
                        foreach (var noteseq in ListPayruleNoteSequence)
                        {
                            if (noteseq.NoteID == noteid && noteseq.SequenceTypeText == "Repayment Sequence")
                            {
                                notesumseq = notesumseq.GetValueOrDefault(0) + noteseq.Value.GetValueOrDefault(0);
                            }
                        }

                        res.SumRepaymentSequence = notesumseq.GetValueOrDefault(0);
                    }
                }

                if (dealDC.EnableAutospreadUseRuleN != true && dealDC.EnableAutospreadRepayments != true)
                {
                    // delete old paydown which are generated from auto spreading 
                    DeletePaydownFromNoteAndDeal();
                }

                DeleteAutoSpreadFundings();
                CreateDealandNotedatcsv("BeforeAutospread");
                if (dealDC.EnableAutoSpread == true && dealDC.EnableAutospreadUseRuleN != true)
                {
                    DeleteFundingForAutoSpreading();
                    AutoSpreadFundDistribution();
                }
                if (dealDC.EnableAutospreadUseRuleN == true)
                {
                    //assign Row no in Note funding according to DealFundingID in Deal funding
                    dealDC.PayruleTargetNoteFundingScheduleList = dealDC.PayruleTargetNoteFundingScheduleList.OrderBy(x => x.Date).ToList();
                    for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
                    {
                        for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                        {
                            if ((dealDC.PayruleDealFundingList[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID) & dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID != null)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].Applied = dealDC.PayruleDealFundingList[j].Applied;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                            }
                        }
                    }

                    if (dealDC.ExpectedFullRepaymentDate == null || dealDC.ExpectedFullRepaymentDate == DateTime.MinValue)
                    {
                        dealDC.ListProjectedPayoff = dealDC.ListProjectedPayoff.OrderBy(x => x.ProjectedPayoffAsofDate).ToList();
                        AutoSpreadRepaymentUseRuleN();
                    }
                    else
                    {
                        ListNoteRepaymentBalances = dealDC.ListNoteRepaymentBalances;
                        CreateExpectedFullRepayRecordUseRuleN(Convert.ToDateTime(dealDC.ExpectedFullRepaymentDate));
                    }

                }
                else if (dealDC.EnableAutospreadRepayments == true)
                {
                    if (dealDC.ApplyNoteLevelPaydowns == true)
                    {
                        //AutoSpreadRepaymentNoteLevelUseRuleY();
                    }
                    else
                    {
                        //repayment autospreading will NOT be performed if ExpectedFullRepaymentDate is provided 
                        if (dealDC.ExpectedFullRepaymentDate == null || dealDC.ExpectedFullRepaymentDate == DateTime.MinValue)
                        {
                            AutoSpreadRepayment();
                        }
                        else
                        {//If provided repayment autospreading will NOT be performed. Only one paydown transaction will be created with the balance on the date provided.
                            ListRepaymentBalances = dealDC.ListAutoRepaymentBalances;
                            CreateExpectedFullRepayRecord(Convert.ToDateTime(dealDC.ExpectedFullRepaymentDate));
                        }
                    }

                }
                CreateDealandNotedatcsv("AfterAutospread");
                if (dealDC.EnableAutospreadUseRuleN != true)
                {
                    if (dealDC.EnableAutospreadRepayments == true && dealDC.ApplyNoteLevelPaydowns != true)
                    {
                        ApplyPennyAdjustmentToRepayment();
                    }
                    dealDC.PayruleDealFundingList = dealObject.PayruleDealFundingList.OrderBy(x => x.Date).OrderByDescending(x => x.Applied).ToList();
                    dealDC.PayruleDealFundingList.ForEach(x => x.Value = Convert.ToDecimal(Math.Round(Convert.ToDouble(x.Value), 2)));
                    dealDC.PayruleNoteAMSequenceList.ForEach(x => x.Value = Convert.ToDecimal(Math.Round(Convert.ToDouble(x.Value), 2)));
                    var cnt = 1;
                    int? oldrownumber = 1;
                    foreach (var val in dealDC.PayruleDealFundingList)
                    {
                        PayruleDealFundingDataContract pay = new PayruleDealFundingDataContract();
                        oldrownumber = val.DealFundingRowno;

                        pay.DealFundingRowno = cnt;
                        val.DealFundingRowno = cnt;

                        pay.Applied = val.Applied;
                        pay.AdjustmentType = val.AdjustmentType;
                        pay.DealID = val.DealID;
                        pay.Date = val.Date;
                        pay.Value = val.Value;
                        pay.PurposeID = val.PurposeID;
                        pay.PurposeText = val.PurposeText;
                        pay.OldComment = val.OldComment;
                        pay.RequiredEquity = val.RequiredEquity.GetValueOrDefault(0);
                        pay.AdditionalEquity = val.AdditionalEquity.GetValueOrDefault(0);
                        //  pay.EquityAmount = val.EquityAmount.GetValueOrDefault(0);
                        pay.RemainingEquityCommitment = val.RemainingEquityCommitment.GetValueOrDefault(0);
                        pay.RemainingFFCommitment = val.RemainingFFCommitment.GetValueOrDefault(0);
                        PayruleDealFundingList.Add(pay);
                        val.Value1 = val.Value;
                        if (val.DealFundingID == null)
                        {
                            AssignRowToNoteBasedonoldRowNumber(cnt, oldrownumber, val.Date, val);
                        }
                        cnt++;
                    }

                    //apply oredr by for proper distribution
                    dealDC.PayruleDealFundingList = dealObject.PayruleDealFundingList.OrderBy(x => x.Date).ToList();
                    //assign Row no in Note funding according to DealFundingID in  Deal funding
                    dealDC.PayruleTargetNoteFundingScheduleList = dealDC.PayruleTargetNoteFundingScheduleList.OrderBy(x => x.Date).ToList();
                    for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
                    {
                        for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                        {
                            if (dealDC.PayruleDealFundingList[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID & dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID != null)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].Applied = dealDC.PayruleDealFundingList[j].Applied;
                                dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                            }
                        }
                    }
                    foreach (var amSeq in dealDC.PayruleNoteAMSequenceList)
                    {
                        PayruleNoteAMSequenceDataContract am = new PayruleNoteAMSequenceDataContract();
                        am.NoteID = amSeq.NoteID;
                        am.Ratio = amSeq.Ratio;
                        am.SequenceNo = amSeq.SequenceNo;
                        am.SequenceType = amSeq.SequenceType;
                        am.SequenceTypeText = amSeq.SequenceTypeText;
                        am.Value = amSeq.Value == Convert.ToDecimal(0.01) ? 0 : amSeq.Value;
                        PayruleNoteAMSequenceList.Add(am);
                    }

                    if (dealDC.ApplyNoteLevelPaydowns == true)
                    {
                        DeleteRepaymentsFromNoteAndDeal();
                    }

                    //#region "AdjustmentType"
                    ////remove AdjustmentType //sam
                    //dealDC.PayruleDealFundingList_AdjustmentType = dealDC.PayruleDealFundingList.Where(x => x.AdjustmentType == 834 || x.AdjustmentType == 835).ToList();

                    //for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
                    //{
                    //    for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                    //    {
                    //        if (dealDC.PayruleDealFundingList[j].DealFundingRowno == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno)
                    //        {
                    //            dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;
                    //        }
                    //    }
                    //}

                    //dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.AdjustmentType == 834 || x.AdjustmentType == 835).ToList();
                    //dealDC.PayruleDealFundingList.RemoveAll(x => x.AdjustmentType == 834 || x.AdjustmentType == 835);
                    //dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.AdjustmentType == 834 || x.AdjustmentType == 835);

                    //#endregion
                    CreateDealandNotedatcsv("Before_Generate");
                    CalculateDealWaterfall();
                    CreateDealandNotedatcsv("After_Generate");
                    if (dealDC.ApplyNoteLevelPaydowns == true)
                    {
                        foreach (var val in dealDC.PayruleDealFundingList)
                        {
                            val.Value = val.Value1;
                        }
                        AutoSpreadRepaymentNoteLevelUseRuleY();
                        ApplyPennyAdjustmentToRepayment();
                    }
                    foreach (var val in dealDC.PayruleDealFundingList)
                    {
                        val.Value = val.Value1;
                        val.EquityAmount = val.EquityAmount.GetValueOrDefault(0);
                    }
                }
                else
                {
                    //penny adjustment for paydown transaction
                    if (dealDC.EnableAutospreadUseRuleN == true)
                    {
                        ApplyPennyAdjustmentToRepayment();
                    }
                }
                dealDC.PayruleDeletedDealFundingList = PayruleDeletedDealFundingList;
                dealDC.PayruleDeletedTargetNoteFundingScheduleList = PayruleDeletedTargetNoteFundingScheduleList;
                dealDC.ListCalculatedAutoRepayment = ListCalculatedAutoRepayment;
                dealDC.ListCummulativeProbability = ListCummulativeProbability;
                dealDC.ListCalculatedNoteRepayment = ListCalculatedNoteRepayment;

                CreateDealandNotedatcsv("BeforeDataApply");
                #region "AdjustmentType"
                if (dealDC.PayruleDealFundingList_AdjustmentType.Count() > 0)
                {
                    var maxRowNum = dealDC.PayruleDealFundingList.Max(x => x.DealFundingRowno).ToInt32();
                    dealDC.PayruleDealFundingList_AdjustmentType.ForEach(x => x.TempDealFundingRowno = x.DealFundingRowno);
                    dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType.ForEach(x => x.TempDealFundingRowno = x.DealFundingRowno);

                    //  CreateCSVFile(ToDataSet(dealDC.PayruleDealFundingList_AdjustmentType).Tables[0], "DealFundingList3");
                    // CreateCSVFile(ToDataSet(dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType).Tables[0], "NoteFundingList3");
                    //assign maxRowNum in AdjustmentType records
                    for (int j = 0; j < dealDC.PayruleDealFundingList_AdjustmentType.Count(); j++)
                    {
                        maxRowNum++;
                        for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType.Count(); i++)
                        {
                            if (dealDC.PayruleDealFundingList_AdjustmentType[j].TempDealFundingRowno == dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType[i].TempDealFundingRowno)// || dealDC.PayruleDealFundingList_AdjustmentType[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType[i].DealFundingID)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType[i].DealFundingRowno = maxRowNum;
                                //dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;

                            }
                        }
                        dealDC.PayruleDealFundingList_AdjustmentType[j].DealFundingRowno = maxRowNum;
                    }

                    //Add AdjustmentType related data
                    dealDC.PayruleDealFundingList.AddRange(dealDC.PayruleDealFundingList_AdjustmentType.ToList());
                    dealDC.PayruleTargetNoteFundingScheduleList.AddRange(dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType.ToList());

                }

                CreateDealandNotedatcsv("Afteradjdata");


                if (dealDC.PayruleDealFundingList_Pwriteoff.Count() > 0)
                {
                    var maxRowNum = dealDC.PayruleDealFundingList.Max(x => x.DealFundingRowno).ToInt32();
                    dealDC.PayruleDealFundingList_Pwriteoff.ForEach(x => x.TempDealFundingRowno = x.DealFundingRowno);
                    dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff.ForEach(x => x.TempDealFundingRowno = x.DealFundingRowno);

                    //  CreateCSVFile(ToDataSet(dealDC.PayruleDealFundingList_AdjustmentType).Tables[0], "DealFundingList3");
                    // CreateCSVFile(ToDataSet(dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType).Tables[0], "NoteFundingList3");
                    //assign maxRowNum in AdjustmentType records
                    for (int j = 0; j < dealDC.PayruleDealFundingList_Pwriteoff.Count(); j++)
                    {
                        maxRowNum++;
                        for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff.Count(); i++)
                        {
                            if (dealDC.PayruleDealFundingList_Pwriteoff[j].TempDealFundingRowno == dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff[i].TempDealFundingRowno)// || dealDC.PayruleDealFundingList_AdjustmentType[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList_AdjustmentType[i].DealFundingID)
                            {
                                dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff[i].DealFundingRowno = maxRowNum;
                                //dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;

                            }
                        }
                        dealDC.PayruleDealFundingList_Pwriteoff[j].DealFundingRowno = maxRowNum;
                    }

                    //Add AdjustmentType related data
                    dealDC.PayruleDealFundingList.AddRange(dealDC.PayruleDealFundingList_Pwriteoff.ToList());
                    dealDC.PayruleTargetNoteFundingScheduleList.AddRange(dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff.ToList());
                }


                #endregion


                dealDC.PayruleDealFundingList = dealDC.PayruleDealFundingList.OrderBy(y => y.Date).ToList();
                dealDC.PayruleTargetNoteFundingScheduleList = dealDC.PayruleTargetNoteFundingScheduleList.OrderBy(y => y.Date).ToList();
                if (dealDC.EnableAutospreadRepayments == true)
                {
                    AddRepayForNonCommitmentAdjustment();
                }
                CreateDealandNotedatcsv("BeforeRowno");
                AssignRowNum();
                dealDC.PayruleDealFundingList = dealObject.PayruleDealFundingList.OrderBy(x => x.Date).OrderByDescending(x => x.Applied).ToList();
                CreateDealandNotedatcsv("Output");


                foreach (var _noteFunding in dealDC.PayruleTargetNoteFundingScheduleList)
                {
                    decimal? noteFundingScheduleListTemp = PayruleTargetNoteFundingScheduleListTemp.Where(x => x.NoteID == _noteFunding.NoteID && x.Value != 0).Sum(y => y.Value);
                }

            }
            catch (Exception ex)
            {
                dealDC.PayruleGenerationExceptionMessage = "Funding schedule generation failed - " + System.Environment.NewLine + "" + ex.Message;
                dealDC.PayruleGenerationStackTrace = "Funding schedule generation failed: " + ex.Message + ". Stack Trace:" + dealDC.CREDealID + " : " + ex.StackTrace;
            }
            return dealDC;
        }

        #region Common
        public void AssignRowNum()
        {
            //Assign New Row No
            int rowcount = 0;
            dealDC.PayruleDealFundingList.ForEach(x => x.TempDealFundingRowno = x.DealFundingRowno);
            foreach (var val in dealDC.PayruleDealFundingList)
            {
                rowcount++;
                val.DealFundingRowno = rowcount;
                if (val.GeneratedBy == null || val.GeneratedBy == 0)
                {
                    val.GeneratedBy = 746;
                }

            }

            dealDC.PayruleTargetNoteFundingScheduleList.ForEach(x => x.TempDealFundingRowno = x.DealFundingRowno);

            for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
            {
                dealDC.PayruleDealFundingList[j].Date = dealDC.PayruleDealFundingList[j].Date.Value.Date;
                for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                {
                    if (dealDC.PayruleDealFundingList[j].TempDealFundingRowno == dealDC.PayruleTargetNoteFundingScheduleList[i].TempDealFundingRowno)
                    {
                        dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                        dealDC.PayruleTargetNoteFundingScheduleList[i].GeneratedBy = dealDC.PayruleDealFundingList[j].GeneratedBy;
                        dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = dealDC.PayruleDealFundingList[j].AdjustmentType;

                    }
                }
            }
            //End of Assign New Row No
        }
        public void AssignRowToNoteBasedonoldRowNumber(int currentrownumber, int? oldrownumber, DateTime? currentdate, PayruleDealFundingDataContract pdc)
        {
            for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
            {
                if (dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID == null)
                {
                    if (dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno == oldrownumber && dealDC.PayruleTargetNoteFundingScheduleList[i].Date == currentdate.Value)
                    {
                        dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = currentrownumber;
                        dealDC.PayruleTargetNoteFundingScheduleList[i].Applied = pdc.Applied;
                        dealDC.PayruleTargetNoteFundingScheduleList[i].AdjustmentType = pdc.AdjustmentType;
                    }
                }
            }
        }
        public static DataSet ToDataSet<T>(IEnumerable<T> list)
        {
            Type elementType = typeof(T);
            DataSet ds = new DataSet();
            System.Data.DataTable t = new System.Data.DataTable();
            ds.Tables.Add(t);

            //add a column to table for each public property on T
            foreach (var propInfo in elementType.GetProperties())
            {
                t.Columns.Add(propInfo.Name);
            }

            //go through each property on T and add each value to the table
            foreach (T item in list)
            {
                DataRow row = t.NewRow();
                foreach (var propInfo in elementType.GetProperties())
                {
                    row[propInfo.Name] = propInfo.GetValue(item, null);
                }

                //This line was missing:
                t.Rows.Add(row);
            }

            return ds;
        }

        public void CreateCSVFile(System.Data.DataTable dt, string csvname)
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

        public void CreateDealandNotedatcsv(string filename)
        {
            if (createcsv == 1)
            {
                CreateCSVFile(ToDataSet(dealDC.PayruleDealFundingList).Tables[0], "DealFunding_" + filename);
                CreateCSVFile(ToDataSet(dealDC.PayruleTargetNoteFundingScheduleList).Tables[0], "NoteFunding_" + filename);
            }
        }

        #endregion Common

        #region NewCode

        public void CalculateDealWaterfall()
        {
            decimal sumDeal = dealDC.PayruleDealFundingList.Sum(x => x.Value.GetValueOrDefault(0));
            var maxFundingPriority = (dealDC.PayruleNoteDetailFundingList.Max(x => x.FundingPriority)).GetValueOrDefault(0);
            dealDC.PayruleNoteDetailFundingList.Where(x => x.FundingPriority == null).ToList().ForEach(i => i.FundingPriority = maxFundingPriority + 1);
            maxFundingPriority = (dealDC.PayruleNoteDetailFundingList.Max(x => x.FundingPriority)).GetValueOrDefault(0);
            dealDC.PayruleNoteDetailFundingList = dealDC.PayruleNoteDetailFundingList.Where(x => x.UseRuletoDetermineNoteFundingText == "Y" || x.UseRuletoDetermineNoteFundingText == "3").OrderBy(y => y.FundingPriority).ToList();
            dealDC.PayruleNoteAMSequenceList = dealDC.PayruleNoteAMSequenceList.Where(x => dealDC.PayruleNoteDetailFundingList.Any(y => x.NoteID == y.NoteID)).ToList();
            foreach (var notepay in dealDC.PayruleNoteAMSequenceList)
            {
                notepay.Value = notepay.Value == Convert.ToDecimal(0.01) ? 0 : notepay.Value;
            }

            var minFundingPriority = (dealDC.PayruleNoteDetailFundingList.Min(x => x.FundingPriority)).GetValueOrDefault(0);
            var maxFundingSequence = (dealDC.PayruleNoteAMSequenceList.Where(y => y.SequenceTypeText == "Funding Sequence").Max(x => x.SequenceNo)).GetValueOrDefault(0);

            var maxRepaymentPriority = (dealDC.PayruleNoteDetailFundingList.Max(x => x.RepaymentPriority)).GetValueOrDefault(0);
            dealDC.PayruleNoteDetailFundingList.Where(x => x.RepaymentPriority == null).ToList().ForEach(i => i.RepaymentPriority = maxRepaymentPriority + 1);
            maxRepaymentPriority = (dealDC.PayruleNoteDetailFundingList.Max(x => x.RepaymentPriority)).GetValueOrDefault(0);
            dealDC.PayruleNoteDetailFundingList = dealDC.PayruleNoteDetailFundingList.Where(x => x.UseRuletoDetermineNoteFundingText == "Y" || x.UseRuletoDetermineNoteFundingText == "3").OrderBy(y => y.FundingPriority).ThenBy(z => z.RepaymentPriority).ToList();
            var minRepaymentPriority = (dealDC.PayruleNoteDetailFundingList.Min(x => x.RepaymentPriority)).GetValueOrDefault(0);
            var maxRepaymentSequence = (dealDC.PayruleNoteAMSequenceList.Where(y => y.SequenceTypeText == "Repayment Sequence").Max(x => x.SequenceNo)).GetValueOrDefault(0);

            CalculateRatio(minFundingPriority, maxFundingPriority, maxFundingSequence, minRepaymentPriority, maxRepaymentPriority, maxRepaymentSequence);

            //assign Applied true/false according to Funding date applied
            for (int i = 0; i < dealDC.PayruleDealFundingList.Count; i++)
            {
                if (dealDC.PayruleDealFundingList[i].Applied == true)
                {
                    dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.DealFundingRowno == dealDC.PayruleDealFundingList[i].DealFundingRowno).ToList().ForEach(z => z.Applied = true);
                }
                else
                {
                    dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.DealFundingRowno == dealDC.PayruleDealFundingList[i].DealFundingRowno).ToList().ForEach(z => z.Applied = false);
                }
            }

            //assign Additional Funding and Repayment balance
            for (int i = 0; i < dealDC.PayruleNoteDetailFundingList.Count; i++)
            {
                dealDC.PayruleNoteDetailFundingList[i].AdditionalBalance = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[i].NoteID && x.Applied == true && x.Value > 0).Sum(x => x.Value);

                dealDC.PayruleNoteDetailFundingList[i].AdditionalRepaymentBalance = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[i].NoteID && x.Applied == true && x.Value < 0).Sum(x => x.Value);
            }

            //assign current PayruleTargetNoteFundingScheduleList in temp
            PayruleTargetNoteFundingScheduleListTemp = dealDC.PayruleTargetNoteFundingScheduleList;

            CalcNotePercentage(maxFundingSequence, maxFundingPriority, maxRepaymentSequence, maxRepaymentPriority);
            GroupByList();

            //CreateCSVFile(ToDataSet(dealDC.PayruleTargetNoteFundingScheduleList).Tables[0], "PayruleTargetNoteFundingScheduleListBeforeRounding");

            //commented by Samrat for distribution testing
            //SettleAmountByRoundingRule();
            //   CreateCSVFile(ToDataSet(dealDC.PayruleTargetNoteFundingScheduleList).Tables[0], "PayruleTargetNoteFundingScheduleListAfterRounding");

            //code remove Wire confirmed Note row from PayruleTargetNoteFundingScheduleList
            PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Where(x => x.Applied != true).ToList();

            var tmpPayruleTargetNoteFundingScheduleListTemp = PayruleTargetNoteFundingScheduleListTemp.Where(x => x.Applied == true).ToList();
            PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Concat(tmpPayruleTargetNoteFundingScheduleListTemp).ToList();

            //dealDC.PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Where(x => x.Value > 0 || x.Value < 0).ToList();

            //commented by Samrat for distribution testing
            SettleAmountByRoundingRule();

            ////code remove Paydown with comment Note row and assign initial values from PayruleTargetNoteFundingScheduleListTemp to PayruleTargetNoteFundingScheduleList
            if (dealDC.ApplyNoteLevelPaydowns == true)
            {
                PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Where(x => (x.PurposeID != 631) || (x.PurposeID == 631 && x.Comments != "")).ToList();
                var tmpPayruleTargetNoteFundingScheduleListTempPaydown = PayruleTargetNoteFundingScheduleListTemp.Where(x => x.PurposeID == 631 && x.Comments == "").ToList();

                PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Concat(tmpPayruleTargetNoteFundingScheduleListTempPaydown).ToList();
            }

            PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Where(x => x.Value > 0 || x.Value < 0).ToList();

            //code for allow 0 funding in Deal funding
            if (dealDC.PayruleDealFundingList.Where(x => x.Value1 == 0).Count() > 0)
            {
                foreach (var _dealFunding in dealDC.PayruleDealFundingList.Where(x => x.Value1 == 0))
                {
                    foreach (var fun in dealDC.PayruleNoteDetailFundingList)
                    {
                        PayruleTargetNoteFundingScheduleDataContract PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                        PayruleTargetNoteFundingScheduleDataContract.DealFundingID = _dealFunding.DealFundingID;
                        PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                        PayruleTargetNoteFundingScheduleDataContract.Date = _dealFunding.Date;
                        PayruleTargetNoteFundingScheduleDataContract.NoteID = fun.NoteID;
                        PayruleTargetNoteFundingScheduleDataContract.PurposeID = _dealFunding.PurposeID;
                        PayruleTargetNoteFundingScheduleDataContract.Purpose = _dealFunding.PurposeText;
                        PayruleTargetNoteFundingScheduleDataContract.Applied = _dealFunding.Applied;
                        PayruleTargetNoteFundingScheduleDataContract.AdjustmentType = _dealFunding.AdjustmentType;
                        PayruleTargetNoteFundingScheduleDataContract.DrawFundingId = _dealFunding.DrawFundingId;
                        PayruleTargetNoteFundingScheduleDataContract.Comments = _dealFunding.Comment;
                        PayruleTargetNoteFundingScheduleDataContract.DealFundingRowno = _dealFunding.DealFundingRowno;
                        PayruleTargetNoteFundingScheduleList.Add(PayruleTargetNoteFundingScheduleDataContract);
                    }
                }
            }

            //foreach (var Payrule in PayruleTargetNoteFundingScheduleList)
            //{

            //}

            dealDC.PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList;
        }

        public void CalculateRatio(int minFundingPriority, int maxFundingPriority, int maxFundingSequence, int minRepaymentPriority, int maxRepaymentPriority, int maxRepaymentSequence)
        {
            Decimal? sum = 0;

            #region FundingRatio

            for (int i = minFundingPriority; i <= maxFundingPriority; i++) //Funding Priority
            {
                for (int y = 1; y <= maxFundingSequence; y++) //Funding Sequence
                {
                    sum = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == y && a.SequenceTypeText == "Funding Sequence") join t in dealDC.PayruleNoteDetailFundingList.Where(b => b.FundingPriority == i) on x.NoteID equals t.NoteID select x.Value.GetValueOrDefault(0)).Sum();
                    if (sum != 0)
                    {
                        dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Funding Sequence" && ((from id in dealDC.PayruleNoteDetailFundingList where id.FundingPriority == i && id.NoteID == x.NoteID select true).FirstOrDefault()) == true)
                            .ToList().ForEach(r => r.Ratio = r.Value.GetValueOrDefault(0) / sum);
                    }

                    foreach (var payruleNoteAMSequence in dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Funding Sequence"))
                    {
                        //Math.Round((Decimal)(from val in dealDC.PayruleNoteAMSequenceList * val.Ratio).FirstOrDefault(), precisionCount);
                        //payruleNoteAMSequence.Ratio = payruleNoteAMSequence.Value / sum;

                        //changed by Samrat
                        payruleNoteAMSequence.Ratio = Math.Round(Convert.ToDecimal(payruleNoteAMSequence.Ratio), 10); //10
                    }

                    var seqSum = dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Funding Sequence").Sum(z => z.Ratio);

                    if (seqSum > 1)
                    {
                        int cntSeq = dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Funding Sequence").Count();
                        dealDC.PayruleNoteAMSequenceList[cntSeq].Ratio = dealDC.PayruleNoteAMSequenceList[cntSeq].Ratio - (seqSum - 1);
                    }
                    else if (seqSum < 1)
                    {
                        int cntSeq = dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Funding Sequence").Count();
                        dealDC.PayruleNoteAMSequenceList[cntSeq].Ratio = dealDC.PayruleNoteAMSequenceList[cntSeq].Ratio + (1 - seqSum);
                    }
                }
            }

            #endregion FundingRatio

            #region RepaymentRatio

            for (int i = minRepaymentPriority; i <= maxRepaymentPriority; i++) //Repayment Priority
            {
                for (int y = 1; y <= maxRepaymentSequence; y++) //Repayment Sequence
                {
                    sum = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == y && a.SequenceTypeText == "Repayment Sequence") join t in dealDC.PayruleNoteDetailFundingList.Where(b => b.RepaymentPriority == i) on x.NoteID equals t.NoteID select x.Value.GetValueOrDefault(0)).Sum();
                    if (sum != 0)
                    {
                        dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == y && x.SequenceTypeText == "Repayment Sequence" && ((from id in dealDC.PayruleNoteDetailFundingList where id.RepaymentPriority == i && id.NoteID == x.NoteID select true).FirstOrDefault()) == true)
                        .ToList().ForEach(r => r.Ratio = r.Value.GetValueOrDefault(0) / sum);
                    }
                }
            }

            #endregion RepaymentRatio
        }

        public void CalcNotePercentage(int maxFundingSequence, int maxFundingPriority, int maxRepaymentSequence, int maxRepaymentPriority)
        {
            Decimal? sumFunding = 0, usedFunding = 0, totalFundingSequence = 0, sumRepayment = 0, usedRepayment = 0, totalRepaymentSequence = 0;
            int minFundingSequence = 1, minRepaymentSequence = 1;
            PayruleTargetNoteFundingScheduleDataContract PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();

            //bool isOrderBY = true;
            //foreach (var funding in dealDC.PayruleDealFundingList.Where(x => x.Value.GetValueOrDefault(0) != 0).ToList())
            //{
            //    for (int i = minFundingSequence; i <= maxFundingSequence && funding.Value != 0; i++)
            //    {
            //        for (int j = 1; j <= maxFundingPriority && funding.Value != 0; j++)
            //        {
            //            sumFunding = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Funding Sequence") join t in dealDC.PayruleNoteDetailFundingList.Where(b => b.FundingPriority == j) on x.NoteID equals t.NoteID select x.Value.GetValueOrDefault(0)).Sum();

            //            if (sumFunding == new decimal(.01))
            //            {
            //                isOrderBY = false;
            //                break;
            //            }
            //        }
            //     }
            //}

            List<PayruleNoteAMSequenceDataContract> _lstPayruleNoteAMSequenceDataContractWithZeroVal = dealDC.PayruleNoteAMSequenceList.Where(x => x.Value == 0 && x.SequenceTypeText == "Funding Sequence").ToList();

            bool wireconfirnSettelmentFlag = true;
            int arrFundingIndex = -1;
            foreach (var funding in dealDC.PayruleDealFundingList.Where(x => x.Value.GetValueOrDefault(0) != 0).ToList())
            {
                arrFundingIndex++;

                if (funding.Applied != true && wireconfirnSettelmentFlag == true)
                {
                    wireconfirnSettelmentFlag = false;
                    //check wire confirm funding exists
                    if (dealDC.PayruleDealFundingList.Where(x => x.Value1 > 0 && x.Applied == true).Sum(y => y.Value1) > 0)
                    {
                        //PayruleTargetNoteFundingScheduleListTemp
                        foreach (var _noteFunding in dealDC.PayruleNoteDetailFundingList)
                        {
                            decimal? noteFundingScheduleListTemp = PayruleTargetNoteFundingScheduleListTemp.Where(x => x.NoteID == _noteFunding.NoteID && x.Applied == true && x.Value > 0).Sum(y => y.Value);

                            decimal? noteFundingScheduleList = PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == _noteFunding.NoteID && x.Applied == true && x.Value > 0).Sum(y => y.Value);
                            if (_noteFunding.NoteID.ToString() == "93b66fdc-98f6-4bbb-be29-51f8581cc57f") // "ed374b47-1996-4465-a619-51f72d890f71")
                            {

                            }

                            if (noteFundingScheduleListTemp != noteFundingScheduleList)
                            {
                                //if (noteFundingScheduleListTemp > noteFundingScheduleList)
                                // check note all funding sequence and increase/decrease locked amount  
                                for (int i = 1; i <= dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == _noteFunding.NoteID && x.SequenceTypeText == "Funding Sequence").Count(); i++)
                                {
                                    PayruleNoteAMSequenceDataContract _NoteAMSequenceDataContract = dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == _noteFunding.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence").FirstOrDefault();
                                    if (_NoteAMSequenceDataContract.Value != 0) //(_NoteAMSequenceDataContract.Value > noteFundingScheduleListTemp)
                                    {
                                        _NoteAMSequenceDataContract.Value += (noteFundingScheduleList - noteFundingScheduleListTemp);
                                        break;
                                    }
                                    else if (i == dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == _noteFunding.NoteID && x.SequenceTypeText == "Funding Sequence").Count())
                                    {
                                        _NoteAMSequenceDataContract.Value += (noteFundingScheduleList - noteFundingScheduleListTemp);
                                        break;
                                    }
                                }


                            }
                        }

                    }
                }

                #region FundingCalcuation

                if (funding.Value.GetValueOrDefault(0) > 0)
                {


                    for (int i = minFundingSequence; i <= maxFundingSequence && funding.Value != 0; i++)
                    {
                        totalFundingSequence = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Funding Sequence") select x.Value.GetValueOrDefault(0)).Sum();
                        for (int j = 1; j <= maxFundingPriority && funding.Value != 0; j++)
                        {
                            PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                            sumFunding = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Funding Sequence") join t in dealDC.PayruleNoteDetailFundingList.Where(b => b.FundingPriority == j) on x.NoteID equals t.NoteID select x.Value.GetValueOrDefault(0)).Sum();

                            //var list = dealDC.PayruleNoteDetailFundingList.Where(p => p.FundingPriority == j && p.TotalCommitment>0 ).OrderBy(x=>x.FundingPriority).ToList();

                            //var list = dealDC.PayruleNoteDetailFundingList.Where(p => p.FundingPriority == j && p.TotalCommitment > 0).OrderBy(x => x.FundingPriority).OrderByDescending(v => v.RepaymentPriority).ToList();
                            var list = (from dw in dealDC.PayruleNoteDetailFundingList orderby dw.FundingPriority, dw.CommitmentUsedInFFDistribution, dw.CRENoteID, dw.NoteName where dw.FundingPriority == j && dw.CommitmentUsedInFFDistribution > 0 select dw).ToList();

                            usedFunding = 0;
                            foreach (var lst in list)
                            {
                                PayruleNoteAMSequenceDataContract _noteAMSequence = dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence").FirstOrDefault();

                                if (_lstPayruleNoteAMSequenceDataContractWithZeroVal != null && _lstPayruleNoteAMSequenceDataContractWithZeroVal.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence").Count() > 0)
                                {

                                }
                                //else if (_noteAMSequence.Value == 0)
                                //{

                                //}
                                else
                                {
                                    if (lst.NoteID.ToString() == "347d3ab1-9b5b-49ec-bfa6-0955e99abb31")
                                    {

                                    }
                                    if (sumFunding == new decimal(.01) && funding.Value > 1)
                                    {
                                        funding.Value += sumFunding;
                                        sumFunding = 0;
                                    }

                                    PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                                    if (sumFunding <= funding.Value)
                                    {
                                        PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence") select val.Value.GetValueOrDefault(0)).FirstOrDefault(), 2);
                                        //New code for stop assign -ve value
                                        if (PayruleTargetNoteFundingScheduleDataContract.Value < 0)
                                        {
                                            PayruleTargetNoteFundingScheduleDataContract.Value = 0;

                                        }
                                        else if (PayruleTargetNoteFundingScheduleDataContract.Value <= new decimal(.01) && funding.Value > 1)
                                        {
                                            funding.Value -= PayruleTargetNoteFundingScheduleDataContract.Value;
                                            PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                        }

                                        //Old code
                                        /*
                                        if (PayruleTargetNoteFundingScheduleDataContract.Value <= new decimal(.01) && funding.Value > 1)
                                        {
                                            funding.Value -= PayruleTargetNoteFundingScheduleDataContract.Value;
                                            PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                        }
                                        */
                                    }
                                    else
                                    {
                                        PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence") select (funding.Value.GetValueOrDefault(0) + usedFunding) * val.Ratio).FirstOrDefault(), 2);

                                        if (PayruleTargetNoteFundingScheduleDataContract.Value <= 0)
                                        {
                                            PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence") select val.Value.GetValueOrDefault(0)).FirstOrDefault(), 2);
                                        }
                                    }

                                    if (PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0) <= funding.Value.GetValueOrDefault(0))
                                    {
                                        funding.Value = funding.Value.GetValueOrDefault(0) - Math.Round(PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 4);

                                        //==funding.Value = Math.Round(funding.Value.GetValueOrDefault(0) - Math.Round(PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 2), 2);
                                        //if (funding.Value == new decimal(.01) && PayruleTargetNoteFundingScheduleDataContract.Value > new decimal(.01))

                                        if (funding.Value == new decimal(.01) && PayruleTargetNoteFundingScheduleDataContract.Value > 1)
                                        {
                                            PayruleTargetNoteFundingScheduleDataContract.Value += funding.Value;
                                            funding.Value = 0;
                                            //   PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                        }
                                    }
                                    else
                                    {
                                        PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round(funding.Value.GetValueOrDefault(0), 2);
                                        funding.Value = funding.Value.GetValueOrDefault(0) - PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    }
                                    sumFunding = sumFunding - PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == i && x.SequenceTypeText == "Funding Sequence" && x.NoteID == lst.NoteID).ToList().ForEach(r => r.Value = r.Value - PayruleTargetNoteFundingScheduleDataContract.Value);
                                    usedFunding = usedFunding + PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    totalFundingSequence = totalFundingSequence - PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                    if (Math.Round(PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 2) != 0)
                                    {
                                        /*

                                        #region Code for reassign values after wireconfirm sequence

                                        PayruleTargetNoteFundingScheduleDataContract objPayruleTargetNoteFundingCurrent = new PayruleTargetNoteFundingScheduleDataContract();
                                        //objPayruleTargetNoteFunding = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.Applied == true & x.NoteID == lst.NoteID ).SingleOrDefault();

                                        if ((dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == lst.NoteID).ToList()).Count() > arrFundingIndex)
                                        {
                                            objPayruleTargetNoteFundingCurrent = (dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == lst.NoteID).ToList()).ElementAt(arrFundingIndex);
                                        }

                                        if (funding.Applied == true)
                                        {
                                            //objPayruleTargetNoteFunding = dealDC.PayruleTargetNoteFundingScheduleList.ElementAt(arrFundingIndex);

                                            if (objPayruleTargetNoteFundingCurrent != null)
                                            {
                                                if (PayruleTargetNoteFundingScheduleDataContract.Value != objPayruleTargetNoteFundingCurrent.Value)
                                                {
                                                    List<PayruleNoteDetailFundingDataContract> lstPayruleNoteDetailFunding = new List<PayruleNoteDetailFundingDataContract>();
                                                    lstPayruleNoteDetailFunding = dealDC.PayruleNoteDetailFundingList.Where(x => x.NoteID == lst.NoteID).ToList();
                                                    //check for null and assign 0
                                                    lstPayruleNoteDetailFunding[0].AdditionalBalance = lstPayruleNoteDetailFunding[0].AdditionalBalance == null ? 0 : lstPayruleNoteDetailFunding[0].AdditionalBalance;

                                                    lstPayruleNoteDetailFunding[0].AdditionalBalance += PayruleTargetNoteFundingScheduleDataContract.Value - objPayruleTargetNoteFundingCurrent.Value ;

                                                    PayruleTargetNoteFundingScheduleDataContract.Value = objPayruleTargetNoteFundingCurrent.Value;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            List<PayruleNoteDetailFundingDataContract> lstPayruleNoteDetailFunding = new List<PayruleNoteDetailFundingDataContract>();
                                            lstPayruleNoteDetailFunding = dealDC.PayruleNoteDetailFundingList.Where(x => x.NoteID == lst.NoteID).ToList();
                                            //==lstPayruleNoteDetailFunding[0].AdditionalBalance += objPayruleTargetNoteFundingCurrent.Value - PayruleTargetNoteFundingScheduleDataContract.Value;

                                            //check for null and assign 0
                                            lstPayruleNoteDetailFunding[0].AdditionalBalance = lstPayruleNoteDetailFunding[0].AdditionalBalance == null ? 0 : lstPayruleNoteDetailFunding[0].AdditionalBalance;

                                            if (lstPayruleNoteDetailFunding[0].AdditionalBalance !=0)
                                            {
                                                if (funding.Value >= lstPayruleNoteDetailFunding[0].AdditionalBalance)
                                                {
                                                   PayruleTargetNoteFundingScheduleDataContract.Value += lstPayruleNoteDetailFunding[0].AdditionalBalance;
                                                    //
                                                    if (PayruleTargetNoteFundingScheduleDataContract.Value < 0)
                                                    {
                                                        lstPayruleNoteDetailFunding[0].AdditionalBalance = lstPayruleNoteDetailFunding[0].AdditionalBalance - (PayruleTargetNoteFundingScheduleDataContract.Value);
                                                        PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                                    }
                                                    else if (PayruleTargetNoteFundingScheduleDataContract.Value > funding.Value)
                                                    {
                                                        lstPayruleNoteDetailFunding[0].AdditionalBalance += PayruleTargetNoteFundingScheduleDataContract.Value - funding.Value;
                                                        PayruleTargetNoteFundingScheduleDataContract.Value = funding.Value;
                                                        funding.Value = 0;
                                                    }
                                                    else
                                                    {
                                                        lstPayruleNoteDetailFunding[0].AdditionalBalance = 0;
                                                        PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                                    }
                                                }
                                                else
                                                {
                                                    PayruleTargetNoteFundingScheduleDataContract.Value += funding.Value;
                                                    lstPayruleNoteDetailFunding[0].AdditionalBalance -= funding.Value;
                                                }
                                            }
                                        }

                                        #endregion Code for reassign values after wireconfirm sequence

                                        */
                                        PayruleTargetNoteFundingScheduleDataContract.DealFundingID = funding.DealFundingID;
                                        PayruleTargetNoteFundingScheduleDataContract.Date = funding.Date;
                                        PayruleTargetNoteFundingScheduleDataContract.NoteID = lst.NoteID;
                                        PayruleTargetNoteFundingScheduleDataContract.PurposeID = funding.PurposeID;
                                        PayruleTargetNoteFundingScheduleDataContract.Purpose = funding.PurposeText;
                                        PayruleTargetNoteFundingScheduleDataContract.Applied = funding.Applied;
                                        PayruleTargetNoteFundingScheduleDataContract.AdjustmentType = funding.AdjustmentType;
                                        PayruleTargetNoteFundingScheduleDataContract.DrawFundingId = funding.DrawFundingId;
                                        PayruleTargetNoteFundingScheduleDataContract.Comments = funding.Comment;
                                        PayruleTargetNoteFundingScheduleDataContract.DealFundingRowno = funding.DealFundingRowno;
                                        PayruleTargetNoteFundingScheduleList.Add(PayruleTargetNoteFundingScheduleDataContract);
                                    }
                                }
                            }
                        }
                        if (totalFundingSequence == 0)
                            minFundingSequence = minFundingSequence + 1;
                    }

                    if (minFundingSequence >= maxFundingSequence)
                    {
                        int count = dealDC.PayruleNoteDetailFundingList.Count();
                        if (count > 0)
                        {
                            if (Math.Round(Math.Abs(funding.Value.GetValueOrDefault(0) / count), 2) > 0)
                            {
                                foreach (var fun in dealDC.PayruleNoteDetailFundingList)
                                {
                                    PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                                    PayruleTargetNoteFundingScheduleDataContract.DealFundingID = funding.DealFundingID;
                                    PayruleTargetNoteFundingScheduleDataContract.Value = funding.Value.GetValueOrDefault(0) / count;
                                    PayruleTargetNoteFundingScheduleDataContract.Date = funding.Date;
                                    PayruleTargetNoteFundingScheduleDataContract.NoteID = fun.NoteID;
                                    PayruleTargetNoteFundingScheduleDataContract.PurposeID = funding.PurposeID;
                                    PayruleTargetNoteFundingScheduleDataContract.Purpose = funding.PurposeText;
                                    PayruleTargetNoteFundingScheduleDataContract.Applied = funding.Applied;
                                    PayruleTargetNoteFundingScheduleDataContract.AdjustmentType = funding.AdjustmentType;
                                    PayruleTargetNoteFundingScheduleDataContract.DealFundingRowno = funding.DealFundingRowno;
                                    PayruleTargetNoteFundingScheduleDataContract.DrawFundingId = funding.DrawFundingId;
                                    PayruleTargetNoteFundingScheduleDataContract.Comments = funding.Comment;
                                    PayruleTargetNoteFundingScheduleList.Add(PayruleTargetNoteFundingScheduleDataContract);
                                }
                            }
                        }
                    }
                }

                #endregion FundingCalcuation

                #region RepaymentCalcuation

                if (funding.Value.GetValueOrDefault(0) < 0)
                {
                    for (int i = minRepaymentSequence; i <= maxRepaymentSequence && funding.Value != 0; i++)
                    {
                        totalRepaymentSequence = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Repayment Sequence") select x.Value.GetValueOrDefault(0)).Sum();
                        for (int j = 1; j <= maxRepaymentPriority && funding.Value != 0; j++)
                        {
                            PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                            sumRepayment = (from x in dealDC.PayruleNoteAMSequenceList.Where(a => a.SequenceNo == i && a.SequenceTypeText == "Repayment Sequence") join t in dealDC.PayruleNoteDetailFundingList.Where(b => b.RepaymentPriority == j) on x.NoteID equals t.NoteID select x.Value.GetValueOrDefault(0)).Sum();
                            var list = dealDC.PayruleNoteDetailFundingList.Where(p => p.RepaymentPriority == j).ToList();

                            usedRepayment = 0;
                            foreach (var lst in list)
                            {
                                PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                                if (sumRepayment <= funding.Value * -1)
                                {
                                    PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Repayment Sequence") select val.Value.GetValueOrDefault(0) * (-1)).FirstOrDefault(), 2);
                                }
                                else
                                {
                                    PayruleTargetNoteFundingScheduleDataContract.Value = Math.Round((Decimal)(from val in dealDC.PayruleNoteAMSequenceList.Where(x => x.NoteID == lst.NoteID && x.SequenceNo == i && x.SequenceTypeText == "Repayment Sequence") select (funding.Value.GetValueOrDefault(0) + usedRepayment * (-1)) * val.Ratio).FirstOrDefault(), 2);
                                }
                                //funding.Value = funding.Value.GetValueOrDefault(0) - PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                if (PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0) >= funding.Value.GetValueOrDefault(0))
                                {
                                    funding.Value = funding.Value.GetValueOrDefault(0) - Math.Round(PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0), 2);
                                    if (funding.Value * -1 == new decimal(.01))
                                    {
                                        PayruleTargetNoteFundingScheduleDataContract.Value += funding.Value;
                                        funding.Value = 0;
                                        //   PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                    }
                                }
                                else
                                {
                                    PayruleTargetNoteFundingScheduleDataContract.Value = funding.Value.GetValueOrDefault(0);
                                    funding.Value = funding.Value.GetValueOrDefault(0) - PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                }

                                sumRepayment = sumRepayment - (-1) * PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                dealDC.PayruleNoteAMSequenceList.Where(x => x.SequenceNo == i && x.SequenceTypeText == "Repayment Sequence" && x.NoteID == lst.NoteID).ToList().ForEach(r => r.Value = r.Value - (-1) * PayruleTargetNoteFundingScheduleDataContract.Value);
                                usedRepayment = usedRepayment + (-1) * PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                totalRepaymentSequence = totalRepaymentSequence - (-1) * PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0);
                                if (Math.Round(PayruleTargetNoteFundingScheduleDataContract.Value.GetValueOrDefault(0)) != 0)
                                {
                                    /*

                                    #region Code for reassign values after wireconfirm Repayment

                                    PayruleTargetNoteFundingScheduleDataContract objPayruleTargetNoteFundingCurrent = new PayruleTargetNoteFundingScheduleDataContract();
                                    //objPayruleTargetNoteFunding = dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.Applied == true & x.NoteID == lst.NoteID ).SingleOrDefault();

                                    if ((dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == lst.NoteID).ToList()).Count() > arrFundingIndex)
                                    {
                                        objPayruleTargetNoteFundingCurrent = (dealDC.PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == lst.NoteID).ToList()).ElementAt(arrFundingIndex);
                                    }

                                    if (funding.Applied == true)
                                    {
                                        //objPayruleTargetNoteFunding = dealDC.PayruleTargetNoteFundingScheduleList.ElementAt(arrFundingIndex);

                                        if (objPayruleTargetNoteFundingCurrent != null)
                                        {
                                            if (PayruleTargetNoteFundingScheduleDataContract.Value != objPayruleTargetNoteFundingCurrent.Value)
                                            {
                                                List<PayruleNoteDetailFundingDataContract> lstPayruleNoteDetailFunding = new List<PayruleNoteDetailFundingDataContract>();
                                                lstPayruleNoteDetailFunding = dealDC.PayruleNoteDetailFundingList.Where(x => x.NoteID == lst.NoteID).ToList();
                                                //check for null and assign 0
                                                lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance = lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance == null ? 0 : lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance;

                                                lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance += PayruleTargetNoteFundingScheduleDataContract.Value - objPayruleTargetNoteFundingCurrent.Value;

                                                PayruleTargetNoteFundingScheduleDataContract.Value = objPayruleTargetNoteFundingCurrent.Value;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        List<PayruleNoteDetailFundingDataContract> lstPayruleNoteDetailFunding = new List<PayruleNoteDetailFundingDataContract>();
                                        lstPayruleNoteDetailFunding = dealDC.PayruleNoteDetailFundingList.Where(x => x.NoteID == lst.NoteID).ToList();
                                        //==lstPayruleNoteDetailFunding[0].AdditionalBalance += objPayruleTargetNoteFundingCurrent.Value - PayruleTargetNoteFundingScheduleDataContract.Value;

                                        //check for null and assign 0
                                        lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance = lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance == null ? 0 : lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance;

                                        if (lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance != 0)
                                        {
                                            if (-funding.Value >= -lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance)
                                            {
                                                PayruleTargetNoteFundingScheduleDataContract.Value -= lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance;
                                                //
                                                if (PayruleTargetNoteFundingScheduleDataContract.Value > 0)
                                                {
                                                    lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance = lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance + (PayruleTargetNoteFundingScheduleDataContract.Value);
                                                    PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                                }
                                                else if (-PayruleTargetNoteFundingScheduleDataContract.Value > -funding.Value)
                                                {
                                                    lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance += PayruleTargetNoteFundingScheduleDataContract.Value - funding.Value;
                                                    PayruleTargetNoteFundingScheduleDataContract.Value = funding.Value;
                                                    //funding.Value = -142;
                                                }
                                                else
                                                {
                                                    lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance = 0;
                                                    PayruleTargetNoteFundingScheduleDataContract.Value = 0;
                                                }
                                            }
                                            else
                                            {
                                                PayruleTargetNoteFundingScheduleDataContract.Value += funding.Value;
                                                lstPayruleNoteDetailFunding[0].AdditionalRepaymentBalance -= funding.Value;
                                            }
                                        }
                                    }

                                    #endregion Code for reassign values after wireconfirm Repayment

                                    */
                                    PayruleTargetNoteFundingScheduleDataContract.DealFundingID = funding.DealFundingID;
                                    PayruleTargetNoteFundingScheduleDataContract.Date = funding.Date;
                                    PayruleTargetNoteFundingScheduleDataContract.NoteID = lst.NoteID;
                                    PayruleTargetNoteFundingScheduleDataContract.PurposeID = funding.PurposeID;
                                    PayruleTargetNoteFundingScheduleDataContract.Purpose = funding.PurposeText;
                                    PayruleTargetNoteFundingScheduleDataContract.Applied = funding.Applied;
                                    PayruleTargetNoteFundingScheduleDataContract.AdjustmentType = funding.AdjustmentType;
                                    PayruleTargetNoteFundingScheduleDataContract.DrawFundingId = funding.DrawFundingId;
                                    PayruleTargetNoteFundingScheduleDataContract.Comments = funding.Comment;
                                    PayruleTargetNoteFundingScheduleDataContract.DealFundingRowno = funding.DealFundingRowno;
                                    PayruleTargetNoteFundingScheduleList.Add(PayruleTargetNoteFundingScheduleDataContract);
                                }
                            }
                        }
                        if (totalRepaymentSequence == 0)
                            minRepaymentSequence = minRepaymentSequence + 1;
                    }

                    if (minRepaymentSequence > maxRepaymentSequence)
                    {
                        int count = dealDC.PayruleNoteDetailFundingList.Count();
                        if (count > 0)
                        {
                            if (Math.Round(Math.Abs(funding.Value.GetValueOrDefault(0) / count), 2) > 0)
                            {
                                foreach (var fun in dealDC.PayruleNoteDetailFundingList)
                                {
                                    PayruleTargetNoteFundingScheduleDataContract = new PayruleTargetNoteFundingScheduleDataContract();
                                    PayruleTargetNoteFundingScheduleDataContract.DealFundingID = funding.DealFundingID;
                                    PayruleTargetNoteFundingScheduleDataContract.Value = funding.Value.GetValueOrDefault(0) / count;
                                    PayruleTargetNoteFundingScheduleDataContract.Date = funding.Date;
                                    PayruleTargetNoteFundingScheduleDataContract.NoteID = fun.NoteID;
                                    PayruleTargetNoteFundingScheduleDataContract.PurposeID = funding.PurposeID;
                                    PayruleTargetNoteFundingScheduleDataContract.Purpose = funding.PurposeText;
                                    PayruleTargetNoteFundingScheduleDataContract.Applied = funding.Applied;
                                    PayruleTargetNoteFundingScheduleDataContract.AdjustmentType = funding.AdjustmentType;
                                    PayruleTargetNoteFundingScheduleDataContract.DrawFundingId = funding.DrawFundingId;
                                    PayruleTargetNoteFundingScheduleDataContract.Comments = funding.Comment;
                                    PayruleTargetNoteFundingScheduleDataContract.DealFundingRowno = funding.DealFundingRowno;
                                    PayruleTargetNoteFundingScheduleList.Add(PayruleTargetNoteFundingScheduleDataContract);
                                }
                            }
                        }
                    }
                }

                #endregion RepaymentCalcuation
            }
        }

        public void GroupByList()
        {
            PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.GroupBy(c => new { c.NoteID, c.DealFundingRowno, c.Date, c.PurposeID, c.Purpose, c.Applied, c.Comments, c.NonCommitmentAdj, c.DrawFundingId, c.DealFundingID }).Select(val => new PayruleTargetNoteFundingScheduleDataContract
            {
                NoteID = val.Key.NoteID,
                Date = val.Key.Date,
                PurposeID = val.Key.PurposeID,
                Purpose = val.Key.Purpose,
                Applied = val.Key.Applied,
                Comments = val.Key.Comments,
                NonCommitmentAdj = val.Key.NonCommitmentAdj,
                DrawFundingId = val.Key.DrawFundingId,
                DealFundingRowno = val.Key.DealFundingRowno,
                DealFundingID = val.Key.DealFundingID,
                Value = val.Sum(v => v.Value)
            }).ToList();

            //Order by
            //  PayruleTargetNoteFundingScheduleList = PayruleTargetNoteFundingScheduleList.OrderBy(b => dealDC.PayruleNoteAMSequenceList.FindIndex(a => a.NoteID == b.NoteID)).ToList();
        }

        public void SettleAmountByRoundingRule()
        {
            bool _isPennyDifference = false;
            //if (dealDC.PayruleDealFundingList.Sum(x => x.Value1) == PayruleTargetNoteFundingScheduleList.Sum(x => x.Value))
            //{
            //    return;
            //}

            //check all row deal and note funding sum 
            foreach (var lst in dealDC.PayruleDealFundingList)
            {
                if (lst.Value1 != PayruleTargetNoteFundingScheduleList.Where(x => x.DealFundingRowno == lst.DealFundingRowno).Sum(x => x.Value))
                {
                    _isPennyDifference = true;
                    break;
                }
            }

            if (_isPennyDifference)
            {
                decimal totalFundingSequence = 0, totalNoteFunding = 0, totalRepaymentSequence = 0, totalNoteRepayment = 0;
                DateTime maxFundingDate = default(DateTime), maxRepaymentDate = default(DateTime);
                PayruleTargetNoteFundingScheduleList.ForEach(x => x.Value = Convert.ToDecimal(Math.Round(Convert.ToDouble(x.Value), 2)));
                dealDC.PayruleNoteDetailFundingList = dealDC.PayruleNoteDetailFundingList.OrderBy(x => x.CommitmentUsedInFFDistribution).ThenBy(n => n.CRENoteID).ToList();
                dealDC.PayruleNoteDetailFundingList = dealDC.PayruleNoteDetailFundingList.Where(note => PayruleTargetNoteFundingScheduleList.Any(deal => deal.NoteID == note.NoteID)).ToList();
                decimal sumNote = 0, diffNoteDeal = 0, j = 0;
                bool isRepayment = false;
                //CreateCSVFile(ToDataSet(PayruleTargetNoteFundingScheduleList).Tables[0], "Before");
                var list = dealDC.PayruleNoteDetailFundingList.Where(p => p.FundingPriority == j).ToList();
                foreach (var val in PayruleDealFundingList)
                {

                    if (val.Value < 0)//chck negative Funding
                    {
                        isRepayment = true;
                    }

                    if (val.Value >= 0)//Funding
                    {
                        sumNote = PayruleTargetNoteFundingScheduleList.Where(y => y.DealFundingRowno == val.DealFundingRowno && y.Value >= 0).Sum(x => x.Value.GetValueOrDefault(0));
                        diffNoteDeal = val.Value.GetValueOrDefault(0) - sumNote;
                        // PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[dealDC.PayruleNoteDetailFundingList.Count - 1].NoteID && x.DealFundingRowno == val.DealFundingRowno && x.Value >= 0).ToList().ForEach(v => v.Value = v.Value + diffNoteDeal);
                        var TotalNoteVal = PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[dealDC.PayruleNoteDetailFundingList.Count - 1].NoteID).Sum(x => x.Value.GetValueOrDefault(0));
                        PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[dealDC.PayruleNoteDetailFundingList.Count - 1].NoteID && x.Date == val.Date && x.DealFundingRowno == val.DealFundingRowno && x.Value >= 0).ToList().ForEach(v => v.Value = v.Value + diffNoteDeal);
                    }
                    else //Repayment
                    {
                        if (isRepayment == true)
                        {
                            sumNote = PayruleTargetNoteFundingScheduleList.Where(y => y.DealFundingRowno == val.DealFundingRowno && y.Value < 0).Sum(x => x.Value.GetValueOrDefault(0));
                            diffNoteDeal = val.Value.GetValueOrDefault(0) - sumNote;
                            //  PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[dealDC.PayruleNoteDetailFundingList.Count - 1].NoteID && x.DealFundingRowno == val.DealFundingRowno && x.Value < 0).ToList().ForEach(v => v.Value = v.Value + diffNoteDeal);
                            PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == dealDC.PayruleNoteDetailFundingList[dealDC.PayruleNoteDetailFundingList.Count - 1].NoteID && x.Date == val.Date && x.DealFundingRowno == val.DealFundingRowno && x.Value < 0).ToList().ForEach(v => v.Value = v.Value + diffNoteDeal);
                        }
                    }
                }

                #region FinalSettelment

                //Finding max and common date in all note
                foreach (var n in dealDC.PayruleNoteDetailFundingList)
                {
                    if (PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value > 0).Count() > 0 && PayruleDealFundingList.Where(x => x.Value > 0).ToList().Count() != 0 && PayruleNoteAMSequenceList.Where(a => a.SequenceTypeText == "Funding Sequence").ToList().Count != 0)
                    {
                        if (maxFundingDate == default(DateTime))
                        {
                            maxFundingDate = PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value > 0).Max(x => x.Date.GetValueOrDefault(new DateTime()));
                        }
                        else if (PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value > 0).Max(x => x.Date.GetValueOrDefault(new DateTime())) > maxFundingDate)
                        {
                            maxFundingDate = PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value > 0).Max(x => x.Date.GetValueOrDefault(new DateTime()));
                        }
                    }
                    if (isRepayment == true)
                    {
                        if (PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value < 0).Count() > 0 && PayruleDealFundingList.Where(x => x.Value < 0).ToList().Count() != 0 && PayruleNoteAMSequenceList.Where(a => a.SequenceTypeText == "Repayment Sequence").ToList().Count != 0)
                        {
                            if (maxRepaymentDate == default(DateTime))
                            {
                                maxRepaymentDate = PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value < 0).Max(x => x.Date.GetValueOrDefault(new DateTime()));
                            }
                            else if (PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value < 0).Max(x => x.Date.GetValueOrDefault(new DateTime())) > maxRepaymentDate)
                            {
                                maxRepaymentDate = PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == n.NoteID && y.Value < 0).Max(x => x.Date.GetValueOrDefault(new DateTime()));
                            }
                        }
                    }
                }

                //Funding match
                if (maxFundingDate != new DateTime())
                {
                    //search for note which has note funding>sequence or funding<sequence
                    foreach (var note in dealDC.PayruleNoteDetailFundingList)
                    {
                        totalFundingSequence = PayruleNoteAMSequenceList.Where(a => a.NoteID == note.NoteID && a.SequenceTypeText == "Funding Sequence").Sum(x => x.Value.GetValueOrDefault(0));
                        totalNoteFunding = PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == note.NoteID && y.Value > 0).Sum(x => x.Value.GetValueOrDefault(0));
                        if (totalNoteFunding > totalFundingSequence)
                        {
                            ExtraNoteFunding = ExtraNoteFunding + (totalNoteFunding - totalFundingSequence);
                        }
                        else if (totalNoteFunding < totalFundingSequence)
                        {
                            LessNoteFunding = LessNoteFunding + (totalFundingSequence - totalNoteFunding);
                        }
                    }

                    //settle funding
                    foreach (var note in dealDC.PayruleNoteDetailFundingList)
                    {
                        totalFundingSequence = PayruleNoteAMSequenceList.Where(a => a.NoteID == note.NoteID && a.SequenceTypeText == "Funding Sequence").Sum(x => x.Value.GetValueOrDefault(0));
                        totalNoteFunding = PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == note.NoteID && y.Value > 0).Sum(x => x.Value.GetValueOrDefault(0));
                        if (totalNoteFunding > totalFundingSequence && LessNoteFunding != 0) //note with greater funding than sequence
                        {
                            diffNoteDeal = (totalNoteFunding - totalFundingSequence) <= LessNoteFunding ? (totalNoteFunding - totalFundingSequence) : LessNoteFunding;
                            PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == note.NoteID && x.Date == maxFundingDate && x.Value > 0).ToList().ForEach(v => v.Value = v.Value - diffNoteDeal);
                            LessNoteFunding = LessNoteFunding - diffNoteDeal;
                        }
                        else if (totalNoteFunding < totalFundingSequence && ExtraNoteFunding != 0) //note with less funding than sequence
                        {
                            diffNoteDeal = (totalFundingSequence - totalNoteFunding) <= ExtraNoteFunding ? (totalFundingSequence - totalNoteFunding) : ExtraNoteFunding;
                            PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == note.NoteID && x.Date == maxFundingDate && x.Value > 0).ToList().ForEach(v => v.Value = v.Value + diffNoteDeal);
                            ExtraNoteFunding = ExtraNoteFunding - diffNoteDeal;
                        }
                    }
                }

                //Repayment match
                if (isRepayment == true)
                {
                    if (maxRepaymentDate != new DateTime())
                    {
                        //search for note which has note Repayment>sequence or Repayment<sequence
                        foreach (var note in dealDC.PayruleNoteDetailFundingList)
                        {
                            totalRepaymentSequence = PayruleNoteAMSequenceList.Where(a => a.NoteID == note.NoteID && a.SequenceTypeText == "Repayment Sequence").Sum(x => x.Value.GetValueOrDefault(0));
                            totalNoteRepayment = Math.Abs(PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == note.NoteID && y.Value < 0).Sum(x => x.Value.GetValueOrDefault(0)));
                            if (totalNoteRepayment > totalRepaymentSequence)
                            {
                                ExtraNoteRepayment = ExtraNoteRepayment + (totalNoteRepayment - totalRepaymentSequence);
                            }
                            else if (totalNoteRepayment < totalRepaymentSequence)
                            {
                                LessNoteRepayment = LessNoteRepayment + (totalRepaymentSequence - totalNoteRepayment);
                            }
                        }
                        //settle Repayment
                        foreach (var note in dealDC.PayruleNoteDetailFundingList)
                        {
                            totalRepaymentSequence = PayruleNoteAMSequenceList.Where(a => a.NoteID == note.NoteID && a.SequenceTypeText == "Repayment Sequence").Sum(x => x.Value.GetValueOrDefault(0));
                            totalNoteRepayment = Math.Abs(PayruleTargetNoteFundingScheduleList.Where(y => y.NoteID == note.NoteID && y.Value < 0).Sum(x => x.Value.GetValueOrDefault(0)));
                            if (totalNoteRepayment > totalRepaymentSequence && LessNoteRepayment != 0) //note with greater Repayment than sequence
                            {
                                diffNoteDeal = (totalNoteRepayment - totalRepaymentSequence) <= LessNoteRepayment ? (totalNoteRepayment - totalRepaymentSequence) : LessNoteRepayment;
                                PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == note.NoteID && x.Date == maxRepaymentDate && x.Value < 0).ToList().ForEach(v => v.Value = v.Value + diffNoteDeal);
                                LessNoteFunding = LessNoteFunding - diffNoteDeal;
                            }
                            else if (totalNoteRepayment < totalRepaymentSequence && ExtraNoteRepayment != 0) //note with less Repayment than sequence
                            {
                                diffNoteDeal = (totalRepaymentSequence - totalNoteRepayment) <= ExtraNoteRepayment ? (totalRepaymentSequence - totalNoteRepayment) : ExtraNoteRepayment;
                                PayruleTargetNoteFundingScheduleList.Where(x => x.NoteID == note.NoteID && x.Date == maxRepaymentDate && x.Value < 0).ToList().ForEach(v => v.Value = v.Value - diffNoteDeal);
                                ExtraNoteRepayment = ExtraNoteRepayment - diffNoteDeal;
                            }
                        }
                    }
                }
                // CreateCSVFile(ToDataSet(PayruleTargetNoteFundingScheduleList).Tables[0], "Final");

                #endregion FinalSettelment
            }
        }

        #endregion NewCode

        #region autospread
        private void AutoSpreadFundDistribution()
        {
            DateTime lastfunddate = DateTime.MinValue;
            DateTime dealfunddate = DateTime.MinValue;
            int? maxrowno = 0;

            //remove all future data from deal funding for which workflow is not started and applied status is false            
            //delete old rows 
            foreach (AutoSpreadRuleDataContract asd in dealDC.AutoSpreadRuleList)
            {
                maxFundDate = DateTime.MinValue;
                foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
                {
                    DateTime? tempdate = DateTime.MinValue;
                    if (ds.PurposeText == asd.PurposeTypeText)
                    {
                        if (ds.Applied == true)
                        {
                            tempdate = ds.Date;
                        }
                        else if (ds.Comment != null)
                        {
                            if (ds.Comment != "")
                            {
                                tempdate = ds.Date;
                            }
                        }
                        if (tempdate != DateTime.MinValue)
                        {
                            if (maxFundDate == DateTime.MinValue)
                            {
                                maxFundDate = ds.Date;
                            }
                            else
                            {
                                maxFundDate = DateExtensions.GetMaxDate(maxFundDate.Value.Date, ds.Date.Value.Date);
                            }
                        }
                    }

                    if (ds.DealFundingRowno != null)
                    {
                        if (ds.DealFundingRowno > maxrowno)
                        {
                            maxrowno = ds.DealFundingRowno;
                        }
                    }

                }
                AutoSpreadDistributionHelper dis = new AutoSpreadDistributionHelper();
                dis.PurposeType = asd.PurposeTypeText;
                dis.MaxFundDate = maxFundDate;
                ListPurposeMinDate.Add(dis);
            }
            maxrowno = maxrowno + 1;
            foreach (AutoSpreadRuleDataContract asd in dealDC.AutoSpreadRuleList)
            {
                TotalRequiredEquity = 0;
                actuallastmonth = 0;
                AutoSpreadStartDate = DateTime.MinValue;
                maxWireConfirmedDate = DateTime.MinValue;
                int totalmonths = 0;
                decimal? FundAllocated = 0, pennyToBeadjusted = 0, ReamingAmountToDistribute = 0, TotalAmtToBeDistribute = 0, TotalAmtDistributed = 0, RequiredEquityAllocated = 0, AdditionalEquityAllocated = 0, TotalRequiredEquityToBeDistribute = 0, TotalAdditionalEquityToBeDistribute = 0, DebtToEquityRatio = 0;
                bool StartInnextMonth = true;
                DateTime startdate = DateTime.MinValue;
                DateTime enddate = DateTime.MinValue;
                int numberofperiods = 0;
                TotalAmtDistributed = GetTotalAmountDistributed(asd.PurposeTypeText);
                TotalAmtToBeDistribute = asd.DebtAmount.GetValueOrDefault(0) - TotalAmtDistributed;
                TotalRequiredEquityToBeDistribute = asd.RequiredEquity.GetValueOrDefault(0) - TotalRequiredEquity;
                // get dropday 
                GetDropDay(asd.PurposeTypeText);

                if (asd.StartDate.Value.Date == asd.EndDate.Value.Date && Math.Abs(TotalAmtToBeDistribute.Value + TotalRequiredEquityToBeDistribute.Value) != 0m)
                {
                    //get TotalAmtToBeDistribute and TotalAmtDistributeed for  purpose type
                    PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
                    pdf.Date = asd.StartDate.Value.Date;
                    pdf.PurposeText = asd.PurposeTypeText;
                    pdf.PurposeID = asd.PurposeType;
                    pdf.SubPurposeType = asd.PurposeSubType;
                    pdf.Value = Math.Round(Convert.ToDecimal(TotalAmtToBeDistribute.Value), 2);
                    pdf.Applied = false;
                    pdf.DealID = dealid;
                    pdf.DealFundingRowno = maxrowno;
                    pdf.DealFundingID = null;
                    if (pdf.PurposeText == "Capital Expenditure" || pdf.PurposeText == "OpEx" || pdf.PurposeText == "TI/LC")
                    {
                        pdf.WF_CurrentStatus = "Projected";
                        pdf.WF_CurrentStatusDisplayName = "Projected";
                        pdf.WF_IsAllow = true;
                        pdf.WF_isParticipate = true;
                    }
                    else
                    {
                        pdf.WF_CurrentStatus = null;
                        pdf.WF_CurrentStatusDisplayName = null;
                        pdf.WF_IsAllow = false;
                        pdf.WF_isParticipate = false;
                    }
                    pdf.Comment = "";
                    pdf.WF_IsCompleted = false;
                    pdf.WF_IsFlowStart = false;
                    pdf.wf_isUserCurrentFlow = false;
                    pdf.EquityAmount = Math.Round(Convert.ToDecimal(TotalRequiredEquityToBeDistribute.Value), 2);
                    pdf.RequiredEquity = Math.Round(Convert.ToDecimal(TotalRequiredEquityToBeDistribute.Value), 2);

                    pdf.GeneratedBy = 747;
                    dealDC.PayruleDealFundingList.Add(pdf);
                    maxrowno = maxrowno + 1;
                }
                else if (Math.Abs(TotalAmtToBeDistribute.Value + TotalRequiredEquityToBeDistribute.Value) != 0m)
                {
                    ReamingAmountToDistribute = TotalAmtToBeDistribute;

                    foreach (AutoSpreadDistributionHelper dt in ListPurposeMinDate)
                    {
                        if (asd.PurposeTypeText == dt.PurposeType)
                        {
                            maxFundDate = dt.MaxFundDate;
                            break;
                        }
                    }
                    int monthpart = Convert.ToInt16(asd.FrequencyFactor);
                    if (monthpart > 1)
                    {
                        monthpart = Convert.ToInt16(asd.FrequencyFactor - 1);
                    }
                    else
                    {
                        monthpart = 0;
                    }
                    //Start date
                    startdate = CalculateStartDateForAutoSpreadFunding(asd.StartDate);
                    //End date 
                    enddate = CalculateEndDateForAutoSpreadFunding(asd.EndDate);

                    if (startdate.Date > enddate)
                    {
                        startdate = enddate.Date;
                    }
                    if (enddate.Date >= startdate.Date)
                    {
                        totalmonths = DateExtensions.GetMonthsDiffIgnoringDays(startdate, enddate);
                    }

                    if (asd.FrequencyFactor > 1)
                    {
                        numberofperiods = GetNumberOfMonths(startdate, enddate, asd.FrequencyFactor.Value, totalmonths, dropday);
                    }
                    else
                    {
                        numberofperiods = totalmonths;
                    }
                    if (asd.DistributionMethodText != "Linear")
                    {
                        GetActualMonthToStart(asd.PurposeTypeText, startdate);
                    }
                    for (int i = 0; i < numberofperiods; i++)
                    {
                        dealfunddate = DateTime.MinValue;
                        PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
                        if (i == 0)
                        {
                            dealfunddate = startdate;
                        }
                        else
                        {
                            if (asd.FrequencyFactor > 1)
                            {
                                monthpart = Convert.ToInt16(asd.FrequencyFactor - 1);
                            }
                            else
                            {
                                monthpart = 0;
                            }
                            monthpart = monthpart + 1;
                            dealfunddate = DateExtensions.CreateNewDate(lastfunddate.Year, lastfunddate.Month + monthpart, dropday);
                        }
                        if (dealfunddate > asd.EndDate)
                        {
                            dealfunddate = asd.EndDate.Value;
                        }
                        lastfunddate = dealfunddate;
                        if (dealfunddate <= enddate)
                        {
                            pdf.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(dealfunddate), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
                            pdf.PurposeText = asd.PurposeTypeText;
                            pdf.PurposeID = asd.PurposeType;
                            pdf.SubPurposeType = asd.PurposeSubType;
                            if (numberofperiods == 1)
                            {
                                pdf.Value = TotalAmtToBeDistribute.GetValueOrDefault(0);
                                pdf.RequiredEquity = Math.Max(0, TotalRequiredEquityToBeDistribute.GetValueOrDefault(0));

                            }
                            else
                            {
                                pdf.Value = DistributeAmountBasedOnRule(TotalAmtToBeDistribute.GetValueOrDefault(0), numberofperiods, asd.DistributionMethodText, actuallastmonth, actuallastmonth + i + 1);
                                pdf.RequiredEquity = DistributeAmountBasedOnRule(TotalRequiredEquityToBeDistribute.GetValueOrDefault(0), numberofperiods, asd.DistributionMethodText, actuallastmonth, actuallastmonth + i + 1);

                            }
                            pdf.Applied = false;
                            pdf.DealID = dealid;
                            pdf.DealFundingRowno = maxrowno;
                            pdf.DealFundingID = null;
                            if (pdf.PurposeText == "Capital Expenditure" || pdf.PurposeText == "OpEx" || pdf.PurposeText == "TI/LC")
                            {
                                pdf.WF_CurrentStatus = "Projected";
                                pdf.WF_CurrentStatusDisplayName = "Projected";
                                pdf.WF_IsAllow = true;
                                pdf.WF_isParticipate = true;
                            }
                            else
                            {
                                pdf.WF_CurrentStatus = null;
                                pdf.WF_CurrentStatusDisplayName = null;
                                pdf.WF_IsAllow = false;
                                pdf.WF_isParticipate = false;
                            }
                            //workflow items
                            pdf.Comment = "";
                            pdf.WF_IsCompleted = false;
                            pdf.WF_IsFlowStart = false;
                            pdf.wf_isUserCurrentFlow = false;
                            //
                            pdf.GeneratedBy = 747;
                            FundAllocated = FundAllocated + pdf.Value;
                            // EquityFundAllocated = EquityFundAllocated + pdf.EquityAmount;
                            RequiredEquityAllocated = RequiredEquityAllocated + pdf.RequiredEquity.GetValueOrDefault(0);
                            // AdditionalEquityAllocated = AdditionalEquityAllocated + pdf.AdditionalEquity.GetValueOrDefault(0);

                            ReamingAmountToDistribute = ReamingAmountToDistribute - pdf.Value;
                            dealDC.PayruleDealFundingList.Add(pdf);
                            maxrowno = maxrowno + 1;
                        }
                        else
                        {
                            break;
                        }
                    }
                    if (FundAllocated != 0)
                    {
                        pennyToBeadjusted = TotalAmtToBeDistribute - FundAllocated;
                        if (pennyToBeadjusted != 0)
                        {
                            if (dealDC.PayruleDealFundingList.Count > 1)
                            {
                                dealDC.PayruleDealFundingList[dealDC.PayruleDealFundingList.Count - 1].Value = dealDC.PayruleDealFundingList[dealDC.PayruleDealFundingList.Count - 1].Value + pennyToBeadjusted.GetValueOrDefault(0);
                            }
                        }
                    }
                    if (RequiredEquityAllocated != 0)
                    {
                        pennyToBeadjusted = 0;
                        pennyToBeadjusted = TotalRequiredEquityToBeDistribute - RequiredEquityAllocated;
                        if (pennyToBeadjusted != 0)
                        {
                            if (dealDC.PayruleDealFundingList.Count > 1)
                            {
                                dealDC.PayruleDealFundingList[dealDC.PayruleDealFundingList.Count - 1].RequiredEquity = dealDC.PayruleDealFundingList[dealDC.PayruleDealFundingList.Count - 1].RequiredEquity + pennyToBeadjusted.GetValueOrDefault(0);
                            }
                        }
                    }

                }
            }

            //delete 0 
            DeleteZeroAmountAfterAutoSpreadingFunding();
        }

        private DateTime CalculateStartDateForAutoSpreadFunding(DateTime? asdStartDate)
        {
            Boolean StartInnextMonth = true;
            DateTime startdate = DateTime.MinValue;
            DateTime todaydate = DateTime.Now.Date;
            DateTime nextdateafter15days = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(todaydate), Convert.ToInt16(15), "US", dealDC.ListHoliday, true).Date;
            DateTime nextstartdate = DateExtensions.CreateNewDate(todaydate.Year, todaydate.Month, dropday);

            AutoSpreadStartDate = DateExtensions.GetMaxDate(AutoSpreadStartDate.Value.Date, asdStartDate.Value.Date);
            AutoSpreadStartDate = DateExtensions.GetMaxDate(AutoSpreadStartDate.Value.Date, maxFundDate.Value.Date.AddMonths(1));
            AutoSpreadStartDate = DateExtensions.GetMaxDate(AutoSpreadStartDate.Value.Date, DateTime.Now);
            AutoSpreadStartDate = DateExtensions.GetMaxDate(AutoSpreadStartDate.Value.Date, nextdateafter15days);
            AutoSpreadStartDate = DateExtensions.GetMaxDate(AutoSpreadStartDate.Value.Date, nextstartdate);
            if (AutoSpreadStartDate.Value.Day > dropday)
            {
                startdate = DateExtensions.CreateNewDate(AutoSpreadStartDate.Value.Year, AutoSpreadStartDate.Value.Month + 1, dropday);
            }
            else
            {
                startdate = DateExtensions.CreateNewDate(AutoSpreadStartDate.Value.Year, AutoSpreadStartDate.Value.Month, dropday);
            }
            return startdate;
        }

        private DateTime CalculateEndDateForAutoSpreadFunding(DateTime? asdEndDate)
        {
            DateTime enddate = DateTime.MinValue;
            enddate = DateExtensions.CreateNewDate(asdEndDate.Value.Year, asdEndDate.Value.Month, dropday);
            if (enddate > asdEndDate)
            {
                enddate = asdEndDate.Value;
            }
            if (enddate < maxWireConfirmedDate)
            {
                enddate = asdEndDate.Value;
            }
            return enddate;
        }
        private void DeleteFundingForAutoSpreading()
        {
            foreach (AutoSpreadRuleDataContract asd in dealDC.AutoSpreadRuleList)
            {
                foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
                {
                    if (ds.PurposeText == asd.PurposeTypeText)
                    {
                        if (ds.Applied != true)
                        {
                            if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                            {
                                if (ds.Comment == null || ds.Comment == "")
                                {
                                    ds.isdeleted = true;
                                    PayruleDeletedDealFundingList.Add(ds);
                                }
                            }
                        }
                        else if (ds.PurposeText == null || ds.PurposeText == "")
                        {
                            ds.isdeleted = true;
                            PayruleDeletedDealFundingList.Add(ds);
                        }
                    }
                }
            }

            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);
        }
        private void DeleteAutoSpreadFundings()
        {
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.Value >= 0m)
                {
                    if (ds.Applied != true)
                    {
                        if (ds.GeneratedBy == 747)
                        {
                            if (ds.Comment == null || ds.Comment == "")
                            {
                                ds.isdeleted = true;
                                PayruleDeletedDealFundingList.Add(ds);
                            }
                        }
                    }
                    else if (ds.PurposeText == null || ds.PurposeText == "")
                    {
                        ds.isdeleted = true;
                        PayruleDeletedDealFundingList.Add(ds);
                    }
                }
            }

            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);
        }

        private void DeleteZeroAmountAfterAutoSpreadingFunding()
        {
            foreach (AutoSpreadRuleDataContract asd in dealDC.AutoSpreadRuleList)
            {
                foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
                {
                    if (ds.PurposeText == asd.PurposeTypeText)
                    {
                        if (ds.Applied != true)
                        {
                            if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                            {
                                if (ds.Comment == null || ds.Comment == "")
                                {
                                    if (Math.Abs(ds.RequiredEquity.GetValueOrDefault(0) + ds.Value.GetValueOrDefault(0)) == 0m)
                                    {
                                        ds.isdeleted = true;
                                        PayruleDeletedDealFundingList.Add(ds);

                                    }

                                }
                            }
                        }

                    }
                }
            }

            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);
        }
        public void AutoSpreadRepayment()
        {
            DateTime? RepaymentStartDate = DateTime.MinValue;
            DateTime LastPaydownDate = DateTime.MinValue;
            if (dealDC.LatestPossibleRepaymentDate == null)
            {
                dealDC.LatestPossibleRepaymentDate = DateTime.MinValue;
            }
            maxLockedDate = DateTime.MinValue;

            if (dealDC.EnableAutoSpread == true)
            {
                dealDC.Endingbalance = dealDC.Endingbalance - AdjustBeginningBalanceForRepaymentAutoSpreading();
            }

            //1) Calculate start date            
            RepaymentStartDate = GetAutoSpreadRepaymentStartDate();
            //2) calculate end date
            RepaymentEndDate = GetAutoSpreadRepaymentEndDate(RepaymentStartDate);
            //3) delete old and future records 
            DeleteRepaymentsFromNoteAndDeal();
            // 4) check for same month paydown if entries found in same month then move start date to next month         
            RepaymentStartDate = RecalculateStartDateAgain(Convert.ToDateTime(RepaymentStartDate));
            ListRepaymentBalances = dealDC.ListAutoRepaymentBalances;

            // If we have balance but the first paydown is happening after maturity then generate a paydown on maturity for
            if (RepaymentEndDate != DateTime.MinValue && RepaymentStartDate != DateTime.MinValue)
            {
                if (RepaymentStartDate.Value.Date > RepaymentEndDate.Value.Date)
                {
                    generateonLatestpossibleprepayment = true;
                }
            }
            if (generateonLatestpossibleprepayment != true)
            {
                // 5) Calculate CPR And SLR Factor
                if (dealDC.RepaymentAutoSpreadMethodText != "Date Specific")
                {
                    if (datainCumulativeProbability == true)
                    {
                        CalculateCPRAndSLFactor(RepaymentStartDate);
                    }
                    else
                    {
                        generateonLatestpossibleprepayment = true;
                    }
                }
            }

            //6)distribute balance

            if (generateonLatestpossibleprepayment != true)
            {
                if (dealDC.RepaymentAutoSpreadMethodText == "Date Specific")
                {
                    DistributeRepayAmountDateSpecific(RepaymentStartDate, RepaymentEndDate);
                }
                else
                {

                    DistributeRepayAmount(RepaymentStartDate, RepaymentEndDate);
                }
            }
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.PurposeText == "Paydown")
                {
                    if (pdf.Value == 0)
                    {
                        //remove all values which are 0
                        pdf.isdeleted = true;
                    }
                    else
                    {
                        // pdf.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(pdf.Date.Value.Date), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                        if (LastPaydownDate != DateTime.MinValue)
                        {
                            LastPaydownDate = DateExtensions.GetMaxDate(LastPaydownDate, Convert.ToDateTime(pdf.Date));
                        }
                        else
                        {
                            LastPaydownDate = Convert.ToDateTime(pdf.Date);
                        }
                    }
                }

            }
            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);

            if (generateonLatestpossibleprepayment == true)
            {
                DateTime todayday = DateTime.Now;
                if (maxLockedDate.Value.Date != RepaymentEndDate.Value.Date && RepaymentEndDate.Value.Date > todayday)
                {
                    int day = GetDayofTheMonth();
                    DateTime dealfunddate = Convert.ToDateTime(RepaymentEndDate);
                    dealfunddate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(dealfunddate), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                    Decimal? balance = 0;
                    balance = Convert.ToDecimal(GetCurrentBalance(dealfunddate, dealfunddate, 0, dealfunddate));
                    AddRepayToPayruleDealFundingList(dealfunddate, balance);
                    LastPaydownDate = dealfunddate;
                }

            }
            var trueup = CheckifTrueUpisToBeApplyorNot(RepaymentStartDate, RepaymentEndDate);
            if (LastPaydownDate != DateTime.MinValue)
            {
                if (LastPaydownDate.Date < DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(RepaymentStartDate.Value), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date)
                {
                    LastPaydownDate = Convert.ToDateTime(RepaymentStartDate);
                }
                foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
                {
                    if (pdf.Date.Value.Date > LastPaydownDate && pdf.Value > 0)
                    {
                        AddRepaySameAsTheFunding(pdf.Date, pdf.Value);
                    }

                    if (pdf.PurposeText == "Paydown" && pdf.Date == LastPaydownDate && pdf.Value != 0)
                    {
                        if (trueup == true)
                        {
                            pdf.Value = pdf.Value.GetValueOrDefault(0) + GetSumAmortAndPikAfterEndDate(Convert.ToDateTime(pdf.Date)) * -1;
                        }
                    }
                }
            }
            if (DealFundingListExtension != null)
            {
                foreach (var ds in DealFundingListExtension)
                {
                    dealDC.PayruleDealFundingList.Add(ds);
                }
            }
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                pdf.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(pdf.Date.Value.Date), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

            }


            //commented below logic : now autospread end will be ExpectedMaturityDate
            //dealDC.RepayExpectedMaturityDate = CalculateExpectedMaturityDate();
            dealDC.RepayExpectedMaturityDate = RepaymentEndDate;
        }

        public void GetDropDay(string purposetype)
        {
            if (purposetype == "Capitalized Interest")
            {
                if (dealDC.FirstPaymentDate != null)
                {
                    dropday = dealDC.FirstPaymentDate.Value.Day;
                }
            }
            else
            {
                if (dealDC.ServicereDayAjustement != null && dealDC.ServicereDayAjustement != 0)
                {
                    dropday = dealDC.ServicereDayAjustement.Value - 2;
                }
            }
            if (dropday < 1)
            {
                //2 business days prior to the drop date default is 29 so 29-2
                dropday = 27;
            }
        }

        public void AutoSpreadRepaymentNoteLevelUseRuleY()
        {
            //assign Row no in Note funding according to DealFundingID in Deal funding
            dealDC.PayruleTargetNoteFundingScheduleList = dealDC.PayruleTargetNoteFundingScheduleList.OrderBy(x => x.Date).ToList();
            for (int j = 0; j < dealDC.PayruleDealFundingList.Count(); j++)
            {
                for (int i = 0; i < dealDC.PayruleTargetNoteFundingScheduleList.Count(); i++)
                {
                    if ((dealDC.PayruleDealFundingList[j].DealFundingID == dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID) & dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingID != null)
                    {
                        dealDC.PayruleTargetNoteFundingScheduleList[i].DealFundingRowno = dealDC.PayruleDealFundingList[j].DealFundingRowno;
                        dealDC.PayruleTargetNoteFundingScheduleList[i].Applied = dealDC.PayruleDealFundingList[j].Applied;
                    }
                }
            }

            if (dealDC.ExpectedFullRepaymentDate == null || dealDC.ExpectedFullRepaymentDate == DateTime.MinValue)
            {
                dealDC.ListProjectedPayoff = dealDC.ListProjectedPayoff.OrderBy(x => x.ProjectedPayoffAsofDate).ToList();
                AutoSpreadRepaymentUseRuleN();
            }
            else
            {
                ListNoteRepaymentBalances = dealDC.ListNoteRepaymentBalances;
                CreateExpectedFullRepayRecordUseRuleN(Convert.ToDateTime(dealDC.ExpectedFullRepaymentDate));
            }
        }
        public void AutoSpreadRepaymentUseRuleN()
        {
            DateTime? RepaymentStartDate = DateTime.MinValue;
            DateTime? LastPaydownDate = DateTime.MinValue;
            maxLockedDate = DateTime.MinValue;
            if (dealDC.LatestPossibleRepaymentDate == null)
            {
                dealDC.LatestPossibleRepaymentDate = DateTime.MinValue;
            }
            if (dealDC.EnableAutoSpread == true)
            {
                AdjustNoteLevelBeginningBalanceForRepaymentAutoSpreading();
            }
            //1) Calculate start date            
            RepaymentStartDate = GetAutoSpreadRepaymentStartDate();
            ListNoteRepaymentBalances = dealDC.ListNoteRepaymentBalances;
            //2) calculate end date
            RepaymentEndDate = GetAutoSpreadRepaymentEndDate(RepaymentStartDate);
            //3) delete old and future records
            //if (dealDC.ApplyNoteLevelPaydowns != true)
            {
                DeleteRepaymentsFromNoteAndDeal();
            }
            // 4) check for same month paydown if entries found in same month then move start date to next month         
            RepaymentStartDate = RecalculateStartDateAgain(Convert.ToDateTime(RepaymentStartDate));

            //reassign DealFundingRowno
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.DealFundingRowno != null)
                {
                    if (ds.DealFundingRowno > UseRuleNRowNumber)
                    {
                        UseRuleNRowNumber = Convert.ToInt32(ds.DealFundingRowno);
                    }
                }
            }
            if (RepaymentEndDate != DateTime.MinValue && RepaymentStartDate != DateTime.MinValue)
            {
                if (RepaymentStartDate.Value.Date > RepaymentEndDate.Value.Date)
                {
                    generateonLatestpossibleprepayment = true;
                }
            }
            // 5) Calculate CPR And SLR Factor
            if (generateonLatestpossibleprepayment != true)
            {
                if (dealDC.RepaymentAutoSpreadMethodText != "Date Specific")
                {
                    if (datainCumulativeProbability == true)
                    {
                        CalculateCPRAndSLFactor(RepaymentStartDate);
                    }
                    else
                    {
                        generateonLatestpossibleprepayment = true;
                    }
                }
            }
            if (generateonLatestpossibleprepayment != true)
            {
                //6)distribute balance 
                if (dealDC.RepaymentAutoSpreadMethodText == "Date Specific")
                {
                    //DistributeRepayAmountDateSpecific(RepaymentStartDate, RepaymentEndDate);
                }
                else
                {
                    DistributeRepayAmountUseRuleN(RepaymentStartDate, RepaymentEndDate);

                }
            }

            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.PurposeText == "Paydown")
                {
                    if (pdf.Value == 0)
                    {
                        //remove all values which are 0
                        pdf.isdeleted = true;
                        DeletedRowNumberList.Add(pdf.DealFundingRowno);
                    }
                    else
                    {
                        //pdf.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(pdf.Date.Value), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

                        if (LastPaydownDate != DateTime.MinValue)
                        {
                            LastPaydownDate = DateExtensions.GetMaxDate(LastPaydownDate.Value.Date, Convert.ToDateTime(pdf.Date));
                        }
                        else
                        {
                            LastPaydownDate = Convert.ToDateTime(pdf.Date);
                        }
                    }

                }
            }

            if (DeletedRowNumberList != null)
            {
                foreach (var id in DeletedRowNumberList)
                {
                    foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
                    {
                        if (notefund.DealFundingRowno == id)
                        {
                            notefund.isDeletedAutoSpread = true;
                            PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                        }
                    }
                }
            }
            dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.isDeletedAutoSpread == true);

            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);

            if (generateonLatestpossibleprepayment == true)
            {
                DateTime todayday = DateTime.Now;
                if (maxLockedDate.Value.Date != RepaymentEndDate.Value.Date && RepaymentEndDate.Value.Date > todayday)
                {
                    CreateExpectedFullRepayRecordUseRuleN(Convert.ToDateTime(RepaymentEndDate));
                    LastPaydownDate = RepaymentEndDate;
                }
            }

            if (generateonLatestpossibleprepayment != true && LastPaydownDate != DateTime.MinValue)
            {
                if (LastPaydownDate.Value.Date < DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(RepaymentStartDate.Value), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date)
                {
                    LastPaydownDate = RepaymentStartDate;
                }

                foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
                {
                    if (pdf.Date.Value.Date > LastPaydownDate && pdf.Value > 0)
                    {
                        AddRepaySameAsTheFundingForUseRuleN(pdf.Date, pdf.DealFundingRowno);
                    }
                }
                decimal? dealamount = 0;
                var trueup = CheckifTrueUpisToBeApplyorNot(RepaymentStartDate, RepaymentEndDate);
                if (trueup == true)
                {
                    foreach (NoteEndingBalanceDataContract noteitem in dealDC.ListNoteEndingBalance)
                    {
                        foreach (var funding in dealDC.PayruleTargetNoteFundingScheduleList)
                        {
                            if (noteitem.NoteID == funding.NoteID.ToString() && funding.Purpose == "Paydown" && funding.Date == LastPaydownDate && funding.Value != 0)
                            {

                                decimal? amount = 0;
                                amount = funding.Value + GetSumAmortAndPikAfterEndDateUseRuleN(Convert.ToDateTime(funding.Date), noteitem.NoteID) * -1;
                                //repayment amount cannot be positive value
                                if (amount > 0)
                                {
                                    amount = 0;
                                }
                                funding.Value = amount;

                                dealamount = dealamount.GetValueOrDefault(0) + funding.Value.GetValueOrDefault(0);
                            }
                        }
                    }

                    //assign deal levelamount
                    foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
                    {
                        if (pdf.PurposeText == "Paydown" && pdf.Date == LastPaydownDate && pdf.Value != 0)
                        {
                            pdf.Value = dealamount;
                            pdf.Value1 = dealamount;
                        }
                    }
                }


                if (DealFundingListExtension != null)
                {
                    foreach (var ds in DealFundingListExtension)
                    {
                        dealDC.PayruleDealFundingList.Add(ds);
                    }
                }
            }
            //holiday adjust the dates
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                pdf.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(pdf.Date.Value.Date), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;

            }
            foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (notefund.Purpose == "Paydown")
                {
                    notefund.Date = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(notefund.Date.Value), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
                }
            }

            //commented below logic : now autospread end will be ExpectedMaturityDate
            //dealDC.RepayExpectedMaturityDate = CalculateExpectedMaturityDate();
            dealDC.RepayExpectedMaturityDate = RepaymentEndDate;
        }

        public Decimal GetTotalAmountDistributed(String PurposeType)
        {
            Decimal TotalAmountDistributed = 0;
            foreach (PayruleDealFundingDataContract pdfd in dealDC.PayruleDealFundingList)
            {
                if (PurposeType == pdfd.PurposeText)
                {
                    if (pdfd.NonCommitmentAdj != true)
                    {
                        if (pdfd.WF_CurrentStatus != "Projected" || pdfd.WF_CurrentStatus == "" || pdfd.WF_CurrentStatus == null || pdfd.Applied == true)
                        {
                            TotalAmountDistributed = TotalAmountDistributed + pdfd.Value.GetValueOrDefault(0);
                            TotalRequiredEquity = TotalRequiredEquity + pdfd.RequiredEquity.GetValueOrDefault(0);

                        }
                        else if (pdfd.Comment != "" || pdfd.Comment != null)
                        {
                            TotalAmountDistributed = TotalAmountDistributed + pdfd.Value.GetValueOrDefault(0);
                            TotalRequiredEquity = TotalRequiredEquity + pdfd.RequiredEquity.GetValueOrDefault(0);
                        }
                    }

                }
                if (pdfd.Applied == true)
                {
                    AutoSpreadStartDate = DateExtensions.GetMaxDate(AutoSpreadStartDate.Value.Date, pdfd.Date.Value.Date);
                    maxWireConfirmedDate = DateExtensions.GetMaxDate(maxWireConfirmedDate.Value.Date, pdfd.Date.Value.Date);
                }
            }

            return TotalAmountDistributed;
        }

        public decimal DistributeAmountBasedOnRule(Decimal RemainingAmtToDistribute, int totalmonth, string DistributionMethod, int lastmonth, int currentmonthid)
        {
            decimal pamt = 0;
            decimal SmoothStep = 0;
            decimal SmoothStepPact = 0;
            decimal PNormalDist = 0;

            if (currentmonthid <= totalmonth + lastmonth)
            {
                if (DistributionMethod == "Linear")
                {
                    pamt = RemainingAmtToDistribute / totalmonth;
                }
                else if (DistributionMethod == "Bell Curve")
                {

                    PNormalDist = Bell_Curve_Gnrtr(totalmonth, currentmonthid - lastmonth);
                    pamt = RemainingAmtToDistribute * PNormalDist;
                }
                else if (DistributionMethod == "Smooth Step Down")
                {
                    SmoothStep = (1 + totalmonth) / 2.0m * totalmonth;
                    SmoothStepPact = 1 / SmoothStep;
                    pamt = RemainingAmtToDistribute * (totalmonth - (currentmonthid - lastmonth) + 1) * SmoothStepPact;
                }
                else if (DistributionMethod == "Smooth Step Up")
                {
                    SmoothStep = (1 + totalmonth) / 2.0m * totalmonth;
                    SmoothStepPact = 1 / SmoothStep;
                    pamt = RemainingAmtToDistribute * (currentmonthid - lastmonth) * SmoothStepPact;
                }
            }
            pamt = Math.Max(0, pamt);
            return Math.Round(pamt, 2);
        }

        public static decimal Bell_Curve_Gnrtr(int totalmonths, int monthid)
        {
            double Normdist = 0, Amean = 0, Astdev = 0, DistSum = 0;
            Amean = (1 + totalmonths) / 2.0;

            for (int i = 1; i <= totalmonths; i++)
            {
                Astdev = Astdev + NumericExtensions.CalcPowAndCheckNaNDouble(Convert.ToDouble(i - Amean), (double)2);
            }
            Astdev = NumericExtensions.CalcPowAndCheckNaNDouble((Astdev / totalmonths), 1 / 2.0);

            Normdist = NormalDistribution.NORMDIST(monthid, Convert.ToDouble(Amean), Convert.ToDouble(Astdev), false);

            for (int j = 1; j <= totalmonths; j++)
            {
                DistSum = DistSum + NormalDistribution.NORMDIST(j, Convert.ToDouble(Amean), Convert.ToDouble(Astdev), false);
            }
            return Convert.ToDecimal(NumericExtensions.SafeDivision(Normdist, DistSum));
        }

        public static int GetNumberOfMonths(DateTime startdate, DateTime enddate, int frequencyfactor, int totalmonths, int dropday)
        {
            DateTime dealfunddate = DateTime.MinValue;
            int monthpart = 0;
            int numberofperiods = 0;
            for (int i = 0; i < totalmonths; i++)
            {
                if (i == 0)
                {
                    dealfunddate = startdate;
                }
                else
                {
                    if (frequencyfactor > 1)
                    {
                        monthpart = Convert.ToInt16(frequencyfactor - 1);
                    }
                    else
                    {
                        monthpart = 0;
                    }
                    monthpart = monthpart + 1;
                    dealfunddate = DateExtensions.CreateNewDate(dealfunddate.Year, dealfunddate.Month + monthpart, dropday);
                }
                if (dealfunddate > enddate)
                {
                    dealfunddate = enddate;
                }
                if (dealfunddate >= enddate)
                {
                    break;
                }
                else
                {
                    numberofperiods = numberofperiods + 1;
                }
            }

            return numberofperiods;
        }
        public static int GetNumberOfMonthsRepay(DateTime startdate, DateTime enddate, int frequencyfactor, int totalmonths, int dropday)
        {
            DateTime dealfunddate = DateTime.MinValue;
            int monthpart = 0;
            int numberofperiods = 0;
            for (int i = 0; i < totalmonths; i++)
            {
                if (i == 0)
                {
                    dealfunddate = startdate;
                }
                else
                {
                    if (frequencyfactor > 1)
                    {
                        monthpart = Convert.ToInt16(frequencyfactor - 1);
                    }
                    else
                    {
                        monthpart = 0;
                    }
                    monthpart = monthpart + 1;
                    dealfunddate = DateExtensions.CreateNewDate(dealfunddate.Year, dealfunddate.Month + monthpart, dropday);
                }
                if (dealfunddate > enddate)
                {
                    dealfunddate = enddate;
                }
                if (dealfunddate > enddate)
                {
                    break;
                }
                else
                {
                    numberofperiods = numberofperiods + 1;
                }
            }

            return numberofperiods;
        }

        public void GetActualMonthToStart(string PurposeType, DateTime startdate)
        {
            int currentmonth = 0;
            foreach (PayruleDealFundingDataContract pdfd in dealDC.PayruleDealFundingList)
            {
                if (PurposeType == pdfd.PurposeText)
                {
                    if (pdfd.Date <= startdate)
                    {
                        currentmonth = currentmonth + 1;
                    }

                }
            }
            actuallastmonth = currentmonth;
        }

        //---------------------auto spread repayment ---------------------------

        public DateTime? GetAutoSpreadRepaymentStartDate()
        {
            DateTime? EarliestPossibleRepaymentDate = DateTime.MinValue;
            DateTime? RepaymentStartDate = DateTime.MinValue;
            DateTime? CalculatedRepaymentStartDate = DateTime.MinValue;
            DateTime? maxrepayDate = DateTime.MinValue;
            DateTime? tempstartDate = DateTime.MinValue;
            DateTime? TodayDatePlusBlockoutperiod = DateTime.Now.Date;
            DateTime? MaxDateWithZeroCummulativeProbability = DateTime.MinValue;


            int dayofthemonth = GetDayofTheMonth();

            if (dealDC.EarliestPossibleRepaymentDate != null)
            {
                EarliestPossibleRepaymentDate = dealDC.EarliestPossibleRepaymentDate;
            }

            if (dealDC.AutoPrepayEffectiveDate != null)
            {
                CalculatedRepaymentStartDate = dealDC.AutoPrepayEffectiveDate.Value.Date;

                if (dealDC.Blockoutperiod != null)
                {
                    if (dealDC.Blockoutperiod != 0)
                    {
                        CalculatedRepaymentStartDate = CalculatedRepaymentStartDate.Value.AddMonths(Convert.ToInt32(dealDC.Blockoutperiod));
                    }
                }
            }

            if (dealDC.Blockoutperiod != null)
            {
                if (dealDC.Blockoutperiod != 0)
                {
                    TodayDatePlusBlockoutperiod = TodayDatePlusBlockoutperiod.Value.AddMonths(Convert.ToInt32(dealDC.Blockoutperiod));
                }
            }

            //loop through all dates in deal funding get max date 
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                DateTime? tempdate = DateTime.MinValue;
                if (ds.Value < 0)
                {
                    if (ds.Applied == true)
                    {
                        tempdate = ds.Date;
                    }
                    if (ds.PurposeText != "Amortization")
                    {
                        if (ds.Comment != null)
                        {
                            if (ds.Comment != "")
                            {
                                tempdate = ds.Date;
                            }
                        }
                    }

                    if (tempdate != DateTime.MinValue)
                    {
                        if (maxrepayDate == DateTime.MinValue)
                        {
                            maxrepayDate = ds.Date;
                        }
                        else
                        {
                            maxrepayDate = DateExtensions.GetMaxDate(maxrepayDate.Value.Date, ds.Date.Value.Date);
                        }
                    }
                }
                else
                {
                    if (ds.Applied == true)
                    {
                        tempdate = ds.Date;
                    }
                    if (tempdate != DateTime.MinValue)
                    {
                        if (maxrepayDate == DateTime.MinValue)
                        {
                            maxrepayDate = ds.Date;
                        }
                        else
                        {
                            maxrepayDate = DateExtensions.GetMaxDate(maxrepayDate.Value.Date, ds.Date.Value.Date);
                        }
                    }
                }
            }
            maxLockedDate = maxrepayDate.Value;

            RepaymentStartDate = DateExtensions.GetMaxDate(maxrepayDate.Value.Date, EarliestPossibleRepaymentDate.Value.Date);
            RepaymentStartDate = DateExtensions.GetMaxDate(RepaymentStartDate.Value.Date, CalculatedRepaymentStartDate.Value.Date);
            RepaymentStartDate = DateExtensions.GetMaxDate(RepaymentStartDate.Value.Date, TodayDatePlusBlockoutperiod.Value.Date);

            foreach (var payoff in dealDC.ListProjectedPayoff)
            {
                if (payoff.CumulativeProbability == 0m)
                {
                    if (MaxDateWithZeroCummulativeProbability != DateTime.MinValue)
                    {
                        MaxDateWithZeroCummulativeProbability = DateExtensions.GetMaxDate(MaxDateWithZeroCummulativeProbability.Value.Date, Convert.ToDateTime(payoff.ProjectedPayoffAsofDate));
                    }
                    else
                    {

                        MaxDateWithZeroCummulativeProbability = payoff.ProjectedPayoffAsofDate;
                    }
                }
                else if (payoff.CumulativeProbability == 1m)
                {
                    if (MinDateWith100CummulativeProbability != DateTime.MinValue)
                    {

                        MinDateWith100CummulativeProbability = DateExtensions.GetMinDate(MinDateWith100CummulativeProbability.Value.Date, Convert.ToDateTime(payoff.ProjectedPayoffAsofDate));
                    }
                    else
                    {
                        MinDateWith100CummulativeProbability = payoff.ProjectedPayoffAsofDate.Value.Date; ;
                    }


                }

            }
            if (MaxDateWithZeroCummulativeProbability != DateTime.MinValue)
            {
                MaxDateWithZeroCummulativeProbability = MaxDateWithZeroCummulativeProbability.Value.AddDays(1);
                MaxDateWithZeroCummulativeProbability = DateExtensions.CreateNewDate(MaxDateWithZeroCummulativeProbability.Value.Year, MaxDateWithZeroCummulativeProbability.Value.Month, dayofthemonth);
                RepaymentStartDate = DateExtensions.GetMaxDate(RepaymentStartDate.Value.Date, MaxDateWithZeroCummulativeProbability.Value.Date);
            }
            // if no date take FirstPaymentDate
            if (RepaymentStartDate == null)
            {
                if (RepaymentStartDate == DateTime.MinValue)
                {
                    RepaymentStartDate = dealDC.FirstPaymentDate.Value;
                }
            }
            tempstartDate = RepaymentStartDate.Value;
            // create a date
            if (dealDC.PossibleRepaymentdayofthemonth != null)
            {
                if (dealDC.PossibleRepaymentdayofthemonth != 0)
                {
                    if (dealDC.PossibleRepaymentdayofthemonth == 31)
                    {
                        RepaymentStartDate = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(RepaymentStartDate.Value.Year, RepaymentStartDate.Value.Month, Convert.ToInt32(15)));
                    }

                }
                else
                {
                    if (dealDC.FirstPaymentDate.Value != null)
                    {
                        RepaymentStartDate = DateExtensions.CreateNewDate(RepaymentStartDate.Value.Year, RepaymentStartDate.Value.Month, dealDC.FirstPaymentDate.Value.Day);
                    }
                }
            }
            else
            {
                if (dealDC.FirstPaymentDate != null)
                {
                    RepaymentStartDate = DateExtensions.CreateNewDate(RepaymentStartDate.Value.Year, RepaymentStartDate.Value.Month, dealDC.FirstPaymentDate.Value.Day);
                }

            }

            if (RepaymentStartDate.Value < tempstartDate)
            {
                FirstRepayDate = DateExtensions.CreateNewDate(RepaymentStartDate.Value.Year, RepaymentStartDate.Value.Month + 1, RepaymentStartDate.Value.Day);
            }
            else
            {
                FirstRepayDate = RepaymentStartDate.Value;
            }

            return RepaymentStartDate;
        }

        public DateTime? GetAutoSpreadRepaymentEndDate(DateTime? RepaymentStartDate)
        {
            DateTime? ProjectedPayoffAsofDateWith100Per = DateTime.MinValue;
            DateTime? LastProjectedPayoffAsofDate = DateTime.MinValue;
            DateTime? RepayEndDate = DateTime.MinValue;

            foreach (var payoff in dealDC.ListProjectedPayoff)
            {
                if (payoff.ProjectedPayoffAsofDate >= RepaymentStartDate)
                {
                    CummulativeProbabilityDataContract cpd = new CummulativeProbabilityDataContract();
                    cpd.ProjectedPayoffAsofDate = Convert.ToDateTime(payoff.ProjectedPayoffAsofDate.Value.Date);
                    cpd.CumulativeProbability = payoff.CumulativeProbability;
                    ListCummulativeProbability.Add(cpd);

                    if (payoff.CumulativeProbability == 1)
                    {
                        if (ProjectedPayoffAsofDateWith100Per == DateTime.MinValue)
                        {
                            ProjectedPayoffAsofDateWith100Per = payoff.ProjectedPayoffAsofDate;
                        }
                        else if (payoff.ProjectedPayoffAsofDate < ProjectedPayoffAsofDateWith100Per.Value.Date)
                        {
                            ProjectedPayoffAsofDateWith100Per = payoff.ProjectedPayoffAsofDate;
                        }
                    }

                    if (payoff.CumulativeProbability.GetValueOrDefault(0) != 0)
                    {
                        datainCumulativeProbability = true;
                    }
                }

                if (LastProjectedPayoffAsofDate != DateTime.MinValue)
                {
                    LastProjectedPayoffAsofDate = DateExtensions.GetMaxDate(LastProjectedPayoffAsofDate.Value.Date, payoff.ProjectedPayoffAsofDate.Value);
                }
                else
                {
                    LastProjectedPayoffAsofDate = payoff.ProjectedPayoffAsofDate.Value;
                }

            }

            if (dealDC.LatestPossibleRepaymentDate != null)
            {
                RepayEndDate = dealDC.LatestPossibleRepaymentDate.Value.Date;
            }

            if (ProjectedPayoffAsofDateWith100Per != DateTime.MinValue)
            {
                if (RepayEndDate != DateTime.MinValue)
                {
                    RepayEndDate = DateExtensions.GetMinDate(RepayEndDate.Value.Date, ProjectedPayoffAsofDateWith100Per.Value.Date);
                }
                else
                {
                    RepayEndDate = ProjectedPayoffAsofDateWith100Per;
                }
            }
            //LastProjectedPayoffAsofDate
            if (RepayEndDate == null || RepayEndDate == DateTime.MinValue)
            {
                RepayEndDate = LastProjectedPayoffAsofDate;
            }
            //if (dealDC.maxMaturityDate != null && dealDC.maxMaturityDate != DateTime.MinValue)
            //{
            //    if (RepayEndDate != DateTime.MinValue)
            //    {
            //        if (RepayEndDate > dealDC.maxMaturityDate.Value.Date)
            //        {
            //            RepayEndDate = dealDC.maxMaturityDate.Value.Date;
            //            EventTrueup = true;
            //        }
            //    }
            //    else
            //    {
            //        RepayEndDate = dealDC.maxMaturityDate.Value.Date;
            //        EventTrueup = true;
            //    }

            //}

            return RepayEndDate.Value.Date;

        }

        public void CalculateCPRAndSLFactor(DateTime? repaystartdate)
        {
            int listindex = 0;
            int numberofmonths = 0;
            bool eventLatestPossibleRepaymentDate = false;
            int dayofthemonth = GetDayofTheMonth();
            ListCummulativeProbability.RemoveAll(x => x.ProjectedPayoffAsofDate > RepaymentEndDate);
            ListCummulativeProbability.RemoveAll(x => x.ProjectedPayoffAsofDate < repaystartdate);
            // un comment below line after release on 04/10/2021 
            //ListCummulativeProbability.RemoveAll(x => x.ProjectedPayoffAsofDate > repaystartdate && x.CumulativeProbability == 0);

            foreach (var current in ListCummulativeProbability)
            {
                if (current.ProjectedPayoffAsofDate.Value.Date >= repaystartdate && current.ProjectedPayoffAsofDate.Value.Date <= RepaymentEndDate)
                {
                    if (listindex > 0)
                    {
                        current.CalculatedStart = ListCummulativeProbability[listindex - 1].CalculatedEnd.Value.AddDays(1);
                    }
                    else
                    {
                        current.CalculatedStart = repaystartdate;
                    }
                    if (RepaymentEndDate != null || RepaymentEndDate != DateTime.MinValue)
                    {
                        if (current.ProjectedPayoffAsofDate > RepaymentEndDate)
                        {
                            eventLatestPossibleRepaymentDate = true;
                        }
                        else
                        {
                            current.CalculatedEnd = current.ProjectedPayoffAsofDate;
                        }
                    }
                    else
                    {
                        current.CalculatedEnd = current.ProjectedPayoffAsofDate;
                    }

                    if (listindex > 0)
                    {
                        current.PeriodicProbability = CalculatePeriodicProbability(listindex, current.CumulativeProbability.GetValueOrDefault(0));
                        current.CPRProbability = CalculateCPRProbability(listindex, current.CumulativeProbability.GetValueOrDefault(0));
                        current.CPRCummulative = current.CumulativeProbability.GetValueOrDefault(0);
                    }
                    else
                    {
                        current.PeriodicProbability = current.CumulativeProbability.GetValueOrDefault(0);
                        current.CPRProbability = current.CumulativeProbability.GetValueOrDefault(0);
                        current.CPRCummulative = current.CPRProbability;
                    }
                    numberofmonths = GetNumberOfMonths(current.CalculatedStart.Value, Convert.ToDateTime(current.CalculatedEnd), Convert.ToInt32(dealDC.Repaymentallocationfrequency), DateExtensions.GetMonthsDiffIgnoringDays(current.CalculatedStart.Value, current.CalculatedEnd.Value), dayofthemonth);
                    if (numberofmonths == 0)
                    {
                        current.CPRFactor = 0;
                        current.StraightLineFactor = 0;
                    }
                    else
                    {
                        current.CPRFactor = CalculateCPRFactor(listindex, current.CPRProbability, numberofmonths, current.CumulativeProbability);
                        current.StraightLineFactor = NumericExtension.SafeDivision(Convert.ToDecimal(current.PeriodicProbability), numberofmonths);
                    }

                    listindex = listindex + 1;
                }
            }

            if (dealDC.LatestPossibleRepaymentDate.Value.Date == RepaymentEndDate || EventTrueup == true)
            {    // added when Latest Possible Repayment Date is provided
                DateTime? dt = DateTime.MinValue;
                if (ListCummulativeProbability != null)
                {
                    if (ListCummulativeProbability.Count > 0)
                    {
                        dt = ListCummulativeProbability.Max(x => x.ProjectedPayoffAsofDate);

                        if (dt == DateTime.MinValue)
                        {
                            dt = DateExtensions.CreateNewDate(RepaymentEndDate.Value.Year, RepaymentEndDate.Value.Month, 1);
                        }

                        CummulativeProbabilityDataContract current = new CummulativeProbabilityDataContract();
                        current.ProjectedPayoffAsofDate = RepaymentEndDate;
                        current.CumulativeProbability = 1M;
                        current.CalculatedEnd = RepaymentEndDate;
                        current.CalculatedStart = dt.Value.AddDays(1);

                        current.PeriodicProbability = CalculatePeriodicProbability(ListCummulativeProbability.Count, current.CumulativeProbability.GetValueOrDefault(0));
                        current.CPRProbability = CalculateCPRProbability(ListCummulativeProbability.Count, current.CumulativeProbability.GetValueOrDefault(0));
                        current.CPRCummulative = current.CumulativeProbability.GetValueOrDefault(0);

                        numberofmonths = GetNumberOfMonthsRepay(current.CalculatedStart.Value, Convert.ToDateTime(current.CalculatedEnd), Convert.ToInt32(dealDC.Repaymentallocationfrequency), DateExtensions.GetMonthsDiffIgnoringDays(current.CalculatedStart.Value, current.CalculatedEnd.Value), dayofthemonth);
                        current.CPRFactor = CalculateCPRFactor(ListCummulativeProbability.Count, current.CPRProbability, numberofmonths, current.CumulativeProbability);
                        current.StraightLineFactor = NumericExtension.SafeDivision(Convert.ToDecimal(current.PeriodicProbability), numberofmonths);

                        ListCummulativeProbability.Add(current);
                    }
                    else if (RepaymentEndDate != DateTime.MinValue && repaystartdate != DateTime.MinValue)
                    {
                        dt = DateExtensions.CreateNewDate(repaystartdate.Value.Year, repaystartdate.Value.Month, 1);

                        CummulativeProbabilityDataContract current = new CummulativeProbabilityDataContract();
                        current.ProjectedPayoffAsofDate = RepaymentEndDate;
                        current.CumulativeProbability = 1M;
                        current.CalculatedEnd = RepaymentEndDate;
                        current.CalculatedStart = dt;

                        current.PeriodicProbability = CalculatePeriodicProbability(ListCummulativeProbability.Count, current.CumulativeProbability.GetValueOrDefault(0));
                        current.CPRProbability = CalculateCPRProbability(ListCummulativeProbability.Count, current.CumulativeProbability.GetValueOrDefault(0));
                        current.CPRCummulative = current.CumulativeProbability.GetValueOrDefault(0);

                        numberofmonths = GetNumberOfMonthsRepay(current.CalculatedStart.Value, Convert.ToDateTime(current.CalculatedEnd), Convert.ToInt32(dealDC.Repaymentallocationfrequency), DateExtensions.GetMonthsDiffIgnoringDays(current.CalculatedStart.Value, current.CalculatedEnd.Value), dayofthemonth);
                        current.CPRFactor = CalculateCPRFactor(ListCummulativeProbability.Count, current.CPRProbability, numberofmonths, current.CumulativeProbability);
                        current.StraightLineFactor = NumericExtension.SafeDivision(Convert.ToDecimal(current.PeriodicProbability), numberofmonths);

                        ListCummulativeProbability.Add(current);
                    }
                    else if (ListCummulativeProbability.Count == 0)
                    {
                        generateonLatestpossibleprepayment = true;
                    }
                    else
                    {
                        bool novalueonasofdate = true;
                        foreach (var current in ListCummulativeProbability)
                        {
                            if (current.CumulativeProbability > 0)
                            {
                                novalueonasofdate = false;
                                break;
                            }
                        }

                        if (novalueonasofdate == true)
                        {
                            generateonLatestpossibleprepayment = true;
                        }

                    }
                }
            }
        }

        public decimal? CalculateCPRFactor(int index, decimal? CPRProbability, int numberofmonths, decimal? CumulativeProbability)
        {
            Decimal? CPRFactor = 0;
            Decimal? prevCumulativeProbability = 0;
            if (index > 0)
            {
                prevCumulativeProbability = ListCummulativeProbability[index - 1].CumulativeProbability.GetValueOrDefault(0);
            }
            else
            {
                prevCumulativeProbability = 0;
            }

            if (CumulativeProbability.GetValueOrDefault(0) - prevCumulativeProbability == 0)
            {
                CPRFactor = 0;
            }
            else if (CumulativeProbability.GetValueOrDefault(0) - prevCumulativeProbability == 1)
            {
                //POWER(1-POWER(0.99999999,I17),1/117)
                double fixednumber = 0.99999999;
                double x = 1 - Math.Pow(fixednumber, numberofmonths);
                double y = Convert.ToDouble(NumericExtension.SafeDivision(Convert.ToDecimal(1), Convert.ToDecimal(117)));
                CPRFactor = Convert.ToDecimal(Math.Pow(x, y));
            }
            else
            {
                double x = Convert.ToDouble(1 - CPRProbability);
                double y = Convert.ToDouble(NumericExtension.SafeDivision(Convert.ToDecimal(1), numberofmonths));
                CPRFactor = Convert.ToDecimal(Math.Pow(x, y));
            }
            return CPRFactor;
        }

        public decimal? CalculatePeriodicProbability(int index, decimal? CumulativeProbability)
        {
            Decimal? PeriodicProbability = 0;
            if (index > 0)
            {
                PeriodicProbability = CumulativeProbability.GetValueOrDefault(0) - ListCummulativeProbability[index - 1].CPRCummulative.GetValueOrDefault(0);
            }
            return PeriodicProbability;
        }

        public decimal? CalculateCPRProbability(int index, decimal? CumulativeProbability)
        {
            Decimal? CPRProbability = 0;
            try
            {

                if (index > 0)
                {
                    if (CumulativeProbability == 1)
                    {
                        CPRProbability = CumulativeProbability - ListCummulativeProbability[index - 1].CPRCummulative.GetValueOrDefault(0);
                    }
                    else
                    {
                        CPRProbability = (CumulativeProbability.GetValueOrDefault(0) - ListCummulativeProbability[index - 1].CPRCummulative.GetValueOrDefault(0)) / (1 - ListCummulativeProbability[index - 1].CPRCummulative.GetValueOrDefault(0));
                    }
                }

            }
            catch (Exception ex)
            {

                CPRProbability = 0;
            }
            return CPRProbability;
        }

        public Decimal? GetMonthlyCPRandSLRatio(DateTime currentdate, string ratiotype)
        {
            Decimal? rate = 0;
            foreach (var current in ListCummulativeProbability)
            {
                if (current.ProjectedPayoffAsofDate >= currentdate)
                {
                    if (ratiotype == "CPR")
                    {
                        rate = current.CPRFactor;
                    }
                    else if (ratiotype == "Straight-line")
                    {
                        rate = current.StraightLineFactor;
                    }
                    else if (ratiotype == "Date Specific")
                    {
                        rate = current.CumulativeProbability;
                    }
                    break;
                }

            }
            return rate;
        }

        public Decimal? GetCurrentBalance(DateTime repaymentstartdate, DateTime currentdate, decimal prevEndingBalance, DateTime lastfunddate)
        {
            CurrentCalculatedAutoRepayment = new CalculatedAutoRepaymentDataContract();
            Decimal? BeginningBalance = 0;
            DateTime monthstartDate = DateExtensions.FirstDateOfMonth(currentdate);
            DateTime endOfMonth = DateExtensions.LastDateOfMonth(currentdate);
            DateTime fundingStartDate = DateTime.MinValue;
            DateTime fundingEndDate = DateTime.MinValue;
            Decimal? sum = 0;
            Decimal? sumamort = 0;
            Decimal? sumPikFunding = 0;
            decimal? NonCommitmentAdjsum = 0;
            decimal? sumrevolver = 0;
            decimal? repaytotal = 0;

            decimal? fundingtotal = 0;
            PreviousEndingBalance = 0;

            if (repaymentstartdate.Date == currentdate.Date)
            {
                if (dealDC.maxWiredDatecalculated != DateTime.MinValue)
                {
                    fundingStartDate = dealDC.maxWiredDatecalculated.AddDays(1);
                }
                else
                {
                    fundingStartDate = dealDC.MaxWireConfirmRecord.AddDays(1);
                }

                lastfunddate = currentdate;
                fundingEndDate = currentdate;
            }
            else
            {
                fundingStartDate = lastfunddate.AddDays(1);
                fundingEndDate = currentdate;
            }
            if (repaymentstartdate.Date == currentdate.Date)
            {
                NonCommitmentAdjTotal = 0;
                RevolverTotal = 0;
                autoSpreadFundingcmp = 0;
                autoSpreadRepaymentcmp = 0;
                BeginningBalance = GetStartingBalance(repaymentstartdate);
                CurrentCalculatedAutoRepayment.BeginningBalance = dealDC.Endingbalance;
                //CurrentCalculatedAutoRepayment.EndingBalance = BeginningBalance;

            }
            else
            {
                BeginningBalance = prevEndingBalance;
                CurrentCalculatedAutoRepayment.BeginningBalance = BeginningBalance;
                //CurrentCalculatedAutoRepayment.EndingBalance = BeginningBalance;
                foreach (var fundng in dealDC.PayruleDealFundingList)
                {
                    if (fundng.Date.Value.Date >= fundingStartDate && fundng.Date.Value.Date <= fundingEndDate)
                    {
                        if (fundng.AdjustmentType != 834 && fundng.AdjustmentType != 896 && fundng.AdjustmentType != 835 && fundng.PurposeID != 840)
                        {
                            if (fundng.Value > 0)
                            {
                                fundingtotal = fundingtotal + fundng.Value;
                            }
                            else if (fundng.Value < 0)
                            {
                                //Amortization 351 Paydown  631
                                if (fundng.PurposeID != null)
                                {
                                    if (fundng.PurposeID != 631 && fundng.PurposeID != 351)
                                    {
                                        repaytotal = repaytotal.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                                    }
                                }
                            }
                        }
                    }
                }
                sumrevolver = GetRevolverBalance(fundingStartDate, fundingEndDate);
                BeginningBalance = BeginningBalance + fundingtotal + repaytotal - NonCommitmentAdjsum - sumrevolver;

                NonCommitmentAdjTotal = NonCommitmentAdjsum;
                RevolverTotal = sumrevolver;
                autoSpreadFundingcmp = fundingtotal;
                autoSpreadRepaymentcmp = repaytotal;
            }

            foreach (var bal in ListRepaymentBalances)
            {
                if (bal.Date.Value.Date >= fundingStartDate && bal.Date.Value.Date <= fundingEndDate)
                {
                    if (bal.Type == "PIKPrincipalFunding")
                    {
                        //sign will be negative from database
                        sumPikFunding = sumPikFunding.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                    }
                    else if (bal.Type == "PIKPrincipalPaid")
                    {
                        //sign will be positive from database
                        sum = sum.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                    }
                    else if (bal.Type == "ScheduledPrincipalPaid")
                    {
                        sumamort = sumamort.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                    }
                }
            }
            CurrentCalculatedAutoRepayment.Funding = autoSpreadFundingcmp;
            CurrentCalculatedAutoRepayment.PIKPrincipalPaid = sum.GetValueOrDefault(0) * -1;
            CurrentCalculatedAutoRepayment.PIKPrincipalFunding = sumPikFunding.GetValueOrDefault(0) * -1;
            CurrentCalculatedAutoRepayment.ScheduledPrincipalPaid = sumamort.GetValueOrDefault(0) * -1;
            CurrentCalculatedAutoRepayment.NonCommitmentAdjTotal = NonCommitmentAdjTotal * -1;
            CurrentCalculatedAutoRepayment.RevolverTotal = RevolverTotal * -1;
            CurrentCalculatedAutoRepayment.Repayment = autoSpreadRepaymentcmp;

            BeginningBalance = BeginningBalance + sum * -1 + sumPikFunding * -1 + sumamort.GetValueOrDefault(0) * -1;
            PreviousEndingBalance = BeginningBalance;
            CurrentCalculatedAutoRepayment.EndingBalance = BeginningBalance;
            return BeginningBalance;
        }

        public decimal? GetSumAmortAndPikAfterEndDate(DateTime currentdate)
        {
            decimal? amount = 0;
            Decimal? pikFunding = 0;
            Decimal? pikPaid = 0, sumamort = 0;


            foreach (var bal in ListRepaymentBalances)
            {
                if (bal.Date.Value.Date > currentdate.Date)
                {
                    if (bal.Type == "PIKPrincipalPaid")
                    {
                        pikPaid = pikPaid.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0) * -1;
                    }
                    else if (bal.Type == "PIKPrincipalFunding")
                    {
                        pikFunding = pikFunding.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0) * -1;
                    }
                    else if (bal.Type == "ScheduledPrincipalPaid")
                    {
                        sumamort = sumamort.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                    }
                }
            }

            amount = pikPaid.GetValueOrDefault(0) + pikFunding.GetValueOrDefault(0) + sumamort.GetValueOrDefault(0) * -1;
            return amount;
        }
        public DateTime CalculateExpectedMaturityDate()
        {
            DateTime? lMinDateWith100CummulativeProbability = MinDateWith100CummulativeProbability;
            DateTime? FinalPaydownDate = DateTime.MinValue;

            foreach (var funding in dealDC.PayruleDealFundingList)
            {
                if (funding.PurposeText == "Paydown")
                {
                    if (FinalPaydownDate == DateTime.MinValue)
                    {
                        FinalPaydownDate = funding.Date;
                    }
                    else
                    {
                        FinalPaydownDate = DateExtensions.GetMaxDate(FinalPaydownDate.Value.Date, funding.Date.Value.Date);
                    }
                }
            }
            if (dealDC.LatestPossibleRepaymentDate == null)
            {
                dealDC.LatestPossibleRepaymentDate = DateTime.MinValue;
            }
            if (dealDC.ExpectedFullRepaymentDate == null)
            {
                dealDC.ExpectedFullRepaymentDate = DateTime.MinValue;
            }

            if (lMinDateWith100CummulativeProbability <= DateTime.Now)
            {
                lMinDateWith100CummulativeProbability = DateTime.MinValue;
            }

            //: MIN (Max(Fully extended maturity date for all Notes within a deal),Latest Possible Repayment Date, 100% prob AsofDate if available)
            DateTime ExpectedMaturityDate = DateTime.MinValue;
            ExpectedMaturityDate = DateExtensions.GetMinDate(dealDC.LatestPossibleRepaymentDate.Value.Date, Convert.ToDateTime(lMinDateWith100CummulativeProbability));
            ExpectedMaturityDate = DateExtensions.GetMinDate(dealDC.maxMaturityDate.Value.Date, ExpectedMaturityDate);
            ExpectedMaturityDate = DateExtensions.GetMinDate(dealDC.ExpectedFullRepaymentDate.Value.Date, ExpectedMaturityDate);
            //if (ExpectedMaturityDate.Year == FinalPaydownDate.Value.Year && ExpectedMaturityDate.Month == FinalPaydownDate.Value.Month)
            //    ExpectedMaturityDate = FinalPaydownDate.Value;
            ExpectedMaturityDate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(ExpectedMaturityDate), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            return ExpectedMaturityDate;
        }

        public decimal? GetStartingBalance(DateTime repaymentstartdate)
        {
            decimal? currentrevolverbal = 0, databaserevolverbal = 0, revolverbalance = 0;
            Decimal? sum = 0;
            Decimal? ffsum = 0;
            Decimal? pikfunding = 0;
            DateTime monthstartDate = dealDC.MaxWireConfirmRecord;
            DateTime endOfMonth = repaymentstartdate;
            Decimal? sumrepay = 0;
            Decimal? NonCommitmentAdjsum = 0, NonCommitmentAdjsumComponent = 0;
            decimal? revolverComponent = 0;
            decimal writeoffonstart = 0;
            foreach (var bal in ListRepaymentBalances)
            {
                if (bal.Date.Value.Date == monthstartDate.Date)
                {
                    if (bal.Type == "PIKPrincipalPaid")
                    {
                        pikfunding = pikfunding + bal.Amount.GetValueOrDefault(0);
                    }
                }
            }

            foreach (var writeoff in dealDC.PayruleDealFundingList_Pwriteoff)
            {
                if (writeoff.Date.Value.Date == monthstartDate.Date && writeoff.Applied == true)
                {
                    writeoffonstart = writeoffonstart + writeoff.Value.GetValueOrDefault(0);
                }
            }

            foreach (var fundng in dealDC.DealFundingListAdjustmentTypeAutoSpread)
            {
                if (fundng.Date.Value.Date >= monthstartDate && fundng.Date.Value.Date <= endOfMonth)
                {
                    if (fundng.Applied == true)
                    {
                        if (fundng.Value > 0)
                        {
                            if (fundng.PurposeID != 840)
                            {
                                if (fundng.AdjustmentType == 834 || fundng.AdjustmentType == 896)
                                {
                                    NonCommitmentAdjsumComponent = NonCommitmentAdjsumComponent.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                                }
                            }
                        }
                    }
                    if (fundng.AdjustmentType == 835)
                    {
                        revolverComponent = revolverComponent.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                    }
                }

                //remove all adjustment type from balance 
                if (fundng.Date.Value.Date <= endOfMonth)
                {
                    if (fundng.Applied == true)
                    {
                        //834  Non - Commitment Adjustment
                        if (fundng.PurposeID != 840)
                        {
                            if (fundng.AdjustmentType == 834 || fundng.AdjustmentType == 896)
                            {
                                NonCommitmentAdjsum = NonCommitmentAdjsum.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }
                        if (fundng.AdjustmentType == 835)
                        {
                            currentrevolverbal = currentrevolverbal.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                        }
                    }

                }
            }

            if (dealDC.ListRevolverDealFunding != null)
            {
                foreach (var fundng in dealDC.ListRevolverDealFunding)
                {
                    if (fundng.Applied == true)
                    {
                        databaserevolverbal = databaserevolverbal.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                    }
                }
            }
            else
            {
                databaserevolverbal = 0;
            }
            revolverbalance = currentrevolverbal - databaserevolverbal;
            foreach (var fundng in dealDC.PayruleDealFundingList)
            {
                if (fundng.Date != null)
                {
                    if (fundng.AdjustmentType != 834 && fundng.AdjustmentType != 896 && fundng.AdjustmentType != 835 && fundng.PurposeID != 840)
                    {
                        if (fundng.Date.Value.Date >= monthstartDate && fundng.Date.Value.Date <= endOfMonth)
                        {
                            if (fundng.Value > 0)
                            {
                                sum = sum.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);

                            }
                            else if (fundng.Value < 0 && fundng.Applied == true)
                            {
                                sumrepay = sumrepay.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                            else if (fundng.Value < 0 && fundng.PurposeID != 351 && fundng.PurposeID != 631)
                            {
                                sumrepay = sumrepay.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }

                        if (fundng.Date.Value.Date > monthstartDate && fundng.Date.Value.Date <= endOfMonth)
                        {
                            if (fundng.Value < 0 && fundng.PurposeText == "Paydown")
                            {
                                RepayToBeAdjusted = RepayToBeAdjusted.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }
                    }
                }
            }
            autoSpreadFundingcmp = sum;
            autoSpreadRepaymentcmp = sumrepay;
            if (generateonLatestpossibleprepayment == true)
            {
                //sumrevolver balance does not has any effecte for case generateonLatestpossibleprepayment
                sum = sum.GetValueOrDefault(0) + dealDC.Endingbalance + NonCommitmentAdjsumComponent + revolverComponent + sumrepay.GetValueOrDefault(0) + pikfunding.GetValueOrDefault(0) * -1 - NonCommitmentAdjsum + writeoffonstart;
            }
            else
            {
                //NonCommitmentAdjsum balance does not has any effecte for case generateonLatestpossibleprepayment             
                sum = sum.GetValueOrDefault(0) + dealDC.Endingbalance + NonCommitmentAdjsumComponent + revolverComponent + sumrepay.GetValueOrDefault(0) + pikfunding.GetValueOrDefault(0) * -1 - NonCommitmentAdjsum + writeoffonstart + revolverbalance;
            }

            NonCommitmentAdjTotal = NonCommitmentAdjsum - NonCommitmentAdjsumComponent;
            RevolverTotal = revolverbalance;
            return sum;
        }


        public Decimal? CumulativeTotalAmount(DateTime repaymentstartdate, DateTime currentdate)
        {
            Decimal? repaytotal = 0;
            foreach (var repay in dealDC.PayruleDealFundingList)
            {
                if (repay.Value < 0)
                {
                    if (repay.Date >= repaymentstartdate && repay.Date < currentdate)
                    {
                        if (repay.PurposeText == "Paydown")
                        {
                            repaytotal = repaytotal + repay.Value;
                        }
                    }
                }
            }
            repaytotal = repaytotal.GetValueOrDefault(0) + RepayToBeAdjusted.GetValueOrDefault(0);
            return repaytotal;
        }
        public void DistributeRepayAmount(DateTime? RepaymentStartDate, DateTime? RepaymentEndDate)
        {
            decimal? MonthlyFactor = 0;
            decimal? Balance = 0;
            decimal? CummulativeRepayments = 0, LastPreviousBalance;
            int totalmonths = 0;
            int monthpart = 0;
            DateTime? dealfunddate = DateTime.MinValue;
            DateTime? lastfunddate = DateTime.MinValue;
            DateTime? lastusedfunddate = DateTime.MinValue;

            int listindex = 0;
            PreviousEndingBalance = 0;
            Decimal? amount = 0;
            int dayofthemonth = GetDayofTheMonth();

            if (dealDC.Repaymentallocationfrequency > 1)
            {
                monthpart = Convert.ToInt16(dealDC.Repaymentallocationfrequency);
            }
            else
            {
                monthpart = 1;
            }

            if (dealDC.PossibleRepaymentdayofthemonth == 31)
            {
                RepaymentStartDate = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(FirstRepayDate.Value.Year, FirstRepayDate.Value.Month, 20));
                RepaymentEndDate = DateExtensions.LastDateOfMonth(RepaymentEndDate.Value);
            }
            else
            {
                RepaymentStartDate = DateExtensions.CreateNewDate(FirstRepayDate.Value.Year, FirstRepayDate.Value.Month, dayofthemonth);
            }
            totalmonths = DateExtensions.GetMonthsDiffIgnoringDays(RepaymentStartDate.Value, RepaymentEndDate.Value);
            for (int i = 0; i < totalmonths; i++)
            {
                if (i == 0)
                {
                    dealfunddate = RepaymentStartDate;
                }
                else
                {
                    if (dealDC.PossibleRepaymentdayofthemonth == 31)
                    {
                        dealfunddate = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(lastfunddate.Value.Year, lastfunddate.Value.Month + monthpart, 20));

                    }
                    else
                    {
                        dealfunddate = DateExtensions.CreateNewDate(lastfunddate.Value.Year, lastfunddate.Value.Month + monthpart, dayofthemonth);
                    }
                }

                if (dealfunddate > RepaymentEndDate.Value)
                {
                    if (i == 0)
                    {
                        DateTime returndate = CheckOneRecordInAmonth(RepaymentEndDate.Value);
                        if (returndate.Date != RepaymentEndDate.Value)
                        {
                            break;
                        }

                    }
                    dealfunddate = RepaymentEndDate.Value;
                    if (lastfunddate == dealfunddate.Value)
                    {
                        break;
                    }

                }
                lastfunddate = dealfunddate.Value;
                if (dealfunddate <= RepaymentEndDate.Value)
                {
                    amount = 0;
                    CalculatedAutoRepaymentDataContract car = new CalculatedAutoRepaymentDataContract();
                    LastPreviousBalance = PreviousEndingBalance.GetValueOrDefault(0);
                    Balance = GetCurrentBalance(RepaymentStartDate.Value, dealfunddate.Value, PreviousEndingBalance.GetValueOrDefault(0), Convert.ToDateTime(lastusedfunddate));
                    lastusedfunddate = dealfunddate.Value;
                    //  if (i > 0)
                    {
                        CummulativeRepayments = CumulativeTotalAmount(RepaymentStartDate.Value, dealfunddate.Value) * -1;
                    }
                    //car.BeginningBalance = Balance;
                    // if ((Balance.GetValueOrDefault(0) + Math.Abs(CummulativeRepayments.GetValueOrDefault(0))) != 0)
                    {
                        if (DateExtensions.LastDateOfMonth(dealfunddate.Value) == DateExtensions.LastDateOfMonth(RepaymentEndDate.Value))
                        {
                            //if (dealDC.maxMaturityDate != null)
                            //{
                            //    if (dealDC.maxMaturityDate != DateTime.MinValue)
                            //    {
                            //        if (RepaymentEndDate.Value > dealDC.maxMaturityDate)
                            //        {
                            //            dealfunddate = dealDC.maxMaturityDate.Value;
                            //        }
                            //    }
                            //}

                            var trueup = CheckifTrueUpisToBeApplyorNot(RepaymentStartDate, RepaymentEndDate);
                            if (trueup == true)
                            {
                                amount = Balance - CummulativeRepayments;
                                amount = Math.Max(0, amount.GetValueOrDefault(0));
                            }

                        }
                        else
                        {
                            if (dealDC.RepaymentAutoSpreadMethodText == "Date Specific")
                            {
                                MonthlyFactor = GetMonthlyCPRandSLRatio(dealfunddate.Value, "Date Specific");
                                car.CurrentCPRandSLRFactor = MonthlyFactor;
                                amount = Balance * car.CurrentCPRandSLRFactor;
                                amount = Math.Max(0, amount.GetValueOrDefault(0));

                            }
                            else if (dealDC.RepaymentAutoSpreadMethodText == "Straight-line")
                            {
                                MonthlyFactor = GetMonthlyCPRandSLRatio(dealfunddate.Value, "Straight-line");
                                car.CurrentCPRandSLRFactor = MonthlyFactor;
                                car.MonthlyCPRandSLRFactor = GetCPRUsedINCalculation("Straight-line", MonthlyFactor, listindex);
                                amount = (Balance * car.MonthlyCPRandSLRFactor) - CummulativeRepayments;
                                amount = Math.Max(0, amount.GetValueOrDefault(0));
                            }
                            else if (dealDC.RepaymentAutoSpreadMethodText == "CPR")
                            {
                                MonthlyFactor = GetMonthlyCPRandSLRatio(dealfunddate.Value, "CPR");
                                car.CurrentCPRandSLRFactor = MonthlyFactor;
                                car.MonthlyCPRandSLRFactor = GetCPRUsedINCalculation("CPR", MonthlyFactor, listindex);
                                amount = (Balance * (1 - car.MonthlyCPRandSLRFactor)) - CummulativeRepayments;
                                amount = Math.Max(0, amount.GetValueOrDefault(0));
                            }
                        }
                        if (listindex > 0)
                        {
                            if (CummulativeRepayments == LastPreviousBalance)
                            {
                                amount = 0;
                            }
                        }
                        PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
                        pdf.Date = dealfunddate.Value;
                        car.Date = pdf.Date;
                        pdf.PurposeText = "Paydown";
                        pdf.PurposeID = 631;// id for paydown in lookuptable
                        pdf.SubPurposeType = "";
                        pdf.RequiredEquity = 0;
                        pdf.Value = Math.Round(Convert.ToDecimal(amount * -1), 2);
                        car.Value = Math.Round(Convert.ToDecimal(amount * -1), 2);
                        pdf.Value1 = pdf.Value;
                        pdf.AdditionalEquity = 0;
                        pdf.Applied = false;
                        pdf.DealID = dealid;
                        pdf.DealFundingRowno = null;
                        pdf.DealFundingID = null;
                        pdf.WF_CurrentStatus = "Projected";
                        pdf.WF_CurrentStatusDisplayName = "Projected";
                        pdf.WF_IsAllow = true;
                        pdf.WF_isParticipate = true;
                        pdf.Comment = "";
                        pdf.WF_IsCompleted = false;
                        pdf.WF_IsFlowStart = false;
                        pdf.wf_isUserCurrentFlow = false;
                        pdf.GeneratedBy = 747;

                        car.Funding = CurrentCalculatedAutoRepayment.Funding;
                        car.PIKPrincipalPaid = CurrentCalculatedAutoRepayment.PIKPrincipalPaid;
                        car.PIKPrincipalFunding = CurrentCalculatedAutoRepayment.PIKPrincipalFunding;
                        car.ScheduledPrincipalPaid = CurrentCalculatedAutoRepayment.ScheduledPrincipalPaid;
                        car.EndingBalance = CurrentCalculatedAutoRepayment.EndingBalance;
                        car.NonCommitmentAdjTotal = CurrentCalculatedAutoRepayment.NonCommitmentAdjTotal;
                        car.RevolverTotal = CurrentCalculatedAutoRepayment.RevolverTotal;
                        car.Repayment = CurrentCalculatedAutoRepayment.Repayment;
                        car.BeginningBalance = CurrentCalculatedAutoRepayment.BeginningBalance;

                        ListCalculatedAutoRepayment.Add(car);
                        dealDC.PayruleDealFundingList.Add(pdf);

                    }

                    listindex = listindex + 1;
                }
                else
                {
                    break;
                }
            }
        }

        public void DistributeRepayAmountDateSpecific(DateTime? RepaymentStartDate, DateTime? RepaymentEndDate)
        {
            DateTime lastusedfunddate = DateTime.MinValue;
            DateTime repaydate = DateTime.MinValue;
            decimal? Balance = 0, CummulativeRepayments = 0;
            int dayofthemonth = GetDayofTheMonth();
            int listindex = 0;

            foreach (var current in ListCummulativeProbability)
            {
                if (current.ProjectedPayoffAsofDate.Value.Date <= RepaymentEndDate)
                {
                    repaydate = current.ProjectedPayoffAsofDate.Value.Date;
                    if (dealDC.PossibleRepaymentdayofthemonth == 31)
                    {
                        repaydate = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(repaydate.Year, repaydate.Month, 20));

                    }
                    else
                    {
                        repaydate = DateExtensions.CreateNewDate(repaydate.Year, repaydate.Month, dayofthemonth);
                    }
                    if (listindex == 0)
                    {
                        Balance = GetCurrentBalance(repaydate, repaydate, PreviousEndingBalance.GetValueOrDefault(0), Convert.ToDateTime(lastusedfunddate));
                    }
                    else
                    {
                        Balance = GetCurrentBalance(RepaymentStartDate.Value, repaydate, PreviousEndingBalance.GetValueOrDefault(0), Convert.ToDateTime(lastusedfunddate));
                    }
                    lastusedfunddate = repaydate;
                    CummulativeRepayments = CumulativeTotalAmount(RepaymentStartDate.Value, repaydate) * -1;
                    Balance = Balance * current.CumulativeProbability.GetValueOrDefault(0);
                    AddRepayToPayruleDealFundingList(repaydate, Balance);
                    listindex = listindex + 1;
                }
            }
            if (dealDC.LatestPossibleRepaymentDate.Value.Date == RepaymentEndDate || EventTrueup == true)
            {
                repaydate = Convert.ToDateTime(RepaymentEndDate);
                Balance = GetCurrentBalance(RepaymentStartDate.Value, repaydate, PreviousEndingBalance.GetValueOrDefault(0), Convert.ToDateTime(lastusedfunddate));
                AddRepayToPayruleDealFundingList(RepaymentEndDate, Balance);
            }
        }

        public int GetDayofTheMonth()
        {
            int dayofthemonth = 0;
            if (dealDC.PossibleRepaymentdayofthemonth != null)
            {
                dayofthemonth = dealDC.PossibleRepaymentdayofthemonth.Value;
            }
            else
            {
                if (dealDC.FirstPaymentDate != null)
                {
                    if (dealDC.FirstPaymentDate.Value != DateTime.MinValue)
                    {
                        dayofthemonth = dealDC.FirstPaymentDate.Value.Day;
                    }
                }
                else
                {
                    dayofthemonth = 20;
                }
            }

            return dayofthemonth;
        }
        public decimal? GetCPRUsedINCalculation(string ratiotype, decimal? currentfactor, int index)
        {
            decimal? MonthlyCPRandSLRFactor = 0;
            if (ratiotype == "CPR")
            {
                if (index > 0)
                {
                    if (currentfactor == 0)
                    {
                        MonthlyCPRandSLRFactor = ListCalculatedAutoRepayment[index - 1].MonthlyCPRandSLRFactor;
                    }
                    else
                    {
                        MonthlyCPRandSLRFactor = currentfactor * ListCalculatedAutoRepayment[index - 1].MonthlyCPRandSLRFactor;
                    }

                }
                else
                {
                    MonthlyCPRandSLRFactor = currentfactor;
                }
            }
            else if (ratiotype == "Straight-line")
            {
                if (index > 0)
                {
                    MonthlyCPRandSLRFactor = currentfactor + ListCalculatedAutoRepayment[index - 1].MonthlyCPRandSLRFactor;
                }
                else
                {
                    MonthlyCPRandSLRFactor = currentfactor;
                }
            }

            return MonthlyCPRandSLRFactor;
        }

        public void CreateExpectedFullRepayRecord(DateTime ExpectedFullRepaymentDate)
        {
            DateTime? RepaymentStartDate = GetAutoSpreadRepaymentStartDate();
            ExpectedFullRepaymentDate = Convert.ToDateTime(GetAutoSpreadRepaymentEndDate(RepaymentStartDate));
            generateonLatestpossibleprepayment = true;

            Decimal? currentbalance = 0;
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.Value < 0 && ds.PurposeText == "Paydown")
                {
                    if (ds.Applied != true)
                    {
                        if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                        {
                            if (ds.Comment == null || ds.Comment == "")
                            {
                                ds.isdeleted = true;
                                PayruleDeletedDealFundingList.Add(ds);
                            }
                        }
                    }
                }

            }
            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);
            currentbalance = Convert.ToDecimal(GetCurrentBalance(ExpectedFullRepaymentDate, ExpectedFullRepaymentDate, 0, ExpectedFullRepaymentDate)) + GetSumAmortAndPikAfterEndDate(ExpectedFullRepaymentDate);

            decimal? repayment = 0;
            //find paydown with comment
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.Applied != true)
                {
                    if (pdf.PurposeText == "Paydown" && pdf.Comment != "" && pdf.Comment != null)
                    {
                        repayment = repayment + pdf.Value.GetValueOrDefault(0);
                    }
                }
            }

            currentbalance = currentbalance + repayment.GetValueOrDefault(0);
            if (currentbalance > 0)
            {
                AddRepayToPayruleDealFundingList(ExpectedFullRepaymentDate, currentbalance);
            }
            //soft pay of case
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.Date.Value.Date > ExpectedFullRepaymentDate.Date && pdf.Value > 0)
                {
                    AddRepaySameAsTheFunding(pdf.Date, pdf.Value);
                }
            }


            if (DealFundingListExtension != null)
            {
                foreach (var ds in DealFundingListExtension)
                {
                    dealDC.PayruleDealFundingList.Add(ds);
                }
            }
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.Value == 0 && pdf.PurposeText == "Paydown")
                {
                    pdf.isdeleted = true;
                    PayruleDeletedDealFundingList.Add(pdf);
                }
            }
            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);
        }

        public void AddRepayToPayruleDealFundingList(DateTime? funddate, Decimal? amount, int? DealFundingRowno = null)
        {
            CalculatedAutoRepaymentDataContract car = new CalculatedAutoRepaymentDataContract();
            PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
            pdf.Date = DateExtensions.GetWorkingDayUsingOffset(funddate.Value, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            pdf.PurposeText = "Paydown";
            pdf.PurposeID = 631;// id for paydown in lookuptable
            pdf.SubPurposeType = "";
            pdf.RequiredEquity = 0;
            pdf.Value = Math.Round(Convert.ToDecimal(amount * -1), 2);
            pdf.Value1 = pdf.Value;
            pdf.AdditionalEquity = 0;
            pdf.Applied = false;
            pdf.DealID = dealid;
            pdf.DealFundingRowno = DealFundingRowno;
            pdf.DealFundingID = null;
            pdf.WF_CurrentStatus = "Projected";
            pdf.WF_CurrentStatusDisplayName = "Projected";
            pdf.WF_IsAllow = true;
            pdf.WF_isParticipate = true;
            pdf.Comment = "";
            pdf.WF_IsCompleted = false;
            pdf.WF_IsFlowStart = false;
            pdf.wf_isUserCurrentFlow = false;
            pdf.GeneratedBy = 747;
            dealDC.PayruleDealFundingList.Add(pdf);

            car.Date = pdf.Date;
            car.Value = pdf.Value;
            ListCalculatedAutoRepayment.Add(car);
        }

        public void AddRepaySameAsTheFundingForUseRuleN(DateTime? funddate, int? DealFundingRowno)
        {
            decimal? dealamount = 0;

            funddate = DateExtensions.GetWorkingDayUsingOffset(funddate.Value, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            UseRuleNRowNumber = UseRuleNRowNumber + 1;
            var notelist = dealDC.PayruleTargetNoteFundingScheduleList.FindAll(x => x.DealFundingRowno == DealFundingRowno && x.Date.Value.Date == funddate.Value.Date).ToList();
            foreach (var item in notelist)
            {
                AddRepayToNoteFundingScheduleList(funddate, item.Value, UseRuleNRowNumber, item.NoteID.ToString(), item.NoteName);
                dealamount = dealamount.GetValueOrDefault(0) + item.Value.GetValueOrDefault(0);
            }

            CalculatedAutoRepaymentDataContract car = new CalculatedAutoRepaymentDataContract();
            PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
            pdf.Date = funddate;
            pdf.PurposeText = "Paydown";
            pdf.PurposeID = 631;// id for paydown in lookuptable
            pdf.SubPurposeType = "";
            pdf.RequiredEquity = 0;
            pdf.Value = Math.Round(Convert.ToDecimal(dealamount * -1), 2);
            pdf.AdditionalEquity = 0;
            pdf.Value1 = pdf.Value;
            pdf.Applied = false;
            pdf.DealID = dealid;
            pdf.DealFundingRowno = UseRuleNRowNumber;
            pdf.DealFundingID = null;
            pdf.WF_CurrentStatus = "Projected";
            pdf.WF_CurrentStatusDisplayName = "Projected";
            pdf.WF_IsAllow = true;
            pdf.WF_isParticipate = true;
            pdf.Comment = "";
            pdf.WF_IsCompleted = false;
            pdf.WF_IsFlowStart = false;
            pdf.wf_isUserCurrentFlow = false;
            pdf.GeneratedBy = 747;
            DealFundingListExtension.Add(pdf);

            car.Date = pdf.Date;
            car.Value = pdf.Value;
            ListCalculatedAutoRepayment.Add(car);
        }

        public void AddRepaySameAsTheFunding(DateTime? funddate, Decimal? amount, int? DealFundingRowno = null)
        {
            CalculatedAutoRepaymentDataContract car = new CalculatedAutoRepaymentDataContract();
            PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
            pdf.Date = DateExtensions.GetWorkingDayUsingOffset(funddate.Value, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            pdf.PurposeText = "Paydown";
            pdf.PurposeID = 631;// id for paydown in lookuptable
            pdf.SubPurposeType = "";
            pdf.RequiredEquity = 0;
            pdf.Value = Math.Round(Convert.ToDecimal(amount * -1), 2);
            pdf.AdditionalEquity = 0;
            pdf.Value1 = pdf.Value;
            pdf.Applied = false;
            pdf.DealID = dealid;
            pdf.DealFundingRowno = DealFundingRowno;
            pdf.DealFundingID = null;
            pdf.WF_CurrentStatus = "Projected";
            pdf.WF_CurrentStatusDisplayName = "Projected";
            pdf.WF_IsAllow = true;
            pdf.WF_isParticipate = true;
            pdf.Comment = "";
            pdf.WF_IsCompleted = false;
            pdf.WF_IsFlowStart = false;
            pdf.wf_isUserCurrentFlow = false;
            pdf.GeneratedBy = 747;
            DealFundingListExtension.Add(pdf);

            car.Date = pdf.Date;
            car.Value = pdf.Value;
            ListCalculatedAutoRepayment.Add(car);
        }

        public void AddRepayToPayruleDealFundingListUseRuleN(DateTime? funddate, Decimal? amount, decimal? CurrentCPRandSLRFactor, decimal? MonthlyCPRandSLRFactor, int? DealFundingRowno = null)
        {
            CalculatedAutoRepaymentDataContract car = new CalculatedAutoRepaymentDataContract();
            PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
            pdf.Date = funddate;
            pdf.PurposeText = "Paydown";
            pdf.PurposeID = 631;// id for paydown in lookuptable
            pdf.SubPurposeType = "";
            pdf.RequiredEquity = 0;
            pdf.Value = Math.Round(Convert.ToDecimal(amount * -1), 2);
            pdf.AdditionalEquity = 0;
            pdf.Value1 = pdf.Value;
            pdf.Applied = false;
            pdf.DealID = dealid;
            pdf.DealFundingRowno = DealFundingRowno;
            pdf.DealFundingID = null;
            pdf.WF_CurrentStatus = "Projected";
            pdf.WF_CurrentStatusDisplayName = "Projected";
            pdf.WF_IsAllow = true;
            pdf.WF_isParticipate = true;
            pdf.Comment = "";
            pdf.WF_IsCompleted = false;
            pdf.WF_IsFlowStart = false;
            pdf.wf_isUserCurrentFlow = false;
            pdf.GeneratedBy = 747;
            dealDC.PayruleDealFundingList.Add(pdf);

            car.Date = pdf.Date;
            car.Value = pdf.Value;
            car.CurrentCPRandSLRFactor = CurrentCPRandSLRFactor;
            car.MonthlyCPRandSLRFactor = MonthlyCPRandSLRFactor;

            ListCalculatedAutoRepayment.Add(car);
        }

        public void AddRepayToNoteFundingScheduleList(DateTime? funddate, Decimal? amount, int? DealFundingRowno, string NoteID, string NotenName)
        {
            PayruleTargetNoteFundingScheduleDataContract notefunding = new PayruleTargetNoteFundingScheduleDataContract();
            notefunding.Date = funddate;
            notefunding.Value = amount * -1;
            notefunding.NoteName = NotenName;
            notefunding.AccountId = null;
            notefunding.PurposeID = 631;
            notefunding.Purpose = "Paydown";
            notefunding.NoteID = new Guid(NoteID);
            notefunding.Applied = false;
            notefunding.DrawFundingId = null;
            notefunding.DealFundingRowno = DealFundingRowno;
            notefunding.Comments = "";
            notefunding.isDeleted = null;
            notefunding.NoteSplitDiff = null;
            notefunding.DealFundingID = null;
            notefunding.WF_CurrentStatus = "Projected";
            notefunding.WF_CurrentStatusDisplayName = "Projected";
            notefunding.OldComment = "";
            notefunding.GeneratedBy = 747;
            dealDC.PayruleTargetNoteFundingScheduleList.Add(notefunding);
        }

        public DateTime CheckOneRecordInAmonth(DateTime repaymentstartdate)
        {
            DateTime repaydateholidaiadj = repaymentstartdate;
            bool nextmonth = false;

            DateTime monthstartDate = DateExtensions.FirstDateOfMonth(repaydateholidaiadj);
            DateTime endOfMonth = DateExtensions.LastDateOfMonth(repaydateholidaiadj);

            foreach (var fund in dealDC.PayruleDealFundingList)
            {
                if (fund.Value < 0)
                {
                    if (fund.PurposeText != "Amortization" && fund.PurposeText != "Note Transfer")
                    {
                        if (fund.Date.Value.Date >= monthstartDate.Date && fund.Date.Value.Date <= endOfMonth.Date)
                        {
                            nextmonth = true;
                            break;
                        }
                    }

                }
            }
            if (nextmonth == true)
            {
                repaymentstartdate = repaymentstartdate.AddMonths(1);
            }

            return repaymentstartdate;
        }

        public DateTime RecalculateStartDateAgain(DateTime StartDate)
        {
            int dayofthemonth = GetDayofTheMonth();
            DateTime RepaymentStartDate = DateTime.MinValue;
            DateTime repaycalculated = DateTime.MinValue;

            RepaymentStartDate = CheckOneRecordInAmonth(Convert.ToDateTime(StartDate));
            repaycalculated = RepaymentStartDate;
            FirstRepayDate = RepaymentStartDate;

            if (dealDC.PossibleRepaymentdayofthemonth == 31)
            {
                repaycalculated = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(RepaymentStartDate.Year, RepaymentStartDate.Month, 20));
            }
            else
            {
                repaycalculated = DateExtensions.CreateNewDate(RepaymentStartDate.Year, RepaymentStartDate.Month, dayofthemonth);
            }

            if (repaycalculated < dealDC.MaxWireConfirmRecord)
            {
                FirstRepayDate = repaycalculated.AddMonths(1);
                RepaymentStartDate = RepaymentStartDate.AddMonths(1);
            }
            if (repaycalculated < StartDate)
            {
                FirstRepayDate = repaycalculated.AddMonths(1);
                RepaymentStartDate = repaycalculated.AddMonths(1);
            }

            return RepaymentStartDate;
        }
        public bool CheckifTrueUpisToBeApplyorNot(DateTime? RepaymentStartDate, DateTime? endDate)
        {
            bool allow = true;
            foreach (var payoff in dealDC.ListProjectedPayoff)
            {
                if (payoff.CumulativeProbability == 1)
                {
                    allow = true;
                    break;
                }
                else
                {
                    allow = false;
                }
            }
            return allow;
        }
        //-------------use rule N-----------------------

        public void DistributeRepayAmountUseRuleN(DateTime? RepaymentStartDate, DateTime? RepaymentEndDate)
        {
            decimal? MonthlyFactor = 0;
            decimal? Balance = 0;
            decimal? CummulativeRepayments = 0;
            decimal? MonthlyCPRandSLRFactor = 0;
            int totalmonths = 0;
            int monthpart = 0;
            DateTime? dealfunddate = DateTime.MinValue;
            DateTime? lastfunddate = DateTime.MinValue;
            DateTime? lastusedfunddate = DateTime.MinValue;
            int listindex = 0;
            PreviousEndingBalance = 0;
            Decimal? amount = 0;
            Decimal? DealAmount = 0, LastPreviousBalance = 0;

            int dayofthemonth = GetDayofTheMonth();

            if (dealDC.Repaymentallocationfrequency > 1)
            {
                monthpart = Convert.ToInt16(dealDC.Repaymentallocationfrequency);
            }
            else
            {
                monthpart = 1;
            }

            if (dealDC.PossibleRepaymentdayofthemonth == 31)
            {
                RepaymentStartDate = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(FirstRepayDate.Value.Year, FirstRepayDate.Value.Month, 20));
                RepaymentEndDate = DateExtensions.LastDateOfMonth(RepaymentEndDate.Value);
            }
            else
            {
                RepaymentStartDate = DateExtensions.CreateNewDate(FirstRepayDate.Value.Year, FirstRepayDate.Value.Month, dayofthemonth);
            }
            totalmonths = DateExtensions.GetMonthsDiffIgnoringDays(RepaymentStartDate.Value, RepaymentEndDate.Value);
            for (int i = 0; i < totalmonths; i++)
            {
                if (i == 0)
                {
                    dealfunddate = RepaymentStartDate;
                }
                else
                {
                    if (dealDC.PossibleRepaymentdayofthemonth == 31)
                    {
                        dealfunddate = DateExtensions.LastDateOfMonth(DateExtensions.CreateNewDate(lastfunddate.Value.Year, lastfunddate.Value.Month + monthpart, 20));

                    }
                    else
                    {
                        dealfunddate = DateExtensions.CreateNewDate(lastfunddate.Value.Year, lastfunddate.Value.Month + monthpart, dayofthemonth);
                    }
                }

                if (dealfunddate > RepaymentEndDate.Value)
                {
                    if (i == 0)
                    {
                        DateTime returndate = CheckOneRecordInAmonth(RepaymentEndDate.Value);
                        if (returndate.Date != RepaymentEndDate.Value)
                        {
                            break;
                        }

                    }
                    dealfunddate = RepaymentEndDate.Value;
                    if (lastfunddate == dealfunddate.Value)
                    {
                        break;
                    }

                }
                lastfunddate = dealfunddate.Value;
                if (dealfunddate <= RepaymentEndDate.Value)
                {
                    UseRuleNRowNumber = UseRuleNRowNumber + 1;
                    amount = 0;
                    DealAmount = 0;
                    if (dealDC.RepaymentAutoSpreadMethodText == "Straight-line")
                    {
                        MonthlyFactor = GetMonthlyCPRandSLRatio(dealfunddate.Value, "Straight-line");
                        MonthlyCPRandSLRFactor = GetCPRUsedINCalculation("Straight-line", MonthlyFactor, listindex);
                    }
                    else if (dealDC.RepaymentAutoSpreadMethodText == "CPR")
                    {
                        MonthlyFactor = GetMonthlyCPRandSLRatio(dealfunddate.Value, "CPR");
                        MonthlyCPRandSLRFactor = GetCPRUsedINCalculation("CPR", MonthlyFactor, listindex);
                    }
                    foreach (NoteEndingBalanceDataContract noteitem in dealDC.ListNoteEndingBalance)
                    {
                        if (noteitem.isNCANote == false)
                        {
                            CalculatedNoteRepaymentDataContract cnr = new CalculatedNoteRepaymentDataContract();
                            Balance = GetCurrentBalanceUseRuleN(RepaymentStartDate.Value, dealfunddate.Value, Convert.ToDateTime(lastusedfunddate), noteitem.NoteID, noteitem.EndingBalance.GetValueOrDefault(0));
                            {
                                CummulativeRepayments = (CumulativeTotalNoteAmount(RepaymentStartDate.Value, dealfunddate.Value, noteitem.NoteID)) * -1;
                            }

                            cnr.Date = dealfunddate.Value;
                            cnr.EndingBalance = Balance;
                            cnr.NoteID = noteitem.NoteID;
                            if (DateExtensions.LastDateOfMonth(dealfunddate.Value) == DateExtensions.LastDateOfMonth(RepaymentEndDate.Value))
                            {
                                //if (dealDC.maxMaturityDate != null)
                                //{
                                //    if (dealDC.maxMaturityDate != DateTime.MinValue)
                                //    {
                                //        if (RepaymentEndDate.Value > dealDC.maxMaturityDate)
                                //        {
                                //            dealfunddate = dealDC.maxMaturityDate.Value;
                                //        }
                                //    }
                                //}

                                amount = Balance - CummulativeRepayments;
                                amount = Math.Max(0, amount.GetValueOrDefault(0));

                                //var trueup = CheckifTrueUpisToBeApplyorNot(RepaymentStartDate, RepaymentEndDate);
                                //if (trueup == true)
                                //{
                                //    amount = Balance - CummulativeRepayments;
                                //    amount = amount + GetSumAmortAndPikAfterEndDateUseRuleN(Convert.ToDateTime(dealfunddate), noteitem.NoteID);
                                //    amount = Math.Max(0, amount.GetValueOrDefault(0));
                                //}
                            }
                            else
                            {
                                if (dealDC.RepaymentAutoSpreadMethodText == "Straight-line")
                                {
                                    amount = (Balance * MonthlyCPRandSLRFactor) - CummulativeRepayments;
                                }
                                else if (dealDC.RepaymentAutoSpreadMethodText == "CPR")
                                {
                                    amount = (Balance * (1 - MonthlyCPRandSLRFactor)) - CummulativeRepayments;
                                }
                            }
                            if (listindex > 0)
                            {
                                if (CummulativeRepayments == LastPreviousBalance)
                                {

                                    amount = 0;
                                }
                            }
                            amount = Math.Round(Convert.ToDecimal(Math.Max(0, amount.GetValueOrDefault(0))), 2);
                            decimal? currentrpay = TotalRepaymentasofDate.GetValueOrDefault(0) * -1 + +amount.GetValueOrDefault(0);
                            if (currentrpay > noteitem.SumRepaymentSequence)
                            {
                                decimal diff = currentrpay.GetValueOrDefault(0) - noteitem.SumRepaymentSequence.GetValueOrDefault(0);
                                if (Math.Abs(Convert.ToDecimal(diff)) <= 1)
                                {
                                    amount = amount + diff * -1;
                                }
                            }
                            cnr.Value = amount;
                            cnr.CummulativeRepayments = CummulativeRepayments;
                            //assign value to note fundings
                            AddRepayToNoteFundingScheduleList(dealfunddate, amount, UseRuleNRowNumber, noteitem.NoteID, noteitem.NotenName);
                            ListCalculatedNoteRepayment.Add(cnr);
                            DealAmount = DealAmount.GetValueOrDefault(0) + amount.GetValueOrDefault(0);
                            LastPreviousBalance = Balance;

                        }
                        //nca end 
                    }

                    lastusedfunddate = dealfunddate.Value;

                    AddRepayToPayruleDealFundingListUseRuleN(dealfunddate, DealAmount, MonthlyFactor, MonthlyCPRandSLRFactor, UseRuleNRowNumber);

                    listindex = listindex + 1;
                }
                else
                {
                    break;
                }
            }
        }

        public Decimal? CumulativeTotalNoteAmount(DateTime repaymentstartdate, DateTime currentdate, string snoteid)
        {
            Decimal? repaytotal = 0;
            decimal? previousTotal = 0;
            Guid NoteID = new Guid(snoteid);
            TotalRepaymentasofDate = 0;

            foreach (var repay in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (repay.Value < 0)
                {
                    if (repay.Date >= repaymentstartdate && repay.Date <= currentdate && repay.NoteID == NoteID)
                    {
                        if (repay.Purpose == "Paydown")
                        {
                            repaytotal = repaytotal + repay.Value;
                        }
                    }

                    if (repay.Applied != true)
                    {
                        if (repay.Date.Value.Date <= repaymentstartdate && repay.NoteID == NoteID)
                        {
                            if (repay.Comments != null && repay.Comments != "" && repay.Purpose == "Paydown")
                            {
                                previousTotal = previousTotal + repay.Value;
                            }
                        }
                    }

                    if (repay.Date.Value.Date <= currentdate && repay.NoteID == NoteID)
                    {
                        if (repay.Purpose == "Paydown")
                        {
                            TotalRepaymentasofDate = TotalRepaymentasofDate.GetValueOrDefault(0) + repay.Value.GetValueOrDefault(0);
                        }
                    }
                }
            }
            repaytotal = repaytotal.GetValueOrDefault(0) + previousTotal.GetValueOrDefault(0);// + RepayToBeAdjustedUseRuleN.GetValueOrDefault(0);
            return repaytotal;
        }

        public Decimal? GetCurrentBalanceUseRuleN(DateTime repaymentstartdate, DateTime currentdate, DateTime lastfunddate, string noteid, decimal dbendingbalance)
        {
            Decimal? BeginningBalance = 0;
            DateTime monthstartDate = DateExtensions.FirstDateOfMonth(currentdate);
            DateTime fundingStartDate = DateTime.MinValue;
            DateTime fundingEndDate = DateTime.MinValue;
            Decimal? sum = 0;
            Decimal? sumamort = 0;
            Decimal? sumPikFunding = 0;
            decimal? fundingtotal = 0;
            decimal? repaytotal = 0;
            decimal? NonCommitmentAdjsum = 0;
            decimal? sumrevolver = 0;

            Guid GNoteID = new Guid(noteid);
            if (repaymentstartdate.Date == currentdate.Date)
            {
                if (dealDC.maxWiredDatecalculated != DateTime.MinValue)
                {
                    fundingStartDate = dealDC.maxWiredDatecalculated.AddDays(1);
                }
                else
                {
                    fundingStartDate = dealDC.MaxWireConfirmRecord.AddDays(1);
                }

                lastfunddate = currentdate;
                //fundingStartDate = dealDC.maxWiredDatecalculated.AddDays(1);
                fundingEndDate = currentdate;
            }
            else
            {
                fundingStartDate = lastfunddate.AddDays(1);
                fundingEndDate = currentdate;
            }
            if (repaymentstartdate.Date == currentdate.Date)
            {
                BeginningBalance = GetStartingBalanceUseRuleN(repaymentstartdate, noteid, dbendingbalance);
            }
            else
            {
                foreach (CalculatedNoteRepaymentDataContract bal in ListCalculatedNoteRepayment)
                {
                    if (bal.NoteID == noteid && bal.Date == lastfunddate)
                    {
                        BeginningBalance = bal.EndingBalance;
                        break;
                    }
                }

                foreach (var funding in dealDC.PayruleTargetNoteFundingScheduleList)
                {
                    if (funding.Date.Value.Date >= fundingStartDate && funding.Date.Value.Date <= fundingEndDate && funding.NoteID == GNoteID)
                    {
                        if (funding.AdjustmentType != 834 && funding.AdjustmentType != 896 && funding.AdjustmentType != 835 && funding.PurposeID != 840)
                        {
                            if (funding.Value > 0)
                            {
                                fundingtotal = fundingtotal + funding.Value.GetValueOrDefault(0);
                            }
                            else if (funding.Value < 0)
                            {
                                //Amortization 351 Paydown  631
                                if (funding.PurposeID != 631 && funding.PurposeID != 351)
                                {
                                    repaytotal = repaytotal.GetValueOrDefault(0) + funding.Value.GetValueOrDefault(0);
                                }
                            }

                        }
                        else
                        {
                            if (funding.AdjustmentType == 834 || funding.AdjustmentType == 896)
                            {
                                NonCommitmentAdjsum = NonCommitmentAdjsum.GetValueOrDefault(0) + funding.Value.GetValueOrDefault(0);

                            }
                            //if (funding.AdjustmentType == 835)
                            //{
                            //    sumrevolver = sumrevolver + funding.Value.GetValueOrDefault(0);
                            //}
                        }
                    }
                }

                sumrevolver = GetRevolverBalanceUseRuleN(fundingStartDate, fundingEndDate, GNoteID);
                BeginningBalance = BeginningBalance + fundingtotal + repaytotal - NonCommitmentAdjsum - sumrevolver;
            }

            foreach (var bal in ListNoteRepaymentBalances)
            {
                if (bal.NoteID == noteid)
                {
                    if (bal.Date.Value.Date >= fundingStartDate && bal.Date.Value.Date <= fundingEndDate)
                    {
                        if (bal.Type == "PIKPrincipalFunding")
                        {
                            //sign will be negative from database
                            sumPikFunding = sumPikFunding.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                        }
                        else if (bal.Type == "PIKPrincipalPaid")
                        {
                            //sign will be positive from database
                            sum = sum.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                        }
                        else if (bal.Type == "ScheduledPrincipalPaid")
                        {
                            sumamort = sumamort.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0);
                        }
                    }
                }
            }

            BeginningBalance = BeginningBalance + sum * -1 + sumPikFunding * -1 + sumamort.GetValueOrDefault(0) * -1;
            return BeginningBalance;
        }

        public decimal? GetStartingBalanceUseRuleN(DateTime repaymentstartdate, string noteid, decimal DBEndingbalance)
        {
            RepayToBeAdjustedUseRuleN = 0;
            Decimal? sum = 0;
            Decimal? ffsum = 0;
            Decimal? NonCommitmentAdjsum = 0, NonCommitmentAdjsumComponent = 0;
            decimal? currentrevolverbal = 0, databaserevolverbal = 0, revolverbalance = 0;
            Guid Gnoteid = new Guid(noteid);
            DateTime startDate = dealDC.MaxWireConfirmRecord;
            DateTime endOfMonth = repaymentstartdate;
            Decimal? sumrepay = 0;
            Decimal? pikfunding = 0;
            decimal? writeoffonstart = 0;

            decimal? sumrevolverPositive = 0, revolverComponent = 0;
            decimal? sumrevolverNegative = 0;
            foreach (var bal in ListNoteRepaymentBalances)
            {
                if (bal.Date.Value.Date == startDate.Date && bal.NoteID == noteid)
                {
                    if (bal.Type == "PIKPrincipalPaid")
                    {
                        pikfunding = pikfunding + bal.Amount.GetValueOrDefault(0);
                    }
                }
            }

            foreach (var writeoff in dealDC.PayruleTargetNoteFundingScheduleList_Pwriteoff)
            {
                if (writeoff.Date.Value.Date == startDate.Date && writeoff.Applied == true && writeoff.NoteID.ToString() == noteid)
                {
                    writeoffonstart = writeoffonstart + writeoff.Value.GetValueOrDefault(0);
                }
            }

            foreach (var fundng in dealDC.NoteFundingScheduleListAdjustmentTypeAutoSpread)
            {
                if (fundng.Date.Value.Date >= startDate && fundng.Date.Value.Date <= endOfMonth && fundng.NoteID == Gnoteid)
                {
                    if (fundng.Value > 0)
                    {
                        if (fundng.Applied == true && fundng.PurposeID != 840)
                        {
                            if (fundng.AdjustmentType == 834 || fundng.AdjustmentType == 896)
                            {
                                NonCommitmentAdjsumComponent = NonCommitmentAdjsumComponent.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }
                    }

                    if (fundng.AdjustmentType == 835)
                    {
                        revolverComponent = revolverComponent.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                    }
                }

                if (fundng.Date.Value.Date <= endOfMonth && fundng.NoteID == Gnoteid)
                {
                    if (fundng.Applied == true)
                    {
                        //834  Non - Commitment Adjustment
                        if (fundng.PurposeID != 840)
                        {
                            if (fundng.AdjustmentType == 834 || fundng.AdjustmentType == 896)
                            {
                                NonCommitmentAdjsum = NonCommitmentAdjsum.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }
                        //835 Revolver
                        if (fundng.AdjustmentType == 835)
                        {
                            currentrevolverbal = currentrevolverbal.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                        }
                    }

                }
            }
            if (dealDC.ListRevolverNoteFunding != null)
            {
                foreach (var fundng in dealDC.ListRevolverNoteFunding)
                {
                    if (fundng.NoteID == Gnoteid && fundng.Applied == true)
                    {
                        databaserevolverbal = databaserevolverbal.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                    }
                }
            }
            else
            {
                databaserevolverbal = 0;
            }
            revolverbalance = currentrevolverbal - databaserevolverbal;

            foreach (var fundng in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (fundng.AdjustmentType != 834 && fundng.AdjustmentType != 897 && fundng.AdjustmentType != 835)
                {
                    if (fundng.Date != null)
                    {

                        if (fundng.Date.Value.Date >= startDate && fundng.Date.Value.Date <= endOfMonth && fundng.NoteID == Gnoteid)
                        {
                            if (fundng.Value > 0)
                            {
                                sum = sum.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                            else if (fundng.Value < 0 && fundng.Applied == true)
                            {
                                sumrepay = sumrepay.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                            else if (fundng.Value < 0 && fundng.PurposeID != 351 && fundng.PurposeID != 631)
                            {
                                sumrepay = sumrepay.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }

                        if (fundng.Date.Value.Date > startDate && fundng.Date.Value.Date <= endOfMonth && fundng.NoteID == Gnoteid)
                        {
                            if (fundng.Value < 0 && fundng.Purpose == "Paydown")
                            {
                                RepayToBeAdjustedUseRuleN = RepayToBeAdjustedUseRuleN.GetValueOrDefault(0) + fundng.Value.GetValueOrDefault(0);
                            }
                        }

                    }

                }
            }
            if (generateonLatestpossibleprepayment == true)
            {
                sum = sum.GetValueOrDefault(0) + DBEndingbalance + revolverComponent + NonCommitmentAdjsumComponent + sumrepay.GetValueOrDefault(0) + pikfunding.GetValueOrDefault(0) * -1 - NonCommitmentAdjsum + writeoffonstart;
            }
            else
            {
                sum = sum.GetValueOrDefault(0) + DBEndingbalance + revolverComponent + NonCommitmentAdjsumComponent + sumrepay.GetValueOrDefault(0) + pikfunding.GetValueOrDefault(0) * -1 - NonCommitmentAdjsum + writeoffonstart + revolverbalance;
            }

            return sum;
        }
        public decimal GetRevolverBalanceUseRuleN(DateTime fundingStartDate, DateTime fundingEndDate, Guid GNoteID)
        {
            decimal sumrevolver = 0;
            foreach (var funding in dealDC.NoteFundingScheduleListAdjustmentTypeAutoSpread)
            {
                if (funding.Date.Value.Date >= fundingStartDate && funding.Date.Value.Date <= fundingEndDate && funding.NoteID == GNoteID)
                {
                    if (funding.AdjustmentType == 835)
                    {
                        sumrevolver = sumrevolver + funding.Value.GetValueOrDefault(0);
                    }

                }
            }
            sumrevolver = Math.Abs(sumrevolver);
            return sumrevolver;
        }

        public decimal GetRevolverBalance(DateTime fundingStartDate, DateTime fundingEndDate)
        {
            decimal sumrevolver = 0;
            foreach (var funding in dealDC.DealFundingListAdjustmentTypeAutoSpread)
            {
                if (funding.Date.Value.Date >= fundingStartDate && funding.Date.Value.Date <= fundingEndDate)
                {
                    if (funding.AdjustmentType == 835)
                    {
                        sumrevolver = sumrevolver + funding.Value.GetValueOrDefault(0);
                    }

                }
            }
            sumrevolver = Math.Abs(sumrevolver);
            return sumrevolver;
        }
        public decimal? GetSumAmortAndPikAfterEndDateUseRuleN(DateTime currentdate, string noteid)
        {
            decimal? amount = 0;
            Decimal? sum = 0;
            Decimal? pikFunding = 0;
            Decimal? pikPaid = 0;
            Guid Gnoteid = new Guid(noteid);

            foreach (var bal in ListNoteRepaymentBalances)
            {
                if (bal.Date.Value.Date > currentdate && bal.NoteID == noteid)
                {
                    if (bal.Type == "PIKPrincipalPaid")
                    {
                        pikPaid = pikPaid.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0) * -1;
                    }
                    else if (bal.Type == "PIKPrincipalFunding")
                    {
                        pikFunding = pikFunding.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0) * -1;
                    }
                    else if (bal.Type == "ScheduledPrincipalPaid")
                    {
                        sum = sum.GetValueOrDefault(0) + bal.Amount.GetValueOrDefault(0) * -1;
                    }
                }
            }

            amount = sum.GetValueOrDefault(0) + pikPaid.GetValueOrDefault(0) + pikFunding.GetValueOrDefault(0);
            return amount;
        }

        public void ApplyPennyAdjustmentToRepayment()
        {
            Decimal? sumreapay = 0;
            Decimal? repaytobeadjusted = 0;
            DateTime? maxpaydownDate = DateTime.MinValue;
            Decimal? sumofrepayseq = (ListPayruleNoteSequence.Where(y => y.SequenceTypeText == "Repayment Sequence").Sum(x => x.Value)).GetValueOrDefault(0);
            int? maxrownumber = 0;
            Guid noteIDWithMaxCommitment = new Guid();
            Guid noteIDWithSecondCommitment = new Guid();
            Decimal? maxcommitment = 0;
            Decimal? secondmaxcommitment = 0;
            string usesecondmax = "";
            decimal? remainingtoadjust = 0;

            foreach (var funding in dealDC.PayruleDealFundingList)
            {
                if (funding.Value < 0)
                {
                    sumreapay = sumreapay.GetValueOrDefault(0) + funding.Value.GetValueOrDefault(0);
                }
                if (funding.PurposeText == "Paydown")
                {
                    if (maxpaydownDate == DateTime.MinValue)
                    {
                        maxpaydownDate = funding.Date;
                    }
                    else
                    {
                        maxpaydownDate = DateExtensions.GetMaxDate(maxpaydownDate.Value.Date, funding.Date.Value.Date);
                        if (funding.DealFundingRowno > maxrownumber)
                        {
                            maxrownumber = funding.DealFundingRowno;
                        }
                    }
                }
            }

            if (dealDC.ExpectedFullRepaymentDate != null && dealDC.ExpectedFullRepaymentDate != DateTime.MinValue)
            {
                maxpaydownDate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(dealDC.ExpectedFullRepaymentDate.Value.Date), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            }

            sumreapay = sumreapay.GetValueOrDefault(0) * -1;
            if (sumreapay > sumofrepayseq)
            {
                repaytobeadjusted = sumreapay.GetValueOrDefault(0) - sumofrepayseq.GetValueOrDefault(0);
                if (Math.Abs(Convert.ToDecimal(repaytobeadjusted)) <= 1)
                {
                    if (dealDC.EnableAutospreadUseRuleN != true && dealDC.EnableAutospreadRepayments == true && dealDC.ApplyNoteLevelPaydowns != true)
                    {
                        //adjust only to deal level
                        foreach (var res in dealDC.PayruleDealFundingList)
                        {
                            if (res.Date.Value.Date == maxpaydownDate && res.PurposeText == "Paydown")
                            {
                                res.Value = res.Value.GetValueOrDefault(0) + repaytobeadjusted;
                                res.Value1 = res.Value;
                                break;
                            }
                        }
                    }
                    else if (dealDC.EnableAutospreadUseRuleN == true || dealDC.ApplyNoteLevelPaydowns == true)
                    {
                        remainingtoadjust = repaytobeadjusted;

                        //note with max total commitment
                        foreach (var res in ListNoteDetail)
                        {
                            decimal? notesumseq = 0;
                            decimal? sumnoterepay = 0;
                            decimal? noterepaytobeadjusted = 0;
                            foreach (var noteseq in ListPayruleNoteSequence)
                            {
                                if (noteseq.NoteID == res.NoteID && noteseq.SequenceTypeText == "Repayment Sequence")
                                {
                                    notesumseq = notesumseq.GetValueOrDefault(0) + noteseq.Value.GetValueOrDefault(0);
                                }
                            }
                            foreach (var funding in dealDC.PayruleTargetNoteFundingScheduleList)
                            {
                                if (funding.Value < 0 && funding.NoteID == res.NoteID)
                                {
                                    sumnoterepay = sumnoterepay.GetValueOrDefault(0) + funding.Value.GetValueOrDefault(0);
                                }
                            }
                            sumnoterepay = sumnoterepay * -1;
                            if (sumnoterepay > notesumseq)
                            {
                                noterepaytobeadjusted = sumnoterepay.GetValueOrDefault(0) - notesumseq.GetValueOrDefault(0);
                                //positive amount means repay is more so we have remove from funding
                                foreach (var funding in dealDC.PayruleTargetNoteFundingScheduleList)
                                {
                                    if (funding.Purpose == "Paydown" && funding.Date == maxpaydownDate && funding.NoteID == res.NoteID)
                                    {
                                        if (noterepaytobeadjusted < 0)
                                        {
                                            noterepaytobeadjusted = noterepaytobeadjusted * -1;
                                        }
                                        if (noterepaytobeadjusted >= remainingtoadjust)
                                        {
                                            noterepaytobeadjusted = remainingtoadjust;
                                        }
                                        if (funding.Value.GetValueOrDefault(0) != 0M)
                                        {
                                            funding.Value = funding.Value.GetValueOrDefault(0) + noterepaytobeadjusted;
                                        }

                                        remainingtoadjust = remainingtoadjust - noterepaytobeadjusted;
                                        break;
                                    }
                                }
                            }

                            if (remainingtoadjust == 0)
                            {
                                break;
                            }
                        }

                        //if (remainingtoadjust != 0)
                        //{
                        //    var notewithmaxcommitment = dealDC.PayruleNoteDetailFundingList.OrderByDescending(x => x.CommitmentUsedInFFDistribution).First();

                        //    foreach (var funding in dealDC.PayruleTargetNoteFundingScheduleList)
                        //    {
                        //        if (funding.Purpose == "Paydown" && funding.Date == maxpaydownDate && funding.NoteID == notewithmaxcommitment.NoteID)
                        //        {
                        //            if (remainingtoadjust < 0)
                        //            {
                        //                remainingtoadjust = remainingtoadjust * -1;
                        //            }
                        //            if (funding.Value.GetValueOrDefault(0) != 0M)
                        //            {
                        //                funding.Value = funding.Value.GetValueOrDefault(0) + remainingtoadjust;
                        //            }
                        //        }
                        //    }

                        //}
                        // update deal level amount
                        foreach (var res in dealDC.PayruleDealFundingList)
                        {
                            if (res.Date == maxpaydownDate && res.PurposeText == "Paydown")
                            {
                                res.Value = res.Value.GetValueOrDefault(0) + repaytobeadjusted;
                                res.Value1 = res.Value;
                                break;
                            }
                        }
                    }
                }
                else
                {
                    dealDC.TotalRepaymentSequences = sumofrepayseq;
                    dealDC.SumTotalRepayments = sumreapay;
                    dealDC.RepayTobeAdjusted = repaytobeadjusted;
                }

            }
        }
        public void CreateExpectedFullRepayRecordUseRuleN(DateTime ExpectedFullRepaymentDate)
        {
            Decimal? Balance = 0, DealAmount = 0;
            DateTime? funddate = ExpectedFullRepaymentDate;
            DateTime? RepaymentStartDate = GetAutoSpreadRepaymentStartDate();
            funddate = GetAutoSpreadRepaymentEndDate(RepaymentStartDate);
            generateonLatestpossibleprepayment = true;
            //if (dealDC.maxMaturityDate != null && dealDC.maxMaturityDate != DateTime.MinValue)
            //{
            //    if (funddate > dealDC.maxMaturityDate.Value.Date)
            //    {
            //        funddate = dealDC.maxMaturityDate.Value.Date;
            //    }
            //}

            funddate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(funddate), Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            //1) delete old and future records
            if (dealDC.ApplyNoteLevelPaydowns != true)
            {
                DeleteRepaymentsFromNoteAndDeal();
            }
            //reassign DealFundingRowno
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.DealFundingRowno != null)
                {
                    if (ds.DealFundingRowno > UseRuleNRowNumber)
                    {
                        UseRuleNRowNumber = Convert.ToInt32(ds.DealFundingRowno);
                    }
                }
            }
            UseRuleNRowNumber = UseRuleNRowNumber + 1;
            foreach (NoteEndingBalanceDataContract noteitem in dealDC.ListNoteEndingBalance)
            {
                decimal? repayment = 0;
                Balance = GetCurrentBalanceUseRuleN(ExpectedFullRepaymentDate, ExpectedFullRepaymentDate, Convert.ToDateTime(ExpectedFullRepaymentDate), noteitem.NoteID, noteitem.EndingBalance.GetValueOrDefault(0));

                Balance = Balance.GetValueOrDefault(0) + GetSumAmortAndPikAfterEndDateUseRuleN(Convert.ToDateTime(ExpectedFullRepaymentDate), noteitem.NoteID); //+ RepayToBeAdjustedUseRuleN;
                Balance = Math.Round(Convert.ToDecimal(Math.Max(0, Balance.GetValueOrDefault(0))), 2);

                foreach (var funding in dealDC.PayruleTargetNoteFundingScheduleList)
                {
                    if (funding.Applied != true)
                    {
                        if (funding.Purpose == "Paydown" && funding.Comments != "" && funding.Comments != null && funding.NoteID.ToString() == noteitem.NoteID)
                        {
                            repayment = repayment + funding.Value.GetValueOrDefault(0);
                        }
                    }
                }
                Balance = Balance + repayment.GetValueOrDefault(0);
                if (Balance < 0)
                {
                    Balance = 0;
                }
                AddRepayToNoteFundingScheduleList(funddate, Balance, UseRuleNRowNumber, noteitem.NoteID.ToString(), noteitem.NotenName);
                DealAmount = DealAmount.GetValueOrDefault(0) + Balance.GetValueOrDefault(0);
            }

            AddRepayToPayruleDealFundingListUseRuleN(funddate, DealAmount, 0, 0, UseRuleNRowNumber);
            // soft pay case
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.Date > ExpectedFullRepaymentDate && pdf.Value > 0)
                {
                    AddRepaySameAsTheFundingForUseRuleN(pdf.Date, pdf.DealFundingRowno);
                }
            }
            if (DealFundingListExtension != null)
            {
                foreach (var ds in DealFundingListExtension)
                {
                    dealDC.PayruleDealFundingList.Add(ds);
                }
            }
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.Value == 0 && pdf.PurposeText == "Paydown")
                {
                    pdf.isdeleted = true;
                    PayruleDeletedDealFundingList.Add(pdf);
                }
            }

            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);

            foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (notefund.Value == 0 && notefund.Purpose == "Paydown")
                {
                    notefund.isDeletedAutoSpread = true;
                    PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                }
            }
            dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.isDeletedAutoSpread == true);

            //commented below logic : now autospread end will be ExpectedMaturityDate
            //dealDC.RepayExpectedMaturityDate = CalculateExpectedMaturityDate();
            dealDC.RepayExpectedMaturityDate = ExpectedFullRepaymentDate;
        }

        public void DeleteRepaymentsFromNoteAndDeal()
        {
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.Value < 0 && ds.PurposeText != "Amortization")
                {
                    if (ds.Applied != true)
                    {
                        if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                        {
                            if (ds.Comment == null || ds.Comment == "")
                            {
                                ds.isdeleted = true;
                                PayruleDeletedDealFundingList.Add(ds);
                            }
                        }
                    }
                    else if (ds.PurposeText == null || ds.PurposeText == "")
                    {
                        ds.isdeleted = true;
                        PayruleDeletedDealFundingList.Add(ds);
                    }
                }
                else if (ds.Value == 0 && ds.PurposeText == "Paydown")
                {
                    ds.isdeleted = true;
                    PayruleDeletedDealFundingList.Add(ds);
                }
                else if (ds.Value > 0 && ds.PurposeText == "Paydown")
                {
                    if (ds.Applied != true)
                    {
                        ds.isdeleted = true;
                        PayruleDeletedDealFundingList.Add(ds);
                    }
                }
            }
            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);

            foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (notefund.Value < 0 && notefund.Purpose != "Amortization")
                {
                    if (notefund.Applied != true)
                    {
                        if (notefund.WF_CurrentStatus == "Projected" || notefund.WF_CurrentStatus == "" || notefund.WF_CurrentStatus == null)
                        {
                            if (notefund.Comments == null || notefund.Comments == "")
                            {
                                notefund.isDeletedAutoSpread = true;
                                PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                            }
                        }
                    }
                    else if (notefund.Purpose == null || notefund.Purpose == "")
                    {
                        notefund.isDeletedAutoSpread = true;
                        PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                    }

                }
                else if (notefund.Value == 0 && notefund.Purpose == "Paydown")
                {
                    notefund.isDeletedAutoSpread = true;
                    PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                }
                else if (notefund.Value > 0 && notefund.Purpose == "Paydown")
                {
                    notefund.isDeletedAutoSpread = true;
                    PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                }
            }

            dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.isDeletedAutoSpread == true);
        }

        public void DeletePaydownFromNoteAndDeal()
        {
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.Value < 0 && ds.PurposeText == "Paydown")
                {
                    if (ds.Applied != true)
                    {
                        if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                        {
                            if (ds.Comment == null || ds.Comment == "")
                            {
                                ds.isdeleted = true;
                                PayruleDeletedDealFundingList.Add(ds);
                            }
                        }
                    }
                    else if (ds.PurposeText == null || ds.PurposeText == "")
                    {
                        ds.isdeleted = true;
                        PayruleDeletedDealFundingList.Add(ds);
                    }
                }
                else if (ds.Value == 0 && ds.PurposeText == "Paydown")
                {
                    ds.isdeleted = true;
                    PayruleDeletedDealFundingList.Add(ds);
                }
            }
            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);

            foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (notefund.Value < 0 && notefund.Purpose == "Paydown")
                {
                    if (notefund.Applied != true)
                    {
                        if (notefund.WF_CurrentStatus == "Projected" || notefund.WF_CurrentStatus == "" || notefund.WF_CurrentStatus == null)
                        {
                            if (notefund.Comments == null || notefund.Comments == "")
                            {
                                notefund.isDeletedAutoSpread = true;
                                PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                            }
                        }
                    }
                    else if (notefund.Purpose == null || notefund.Purpose == "")
                    {
                        notefund.isDeletedAutoSpread = true;
                        PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                    }

                }
                else if (notefund.Value == 0 && notefund.Purpose == "Paydown")
                {
                    notefund.isDeletedAutoSpread = true;
                    PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                }
            }

            dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.isDeletedAutoSpread == true);
        }

        public decimal AdjustBeginningBalanceForRepaymentAutoSpreading()
        {
            decimal sum = 0;
            foreach (AutoSpreadRuleDataContract asd in dealDC.AutoSpreadRuleList)
            {
                foreach (PayruleDealFundingDataContract ds in OriginalDealFundingList)
                {
                    if (ds.Date.Value.Date <= dealDC.MaxWireConfirmRecord)
                    {
                        if (ds.Date.Value.Date <= asd.StartDate.Value.Date)
                        {
                            if (ds.PurposeText == asd.PurposeTypeText && ds.Applied != true)
                            {
                                if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                                {
                                    if (ds.Comment == null || ds.Comment == "")
                                    {
                                        sum = sum + ds.Value.GetValueOrDefault(0);
                                    }
                                }
                            }
                        }


                    }

                }
            }

            return sum;
        }

        public decimal AdjustNoteLevelBeginningBalanceForRepaymentAutoSpreading()
        {
            decimal sum = 0;
            foreach (AutoSpreadRuleDataContract asd in dealDC.AutoSpreadRuleList)
            {
                foreach (NoteEndingBalanceDataContract noteitem in dealDC.ListNoteEndingBalance)
                {
                    sum = 0;
                    foreach (var ds in OriginalNoteFundingList)
                    {
                        if (ds.Purpose == asd.PurposeTypeText && ds.Applied != true && ds.NoteID.ToString() == noteitem.NoteID)
                        {
                            if (ds.Date.Value.Date <= dealDC.MaxWireConfirmRecord)
                            {
                                if (ds.Date.Value.Date <= asd.StartDate.Value.Date)
                                {
                                    if (ds.WF_CurrentStatus == "Projected" || ds.WF_CurrentStatus == "" || ds.WF_CurrentStatus == null)
                                    {
                                        if (ds.Comments == null || ds.Comments == "")
                                        {
                                            sum = sum + ds.Value.GetValueOrDefault(0);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    noteitem.EndingBalance = noteitem.EndingBalance - sum;
                }
            }

            return sum;
        }
        #endregion autospread
        public void AddRepayForNonCommitmentAdjustment()
        {
            DateTime LastPaydownDate = DateTime.MinValue;
            DateTime holidayadjmaturity = DateTime.MinValue;
            string nca = "";
            string ncapa = "";
            string comment = "";
            DeleteNonCommitmentAdjustmentPaydownFromNoteAndDeal(holidayadjmaturity);
            decimal? dealsum = 0;
            foreach (PayruleDealFundingDataContract pdf in dealDC.PayruleDealFundingList)
            {
                if (pdf.PurposeText == "Paydown")
                {
                    if (pdf.Value != 0)
                    {
                        if (LastPaydownDate != DateTime.MinValue)
                        {
                            LastPaydownDate = DateExtensions.GetMaxDate(LastPaydownDate, Convert.ToDateTime(pdf.Date));
                        }
                        else
                        {
                            LastPaydownDate = Convert.ToDateTime(pdf.Date);
                        }

                    }
                }
                if (pdf.AdjustmentType == 834 || pdf.AdjustmentType == 896)
                {
                    if (pdf.AdjustmentType == 834)
                    {
                        nca = "Non-Commitment Adjustment";

                    }
                    if (pdf.AdjustmentType == 896)
                    {
                        ncapa = "Commitment Adjustment (PA)";
                    }

                    dealsum = dealsum.GetValueOrDefault(0) + pdf.Value.GetValueOrDefault(0);
                }

            }
            if (nca != "" && ncapa != "")
            {
                comment = "Autospread : Non-Commitment Adjustment and Commitment Adjustment (PA).";
            }
            else if (nca != "")
            {
                comment = "Autospread : Non-Commitment Adjustment.";
            }
            else if (ncapa != "")
            {
                comment = "Autospread : Commitment Adjustment (PA).";
            }

            if (LastPaydownDate.Date.Year <= 2000)
            {
                holidayadjmaturity = DateExtensions.GetWorkingDayUsingOffset(dealDC.maxMaturityDate.Value, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            }
            else
            {
                holidayadjmaturity = DateExtensions.GetWorkingDayUsingOffset(LastPaydownDate, Convert.ToInt16(-1), "US", dealDC.ListHoliday).Date;
            }
            if (Math.Round(dealsum.GetValueOrDefault(0), 2) > 0)
            {
                var RowNumber = dealDC.PayruleDealFundingList.Max(x => x.DealFundingRowno).ToInt32();
                Decimal? dealamount = 0;
                RowNumber = RowNumber + 1;

                foreach (var noteitem in dealDC.PayruleNoteDetailFundingList)
                {
                    decimal? noteNonCommitmentAdjustmentBalance = 0;
                    noteNonCommitmentAdjustmentBalance = GetNonCommitmentAdjustmentBalance(noteitem.NoteID);
                    AddRepayToNoteFundingScheduleListWithAdjustmentType(holidayadjmaturity, noteNonCommitmentAdjustmentBalance, RowNumber, noteitem.NoteID.ToString(), noteitem.NoteName, 834);
                    dealamount = dealamount + noteNonCommitmentAdjustmentBalance;
                }

                PayruleDealFundingDataContract pdf = new PayruleDealFundingDataContract();
                pdf.Date = holidayadjmaturity;
                pdf.PurposeText = "Paydown";
                pdf.PurposeID = 631;// id for paydown in lookuptable
                pdf.SubPurposeType = "";
                pdf.RequiredEquity = 0;
                pdf.Value = Math.Round(Convert.ToDecimal(dealamount * -1), 2);
                pdf.AdditionalEquity = 0;
                pdf.Value1 = pdf.Value;
                pdf.Applied = false;
                pdf.DealID = dealid;
                pdf.DealFundingRowno = RowNumber;
                pdf.DealFundingID = null;
                pdf.WF_CurrentStatus = "Projected";
                pdf.WF_CurrentStatusDisplayName = "Projected";
                pdf.WF_IsAllow = true;
                pdf.WF_isParticipate = true;
                pdf.WF_IsCompleted = false;
                pdf.WF_IsFlowStart = false;
                pdf.wf_isUserCurrentFlow = false;
                pdf.GeneratedBy = 747;
                pdf.AdjustmentType = 834;
                pdf.Comment = comment;

                dealDC.PayruleDealFundingList.Add(pdf);
            }

        }
        public decimal? GetNonCommitmentAdjustmentBalance(Guid noteid)
        {
            decimal? noteNonCommitmentAdjustmen = 0;
            foreach (var note in dealDC.NoteFundingScheduleListAdjustmentTypeAutoSpread)
            {
                if (note.NoteID == noteid && note.PurposeID != 631)
                {
                    if (note.AdjustmentType == 834 || note.AdjustmentType == 896)
                    {
                        noteNonCommitmentAdjustmen = noteNonCommitmentAdjustmen + note.Value.GetValueOrDefault(0);
                    }
                }
            }
            return noteNonCommitmentAdjustmen;
        }
        public void AddRepayToNoteFundingScheduleListWithAdjustmentType(DateTime? funddate, Decimal? amount, int? DealFundingRowno, string NoteID, string NotenName, int AdjustmentType)
        {
            PayruleTargetNoteFundingScheduleDataContract notefunding = new PayruleTargetNoteFundingScheduleDataContract();
            notefunding.Date = funddate;
            notefunding.Value = amount * -1;
            notefunding.NoteName = NotenName;
            notefunding.AccountId = null;
            notefunding.PurposeID = 631;
            notefunding.Purpose = "Paydown";
            notefunding.NoteID = new Guid(NoteID);
            notefunding.Applied = false;
            notefunding.DrawFundingId = null;
            notefunding.DealFundingRowno = DealFundingRowno;
            notefunding.Comments = "";
            notefunding.isDeleted = null;
            notefunding.NoteSplitDiff = null;
            notefunding.DealFundingID = null;
            notefunding.WF_CurrentStatus = "Projected";
            notefunding.WF_CurrentStatusDisplayName = "Projected";
            notefunding.OldComment = "";
            notefunding.GeneratedBy = 747;
            notefunding.AdjustmentType = AdjustmentType;
            notefunding.Comments = "Autospread : Non-Commitment Adjustment.";
            dealDC.PayruleTargetNoteFundingScheduleList.Add(notefunding);
        }

        public void DeleteNonCommitmentAdjustmentPaydownFromNoteAndDeal(DateTime holidayadjimatdate)
        {
            List<int?> rownumber = new List<int?>();
            foreach (PayruleDealFundingDataContract ds in dealDC.PayruleDealFundingList)
            {
                if (ds.Date.Value.Date == holidayadjimatdate.Date && ds.PurposeText == "Paydown" && ds.AdjustmentType == 834)
                {
                    if (ds.Applied != true)
                    {
                        if (ds.Comment == null || ds.GeneratedBy == 747)
                        {
                            ds.isdeleted = true;
                            PayruleDeletedDealFundingList.Add(ds);
                        }
                        else
                        {
                            if (ds.Value == 0)
                            {
                                ds.isdeleted = true;
                                PayruleDeletedDealFundingList.Add(ds);
                                rownumber.Add(ds.DealFundingRowno);
                            }
                        }
                    }
                }
                if (ds.PurposeText == "Paydown" && ds.AdjustmentType == 834)
                {
                    if (ds.Applied != true)
                    {
                        if (ds.Value == 0 || ds.GeneratedBy == 747)
                        {
                            ds.isdeleted = true;
                            PayruleDeletedDealFundingList.Add(ds);
                            rownumber.Add(ds.DealFundingRowno);
                        }
                    }
                }

            }
            dealDC.PayruleDealFundingList.RemoveAll(x => x.isdeleted == true);
            foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
            {
                if (notefund.Date.Value.Date == holidayadjimatdate.Date && notefund.Purpose == "Paydown" && notefund.AdjustmentType == 834)
                {
                    if (notefund.Applied != true)
                    {
                        if (notefund.Comments == null || notefund.GeneratedBy == 747)
                        {
                            notefund.isDeletedAutoSpread = true;
                            PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                        }
                    }
                }
            }

            dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.isDeletedAutoSpread == true);
            foreach (var item in rownumber)
            {
                foreach (PayruleTargetNoteFundingScheduleDataContract notefund in dealDC.PayruleTargetNoteFundingScheduleList)
                {
                    if (notefund.DealFundingRowno == item)
                    {
                        notefund.isDeletedAutoSpread = true;
                        PayruleDeletedTargetNoteFundingScheduleList.Add(notefund);
                    }
                }
            }
            dealDC.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.isDeletedAutoSpread == true);

        }

        public void IndentifyNCANote()
        {
            decimal? noteFundseq = 0;
            decimal? noteRepayseq = 0;
            Boolean isNCAnote = false;
            if (dealDC.ListNoteEndingBalance != null)
            {
                foreach (var item in dealDC.ListNoteEndingBalance)
                {
                    noteFundseq = 0;
                    noteRepayseq = 0;
                    isNCAnote = false;
                    Guid currentnoteid = new Guid(item.NoteID);
                    foreach (var noteseq in ListPayruleNoteSequence)
                    {
                        if (noteseq.NoteID == currentnoteid)
                        {
                            if (noteseq.SequenceTypeText == "Funding Sequence")
                            {
                                noteFundseq = noteFundseq.GetValueOrDefault(0) + noteseq.Value.GetValueOrDefault(0);
                            }
                            if (noteseq.SequenceTypeText == "Repayment Sequence")
                            {
                                noteRepayseq = noteRepayseq.GetValueOrDefault(0) + noteseq.Value.GetValueOrDefault(0);
                            }
                        }
                    }
                    if (noteFundseq == 0 && noteRepayseq == 0)
                    {
                        foreach (var funding in dealDC.NoteFundingScheduleListAdjustmentTypeAutoSpread)
                        {
                            if (currentnoteid == funding.NoteID && funding.AdjustmentType == 834)
                            {
                                //834  Non - Commitment Adjustment
                                if (funding.Value != null && funding.Value != 0)
                                {
                                    isNCAnote = true;
                                    break;
                                }
                            }

                        }
                    }

                    item.isNCANote = isNCAnote;

                }
            }


        }
    }
}