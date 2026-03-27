using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class JsonFormatCalcLiability
    {
        public int? JsonFormatCalcLiabilityID { get; set; }
        public string Position { get; set; }
        public string Key { get; set; }
        public string KeyFormat { get; set; }
        public string DataType { get; set; }
        public bool IsActive { get; set; }
        public int? ParentID { get; set; }
        public string FilterBy { get; set; }
        public string DynamicField { get; set; }
        public string DynamicFieldValue { get; set; }
        public string ParentDynamicField { get; set; }
        public bool IsOptional { get; set; }
    }

    public class LiabilityCalcDataContract
    {
        public int? value { get; set; }
        public string Name { get; set; }
        public DateTime? vDate { get; set; }
        public string LiabilityID { get; set; }
        public string LiabilityName { get; set; }
        public int? StatusID { get; set; }
        public DateTime? RequestTime { get; set; }
        public string ProcessType { get; set; }
        public string ErrorMessage { get; set; }
        public string ScenarioID { get; set; }
        public Guid? UserID { get; set; }
        public string CalcStatus { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string RequestBy { get; set; }
        public int? IsEnable { get; set; }
        public string CalcEngineTypeText { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? Count { get; set; }
        public DateTime? Date { get; set; }
        public string IsChart { get; set; }
        public Guid? AccountID { get; set; }
        public bool Active { get; set; }

    }

}
