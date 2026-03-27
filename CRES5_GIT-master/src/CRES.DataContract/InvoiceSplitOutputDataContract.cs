using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class InvoiceSplitOutputDataContract
    {
        public string DealID { get; set; }
        public string DealName { get; set; }
        public decimal SplitAmount { get; set; }
        public string QBAccountNo { get; set; }
        public string QBItemName { get; set; }
    }
}
