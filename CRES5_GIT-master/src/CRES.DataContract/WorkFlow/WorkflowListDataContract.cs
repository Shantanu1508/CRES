using System;

namespace CRES.DataContract
{
    public class WorkflowListDataContract
    {
        public int WFTaskDetailID { get; set; }
        public string TaskID { get; set; }
        public int? TaskTypeID { get; set; }
        public int? SubmitType { get; set; }
        public string WorkFlowComment { get; set; }
        public int? WFStatusPurposeMappingID { get; set; }
        public int? PurposeTypeId { get; set; }
        public int? OrderIndex { get; set; }
        public int? WFStatusMasterID { get; set; }
        public string StatusName { get; set; }
        public string TaskTypeIDText { get; set; }
        public string SubmitTypeText { get; set; }
        public int? PurposeID { get; set; }
        public string PurposeIDText { get; set; }
        public int? Applied { get; set; }
        public string dealfunComment { get; set; }
        public string DrawFundingID { get; set; }
        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public Nullable<System.DateTime> Deadline { get; set; }
        public Nullable<System.DateTime> Fundingdate { get; set; }
        public decimal? Amount { get; set; }
        public string Username { get; set; }

        public string FundingApprovalRequired { get; set; }
    }
}
