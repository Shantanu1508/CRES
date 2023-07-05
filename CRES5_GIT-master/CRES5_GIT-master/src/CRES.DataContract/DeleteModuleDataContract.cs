using System;

namespace CRES.DataContract
{
    public class DeleteModuleDataContract
    {
        public Guid UserId { get; set; }
        public string ModuleName { get; set; }
        public Guid ModuleID { get; set; }
        public Guid DealID { get; set; }
        public int LookupID { get; set; }
    }
}
