using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BackShopExportDataContract
    {
        public string NoteId { get; set; }
        public string Type { get; set; }        
        public List<BackShopNoteFundingsDataContract> NoteFundings { get; set; }
    }
}
