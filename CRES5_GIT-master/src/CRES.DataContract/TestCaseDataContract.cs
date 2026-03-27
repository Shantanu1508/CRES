using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class TestCaseDataContract
    {
        public System.Guid TestCasesID { get; set; }
        public string TestCasesName { get; set; }
        public string crenoteid { get; set; }
        public bool isRun { get; set; }
        public string userId { get; set; }
        public string ModuleName { get; set; }

    }
}
