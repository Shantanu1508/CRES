using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
  public class LookupDataContract
    {
        public int LookupID { get; set; }
        public int ParentID { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public short SortOrder { get; set; }
        public int StatusID { get; set; }
        public string LookupIDGuID { get; set; }
        public string AccountTypeId { get; set; }
        public string AssetIdName { get; set; }
        public string Type { get; set; }
        public int AssetOrLiability { get; set; }
        public string DebtEquityType { get; set; }
        public string TableGUID { get; set; }
    }
}
