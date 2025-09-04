using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using CRES.DAL.IRepository;
using CRES.DAL.IRepository;

namespace CRES.DAL.Repository
{
    public class NoteTransactionDetailRepository :  INoteTransactionDetail
    {
        public int InsertUpdateServicelog(List<NoteServicingLogDataContract> lstServicelogdc,string noteId)
        {
            int result = 0;
            //#Remaining#


            //NoteTransactionDetail _servicelog = new NoteTransactionDetail();
            //foreach (NoteServicingLogDataContract _ServicingLogdc in lstServicelogdc)
            //{
                
            //    _servicelog.NoteID =new Guid(noteId);
            //    _servicelog.TransactionDate = _ServicingLogdc.TransactionDate;
            //    _servicelog.Amount = _ServicingLogdc.TransactionAmount;
            //    _servicelog.ModeledPayment = _ServicingLogdc.ModeledPayment;
            //    _servicelog.TransactionType = _ServicingLogdc.TransactionType;
            //    _servicelog.RelatedtoModeledPMTDate = _ServicingLogdc.RelatedtoModeledPMTDate;
            
            //    _servicelog.AmountOutstandingafterCurrentPayment = _ServicingLogdc.AmountOutstandingafterCurrentPayment;

               
            //    if (_ServicingLogdc.TransactionId.ToString() != "00000000-0000-0000-0000-000000000000")
            //    {
            //        _servicelog.NoteTransactionDetailID = _ServicingLogdc.TransactionId;
            //        _servicelog.UpdatedBy = _ServicingLogdc.UpdatedBy;
            //        _servicelog.UpdatedDate = DateTime.Now;
            //    //    dbContext.NoteTransactionDetails.State = EntityState.Modified;
                
            //        result = dbContext.SaveChanges();
            //    }
            //    else
            //    {
            //        _servicelog.NoteTransactionDetailID = Guid.NewGuid();
            //        _servicelog.CreatedBy = _ServicingLogdc.CreatedBy;
            //        _servicelog.CreatedDate = DateTime.Now;
            //        dbContext.NoteTransactionDetails.Add(_servicelog);
            //        result= dbContext.SaveChanges();
            //    }
            //}
            return result;

        }

    }
}
