using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class XIRROutputDataContract
    {
		public int XIRROutputID { get; set; }
		public string XIRRConfigID { get; set; }
		public string ObjectType { get; set; }
		public string ObjectID { get; set; }
		public string ObjectName { get; set; }
		public string ReturnName { get; set; }
		public decimal XIRRValue { get; set; }
		public string AnalysisID { get; set; }
		public string CreatedBy { get; set; }
		public DateTime? CreatedDate { get; set; }
		public string UpdatedBy { get; set; }
		public DateTime? UpdatedDate { get; set; }

	}
}
