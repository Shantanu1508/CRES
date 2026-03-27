using CRES.DAL.Helper;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CRES.DAL;

namespace CRES.BusinessLogic
{
    public class PeriodicLogic
    {
        private PeriodicRepository _periodicRepository = new PeriodicRepository();
        
        public DataTable GetAlPeriodicClose(Guid? PortfolioMasterGuid)
        {
            return _periodicRepository.GetAllPeriodicClose(PortfolioMasterGuid);
        }
        public int Openaccounting(DataTable dt, string UserID)
        {

            string DealIDs = "", Comments = "";
            DateTime OpenDate;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                DealIDs += dt.Rows[i]["CREDealID"] + "|";
            }
            OpenDate = Convert.ToDateTime(dt.Rows[0]["OpenDate"]);
            Comments = dt.Rows[0]["Comments"].ToString();
            return _periodicRepository.SaveAccountingbyOpenDate(DealIDs, OpenDate, UserID, Comments);
        }
        public int Closeaccounting(DataTable dt, string UserID)
        {
            string DealIDs = "",Comments="";
            DateTime CloseDate;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                DealIDs += dt.Rows[i]["CREDealID"] + "|";
            }
            CloseDate = Convert.ToDateTime(dt.Rows[0]["closeDate"]);
            Comments = dt.Rows[0]["Comments"].ToString();
            return _periodicRepository.SaveAccountingbyCloseDate(DealIDs, CloseDate, UserID,Comments);
        }
        public DataTable GetAccountingCloseByDealId(string DealID, string userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            return _periodicRepository.GetAccountingCloseByDealId(DealID, userId, pageSize, pageIndex, out TotalCount);
        }
        public int SaveDealAccountingByCloseDate(string str, string UserID)
        {
            string DealID = "", Comment = ""; ;
            DateTime CloseDate;
            var accclose = str.Split("|");
            DealID = accclose[0];
            CloseDate = Convert.ToDateTime(accclose[1]);
            Comment = accclose[2];
            return _periodicRepository.SaveAccountingbyCloseDate(DealID, CloseDate, UserID, Comment);
        }
        public int SaveDealAccountingByOpenDate(string str, string UserID)
        {
            string DealID = "", Comment = "";
            DateTime OpenDate;
            var accopen = str.Split("|");
            DealID = accopen[0];
            OpenDate = Convert.ToDateTime(accopen[1]);
            Comment = accopen[2];
            return _periodicRepository.SaveAccountingbyOpenDate(DealID, OpenDate, UserID, Comment);
        }
        public void UpdatePeriodicCloseAzureBlobLink(PeriodicDataContract _periodicDC)
        {
            _periodicRepository.UpdatePeriodicCloseAzureBlobLink(_periodicDC);
        }
        public void ImportIntoTransactionEntryClose(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? TagMasterID, Guid? AnalysisID)
        {

            _periodicRepository.ImportIntoTransactionEntryClose(StartDate, EndDate, PeriodId, userID, TagMasterID, AnalysisID);

        }
        public DateTime? GetLastAccountingCloseDateByDealIDORNoteID(Guid? DealID, Guid? Noteid)
        {
            return _periodicRepository.GetLastAccountingCloseDateByDealIDORNoteID(DealID, Noteid);
        }

    }
}
