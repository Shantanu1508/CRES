using System;

namespace CRES.DataContract.WorkFlow
{
    public class WFStatusPurposeMappingDataContract
    {
        public int WFStatusPurposeMappingID { get; set; }
        public int? WFStatusMasterID { get; set; }
        public int? PurposeTypeId { get; set; }
        public int? OrderIndex { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public bool? IsEnable { get; set; }
        public string PurposeTypeText { get; set; }
        public string AutospreadValueText { get; set; }
        public string WFValueText { get; set; }
    }
}
