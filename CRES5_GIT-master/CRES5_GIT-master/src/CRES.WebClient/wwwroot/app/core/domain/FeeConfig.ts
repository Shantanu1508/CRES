export class FeeConfig {
    lstFeeFunctionsConfig: Array<FeeFunctionsConfig>;
    lstFeeSchedulesConfig: Array<FeeSchedulesConfig>;
}


export class FeeFunctionsConfig {

    FunctionNameID: number
    FunctionGuID : string
    FunctionTypeID : number
    PaymentFrequencyID : number
    AccrualBasisID : number
    AccrualStartDateID : number
    AccrualPeriodID : number
    FunctionNameText : string
    FunctionTypeText : string
    PaymentFrequencyText : string
    AccrualBasisText : string
    AccrualStartDateText : string
    AccrualPeriodText : string
}


export class FeeSchedulesConfig {

        FeeTypeNameID :number
        FeeTypeGuID :string
        FeeTypeNameText :string
        FeePaymentFrequencyID :number
        FeePaymentFrequencyText : string
        FeeCoveragePeriodID :number
        FeeCoveragePeriodText : string
        FeeFunctionID :number
        FeeFunctionText : string
        TotalCommitmentID :number
        TotalCommitmentText : string
        UnscheduledPaydownsID :number
        UnscheduledPaydownsText : string
        BalloonPaymentID :number
        BalloonPaymentText : string
        LoanFundingsID :number
        LoanFundingsText : string
        ScheduledPrincipalAmortizationPaymentID :number
        ScheduledPrincipalAmortizationPaymentText : string
        CurrentLoanBalanceID :number
        CurrentLoanBalanceText : string
        InterestPaymentID :number
        InterestPaymentText : string
        LookupID :number
        Name: string
        ExcludeFromCashflowDownload: boolean
        M61AdjustedCommitmentID: number
        M61AdjustedCommitmentText: string
    }