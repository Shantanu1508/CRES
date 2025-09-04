using System;

namespace CRES.DataContract
{
    public class DevDashBoardDataContract
    {
        public int? value { get; set; }
        public string Name { get; set; }
        public DateTime? vDate { get; set; }
        public string NoteID { get; set; }
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public int? StatusID { get; set; }
        public DateTime? RequestTime { get; set; }
        public string ProcessType { get; set; }
        public string ErrorMessage { get; set; }
        public string ScenarioID { get; set; }
        public string dwStatus { get; set; }
        public DateTime dwlastupdatedtime { get; set; }
        public Guid? UserID { get; set; }
        public string CalcStatus { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string RequestBy { get; set; }
        public int? IsEnable { get; set; }
        public int? DealCount { get; set; }
        public int? NoteCount { get; set; }
        public string IsChart { get; set; }
        public string ChartType { get; set; }
        public string ChartName { get; set; }
        public DateTime? AccountingCloseDate { get; set; }
        public string CalcEngineTypeText { get; set; }
        public string DealID { get; set; }
    }
}
