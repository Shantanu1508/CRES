using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class UserDelegateLogic
    {
        private UserDelegateRepository udr = new UserDelegateRepository();

        public string InsertDelegateConfiguration(UserDelegationConfigDataContract udd)
        {
            return udr.InsertDelegateConfiguration(udd);
        }
        public List<UserDelegationConfigDataContract> GetAllActiveDelegatedUser(Guid userid)
        {
            return udr.GetAllActiveDelegatedUser(userid);
        }
        public List<UserDelegationConfigDataContract> GetUsersToImpersonate(Guid? userid)
        {
            return udr.GetUsersToImpersonate(userid);
        }
        public string InsertDelegateHistory(UserDelegationConfigDataContract udc)
        {
          return  udr.InsertDelegateHistory(udc);
        }

        public bool RevokeUserDelegateConfigByUserDelegateConfigID(Guid userDelegateConfigID)
        {
            return udr.RevokeUserDelegateConfigByUserDelegateConfigID(userDelegateConfigID);
        }
        public int ImpersonateUserCount(Guid UserID)
        {
            return udr.ImpersonateUserCount(UserID);
        }
    }
}