using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DataContract
{
    public class AmortDataContract
    {
        public System.Guid DealID { get; set; }
        public string DealName { get; set; }
        public DataTable dt { get; set; }
        public List<NoteListDealAmortDataContarct> NoteListForDealAmort { get; set; }
        public List<AmortSequenceDataContract> AmortSequenceList { get; set; }

        public List<DealAmortScheduleDataContract> DealAmortScheduleList { get; set; }
        public List<NoteAmortScheduleDataContract> NoteAmortScheduleList { get; set; }
        public string DealAmortGenerationExceptionMessage { get; set; }
        public int? Flag_BasicDealSave { get; set; }
        public int? Flag_DealFundingSave { get; set; }
        public int? Flag_DealAmortSave { get; set; }
        public int? Flag_NoteSaveFromDealDetail { get; set; }
        public int? AmortizationMethod { get; set; }
        public string AmortizationMethodText { get; set; }
        public int? ReduceAmortizationForCurtailments { get; set; }
        public string ReduceAmortizationForCurtailmentsText { get; set; }
        public int? BusinessDayAdjustmentForAmort { get; set; }
        public string BusinessDayAdjustmentForAmortText { get; set; }
        public int? NoteDistributionMethod { get; set; }
        public string NoteDistributionMethodText { get; set; }

        public decimal? PeriodicStraightLineAmortOverride { get; set; }
        public decimal? FixedPeriodicPayment { get; set; }
        public int? DealAmortScheduleRowno { get; set; }
        public List<NoteAmortFundingDataContract> AmortNoteFundingList { get; set; }
        public string MutipleNoteIds { get; set; }

    }



    public class NoteAmortFundingDataContract
    {
        public string NoteID { get; set; }
        public string Value { get; set; }
        public string NoteName { get; set; }
        public DateTime Date { get; set; }
        public int? DealAmortScheduleRowno { get; set; }
        public decimal? EndingBalance { get; set; }
    }
}
