using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    interface INoteRepository
    {
        List<NoteDataContract> GetNoteFromDealIds(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? totalCount);
        List<NoteUsedInDealDataContract> GetNotesFromDealDetailByDealID(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount);
        NoteDataContract GetNoteFromNoteId(String noteID, Guid? userID, Guid? AnalysisID);

        List<MaturityScenariosDataContract> GetMaturityPeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<RateSpreadSchedule> GetRateSpreadSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<PrepayAndAdditionalFeeScheduleDataContract> GetPrepayAndAdditionalFeeScheduleDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<StrippingScheduleDataContract> GetStrippingSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<FinancingFeeScheduleDataContract> GetFinancingFeeSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<FinancingScheduleDataContract> GetFinancingSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<DefaultScheduleDataContract> GetDefaultSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<NoteServicingFeeScheduleDataContract> GetServicingFeeSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        List<PIKSchedule> GetPIKSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);


        DataTable GetHistoricalDataOfModuleByNoteId(Guid? noteid, Guid? userID, string ModuleName, string AnalysisID);
        void InsertNoteFutureFunding(List<PayruleTargetNoteFundingScheduleDataContract> NoteFundings, string username);
        DataTable GetNoteCashflowsExportData(Guid? noteid, Guid? dealid, Guid? AnalysisID, string MutipleNote);
        DataTable GetNoteCashflowsExportData(DownloadCashFlowDataContract downloadCashFlow);
        void InsertNotePeriodicCalcFromCalculationManger(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid);
        string AddNewNoteFromDealDetail(Guid? userid, List<NoteDataContract> noteDataContract, string createdBy, string UpdatedBy);
        List<PayruleNoteDetailFundingDataContract> GetNotesForPayruleCalculationByDealID(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount);
        List<NoteDataContract> SearchNoteByCRENoteId(NoteDataContract _noteDC);
        List<ActivityLogDataContract> GetActivityLogByModuleId(string userID, ActivityLogDataContract _activityDC, int? pageIndx, int? pageSize, out int? TotalCount);
        List<HolidayListDataContract> GetHolidayList();

        void InsertPIKDistributions(List<PIKDistributionsDataContract> _listPIKDistributionsDC, string CreatedBy);
        void AddUpdateNoteRuleByNoteId(NoteDataContract _noteDC, Guid? UserID);
        DataTable GetNotePeriodicCalcDynamicByNoteId(Guid? noteid);

        List<FFutureFundingScheduleTab> GetInputFutureFundingScheduleListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        DevDashBoardDataContract GetNoteCalcInfoByNoteId(Guid? NoteId, Guid? AnalysisID, Guid? UserID);
        List<FinancingSourceDataContract> GetFinancingSource(Guid? UserID);
        List<ScheduleEffectiveDateDataContract> GetScheduleEffectiveDateCount(Guid NoteId);
        void InsertDailyInterestAccural(List<DailyInterestAccrualsDataContract> ListDailyInterest, string NoteId, string CreatedBy);
        void InsertPeriodicInterestRateUsed(List<PeriodicInterestRateUsed> ListDailyInterest, string NoteId, string CreatedBy);
        DataTable GetMarketPriceByNoteID(String Noteid, string UserID);
        void InsertUpdateMarketPriceByNoteID(List<NoteMarketPriceDataContract> _notemarketpriceDC, Guid UserID);
        List<HolidayListDataContract> GetHolidayListForCalculator();

        void InsertDailyGAAPBasisComponents(List<DailyGAAPBasisComponentsDataContract> ListDailyGaap, string NoteId, string CreatedBy);
    }
}
