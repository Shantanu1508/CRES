using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class FeeConfigurationLogic
    {
        private FeeConfigurationRepository _feeConfigurationRepository = new FeeConfigurationRepository();

        public List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfig(Guid? userID)
        {
            return _feeConfigurationRepository.GetFeeFunctionsConfig(userID);
        }

        public void SaveFeeFunctionsConfig(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC)
        {
            _feeConfigurationRepository.SaveFeeFunctionsConfig(userID, ffDC);
        }

        public List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfig(Guid? userID)
        {
            return _feeConfigurationRepository.GetFeeSchedulesConfig(userID);
        }
        public void SaveFeeSchedulesConfig(Guid? userID, List<FeeSchedulesConfigDataContract> ffDC)
        {
            _feeConfigurationRepository.SaveFeeSchedulesConfig(userID, ffDC);
        }

        public void DeleteFeeSchedulesConfigByID(Guid? userID, Guid? FeeTypeGuID)
        {
            _feeConfigurationRepository.DeleteFeeSchedulesConfigByID(userID, FeeTypeGuID);
        }

        public void DeleteFeeFunctionsConfigByID(Guid? userID, Guid? FunctionGuID)
        {
            _feeConfigurationRepository.DeleteFeeFunctionsConfigByID(userID, FunctionGuID);
        }


        public List<FeeSchedulesConfigDataContract> GetPayRuleDropDownFeeSchedules(Guid? userID)
        {
            return _feeConfigurationRepository.GetPayRuleDropDownFeeSchedules(userID);
        }
    }
}
