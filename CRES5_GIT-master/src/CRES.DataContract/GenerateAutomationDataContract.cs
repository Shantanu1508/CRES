using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class GenerateAutomationDataContract
    {
        public int? AutomationRequestsID { get; set; } 
        public string DealID { get; set; }
        public int? BatchID { get; set; }
        public string StatusText { get; set; }
        public int? AutomationType { get; set; }
        public string AutomationTypeText { get; set; }        
        public string BatchType { get; set; }
        public string CreatedBy { get; set; }
        
    }
}
