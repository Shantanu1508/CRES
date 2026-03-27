using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WFDetailDataContract
    {
        public string wfFlag;
        public int wf_isAllow;

        public int? WFTaskDetailId { get; set; }
        public int? WFStatusPurposeMappingID { get; set; }
        public string TaskID { get; set; }
        public int? WFStatusTaskMappingID { get; set; }
        public int? WFStatusMasterID { get; set; }
        public string StatusName { get; set; }
        public string StatusDisplayName { get; set; }
        public int? SubmitType { get; set; }
        public string SubmitTypeText { get; set; }

        public int? NextWFStatusPurposeMappingID { get; set; }
        public int? NextWFStatusMasterID { get; set; }
        public string NextStatusName { get; set; }
        public int? NextOrderIndex { get; set; }

        public WFAdditionalDataContarct WFAdditionalList { get; set; }
        public List<WFCheckListDataContract> WFCheckList { get; set; }
        public List<WFStatusDataContract> WFStatusList { get; set; }
        public int? TaskTypeID { get; set; }
        public string Comment { get; set; }
        public int? PurposeTypeId { get; set; }
        public int? OrderIndex { get; set; }
        public string TaskTypeIDText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public string CommentedByFirstLetter { get; set; }
        public string Login { get; set; }
        public string UColor { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string NextStatusDisplayName { get; set; }

        public string FilterType { get; set; }
        public List<ClientDataContract> WFClientList { get; set; }
        public List<ClientDataContract> WFNotificationMasterEmail { get; set; }
        public string DealName { get; set; }
        public string DrawComment { get; set; }
        public string ActivityLog { get; set; }
        public string FooterText { get; set; }
        public string SenderName { get; set; }
        public List<LookupDataContract> WFCheckListStatus { get; set; }

        public string AdditionalComments { get; set; }
        public string SpecialInstructions { get; set; }
        public string NoteswithAmount { get; set; }
        public DateTime? WFUpdatedDate { get; set; }
        public DateTime? WFAdditionalUpdatedDate { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string LastUpdatedBy { get; set; }
        public int wf_isAllowReject { get; set; }
        public string TimeZone { get; set; }
        public string WorkFlowType { get; set; }
        public string DelegatedUserID { get; set; }
        public string DelegatedUserName { get; set; }
        public string Abbreviation { get; set; }
        public int IsDisableFundingTeamApproval { get; set; }
        public int IsOnlyPrimaryUser { get; set; }
        public string ReserveScheduleBreakDown { get; set; }
        public decimal? ExitFee { get; set; }
        public decimal? ExitFeePercentage { get; set; }
        public decimal? PrepayPremium { get; set; }
        public string PropertyManagerEmail { get; set; }
        public string CREDealID { get; set; }
        public string AdditionalEmail { get; set; }
        //public UserDataContract User { get; set; }
        public string DealID { get; set; }
        public bool IsDiscrepancyForCommitment { get; set; }
        public int? OriginalWFStatusPurposeMappingID { get; set; }
        public string AmOversightMsg { get; set; }
    }


    public class WFRejectListDataContract
    {
        public int? WFStatusPurposeMappingID { get; set; }

        public string StatusName { get; set; }
        public string StatusDisplayName { get; set; }
    }

    public class WFConcurrencyParams
    {
        public string TaskID { get; set; }
        public int? TaskTypeID { get; set; }
        public int? WFStatusPurposeMappingID { get; set; }
        public int? WFStatusMasterID { get; set; }

    }
}
