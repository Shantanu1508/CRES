using System;

namespace CRES.DataContract
{
    public class TagMasterDataContract
    {
        public Guid? TagMasterID { get; set; }
        public string TagName { get; set; }
        public string TagDesc { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string FullName { get; set; }

        public Guid? AnalysisID { get; set; }
        public string AnalysisName { get; set; }
        public string StatusText { get; set; }
        public string TagFileName { get; set; }
        public string NewTagFileName { get; set; }
    }
}
