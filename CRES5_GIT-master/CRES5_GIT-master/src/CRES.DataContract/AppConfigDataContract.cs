using System;

namespace CRES.DataContract
{
    public class AppConfigDataContract
    {
        //public int? AllowBackshopFF { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
