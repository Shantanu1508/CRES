using System;
using System.Collections.Generic;
using System.Text;
using CRES.DataContract;
using CRES.DataContract.Liability;
using System.Linq;
using System.Data;
using System.IO;
using Microsoft.EntityFrameworkCore.Metadata.Conventions.Internal;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Math;
using Syncfusion.DocIO.DLS;
using Microsoft.Data.Analysis;
using CRES.DAL.Repository;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.Internal;
using static CRES.DataContract.V1CalcDataContract;
using Microsoft.EntityFrameworkCore.Internal;

namespace CRES.NoteCalculator
{
    public class LiabilityCashflowManager
    {
        #region Properties

        private string CalculationTimeLog = "";
        private string notetype = "";
        private DateTime CalcAsOfDate = DateTime.MinValue;
        private string HolidayCalendarType = "US";

        private DataTable dtLiabilityMain = null;
        private DataTable dtAssetLiabilityTransactions = null;

        private DateTime periodstart;
        private DateTime periodend;
        private LiabilityCFInput liabilityCFInput;
        private LiabilityLine subline;
        private Deposit cash_sub;
        private Deposit cash_eq;
        private CashflowConfig config;
        private IDictionary<string, decimal> curbalance = new Dictionary<string, decimal>();
        private List<Balance> initial_regbalances = new List<Balance>();
        private List<Balance> initial_pikbalances = new List<Balance>();
        private decimal port_cash = 0.0M;
        private string dep_type = "Cash";

        //Main Data Frames
        private List<LiabilityMain> LiabilityMainFrame = new List<LiabilityMain>();
        private List<AssetLiabilityTransaction> ListAssetLiabilityTransactions = new List<AssetLiabilityTransaction>();

        //Output Vectors
        private List<LiabilityNoteTransaction> ListLiabilityNoteTransactions = new List<LiabilityNoteTransaction>();
        private List<LiabilityLineTransaction> ListLiabilityLineTransactions = new List<LiabilityLineTransaction>();
        public LiabilityCFOutput ListLiabilityCFOutput = new LiabilityCFOutput();

        //Data
        private List<ManualEntry> ListManualEntries = new List<ManualEntry>();
        #endregion

        #region Main
        public LiabilityCFOutput GenerateLiabilityCashflow(string json)
        {
            try
            {
                InitializeCashflowManager(json);

                InitializeMain();

                //Set up Liability Notes based on Asset Transactions - 
                GenerateAssetLiabilityTransactionTable();
                //CalculationHelper.CreateCSVFile(CalculationHelper.ToDataSet(this.ListAssetLiabilityTransactions), "LCFTransactions_1");
                //CalculationHelper.CreateCSVFile(CalculationHelper.ToDataSet(this.LiabilityMainFrame), "LCFMainFrame_1");
                foreach (string mode in config.OperationMode.Split(","))
                    ApplyConfigurationOptions(mode);

                UpdateMainFrameBalance();
                //CalculationHelper.CreateCSVFile(CalculationHelper.ToDataSet(this.ListAssetLiabilityTransactions), "LCFTransactions");
                //CalculationHelper.CreateCSVFile(CalculationHelper.ToDataSet(this.LiabilityMainFrame), "LCFMainFrame");

                //Generate Outputs
                GenerateLiabilityNoteTransactions();
                GenerateLiabilityLineTransactions();

                ListLiabilityCFOutput.LiabilityNoteTransactions = ListLiabilityNoteTransactions;
                ListLiabilityCFOutput.LiabilityLineTransactions = ListLiabilityLineTransactions;
                ListLiabilityCFOutput.CalculatorExceptionMessage = "Cashflow generated successfully!";
            }
            catch (Exception ex)
            {
                ListLiabilityCFOutput.CalculatorExceptionMessage += "Calculation failed due to- " + System.Environment.NewLine + "" + ex.Message;
                ListLiabilityCFOutput.CalculatorStackTrace = "Calculation Error Message:" + ex.Message + ". Stack Trace:" + " : " + ex.StackTrace;
            }

            return this.ListLiabilityCFOutput;
        }

