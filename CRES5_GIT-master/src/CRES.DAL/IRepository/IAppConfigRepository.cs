using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IAppConfigRepository
    {
        List<AppConfigDataContract> GetAppConfigByKey(Guid? userId, string KeyName);
        int UpdateAppConfigByKey(Guid? userId, AppConfigDataContract _appconfigdatacontract);
    }
}
