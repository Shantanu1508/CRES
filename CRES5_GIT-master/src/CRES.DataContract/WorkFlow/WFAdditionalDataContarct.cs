using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WFAdditionalDataContarct
    {
        public decimal? Amount { get; set; }
        public bool? Applied { get; set; }
        public string Comment { get; set; }
        public string CREDealID { get; set; }
        public DateTime? Date { get; set; }
        public string DealName { get; set; }
        public string DrawFundingID { get; set; }
        public string FindingAmount { get; set; }
        public string FundingDate { get; set; }
        public int? PurposeID { get; set; }
        public string PurposeIDText { get; set; }
        public string PurposeText { get; set; }
        public string TaskID { get; set; }
        public int? WFTaskDetailID { get; set; }
        public string BoxDocumentLink { get; set; }
        public DateTime? DeadLineDate { get; set; }
        public bool IsPreliminaryNotification { get; set; }
        public bool IsRevisedPreliminaryNotification { get; set; }
        public bool IsFinalNotification { get; set; }
        public bool IsRevisedFinalNotification { get; set; }
        public bool IsServicerNotification { get; set; }
        public bool IsRevisedServicerNotification { get; set; }

        public string CreatedByName { get; set; }
        public string AMEmails { get; set; }
        public string AdditionalComments { get; set; }
        public string SpecialInstructions { get; set; }
        public DateTime? WFUpdatedDate { get; set; }
        public DateTime? WFAdditionalUpdatedDate { get; set; }
        public string SeniorCreNoteID { get; set; }
        public string SeniorServicerName { get; set; }
        public decimal? RequiredEquity { get; set; }
        public decimal? AdditionalEquity { get; set; }

        public string AssetManager { get; set; }
        public string AMTeamLeadUser { get; set; }
        public string AMSecondUser { get; set; }

        public string BaseCurrencyName { get; set; }

        public string ServicerName { get; set; }

        //public Guid? AssetManagerID { get; set; }
        //public Guid? AMTeamLeadUserID { get; set; }
        //public Guid? AMSecondUserID { get; set; }

        public bool IsREODeal { get; set; }

        public bool IsFinalNotificationPayOff { get; set; }
        public bool IsRevisedFinalNotificationPayOff { get; set; }
        public decimal? ExitFee { get; set; }
        public decimal? ExitFeePercentage { get; set; }
        public decimal? PrepayPremium { get; set; }
        public string PropertyManagerEmail { get; set; }
        public string AccountingEmail { get; set; }
        public DateTime? LastPrelimSentDate { get; set; }
        public bool IsCancelFinalSent { get; set; }

        public string AdditionalGroupEmail { get; set; }
        public string RevisedMessage { get; set; }
        public string AdditionalEmail { get; set; }
        public string NotesWithFinancingSourceNone { get; set; }
        public string AMEmailsWithoutWellsBerkadia { get; set; }
        public string WatchlistStatus { get; set; }

        public int TotalPendingInvoice { get; set; }
        public decimal TotalPendingInvoiceAmt { get; set; }
        public bool IsPrelimDisabled { get; set; }
        public string CREDealIDWithREO { get; set; }
    }
}
