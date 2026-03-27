using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FeeScheduleDataContract
    {
        public DateTime? EffectiveDate { get; set; }
        public string FeeName { get; set; }
        public string AccountID { get; set; }
        public string AdditionalAccountID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? ValueTypeID { get; set; }
        public string FeeTypeText { get; set; }
        public Decimal? Fee { get; set; }
        public decimal? FeeAmountOverride { get; set; }
        public decimal? BaseAmountOverride { get; set; }
        public string ApplyTrueUpFeatureText { get; set; }
        public int? ApplyTrueUpFeatureID { get; set; }
        public decimal? IncludedLevelYield { get; set; }
        public decimal? PercentageOfFeeToBeStripped { get; set; }
        public Boolean IsDeleted { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }

    public class PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract
    {
        public string AccountID { get; set; }
        public string AdditionalAccountID { get; set; }
        public string EventID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? StartDate { get; set; }
        public int? ValueTypeID { get; set; }
        public decimal? From { get; set; }
        public decimal? To { get; set; }
        public decimal? Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }

}
