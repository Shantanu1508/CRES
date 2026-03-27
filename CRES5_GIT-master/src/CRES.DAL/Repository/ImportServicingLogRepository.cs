using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using System.Data;

namespace CRES.DAL.Repository
{
   public class ImportServicingLogRepository 
    {
        //public int ImportIntoINServicingTransaction(List<ServicingLogDataContract> lstServicingLog)
        //{


        //    return 0;
        //}


        public int ImportIntoINServicingTransaction(DataTable dtservice, string userId, string sourceBlobFileName, string fileDisplayName,string storagetype, string _startdate, string _enddate)
        {
            Helper.Helper hp = new Helper.Helper();
            int res = hp.ExecDataTableServingLog("dbo.usp_ImportIntoINServicingTransaction", dtservice, userId, sourceBlobFileName, fileDisplayName, storagetype, _startdate, _enddate);
            return res;
        }
    }
}
