
import { Note, NoteMarketPrice } from "./note.model";

export class NoteAdditionalListObject {
  NoteId: string;
  ModuleId: number;
  noteobj: Note;
  noteValue: string;
  // lstMaturity: Array<Maturity>;
  MaturityScenariosList: Array<Maturity>;
  // lstRateSpreadSchedule: Array<RateSpreadSchedule>;
  RateSpreadScheduleList: Array<RateSpreadSchedule>;
  //  lstNotePrepayFeeSchedule: Array<NotePrepayAndAdditionalFeeSchedule>;
  NotePrepayAndAdditionalFeeScheduleList: Array<NotePrepayAndAdditionalFeeSchedule>;
  lstFinancingFeeSchedule: Array<FinancingFeeSchedule>;
  //  lstStrippingSchedule: Array<StrippingSchedule>;
  NoteStrippingList: Array<StrippingSchedule>;
  // lstFinancingSchedule: Array<FinancingSchedule>;
  NoteFinancingScheduleList: Array<FinancingSchedule>;
  //  lstDefaultSchedule: Array<DefaultSchedule>;
  NoteDefaultScheduleList: Array<DefaultSchedule>;
  //  lstPIKSchedule: Array<PIKSchedule>;
  NotePIKScheduleList: Array<PIKSchedule>;
  // lstServicingFeeSchedule: Array<ServicingFeeSchedule>;
  NoteServicingFeeScheduleList: Array<ServicingFeeSchedule>;
  // lstFutureFundingScheduleTab: Array<FutureFunding>;
  ListFutureFundingScheduleTab: Array<FutureFunding>;
  // lstFixedAmortScheduleTab: Array<FixedAmort>;
  ListFixedAmortScheduleTab: Array<FixedAmort>;
  //  lstLaborScheduleTab: Array<Labor>;
  ListLiborScheduleTab: Array<Libor>;
  // lstPIKDetailScheduleTab: Array<PIKDetail>;
  ListPIKfromPIKSourceNoteTab: Array<PIKDetail>;
  //lstFeeCouponStripReceivableTab: Array<FeeCouponStripReceivable>
  ListFeeCouponStripReceivable: Array<FeeCouponStripReceivable>
  lstNoteServicingLog: Array<ServicingLog>

  lstnotePeriodicOutputs: Array<NotePeriodicOutputsDataContract>
  lstOutputNPVdata: Array<OutputNPVdata>

  lstServicerDropDateSetup: Array<ServicerDropDateSetup>
  ParentNoteID: string;
  deleteMarketPriceList: Array<NoteMarketPrice>;
}


export class Maturity {
  MaturityID: number;
  EffectiveDate: Date;
  EventId: number;
  Date: Date;
  ModuleId: number;
}

export class RateSpreadSchedule {
  RateSpreadScheduleID: string;
  ModuleId: number;
  EventId: string;
  Date: Date;
  ValueTypeID: number;
  ValueTypeText: string;
  IntCalcMethodID: number;
  IntCalcMethodText: string;
  Value: number;
  EffectiveDate: Date;
}

export class NotePrepayAndAdditionalFeeSchedule {
  //   PrepayAndAdditionalFeeScheduleID: string;
  ModuleId: number;
  EventId: string;
  EffectiveDate: Date;
  //NotePrepayAndAdditionalValueType: number;
  ValueTypeID: number;
  ValueTypeText: string;
  NotePrepayAndAdditionalValue: number;
  ScheduleStartDate: Date;
  IncludedLevelYield: number;
  IncludedBasis: number;
  StartDate: Date;
  Value: number;
}

export class FinancingFeeSchedule {
  FinancingFeeScheduleID: string;
  ModuleId: number;
  EventId: string;
  EffectiveDate: Date;
  Date: Date;
  ValueTypeID: number;
  ValueTypeText: string;
  Value: number;
}

export class StrippingSchedule {
  StrippingScheduleID: string;
  ModuleId: number;
  EventId: string
  EffectiveDate: Date;
  StartDate: Date;
  ValueTypeID: number;
  ValueTypeText: string;
  Value: number;
  IncludedLevelYield: number;
  IncludedBasis: number;
}

export class FinancingSchedule {
  FinancingScheduleID: string;
  ModuleId: number;
  EventId: string;
  Date: Date;
  EffectiveDate: Date;
  Value: number;
  ValueTypeID: number;
  ValueTypeText: string;
  IndexTypeID: number;
  IndexTypeText: string;
  IntCalcMethodID: number;
  IntCalcMethodText: string;
  CurrencyCode: number;
  CurrencyCodeText: string;
}

export class DefaultSchedule {
  ModuleId: number;
  EffectiveDate: Date;
  EventId: string;
  StartDate: Date;
  EndDate: Date;
  Value: number;
  ValueTypeID: number;
  ValueTypeText: string;
}
export class ServicingFeeSchedule {
  EffectiveDate: Date;
  Date: Date;
  Value: number;
  IsCapitalized: number;
  ServicingFeeScheduleID: string;
  ModuleId: number;
  EventId: string;
}
export class PIKSchedule {
  EffectiveDate: Date;
  StartDate: Date;
  EndDate: Date;
  SourceAccountID: string
  SourceAccount: string
  TargetAccountID: string
  TargetAccount: string
  AdditionalIntRate: number
  AdditionalSpread: number
  IndexFloor: number
  IntCompoundingRate: number
  IntCompoundingSpread: number
  IntCapAmt: number
  PurBal: number
  AccCapBal: number
  PIKReasonCodeID: number;
  PIKComments: string;
  PIKReasonCodeIDText: string;
  PIKIntCalcMethodID: number;
  PIKIntCalcMethodIDText: string;

