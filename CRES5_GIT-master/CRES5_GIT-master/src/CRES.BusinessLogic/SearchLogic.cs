using CRES.DAL.Repository;
using CRES.DataContract;
using System.Collections.Generic;


namespace CRES.BusinessLogic
{
    public class SearchLogic
    {

        SearchRepository SearchRepository = new SearchRepository();

        public List<SearchDataContract> GetAutosuggestSearchData(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            return SearchRepository.GetAutosuggestSearchData(userID, pageIndex, pageSize, serchKey, out TotalCount);
        }

        //public List<SearchDataContract> GetSearchData(string query)
        //{

        //    return SearchRepository.GetAutoCompleteSearchData(query);

        //}


        public List<SearchDataContract> GetAutoSearchDataPIKAccount(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            return SearchRepository.GetAutoSearchDataPIKAccount(userID, pageIndex, pageSize, serchKey, out TotalCount);
        }



        public void UpdateRankInSearchItem(System.Guid? ObjectID, string SearchText)
        {

            SearchRepository.UpdateRankInSearchItem(ObjectID, SearchText);
        }


        public List<SearchDataContract> GetAutosuggestSearchDeal(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            return SearchRepository.GetAutosuggestSearchDeal(userID, pageIndex, pageSize, serchKey, out TotalCount);
        }

        public List<SearchDataContract> GetAutosuggestUserName(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            return SearchRepository.GetAutosuggestSearchUserName(userID, pageIndex, pageSize, serchKey, out TotalCount);
        }


    }
}
