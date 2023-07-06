using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    interface IFeeConfigurationRepository
    {
        List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfig(Guid? userID);
        void SaveFeeFunctionsConfig(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC);
        void SaveFeeSchedulesConfig(Guid? userID, List<FeeSchedulesConfigDataContract> fsDC);
        List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfig(Guid? userID);
        void DeleteFeeSchedulesConfigByID(Guid? userID, Guid? FeeTypeGuID);
        void DeleteFeeFunctionsConfigByID(Guid? userID, Guid? FunctionGuID);
    }
}
