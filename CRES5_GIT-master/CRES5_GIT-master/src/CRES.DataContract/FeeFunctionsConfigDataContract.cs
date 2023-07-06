using System;

namespace CRES.DataContract
{
    public class FeeFunctionsConfigDataContract
    {



        public int? FunctionNameID { get; set; }
        public Guid? FunctionGuID { get; set; }
        public int? FunctionTypeID { get; set; }
        public int? PaymentFrequencyID { get; set; }
        public int? AccrualBasisID { get; set; }
        public int? AccrualStartDateID { get; set; }
        public int? AccrualPeriodID { get; set; }

        public string FunctionNameText { get; set; }
        public string FunctionTypeText { get; set; }
        public string PaymentFrequencyText { get; set; }
        public string AccrualBasisText { get; set; }
        public string AccrualStartDateText { get; set; }
        public string AccrualPeriodText { get; set; }
        public int? LookupID { get; set; }
        public string Name { get; set; }
        public bool IsUsedInFeeSchedule { get; set; }


    }
}
