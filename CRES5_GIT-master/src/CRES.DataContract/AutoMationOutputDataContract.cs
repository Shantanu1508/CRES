using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{



    public class AutoMationOutputDataContract
    {
        public string CREID { get; set; }
        public string Name { get; set; }
        public string URL { get; set; }
        public string SaveMessage { get; set; }
        public string GenerateMessage { get; set; }
        public string TestCaseName { get; set; }
        public string Validation { get; set; }

    }

    public class AutoMationOutputData
    {
        public string DealID { get; set; }
        public string DealName { get; set; }
        public string SaveMessage { get; set; }
        public string GenerateMessage { get; set; }
        public string Validation1 { get; set; }
        public string Validation2 { get; set; }
        public string Validation3 { get; set; }
        public string Validation4 { get; set; }
        /* public string Validation5 { get; set; }
         public string Validation6 { get; set; }
         public string Validation7 { get; set; }
         public string Validation8 { get; set; }
         public string Validation9 { get; set; }
         public string Validation10 { get; set; }
         */
    }

    public class ExcelAutoMationOutputDataContract
    {
        public string CREID { get; set; }
        public string Name { get; set; }
        public string CommitmentDownloadPassStatus { get; set; }
        public string FundingRuleDownloadPassStatus { get; set; }
        public string DealFundingDownloadPassStatus { get; set; }
        public string DownloadFailedStatus { get; set; }
        public string FolderNotExist { get; set; }
        public string Exception { get; set; }

    }

    public class ExcelAutoMationOutputData
    {
        public string CREID { get; set; }
        public string Name { get; set; }
        public string CommitmentDownloadPassStatus { get; set; }
        public string FundingRuleDownloadPassStatus { get; set; }
        public string DealFundingDownloadPassStatus { get; set; }
        public string DownloadFailedStatus { get; set; }
        public string FolderNotExist { get; set; }
        public string Exception { get; set; }

    }

    public class PageLoadTest
    {
        public int SrNo { get; set; }
        public string PageName { get; set; }
        public string TabName { get; set; }
        public string Status { get; set; }
        public string Exception { get; set; }
    }

    public class Liabilitys
    {
        public int SrNo { get; set; }
        public string Entity_Name { get; set; }
        public string Entity_Id { get; set; }
        public string Entity_Type { get; set; }
        public string Status { get; set; }
        public string Exception { get; set; }

    }

    public class DebtSheet
    {
        public int SrNo { get; set; }
        public string Output { get; set; }
        public string LiabilityNoteID { get; set; }
        public string LiabilityID { get; set; }
        public string LiabilityAssetID { get; set; }
        public string LiabilityStatus { get; set; }
        public string LiabilityPledgeDate { get; set; }
        public double LiabilityPaydownAdvanceRate { get; set; }
        public double LiabilityFundingAdvanceRate { get; set; }
        public double LiabilityTargetAdvanceRate { get; set; }
        public string LiabilityMaturityDate { get; set; }
        public string RSSEffectiveDate { get; set; }
        public string RSSDate { get; set; }
        public string RSSValueType { get; set; }
        public string RSSValue { get; set; }
        public string RSSCalcMethod { get; set; }
        public string RSSRateOrSpreadToBeStripped { get; set; }
        public string RSSIndexName { get; set; }
        public string RSSDeterminationDateHolidayList { get; set; }
    }

    public class EquitySheet
    {
        public int SrNo { get; set; }
        public string Entity_Name { get; set; }
        public string Entity_Id { get; set; }
        public string Entity_Type { get; set; }
        public string Status { get; set; }
        public string Exception { get; set; }

    }


    public class JournalEntrySheet
    {
        public int SrNo { get; set; }
        public string Entity_Name { get; set; }
        public string Entity_Id { get; set; }
        public string Entity_Type { get; set; }
        public string Status { get; set; }
        public string Exception { get; set; }

    }
    public class LiabilityNoteSheet
    {
        public int SrNo { get; set; }
        public string Entity_Name { get; set; }
        public string Entity_Id { get; set; }
        public string Entity_Type { get; set; }
        public string Status { get; set; }
        public string Exception { get; set; }

    }

    public class ExportDataStatus
    {
        public string NoteId { get; set; }
        public string Amount { get; set; }
        public string FundingDate { get; set; }
        public string FundingPurpose { get; set; }
        public string TimeStamp { get; set; }
        public string Status { get; set; }

    }

}