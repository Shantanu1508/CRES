using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class AppConfigLogic
    {
        AppConfigRepository _AppConfigRepository = new AppConfigRepository();

        public List<AppConfigDataContract> GetAppConfigByKey(Guid? userID, string Key)
        {
            return _AppConfigRepository.GetAppConfigByKey(userID, Key);
        }

        public int UpdateAppConfigByKey(Guid userId, AppConfigDataContract _appconfigdatacontract)
        {
            return _AppConfigRepository.UpdateAppConfigByKey(userId, _appconfigdatacontract);
        }

        public List<AppConfigDataContract> GetAllAppConfig(Guid? userID)
        {
            return _AppConfigRepository.GetAllAppConfig(userID);
        }
    }
}
