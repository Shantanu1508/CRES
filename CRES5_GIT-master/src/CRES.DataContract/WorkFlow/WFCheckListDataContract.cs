namespace CRES.DataContract
{
    public class WFCheckListDataContract
    {
        public int? CheckListMasterId { get; set; }
        public string CheckListName { get; set; }
        public int? CheckListStatus { get; set; }
        public string CheckListStatusText { get; set; }
        public string Comment { get; set; }
        public bool? IsMandatory { get; set; }
        public string TaskID { get; set; }
        public object WFCheckListDetailID { get; set; }
        public int WFTaskDetailID { get; set; }
        public int RowId { get; set; }
        public string WorkFlowType { get; set; }
        public bool? IsDisable { get; set; }
    }
}
