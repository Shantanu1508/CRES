using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;

namespace CRES.DAL.IRepository
{
    interface IFeeConfigurationRepository
    {
        List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfig(Guid? userID);
        List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfigLiability(Guid? userID);
        void SaveFeeFunctionsConfig(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC);
        void SaveFeeFunctionsConfigLiability(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC);
        void SaveFeeSchedulesConfig(Guid? userID, List<FeeSchedulesConfigDataContract> fsDC);
        void SaveFeeSchedulesConfigLiability(Guid? userID, List<FeeSchedulesConfigDataContract> fsDC);
        List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfig(Guid? userID);
        List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfigLiability(Guid? userID);
        void DeleteFeeSchedulesConfigByID(Guid? userID, Guid? FeeTypeGuID);
        void DeleteFeeFunctionsConfigByID(Guid? userID, Guid? FunctionGuID);
        void DeleteFeeFunctionsConfigLiabilityByID(Guid? userID, Guid? FunctionGuID);
        void DeleteFeeSchedulesConfigLiabilityByID(Guid? userID, Guid? FeeTypeGuID);
    }
}
