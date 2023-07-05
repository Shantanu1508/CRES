using CRES.DAL.IRepository;
#pragma warning disable CS0105 // The using directive for 'CRES.DAL.IRepository' appeared previously in this namespace
#pragma warning restore CS0105 // The using directive for 'CRES.DAL.IRepository' appeared previously in this namespace
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class FeeConfigurationRepository : IFeeConfigurationRepository
    {
        public List<FeeFunctionsConfigDataContract> GetFeeFunctionsConfig(Guid? userID)
        {
            DataTable dt = new DataTable();
            List<FeeFunctionsConfigDataContract> lstFeeFunctionsConfigDC = new List<FeeFunctionsConfigDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFeeFunctionsConfig", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                FeeFunctionsConfigDataContract _feeFunctionsConfigdc = new FeeFunctionsConfigDataContract();
                if (Convert.ToString(dr["FunctionGuID"]) != "")
                {
                    _feeFunctionsConfigdc.FunctionGuID = new Guid(Convert.ToString(dr["FunctionGuID"]));
                }
                _feeFunctionsConfigdc.FunctionNameText = Convert.ToString(dr["FunctionNameText"]);
                _feeFunctionsConfigdc.FunctionNameID = CommonHelper.ToInt32(dr["FunctionNameID"]);
                _feeFunctionsConfigdc.FunctionTypeText = Convert.ToString(dr["FunctionTypeText"]);
                _feeFunctionsConfigdc.FunctionTypeID = CommonHelper.ToInt32(dr["FunctionTypeID"]);
                _feeFunctionsConfigdc.PaymentFrequencyText = Convert.ToString(dr["PaymentFrequencyText"]);
                _feeFunctionsConfigdc.PaymentFrequencyID = CommonHelper.ToInt32(dr["PaymentFrequencyID"]);
                _feeFunctionsConfigdc.AccrualBasisText = Convert.ToString(dr["AccrualBasisText"]);
                _feeFunctionsConfigdc.AccrualBasisID = CommonHelper.ToInt32(dr["AccrualBasisID"]);
                _feeFunctionsConfigdc.AccrualStartDateText = Convert.ToString(dr["AccrualStartDateText"]);
                _feeFunctionsConfigdc.AccrualStartDateID = CommonHelper.ToInt32(dr["AccrualStartDateID"]);
                _feeFunctionsConfigdc.AccrualPeriodText = Convert.ToString(dr["AccrualPeriodText"]);
                _feeFunctionsConfigdc.AccrualPeriodID = CommonHelper.ToInt32(dr["AccrualPeriodID"]);
                _feeFunctionsConfigdc.LookupID = CommonHelper.ToInt32(dr["LookupID"]);
                _feeFunctionsConfigdc.Name = Convert.ToString(dr["Name"]);
                _feeFunctionsConfigdc.IsUsedInFeeSchedule = Convert.ToBoolean(dr["IsUsedInFeeSchedule"]);

                lstFeeFunctionsConfigDC.Add(_feeFunctionsConfigdc);
            }

            return lstFeeFunctionsConfigDC;
        }

        public void SaveFeeFunctionsConfig(Guid? userID, List<FeeFunctionsConfigDataContract> ffDC)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FeeFunctionsConfigXML", Value = ffDC.ToXML().Replace(" xsi:nil=\"true\"", "") };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_SaveFeeFunctionsConfig", sqlparam);
            //  dbContext.usp_SaveFeeFunctionsConfig(userID.ToString(), ffDC.ToXML().Replace(" xsi:nil=\"true\"", ""));
        }


        public List<FeeSchedulesConfigDataContract> GetFeeSchedulesConfig(Guid? userID)
        {
            DataTable dt = new DataTable();
            List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfigDC = new List<FeeSchedulesConfigDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFeeSchedulesConfig", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                FeeSchedulesConfigDataContract _feeSchedulesConfigdc = new FeeSchedulesConfigDataContract();
                if (Convert.ToString(dr["FeeTypeGuID"]) != "")
                {
                    _feeSchedulesConfigdc.FeeTypeGuID = new Guid(Convert.ToString(dr["FeeTypeGuID"]));
                }
                _feeSchedulesConfigdc.FeeTypeNameText = Convert.ToString(dr["FeeTypeNameText"]);
                _feeSchedulesConfigdc.FeeTypeNameID = CommonHelper.ToInt32(dr["FeeTypeNameID"]);
                _feeSchedulesConfigdc.FeePaymentFrequencyID = CommonHelper.ToInt32(dr["FeePaymentFrequencyID"]);
                _feeSchedulesConfigdc.FeeCoveragePeriodID = CommonHelper.ToInt32(dr["FeeCoveragePeriodID"]);
                _feeSchedulesConfigdc.FeeFunctionID = CommonHelper.ToInt32(dr["FeeFunctionID"]);
                _feeSchedulesConfigdc.TotalCommitmentID = CommonHelper.ToInt32(dr["TotalCommitmentID"]);
                _feeSchedulesConfigdc.UnscheduledPaydownsID = CommonHelper.ToInt32(dr["UnscheduledPaydownsID"]);
                _feeSchedulesConfigdc.BalloonPaymentID = CommonHelper.ToInt32(dr["BalloonPaymentID"]);
                _feeSchedulesConfigdc.LoanFundingsID = CommonHelper.ToInt32(dr["LoanFundingsID"]);
                _feeSchedulesConfigdc.ScheduledPrincipalAmortizationPaymentID = CommonHelper.ToInt32(dr["ScheduledPrincipalAmortizationPaymentID"]);
                _feeSchedulesConfigdc.CurrentLoanBalanceID = CommonHelper.ToInt32(dr["CurrentLoanBalanceID"]);
                _feeSchedulesConfigdc.InterestPaymentID = CommonHelper.ToInt32(dr["InterestPaymentID"]);
                _feeSchedulesConfigdc.FeePaymentFrequencyText = Convert.ToString(dr["FeePaymentFrequencyText"]);
                _feeSchedulesConfigdc.FeeCoveragePeriodText = Convert.ToString(dr["FeeCoveragePeriodText"]);
                _feeSchedulesConfigdc.FeeFunctionText = Convert.ToString(dr["FeeFunctionText"]);
                _feeSchedulesConfigdc.TotalCommitmentText = Convert.ToString(dr["TotalCommitmentText"]);
                _feeSchedulesConfigdc.UnscheduledPaydownsText = Convert.ToString(dr["UnscheduledPaydownsText"]);
                _feeSchedulesConfigdc.BalloonPaymentText = Convert.ToString(dr["BalloonPaymentText"]);
                _feeSchedulesConfigdc.LoanFundingsText = Convert.ToString(dr["LoanFundingsText"]);
                _feeSchedulesConfigdc.ScheduledPrincipalAmortizationPaymentText = Convert.ToString(dr["ScheduledPrincipalAmortizationPaymentText"]);
                _feeSchedulesConfigdc.CurrentLoanBalanceText = Convert.ToString(dr["CurrentLoanBalanceText"]);
                _feeSchedulesConfigdc.InterestPaymentText = Convert.ToString(dr["InterestPaymentText"]);
                _feeSchedulesConfigdc.LookupID = CommonHelper.ToInt32(dr["LookupID"]);
                _feeSchedulesConfigdc.Name = Convert.ToString(dr["Name"]);
                _feeSchedulesConfigdc.IsUsedInCalc = Convert.ToBoolean(dr["IsUsedInCalc"]);
                _feeSchedulesConfigdc.FeeNameTransID = CommonHelper.ToInt32(dr["FeeNameTransID"]);
                _feeSchedulesConfigdc.FeeNameTransText = Convert.ToString(dr["FeeNameTransText"]);
                _feeSchedulesConfigdc.ExcludeFromCashflowDownload = CommonHelper.ToBoolean(dr["ExcludeFromCashflowDownload"]);
                _feeSchedulesConfigdc.ID = CommonHelper.ToInt32(dr["ID"]);
                _feeSchedulesConfigdc.NameText = Convert.ToString(dr["NameText"]);
                _feeSchedulesConfigdc.InitialFundingID = CommonHelper.ToInt32(dr["InitialFundingID"]);
                _feeSchedulesConfigdc.InitialFundingText = Convert.ToString(dr["InitialFundingText"]);
                _feeSchedulesConfigdc.M61AdjustedCommitmentID = CommonHelper.ToInt32(dr["M61AdjustedCommitmentID"]);
                _feeSchedulesConfigdc.M61AdjustedCommitmentText = Convert.ToString(dr["M61AdjustedCommitmentText"]);

                lstFeeSchedulesConfigDC.Add(_feeSchedulesConfigdc);
            }
            return lstFeeSchedulesConfigDC;
        }
        public void SaveFeeSchedulesConfig(Guid? userID, List<FeeSchedulesConfigDataContract> fsDC)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FeeScheduleConfigXML", Value = fsDC.ToXML().Replace(" xsi:nil=\"true\"", "") };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_SaveFeeSchedulesConfig", sqlparam);
            //dbContext.usp_SaveFeeSchedulesConfig(userID.ToString(), fsDC.ToXML().Replace(" xsi:nil=\"true\"", ""));
        }

        public void DeleteFeeSchedulesConfigByID(Guid? userID, Guid? FeeTypeGuID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FeeTypeGuID", Value = FeeTypeGuID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_DeleteFeeSchedulesConfigByID", sqlparam);

            // dbContext.usp_DeleteFeeSchedulesConfigByID(userID, FeeTypeGuID);
        }

        public void DeleteFeeFunctionsConfigByID(Guid? userID, Guid? FunctionGuID)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FunctionGuID", Value = FunctionGuID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_DeleteFeeFunctionsConfigByID", sqlparam);
            // dbContext.usp_DeleteFeeFunctionsConfigByID(userID, FunctionGuID);
        }



        public List<FeeSchedulesConfigDataContract> GetPayRuleDropDownFeeSchedules(Guid? userID)
        {
            DataTable dt = new DataTable();
            List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfigDC = new List<FeeSchedulesConfigDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetPayRuleDropDownFeeSchedules", sqlparam);


            foreach (DataRow dr in dt.Rows)
            {

                FeeSchedulesConfigDataContract _feeSchedulesConfigdc = new FeeSchedulesConfigDataContract();
                _feeSchedulesConfigdc.ID = CommonHelper.ToInt32(dr["ID"]);
                _feeSchedulesConfigdc.NameText = Convert.ToString(dr["NameText"]);

                lstFeeSchedulesConfigDC.Add(_feeSchedulesConfigdc);
            }
            return lstFeeSchedulesConfigDC;
        }
    }
}