        public void InitializeCashflowManager(string json)
        {
            liabilityCFInput = JsonConvert.DeserializeObject<LiabilityCFInput>(json);
            CalcAsOfDate = liabilityCFInput.CalcAsOfDate.Value.Date;
            config = liabilityCFInput.CashflowConfig;
            Fund fund = liabilityCFInput.Fund;

            //Initialize Fund
            fund.BalanceAsofCalcDate = fund.BalanceAsofCalcDate.GetValueOrDefault();
            fund.FundDelay = fund.FundDelay.GetValueOrDefault();
            fund.FundingDay = fund.FundingDay.GetValueOrDefault(30);
            curbalance.Add(fund.EquityName, fund.BalanceAsofCalcDate.GetValueOrDefault());

            //Set default values for Line properties in case they are null
            foreach (LiabilityLine ln in liabilityCFInput.LiabilityLines)
            {
                //Stash the current balance in a hash table
                ln.BalanceAsofCalcDate = ln.BalanceAsofCalcDate.GetValueOrDefault(0);
                curbalance.Add(ln.LiabilityID, ln.BalanceAsofCalcDate.GetValueOrDefault());

                // FundDelay: Number of days to hold on the Subline
                ln.FundDelay = ln.FundDelay.GetValueOrDefault(0);
                ln.FundingDay = ln.FundingDay.GetValueOrDefault(0); // Funding Day = 0 indicates End of Month
            }

            foreach (LiabilityNote ln in liabilityCFInput.LiabilityNotes)
                curbalance.Add(ln.LiabilityNoteID, ln.BalanceAsofCalcDate.GetValueOrDefault());

            subline = liabilityCFInput.LiabilityLines.Where(ln => ln.Type == "Subline").FirstOrDefault();
            cash_sub = new Deposit(subline.PortfolioAccountID, subline.PortfolioAccountName, dep_type, subline.PortfolioBalanceAsofCalcDate.GetValueOrDefault(0));
            cash_eq = new Deposit(fund.PortfolioAccountID, fund.PortfolioAccountName, dep_type, fund.PortfolioBalanceAsofCalcDate.GetValueOrDefault(0));
            port_cash = cash_sub.BalanceAsofCalcDate.GetValueOrDefault(0);

            //Manual Entries
            ListManualEntries = this.liabilityCFInput.ManualEntry;
        }
        public void InitializeMain()
        {
            int ndx = 0, lnotecount = 0;
            decimal fundbalance = 0.0M, sublinebalance = 0.0M, linebalance = 0.0M;
            DateTime LastAssetTransactionDate;
            Fund fund = liabilityCFInput.Fund;


            LastAssetTransactionDate = GetLastAssetTransactionDate(liabilityCFInput.AssetNotes);
            initial_regbalances.Add(new Balance(fund.EquityName, CalcAsOfDate, fund.BalanceAsofCalcDate.GetValueOrDefault(0)));
            initial_pikbalances.Add(new Balance(fund.EquityName, CalcAsOfDate, 0.0M));
            this.periodstart = CalcAsOfDate;
            this.periodend = LastAssetTransactionDate;

            int len = (periodend - periodstart).Days + 1;
            List<DateTime> date_range = new List<DateTime>(Enumerable.Range(0, 1 + periodend.Subtract(CalcAsOfDate).Days)
                .Select(offset => periodstart.AddDays(offset)).ToArray().Cast<DateTime>());

            foreach (LiabilityLine ln in liabilityCFInput.LiabilityLines)
            {
                fundbalance = fund.BalanceAsofCalcDate.GetValueOrDefault(0);
                initial_regbalances.Add(new Balance(ln.LiabilityID, CalcAsOfDate, ln.BalanceAsofCalcDate.GetValueOrDefault(0)));
                initial_pikbalances.Add(new Balance(ln.LiabilityID, CalcAsOfDate, 0.0M));

                foreach (DateTime date in date_range)
                {
                    linebalance = ln.BalanceAsofCalcDate.GetValueOrDefault(0);

                    LiabilityMain lm = new LiabilityMain();
                    lm.SequenceID = ++ndx;
                    lm.Date = date;

                    //Fund details
                    lm.EffectiveDate = fund.FundUpdates.Where(upd => upd.EffectiveDate <= date).Max(ud => ud.EffectiveDate);
                    lm.InvestorCapital = fund.InvestorCapital;
                    lm.CapitalReserveReq = fund.CapitalReserveReq;
                    lm.ReserveReq = fund.ReserveReq;
                    lm.CapitalCallNoticeBusinessDays = fund.CapitalCallNoticeBusinessDays;
                    lm.FundBalance = fundbalance;

                    //subline details
                    lm.SublineBalance = sublinebalance;

                    //Line details
                    lm.LiabilityID = ln.LiabilityID;
                    lm.LiabilityType = ln.Type;
                    lm.FundingNoticeBusinessDays = ln.FundingNoticeBusinessDays;
                    lm.InitialFundingDelay = ln.InitialFundingDelay;
                    lm.PaydownDelay = ln.PaydownDelay;
                    lm.MaxAdvanceRate = ln.MaxAdvanceRate;
                    lm.OriginationDate = ln.OriginationDate;
                    lm.Commitment = ln.LiabilityLineUpdates.Where(upd => upd.EffectiveDate <= date).Max(ud => ud.Commitment);
                    lm.InitialMaturityDate = ln.LiabilityLineUpdates.Where(upd => upd.EffectiveDate <= date).Max(ud => ud.InitialMaturityDate);
                    lm.LiabilityBalance = linebalance;
                    this.LiabilityMainFrame.Add(lm);
                }

                lnotecount++;
            }
        }
        private void GenerateAssetLiabilityTransactionTable()
        {
            int ndx = 0, lnotecount = 0;
            decimal notebalance = 0.0M, assetbalance = 0.0M;
            decimal targetadvrate = 0.0M;
            bool piktxn = false;
            Fund fund = this.liabilityCFInput.Fund;

            //Generate Asset-Liability Transactions for all Equity & Liability Notes (Exclude Subline & Cash notes).
            foreach (LiabilityNote ln in liabilityCFInput.LiabilityNotes.Where(ln => CalculationEnums.FundingSourceText.Contains(ln.Type)))
            {
                notebalance = curbalance.ContainsKey(ln.LiabilityNoteID) ? curbalance[ln.LiabilityNoteID] : 0M;

                //Locate the Asset and load all transactions
                int anotendx = liabilityCFInput.AssetNotes.FindIndex(an => an.CreNoteID == ln.AssetID);
                if (anotendx != -1)
                {
                    AssetNote an = liabilityCFInput.AssetNotes[anotendx];
                    if (an != null)
                    {
                        assetbalance = an.BalanceAsofCalcDate.GetValueOrDefault(0);
                        List<DataContract.Liability.Transaction> assetTransactions = an.Transactions.OrderBy(tx => tx.Date).Where(t => t.Date >= CalcAsOfDate).ToList();
                        foreach (DataContract.Liability.Transaction at in assetTransactions.Where(tx => tx.Date >= this.CalcAsOfDate))
                        {
                            try
                            {
                                AssetLiabilityTransaction alt = new AssetLiabilityTransaction();
                                targetadvrate = ln.LiabilityNoteUpdates.OrderBy(u => u.EffectiveDate).Min().TargetAdvanceRate.GetValueOrDefault();
                                //targetadvrate = ln.LiabilityNoteUpdates.Where(upd => upd.EffectiveDate <= at.Date).Max(tx => tx.TargetAdvanceRate).Value;
                                piktxn = at.Type == CalculationEnums.TransactionTypeText[(int)TransactionType.PIKPrincipalFunding] || at.Type == CalculationEnums.TransactionTypeText[(int)TransactionType.PIKPrincipalPaid];

                                #region Create Transaction

                                alt.TransactionID = ++ndx;
                                alt.LiabilityNoteID = ln.LiabilityNoteID;
                                alt.LiabilityID = ln.LiabilityID;
                                alt.LiabilityType = ln.Type;    //ln.LiabilityID == fund.EquityName ? "Equity" : string.IsNullOrEmpty(fund.EquityName) ? "Unknown" : fund.EquityName;

                                alt.TransactionDate = at.Date;
                                alt.TransactionType = at.Type;
                                alt.TargetAdvanceRate = targetadvrate;
                                alt.TransactionAmount = at.Amount * targetadvrate * -1.0M;
                                notebalance += alt.TransactionAmount.Value;
                                alt.LiabilityNoteBalance = notebalance;

                                alt.AssetID = an.CreNoteID;
                                alt.TransactionEntryID = at.TransactionEntryID;
                                alt.AssetTransactionDate = at.Date;
                                alt.AssetTransactionType = at.Type;
                                alt.AssetTransactionAmount = at.Amount;
                                assetbalance += alt.AssetTransactionAmount.Value * -1.0M;
                                alt.AssetBalance = assetbalance;

                                //alt.TransactionKey = ln.LiabilityNoteID + "_" + alt.TransactionDate.Value.Date.ToString("yyyyMMdd") + "_" + alt.TransactionType;
                                #endregion
                                ListAssetLiabilityTransactions.Add(alt);
                            }
                            catch (Exception ex)
                            {
                                ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateTransactions failed for : " + ln.LiabilityNoteID + " : "
                                    + an.CreNoteID + " : " + at.Date.ToString() + " : " + at.Type + System.Environment.NewLine;
                                throw ex;
                            }

                        }

                    }
                }
                lnotecount++;
            }

            UpdateBalances();
            UpdateMainFrameBalance();
            //this.dtAssetLiabilityTransactions = CalculationHelper.ToDataSet(this.ListAssetLiabilityTransactions);
        }
        private void UpdateBalances()
        {
            Decimal sublinebalance = 0.0M, fundbalance = 0.0M, lnbalance = 0.0M;

            //Update Fund Balance
            fundbalance = liabilityCFInput.Fund.BalanceAsofCalcDate.GetValueOrDefault(0);
            List<AssetLiabilityTransaction> FundTransactions = ListAssetLiabilityTransactions.Where(txn => txn.LiabilityID == liabilityCFInput.Fund.EquityName).OrderBy(t => t.TransactionDate).ToList();
            foreach (AssetLiabilityTransaction ftxn in FundTransactions)
            {
                fundbalance = fundbalance + ftxn.TransactionAmount.Value;
                ftxn.FundBalance = fundbalance;
            }

            //Update Line Balance
            foreach (LiabilityLine line in liabilityCFInput.LiabilityLines)
            {
                lnbalance = line.BalanceAsofCalcDate.GetValueOrDefault(0);
                List<AssetLiabilityTransaction> lineTransactions = ListAssetLiabilityTransactions.Where(txn => txn.LiabilityID == line.LiabilityID).OrderBy(t => t.TransactionDate).ToList();

                foreach (AssetLiabilityTransaction ltxn in lineTransactions)
                {
                    lnbalance += ltxn.TransactionAmount.Value;
                    ltxn.LiabilityLineBalance = lnbalance;
                }
            }

            //Update Subline Balance
            sublinebalance = subline.BalanceAsofCalcDate.GetValueOrDefault(0);
            List<AssetLiabilityTransaction> SubTransactions = ListAssetLiabilityTransactions.Where(txn => txn.LiabilityID == subline.LiabilityID).OrderBy(t => t.TransactionDate).ToList();
            foreach (AssetLiabilityTransaction stxn in SubTransactions)
            {
                sublinebalance += stxn.TransactionAmount.Value;
                stxn.SublineBalance = sublinebalance;
            }

        }
        private void UpdateMainFrameBalance()
        {
            decimal LBalanceAsOfCalcDate = 0.0M, lnbalance = 0.0M, subbalance = 0.0M;
            DateTime firstTransactionDate = DateTime.MinValue;

            //Update Liability Line Balances
            foreach (LiabilityLine ln in liabilityCFInput.LiabilityLines)
            {
                LBalanceAsOfCalcDate = ln.BalanceAsofCalcDate.GetValueOrDefault(0);
                lnbalance = ln.BalanceAsofCalcDate.GetValueOrDefault(0);
                subbalance = ln.Type == CalculationEnums.AccountCategoriesText[(int)AccountTypes.Subline] ? ln.BalanceAsofCalcDate.GetValueOrDefault(0) : 0;

                //Get all transactions for this line 
                List<AssetLiabilityTransaction> lineTransactions = ListAssetLiabilityTransactions.Where(txn => txn.LiabilityID == ln.LiabilityID).OrderBy(txn => txn.TransactionDate).ToList();

                //Get the section from Liability Main Frame for this line
                List<LiabilityMain> lnMain = LiabilityMainFrame.Where(mn => mn.LiabilityID == ln.LiabilityID).OrderBy(m => m.Date).ToList();

                firstTransactionDate = lineTransactions.Min(t => t.TransactionDate).GetValueOrDefault();
                foreach (LiabilityMain main in lnMain)
                {
                    if (main.Date >= firstTransactionDate)
                    {
                        lnbalance += lineTransactions.Where(tx => tx.TransactionDate == main.Date).Sum(t => t.TransactionAmount.Value);
                        main.LiabilityBalance = lnbalance;
                        if (main.LiabilityID == this.subline.LiabilityID)
                            main.SublineBalance = lnbalance;
                    }
                }
            }

            //Update Fund Balances
            //Get all transactions for the fund
            List<AssetLiabilityTransaction> FundTransactions = ListAssetLiabilityTransactions.Where(txn => txn.LiabilityID == liabilityCFInput.Fund.EquityName).OrderBy(txn => txn.TransactionDate).ToList();
            //foreach (LiabilityLine ln in liabilityCFInput.LiabilityLines.Where(ll => ll.LiabilityID != subline.LiabilityID))
            foreach (LiabilityLine ln in liabilityCFInput.LiabilityLines)
            {
                firstTransactionDate = FundTransactions.Min(t => t.TransactionDate).GetValueOrDefault();
                List<LiabilityMain> lnMain = LiabilityMainFrame.Where(mn => mn.LiabilityID == ln.LiabilityID).OrderBy(m => m.Date).ToList();
                foreach (LiabilityMain main in lnMain.Where(mn => mn.Date >= firstTransactionDate))
                {
                    if (main.Date >= firstTransactionDate)
                    {
                        int txnid = FundTransactions.Where(t => t.TransactionDate <= main.Date).Max(t => t.TransactionID).Value;
                        AssetLiabilityTransaction ltxn = FundTransactions.Where(txn => txn.TransactionID == txnid).FirstOrDefault();
                        main.FundBalance = ltxn.FundBalance;
                    }
                }
            }
        }
        #endregion Main

