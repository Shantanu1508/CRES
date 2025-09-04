
using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface ISearchRepository 
    {
        List<SearchDataContract> GetAutosuggestSearchData(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount);


        List<SearchDataContract> GetAutosuggestSearchUserName(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount);

        //List<SearchDataContract> GetAutoCompleteSearchData(string Searchtext);
    }
}