using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class UserDelegateRepository : IUserDelegateRepository
    {
        public string InsertDelegateConfiguration(UserDelegationConfigDataContract udd)
        {
            string result = "";
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@userID", Value = udd.UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@delegatedUserID", Value = udd.DelegatedUserID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@startdate", Value = udd.Startdate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@enddate", Value = udd.Enddate };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("dbo.usp_InsertUserDelegateConfig", sqlparam);

                //var res = dbContext.usp_InsertUserDelegateConfig(
                //    udd.UserID,
                //    udd.DelegatedUserID,
                //    udd.Startdate,
                //    udd.Enddate
                //     );
                result = "TRUE";

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        public List<UserDelegationConfigDataContract> GetAllActiveDelegatedUser(Guid userid)
        {
            try
            {
                DataTable dt = new DataTable();
                List<UserDelegationConfigDataContract> _list = new List<UserDelegationConfigDataContract>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@userID", Value = userid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAllActiveDelegatedUser", sqlparam);

                //var dellist = dbContext.usp_GetAllActiveDelegatedUser(userid);
                foreach (DataRow dr in dt.Rows)
                {
                    UserDelegationConfigDataContract tdc = new UserDelegationConfigDataContract();
                    if (Convert.ToString(dr["DelegatedUserID"]) != "")
                    {
                        tdc.DelegatedUserID = new Guid(Convert.ToString(dr["DelegatedUserID"]));
                    }
                    if (Convert.ToString(dr["UserID"]) != "")
                    {
                        tdc.UserID = new Guid(Convert.ToString(dr["UserID"]));
                    }
                    if (Convert.ToString(dr["UserDelegateConfigID"]) != "")
                    {
                        tdc.UserDelegateConfigID = new Guid(Convert.ToString(dr["UserDelegateConfigID"]));
                    }
                    tdc.Startdate = CommonHelper.ToDateTime(dr["StartDate"]);
                    tdc.Enddate = CommonHelper.ToDateTime(dr["EndDate"]);
                    tdc.IsActive = CommonHelper.ToBoolean(dr["IsActive"]);
                    tdc.DelegatedUserIDText = Convert.ToString(dr["DelegatedUserIDText"]);

                    _list.Add(tdc);
                }

                return _list;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<UserDelegationConfigDataContract> GetUsersToImpersonate(Guid? userid)
        {
            try
            {
                DataTable dt = new DataTable();
                List<UserDelegationConfigDataContract> _list = new List<UserDelegationConfigDataContract>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@userID", Value = userid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetUsersToImpersonate", sqlparam);
                // var dellist = dbContext.usp_GetUsersToImpersonate(userid);
                foreach (DataRow dr in dt.Rows)
                {
                    UserDelegationConfigDataContract tdc = new UserDelegationConfigDataContract();
                    if (Convert.ToString(dr["DelegatedUserID"]) != "")
                    {
                        tdc.DelegatedUserID = new Guid(Convert.ToString(dr["DelegatedUserID"]));
                    }
                    if (Convert.ToString(dr["UserID"]) != "")
                    {
                        tdc.UserID = new Guid(Convert.ToString(dr["UserID"]));
                    }
                    tdc.UserIDText = Convert.ToString(dr["UserIDText"]);
                    //if (Convert.ToString(dr["UserDelegateConfigID"]) != "")
                    //{
                    //    tdc.UserDelegateConfigID = new Guid(Convert.ToString(dr["UserDelegateConfigID"]));
                    //}
                    //tdc.Startdate = CommonHelper.ToDateTime(dr["StartDate"]);
                    //tdc.Enddate = CommonHelper.ToDateTime(dr["EndDate"]);
                    tdc.IsActive = CommonHelper.ToBoolean(dr["IsActive"]);
                    tdc.DelegatedUserIDText = Convert.ToString(dr["DelegatedUserIDText"]);



                    _list.Add(tdc);
                }

                return _list;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string InsertDelegateHistory(UserDelegationConfigDataContract udc)
        {
            try
            {
                string res = "";
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@delegatedUserID", Value = udc.DelegatedUserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@userID", Value = udc.UserID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@entryType", Value = udc.EntryType };
                SqlParameter p4 = new SqlParameter { ParameterName = "@requestType", Value = udc.RequestType };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("dbo.usp_InsertDelegateHistory", sqlparam);

                //dbContext.usp_InsertDelegateHistory(
                //      udc.DelegatedUserID,
                //      udc.UserID,
                //      udc.EntryType,
                //      udc.RequestType
                //      );

                res = "TRUE";
                return res;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool RevokeUserDelegateConfigByUserDelegateConfigID(Guid userDelegateConfigID)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@userDelegateConfigID", Value = userDelegateConfigID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecNonquery("dbo.usp_RevokeUserDelegateConfigByUserDelegateConfigID", sqlparam);
                // dbContext.usp_RevokeUserDelegateConfigByUserDelegateConfigID(userDelegateConfigID);
                return true;
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }
        public int ImpersonateUserCount(Guid UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetImpersonateUserCountByUserId", sqlparam);
            var totalcount = dt.Rows[0]["TotalCount"];
            return Convert.ToInt32(totalcount);
        }
    }
}