        #region Configuration Options
        private void ApplyConfigurationOptions(string opMode)
        {
            switch (opMode)
            {

                case "GenTransactionDates":
                    ConfigOptionBase(999, 999);    //setting both Notice business days to 999, forces the method to use the Capital Call Business Days for the fund and Financial Notice Days for Lines.
                    break;

                case "DrawUptoFullFundBalance":
                    ConfigOptionEquityOnly();
                    break;

                case "MonthsToHold":
                    ConfigOptionSublineMonths();
                    break;

                case "ScheduledDraws":
                    ConfigOptionScheduleDraws();
                    break;
            }

        }

        // No Subline: Generate Liability (Debt & Equity) Transaction dates based on Notice Business Days.
        // Set Parameter values to 999 to default to Fund and Liability notice days. Or call without any parameters.
        // Method is callable from other Configuration Handlers.
        private void ConfigOptionBase(int BusinessDayNoticeEquity = 999, int BusinessDayNoticeDebt = 999)
        {
            int len = config.CapitalCallDaysOfTheMonth.Length;
            int BusinessDaysNotice = 0;
            LiabilityMain main = null;
            Fund fund = liabilityCFInput.Fund;

            foreach (AssetLiabilityTransaction alt in this.ListAssetLiabilityTransactions)
            {
                main = null;
                try
                {
                    if (alt.LiabilityID == fund.EquityName)
                        BusinessDaysNotice = BusinessDayNoticeEquity == 999 ? fund.CapitalCallNoticeBusinessDays.Value : BusinessDayNoticeEquity;
                    else
                    {
                        //Pick up the Notice Business Days by Effective Date
                        main = GetMainFrameData(alt.LiabilityID, alt.TransactionDate.Value.Date);
                        BusinessDaysNotice = BusinessDayNoticeDebt == 999 ? main == null ? 0 : main.FundingNoticeBusinessDays.Value : BusinessDayNoticeDebt;
                    }

                    alt.TransactionDate = CalculationHelper.GetWorkingDayUsingOffset(alt.TransactionDate.Value.Date, BusinessDaysNotice * -1, HolidayCalendarType, true);
                }
                catch (Exception ex)
                {
                    ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateTransactions failed for : " + alt.LiabilityNoteID + " : "
                        + alt.AssetID + " : " + alt.TransactionDate.ToString() + " : " + alt.TransactionType + System.Environment.NewLine;
                    throw ex;
                }
            }
        }

