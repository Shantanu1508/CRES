using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BackShopImportDataContract
    {
        public string DealID { get; set; }
        public string DealName { get; set; }
        public string UserName { get; set; }

        public Guid? BatchLogID { get; set; }
        

    }
}
