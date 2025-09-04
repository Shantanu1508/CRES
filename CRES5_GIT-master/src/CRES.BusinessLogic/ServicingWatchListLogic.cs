using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net;
using System.Text;
using CRES.DAL.Repository;
using CRES.DataContract;
using System.Data;

namespace CRES.BusinessLogic
{
    public class ServicingWatchListLogic
    {
        ServicingWatchListRepository _repo = new ServicingWatchListRepository();
        public void InsertUpdatedServicingWatchlistAccounting(List<ServicingWatchlistDataContract> ServicingWatchlistAccounting)
        {
            _repo.InsertUpdatedServicingWatchlistAccounting(ServicingWatchlistAccounting);

        }
        public List<ServicingWatchlistDataContract> GetServicingWatchlistDealAccountingByDealID(string DealId)
        {
           return _repo.GetServicingWatchlistDealAccountingByDealID(DealId);
        }

        public List<ServicingWatchlistDataContract> GetServicingWatchlistDealLegalStatusByDealID(string DealId)
        {
            return _repo.GetServicingWatchlistDealLegalStatusByDealID(DealId);
        }

        public void InsertWLDealLegalStatusFromAPI(List<ServicingWatchlistDataContract> ServicingWatchlistLegalStatus)
        {
            _repo.InsertWLDealLegalStatusFromAPI(ServicingWatchlistLegalStatus);
        }

        public List<ServicingWatchlistDataContract> GetServicingWatchlistDealPotentialImpairmentByDealID(string DealId)
        {
            return _repo.GetServicingWatchlistDealPotentialImpairmentByDealID(DealId);
        }

        public void InsertUpdatedServicingWatchlistPotentialImpairment(DataTable ServicingWatchlistPotentialImpairment, string userid)
        {
            _repo.InsertUpdatedServicingWatchlistPotentialImpairment(ServicingWatchlistPotentialImpairment, userid);
        }


        public DataTable GetDealPotentialImpairmentByDealID(Guid? DealID, Guid? UserID)
        {
            return _repo.GetDealPotentialImpairmentByDealID(DealID, UserID);
        }

        public void DeleteServicingWatchlistPotentialImpairment(DataTable dtPotentialImpairmentData, string userid)
        {
            _repo.DeleteServicingWatchlistPotentialImpairment(dtPotentialImpairmentData, userid);

        }
    }
}
