using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface INoteTransactionDetail
    {
        int InsertUpdateServicelog(List<NoteServicingLogDataContract> lstServicelogdc, string noteId);
    }
}
