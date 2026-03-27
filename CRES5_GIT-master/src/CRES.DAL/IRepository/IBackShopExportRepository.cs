using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IBackShopExportRepository
    {
        DataTable ExportFFandPIKgetrecordsforJson(string DealID, string NoteID, string userName, string flag);
        void ExportFFandPIKUpdateStatus(string DealID, string NoteID, string Status, string userName, string UpdateFor);
        void VerifyFutureFundingM61andBackshop(string DealID, string NoteID, string userName, string verificationFor);
        void ExportPIKPrincipalFromCRES_API(string CRENoteID, string CreatedBy);
    }
}
