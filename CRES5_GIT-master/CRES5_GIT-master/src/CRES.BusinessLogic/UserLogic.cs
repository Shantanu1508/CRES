using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.BusinessLogic
{
    public class UserLogic
    {
        UserRepository _userRepository = new UserRepository();

        public UserDataContract ValidateUser(string login, string password)
        {

#pragma warning disable CS0219 // The variable 'isValid' is assigned but its value is never used
            bool isValid = false;
#pragma warning restore CS0219 // The variable 'isValid' is assigned but its value is never used
            UserDataContract _userdatacontract = new UserDataContract();
            _userdatacontract.Login = login;
            _userdatacontract.Password = password;
            _userdatacontract = _userRepository.ValidateUser(_userdatacontract);

            return _userdatacontract;
        }

        //public UserDataContract GetPassword(UserDataContract Userobj)
        //{
        //    UserDataContract userdc = _userRepository.GetPassword(Userobj);
        //    return userdc;
        //}

        public UserDataContract GetUserCredentialByUserID(Guid UserID, Guid? DelegatedUserID)
        {
            UserDataContract _userdatacontract = new UserDataContract();
            _userdatacontract = _userRepository.GetUserCredentialByUserID(UserID, DelegatedUserID);
            return _userdatacontract;
        }

        public bool ChangePassword(Guid? userid, string oldpassword, string newpassword)
        {
            bool retValue = false;
            retValue = _userRepository.ChangePassword(userid, oldpassword, newpassword);
            return retValue;
        }

        public bool ResetPasswordByAuthenticationKey(string authenticationKey, string newpassword)
        {
            bool retValue = false;
            retValue = _userRepository.ResetPasswordByAuthenticationKey(authenticationKey, newpassword);
            return retValue;
        }

        public int UpdateUserCredentialByUserID(UserDataContract Userobj)
        {
            int retValue = _userRepository.UpdateUserCredentialByUserID(Userobj);
            return retValue;
        }

        public UserDataContract getUserpwdfromemail(string emailid)
        {
            return _userRepository.getUserpwdfromemil(emailid);
        }


        public List<UserDefaultSettingDataContract> GetUserDefaultSettingByUserID(Guid UserID)
        {
            List<UserDefaultSettingDataContract> _userdefaultsettingdc = new List<UserDefaultSettingDataContract>();
            _userdefaultsettingdc = _userRepository.GetUserDefaultSettingByUserID(UserID);
            return _userdefaultsettingdc;
        }


        public bool InsertUpdateUserDefaultSetting(Guid? userid, string type, string value)
        {
            bool retValue = false;
            retValue = _userRepository.InsertUpdateUserDefaultSetting(userid, type, value);
            return retValue;
        }


        public List<UserDataContract> GetAllUsers()
        {
            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();
            _userdatacontractlst = _userRepository.GetAllUsers();
            return _userdatacontractlst;
        }




        public int AddUpdateUser(List<UserDataContract> _userDataContract)
        {
            return _userRepository.AddUpdateUser(_userDataContract);
        }


        public int ResetUserPassword(UserDataContract _userDataContract)
        {
            return _userRepository.ResetUserPassword(_userDataContract);
        }

        public List<UserDataContract> UserForgotPassword(UserDataContract _userDataContract)
        {
            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();
            _userdatacontractlst = _userRepository.UserForgotPassword(_userDataContract);
            return _userdatacontractlst;
        }

        public List<UserDataContract> GetUsersByRoleName(string RoleName)
        {
            List<UserDataContract> _userdatacontractlst = new List<UserDataContract>();
            _userdatacontractlst = _userRepository.GetUsersByRoleName(RoleName);
            return _userdatacontractlst;
        }

        public bool ForceLogout(Guid? userID)
        {
            return _userRepository.ForceLogout(userID);
        }

        public int UpdateUserByUserID(UserDataContract _userDataContract)
        {
            return _userRepository.UpdateUserByUserID(_userDataContract);
        }

        public List<AppTimeZoneDataContract> GetAllTimeZoneSearchData(Guid? UserID, string Valuekey)
        {
            return _userRepository.GetAllTimeZoneSearchData(UserID, Valuekey);
        }

        public List<AppTimeZoneDataContract> GetAllTimeZoneData(Guid? UserID)
        {
            return _userRepository.GetAllTimeZoneData(UserID);
        }


        //public UserDataContract GetPassword(UserDataContract Userobj)
        //{
        //    UserDataContract userdc = _userRepository.GetPassword(Userobj);
        //    return userdc;
        //}
        public DataTable GetTimeZoneyUserID(Guid UserID, Guid? DelegateUserID)
        {
            return _userRepository.GetTimeZoneyUserID(UserID, DelegateUserID);
        }

        public int UpdateIPAddressByUserID(UserDataContract _userDataContract)
        {
            return _userRepository.UpdateIPAddressByUserID(_userDataContract);
        }
        public bool CheckDuplicateIPAddress(Guid? UserID, string IpAddress)
        {
            return _userRepository.CheckDuplicateIPAddress(UserID, IpAddress);
        }
    }
}
