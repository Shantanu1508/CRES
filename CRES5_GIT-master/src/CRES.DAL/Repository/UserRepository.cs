using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CRES.DataContract;
using CRES.DAL.IRepository;

using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using CRES.Utilities;
using Microsoft.Extensions.Options;
using System.Net;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Math;
using Azure;

namespace CRES.DAL.Repository
{
    public class UserRepository : IUserRepository
    {
        public UserDataContract ValidateUser(UserDataContract Userobj)
        {
            DataTable dt = new DataTable();          
            UserDataContract _userdatacontract = new UserDataContract();

            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@Login", Value = Userobj.Login };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Password", Value = Userobj.Password };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("App.usp_ValidateUser", sqlparam);

                List<UserDataContract> lstuser = new List<UserDataContract>();
                if (dt.Rows.Count > 0)
                {

                    foreach (DataRow dr in dt.Rows)
                    {
                        if (Convert.ToString(dr["UserID"]) != "")
                        _userdatacontract.UserID = new Guid(Convert.ToString(dr["UserID"]));
                        _userdatacontract.FirstName = Convert.ToString(dr["FirstName"]);
                        _userdatacontract.LastName = Convert.ToString(dr["LastName"]);
                        _userdatacontract.Email = Convert.ToString(dr["Email"]);
                        _userdatacontract.Login = Convert.ToString(dr["Login"]);
                        _userdatacontract.Password = Convert.ToString(dr["Password"]);
                        _userdatacontract.ExpirationDate = CommonHelper.ToDateTime(dr["ExpirationDate"]);
                        _userdatacontract.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                        _userdatacontract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        _userdatacontract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                        _userdatacontract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        _userdatacontract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                        _userdatacontract.RoleID = new Guid(Convert.ToString(dr["roleId"]));
                        _userdatacontract.RoleName = Convert.ToString(dr["RoleName"]);
                        _userdatacontract.ContactNo1 = Convert.ToString(dr["ContactNo1"]);
                        _userdatacontract.UserToken = Convert.ToString(dr["UserToken"]);
                        _userdatacontract.TimeZone = Convert.ToString(dr["TimeZone"]);
                    }

                }
                if (lstuser.Count() > 0)
                {
                    _userdatacontract = lstuser.FirstOrDefault();
                }

