using CRES.DataContract;
using System;
using System.Collections.Generic;
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

    }
}
