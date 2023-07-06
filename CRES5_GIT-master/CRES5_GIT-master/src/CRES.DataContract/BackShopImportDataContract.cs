using System;

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
