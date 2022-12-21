using System;

namespace CRES.DataContract
{
    public class NoteAdditinalFeildsDataContract
    {
        public string NoteID { get; set; }
        //Maturity
        public int Maturity_EventId { get; set; }
        public int NoteMaturityScenariosID { get; set; }
        public DateTime? Maturity_EffectiveDate { get; set; }
        public DateTime? MaturityDate { get; set; }

        //RateSpreadSchedule
        public int RateSpreadScheduleID { get; set; }
        public int RateSpreadSchedule_EventId { get; set; }
        public DateTime? RateSpreadSchedule_Date { get; set; }
        public DateTime? RateSpreadSchedule_EffectiveDate { get; set; }
        public int? RateSpreadSchedule_ValueTypeID { get; set; }
        public string RateSpreadSchedule_ValueTypeText { get; set; }
        public Decimal? RateSpreadSchedule_Value { get; set; }
        public int? RateSpreadSchedule_IntCalcMethodID { get; set; }


        ///Prepay And Additional Fee Schedule
        public int PrepayAndAdditionalFeeScheduleID { get; set; }
        public int PrepayAddFeeSch_EventID { get; set; }
        public DateTime? PrepayAddFeeSch_EffectiveDate { get; set; }
        public int? PrepayAddFeeSch_ValueTypeID { get; set; }
        public Decimal? PrepayAddFeeSch_Value { get; set; }
        public Decimal? PrepayAddFeeSch_IncludedLevelYield { get; set; }
        public Decimal? PrepayAddFeeSch_IncludedBasis { get; set; }
        public DateTime? PrepayAddFeeSch_StartDate { get; set; }
        public Decimal? PrepayAddFeeSch_MaxFeeAmt { get; set; }

        //Stripping

        public int StrippingScheduleID { get; set; }
        public int Stripping_EventID { get; set; }
        public DateTime? Stripping_EffectiveDate { get; set; }
        public decimal? Stripping_Value { get; set; }
        public int? Stripping_ValueTypeID { get; set; }
        public string Stripping_ValueTypeText { get; set; }
        public DateTime? Stripping_StartDate { get; set; }
        public Decimal? Stripping_IncludedLevelYield { get; set; }
        public Decimal? Stripping_IncludedBasis { get; set; }

        //Financing Fee Schedule
        public int FinancingFee_EventId { get; set; }
        public DateTime? FinancingFee_EffectiveDate { get; set; }
        public DateTime? FinancingFee_Date { get; set; }
        public int? FinancingFee_ValueTypeID { get; set; }
        public Decimal? FinancingFee_Value { get; set; }

        //Note Financing Schedule
        public int? FinancingSch_FinancingScheduleID { get; set; }
        public int? FinancingSch_EventId { get; set; }
        public DateTime? FinancingSch_EffectiveDate { get; set; }
        public DateTime? FinancingSch_Date { get; set; }
        public Decimal? FinancingSch_Value { get; set; }
        public int? FinancingSch_IndexTypeID { get; set; }
        public int? FinancingSch_IntCalcMethodID { get; set; }
        public int? FinancingSch_CurrencyCode { get; set; }
        public int? FinancingSch_ValueTypeID { get; set; }
        public string FinancingSch_IndexTypeText { get; set; }
        public string FinancingSch_IntCalcMethodText { get; set; }
        public string FinancingSch_CurrencyCodeText { get; set; }
        public string FinancingSch_ValueTypeText { get; set; }


        //DefaultSchedule
        public int DefaultScheduleID { get; set; }
        public int DefaultSch_EventId { get; set; }
        public DateTime? DefaultSch_EffectiveDate { get; set; }
        public DateTime? DefaultSch_StartDate { get; set; }
        public DateTime? DefaultSch_EndDate { get; set; }
        public string DefaultSch_ValueTypeText { get; set; }
        public int? DefaultSch_ValueTypeID { get; set; }
        public Decimal? DefaultSch_Value { get; set; }


        //ServicingFeeSchedule

        public int NoteServicingFeeScheduleID { get; set; }
        public DateTime? ServicingFee_EffectiveDate { get; set; }
        public DateTime? ServicingFee_Date { get; set; }
        public Decimal? ServicingFee_Value { get; set; }
        public int? ServicingFee_IsCapitalized { get; set; }

        //PIK
        public DateTime? PIK_EffectiveDate { get; set; }
        public string SourceAccountID { get; set; }
        public string SourceAccount { get; set; }
        public string TargetAccountID { get; set; }
        public string TargetAccount { get; set; }
        public int? AdditionalIntRate { get; set; }
        public int? AdditionalSpread { get; set; }
        public int? IndexFloor { get; set; }
        public int? IntCompoundingRate { get; set; }
        public int? IntCompoundingSpread { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? IntCapAmt { get; set; }
        public int? PurBal { get; set; }
        public int? AccCapBal { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? PIKReasonCodeID { get; set; }
        public int? PIKIntCalcMethodID { get; set; }
        public string PIKComments { get; set; }
    }
}
