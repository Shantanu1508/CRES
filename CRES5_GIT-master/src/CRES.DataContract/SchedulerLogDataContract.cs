using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class SchedulerLogDataContract
    {
		 public int SchedulerLogID { get; set; }
		 public int SchedulerConfigID { get; set; }
		public string Message { get; set; }
		 public DateTime? StartTime { get; set; }
		 public DateTime? EndTime { get; set; }
		 public string GeneratedBy { get; set; }
		 public DateTime CreatedDate { get; set; }
	}
}
