using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IDealRepository
    {
        //List<DealDataContract> GetAllDeal();
        List<DealDataContract> GetAllDealUSP(Guid? userId, int? PageIndex, int? PageSize, out int? TotalCount);
        DealDataContract GetDealByid(string DeailId, Guid? userId);
        string InsertUpdateDeal(DealDataContract dealDC);
        List<PayruleTargetNoteFundingScheduleDataContract> GetFundingSchedulePayruleDataByDealID(Guid? dealID);
        List<PayruleNoteAMSequenceDataContract> GetFundingRepaymentSequenceByDealID(Guid? dealID);
        DataTable GetFundingRepaymentSequenceHistoryByDealID(Guid? dealID);
        List<PayruleDealFundingDataContract> GetDealFundingScheduleByDealID(Guid? dealID);

        void InsertUpdateDealFunding(List<PayruleDealFundingDataContract> dealfunding, string delegateduserid);
        List<DealDataContract> GetLinkedPhantomDealID(string CREDealId);

        void CopyDealFundingFromLegalToPhantom(string crenoteid);
        List<DealDataContract> SearchDealByCREDealIdOrDealName(DealDataContract dealDC);
        void DeleteModuleByID(DeleteModuleDataContract ModuleDC);
        DataTable GetWFNoteFunding(Guid? DealFundingID, string userID);
        void InsertUpdateAutoSpreadRule(List<AutoSpreadRuleDataContract> _autospreadruleDC);

        List<AutoSpreadRuleDataContract> GetAutoSpreadRuleByDealID(Guid? UserId, Guid? dealID);

        int ImportDealByCREDealID(string CREDealID, string envname, string NewCREDealID, string NewDealName, string UserID, out int? TotalCount);
        void DeleteDealByCREDealID(string CREDealID);
        DataTable GetDealNoteFundingDiscrepancy();
        DataSet GetNoteAllocationPercentage(Guid? DealFundingID, string userID);
        List<IDValueDataContract> GetScheduledPrincipalByDealID(Guid? UserId, string DealID);
        // DataTable GetDiscrepancyForExitAndExtentionStripReceiveable();
        PayruleDealFundingDataContract GetDealFundingByDealFundingID(string Userid, Guid? dealFundingID);
        Decimal GetEndingBalanceByDate(Guid? DealID, DateTime BalanceAsofDate);
        string GetDealCalculationStatus(string DealID);
        DataTable GetDiscrepancyListOfDealForEnableAutoSpread();
        DataTable GetDiscrepancyForExportPaydown();
        void UpdateAutoSpreadColumnByDealID(String DealID, DateTime? EarliestPossibleRepaymentDate, DateTime? LatestPossibleRepaymentDate, DateTime? ExpectedFullRepaymentDate, DateTime? AutoPrepayEffectiveDate, string UserID);
        DataTable GetDiscrepancyForCommitmentDataByDealID(string DealID);
        void InsertUpdateDealArchieveFunding_Automation(List<PayruleDealFundingDataContract> dealfunding, string username);

        int QueueDealForCalculationMultipleDeals(string DealdIDPipSeprated, string Updatedby, string AnalysisID, int CalcTyep);
        DataTable GetDealFundingWLDealPotentialImpairmentByDealID(Guid? dealID, string userID);
        List<AutoDistributeWriteoffDataContract> GetAutoDistributeWriteoffByDealID(Guid? dealID);
        void InsertUpdateAutoDistributeWriteoff(List<AutoDistributeWriteoffDataContract> _autodistributewriteoffDCList, string username);
        void InsertUpdateXIRROverride(DataTable _xirrOverride, string username);
        List<DealRelationshipDataContract> GetDealRelationshipByDealID(Guid? dealID);
        void SaveDealRelationship(List<DealRelationshipDataContract> _dealRelationship, string username);

        DataTable GetPrepaymentNoteSetupByDealID(Guid? dealID);

        DataTable GetPrepaymentGroupByDealID(Guid? dealID);
        DataTable GetCurrentSpreadfromRateSpreadSchByDealID(string dealID);
        DataTable GetCalculatedWeightedSpreadByDealID(Guid? dealID);
        List<ReserveAccountMasterDataContract> GetAllReserveAccountMaster(Guid? userid);
        DataTable GetFundingNetCapitalInvestedbyDealID(Guid? dealID);
        void UpdateReserveAccountFromBackshop(ReserveAccountSyncDataContract DealDC, string UserID);

        public DealDashDataContract GetDealDashBoardByid(Guid? DeailId);
        int InsertUpdatePayoffStatementFees(DataTable dtPayoffStatementFees, string UserID);
        DataTable GetPayoffStatementFeesDetailsByDealID(Guid? dealID);
        void UpdateDealForPayoffStatementConfiguration(DealDataContract dealdc);
        int CallDealForPrePayCalculation(string Dealdid, string Updatedby, string AnalysisID, int CalcTyep, string RequestFrom, int? IsEmailSent);
    }
}
