using System;

namespace CRES.DataContract
{
    public class RoleDataContract
    {
        public Guid? RoleID { get; set; }
        public string RoleName { get; set; }
        public int? StatusID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public string UserId { get; set; }
    }
}
