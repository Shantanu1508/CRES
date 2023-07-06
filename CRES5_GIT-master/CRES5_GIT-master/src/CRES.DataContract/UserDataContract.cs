using System;

namespace CRES.DataContract
{
    public class UserDataContract
    {
        public Guid? UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Login { get; set; }
        public string Password { get; set; }

        public DateTime? ExpirationDate { get; set; }
        public int? StatusID { get; set; }

        public string OldPassword { get; set; }
        public string NewPassword { get; set; }


        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public Guid? RoleID { get; set; }
        public string RoleName { get; set; }
        public string Status { get; set; }
        public string SuperAdminName { get; set; }
        public string AuthenticationKey { get; set; }
        public string ContactNo1 { get; set; }
        public string UserToken { get; set; }

        public string UserLogin { get; set; }
        public string TimeZone { get; set; }

        public int EmailNotificationID { get; set; }
        public int ModuleId { get; set; }
        public string ModuleName { get; set; }

        public string envName { get; set; }

        public string IpAddress { get; set; }

    }
}
