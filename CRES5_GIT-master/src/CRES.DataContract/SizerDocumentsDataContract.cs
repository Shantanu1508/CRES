using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class SizerDocumentsDataContract
    {
        public string CRENoteID { get; set; }
        public string DocLink { get; set; }
        public int DocTypeID { get; set; }
        public string DocTypeText { get; set; }
    }
}