                if (_userdatacontract.UserID == null)
                {
                    _userdatacontract = null;
                }
                return _userdatacontract;
            }
            catch (Exception ex)
            {

            }
            return _userdatacontract;
        }

        public UserDataContract GetUserCredentialByUserID(Guid UserID, Guid? DelegatedUserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DelegateUserID", Value = DelegatedUserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("App.usp_GetUserCredentialByUserID", sqlparam);

            List<UserDataContract> lstuser = new List<UserDataContract>();           

            UserDataContract _userdatacontract = new UserDataContract();
            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["UserID"]) != "")
                    _userdatacontract.UserID = new Guid(Convert.ToString(dr["UserID"]));
                _userdatacontract.FirstName = Convert.ToString(dr["FirstName"]);
                _userdatacontract.LastName = Convert.ToString(dr["LastName"]);
                _userdatacontract.Email = Convert.ToString(dr["Email"]);
                _userdatacontract.Login = Convert.ToString(dr["Login"]);
                _userdatacontract.Password = Convert.ToString(dr["Password"]);
                _userdatacontract.ExpirationDate = Convert.ToDateTime(dr["ExpirationDate"]);
                _userdatacontract.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                _userdatacontract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _userdatacontract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _userdatacontract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _userdatacontract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _userdatacontract.ContactNo1 = Convert.ToString(dr["ContactNo1"]);
                _userdatacontract.UserToken = Convert.ToString(dr["UserToken"]);
                _userdatacontract.TimeZone = Convert.ToString(dr["Timezone"]);
            }

            if (_userdatacontract.UserID == null)
            {
                _userdatacontract = null;
            }

            return _userdatacontract;
        }

        public bool ChangePassword(Guid? userid, string oldpassword, string newpassword)
        {
            bool retValue = false;
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@OldPassword", Value = oldpassword };
            SqlParameter p3 = new SqlParameter { ParameterName = "@NewPassword", Value = newpassword };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            int count = hp.ExecNonquery("App.usp_UpdatePassword", sqlparam);
            if (count == 1)
            {
                retValue = true;
            }
            return retValue;
        }

        public bool ResetPasswordByAuthenticationKey(string authenticationKey, string newpassword)
        {

            bool retValue = false;
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AuthenticationKey", Value = authenticationKey };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NewPassword", Value = newpassword };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            int count = hp.ExecNonquery("App.usp_ResetPasswordByAuthenticationKey", sqlparam);
            if (count == 1)
            {
                retValue = true;
            }
            return retValue;
        }

        public int UpdateUserCredentialByUserID(UserDataContract Userobj)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = Userobj.UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FirstName", Value = Userobj.FirstName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@LastName", Value = Userobj.LastName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@Email", Value = Userobj.Email };
            SqlParameter p5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = Userobj.FirstName };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            int count = hp.ExecNonquery("App.usp_UpdateUserCredentialByUserID", sqlparam);
            return count;
        }
        public UserDataContract getUserpwdfromemil(string emailid)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@emailid", Value = emailid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("App.usp_GetUserinfofromemailId", sqlparam);

            UserDataContract _userdatacontract = new UserDataContract();

            if (dt != null && dt.Rows.Count > 0)
            {
                _userdatacontract.Login = Convert.ToString(dt.Rows[0]["Login"]);
                _userdatacontract.Password = Convert.ToString(dt.Rows[0]["Password"]);
                
            }
            return _userdatacontract;

        }

        public List<UserDefaultSettingDataContract> GetUserDefaultSettingByUserID(Guid UserID)
        {

            List<UserDefaultSettingDataContract> _userDSdc = new List<UserDefaultSettingDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetUserDefaultSettingByUserID", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    UserDefaultSettingDataContract _userdefaultsettingdc = new UserDefaultSettingDataContract();
                    _userdefaultsettingdc.UserDefaultSettingID = new Guid(Convert.ToString(dr["UserDefaultSettingID"]));
                    _userdefaultsettingdc.UserID = new Guid(Convert.ToString(dr["UserID"]));
                    _userdefaultsettingdc.Type = CommonHelper.ToInt32(dr["Type"]);
                    _userdefaultsettingdc.TypeText = Convert.ToString(dr["TypeText"]);
                    _userdefaultsettingdc.Value = Convert.ToString(dr["Value"]);
                    _userdefaultsettingdc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _userdefaultsettingdc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _userdefaultsettingdc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _userdefaultsettingdc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                    _userDSdc.Add(_userdefaultsettingdc);
                }
            }
            return _userDSdc;
        }

        public bool InsertUpdateUserDefaultSetting(Guid? userid, string type, string value)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = userid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Type", Value = type };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Value", Value = value };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = userid.ToString() };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            int count = hp.ExecNonquery("dbo.usp_InsertUpdateUserDefaultSetting", sqlparam);
            return true;
        }

        public List<UserDataContract> GetAllUsers()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("App.usp_GetAllUsers");

            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    UserDataContract _userdatacontract = new UserDataContract();
                    if (Convert.ToString(dr["UserID"]) != "")
                        _userdatacontract.UserID = new Guid(Convert.ToString(dr["UserID"]));
                    _userdatacontract.FirstName = Convert.ToString(dr["FirstName"]);
                    _userdatacontract.LastName = Convert.ToString(dr["LastName"]);
                    _userdatacontract.Email = Convert.ToString(dr["Email"]);
                    _userdatacontract.Login = Convert.ToString(dr["Login"]);
                    _userdatacontract.Password = Convert.ToString(dr["Password"]);
                    _userdatacontract.ExpirationDate = CommonHelper.ToDateTime(dr["ExpirationDate"]);
                    _userdatacontract.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                    _userdatacontract.RoleID = CommonHelper.ToGuid(dr["roleId"]);
                    _userdatacontract.RoleName = Convert.ToString(dr["RoleName"]);
                    _userdatacontract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _userdatacontract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _userdatacontract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _userdatacontract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _userdatacontract.Status = Convert.ToString(dr["Status"]);
                    _userdatacontract.ContactNo1 = Convert.ToString(dr["ContactNo1"]);
                    //_userdatacontract.UserToken = Convert.ToString(dr["UserToken"]);
                    _userdatacontract.TimeZone = Convert.ToString(dr["TimeZone"]);

                    _userdatacontractlst.Add(_userdatacontract);
                }
            }
            return _userdatacontractlst;
        }



        public List<UserDataContract> GetUsersforAzureAD()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("App.usp_GetAllUsersForAzureAD");

            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    UserDataContract _userdatacontract = new UserDataContract();
                    if (Convert.ToString(dr["UserID"]) != "")
                        _userdatacontract.UserID = new Guid(Convert.ToString(dr["UserID"]));
                    _userdatacontract.FirstName = Convert.ToString(dr["FirstName"]);
                    _userdatacontract.LastName = Convert.ToString(dr["LastName"]);
                    _userdatacontract.Email = Convert.ToString(dr["Email"]);
                    _userdatacontract.Login = Convert.ToString(dr["Login"]);
                    _userdatacontract.Password = Convert.ToString(dr["Password"]);
                    _userdatacontract.ExpirationDate = CommonHelper.ToDateTime(dr["ExpirationDate"]);
                    _userdatacontract.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                    _userdatacontract.RoleID = CommonHelper.ToGuid(dr["roleId"]);
                    _userdatacontract.RoleName = Convert.ToString(dr["RoleName"]);
                    _userdatacontract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _userdatacontract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _userdatacontract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _userdatacontract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _userdatacontract.Status = Convert.ToString(dr["Status"]);
                    _userdatacontract.ContactNo1 = Convert.ToString(dr["ContactNo1"]);
                    //_userdatacontract.UserToken = Convert.ToString(dr["UserToken"]);
                    _userdatacontract.TimeZone = Convert.ToString(dr["TimeZone"]);

                    _userdatacontractlst.Add(_userdatacontract);
                }
            }
            return _userdatacontractlst;
        }

        public int AddUpdateUser(List<UserDataContract> _userDataContract)
        {
            foreach (var Userobj in _userDataContract)
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = Userobj.UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@firstName", Value = Userobj.FirstName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@lastName", Value = Userobj.LastName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@email", Value = Userobj.Email };
                SqlParameter p5 = new SqlParameter { ParameterName = "@login", Value = Userobj.Login };
                SqlParameter p6 = new SqlParameter { ParameterName = "@password", Value = Userobj.Password };
                SqlParameter p7 = new SqlParameter { ParameterName = "@expirationDate", Value = Userobj.ExpirationDate };
                SqlParameter p8 = new SqlParameter { ParameterName = "@statusId", Value = Userobj.StatusID };
                SqlParameter p9 = new SqlParameter { ParameterName = "@roleId", Value = Userobj.RoleID };
                SqlParameter p10 = new SqlParameter { ParameterName = "@ContactNo1", Value = Userobj.ContactNo1 };
                SqlParameter p11 = new SqlParameter { ParameterName = "@updatedBy", Value = Userobj.UpdatedBy };
                SqlParameter p12 = new SqlParameter { ParameterName = "@TimeZone", Value = Userobj.TimeZone };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12 };

                int count = hp.ExecNonquery("App.usp_AddUpdateUser", sqlparam);
            }
            return 1;
        }

        public int ResetUserPassword(UserDataContract _userDataContract)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = _userDataContract.UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@password", Value = _userDataContract.Password };
            SqlParameter p3 = new SqlParameter { ParameterName = "@updatedBy", Value = _userDataContract.UpdatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            int count = hp.ExecNonquery("App.usp_ResetUserPassword", sqlparam);
            return count;
        }

        public List<UserDataContract> UserForgotPassword(UserDataContract _userDataContract)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserLogin", Value = _userDataContract.UserLogin };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AuthenticationKey", Value = _userDataContract.AuthenticationKey };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("App.usp_UserForgotPassword", sqlparam);

            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();

            foreach (DataRow dr in dt.Rows)
            {
                UserDataContract _userdatacontract = new UserDataContract();
                _userdatacontract.FirstName = Convert.ToString(dr["FullName"]);
                _userdatacontract.Email = Convert.ToString(dr["Email"]);
                _userdatacontractlst.Add(_userdatacontract);
            }
            return _userdatacontractlst;
        }

        public List<string> GetEmailIdsByModule(int moduleid)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ModuleId", Value = moduleid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetEmailIdsForEmailNotification", sqlparam);
            List<string> bccemails = new List<string>();

            foreach (DataRow dr in dt.Rows)
            {
                bccemails.Add(Convert.ToString(dr["EmailId"]));
            }
            return bccemails;
        }
        public string GetUserEmailByUserName(string username)
        {
            string email = "";
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@LoginName", Value = username };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetEmailByLoginName", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                email = Convert.ToString(dr["Email"]);

            }
            return email;
        }

        public List<UserDataContract> GetUsersByRoleName(string RoleName)
        {

            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RoleName", Value = RoleName };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("App.usp_GetUsersByRoleName", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                UserDataContract _userdatacontract = new UserDataContract();
                _userdatacontract.UserID = new Guid(Convert.ToString(dr["UserID"]));
                _userdatacontract.FirstName = Convert.ToString(dr["FirstName"]);
                _userdatacontract.LastName = Convert.ToString(dr["LastName"]);
                _userdatacontract.Email = Convert.ToString(dr["Email"]);
                _userdatacontract.Login = Convert.ToString(dr["Login"]);
                _userdatacontract.Password = Convert.ToString(dr["Password"]);
                _userdatacontract.ExpirationDate = CommonHelper.ToDateTime(dr["ExpirationDate"]);
                _userdatacontract.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                _userdatacontract.RoleID = new Guid(Convert.ToString(dr["roleId"]));
                _userdatacontract.RoleName = Convert.ToString(dr["RoleName"]);
                _userdatacontract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _userdatacontract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _userdatacontract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _userdatacontract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _userdatacontract.Status = Convert.ToString(dr["Status"]);
                _userdatacontractlst.Add(_userdatacontract);
            }

            return _userdatacontractlst;
        }

        public List<UserDataContract> GetUsersInfoByRoleNameForDropDown(string RoleName)
        {

            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RoleName", Value = RoleName };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("App.usp_GetUsersInfoByRoleNameForDropDown", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                UserDataContract _userdatacontract = new UserDataContract();
                _userdatacontract.UserID = new Guid(Convert.ToString(dr["UserID"]));
                _userdatacontract.FirstName = Convert.ToString(dr["FirstName"]);
                _userdatacontract.LastName = Convert.ToString(dr["LastName"]);
                _userdatacontractlst.Add(_userdatacontract);
            }

            return _userdatacontractlst;
        }

        public bool ForceLogout(Guid? userID)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@userID", Value = userID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecNonquery("dbo.usp_ForceLogout", sqlparam);

            return true;
        }


        public int UpdateUserByUserID(UserDataContract _userDataContract)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = _userDataContract.UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@firstName", Value = _userDataContract.FirstName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@lastName", Value = _userDataContract.LastName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@email", Value = _userDataContract.Email };
            SqlParameter p5 = new SqlParameter { ParameterName = "@login", Value = _userDataContract.Login };
            SqlParameter p6 = new SqlParameter { ParameterName = "@password", Value = _userDataContract.Password };
            SqlParameter p7 = new SqlParameter { ParameterName = "@expirationDate", Value = _userDataContract.ExpirationDate };
            SqlParameter p8 = new SqlParameter { ParameterName = "@statusId", Value = _userDataContract.StatusID };
            SqlParameter p9 = new SqlParameter { ParameterName = "@roleId", Value = _userDataContract.RoleID };
            SqlParameter p10 = new SqlParameter { ParameterName = "@ContactNo1", Value = _userDataContract.ContactNo1 };
            SqlParameter p11 = new SqlParameter { ParameterName = "@updatedBy", Value = _userDataContract.UpdatedBy };
            SqlParameter p12 = new SqlParameter { ParameterName = "@TimeZone", Value = _userDataContract.TimeZone };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12 };

            int count = hp.ExecNonquery("App.usp_AddUpdateUser", sqlparam);
            return 1;
        }

        public List<AppTimeZoneDataContract> GetAllTimeZoneSearchData(Guid? UserID, string Valuekey)
        {
            List<AppTimeZoneDataContract> _lstAppTimeZone = new List<AppTimeZoneDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Search", Value = Valuekey };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("App.usp_GetAllTimeZoneSearch", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                AppTimeZoneDataContract _apptimezonedatacontract = new AppTimeZoneDataContract();
                _apptimezonedatacontract.TimeZoneID = Convert.ToInt32(dr["TimeZoneID"]);
                _apptimezonedatacontract.Name = Convert.ToString(dr["Name"]);
                _apptimezonedatacontract.Valuekey = Convert.ToString(dr["Name"]);
                _apptimezonedatacontract.current_utc_offset = Convert.ToString(dr["current_utc_offset"]);
                _apptimezonedatacontract.is_currently_dst = Convert.ToInt32(dr["is_currently_dst"]);
                _lstAppTimeZone.Add(_apptimezonedatacontract);
            }
            return _lstAppTimeZone;
        }
        public List<AppTimeZoneDataContract> GetAllTimeZoneData(Guid? UserID)
        {
            List<AppTimeZoneDataContract> _lstAppTimeZone = new List<AppTimeZoneDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("App.usp_GetAllTimeZone", sqlparam);

            // var res = dbContext.usp_GetAllTimeZone(UserID, Valuekey);
            foreach (DataRow dr in dt.Rows)
            {
                AppTimeZoneDataContract _apptimezonedatacontract = new AppTimeZoneDataContract();
                _apptimezonedatacontract.TimeZoneID = Convert.ToInt32(dr["TimeZoneID"]);
                _apptimezonedatacontract.Name = Convert.ToString(dr["Name"]);
                _apptimezonedatacontract.Valuekey = Convert.ToString(dr["Name"]);
                _apptimezonedatacontract.current_utc_offset = Convert.ToString(dr["current_utc_offset"]);
                _apptimezonedatacontract.is_currently_dst = Convert.ToInt32(dr["is_currently_dst"]);
                _apptimezonedatacontract.Abbreviation = Convert.ToString(dr["Abbreviation"]);
                _lstAppTimeZone.Add(_apptimezonedatacontract);
            }
            return _lstAppTimeZone;
        }


        public System.Data.DataTable GetTimeZoneyUserID(Guid UserID, Guid? DelegateUserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DelegateUserID", Value = DelegateUserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("usp_GetTimeZoneByUserID", sqlparam);
            return dt;
        }

        public List<EmailDataContract> GetEmailIdsByModuleandType(int moduleid)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ModuleId", Value = moduleid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetEmailIdsForEmailNotificationNew", sqlparam);
            List<EmailDataContract> emails = new List<EmailDataContract>();

            foreach (DataRow dr in dt.Rows)
            {
                EmailDataContract emailDC = new EmailDataContract();
                emailDC.EmailID = Convert.ToString(dr["EmailId"]);
                emailDC.Type = Convert.ToInt32(dr["Type"]);
                emails.Add(emailDC);
            }
            return emails;
        }


        public int UpdateIPAddressByUserID(UserDataContract _userDataContract)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = _userDataContract.UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserLogin", Value = _userDataContract.Login };
            SqlParameter p3 = new SqlParameter { ParameterName = "@IPAddress", Value = _userDataContract.IpAddress };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };

            int count = hp.ExecNonquery("App.usp_UpdateIP", sqlparam);
            return 1;
        }

        public bool CheckDuplicateIPAddress(Guid? UserID, string IPAddress)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@IPAddress", Value = IPAddress };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var res = hp.ExecuteScalar("DBO.usp_CheckDuplicateIPAddress", sqlparam);

            return string.IsNullOrEmpty(Convert.ToString(res)) ? false : Convert.ToBoolean(res);
        }


        public bool AddNewUser(string? email, string? createdby)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@email", Value = email };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = createdby };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecNonquery("[App].[usp_AddViewerUser]", sqlparam);
                return true;
            }
            catch (Exception)
            {

                throw;
            }
            
        }


        public bool checkIsUserActive(string UserID)
        {
            bool isUserActive = false;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1};
            var res = hp.ExecDataTable("[App].[CheckUserIsACtive]", sqlparam);
            if (res.Rows.Count > 0)
            {
                if (res.Rows[0]["StatusID"].ToString() == "1")
                    isUserActive=true;
                else
                    isUserActive = false;
            }
            return isUserActive;
        }

        public void UpdateDeviceCode(UserDataContract Userobj)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@Login", Value = Userobj.Login };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DeviceCode", Value = Userobj.DeviceCode };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataTable("App.usp_UpdateDeviceCodeByUser", sqlparam);
        }

        public string GetDeviceCode(UserDataContract Userobj)
        {
            string Response = "";
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@Login", Value = Userobj.Login };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DeviceCode", Value = Userobj.DeviceCode };
            
            SqlParameter[] sqlparam = new SqlParameter[] { p1 , p2};
            DataTable dt = hp.ExecDataTable("App.usp_GetDeviceCodeByUser", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                Response = Convert.ToString(dr["Response"]);

            }
            return Response;
        }
    }
}
