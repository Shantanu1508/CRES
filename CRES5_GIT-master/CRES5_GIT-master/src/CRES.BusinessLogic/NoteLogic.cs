using CRES.DAL.Helper;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class NoteLogic
    {
        private NoteRepository _noteRepository = new NoteRepository();
        public DealLogic _deallogic;
        public FeeConfigurationLogic feeConfigLogic = new FeeConfigurationLogic();
        public List<NoteDataContract> GetAllNotesFromDealIds(string DealId, Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();
            lstNotes = _noteRepository.GetNoteFromDealIds(DealId, userId, pageIndex, pageSize, out TotalCount);
            return lstNotes;
        }


        public List<NoteUsedInDealDataContract> GetNotesFromDealDetailByDealID(string DealId, Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<NoteUsedInDealDataContract> lstNotes = new List<NoteUsedInDealDataContract>();
            lstNotes = _noteRepository.GetNotesFromDealDetailByDealID(DealId, userId, pageIndex, pageSize, out TotalCount);
            return lstNotes;
        }

        public string AddNewNote(Guid? userid, List<NoteDataContract> noteDC, string createdBy, string UpdatedBy)
        {
            string noteValue;
            noteValue = _noteRepository.AddNewNote(userid, noteDC, createdBy, UpdatedBy);
            return noteValue;
        }
        ///

        public string AddNewNoteFromDealDetail(Guid? userid, List<NoteDataContract> noteDC, string createdBy, string UpdatedBy)
        {
            _deallogic = new DealLogic();
            string noteValue = "";
            noteValue = _noteRepository.AddNewNoteFromDealDetail(userid, noteDC, createdBy, UpdatedBy);

            return noteValue;
        }

        public NoteDataContract GetNoteFromNoteId(string noteId, Guid? userId, Guid? AnalysisID)
        {
            NoteDataContract objNote = new NoteDataContract();
            objNote = _noteRepository.GetNoteFromNoteId(noteId, userId, AnalysisID);

            return objNote;
        }

        //public NoteDataContract GetNoteByCRENoteId(string CRENoteId)
        //{
        //    NoteDataContract objNote = new NoteDataContract();
        //    objNote = _noteRepository.GetNoteByCRENoteId(CRENoteId);
        //    return objNote;
        //}

        public NoteAdditinalListDataContract GetNoteAdditinalList(Guid? noteId, Guid? userId)
        {
            return _noteRepository.GetNoteAdditinalList(noteId, userId);
        }

        public List<MaturityScenariosDataContract> GetMaturityPeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<MaturityScenariosDataContract> _maturityScenariosDataContractList = new List<MaturityScenariosDataContract>();
            _maturityScenariosDataContractList = _noteRepository.GetMaturityPeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _maturityScenariosDataContractList;
        }

        public List<RateSpreadSchedule> GetRateSpreadSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<RateSpreadSchedule> _rateSpreadScheduleList = new List<RateSpreadSchedule>();
            _rateSpreadScheduleList = _noteRepository.GetRateSpreadSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _rateSpreadScheduleList;
        }

        public List<PrepayAndAdditionalFeeScheduleDataContract> GetPrepayAndAdditionalFeeScheduleDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<PrepayAndAdditionalFeeScheduleDataContract> _PrepayAndAdditionalFeeScheduleList = new List<PrepayAndAdditionalFeeScheduleDataContract>();
            _PrepayAndAdditionalFeeScheduleList = _noteRepository.GetPrepayAndAdditionalFeeScheduleDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _PrepayAndAdditionalFeeScheduleList;
        }

        public List<StrippingScheduleDataContract> GetStrippingSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<StrippingScheduleDataContract> _strippingScheduleDataContractList = new List<StrippingScheduleDataContract>();
            _strippingScheduleDataContractList = _noteRepository.GetStrippingSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _strippingScheduleDataContractList;
        }

        public List<FinancingFeeScheduleDataContract> GetFinancingFeeSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FinancingFeeScheduleDataContract> _financingFeeScheduleDataContractList = new List<FinancingFeeScheduleDataContract>();
            _financingFeeScheduleDataContractList = _noteRepository.GetFinancingFeeSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _financingFeeScheduleDataContractList;
        }

        public List<FinancingScheduleDataContract> GetFinancingSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FinancingScheduleDataContract> _financingScheduleDataContractList = new List<FinancingScheduleDataContract>();
            _financingScheduleDataContractList = _noteRepository.GetFinancingSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _financingScheduleDataContractList;
        }

        public List<DefaultScheduleDataContract> GetDefaultSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<DefaultScheduleDataContract> _defaultScheduleDataContractList = new List<DefaultScheduleDataContract>();
            _defaultScheduleDataContractList = _noteRepository.GetDefaultSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _defaultScheduleDataContractList;
        }

        public List<NoteServicingFeeScheduleDataContract> GetServicingFeeSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<NoteServicingFeeScheduleDataContract> _noteServicingFeeScheduleDataContractList = new List<NoteServicingFeeScheduleDataContract>();
            _noteServicingFeeScheduleDataContractList = _noteRepository.GetServicingFeeSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _noteServicingFeeScheduleDataContractList;
        }

        public List<PIKSchedule> GetPIKSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<PIKSchedule> _pIKScheduleList = new List<PIKSchedule>();
            _pIKScheduleList = _noteRepository.GetPIKSchedulePeriodicDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _pIKScheduleList;
        }

        public List<EffectiveDateList> GetEffectiveDateListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<EffectiveDateList> _effectiveDateList = new List<EffectiveDateList>();
            _effectiveDateList = _noteRepository.GetEffectiveDateListDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _effectiveDateList;
        }

        public List<FutureFundingScheduleTab> GetFutureFundingScheduleTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FutureFundingScheduleTab> _futureFundingScheduleTabList = new List<FutureFundingScheduleTab>();
            _futureFundingScheduleTabList = _noteRepository.GetFutureFundingScheduleTabListDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _futureFundingScheduleTabList;
        }

        public List<FFutureFundingScheduleTab> GetInputFutureFundingScheduleListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FFutureFundingScheduleTab> _futureFundingScheduleTabList = new List<FFutureFundingScheduleTab>();
            _futureFundingScheduleTabList = _noteRepository.GetInputFutureFundingScheduleListDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _futureFundingScheduleTabList;
        }
        //
        public List<PIKfromPIKSourceNoteTab> GetPIKfromPIKSourceNoteTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<PIKfromPIKSourceNoteTab> _pIKfromPIKSourceNoteTabList = new List<PIKfromPIKSourceNoteTab>();
            _pIKfromPIKSourceNoteTabList = _noteRepository.GetPIKfromPIKSourceNoteTabListDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _pIKfromPIKSourceNoteTabList;
        }

        public List<FeeCouponStripReceivableTab> GetFeeCouponStripReceivableListDataByNoteId(Guid? noteid, Guid? userID, Guid? AnalysisID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FeeCouponStripReceivableTab> _feeCouponStripReceivableDataContractList = new List<FeeCouponStripReceivableTab>();
            _feeCouponStripReceivableDataContractList = _noteRepository.GetFeeCouponStripReceivableTabListDataByNoteId(noteid, userID, AnalysisID, pageIndex, pageSize, out TotalCount);
            return _feeCouponStripReceivableDataContractList;
        }

        public List<LiborScheduleTab> GetLiborScheduleTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<LiborScheduleTab> _liborScheduleTabList = new List<LiborScheduleTab>();
            _liborScheduleTabList = _noteRepository.GetLiborScheduleTabListDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _liborScheduleTabList;
        }

        public List<FixedAmortScheduleTab> GetFixedAmortScheduleTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FixedAmortScheduleTab> _fixedAmortScheduleTabList = new List<FixedAmortScheduleTab>();
            _fixedAmortScheduleTabList = _noteRepository.GetFixedAmortScheduleTabListDataByNoteId(noteid, userID, pageIndex, pageSize, out TotalCount);
            return _fixedAmortScheduleTabList;
        }

        public DataTable GetHistoricalDataOfModuleByNoteId(Guid? noteid, Guid? userID, string moduleName, string AnalysisID)
        {
            DataTable dt = new DataTable();
            dt = _noteRepository.GetHistoricalDataOfModuleByNoteId(noteid, userID, moduleName, AnalysisID);
            return dt;
        }

        public NoteAllScheduleLatestRecordDataContract GetAllScheduleLatestDataByNoteId(Guid? noteid, Guid? userID, Guid? AnalysisID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            NoteAllScheduleLatestRecordDataContract _noteAllScheduleLatestRecordDataContract = new NoteAllScheduleLatestRecordDataContract();
            _noteAllScheduleLatestRecordDataContract = _noteRepository.GetAllScheduleLatestDataByNoteId(noteid, userID, AnalysisID, pageIndex, pageSize, out TotalCount);
            return _noteAllScheduleLatestRecordDataContract;
        }

        public int AddUpdateNoteAdditinalList(Guid? userid, NoteAdditinalListDataContract _noteaddlistdc, string CreatedBy, string UpdatedBy)
        {
            return _noteRepository.AddUpdateNoteAdditinalList(userid, _noteaddlistdc, CreatedBy, UpdatedBy);
        }
        public int AddUpdateNoteArchieveAdditinalList(Guid? userid, NoteAdditinalListDataContract _noteaddlistdc, string CreatedBy, string UpdatedBy)
        {
            return _noteRepository.AddUpdateNoteArchieveAdditinalList(userid, _noteaddlistdc, CreatedBy, UpdatedBy);
        }

        public void InsertNotePeriodicCalc(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC)
        {
            _noteRepository.InsertNotePeriodicCalc(_notePeriodicOutputsDC);
        }

        public void InsertCashflowTransaction(List<TransactionEntry> _transactionEntryDC, string noteId, string CreatedBy)
        {
            _noteRepository.InsertCashflowTransaction(_transactionEntryDC, noteId, CreatedBy);
        }

        public void InsertInterestCalculator(List<InterestCalculatorDataContract> ListInterestCalculator, string noteId, string CreatedBy)
        {
            _noteRepository.InsertInterestCalculator(ListInterestCalculator, noteId, CreatedBy);
        }

        public void InsertDailyInterestAccural(List<DailyInterestAccrualsDataContract> ListDailyInterest, string NoteId, string CreatedBy)
        {
            _noteRepository.InsertDailyInterestAccural(ListDailyInterest, NoteId, CreatedBy);
        }

        public void InsertDailyGAAPBasisComponents(List<DailyGAAPBasisComponentsDataContract> ListDailyGaap, string NoteId, string CreatedBy)
        {
            _noteRepository.InsertDailyGAAPBasisComponents(ListDailyGaap, NoteId, CreatedBy);
        }
        public void InsertPeriodicInterestRateUsed(List<PeriodicInterestRateUsed> Listrate, string NoteId, string CreatedBy)
        {
            _noteRepository.InsertPeriodicInterestRateUsed(Listrate, NoteId, CreatedBy);
        }

        public void InsertPIKDistributions(List<PIKDistributionsDataContract> _listPIKDistributionsDC, string CreatedBy)
        {
            _noteRepository.InsertPIKDistributions(_listPIKDistributionsDC, CreatedBy);
        }
        public NoteDataContract GetNoteAllDataForCalculatorByNoteId(string noteid, Guid? UserID, Guid? AnalysisID, int? pageIndex, int? pageSize)
        {
            try
            {
                NoteDataContract _noteDC = new NoteDataContract();

                int? totalCount = 0;
                List<MaturityScenariosDataContract> MaturityScenariosList = new List<MaturityScenariosDataContract>();
                List<RateSpreadSchedule> RateSpreadScheduleList = new List<RateSpreadSchedule>();
                List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleList = new List<PrepayAndAdditionalFeeScheduleDataContract>();
                List<StrippingScheduleDataContract> NoteStrippingList = new List<StrippingScheduleDataContract>();
                List<FinancingScheduleDataContract> NoteFinancingScheduleList = new List<FinancingScheduleDataContract>();
                List<DefaultScheduleDataContract> NoteDefaultScheduleList = new List<DefaultScheduleDataContract>();
                List<EffectiveDateList> EffectiveDateList = new List<EffectiveDateList>();
                List<FutureFundingScheduleTab> ListFutureFundingScheduleTab = new List<FutureFundingScheduleTab>();
                List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTab = new List<PIKfromPIKSourceNoteTab>();
                List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable = new List<FeeCouponStripReceivableTab>();
                List<LiborScheduleTab> ListLiborScheduleTab = new List<LiborScheduleTab>();
                List<FixedAmortScheduleTab> ListFixedAmortScheduleTab = new List<FixedAmortScheduleTab>();
                List<NoteServicingFeeScheduleDataContract> NoteServicingFeeScheduleList = new List<NoteServicingFeeScheduleDataContract>();
                List<FeeFunctionsConfigDataContract> ListFeeFunctionsConfigDataContract = new List<FeeFunctionsConfigDataContract>();
                List<FeeSchedulesConfigDataContract> ListFeeSchedulesConfigDataContract = new List<FeeSchedulesConfigDataContract>();
                List<HistoricalAccrualDataContract> ListPeriodCloseArchiveDataContract = new List<HistoricalAccrualDataContract>();
                List<NoteCommitmentDataContract> ListNoteCommitment = new List<NoteCommitmentDataContract>();



                //get note master data
                NoteDataContract _noteCalculatorDC = new NoteDataContract();
                _noteDC = GetNoteFromNoteId(noteid, UserID, AnalysisID);

                //assign values in _noteCalculatorDC
                _noteCalculatorDC.NoteId = _noteDC.NoteId;
                _noteCalculatorDC.NoteRule = _noteDC.NoteRule;
                _noteCalculatorDC.ID = _noteDC.NoteId;

                _noteCalculatorDC.AccountID = _noteDC.AccountID;
                _noteCalculatorDC.DealID = _noteDC.DealID;
                _noteCalculatorDC.CRENoteID = _noteDC.CRENoteID;
                _noteCalculatorDC.Comments = _noteDC.Comments;
                if (_noteDC.InitialInterestAccrualEndDate != null)
                    _noteCalculatorDC.InitialInterestAccrualEndDate = _noteDC.InitialInterestAccrualEndDate.Value.Date;
                _noteCalculatorDC.AccrualFrequency = _noteDC.AccrualFrequency;
                _noteCalculatorDC.DeterminationDateLeadDays = _noteDC.DeterminationDateLeadDays;
                _noteCalculatorDC.DeterminationDateReferenceDayoftheMonth = _noteDC.DeterminationDateReferenceDayoftheMonth;
                _noteCalculatorDC.DeterminationDateInterestAccrualPeriod = _noteDC.DeterminationDateInterestAccrualPeriod;
                _noteCalculatorDC.DeterminationDateHolidayList = _noteDC.DeterminationDateHolidayList;
                _noteCalculatorDC.DeterminationDateHolidayListText = _noteDC.DeterminationDateHolidayListText;
                if (_noteDC.FirstPaymentDate != null)
                    _noteCalculatorDC.FirstPaymentDate = _noteDC.FirstPaymentDate.Value.Date;
                if (_noteDC.InitialMonthEndPMTDateBiWeekly != null)
                    _noteCalculatorDC.InitialMonthEndPMTDateBiWeekly = _noteDC.InitialMonthEndPMTDateBiWeekly.Value.Date;
                _noteCalculatorDC.PaymentDateBusinessDayLag = _noteDC.PaymentDateBusinessDayLag;
                _noteCalculatorDC.PayFrequency = _noteDC.PayFrequency;
                _noteCalculatorDC.IOTerm = _noteDC.IOTerm;
                _noteCalculatorDC.AmortTerm = _noteDC.AmortTerm;
                _noteCalculatorDC.PIKSeparateCompounding = _noteDC.PIKSeparateCompounding;
                _noteCalculatorDC.MonthlyDSOverridewhenAmortizing = _noteDC.MonthlyDSOverridewhenAmortizing;
                _noteCalculatorDC.AccrualPeriodPaymentDayWhenNotEOMonth = _noteDC.AccrualPeriodPaymentDayWhenNotEOMonth;
                _noteCalculatorDC.FirstPeriodInterestPaymentOverride = _noteDC.FirstPeriodInterestPaymentOverride;
                _noteCalculatorDC.FirstPeriodPrincipalPaymentOverride = _noteDC.FirstPeriodPrincipalPaymentOverride;
                if (_noteDC.FinalInterestAccrualEndDateOverride != null)
                    _noteCalculatorDC.FinalInterestAccrualEndDateOverride = _noteDC.FinalInterestAccrualEndDateOverride.Value.Date;
                _noteCalculatorDC.LoanCurrency = _noteDC.LoanCurrency;
                _noteCalculatorDC.AmortType = _noteDC.AmortType;
                _noteCalculatorDC.RateType = _noteDC.RateType;
                _noteCalculatorDC.ReAmortizeMonthly = _noteDC.ReAmortizeMonthly;
                _noteCalculatorDC.ReAmortizeatPMTReset = _noteDC.ReAmortizeatPMTReset;
                _noteCalculatorDC.StubPaidInArrears = _noteDC.StubPaidInArrears;
                _noteCalculatorDC.RelativePaymentMonth = _noteDC.RelativePaymentMonth;
                _noteCalculatorDC.SettleWithAccrualFlag = _noteDC.SettleWithAccrualFlag;
                _noteCalculatorDC.InterestDueAtMaturity = _noteDC.InterestDueAtMaturity;
                _noteCalculatorDC.RateIndexResetFreq = _noteDC.RateIndexResetFreq;
                if (_noteDC.FirstRateIndexResetDate != null)
                    _noteCalculatorDC.FirstRateIndexResetDate = _noteDC.FirstRateIndexResetDate.Value.Date;
                _noteCalculatorDC.LoanPurchase = _noteDC.LoanPurchase;
                _noteCalculatorDC.LoanPurchaseYNText = _noteDC.LoanPurchaseYNText;
                _noteCalculatorDC.AmortIntCalcDayCount = _noteDC.AmortIntCalcDayCount;
                _noteCalculatorDC.StubPaidinAdvanceYN = _noteDC.StubPaidinAdvanceYN;
                _noteCalculatorDC.FullPeriodInterestDueatMaturity = _noteDC.FullPeriodInterestDueatMaturity;
                _noteCalculatorDC.ProspectiveAccountingMode = _noteDC.ProspectiveAccountingMode;
                _noteCalculatorDC.IsCapitalized = _noteDC.IsCapitalized;
                _noteCalculatorDC.SelectedMaturityDateScenario = _noteDC.SelectedMaturityDateScenario;
                if (_noteDC.SelectedMaturityDate != null)
                    _noteCalculatorDC.SelectedMaturityDate = _noteDC.SelectedMaturityDate.Value.Date;
                if (_noteDC.InitialMaturityDate != null)
                    _noteCalculatorDC.InitialMaturityDate = _noteDC.InitialMaturityDate.Value.Date;
                if (_noteDC.ExpectedMaturityDate != null)
                    _noteCalculatorDC.ExpectedMaturityDate = _noteDC.ExpectedMaturityDate.Value.Date;
                if (_noteDC.FullyExtendedMaturityDate != null)
                    _noteCalculatorDC.FullyExtendedMaturityDate = _noteDC.FullyExtendedMaturityDate.Value.Date;
                if (_noteDC.OpenPrepaymentDate != null)
                    _noteCalculatorDC.OpenPrepaymentDate = _noteDC.OpenPrepaymentDate.Value.Date;
                _noteCalculatorDC.CashflowEngineID = _noteDC.CashflowEngineID;
                _noteCalculatorDC.LoanType = _noteDC.LoanType;
                _noteCalculatorDC.Classification = _noteDC.Classification;
                _noteCalculatorDC.SubClassification = _noteDC.SubClassification;
                _noteCalculatorDC.GAAPDesignation = _noteDC.GAAPDesignation;
                _noteCalculatorDC.PortfolioID = _noteDC.PortfolioID;
                _noteCalculatorDC.GeographicLocation = _noteDC.GeographicLocation;
                _noteCalculatorDC.PropertyType = _noteDC.PropertyType;
                _noteCalculatorDC.RatingAgency = _noteDC.RatingAgency;
                _noteCalculatorDC.RiskRating = _noteDC.RiskRating;
                _noteCalculatorDC.PurchasePrice = _noteDC.PurchasePrice;
                _noteCalculatorDC.FutureFeesUsedforLevelYeild = _noteDC.FutureFeesUsedforLevelYeild;
                _noteCalculatorDC.TotalToBeAmortized = _noteDC.TotalToBeAmortized;
                _noteCalculatorDC.StubPeriodInterest = _noteDC.StubPeriodInterest;
                _noteCalculatorDC.WDPAssetMultiple = _noteDC.WDPAssetMultiple;
                _noteCalculatorDC.WDPEquityMultiple = _noteDC.WDPEquityMultiple;
                _noteCalculatorDC.PurchaseBalance = _noteDC.PurchaseBalance;
                _noteCalculatorDC.DaysofAccrued = _noteDC.DaysofAccrued;
                _noteCalculatorDC.InterestRate = _noteDC.InterestRate;
                _noteCalculatorDC.PurchasedInterestCalc = _noteDC.PurchasedInterestCalc;
                _noteCalculatorDC.ModelFinancingDrawsForFutureFundings = _noteDC.ModelFinancingDrawsForFutureFundings;
                _noteCalculatorDC.NumberOfBusinessDaysLagForFinancingDraw = _noteDC.NumberOfBusinessDaysLagForFinancingDraw;
                _noteCalculatorDC.FinancingFacilityID = _noteDC.FinancingFacilityID;
                if (_noteDC.FinancingInitialMaturityDate != null)
                    _noteCalculatorDC.FinancingInitialMaturityDate = _noteDC.FinancingInitialMaturityDate.Value.Date;
                if (_noteDC.FinancingExtendedMaturityDate != null)
                    _noteCalculatorDC.FinancingExtendedMaturityDate = _noteDC.FinancingExtendedMaturityDate.Value.Date;
                _noteCalculatorDC.FinancingPayFrequency = _noteDC.FinancingPayFrequency;
                _noteCalculatorDC.FinancingInterestPaymentDay = _noteDC.FinancingInterestPaymentDay;
                if (_noteDC.ClosingDate != null)
                    _noteCalculatorDC.ClosingDate = _noteDC.ClosingDate.Value.Date;
                _noteCalculatorDC.InitialFundingAmount = _noteDC.InitialFundingAmount;
                _noteCalculatorDC.InitialIndexValueOverride = _noteDC.InitialIndexValueOverride;
                _noteCalculatorDC.Discount = _noteDC.Discount;
                _noteCalculatorDC.OriginationFee = _noteDC.OriginationFee;
                _noteCalculatorDC.CapitalizedClosingCosts = _noteDC.CapitalizedClosingCosts;
                if (_noteDC.PurchaseDate != null)
                    _noteCalculatorDC.PurchaseDate = _noteDC.PurchaseDate.Value.Date;
                _noteCalculatorDC.PurchaseAccruedFromDate = _noteDC.PurchaseAccruedFromDate;
                _noteCalculatorDC.PurchasedInterestOverride = _noteDC.PurchasedInterestOverride;
                _noteCalculatorDC.OngoingAnnualizedServicingFee = _noteDC.OngoingAnnualizedServicingFee;
                _noteCalculatorDC.DiscountRate = _noteDC.DiscountRate;
                if (_noteDC.ValuationDate != null)
                    _noteCalculatorDC.ValuationDate = _noteDC.ValuationDate.Value.Date;
                _noteCalculatorDC.DiscountRatePlus = _noteDC.DiscountRatePlus;
                _noteCalculatorDC.DiscountRateMinus = _noteDC.DiscountRateMinus;
                _noteCalculatorDC.IncludeServicingPaymentOverrideinLevelYield = _noteDC.IncludeServicingPaymentOverrideinLevelYield;
                _noteCalculatorDC.IncludeServicingPaymentOverrideinLevelYieldText = _noteDC.IncludeServicingPaymentOverrideinLevelYieldText;
                _noteCalculatorDC.CreatedBy = _noteDC.CreatedBy;
                _noteCalculatorDC.CreatedDate = _noteDC.CreatedDate;
                _noteCalculatorDC.UpdatedBy = _noteDC.UpdatedBy;
                _noteCalculatorDC.UpdatedDate = _noteDC.UpdatedDate;
                _noteCalculatorDC.PIKSeparateCompoundingText = _noteDC.PIKSeparateCompoundingText;
                _noteCalculatorDC.StubPaidinAdvanceYNText = _noteDC.StubPaidinAdvanceYNText;
                _noteCalculatorDC.ModelFinancingDrawsForFutureFundingsText = _noteDC.ModelFinancingDrawsForFutureFundingsText;
                _noteCalculatorDC.RoundingMethodText = _noteDC.RoundingMethodText;
                _noteCalculatorDC.RoundingMethod = _noteDC.RoundingMethod;
                _noteCalculatorDC.IndexRoundingRule = _noteDC.IndexRoundingRule;
                _noteCalculatorDC.StubOnFFtext = _noteDC.StubOnFFtext;
                _noteCalculatorDC.StubOnFF = _noteDC.StubOnFF;
                _noteCalculatorDC.StubIntOverride = _noteDC.StubIntOverride;
                _noteCalculatorDC.PurchasedIntOverride = _noteDC.PurchasedIntOverride;
                _noteCalculatorDC.ExitFeeFreePrepayAmt = _noteDC.ExitFeeFreePrepayAmt;
                _noteCalculatorDC.ExitFeeBaseAmountOverride = _noteDC.ExitFeeBaseAmountOverride;
                _noteCalculatorDC.ExitFeeAmortCheck = _noteDC.ExitFeeAmortCheck;
                _noteCalculatorDC.ExitFeeAmortCheckText = _noteDC.ExitFeeAmortCheckText;
                _noteCalculatorDC.FixedAmortSchedule = _noteDC.FixedAmortSchedule;
                _noteCalculatorDC.FixedAmortScheduleText = _noteDC.FixedAmortScheduleText;
                _noteCalculatorDC.ExtendedMaturityCurrent = _noteDC.ExtendedMaturityCurrent;
                _noteCalculatorDC.UnusedFeeThresholdBalance = _noteDC.UnusedFeeThresholdBalance;
                _noteCalculatorDC.UnusedFeePaymentFrequency = Convert.ToInt16(_noteDC.UnusedFeePaymentFrequency);
                _noteCalculatorDC.Servicer = _noteDC.Servicer;
                _noteCalculatorDC.ServicerText = _noteDC.ServicerText;
                _noteCalculatorDC.ActualPayoffDate = _noteDC.ActualPayoffDate;
                _noteCalculatorDC.SelectedMaturityDateScenarioText = _noteDC.SelectedMaturityDateScenarioText;
                _noteCalculatorDC.TotalCommitmentExtensionFeeisBasedOn = _noteDC.TotalCommitmentExtensionFeeisBasedOn;
                _noteCalculatorDC.TotalCommitment = _noteDC.TotalCommitment;
                _noteCalculatorDC.FullInterestAtPPayoffText = _noteDC.FullInterestAtPPayoffText;
                _noteCalculatorDC.FullInterestAtPPayoff = _noteDC.FullInterestAtPPayoff;
                _noteCalculatorDC.AcctgCloseDate = _noteDC.AcctgCloseDate;
                _noteCalculatorDC.CalculationModeText = _noteDC.CalculationModeText;
                _noteCalculatorDC.AnalysisID = _noteDC.AnalysisID;
                _noteCalculatorDC.ServicerNameID = _noteDC.ServicerNameID;
                _noteCalculatorDC.ServicerNameText = _noteDC.ServicerNameText;
                _noteCalculatorDC.BusinessdaylafrelativetoPMTDate = _noteDC.BusinessdaylafrelativetoPMTDate;
                _noteCalculatorDC.DayoftheMonth = _noteDC.DayoftheMonth;
                _noteCalculatorDC.InterestCalculationRuleForPaydowns = _noteDC.InterestCalculationRuleForPaydowns;
                _noteCalculatorDC.InterestCalculationRuleForPaydownsText = _noteDC.InterestCalculationRuleForPaydownsText;
                _noteCalculatorDC.InterestCalculationRuleForPaydownsAmortText = _noteDC.InterestCalculationRuleForPaydownsAmortText;
                _noteCalculatorDC.InterestCalculationRuleForPaydownsAmort = _noteDC.InterestCalculationRuleForPaydownsAmort;
                _noteCalculatorDC.EnableDebug = _noteDC.EnableDebug;
                _noteCalculatorDC.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = _noteDC.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate;
                _noteCalculatorDC.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText = _noteDC.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText;
                _noteCalculatorDC.CollectCalculatorLogs = _noteDC.CollectCalculatorLogs;
                _noteCalculatorDC.AllowYieldConfigData = _noteDC.AllowYieldConfigData;
                _noteCalculatorDC.CalcByNewMaturitySetup = _noteDC.CalcByNewMaturitySetup;
                _noteCalculatorDC.OriginalTotalCommitment = _noteDC.OriginalTotalCommitment;
                //==========================================================================

                ScenarioLogic _sl = new ScenarioLogic();
                _noteDC.DefaultScenarioParameters = _sl.GetActiveScenarioParameters(_noteDC.AnalysisID);
                _noteDC.ListDropDateSetup = GetServicerDropDateSetupByNoteId(new Guid(_noteDC.NoteId), UserID.ToString());

                //case "RateSpreadSchedule": --RateSpreadScheduleList
                RateSpreadScheduleList = GetRateSpreadSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "Maturity": -- MaturityScenariosList
                MaturityScenariosList = GetMaturityPeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "DefaultSchedule": --NoteDefaultScheduleList
                NoteDefaultScheduleList = GetDefaultSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "PrepayAndAdditionalFeeSchedule": NotePrepayAndAdditionalFeeScheduleList
                NotePrepayAndAdditionalFeeScheduleList = GetPrepayAndAdditionalFeeScheduleDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "StrippingSchedule":  --NoteStrippingList
                NoteStrippingList = GetStrippingSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //EffectiveDateList
                EffectiveDateList = GetEffectiveDateListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //-- ListFutureFundingScheduleTab
                ListFutureFundingScheduleTab = GetFutureFundingScheduleTabListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);
                _noteCalculatorDC.ListFutureFundingScheduleTabFromDB = ListFutureFundingScheduleTab;
                //-- ListPIKfromPIKSourceNoteTab
                ListPIKfromPIKSourceNoteTab = GetPIKfromPIKSourceNoteTabListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //--ListFeeCouponStripReceivable -
                ListFeeCouponStripReceivable = GetFeeCouponStripReceivableListDataByNoteId(new Guid(noteid), UserID, AnalysisID, pageIndex, pageSize, out totalCount);
                //vishal
                //ListFeeCouponStripReceivable = GetFeeCouponStripReceivableDataByNoteIdForCalc(new Guid(noteid), UserID, AnalysisID);


                //---ListLiborScheduleTab               
                ListLiborScheduleTab = GetLiborScheduleTabListDataForCalcByNoteId(new Guid(_noteDC.NoteId), Convert.ToInt32(_noteDC.IndexNameID), UserID, _noteDC.AnalysisID, pageIndex, pageSize, out totalCount);


                //NotePIKScheduleList
                _noteCalculatorDC.NotePIKScheduleList = GetPIKSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //ListServicingLogTab               

                _noteCalculatorDC.ListServicingLogTab = GetNoteTransactionDetailByNoteID(_noteDC.NoteId, _noteDC.AnalysisID);
                _noteCalculatorDC.DefaultScenarioParameters = _noteDC.DefaultScenarioParameters;
                //-- ListFixedAmortScheduleTab
                ListFixedAmortScheduleTab = GetFixedAmortScheduleTabListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "ServicingFeeSchedule":  -- NoteServicingFeeScheduleList
                NoteServicingFeeScheduleList = GetServicingFeeSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "FinancingSchedule":  -- NoteFinancingScheduleList
                NoteFinancingScheduleList = GetFinancingSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                ListFutureFundingScheduleTab = ListFutureFundingScheduleTab.Where(s => s.PurposeText != "Amortization").ToList();

                //new 
                ListFeeFunctionsConfigDataContract = GetFeeFunctionsConfig(UserID);
                ListFeeSchedulesConfigDataContract = GetFeeSchedulesConfig(UserID);
                ListPeriodCloseArchiveDataContract = GetAccrualFieldsFromNotePeriodicByNoteID(new Guid(noteid), UserID, _noteDC.AnalysisID);

                ListNoteCommitment = GetNoteCommitmentForCalculatorByNoteID(new Guid(noteid));

                //assign sofr rates to list


                //// List objects /////
                _noteCalculatorDC.RateSpreadScheduleList = RateSpreadScheduleList;
                _noteCalculatorDC.NoteStrippingList = NoteStrippingList;
                _noteCalculatorDC.MaturityScenariosListFromDatabase = MaturityScenariosList;
                _noteCalculatorDC.NoteDefaultScheduleList = NoteDefaultScheduleList;
                _noteCalculatorDC.NotePrepayAndAdditionalFeeScheduleList = NotePrepayAndAdditionalFeeScheduleList;
                _noteCalculatorDC.EffectiveDateList = EffectiveDateList;
                _noteCalculatorDC.ListFutureFundingScheduleTab = ListFutureFundingScheduleTab;
                _noteCalculatorDC.ListPIKfromPIKSourceNoteTab = ListPIKfromPIKSourceNoteTab;
                _noteCalculatorDC.ListFeeCouponStripReceivable = ListFeeCouponStripReceivable;
                _noteCalculatorDC.ListLiborScheduleTab = ListLiborScheduleTab;
                _noteCalculatorDC.ListFixedAmortScheduleTab = ListFixedAmortScheduleTab;
                _noteCalculatorDC.NoteServicingFeeScheduleList = NoteServicingFeeScheduleList;
                _noteCalculatorDC.NoteFinancingScheduleList = NoteFinancingScheduleList;
                _noteCalculatorDC.ListHoliday = GetHolidayListForCalculator();
                _noteCalculatorDC.ListFeeFunctions = ListFeeFunctionsConfigDataContract;
                _noteCalculatorDC.ListFeeSchedulesConfiguration = ListFeeSchedulesConfigDataContract;
                _noteCalculatorDC.ListHistoricalAccrual = ListPeriodCloseArchiveDataContract;
                _noteCalculatorDC.ListNoteCommitment = ListNoteCommitment;

                _noteCalculatorDC = ScenarioRules.AssignValuesToSelectedMaturityUsingDealSetup(_noteCalculatorDC, "");
                //AssignIndexRates
                _noteCalculatorDC.ListLiborScheduleTabFromDB = _noteCalculatorDC.ListLiborScheduleTab;
                _noteCalculatorDC = ScenarioRules.AssignIndexRates(_noteCalculatorDC);

                _noteCalculatorDC = ScenarioRules.ApplyExcludedForcastedPrePaymentRule(_noteCalculatorDC);

                // add new effective dates to effective date list
                var items = _noteCalculatorDC.ListFutureFundingScheduleTab.Select(x => x.EffectiveDate).Distinct().ToList();
                List<EffectiveDateList> effectdatelist = new List<EffectiveDateList>();
                foreach (var item in items)
                {
                    EffectiveDateList res = _noteCalculatorDC.EffectiveDateList.Find(x => x.EffectiveDate.Value.Date == item.Value.Date);
                    if (res == null)
                    {
                        EffectiveDateList edl = new EffectiveDateList();
                        edl.EffectiveDate = item;
                        edl.Type = "FFScheduleTab";
                        _noteCalculatorDC.EffectiveDateList.Add(edl);
                    }
                }

                if (_noteCalculatorDC.RateType == 139)
                {
                    _noteCalculatorDC = ScenarioRules.UpdateRateSpreadSchedule(_noteCalculatorDC);
                }
                _noteCalculatorDC.ListDropDateSetup = _noteDC.ListDropDateSetup;

                AppConfigLogic app = new AppConfigLogic();
                List<AppConfigDataContract> appconfiglist = app.GetAppConfigByKey(UserID, "NumberofDaysin");

                foreach (AppConfigDataContract app1 in appconfiglist)
                {
                    if (app1.Key.ToLower() == "NumberofDaysinPast".ToLower())
                    {
                        _noteCalculatorDC.NumberofDaysinPast = Convert.ToInt32(app1.Value);
                    }
                    if (app1.Key.ToLower() == "NumberofDaysinFuture".ToLower())
                    {
                        _noteCalculatorDC.NumberofDaysinFuture = Convert.ToInt32(app1.Value);
                    }
                }

                _noteCalculatorDC = ScenarioRules.GetAccoutingCLoseDate(_noteCalculatorDC);
                return _noteCalculatorDC;
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNotesFromDealDetailByDealID: Note ID " + noteid, noteid, UserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
                throw ex;
            }
        }

        public void ExecDataTablewithtable(NoteDataContract _noteDC, string procedureName)
        {
            DataTable ret_dt = new DataTable();
            Helper hp = new Helper();

            DataTable noteaddilist = new DataTable();

            noteaddilist.Columns.Add("NoteId");
            noteaddilist.Columns.Add("EffectiveDate");
            noteaddilist.Columns.Add("Date");
            noteaddilist.Columns.Add("SelectedMaturityDate");
            noteaddilist.Columns.Add("EndDate");
            noteaddilist.Columns.Add("ValueTypeID");
            noteaddilist.Columns.Add("Value");
            noteaddilist.Columns.Add("IntCalcMethodID");
            noteaddilist.Columns.Add("IncludedLevelYield");
            noteaddilist.Columns.Add("IncludedBasis");
            noteaddilist.Columns.Add("MaxFeeAmt");
            noteaddilist.Columns.Add("IndexTypeID");
            noteaddilist.Columns.Add("CurrencyCode");
            noteaddilist.Columns.Add("IsCapitalized");
            noteaddilist.Columns.Add("SourceAccountID");
            noteaddilist.Columns.Add("SourceAccountText");
            noteaddilist.Columns.Add("TargetAccountID");
            noteaddilist.Columns.Add("TargetAccountText");
            noteaddilist.Columns.Add("AdditionalIntRate");
            noteaddilist.Columns.Add("AdditionalSpread");
            noteaddilist.Columns.Add("IndexFloor");
            noteaddilist.Columns.Add("IntCompoundingRate");
            noteaddilist.Columns.Add("IntCompoundingSpread");
            noteaddilist.Columns.Add("StartDate");
            noteaddilist.Columns.Add("ScheduleStartDate");
            noteaddilist.Columns.Add("IntCapAmt");
            noteaddilist.Columns.Add("PurBal");
            noteaddilist.Columns.Add("AccCapBal");
            noteaddilist.Columns.Add("ValueTypeText");
            noteaddilist.Columns.Add("IntCalcMethodText");
            noteaddilist.Columns.Add("CurrencyCodeText");
            noteaddilist.Columns.Add("IndexTypeText");
            noteaddilist.Columns.Add("IsCapitalizedText");
            noteaddilist.Columns.Add("ModuleId");
            noteaddilist.Columns.Add("CreatedBy");
            noteaddilist.Columns.Add("CreatedDate");
            noteaddilist.Columns.Add("UpdatedBy");
            noteaddilist.Columns.Add("UpdatedDate");

            noteaddilist.Columns.Add("PIKReasonCodeID");
            noteaddilist.Columns.Add("PIKComments");
            noteaddilist.Columns.Add("PIKIntCalcMethodID");

            DataTable dt = new DataTable();

            //Rate spread schedule
            if (_noteDC.RateSpreadScheduleList != null)
            {
                foreach (var item in _noteDC.RateSpreadScheduleList)
                {
                    item.ModuleId = 14;
                }
                dt = hp.ToDataTable(_noteDC.RateSpreadScheduleList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================
            //Maturity
            if (_noteDC.MaturityScenariosList != null)
            {
                foreach (var item in _noteDC.MaturityScenariosList)
                {
                    item.ModuleId = 11;
                }
                dt = hp.ToDataTable(_noteDC.MaturityScenariosList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //PrepayAndAdditionalFeeScheduleList
            if (_noteDC.NotePrepayAndAdditionalFeeScheduleList != null)
            {
                foreach (var item in _noteDC.NotePrepayAndAdditionalFeeScheduleList)
                {
                    item.ModuleId = 13;
                }
                dt = hp.ToDataTable(_noteDC.NotePrepayAndAdditionalFeeScheduleList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //StrippingList
            if (_noteDC.NoteStrippingList != null)
            {
                foreach (var item in _noteDC.NoteStrippingList)
                {
                    item.ModuleId = 16;
                }
                dt = hp.ToDataTable(_noteDC.NoteStrippingList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //Financing Fee Schedule
            if (_noteDC.NoteServicingFeeScheduleList != null)
            {
                foreach (var item in _noteDC.NoteServicingFeeScheduleList)
                {
                    item.ModuleId = 8;
                }
                dt = hp.ToDataTable(_noteDC.NoteServicingFeeScheduleList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //Financing Schedule
            if (_noteDC.NoteFinancingScheduleList != null)
            {
                foreach (var item in _noteDC.NoteFinancingScheduleList)
                {
                    item.ModuleId = 9;
                }
                dt = hp.ToDataTable(_noteDC.NoteFinancingScheduleList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //PIK Schedule
            if (_noteDC.NotePIKScheduleList != null)
            {
                foreach (var item in _noteDC.NotePIKScheduleList)
                {
                    item.ModuleId = 12;
                }
                dt = hp.ToDataTable(_noteDC.NotePIKScheduleList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //Default Schedule
            if (_noteDC.NoteDefaultScheduleList != null)
            {
                foreach (var item in _noteDC.NoteDefaultScheduleList)
                {
                    item.ModuleId = 6;
                }
                dt = hp.ToDataTable(_noteDC.NoteDefaultScheduleList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //ServicingOneTimeFeesTableList
            if (_noteDC.ServicingOneTimeFeesTableList != null)
            {
                foreach (var item in _noteDC.ServicingOneTimeFeesTableList)
                {
                    item.ModuleId = 15;
                }
                dt = hp.ToDataTable(_noteDC.ServicingOneTimeFeesTableList);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //ListFutureFundingScheduleTab
            if (_noteDC.ListFutureFundingScheduleTab != null)
            {
                foreach (var item in _noteDC.ListFutureFundingScheduleTab)
                {
                    item.ModuleId = 10;
                }
                dt = hp.ToDataTable(_noteDC.ListFutureFundingScheduleTab);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //ListPIKfromPIKSourceNoteTab
            if (_noteDC.ListPIKfromPIKSourceNoteTab != null)
            {
                foreach (var item in _noteDC.ListPIKfromPIKSourceNoteTab)
                {
                    item.ModuleId = 17;
                }
                dt = hp.ToDataTable(_noteDC.ListPIKfromPIKSourceNoteTab);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //ListLiborScheduleTab
            if (_noteDC.ListLiborScheduleTab != null)
            {
                foreach (var item in _noteDC.ListLiborScheduleTab)
                {
                    item.ModuleId = 18;
                }
                dt = hp.ToDataTable(_noteDC.ListLiborScheduleTab);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //ListFixedAmortScheduleTab
            if (_noteDC.ListFixedAmortScheduleTab != null)
            {
                foreach (var item in _noteDC.ListFixedAmortScheduleTab)
                {
                    item.ModuleId = 19;
                }
                dt = hp.ToDataTable(_noteDC.ListFixedAmortScheduleTab);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            //ListFeeCouponStripReceivable
            if (_noteDC.ListFeeCouponStripReceivable != null)
            {
                foreach (var item in _noteDC.ListFeeCouponStripReceivable)
                {
                    item.ModuleId = 20;
                }
                dt = hp.ToDataTable(_noteDC.ListFeeCouponStripReceivable);

                foreach (DataRow dr in dt.Rows)
                {
                    noteaddilist.ImportRow(dr);
                }
            }
            //==============================

            if (noteaddilist.Rows.Count > 0)
            {
                for (int i = 0; i < noteaddilist.Rows.Count; i++)
                {
                    noteaddilist.Rows[i]["NoteId"] = _noteDC.NoteId;
                }
            }

            if (noteaddilist.Rows.Count > 0)
            {
                string CreatedBy = _noteDC.CreatedBy;
                string UpdatedBy = _noteDC.UpdatedBy;

                hp.ExecDataTablewithtable(procedureName, noteaddilist, CreatedBy, UpdatedBy);
            }
        }

        public string AddUpdateNoteFromCalculatorService(Guid? userid, List<NoteDataContract> noteDC)
        {
            string noteValue;
            noteValue = _noteRepository.AddUpdateNoteFromCalculatorService(userid, noteDC);
            return noteValue;
        }

        public void InsertNoteFutureFunding(List<PayruleTargetNoteFundingScheduleDataContract> NoteFundings, string username)
        {
            _noteRepository.InsertNoteFutureFunding(NoteFundings, username);

        }

        public string ExportFutureFundingFromCRES(List<PayruleTargetNoteFundingScheduleDataContract> NoteFundings, string username)
        {
            string status = _noteRepository.ExportFutureFundingFromCRES(NoteFundings, username);

            return status;
        }
        public string ExportFutureFundingFromNote(List<FutureFundingScheduleTab> NoteFundings, string username)
        {
            string status = _noteRepository.ExportFutureFundingFromNote(NoteFundings, username);

            return status;
        }

        public string GetOrCreateNoteByCRENoteId(string CRENoteID, Guid? DealID, string username)
        {
            string NoteID = _noteRepository.GetOrCreateNoteByCRENoteId(CRENoteID, DealID, username);
            return NoteID;
        }

        public List<NotePeriodicOutputsDataContract> GetNotePeriodicCalcByNoteId(Guid? noteid, Guid? AnalysisID)
        {
            List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDataContractList = new List<NotePeriodicOutputsDataContract>();
            _notePeriodicOutputsDataContractList = _noteRepository.GetNotePeriodicCalcByNoteId(noteid, AnalysisID);
            return _notePeriodicOutputsDataContractList;
        }


        public DataTable GetNotePeriodicCalcDynamicByNoteId(Guid? noteid)
        {
            DataTable _notePeriodicOutputsDataContractList = new DataTable();
            _notePeriodicOutputsDataContractList = _noteRepository.GetNotePeriodicCalcDynamicByNoteId(noteid);
            return _notePeriodicOutputsDataContractList;
        }

        public bool CheckDuplicateNote(NoteDataContract _noteDC)
        {
            bool isexist = false;
            isexist = _noteRepository.CheckDuplicateNote(_noteDC);
            return isexist;
        }

        public List<LiborScheduleTab> GetLiborScheduleTabListDataForCalcByNoteId(Guid? noteid, int IndexNameID, Guid? userID, Guid? AnalysisID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<LiborScheduleTab> _liborScheduleTabList = new List<LiborScheduleTab>();
            _liborScheduleTabList = _noteRepository.GetLiborScheduleTabListDataForCalcByNoteId(noteid, IndexNameID, userID, AnalysisID, pageIndex, pageSize, out TotalCount);
            return _liborScheduleTabList;
        }

        public void insertCalcLog(string Msg1, string Msg2, string Msg3, string Msg4, string Msg5, string Msg6, string Msg7, string Msg8, string Msg9, string Msg10)
        {
            Helper hp = new Helper();
            hp.ExecNonqueryForCalcLog("app.usp_InsertCalcLog", Msg1, Msg2, Msg3, Msg4, Msg5, Msg6, Msg7, Msg8, Msg9, Msg10);
        }

        public void importsourcetodw()
        {
            _noteRepository.importsourcetodw();
        }

        public void refreshentitydatatodw()
        {
            _noteRepository.refreshentitydatatodw();
        }

        public void GetExecuteProcedureNightly(int? isButtonClick)
        {
            _noteRepository.GetExecuteProcedureNightly(isButtonClick);
        }

        public void ExecuteProcedureOnesInADay()
        {
            _noteRepository.ExecuteProcedureOnesInADay();
        }

        /*
        public List<NoteCashflowsExportDataContract> GetNoteCashflowsExportData(Guid? noteid, Guid? dealid)
        {
            ObjectResult<usp_GetNoteCashflows_Result> _noteCashflowsExportDataContractList = new List<NoteCashflowsExportDataContract>();
            _noteCashflowsExportDataContractList = _noteRepository.GetNoteCashflowsExportData(noteid, dealid);
            return _noteCashflowsExportDataContractList;
        }
        */
        public DataTable GetNoteCashflowsExportData(Guid? noteid, Guid? dealid, Guid? AnalysisID, string MutipleNote)
        {
            DataTable _noteCashflowsExportDataContractList = new DataTable();
            _noteCashflowsExportDataContractList = _noteRepository.GetNoteCashflowsExportData(noteid, dealid, AnalysisID, MutipleNote);
            return _noteCashflowsExportDataContractList;
        }
        public DataTable GetNoteCashflowsExportData(DownloadCashFlowDataContract downloadCashFlow)
        {
            DataTable _noteCashflowsExportDataContractList = new DataTable();
            _noteCashflowsExportDataContractList = _noteRepository.GetNoteCashflowsExportData(downloadCashFlow);
            return _noteCashflowsExportDataContractList;
        }

        public DataTable DownloadNoteDataTape(int withoutSpread)
        {
            DataTable _DownloadNoteDataTapeList = new DataTable();
            _DownloadNoteDataTapeList = _noteRepository.DownloadNoteDataTape(withoutSpread);
            return _DownloadNoteDataTapeList;
        }

        public List<ServicingLogTab> GetNoteTransactionDetailByNoteID(string NoteID, Guid? Analysisid)
        {
            return _noteRepository.GetNoteTransactionDetailByNoteID(NoteID, Analysisid);
        }


        public void InsertNoteTransactionDetail(List<ServicingLogTab> _lstCalcValDC, string NoteId, string CreatedBy)
        {
            _noteRepository.InsertNoteTransactionDetail(_lstCalcValDC, NoteId, CreatedBy);
        }


        public void InsertNotePeriodicCalcFromCalculationManger(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {

            _noteRepository.InsertNotePeriodicCalcFromCalculationManger(_notePeriodicOutputsDC, username, noteid);
        }


        public void InsertNotePeriodicCalcFromCalculationDaily(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            _noteRepository.InsertNotePeriodicCalcFromCalculationDaily(_notePeriodicOutputsDC, username, noteid);
        }

        public void InsertNotePeriodicCalcFromCalculationPVandGaap(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            _noteRepository.InsertNotePeriodicCalcFromCalculationPVandGaap(_notePeriodicOutputsDC, username, noteid);
        }

        public void InsertNotePeriodicCalcFromCalculationSpreadLibor(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            _noteRepository.InsertNotePeriodicCalcFromCalculationSpreadLibor(_notePeriodicOutputsDC, username, noteid);
        }




        public List<PayruleNoteDetailFundingDataContract> GetNotesForPayruleCalculationByDealID(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)

        {
            return _noteRepository.GetNotesForPayruleCalculationByDealID(dealID, userID, pgeIndex, pageSize, out TotalCount);
        }

        public List<NoteDataContract> SearchNoteByCRENoteId(NoteDataContract _noteDC)
        {
            return _noteRepository.SearchNoteByCRENoteId(_noteDC);
        }

        public List<ActivityLogDataContract> GetActivityLogByModuleId(string userID, ActivityLogDataContract _activityDC, int? pageIndx, int? pageSize, out int? TotalCount)
        {
            return _noteRepository.GetActivityLogByModuleId(userID, _activityDC, pageIndx, pageSize, out TotalCount);
        }
        public List<HolidayListDataContract> GetHolidayList()
        {
            return _noteRepository.GetHolidayList();

        }
        public List<HolidayListDataContract> GetHolidayListForCalculator()
        {
            return _noteRepository.GetHolidayListForCalculator();
        }

        public NoteAllScheduleLatestRecordDataContract GetLastUpdatedDateAndUpdatedByForSchedule(Guid? noteid, string ModuleName)
        {
            return _noteRepository.GetLastUpdatedDateAndUpdatedByForSchedule(noteid, ModuleName);
        }

        public void AddUpdateNoteRuleByNoteId(NoteDataContract _noteDC, Guid? UserID)
        {
            _noteRepository.AddUpdateNoteRuleByNoteId(_noteDC, UserID);
        }

        public List<ClientDataContract> GetAllClient()
        {
            List<ClientDataContract> _clientDataContractList = new List<ClientDataContract>();
            _clientDataContractList = _noteRepository.GetAllClients();
            return _clientDataContractList;
        }

        public List<FundDataContract> GetAllFund()
        {
            List<FundDataContract> _fundDataContractList = new List<FundDataContract>();
            _fundDataContractList = _noteRepository.GetAllFund();
            return _fundDataContractList;
        }

        public FNoteDataContract GetNoteDataForCalculationByNoteId(string noteid, Guid? UserID, int? pageIndex, int? pageSize)
        {
            try
            {
                NoteDataContract _noteDC = new NoteDataContract();

                int? totalCount = 0;
                List<MaturityScenariosDataContract> MaturityScenariosList = new List<MaturityScenariosDataContract>();
                List<RateSpreadSchedule> RateSpreadScheduleList = new List<RateSpreadSchedule>();
                List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleList = new List<PrepayAndAdditionalFeeScheduleDataContract>();
                List<StrippingScheduleDataContract> NoteStripping = new List<StrippingScheduleDataContract>();
                List<FStrippingScheduleDataContract> NoteStrippingList = new List<FStrippingScheduleDataContract>();
                List<FinancingScheduleDataContract> NoteFinancingScheduleList = new List<FinancingScheduleDataContract>();
                List<DefaultScheduleDataContract> NoteDefaultScheduleList = new List<DefaultScheduleDataContract>();
                List<EffectiveDateList> EffectiveDateList = new List<EffectiveDateList>();
                List<FFutureFundingScheduleTab> ListFutureFundingScheduleTab = new List<FFutureFundingScheduleTab>();
                List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTab = new List<PIKfromPIKSourceNoteTab>();
                List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable = new List<FeeCouponStripReceivableTab>();
                //List<LiborScheduleTab> ListLiborScheduleTab = new List<LiborScheduleTab>();
                List<FixedAmortScheduleTab> ListFixedAmortScheduleTab = new List<FixedAmortScheduleTab>();
                List<NoteServicingFeeScheduleDataContract> NoteServicingFeeScheduleList = new List<NoteServicingFeeScheduleDataContract>();

                //get note master data
                FNoteDataContract _noteCalculatorDC = new FNoteDataContract();
                _noteDC = GetNoteFromNoteId(noteid, UserID, _noteDC.AnalysisID);

                //assign values in _noteCalculatorDC
                _noteCalculatorDC.NoteId = _noteDC.NoteId;
                _noteCalculatorDC.NoteRule = _noteDC.NoteRule;
                _noteCalculatorDC.ID = _noteDC.NoteId;

                _noteCalculatorDC.AccountID = _noteDC.AccountID;

                _noteCalculatorDC.CRENoteID = _noteDC.CRENoteID;

                if (_noteDC.InitialInterestAccrualEndDate != null)
                    _noteCalculatorDC.InitialInterestAccrualEndDate = _noteDC.InitialInterestAccrualEndDate.Value.Date;
                _noteCalculatorDC.AccrualFrequency = _noteDC.AccrualFrequency;
                _noteCalculatorDC.DeterminationDateLeadDays = _noteDC.DeterminationDateLeadDays;
                _noteCalculatorDC.DeterminationDateReferenceDayoftheMonth = _noteDC.DeterminationDateReferenceDayoftheMonth;
                _noteCalculatorDC.DeterminationDateInterestAccrualPeriod = _noteDC.DeterminationDateInterestAccrualPeriod;
                _noteCalculatorDC.DeterminationDateHolidayList = _noteDC.DeterminationDateHolidayList;
                _noteCalculatorDC.DeterminationDateHolidayList = _noteDC.DeterminationDateHolidayList;
                if (_noteDC.FirstPaymentDate != null)
                    _noteCalculatorDC.FirstPaymentDate = _noteDC.FirstPaymentDate.Value.Date;
                if (_noteDC.InitialMonthEndPMTDateBiWeekly != null)
                    _noteCalculatorDC.InitialMonthEndPMTDateBiWeekly = _noteDC.InitialMonthEndPMTDateBiWeekly.Value.Date;
                _noteCalculatorDC.PaymentDateBusinessDayLag = _noteDC.PaymentDateBusinessDayLag;
                _noteCalculatorDC.PayFrequency = _noteDC.PayFrequency;
                _noteCalculatorDC.IOTerm = _noteDC.IOTerm;
                _noteCalculatorDC.AmortTerm = _noteDC.AmortTerm;
                _noteCalculatorDC.PIKSeparateCompounding = _noteDC.PIKSeparateCompounding;
                _noteCalculatorDC.MonthlyDSOverridewhenAmortizing = _noteDC.MonthlyDSOverridewhenAmortizing;
                _noteCalculatorDC.AccrualPeriodPaymentDayWhenNotEOMonth = _noteDC.AccrualPeriodPaymentDayWhenNotEOMonth;
                _noteCalculatorDC.FirstPeriodInterestPaymentOverride = _noteDC.FirstPeriodInterestPaymentOverride;
                _noteCalculatorDC.FirstPeriodPrincipalPaymentOverride = _noteDC.FirstPeriodPrincipalPaymentOverride;
                if (_noteDC.FinalInterestAccrualEndDateOverride != null)
                    _noteCalculatorDC.FinalInterestAccrualEndDateOverride = _noteDC.FinalInterestAccrualEndDateOverride.Value.Date;
                _noteCalculatorDC.LoanCurrency = _noteDC.LoanCurrency;

                _noteCalculatorDC.InterestDueAtMaturity = _noteDC.InterestDueAtMaturity;
                _noteCalculatorDC.RateIndexResetFreq = _noteDC.RateIndexResetFreq;
                if (_noteDC.FirstRateIndexResetDate != null)
                    _noteCalculatorDC.FirstRateIndexResetDate = _noteDC.FirstRateIndexResetDate.Value.Date;
                _noteCalculatorDC.LoanPurchase = _noteDC.LoanPurchase;
                _noteCalculatorDC.LoanPurchaseYNText = _noteDC.LoanPurchaseYNText;
                _noteCalculatorDC.AmortIntCalcDayCount = _noteDC.AmortIntCalcDayCount;
                _noteCalculatorDC.StubPaidinAdvanceYN = _noteDC.StubPaidinAdvanceYN;
                _noteCalculatorDC.FullPeriodInterestDueatMaturity = _noteDC.FullPeriodInterestDueatMaturity;

                _noteCalculatorDC.IsCapitalized = _noteDC.IsCapitalized;
                _noteCalculatorDC.SelectedMaturityDateScenario = _noteDC.SelectedMaturityDateScenario;
                if (_noteDC.SelectedMaturityDate != null)
                    _noteCalculatorDC.SelectedMaturityDate = _noteDC.SelectedMaturityDate.Value.Date;
                if (_noteDC.InitialMaturityDate != null)
                    _noteCalculatorDC.InitialMaturityDate = _noteDC.InitialMaturityDate.Value.Date;
                if (_noteDC.ExpectedMaturityDate != null)
                    _noteCalculatorDC.ExpectedMaturityDate = _noteDC.ExpectedMaturityDate.Value.Date;
                if (_noteDC.FullyExtendedMaturityDate != null)
                    _noteCalculatorDC.FullyExtendedMaturityDate = _noteDC.FullyExtendedMaturityDate.Value.Date;
                if (_noteDC.OpenPrepaymentDate != null)
                    _noteCalculatorDC.OpenPrepaymentDate = _noteDC.OpenPrepaymentDate.Value.Date;

                _noteCalculatorDC.TotalToBeAmortized = _noteDC.TotalToBeAmortized;
                _noteCalculatorDC.StubPeriodInterest = _noteDC.StubPeriodInterest;

                _noteCalculatorDC.PurchaseBalance = _noteDC.PurchaseBalance;
                _noteCalculatorDC.DaysofAccrued = _noteDC.DaysofAccrued;
                _noteCalculatorDC.InterestRate = _noteDC.InterestRate;
                _noteCalculatorDC.PurchasedInterestCalc = _noteDC.PurchasedInterestCalc;
                _noteCalculatorDC.ModelFinancingDrawsForFutureFundings = _noteDC.ModelFinancingDrawsForFutureFundings;
                _noteCalculatorDC.NumberOfBusinessDaysLagForFinancingDraw = _noteDC.NumberOfBusinessDaysLagForFinancingDraw;
                _noteCalculatorDC.FinancingFacilityID = _noteDC.FinancingFacilityID;
                if (_noteDC.FinancingInitialMaturityDate != null)
                    _noteCalculatorDC.FinancingInitialMaturityDate = _noteDC.FinancingInitialMaturityDate.Value.Date;
                if (_noteDC.FinancingExtendedMaturityDate != null)
                    _noteCalculatorDC.FinancingExtendedMaturityDate = _noteDC.FinancingExtendedMaturityDate.Value.Date;
                _noteCalculatorDC.FinancingPayFrequency = _noteDC.FinancingPayFrequency;
                _noteCalculatorDC.FinancingInterestPaymentDay = _noteDC.FinancingInterestPaymentDay;
                if (_noteDC.ClosingDate != null)
                    _noteCalculatorDC.ClosingDate = _noteDC.ClosingDate.Value.Date;
                _noteCalculatorDC.InitialFundingAmount = _noteDC.InitialFundingAmount;
                _noteCalculatorDC.InitialIndexValueOverride = _noteDC.InitialIndexValueOverride;
                _noteCalculatorDC.Discount = _noteDC.Discount;
                _noteCalculatorDC.OriginationFee = _noteDC.OriginationFee;
                _noteCalculatorDC.CapitalizedClosingCosts = _noteDC.CapitalizedClosingCosts;
                if (_noteDC.PurchaseDate != null)
                    _noteCalculatorDC.PurchaseDate = _noteDC.PurchaseDate.Value.Date;
                _noteCalculatorDC.PurchaseAccruedFromDate = _noteDC.PurchaseAccruedFromDate;
                _noteCalculatorDC.PurchasedInterestOverride = _noteDC.PurchasedInterestOverride;
                _noteCalculatorDC.OngoingAnnualizedServicingFee = _noteDC.OngoingAnnualizedServicingFee;
                _noteCalculatorDC.DiscountRate = _noteDC.DiscountRate;
                if (_noteDC.ValuationDate != null)
                    _noteCalculatorDC.ValuationDate = _noteDC.ValuationDate.Value.Date;
                _noteCalculatorDC.DiscountRatePlus = _noteDC.DiscountRatePlus;
                _noteCalculatorDC.DiscountRateMinus = _noteDC.DiscountRateMinus;
                _noteCalculatorDC.IncludeServicingPaymentOverrideinLevelYield = _noteDC.IncludeServicingPaymentOverrideinLevelYield;
                _noteCalculatorDC.IncludeServicingPaymentOverrideinLevelYieldText = _noteDC.IncludeServicingPaymentOverrideinLevelYieldText;

                _noteCalculatorDC.PIKSeparateCompoundingText = _noteDC.PIKSeparateCompoundingText;
                _noteCalculatorDC.StubPaidinAdvanceYNText = _noteDC.StubPaidinAdvanceYNText;
                _noteCalculatorDC.ModelFinancingDrawsForFutureFundingsText = _noteDC.ModelFinancingDrawsForFutureFundingsText;
                _noteCalculatorDC.RoundingMethodText = _noteDC.RoundingMethodText;
                _noteCalculatorDC.RoundingMethod = _noteDC.RoundingMethod;
                _noteCalculatorDC.IndexRoundingRule = _noteDC.IndexRoundingRule;
                _noteCalculatorDC.StubOnFFtext = _noteDC.StubOnFFtext;
                _noteCalculatorDC.StubOnFF = _noteDC.StubOnFF;
                _noteCalculatorDC.StubIntOverride = _noteDC.StubIntOverride;
                _noteCalculatorDC.PurchasedIntOverride = _noteDC.PurchasedIntOverride;
                _noteCalculatorDC.ExitFeeFreePrepayAmt = _noteDC.ExitFeeFreePrepayAmt;
                _noteCalculatorDC.ExitFeeBaseAmountOverride = _noteDC.ExitFeeBaseAmountOverride;
                _noteCalculatorDC.ExitFeeAmortCheck = _noteDC.ExitFeeAmortCheck;
                _noteCalculatorDC.ExitFeeAmortCheckText = _noteDC.ExitFeeAmortCheckText;
                _noteCalculatorDC.FixedAmortSchedule = _noteDC.FixedAmortSchedule;
                _noteCalculatorDC.FixedAmortScheduleText = _noteDC.FixedAmortScheduleText;


                //_noteCalculatorDC.ExtendedMaturityScenario1 = _noteDC.ExtendedMaturityScenario1;
                //_noteCalculatorDC.ExtendedMaturityScenario2 = _noteDC.ExtendedMaturityScenario2;
                //_noteCalculatorDC.ExtendedMaturityScenario3 = _noteDC.ExtendedMaturityScenario3;
                _noteCalculatorDC.UnusedFeeThresholdBalance = _noteDC.UnusedFeeThresholdBalance;
                _noteCalculatorDC.UnusedFeePaymentFrequency = Convert.ToInt16(_noteDC.UnusedFeePaymentFrequency);

                _noteCalculatorDC.ActualPayoffDate = _noteDC.ActualPayoffDate;
                _noteCalculatorDC.SelectedMaturityDateScenarioText = _noteDC.SelectedMaturityDateScenarioText;
                _noteCalculatorDC.TotalCommitmentExtensionFeeisBasedOn = _noteDC.TotalCommitmentExtensionFeeisBasedOn;
                _noteCalculatorDC.TotalCommitment = _noteDC.TotalCommitment;
                _noteCalculatorDC.FullInterestAtPPayoffText = _noteDC.FullInterestAtPPayoffText;
                _noteCalculatorDC.FullInterestAtPPayoff = _noteDC.FullInterestAtPPayoff;
                _noteCalculatorDC.MaturityScenarioOverrideText = _noteDC.MaturityScenarioOverrideText;

                //==========================================================================
                ScenarioLogic _sl = new ScenarioLogic();
                _noteDC.DefaultScenarioParameters = _sl.GetActiveScenarioParameters(_noteDC.AnalysisID);
                //case "RateSpreadSchedule": --RateSpreadScheduleList
                RateSpreadScheduleList = GetRateSpreadSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "Maturity": -- MaturityScenariosList
                MaturityScenariosList = GetMaturityPeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "DefaultSchedule": --NoteDefaultScheduleList
                NoteDefaultScheduleList = GetDefaultSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "PrepayAndAdditionalFeeSchedule": NotePrepayAndAdditionalFeeScheduleList
                NotePrepayAndAdditionalFeeScheduleList = GetPrepayAndAdditionalFeeScheduleDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "StrippingSchedule":  --NoteStrippingList
                NoteStripping = GetStrippingSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                foreach (StrippingScheduleDataContract item in NoteStripping)
                {
                    FStrippingScheduleDataContract fssd = new FStrippingScheduleDataContract();
                    fssd.EffectiveDate = item.EffectiveDate;
                    fssd.Date = item.StartDate;
                    fssd.Value = item.Value;
                    fssd.ValueTypeText = item.ValueTypeText;
                    fssd.IncludedLevelYield = item.IncludedLevelYield;
                    fssd.IncludedBasis = item.IncludedBasis;
                    NoteStrippingList.Add(fssd);
                }
                //EffectiveDateList
                EffectiveDateList = GetEffectiveDateListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //-- ListFutureFundingScheduleTab
                ListFutureFundingScheduleTab = GetInputFutureFundingScheduleListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //-- ListPIKfromPIKSourceNoteTab
                ListPIKfromPIKSourceNoteTab = GetPIKfromPIKSourceNoteTabListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //--ListFeeCouponStripReceivable -
                ListFeeCouponStripReceivable = GetFeeCouponStripReceivableListDataByNoteId(new Guid(noteid), UserID, _noteDC.AnalysisID, pageIndex, pageSize, out totalCount);
                //vishal
                // ListFeeCouponStripReceivable = GetFeeCouponStripReceivableDataByNoteIdForCalc(new Guid(noteid), UserID, _noteDC.AnalysisID);



                //---ListLiborScheduleTab               
                // ListLiborScheduleTab = GetLiborScheduleTabListDataForCalcByNoteId(new Guid(_noteDC.NoteId), Convert.ToInt32(_noteDC.IndexNameID), UserID, pageIndex, pageSize, out totalCount);

                //NotePIKScheduleList
                _noteCalculatorDC.NotePIKScheduleList = GetPIKSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);
                //ListServicingLogTab
                _noteCalculatorDC.ListServicingLogTab = GetNoteTransactionDetailByNoteID(_noteDC.NoteId, _noteDC.AnalysisID);

                _noteCalculatorDC.DefaultScenarioParameters = _noteDC.DefaultScenarioParameters;

                //-- ListFixedAmortScheduleTab
                ListFixedAmortScheduleTab = GetFixedAmortScheduleTabListDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "ServicingFeeSchedule":  -- NoteServicingFeeScheduleList
                NoteServicingFeeScheduleList = GetServicingFeeSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                //case "FinancingSchedule":  -- NoteFinancingScheduleList
                NoteFinancingScheduleList = GetFinancingSchedulePeriodicDataByNoteId(new Guid(noteid), UserID, pageIndex, pageSize, out totalCount);

                ListFutureFundingScheduleTab = ListFutureFundingScheduleTab.Where(s => s.PurposeText != "Amortization").ToList();
                //// List objects /////
                _noteCalculatorDC.RateSpreadScheduleList = RateSpreadScheduleList;
                _noteCalculatorDC.NoteStrippingList = NoteStrippingList;
                _noteCalculatorDC.MaturityScenariosList = MaturityScenariosList;
                _noteCalculatorDC.NoteDefaultScheduleList = NoteDefaultScheduleList;
                _noteCalculatorDC.NotePrepayAndAdditionalFeeScheduleList = NotePrepayAndAdditionalFeeScheduleList;
                _noteCalculatorDC.EffectiveDateList = EffectiveDateList;
                _noteCalculatorDC.ListFutureFundingScheduleTab = ListFutureFundingScheduleTab;
                _noteCalculatorDC.ListPIKfromPIKSourceNoteTab = ListPIKfromPIKSourceNoteTab;
                _noteCalculatorDC.ListFeeCouponStripReceivable = ListFeeCouponStripReceivable;
                //  _noteCalculatorDC.ListLiborScheduleTab = ListLiborScheduleTab;
                _noteCalculatorDC.ListFixedAmortScheduleTab = ListFixedAmortScheduleTab;
                _noteCalculatorDC.NoteServicingFeeScheduleList = NoteServicingFeeScheduleList;
                _noteCalculatorDC.NoteFinancingScheduleList = NoteFinancingScheduleList;


                AppConfigLogic app = new AppConfigLogic();
                List<AppConfigDataContract> appconfiglist = app.GetAppConfigByKey(UserID, "NumberofDaysin");

                foreach (AppConfigDataContract app1 in appconfiglist)
                {
                    if (app1.Key.ToLower() == "NumberofDaysinPast".ToLower())
                    {
                        _noteCalculatorDC.NumberofDaysinPast = Convert.ToInt32(app1.Value);
                    }
                    if (app1.Key.ToLower() == "NumberofDaysinFuture".ToLower())
                    {
                        _noteCalculatorDC.NumberofDaysinFuture = Convert.ToInt32(app1.Value);
                    }
                }

                //if (_noteCalculatorDC.MaturityScenariosList.Count > 0)
                //{
                //    foreach (MaturityScenariosDataContract mdc in _noteCalculatorDC.MaturityScenariosList)
                //    {
                //        mdc.SelectedMaturityDate = _noteCalculatorDC.SelectedMaturityDate;
                //    }
                //}


                return _noteCalculatorDC;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetWellsViewsDataByDealID(string dealid, string viewName)
        {
            DataTable _wellsImportDataContractList = new DataTable();
            _wellsImportDataContractList = _noteRepository.GetWellsViewsDataByDealID(dealid, viewName);
            return _wellsImportDataContractList;
        }

        public DataSet GetWellsViewsAllDataByDealID(string dealid)
        {
            DataSet _wellsImportDataContractList = new DataSet();
            _wellsImportDataContractList = _noteRepository.GetWellsViewsAllDataByDealID(dealid);
            return _wellsImportDataContractList;
        }


        public List<FLiborScheduleTab> GetLiborScheduleForFast()
        {
            return _noteRepository.GetLiborScheduleForFast();
        }

        public List<NoteDataContract> GetAllNotes()
        {
            return _noteRepository.GetAllNotes();

        }

        public List<FeeSchedulesConfigDataContract> GetAllFeeTypesFromFeeSchedulesConfig()
        {
            return _noteRepository.GetAllFeeTypesFromFeeSchedulesConfig();
        }



        public List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfig(Guid? userID)
        {
            List<FeeFunctionsConfigDataContract> _feeFunctionsConfigDataContract = new List<FeeFunctionsConfigDataContract>();
            _feeFunctionsConfigDataContract = feeConfigLogic.GetFeeFunctionsConfig(userID);
            return _feeFunctionsConfigDataContract;
        }


        public List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfig(Guid? userID)
        {
            List<FeeSchedulesConfigDataContract> _feeSchedulesConfigDataContract = new List<FeeSchedulesConfigDataContract>();
            _feeSchedulesConfigDataContract = feeConfigLogic.GetFeeSchedulesConfig(userID);
            return _feeSchedulesConfigDataContract;
        }



        public List<HistoricalAccrualDataContract> GetAccrualFieldsFromNotePeriodicByNoteID(Guid? NoteId, Guid? UserID, Guid? AnalysisID)
        {
            return _noteRepository.GetAccrualFieldsFromNotePeriodicByNoteID(NoteId, UserID, AnalysisID);
        }


        public List<TransactionEntryDataContract> GetTransactionEntryByNoteId(Guid? noteid, Guid? AnalysisID)
        {
            return _noteRepository.GetTransactionEntryByNoteId(noteid, AnalysisID);
        }

        public List<LookupMasterDataContract> GetLookupForMaster()
        {
            return _noteRepository.GetLookupForMaster();
        }

        public DevDashBoardDataContract GetNoteCalcInfoByNoteId(Guid noteid, Guid scenrioid, Guid UserID)
        {
            return _noteRepository.GetNoteCalcInfoByNoteId(noteid, scenrioid, UserID);
        }
        public List<ServicerDropDateSetup> GetServicerDropDateSetupByNoteId(Guid? noteid, string createdBy)
        {
            return _noteRepository.GetServicerDropDateSetupByNoteId(noteid, createdBy);
        }
        public List<FinancingSourceDataContract> GetFinancingSource(Guid? UserID)
        {
            return _noteRepository.GetFinancingSource(UserID);
        }
        public List<ScheduleEffectiveDateDataContract> GetScheduleEffectiveDateCount(Guid NoteID)
        {
            return _noteRepository.GetScheduleEffectiveDateCount(NoteID);
        }
        public void CopyFundingSchedule(string ParentNoteID, string CopyNoteID, string CreatedBy)
        {
            _noteRepository.CopyFundingSchedule(ParentNoteID, CopyNoteID, CreatedBy);
        }
        public List<FeeCouponStripReceivableTab> GetFeeCouponStripReceivableDataByNoteIdForCalc(Guid? noteid, Guid? userID, Guid? AnalysisID)
        {
            List<FeeCouponStripReceivableTab> _feeCouponStripReceivableDataContractList = new List<FeeCouponStripReceivableTab>();
            _feeCouponStripReceivableDataContractList = _noteRepository.GetFeeCouponStripReceivableDataByNoteIdForCalc(noteid, userID, AnalysisID);
            return _feeCouponStripReceivableDataContractList;
        }

        public List<NoteListDealAmortDataContarct> GetNoteDetailForDealAmortByDealID(Guid? dealID)
        {
            return _noteRepository.GetNoteDetailForDealAmortByDealID(dealID);
        }

        public DataTable GetNoteDealAmortByDealID(Guid? dealID)
        {
            return _noteRepository.GetNoteDealAmortByDealID(dealID);
        }
        public DataTable refreshBSUnderwritingStatus(string BatchName, Guid? UserID)
        {
            return _noteRepository.refreshBSUnderwritingStatus(BatchName, UserID);
        }
        public DataTable GetMarketPriceByNoteID(string NoteId, string UserID)
        {
            return _noteRepository.GetMarketPriceByNoteID(NoteId, UserID);
        }
        public void InsertUpdateMarketPriceByNoteID(List<NoteMarketPriceDataContract> _notemarketpriceDC, Guid UserID)
        {

            _noteRepository.InsertUpdateMarketPriceByNoteID(_notemarketpriceDC, UserID);
        }
        public void DeleteMarketPriceByNoteID(List<NoteMarketPriceDataContract> _notemarketpriceDC, Guid UserID)
        {
            _noteRepository.DeleteMarketPriceByNoteID(_notemarketpriceDC, UserID);
        }

        public int DeleteNoteTransactionDetail(List<NoteServicingLogDataContract> lstNoteTransactionDetail)
        {
            return _noteRepository.DeleteNoteTransactionDetail(lstNoteTransactionDetail);
        }
        public DataTable GetNoteCommitmentsByNoteID(string NoteId, string UserID)
        {
            return _noteRepository.GetNoteCommitmentsByNoteID(NoteId, UserID);
        }

        public List<NoteCommitmentDataContract> GetNoteCommitmentForCalculatorByNoteID(Guid? NoteID)
        {
            return _noteRepository.GetNoteCommitmentForCalculatorByNoteID(NoteID);
        }
        public void InsertYieldCalcInput(List<YieldCalcInputDataContract> _yieldcalcinputdc, string CreatedBy)
        {
            _noteRepository.InsertYieldCalcInput(_yieldcalcinputdc, CreatedBy);
        }


        public string CopyNote(NoteDataContract notedc, string CreatedBy)
        {
            return _noteRepository.CopyNote(notedc, CreatedBy);
        }

        public void UpdateMaturityConfiguration(List<NoteDataContract> notedc, Guid UserId)
        {
            _noteRepository.UpdateMaturityConfiguration(notedc, UserId);
        }

        public void SaveMaturitybydeal(DataTable dtMaturity, Guid UserId)
        {
            _noteRepository.SaveMaturitybydeal(dtMaturity, UserId);
        }


        public DataTable GetMaturityHistoricalDataByDealID(Guid? DealID, Guid? userID, string mutipleNoteids)
        {
            return _noteRepository.GetMaturityHistoricalDataByDealID(DealID, userID, mutipleNoteids);
        }
        public String AddUpdateNoteRuleTypeSetup(List<ScenarioruletypeDataContract> scenarioDC, string headerUserID)

        {
            return _noteRepository.AddUpdateNoteRuleTypeSetup(scenarioDC, headerUserID);
        }
        public DataTable GetNoteCashflowsGAAPBasisExportData(DownloadCashFlowDataContract downloadCashFlow)
        {
            DataTable _noteCashflowsExportDataContractList = new DataTable();
            _noteCashflowsExportDataContractList = _noteRepository.GetNoteCashflowsGAAPBasisExportData(downloadCashFlow);
            return _noteCashflowsExportDataContractList;
        }

        public List<ScenarioruletypeDataContract> GetRuleTypeSetupByNoteId(string NoteID, string AnalysisID)
        {
            List<ScenarioruletypeDataContract> _scenarioDC = new List<ScenarioruletypeDataContract>();
            _scenarioDC = _noteRepository.GetRuleTypeSetupByNoteId(NoteID, AnalysisID);
            return _scenarioDC;
        }
    }
}