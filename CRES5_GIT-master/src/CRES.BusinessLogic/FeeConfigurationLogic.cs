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
        public List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfigLiability(Guid? userID)
        {
            return _feeConfigurationRepository.GetFeeFunctionsConfigLiability(userID);
        }

        public void SaveFeeFunctionsConfig(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC)
        {
            _feeConfigurationRepository.SaveFeeFunctionsConfig(userID, ffDC);
        }
        public void SaveFeeFunctionsConfigLiability(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC)
        {
            _feeConfigurationRepository.SaveFeeFunctionsConfigLiability(userID, ffDC);
        }

        public List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfig(Guid? userID)
        {
            return _feeConfigurationRepository.GetFeeSchedulesConfig(userID);
        }

        public List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfigLiability(Guid? userID)
        {
            return _feeConfigurationRepository.GetFeeSchedulesConfigLiability(userID);
        }
        public void SaveFeeSchedulesConfig(Guid? userID, List<FeeSchedulesConfigDataContract> ffDC)
        {
            _feeConfigurationRepository.SaveFeeSchedulesConfig(userID, ffDC);
        }

        public void SaveFeeSchedulesConfigLiability(Guid? userID, List<FeeSchedulesConfigDataContract> ffDC)
        {
            _feeConfigurationRepository.SaveFeeSchedulesConfigLiability(userID, ffDC);
        }

        public void DeleteFeeSchedulesConfigByID(Guid? userID, Guid? FeeTypeGuID)
        {
            _feeConfigurationRepository.DeleteFeeSchedulesConfigByID(userID, FeeTypeGuID);
        }
        public void DeleteFeeSchedulesConfigLiabilityByID(Guid? userID, Guid? FeeTypeGuID)
        {
            _feeConfigurationRepository.DeleteFeeSchedulesConfigLiabilityByID(userID, FeeTypeGuID);
        }

        public void DeleteFeeFunctionsConfigByID(Guid? userID, Guid? FunctionGuID)
        {
            _feeConfigurationRepository.DeleteFeeFunctionsConfigByID(userID, FunctionGuID);
        }
        public void DeleteFeeFunctionsConfigLiabilityByID(Guid? userID, Guid? FunctionGuID)
        {
            _feeConfigurationRepository.DeleteFeeFunctionsConfigLiabilityByID(userID, FunctionGuID);
        }


        public List<FeeSchedulesConfigDataContract> GetPayRuleDropDownFeeSchedules(Guid? userID)
        {
            return _feeConfigurationRepository.GetPayRuleDropDownFeeSchedules(userID);
        }
    }
}
