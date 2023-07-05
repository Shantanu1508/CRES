using System;

namespace CRES.DataContract
{
    public class IndexesMasterDataContract
    {

        public int? IndexesMasterID { get; set; }

        public System.Guid? IndexesMasterGuid { get; set; }

        public String IndexesName { get; set; }
        public String Description { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public System.Guid? IndewxFromGuid { get; set; }
        public System.Guid? IndewxToGuid { get; set; }
        //1-replace,2-overwrite
        public int ImportType { get; set; }

    }

    public class IndexesMasterSearchDataContract
    {
        public System.Guid? IndexesMasterGuid { get; set; }
        public DateTime? Fromdate { get; set; }
        public DateTime? Todate { get; set; }

    }
}