  ModuleId: number
  Value: number


}

export class FutureFunding {
  FundingScheduleID: string;
  EventId: string;
  ModuleId: number;
  EffectiveDate: Date;
  Date: Date;
  Value: number;
}

export class FixedAmort {
  AmortScheduleID: string;
  EventId: string;
  ModuleId: number;
  EffectiveDate: Date;
  Date: Date;
  Value: number;
}
export class Libor {
  LaborScheduleID: string;
  EventId: string;
  ModuleId: number;
  EffectiveDate: Date;
  Date: Date;
  Value: number;
  Indexoverrides: number;
}

export class PIKDetail {
  PIKScheduleDetailID: string;
  EventId: string;
  ModuleId: number;
  EffectiveDate: string;
  Date: Date;
  Value: number;
}

export class FeeCouponStripReceivable {
  FeeCouponStripReceivableID: string;
  EventId: string;
  ModuleId: number;
  EffectiveDate: Date;
  Date: Date;
  Value: number;
}
export class ServicingLog {
  row_num: number;
  TransactionDate: Date;
  TransactionType: number;
  TransactionAmount: number;
  RelatedtoModeledPMTDate: Date;
  ModeledPayment: number;
  AmountOutstandingafterCurrentPayment: number;
}

export class OutputNPVdata {
  NoteID: string;
  OutputNPVdataID: string;
  NPVdate: Date;
  NPVvalue: number;
  NPVnetFeeValue: number;
  NPVactual: number;
  CreatedBy: string;
  CreatedDate: Date;
  UpdatedBy: string;
  UpdatedDate: Date;
}


export class NotePeriodicOutputsDataContract {
  //NoteID: string;
  //NotePeriodicCalcID: string;
  PeriodEndDate: Date;
  Month: number;
  ActualCashFlows: number;
  GAAPCashFlows: number;
  EndingGAAPBookValue: number;
  TotalGAAPIncomeforthePeriod: number;
  InterestAccrualforthePeriod: number;
  PIKInterestAccrualforthePeriod: number;
  TotalAmortAccrualForPeriod: number;
  AccumulatedAmort: number;
  BeginningBalance: number;
  TotalFutureAdvancesForThePeriod: number;
  TotalDiscretionaryCurtailmentsforthePeriod: number;
  InterestPaidOnPaymentDate: number;
  TotalCouponStrippedforthePeriod: number;
  CouponStrippedonPaymentDate: number;
  ScheduledPrincipal: number;
  PrincipalPaid: number;
  BalloonPayment: number;
  EndingBalance: number;

  //ExitFeeIncludedInLevelYield: number;
  //ExitFeeExcludedFromLevelYield: number;
  //AdditionalFeesIncludedInLevelYield: number;
  //AdditionalFeesExcludedFromLevelYield: number;
  //OriginationFeeStripping: number;
  //ExitFeeStrippingIncldinLevelYield: number;
  //ExitFeeStrippingExcldfromLevelYield: number;
  //AddlFeesStrippingIncldinLevelYield: number;
  //AddlFeesStrippingExcldfromLevelYield: number;

  EndOfPeriodWAL: number;
  PIKInterestFromPIKSourceNote: number;
  PIKInterestTransferredToRelatedNote: number;
  PIKInterestForThePeriod: number;
  BeginningPIKBalanceNotInsideLoanBalance: number;
  PIKInterestForPeriodNotInsideLoanBalance: number;
  PIKBalanceBalloonPayment: number;
  EndingPIKBalanceNotInsideLoanBalance: number;
  CostBasis: number;
  PreCapBasis: number;
  BasisCap: number;
  AmortAccrualLevelYield: number;
  ScheduledPrincipalShortfall: number;
  PrincipalShortfall: number;
  PrincipalLoss: number;
  InterestForPeriodShortfall: number;
  InterestPaidOnPMTDateShortfall: number;
  CumulativeInterestPaidOnPMTDateShortfall: number;
  InterestShortfallLoss: number;
  InterestShortfallRecovery: number;
  BeginningFinancingBalance: number;
  TotalFinancingDrawsCurtailmentsForPeriod: number;
  FinancingBalloon: number;
  EndingFinancingBalance: number;
  FinancingInterestPaid: number;
  FinancingFeesPaid: number;
  PeriodLeveredYield: number;
  CreatedBy: string;
  CreatedDate: Date;
  UpdatedBy: string;
  UpdatedDate: Date;

}


export class ServicerDropDateSetup {
  ServicerDropDateSetupID: string;
  NoteID: string;
  ModeledPMTDropDate: Date;
  PMTDropDateOverride: Date;
  CreatedBy: string;
  CreatedDate: Date;
  UpdatedBy: string;
  UpdatedDate: Date;
}

