using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
