using System;
using System.Collections.Generic;
using CRES.DataContract;
using System.Data;
namespace CRES.DAL.IRepository
{
    public interface IServicingWatchListRepository
    {
        void InsertUpdatedServicingWatchlistAccounting(List<ServicingWatchlistDataContract> ServicingWatchlistAccounting);
        List<ServicingWatchlistDataContract> GetServicingWatchlistDealAccountingByDealID(string DealId);

        void InsertWLDealLegalStatusFromAPI(List<ServicingWatchlistDataContract> ServicingWatchlistLegalStatus);
        List<ServicingWatchlistDataContract> GetServicingWatchlistDealLegalStatusByDealID(string DealId);

        List<ServicingWatchlistDataContract> GetServicingWatchlistDealPotentialImpairmentByDealID(string DealId);
        DataTable InsertUpdatedServicingWatchlistPotentialImpairment(DataTable dtPotentialImpairmentData, string UserID);
        DataTable GetDealPotentialImpairmentByDealID(Guid? DealID, Guid? UserID);
        void DeleteServicingWatchlistPotentialImpairment(DataTable dtPotentialImpairmentData, string UserID);
    }
}