        // No Repo line, Optional Subline: DrawUptoFullFundBalance - Utiize Fund Balance completely.
        // TO DO : Optionally include Subline
        private void ConfigOptionEquityOnly(bool bSubline = false)
        {
            Fund fund = liabilityCFInput.Fund;
            decimal ReserveAmount = fund.InvestorCapital.Value * fund.CapitalReserveReq.Value;
            decimal FundAvailableBalance = fund.BalanceAsofCalcDate.Value - ReserveAmount;

            //Split the Asset-Liability Transactions into Equity & Debt transactions ordered by Transaction Date 
            List<AssetLiabilityTransaction> FundTransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID == fund.EquityName)
                .OrderBy(txn => txn.TransactionDate).ToList();
            List<AssetLiabilityTransaction> debttransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID != fund.EquityName)
                .OrderBy(txn => txn.TransactionDate).ToList();

            foreach (AssetLiabilityTransaction alt in FundTransactions)
            {
                //For each Note go through the transactions and set them to Fund until Fund Available balance is 0.
                //Make sure to update the transaction for Debt as well for the asset.
                try
                {
                    if (alt.AssetTransactionAmount.Value * -1 <= FundAvailableBalance)
                    {
                        alt.TransactionAmount = alt.AssetTransactionAmount;
                        FundAvailableBalance -= alt.AssetTransactionAmount.Value * -1;
                        alt.FundBalance -= alt.AssetTransactionAmount * -1;
                        AssetLiabilityTransaction falt = debttransactions.Where(txn => txn.TransactionEntryID == alt.TransactionEntryID).FirstOrDefault();
                        if (falt != null)
                        {
                            falt.TransactionAmount = 0;
                        }
                    }
                    else //Not enough balance in the fund draw full amount from debt
                    {
                        AssetLiabilityTransaction falt = debttransactions.Where(txn => txn.AssetID == alt.AssetID && txn.AssetTransactionDate == alt.AssetTransactionDate && txn.TransactionType == alt.TransactionType).FirstOrDefault();
                        if (falt != null)
                        {
                            falt.TransactionAmount = alt.AssetTransactionAmount;
                        }
                    }

                    UpdateBalances();

                }
                catch (Exception ex)
                {
                    ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateTransactions failed for : " + alt.LiabilityNoteID + " : "
                        + alt.AssetID + " : " + alt.TransactionDate.ToString() + " : " + alt.TransactionType + System.Environment.NewLine;
                    throw ex;
                }
            }
        }

        ///With Subline: MonthsToHold - Fund asset transactions from Subline and hold the amount on Subline for a preset period of time.
        /// This method adds additional records/transactions to the ALT Table.
        ///For asset funding transaction, create three subline transactions
        /// 1) A draw for the full funding amount on Asset Transaction Date
        /// 2) Remit when Equity draw happens and
        /// 3) Remit when Debt draw happens.
        /// 4) Move the Eq transaction by EqHold Months, and debt transaction by FinHold months.
        private void ConfigOptionSublineMonths()
        {
            bool bFunding = false;
            Fund fund = liabilityCFInput.Fund;
            int FinDelay = config.FinDelayMonths;
            int EqDelay = config.EqDelayMonths;
            int FinHold = config.SublineFinApplyMonths;
            int EqHold = config.SublineEqApplyMonths;
            decimal AssetTransactionAmount = 0, LiabilityTransactionAmount = 0, RepoLineCommitmentAmount = 0;

            //Split the Asset-Liability Transactions into Equity & Debt transactions ordered by Transaction Date 
            List<AssetLiabilityTransaction> FundTransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID == fund.EquityName && txn.TransactionType != "PIKPrincipalFunding")
                .OrderBy(txn => txn.TransactionDate).ToList();
            List<AssetLiabilityTransaction> debttransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID != fund.EquityName && txn.TransactionType != "PIKPrincipalFunding")
                .OrderBy(txn => txn.TransactionDate).ToList();

            foreach (AssetLiabilityTransaction alt in FundTransactions)
            {

                AssetTransactionAmount = Math.Abs(alt.AssetTransactionAmount.Value);
                bFunding = alt.AssetTransactionAmount < 0;

                try
                {
                    //Asset Transaction Amounts are rounded to the penny. No additional steps required before creating a subline transaction.
                    if (bFunding)
                    {
                        AssetLiabilityTransaction sub_draw = GenerateSublineTransaction(alt, alt.AssetTransactionAmount.Value, EqHold, true);
                        ListAssetLiabilityTransactions.Add(sub_draw);
                    }

                    //Grab the debt transaction and move it down by FinHOld months
                    AssetLiabilityTransaction falt = debttransactions.Where(txn => txn.TransactionEntryID == alt.TransactionEntryID).FirstOrDefault();
                    if (falt != null)
                    {
                        LiabilityMain main = GetMainFrameData(falt.LiabilityID, falt.TransactionDate.Value);
                        if (main != null && main.Commitment != null)
                        {
                            RepoLineCommitmentAmount = main.Commitment.Value;

                            //If its a draw from Repo Line (TransactionAmount > 0), do not draw more than the commitment amount
                            //If its a pay down, do not pay more than the current balance.
                            if (falt.TransactionAmount > 0)  //Draw from Repo line into Portfolio - cap at Commitment - Current Balance
                                falt.TransactionAmount = Math.Min(falt.TransactionAmount.Value, RepoLineCommitmentAmount - falt.LiabilityLineBalance.Value);
                            else
                                falt.TransactionAmount = Math.Min(Math.Abs(falt.TransactionAmount.Value), falt.LiabilityLineBalance.Value) * -1;
                        }
                        //Round the transaction Amount to a penny
                        falt.TransactionAmount = Math.Round(falt.TransactionAmount.Value, 2);
                        LiabilityTransactionAmount = Math.Abs(falt.TransactionAmount.Value);
                        if (bFunding)
                        {
                            AssetLiabilityTransaction sub_debtreturn = GenerateSublineTransaction(falt, falt.TransactionAmount.Value, FinHold, false);
                            falt.TransactionDate = falt.TransactionDate.Value.AddMonths(FinHold);
                            ListAssetLiabilityTransactions.Add(sub_debtreturn);
                        }
                    }

                    //Set the Equity transaction amount to the residual
                    if (alt.AssetTransactionAmount < 0) //Asset Outflow(-ve) ==> Draw from equity/repo/subline(+ve)
                    {
                        alt.TransactionAmount = alt.AssetTransactionAmount.Value * -1 - LiabilityTransactionAmount;
                    }
                    else //Asset inflow(+ve) Scheduled Principal/Pay Down/ Balloon ==> Remit to equity/repo (-ve)
                    {
                        // Switch the sign since money will be payed out to equity from portfolio funds.
                        alt.TransactionAmount = (alt.AssetTransactionAmount.Value - LiabilityTransactionAmount) * -1;
                    }

                    if (bFunding) //Move the Equity transaction by Eqhold months.
                    {
                        AssetLiabilityTransaction sub_eqreturn = GenerateSublineTransaction(alt, alt.TransactionAmount.Value, EqHold, false);
                        alt.TransactionDate = alt.TransactionDate.Value.AddMonths(EqHold);
                        ListAssetLiabilityTransactions.Add(sub_eqreturn);
                    }
                    //UpdateBalances();
                }
                catch (Exception ex)
                {
                    ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateTransactions failed for : " + alt.LiabilityNoteID + " : "
                        + alt.AssetID + " : " + alt.TransactionDate.ToString() + " : " + alt.TransactionType + System.Environment.NewLine;
                    throw ex;
                }
            }
            UpdateBalances();
        }

        /// <summary>
        /// With Subline: ScheduledDraws - Fund from Subline and schedule Equity & Debt draws subsequently 
        /// If Asset funding is before the 15th of the month schedule for current month end, else next month end.
        /// </summary>
        private void ConfigOptionScheduleDraws()
        {
            bool bFunding = false;
            Fund fund = liabilityCFInput.Fund;
            int FinDelay = config.FinDelayMonths;
            int EqDelay = config.EqDelayMonths;
            int FinHold = 0, FundingDayOfMonth = 30;
            int EqHold = 0, EquityFundingDayOfMonth = 30;
            DateTime NextTransactionDate = DateTime.MinValue;
            decimal CashTransactionAmount = 0, AssetTransactionAmount = 0, LiabilityTransactionAmount = 0, RepoLineCommitmentAmount = 0;

            //Split the Asset-Liability Transactions into Equity & Debt transactions ordered by Transaction Date 
            List<AssetLiabilityTransaction> FundTransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID == fund.EquityName)
                .OrderBy(txn => txn.TransactionDate).ToList();
            List<AssetLiabilityTransaction> debttransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID != fund.EquityName)
                .OrderBy(txn => txn.TransactionDate).ToList();

            foreach (AssetLiabilityTransaction alt in FundTransactions)
            {
                // For each transaction, create three subline transactions
                // 1) A draw for the full funding amount on Asset Transaction Date
                // 2) remit when Equity draw happens and
                // 3) Remit when Debt draw happens.
                // And move the Eq transaction by EqHold Months, and debt transaction by FinHold months.

                bFunding = alt.AssetTransactionAmount < 0;
                LiabilityTransactionAmount = 0;
                EqHold = fund.FundDelay.Value;
                EquityFundingDayOfMonth = fund.FundingDay.Value;

                try
                {
                    if (bFunding)
                    {
                        // Draw the full amount from Subline
                        //CashTransactionAmount = Math.Min(alt.CashSublineBalance.GetValueOrDefault(), alt.TransactionAmount.Value);
                        AssetLiabilityTransaction sub_draw = GenerateSublineTransaction(alt, alt.AssetTransactionAmount.Value, EqHold, true);
                        ListAssetLiabilityTransactions.Add(sub_draw);

                        // Generate a mirror transaction for Cash
                        CashTransactionAmount = Math.Min(alt.CashSublineBalance.GetValueOrDefault(), alt.TransactionAmount.Value);
                        AssetLiabilityTransaction cash_draw = GenerateCashTransaction(sub_draw, -1 * sub_draw.AssetTransactionAmount.Value, EqHold, true);
                        ListAssetLiabilityTransactions.Add(cash_draw);

                    }
                    //Grab the Debt transaction and move it to the next Debt Call of the Month Date
                    AssetLiabilityTransaction falt = debttransactions.Where(txn => txn.TransactionEntryID == alt.TransactionEntryID).FirstOrDefault();
                    if (falt != null)
                    {
                        FinHold = liabilityCFInput.LiabilityLines.FindIndex(ll => ll.LiabilityID == falt.LiabilityID) > -1 ?
                            liabilityCFInput.LiabilityLines.Where(ln => ln.LiabilityID == falt.LiabilityID).First().FundDelay.Value : 0;
                        FundingDayOfMonth = liabilityCFInput.LiabilityLines.FindIndex(ll => ll.LiabilityID == falt.LiabilityID) > -1 ?
                            liabilityCFInput.LiabilityLines.Where(ln => ln.LiabilityID == falt.LiabilityID).First().FundingDay.Value : 30;

                        LiabilityMain main = GetMainFrameData(falt.LiabilityID, falt.TransactionDate.Value);
                        if (main != null)
                        {
                            RepoLineCommitmentAmount = main.Commitment.GetValueOrDefault();

                            //If its a draw from Repo Line (TransactionAmount > 0), do not draw more than the commitment amount
                            //If its a pay down, do not pay more than the current balance.
                            if (RepoLineCommitmentAmount > 0)
                            {
                                if (falt.TransactionAmount > 0)  //Draw from Repo line into Portfolio - cap at Commitment - Current Balance
                                    falt.TransactionAmount = Math.Min(falt.TransactionAmount.Value, RepoLineCommitmentAmount - falt.LiabilityLineBalance.Value);
                                else
                                    falt.TransactionAmount = Math.Min(Math.Abs(falt.TransactionAmount.Value), falt.LiabilityLineBalance.Value) * -1.0M;
                            }
                        }
                        //Round the transaction Amount to a penny
                        falt.TransactionAmount = Math.Round(falt.TransactionAmount.Value, 2);
                        LiabilityTransactionAmount = Math.Abs(falt.TransactionAmount.Value);

                        if (bFunding)
                        {
                            falt.TransactionDate = GetNextTransactionDate(falt.TransactionDate.Value, FundingDayOfMonth);
                            AssetLiabilityTransaction sub_debtreturn = GenerateSublineTransaction(falt, falt.TransactionAmount.Value, FinHold, false);
                            ListAssetLiabilityTransactions.Add(sub_debtreturn);

                            // Generate a mirror transaction for Cash
                            CashTransactionAmount = Math.Min(alt.CashSublineBalance.GetValueOrDefault(), alt.TransactionAmount.Value);
                            AssetLiabilityTransaction cash_debtreturn = GenerateCashTransaction(sub_debtreturn, -1 * sub_debtreturn.AssetTransactionAmount.Value, FinHold, true);
                            ListAssetLiabilityTransactions.Add(cash_debtreturn);
                        }
                    }
                    //Set the Equity transaction amount to the residual
                    if (alt.AssetTransactionAmount < 0) //Asset Outflow(-ve) ==> Draw from equity/repo/subline(+ve)
                    {
                        alt.TransactionAmount = alt.AssetTransactionAmount.Value * -1 - LiabilityTransactionAmount;
                    }
                    else //Asset inflow(+ve) Scheduled Principal/Pay Down/ Balloon ==> Remit to equity/repo (-ve)
                    {
                        // Switch the sign since money will be payed out to equity from portfolio funds.
                        alt.TransactionAmount = (alt.AssetTransactionAmount.Value - LiabilityTransactionAmount) * -1;
                    }
                    //Schedule the Equity transaction to the next available date.
                    if (bFunding)
                    {
                        alt.TransactionDate = GetNextTransactionDate(alt.TransactionDate.Value, EquityFundingDayOfMonth);
                        AssetLiabilityTransaction cash_eqcall = GenerateCashTransaction(alt, -1 * alt.TransactionAmount.Value, FinHold, true);
                        ListAssetLiabilityTransactions.Add(cash_eqcall);

                        AssetLiabilityTransaction sub_eqreturn = GenerateSublineTransaction(alt, alt.TransactionAmount.Value, EqHold, false);
                        ListAssetLiabilityTransactions.Add(sub_eqreturn);

                        // Generate a mirror transaction for Cash
                        CashTransactionAmount = Math.Min(alt.CashSublineBalance.GetValueOrDefault(), alt.TransactionAmount.Value);
                        AssetLiabilityTransaction cashsub_eqreturn = GenerateCashTransaction(sub_eqreturn, -1 * sub_eqreturn.AssetTransactionAmount.Value, FinHold, true);
                        ListAssetLiabilityTransactions.Add(cashsub_eqreturn);
                    }
                }
                catch (Exception ex)
                {
                    ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateTransactions failed for : " + alt.LiabilityNoteID + " : "
                        + alt.AssetID + " : " + alt.TransactionDate.ToString() + " : " + alt.TransactionType + System.Environment.NewLine;
                    throw ex;
                }
            }
            //Insert Manual transactions
            int ndx = 10000;
            foreach (ManualEntry mtrn in ListManualEntries)
            {
                AssetLiabilityTransaction alt = new AssetLiabilityTransaction();
                #region Create Manual Transaction
                try
                {
                    alt.TransactionID = ++ndx;
                    alt.LiabilityID = mtrn.AccountName;
                    alt.TransactionDate = mtrn.TransactionDate;
                    alt.TransactionType = mtrn.TransactionType;
                    alt.TransactionAmount = mtrn.TransactionAmount;
                    //alt.TransactionKey = ln.LiabilityNoteID + "_" + alt.TransactionDate.Value.Date.ToString("yyyyMMdd") + "_" + alt.TransactionType;
                    ListAssetLiabilityTransactions.Add(alt);
                }
                catch (Exception exm)
                {
                    ListLiabilityCFOutput.CalculatorExceptionMessage += "Manual transactions failed for : " + mtrn.AccountName + " : "
                        + alt.AssetID + " : " + alt.TransactionDate.ToString() + " : " + alt.TransactionType + System.Environment.NewLine;
                    throw exm;
                }
                #endregion
            }

            UpdateBalances();
        }
        #endregion

        #region Reports / Output
        private void GenerateLiabilityNoteTransactions()
        {
            decimal fundbalance = 0, lnbalance = 0, sublinebalance = 0, cashsubbalance = 0;
            List<LiabilityMain> mains = null;
            List<LiabilityMain> subs = null;
            LiabilityMain main = null, sub = null;
            Guid? LiabilityAccountID = null, AssetAccountID = null;
            List<AssetLiabilityTransaction> ListLiabilityNoteTransactions;
            cashsubbalance = cash_sub.BalanceAsofCalcDate.GetValueOrDefault();

            foreach (LiabilityNote ln in liabilityCFInput.LiabilityNotes)
            {
                //Set Ending Balance to Calc As of Date Balance
                lnbalance = ln.BalanceAsofCalcDate.GetValueOrDefault(0);
                mains = null; main = null; subs = null;

                if (ln.LiabilityID == liabilityCFInput.Fund.EquityName)
                    LiabilityAccountID = liabilityCFInput.Fund.EquityAccountID;
                else
                {
                    //Find the Line for this LiabilityNote
                    int ndxl = this.liabilityCFInput.LiabilityLines.FindIndex(ll => ll.LiabilityID == ln.LiabilityID);
                    if (ndxl > -1)
                    {
                        LiabilityAccountID = liabilityCFInput.LiabilityLines[ndxl].DebtAccountID;
                    }
                }
                int ndxa = this.liabilityCFInput.AssetNotes.FindIndex(a => a.CreNoteID == ln.AssetID);
                AssetAccountID = ndxa >= 0 ? liabilityCFInput.AssetNotes[ndxa].AssetAccountID : null;
                try
                {
                    //Find all transactions for the Liability Note in the DataFrame
                    ListLiabilityNoteTransactions = this.ListAssetLiabilityTransactions
                        .Where(txn => txn.LiabilityNoteID == ln.LiabilityNoteID && txn.TransactionAmount != 0)
                        .OrderBy(t => t.TransactionDate).ToList();

                    foreach (AssetLiabilityTransaction txn in ListLiabilityNoteTransactions)
                    {
                        //find all balances from Main Frame
                        mains = LiabilityMainFrame.Where(mn => mn.LiabilityID == ln.LiabilityID && mn.Date == txn.TransactionDate).ToList();
                        if (mains != null && mains.Count() > 0)
                            main = mains.First();
                        subs = LiabilityMainFrame.Where(mn => mn.LiabilityID == subline.LiabilityID && mn.Date == txn.TransactionDate).ToList();
                        if (subs != null && subs.Count() > 0)
                            sub = subs.First();

                        LiabilityNoteTransaction lnTxn = new LiabilityNoteTransaction();
                        lnTxn.AnalysisID = this.liabilityCFInput.AnalysisID;
                        lnTxn.LiabilityAccountID = LiabilityAccountID;
                        lnTxn.LiabilityNoteAccountID = ln.LiabilityNoteAccountID;
                        lnTxn.LiabilityID = ln.LiabilityID;
                        lnTxn.LiabilityNoteID = ln.LiabilityNoteID;

                        //Add Liability Note transaction details and Asset transaction detail
                        lnTxn.Date = txn.TransactionDate;
                        lnTxn.Amount = txn.TransactionAmount;

                        lnTxn.TransactionType = GetTransactionType(ln.LiabilityID, txn.TransactionAmount > 0);//txn.TransactionType;
                        lnbalance += txn.LiabilityType == cash_sub.Type ? 0 : txn.TransactionAmount.Value;
                        cashsubbalance += txn.LiabilityType == cash_sub.Type ? txn.TransactionAmount.Value : 0;
                        lnTxn.EndingBalance = txn.LiabilityType == cash_sub.Type ? 0 : lnbalance;
                        if (ln.LiabilityID == liabilityCFInput.Fund.EquityName)
                        {
                            if (sub != null)
                            {
                                lnTxn.FundBalance = sub.FundBalance.GetValueOrDefault();
                                lnTxn.LineBalance = null;
                                lnTxn.SublineBalance = sub.SublineBalance.GetValueOrDefault();
                            }
                        }
                        else
                        {
                            if (main != null)
                            {
                                lnTxn.FundBalance = main.FundBalance.GetValueOrDefault();
                                lnTxn.LineBalance = main.LiabilityBalance.GetValueOrDefault();
                                lnTxn.SublineBalance = main.LiabilityBalance.GetValueOrDefault(); ;
                            }
                        }
                        lnTxn.AssetAccountID = AssetAccountID;
                        lnTxn.AssetDate = txn.AssetTransactionDate;
                        lnTxn.AssetTransactionType = txn.AssetTransactionType;
                        lnTxn.AssetAmount = txn.AssetTransactionAmount;

                        // If there is a Portfolio/Cash transaction associated with the subline txn, include it in the output
                        if (txn.LiabilityType == cash_sub.Type)
                        {
                            lnTxn.LiabilityID = cash_sub.LiabilityID;
                            lnTxn.CashSublineBalance = cashsubbalance;
                        }
                        this.ListLiabilityNoteTransactions.Add(lnTxn);
                    }


                }
                catch (Exception ex)
                {
                    ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateTransactions failed for : " + ln.LiabilityNoteID + System.Environment.NewLine;
                    throw ex;
                }

            }
        }
        private void GenerateLiabilityLineTransactions()
        {
            int ndx = 0;
            decimal? TransactionAmount = 0, fundbalance = 0, linebalance = 0, sublinebalance = 0, cashsublinebalance = 0;
            Fund fund = this.liabilityCFInput.Fund;

            //Split the Asset-Liability Transactions into Equity & Debt transactions ordered by Transaction Date 
            List<AssetLiabilityTransaction> FundDetailTransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID == fund.EquityName && txn.TransactionType != "PIKPrincipalFunding")
                .OrderBy(txn => txn.TransactionDate).ToList();
            List<AssetLiabilityTransaction> DebtDetailTransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID != fund.EquityName && txn.LiabilityID != subline.LiabilityID && txn.TransactionType != "PIKPrincipalFunding")
                .OrderBy(txn => txn.TransactionDate).ToList();
            List<AssetLiabilityTransaction> SublineDetailTransactions = (List<AssetLiabilityTransaction>)ListAssetLiabilityTransactions
                .Where(txn => txn.LiabilityID == subline.LiabilityID && txn.TransactionType != "PIKPrincipalFunding")
                .OrderBy(txn => txn.TransactionDate).ToList();

            //CalculationHelper.CreateCSVFile(CalculationHelper.ToDataSet(DebtDetailTransactions.Where(t => t.LiabilityID == "WF Repo").ToList()), "WFRepo");
            var FundTransactions = FundDetailTransactions.GroupBy(txn => new { txn.LiabilityID, txn.TransactionDate, txn.TransactionType });

            fundbalance = fund.BalanceAsofCalcDate.GetValueOrDefault();
            //Add Fund Transactions
            foreach (var FundTransaction in FundTransactions)
            {
                TransactionAmount = FundTransaction.Sum(t => t.TransactionAmount);
                if (TransactionAmount != 0)
                {
                    if (FundTransaction.Key.LiabilityID == fund.EquityName)
                    {
                        LiabilityLineTransaction llt = new LiabilityLineTransaction();

                        llt.AnalysisID = liabilityCFInput.AnalysisID;
                        llt.LiabilityAccountID = fund.EquityAccountID;
                        llt.LiabilityID = fund.EquityName;
                        llt.Date = FundTransaction.Key.TransactionDate;
                        llt.TransactionType = TransactionAmount > 0 ? "EquityCapitalCall" : "EquityCapitalDistribution";  //FundTransaction.Key.TransactionType;
                        llt.Amount = TransactionAmount;
                        fundbalance += TransactionAmount;
                        llt.EndingBalance = fundbalance;

                        ListLiabilityLineTransactions.Add(llt);
                    }
                }
            }

            var SublineTransactions = SublineDetailTransactions.GroupBy(txn => new { txn.LiabilityID, txn.TransactionDate });
            sublinebalance = subline.BalanceAsofCalcDate.GetValueOrDefault();
            //Add Subline Transactions
            foreach (var SublineTransaction in SublineTransactions)
            {
                TransactionAmount = SublineTransaction.Sum(t => t.TransactionAmount);
                if (TransactionAmount != 0)
                {

                    LiabilityLineTransaction llt = new LiabilityLineTransaction();

                    llt.AnalysisID = liabilityCFInput.AnalysisID;
                    llt.LiabilityAccountID = subline.DebtAccountID;
                    llt.LiabilityID = subline.LiabilityID;
                    llt.Date = SublineTransaction.Key.TransactionDate;
                    llt.TransactionType = TransactionAmount > 0 ? "SublineAdvance" : "SublinePaydown";  //SublineTransaction.TransactionType;
                    llt.Amount = TransactionAmount;
                    sublinebalance += TransactionAmount;
                    llt.EndingBalance = sublinebalance;

                    ListLiabilityLineTransactions.Add(llt);

                }
            }

            foreach (LiabilityLine ll in liabilityCFInput.LiabilityLines)
            {
                linebalance = ll.BalanceAsofCalcDate.GetValueOrDefault();
                var LineTransactions = DebtDetailTransactions.Where(txn => txn.LiabilityID == ll.LiabilityID).GroupBy(t => new { t.LiabilityID, t.TransactionDate, t.TransactionType });
                foreach (var LineTransaction in LineTransactions)
                {
                    TransactionAmount = LineTransaction.Sum(t => t.TransactionAmount);
                    if (TransactionAmount != 0)
                    {
                        LiabilityLineTransaction llt = new LiabilityLineTransaction();

                        llt.AnalysisID = liabilityCFInput.AnalysisID;
                        llt.LiabilityAccountID = ll.DebtAccountID;
                        llt.LiabilityID = ll.LiabilityID;
                        llt.Date = LineTransaction.Key.TransactionDate;
                        if (ll.Type == "Cash")
                            llt.TransactionType = TransactionAmount > 0 ? "SublineAdvance" : "SublinePaydown";  //SublineTransaction.TransactionType;
                        else
                            llt.TransactionType = TransactionAmount > 0 ? "RepoAdvance" : "RepoPaydown";  //LineTransaction.Key.TransactionType;

                        llt.Amount = TransactionAmount;
                        linebalance += TransactionAmount;
                        llt.EndingBalance = linebalance;

                        ListLiabilityLineTransactions.Add(llt);
                    }
                }
            }
        }
        private AssetLiabilityTransaction GenerateSublineTransaction(AssetLiabilityTransaction alt, decimal amount, int hold, bool bdraw)
        {
            AssetLiabilityTransaction slt = null;

            try
            {
                //Pick up the subline note for this deal
                LiabilityNote sub = liabilityCFInput.LiabilityNotes.Where(ln => ln.LiabilityID == subline.LiabilityID && ln.AssetID == alt.AssetID).FirstOrDefault();
                //bdraw = true: Drawing funds from Subline to fund asset: amount is -ve
                slt = alt.Clone();
                slt.LiabilityNoteID = sub.LiabilityNoteID;
                slt.LiabilityType = "Subline";
                slt.LiabilityID = this.subline.LiabilityID;
                slt.FundBalance = null;
                slt.LiabilityLineBalance = null;
                slt.LiabilityNoteBalance = null;

                slt.TransactionType = alt.TransactionType;
                slt.TransactionDate = bdraw ? alt.TransactionDate : alt.TransactionDate.Value.AddMonths(hold);
                slt.TransactionAmount = bdraw ? amount * -1 : slt.TransactionAmount * -1;

                //slt.SublineBalance -= slt.TransactionAmount * -1;
                //slt.TransactionKey = this.subline.LiabilityID + "_" + slt.TransactionDate.Value.Date.ToString("yyyyMMdd") + "_" + alt.TransactionType;

            }
            catch (Exception ex)
            {
                ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateSublineTransaction failed for : " + alt.LiabilityNoteID + " : "
                    + alt.AssetID + " : " + alt.TransactionDate.ToString() + " : " + alt.TransactionType + System.Environment.NewLine;
                throw ex;
            }

            return slt;
        }

        private AssetLiabilityTransaction GenerateCashTransaction(AssetLiabilityTransaction salt, decimal amount, int hold = 0, bool bdraw = true)
        {
            AssetLiabilityTransaction ct = null;

            try
            {
                ct = salt.Clone();
                ct.LiabilityNoteID = salt.LiabilityNoteID;
                ct.LiabilityType = "Cash";
                ct.LiabilityID = salt.LiabilityType == "Subline" ? this.cash_sub.LiabilityID : this.cash_eq.LiabilityID;
                ct.CashSublineBalance = 0;
                ct.FundBalance = 0;
                ct.LiabilityLineBalance = 0;
                ct.LiabilityNoteBalance = 0;
                ct.SublineBalance = 0;

                ct.TransactionType = salt.TransactionType;
                ct.TransactionDate = bdraw ? salt.TransactionDate : salt.TransactionDate.Value.AddMonths(hold);
                ct.TransactionAmount = bdraw ? amount * -1 : ct.TransactionAmount * -1;

                ct.CashSublineBalance += ct.TransactionAmount * -1;
            }
            catch (Exception ex)
            {
                ListLiabilityCFOutput.CalculatorExceptionMessage += "GenerateCashTransaction failed for : " + salt.LiabilityNoteID + " : "
                    + salt.AssetID + " : " + salt.TransactionDate.ToString() + " : " + salt.TransactionType + System.Environment.NewLine;
                throw ex;
            }

            return ct;
        }
        #endregion

        #region Helper methods
        private DateTime GetLastAssetTransactionDate(List<AssetNote> assetNotes)
        {
            DateTime LastTransactionDate = DateTime.MinValue;
            foreach (AssetNote an in assetNotes)
            {
                if (an.Transactions.Count > 0)
                {
                    var txn = an.Transactions.Max(t => t.Date.Value.Date);
                    if (txn.Date >= LastTransactionDate) LastTransactionDate = txn.Date;
                }
            }

            return LastTransactionDate;
        }
        private LiabilityMain GetMainFrameData(string Id, DateTime dt)
        {
            DateTime? maxDate = DateTime.MinValue;
            List<LiabilityMain> lsmain = null;
            LiabilityMain main = null;

            lsmain = LiabilityMainFrame.Where(mn => mn.LiabilityID == Id && mn.Date <= dt).ToList();
            if (lsmain.Count > 0)
            {
                maxDate = LiabilityMainFrame.Where(mn => mn.LiabilityID == Id && mn.Date <= dt).Max(t => t.Date);
                if (maxDate != null)
                    main = LiabilityMainFrame.Where(mn => mn.LiabilityID == Id && mn.Date == maxDate).FirstOrDefault();
            }
            return main;
        }

        private string GetTransactionType(string Id, bool bDraw = true)
        {
            string TransactionType = string.Empty;

            if (Id == liabilityCFInput.Fund.EquityName)
                TransactionType = bDraw ? "EquityCapitalCall" : "EquityCapitalDistribution";
            else if (Id == subline.LiabilityID)
                TransactionType = bDraw ? "SublineAdvance" : "SublinePaydown";
            else
                TransactionType = bDraw ? "RepoAdvance" : "RepoPaydown";

            return TransactionType;
        }
        private DateTime GetNextTransactionDate(DateTime dt, int[] DaysOfTheMonth)
        {
            DateTime nextDate = DateTime.MinValue;
            int minDay = DaysOfTheMonth.Length == 0 ? 1 : DaysOfTheMonth[0];

            foreach (int day in DaysOfTheMonth)
            {
                if (day > dt.Day)
                {
                    nextDate = new DateTime(dt.Year, dt.Month, day);
                    break;
                }
            }
            if (nextDate == DateTime.MinValue)
                nextDate = new DateTime(dt.AddMonths(1).Year, dt.AddMonths(1).Month, minDay);

            return nextDate;
        }
        private DateTime GetNextTransactionDate(DateTime dt, int FundingDayOfMonth)
        {
            //If Asset Transaction date <= 15, this monthend else next Month End.

            DateTime nextDate = new DateTime(dt.Year, dt.Month, 1);
            nextDate = dt.Day <= 15 ? nextDate.AddMonths(1).AddDays(-1) : nextDate.AddMonths(2).AddDays(-1);

            return nextDate;
        }
        #endregion
    }
}
