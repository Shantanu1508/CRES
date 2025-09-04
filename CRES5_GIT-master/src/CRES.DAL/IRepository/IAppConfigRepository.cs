using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;

namespace CRES.DAL.IRepository
{
    public interface IAppConfigRepository
    {
        List<AppConfigDataContract> GetAppConfigByKey(Guid? userId, string KeyName);
        int UpdateAppConfigByKey(Guid? userId, AppConfigDataContract _appconfigdatacontract);
    }
}
