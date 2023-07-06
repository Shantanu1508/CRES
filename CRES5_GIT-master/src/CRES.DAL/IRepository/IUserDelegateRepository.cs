using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IUserDelegateRepository
    {

        string InsertDelegateConfiguration(UserDelegationConfigDataContract udd);
        List<UserDelegationConfigDataContract> GetAllActiveDelegatedUser(Guid userid);
        List<UserDelegationConfigDataContract> GetUsersToImpersonate(Guid? userid);

        string InsertDelegateHistory(UserDelegationConfigDataContract udc);
        int ImpersonateUserCount(Guid UserID);
    }
}
