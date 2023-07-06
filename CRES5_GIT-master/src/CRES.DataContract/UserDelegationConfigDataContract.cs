using System;

namespace CRES.DataContract
{
    public class UserDelegationConfigDataContract
    {

        public Guid? UserDelegateConfigID { get; set; }
        public Guid? UserID { get; set; }
        public string UserIDText { get; set; }
        public Guid? DelegatedUserID { get; set; }
        public string DelegatedUserIDText { get; set; }
        public DateTime? Startdate { get; set; }
        public DateTime? Enddate { get; set; }
        public bool? IsActive { get; set; }
        public string Selecteduser { get; set; }
        public string EntryType { get; set; }
        public string RequestType { get; set; }
        public string username { get; set; }



    }
}
