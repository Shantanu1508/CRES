namespace CRES.DataContract
{
    public class UserPermissionDataContract
    {
        public string UserID { get; set; }
        public string RoleName { get; set; }
        public string RightsName { get; set; }
        public string ParentModule { get; set; }
        public string ChildModule { get; set; }
        public string ModuleTabName { get; set; }
        public string ModuleType { get; set; }
    }

    public class SystemConfigKeys
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }
}