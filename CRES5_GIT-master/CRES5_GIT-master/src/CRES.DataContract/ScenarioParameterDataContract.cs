using System;

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

        public string Key { get; set; }
        public string Type { get; set; }

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