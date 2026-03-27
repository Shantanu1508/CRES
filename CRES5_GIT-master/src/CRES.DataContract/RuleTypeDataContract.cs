using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class RuleTypeDataContract
    {
        public int? RuleTypeMasterID { get; set; }
        public string RuleTypeName { get; set; }        
        public int? RuleTypeDetailID { get; set; }
        public string FileName { get; set; }
        public string Type { get; set; }
        public string Comments { get; set; }
        public string DBFileName { get; set; }
        public string Content { get; set; }
        public bool IsBalanceAware { get; set; }

        public string OriginalFileName { get; set; }

    }
}
