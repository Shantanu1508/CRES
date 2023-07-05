using System;

namespace CRES.DataContract
{
    public class ExceptionDataContract
    {
        public Guid? ExceptionID { get; set; }
        public int ObjectTypeID { get; set; }
        public Guid? ObjectID { get; set; }
        public string ObjectTypeText { get; set; }
        public string FieldName { get; set; }
        public int? Count { get; set; }
        public int? CountNormal { get; set; }
        public string Name { get; set; }
        public string CREID { get; set; }
        public string ActionLevelText { get; set; }
        public int? ActionLevelID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public Guid? DealID { get; set; }
        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public string Summary { get; set; }
        public string StackTrace { get; set; }
        public string MethodName { get; set; }

    }
}


