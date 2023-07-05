using System;

namespace CRES.DataContract
{
    public class RequestFailureDataContract
    {
        public string Name { get; set; }
        public string UserName { get; set; }
        public Nullable<System.DateTime> StartTime { get; set; }
        public Nullable<System.DateTime> EndTime { get; set; }
        public string ErrorMessage { get; set; }
        public string DealName { get; set; }
        public string EmailIds { get; set; }
        public System.Guid NoteID { get; set; }
        public System.Guid DealID { get; set; }
        public string CRENoteID { get; set; }
        public string CREDealID { get; set; }
    }
}
