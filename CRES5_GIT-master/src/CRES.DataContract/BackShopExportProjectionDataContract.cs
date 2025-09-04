using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class BackShopExportProjectionDataContract
    {
        public string NoteId { get; set; }       
        public List<BackShopNoteProjectionDataContract> NoteProjectedPayments { get; set; }
    }
}
