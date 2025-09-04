using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;

namespace CRES.DAL.IRepository
{
   public interface INoteTransactionDetail
    {
        int InsertUpdateServicelog(List<NoteServicingLogDataContract> lstServicelogdc, string noteId);
    }
}
