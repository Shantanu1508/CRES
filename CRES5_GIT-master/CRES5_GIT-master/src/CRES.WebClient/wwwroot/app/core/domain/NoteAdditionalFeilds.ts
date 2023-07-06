export class NoteAdditionalFeilds {
    //Maturity
    NoteID: string;
    Maturity_EventId: number;
    NoteMaturityScenariosID: number;
    Maturity_EffectiveDate: Date;
    MaturityDate: Date;   

    //RateSpreadSchedule
    RateSpreadScheduleID: number;
    RateSpreadSchedule_EventId: number;
    RateSpreadSchedule_Date: Date;
    RateSpreadSchedule_EffectiveDate: Date;
    RateSpreadSchedule_ValueTypeID: number;
    RateSpreadSchedule_ValueTypeText: string;
    RateSpreadSchedule_Value: number;
    RateSpreadSchedule_IntCalcMethodID: number;
    RateSpreadSchedule_IntCalcMethodText: string;

    ///Prepay And Additional Fee Schedule
    PrepayAndAdditionalFeeScheduleID: number
    PrepayAddFeeSch_EventID: number;
    PrepayAddFeeSch_EffectiveDate: Date;
    PrepayAddFeeSch_ValueTypeID: number;
    PrepayAddFeeSch_Value: number;
    PrepayAddFeeSch_StartDateScheduleStartDate: Date;
    PrepayAddFeeSch_StartDateIncludedLevelYield: number;
    PrepayAddFeeSch_StartDateIncludedBasis: number;
    PrepayAddFeeSch_StartDate: Date;
    PrepayAddFeeSch_StartDateMaxFeeAmt: number;


    //Stripping
    StrippingScheduleID: string;
    Stripping_EventID: number;
    Stripping_EffectiveDate: Date;
    Stripping_ValueTypeID: number;
    Stripping_Value: number;
    Stripping_ValueTypeText: string;
    Stripping_StartDate: Date;
    Stripping_IncludedLevelYield: number;
    Stripping_IncludedBasis: number;


    //Financing Fee Schedule
    FinancingFee_EventId: string;
    FinancingFee_EffectiveDate: Date;
    FinancingFee_Date: Date;
    FinancingFee_ValueTypeID: number;
    FinancingFee_Value: number;

    //Note Financing Schedule
    FinancingSch_FinancingScheduleID: string;
    FinancingSch_EventId: number;
    FinancingSch_EffectiveDate: Date;
    FinancingSch_Date: Date;
    FinancingSch_Value: number;
    FinancingSch_IndexTypeID: number;
    FinancingSch_IntCalcMethodID: number;
    FinancingSch_CurrencyCode: number;
    FinancingSch_ValueTypeID: number;
    FinancingSch_IndexTypeText: string;
    FinancingSch_IntCalcMethodText: string;
    FinancingSch_CurrencyCodeText: string;
    FinancingSch_ValueTypeText: string;

    //DefaultSchedule
    DefaultScheduleID: string;
    DefaultSch_EventId: number;
    DefaultSch_EffectiveDate: Date;
    DefaultSch_StartDate: Date;
    DefaultSch_EndDate: Date;
    DefaultSch_ValueTypeText: string;
    DefaultSch_ValueTypeID: number;

    //ServicingFeeSchedule
    NoteServicingFeeScheduleID: number;
    ServicingFee_EffectiveDate: Date;
    ServicingFee_Date: Date;
    ServicingFee_Value: any;
    ServicingFee_IsCapitalized: number;

    //PIKSchedule
    PIK_EffectiveDate: Date;
    SourceAccountID: string;
    TargetAccountID: string;
    AdditionalIntRate: number;
    AdditionalSpread: number;
    IndexFloor: number;
    IntCompoundingRate: number;
    IntCompoundingSpread: number;
    StartDate: Date;
    EndDate: Date;
    IntCapAmt: number;
    PurBal: number;
    AccCapBal: number; 

    PIKReasonCodeID: number; 
    PIKComments: string; 
    PIKReasonCodeIDText: string; 
      
    constructor(noteid: string) {
        this.NoteID = noteid;
    }
}