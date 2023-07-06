using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    interface IPeriodicRepository
    {
        List<PeriodicDataContract> GetPeriodicCloseByUserID(Guid? userID, Guid? AnalysisID);

        Guid? SavePeriodicClose(DateTime? StartDate, DateTime? EndDate, string AzureBlobLink, Guid? userID, Guid? AnalysisID);

        void ImportIntoPeriodCloseArchive(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? AnalysisID);
        void UpdatePeriodicCloseAzureBlobLink(PeriodicDataContract _periodicDC);
        void OpenPeriodicClose(Guid? userID, PeriodicDataContract _periodicDC);
        void DeleteTagMasterTransactionEntryClose(Guid? userID, PeriodicDataContract _periodicDC);
    }
}
