using System;

namespace CRES.DataContract
{
    public class QBDCompanyDataContract
    {
        public int QuickBookCompanyID { get; set; }
        public string Name { get; set; }
        public string EndPointID { get; set; }
        public string AutofyCompanyID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        //
    }
}
