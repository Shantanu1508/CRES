using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using System.Data;

namespace CRES.DAL.IRepository
{
   public interface IPeriodicRepository
    {
        DataTable GetAllPeriodicClose(Guid? PortfolioMasterGuid);
        int SaveAccountingbyOpenDate(string DealIDs, DateTime OpenDate, string UserID, string Comments);
        int SaveAccountingbyCloseDate(string DealIDs, DateTime closedate, string UserID, string Comments);
        DataTable GetAccountingCloseByDealId(string DealID, string UserID, int? pageSize, int? pageIndex, out int? TotalCount);
        DateTime? GetLastAccountingCloseDateByDealIDORNoteID(Guid? DealID, Guid? Noteid);
        void UpdatePeriodicCloseAzureBlobLink(PeriodicDataContract _periodicDC);
        void ImportIntoTransactionEntryClose(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? TagMasterID, Guid? AnalysisID);
    }
}
