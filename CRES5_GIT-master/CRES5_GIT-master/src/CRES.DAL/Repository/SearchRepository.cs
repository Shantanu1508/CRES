using System;
using System.Collections.Generic;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data;
#pragma warning disable CS0105 // The using directive for 'CRES.DAL.IRepository' appeared previously in this namespace
#pragma warning restore CS0105 // The using directive for 'CRES.DAL.IRepository' appeared previously in this namespace

using System.Data.SqlClient;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class SearchRepository : ISearchRepository
    {
        public List<SearchDataContract> GetAutosuggestSearchData(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();
            List<SearchDataContract> lstSearchDC = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@SearchKey", Value = serchKey };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetSearchBykey", sqlparam);

            //var lstSearchResult = dbContext.usp_GetSearchBykey(userID, pageIndex, pageSize, serchKey, totalCount);
            // var lstSearch = lstSearchResult.ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["ValueID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["Valuekey"]);
                _Searchdc.ValueType = CommonHelper.ToInt32(dr["ValueType"]);

                lstSearchDC.Add(_Searchdc);
            }

            return lstSearchDC;
        }


        //    public List<SearchDataContract> GetAutoCompleteSearchData(string Searchtext)
        //    {
        //        List<SearchDataContract> SearchResult = new List<SearchDataContract>();

        //        if (!string.IsNullOrWhiteSpace(Searchtext))
        //        {
        //            CRESEntities dbContext = new CRESEntities();

        //            var res = dbContext.usp_GetAutoCompleteSearchData(Searchtext);

        //            foreach (var b in res)
        //            {
        //                SearchDataContract sdc = new SearchDataContract();
        //                sdc.AccountID = b.AccountID.ToString();
        //                sdc.AccountType = b.AccountType;
        //                sdc.Name = b.Name;

        //                SearchResult.Add(sdc);
        //            }
        //        }

        //        return SearchResult;
        //    }

        public List<SearchDataContract> GetAutoSearchDataPIKAccount(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();
            List<SearchDataContract> lstPikAccount = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@SearchKey", Value = serchKey };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetSearchPIKAccountBykey", sqlparam);

            //var lstSearchResult = dbContext.usp_GetSearchPIKAccountBykey(userID, pageIndex, pageSize, serchKey, totalCount);
            // var lstSearchpik = lstSearchResult.ToList();
            //if (totalCount != null)
            //    TotalCount = Convert.ToInt32(totalCount.Value);
            //else
            TotalCount = 0;

            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["ValueID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["Valuekey"]);
                //   _Searchdc.ValueType = _search.ValueType;

                lstPikAccount.Add(_Searchdc);
            }
            return lstPikAccount;

        }

        public void UpdateRankInSearchItem(System.Guid? ObjectID, string SearchText)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = ObjectID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@SearchText", Value = SearchText.Trim() };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("App.usp_UpdateRankInSearchItem", sqlparam);
            // var UpdateResult = dbContext.usp_UpdateRankInSearchItem(ObjectID, SearchText.Trim());
        }

        public List<SearchDataContract> GetAutosuggestSearchDeal(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();
            List<SearchDataContract> lstSearchDC = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@SearchKey", Value = serchKey };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetSearchDealBykey", sqlparam);


            //  var lstSearchdealResult = dbContext.usp_GetSearchDealBykey(userID, pageIndex, pageSize, serchKey, totalCount);
            //  var lstSearch = lstSearchdealResult.ToList();
            // TotalCount = Convert.ToInt32(totalCount.Value);
            TotalCount = 0;
            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["ValueID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["Valuekey"]);

                lstSearchDC.Add(_Searchdc);
            }

            return lstSearchDC;
        }

        public List<SearchDataContract> GetAutosuggestSearchUserName(System.Guid? userID, int? pageIndex, int? pageSize, string serchKey, out int? TotalCount)
        {
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();
            List<SearchDataContract> lstSearchDC = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@SearchKey", Value = serchKey };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetSearchUserNameBykey", sqlparam);

            //var lstSearchdealResult = dbContext.usp_GetSearchUserNameBykey(userID, pageIndex, pageSize, serchKey, totalCount);
            // var lstSearch = lstSearchdealResult.ToList();
            // TotalCount = Convert.ToInt32(totalCount.Value);
            TotalCount = 0;
            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["ValueID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["Valuekey"]);

                lstSearchDC.Add(_Searchdc);
            }

            return lstSearchDC;
        }
    }
}