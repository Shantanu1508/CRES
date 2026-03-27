using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FeeSchedulesConfigDataContract
    {

        public int? FeeTypeNameID { get; set; }
        public Guid? FeeTypeGuID { get; set; }
        public string FeeTypeNameText { get; set; }
        public int? FeePaymentFrequencyID { get; set; }
        public string FeePaymentFrequencyText { get; set; }
        public int? FeeCoveragePeriodID { get; set; }
        public string FeeCoveragePeriodText { get; set; }
        public int? FeeFunctionID { get; set; }
        public string FeeFunctionText { get; set; }
        public int? TotalCommitmentID { get; set; }
        public string TotalCommitmentText { get; set; }
        public int? UnscheduledPaydownsID { get; set; }
        public string UnscheduledPaydownsText { get; set; }
        public int? BalloonPaymentID { get; set; }
        public string BalloonPaymentText { get; set; }
        public int? LoanFundingsID { get; set; }
        public string LoanFundingsText { get; set; }
        public int? ScheduledPrincipalAmortizationPaymentID { get; set; }
        public string ScheduledPrincipalAmortizationPaymentText { get; set; }
        public int? CurrentLoanBalanceID { get; set; }
        public string CurrentLoanBalanceText { get; set; }
        public int? InterestPaymentID { get; set; }
        public string InterestPaymentText { get; set; }
        public int? LookupID { get; set; }
        public string Name { get; set; }
        public bool IsUsedInCalc { get; set; }
        public int? FeeNameTransID { get; set; }
        public string FeeNameTransText { get; set; }     
        

        public int? ID { get; set; }
        public string NameText { get; set; }

        public bool? ExcludeFromCashflowDownload { get; set; }
        public int? InitialFundingID { get; set; }
        public string InitialFundingText { get; set; }
       
        public int? M61AdjustedCommitmentID { get; set; }
        public string M61AdjustedCommitmentText { get; set; }

        public int? PIKFundingID { get; set; }
        public string PIKFundingText { get; set; }
        public int? PIKPrincipalPaymentID { get; set; }
        public string PIKPrincipalPaymentText { get; set; }
        public int? CurtailmentID { get; set; }
        public string CurtailmentText { get; set; }
        public int? UpsizeAmountID { get; set; }
        public string UpsizeAmountText { get; set; }
        public int? UnfundedCommitmentID { get; set; }
        public string UnfundedCommitmentText { get; set; }

    }
}
