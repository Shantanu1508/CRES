using System;

namespace CRES.DataContract
{
    public class FastFunctionDataContract
    {

        public System.Guid FunctionID { get; set; }
        public string FunctionName { get; set; }
        public int FunctionType { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public bool IsDefault { get; set; }
    }
}
