using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class CustomFeeScheduleDataContract
    {

        public Guid? NoteID { get; set; }
        public DateTime? EffectiveDate { get; set; }       
        public DateTime? ScheduleStartDate { get; set; }
        public decimal? Value { get; set; }        
        public string ValueTypeText { get; set; }
        public decimal? IncludedLevelYield { get; set; }
        public decimal? IncludedBasis { get; set; }      
        public DateTime? StartDate { get; set; }        
        public DateTime? ScheduleEndDate { get; set; }
        public string FeeFunction { get; set; }
        public string FeeName { get; set; }
        public decimal? FeeAmountOverride { get; set; }
        public decimal? BaseAmountOverride { get; set; }
        public string ApplyTrueUpFeatureText { get; set; }       
        public decimal? PercentageOfFeeToBeStripped { get; set; }         
        public int TotalCommitment { get; set; }       
        public int UnscheduledPaydowns { get; set; }      
        public int BalloonPayment { get; set; }        
        public int LoanFundings { get; set; }      
        public int ScheduledPrincipalAmortizationPayment { get; set; }
        public int CurrentLoanBalance { get; set; }
        public int InterestPayment { get; set; }
        public string FeeNameTransText { get; set; }
        public int InitialFunding { get; set; }
        public int AdjustedCommitment { get; set; }
        
    }
}
