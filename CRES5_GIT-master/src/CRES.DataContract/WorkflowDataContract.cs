using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WorkflowDataContract
    {
        public string Name { get; set; }
        public string FirstTask { get; set; }
        public string FirstTaskTime { get; set; }

        public string SecondTask { get; set; }
        public string SecondTaskTime { get; set; }
        public string TaskStatus { get; set; }        

    }
}
