using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IUserRepository
    {
        UserDataContract ValidateUser(UserDataContract Userobj);
        UserDataContract GetUserCredentialByUserID(Guid UserID, Guid? DelegatedUserID);

        bool ChangePassword(Guid? userid, string oldpassword, string newpassword);
        bool ResetPasswordByAuthenticationKey(string authenticationKey, string newpassword);
        int UpdateUserCredentialByUserID(UserDataContract Userobj);
        UserDataContract getUserpwdfromemil(string emailid);
        List<UserDefaultSettingDataContract> GetUserDefaultSettingByUserID(Guid UserID);
        bool InsertUpdateUserDefaultSetting(Guid? userid, string type, string value);
        List<UserDataContract> GetAllUsers();
        int AddUpdateUser(List<UserDataContract> _userDataContract);
        int ResetUserPassword(UserDataContract _userDataContract);
        List<UserDataContract> UserForgotPassword(UserDataContract _userDataContract);
        List<string> GetEmailIdsByModule(int moduleid);
        List<UserDataContract> GetUsersByRoleName(string RoleName);
        bool ForceLogout(Guid? userID);
        int UpdateUserByUserID(UserDataContract _userDataContract);
        List<AppTimeZoneDataContract> GetAllTimeZoneSearchData(Guid? UserID, string Valuekey);
        List<AppTimeZoneDataContract> GetAllTimeZoneData(Guid? UserID);

    }
}
