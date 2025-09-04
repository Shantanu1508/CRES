using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.BusinessLogic
{
    public class PayoffLogic
    {
        public DataSet GetPayoffAnalysisData(string DealID, DateTime PayoffDate, DateTime? ActualPayoffDate)
        {
            PayoffRepository pfRepo = new PayoffRepository();
            return pfRepo.GetPayoffAnalysisData(DealID, PayoffDate, ActualPayoffDate);
        }
    }
}
