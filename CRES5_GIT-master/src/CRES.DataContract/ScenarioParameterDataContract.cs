using System;
using System.Data;

namespace CRES.DataContract
{
    public class ScenarioParameterDataContract
    {
        public string AnalysisID { get; set; }
        public string AnalysisParameterID { get; set; }
        public int? MaturityScenarioOverrideID { get; set; }
        public string MaturityScenarioOverrideText { get; set; }
        public int? MaturityAdjustment { get; set; }
        public string Description { get; set; }
        public int? StatusID { get; set; }
        public string StatusIDText { get; set; }
        public string ScenarioName { get; set; }
        public string CreatedBy { get; set; }
        public string ActionStatus { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        //public DataTable indexlist { get; set; }
        public string FunctionName { get; set; }
        public int? IndexScenarioOverride { get; set; }
        public string IndexScenarioOverrideText { get; set; }
        public int? CalculationMode { get; set; }
        public string CalculationModeText { get; set; }
        public int? ExcludedForcastedPrePayment { get; set; }
        public string ExcludedForcastedPrePaymentText { get; set; }
        public int? AutoCalcFreq { get; set; }
        public string AutoCalcFreqText { get; set; }
        public string ScenarioColor { get; set; }
        public object UserID { get; set; }
        public string UseActualsText { get; set; }
        public int? UseActuals { get; set; }
        public string DisableBusinessDayAdjustmentText { get; set; }
        public int? DisableBusinessDayAdjustment { get; set; }
        public int? JsonTemplateMasterID { get; set; }
        public string TemplateName { get; set; }


        public int? CalculationFrequency { get; set; }
        public string CalculationFrequencyText { get; set; }
        public int? CalcEngineType { get; set; }
        public string CalcEngineTypeText { get; set; }
        public int? AllowCalcOverride { get; set; }
        public string AllowCalcOverrideText { get; set; }
        public int? AllowCalcAlongWithDefault { get; set; }
        public string AllowCalcAlongWithDefaultText { get; set; }
        public string Key { get; set; }
        public string Type { get; set; }

        public int? AccountingClose { get; set; }
        public string AccountingCloseText { get; set; }
        public int? IncludeProjectedPrincipalWriteoff { get; set; }
        public string IncludeProjectedPrincipalWriteoffText { get; set; }

        public int? CalculateLiability { get; set; }
        public string CalculateLiabilityText { get; set; }

        public int? ScenarioStatus { get; set; }
        public string ScenarioStatusText { get; set; }
        public string jsonparam { get; set; }
        public int? UseFinancingMaturityDateOverride { get; set; }
        public string UseFinancingMaturityDateOverrideText { get; set; }
        public int? UseMaturityAdjustmentMonths { get; set; }
        public string UseMaturityAdjustmentMonthsText { get; set; }
        public int? IncludeInDiscrepancy { get; set; }
        public string IncludeInDiscrepancyText { get; set; }

        public DateTime? LastCalculatedDate { get; set; }
        public string OperationMode { get; set; }
        public int? EqDelayMonths { get; set; }
        public int? FinDelayMonths { get; set; }
        public double? MinEqBalForFinStart { get; set; }
        public int? SublineEqApplyMonths { get; set; }
        public int? SublineFinApplyMonths { get; set; }
        public int? DebtCallDaysOfTheMonth { get; set; }
        public int? CapitalCallDaysOfTheMonth { get; set; }
    }


    public class ScenariosearchDataContract
    {
        public string AnalysisID { get; set; }
        public DateTime? Fromdate { get; set; }
        public DateTime? Todate { get; set; }

    }

    public class ScenarioruletypeDataContract
    {
        public string AnalysisID { get; set; }

        public string DealID { get; set; }

        public string NoteID { get; set; }
        public int? RuleTypeMasterID { get; set; }
        public string RuleTypeName { get; set; }
        public int? RuleTypeDetailID { get; set; }
        public string FileName { get; set; }

        public int? RuleTypeMasterID_Detail { get; set; }

        public string AnalysisName { get; set; }
        public string CreatedBy { get; set; }

        public string UpdatedBy { get; set; }

    }

}