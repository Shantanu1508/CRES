using System;

namespace CRES.DataContract
{
    public class UserDefaultSettingDataContract
    {

        public Guid? UserDefaultSettingID { get; set; }
        public Guid? UserID { get; set; }
        public int? Type { get; set; }
        public string TypeText { get; set; }
        public string Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
