using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    internal interface IPayoffRepository
    {
        DataSet GetPayoffAnalysisData(string DealID, DateTime PayoffDate, DateTime? ActualPayoffDate);

        int GetPayoffEmailToSendCount();
        DataTable GetPayoffEmailData();
        void UpdateCalculationRequestSetIsEmailSentToYes(string CalculationRequestID);
    }
}
