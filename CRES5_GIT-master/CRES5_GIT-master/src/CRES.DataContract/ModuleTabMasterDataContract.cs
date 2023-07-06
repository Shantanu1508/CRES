using System;

namespace CRES.DataContract
{
    public class ModuleTabMasterDataContract
    {

        public int ModuleTabMasterID { get; set; }
        public string ModuleTabName { get; set; }
        public int? ParentID { get; set; }
        public int? StatusID { get; set; }
        public int? SortOrder { get; set; }
        public string DisplayName { get; set; }
        public string ModuleType { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public bool? IsEdit { get; set; }
        public bool? IsView { get; set; }
        public bool? IsDelete { get; set; }

        public string RoleID { get; set; }
    }
}
