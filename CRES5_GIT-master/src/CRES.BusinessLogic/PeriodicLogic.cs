using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class PeriodicLogic
    {
        private PeriodicRepository _periodicRepository = new PeriodicRepository();

        public List<PeriodicDataContract> GetPeriodicCloseByUserID(Guid? userID, Guid? AnalysisID)
        {
            return _periodicRepository.GetPeriodicCloseByUserID(userID, AnalysisID);
        }

        public Guid? SavePeriodicClose(DateTime? StartDate, DateTime? EndDate, string AzureBlobLink, Guid? userID, Guid? AnalysisID)
        {
            return _periodicRepository.SavePeriodicClose(StartDate, EndDate, AzureBlobLink, userID, AnalysisID);
        }


        public void ImportIntoPeriodCloseArchive(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? AnalysisID)
        {

            _periodicRepository.ImportIntoPeriodCloseArchive(StartDate, EndDate, PeriodId, userID, AnalysisID);

        }

        public void UpdatePeriodicCloseAzureBlobLink(PeriodicDataContract _periodicDC)
        {
            _periodicRepository.UpdatePeriodicCloseAzureBlobLink(_periodicDC);
        }


        public void ImportIntoTransactionEntryClose(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? TagMasterID, Guid? AnalysisID)
        {

            _periodicRepository.ImportIntoTransactionEntryClose(StartDate, EndDate, PeriodId, userID, TagMasterID, AnalysisID);

        }

        public void OpenPeriodicClose(Guid? userID, PeriodicDataContract _periodicDC)
        {
            _periodicRepository.OpenPeriodicClose(userID, _periodicDC);

        }
        public void DeleteTagMasterTransactionEntryClose(Guid? userID, PeriodicDataContract _periodicDC)
        {
            _periodicRepository.DeleteTagMasterTransactionEntryClose(userID, _periodicDC);
        }
    }
}
