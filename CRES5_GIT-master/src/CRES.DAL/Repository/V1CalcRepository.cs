using CRES.DAL.IRepository;
using CRES.DAL.Helper;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Remotion.Linq.Parsing;
using Microsoft.Extensions.Configuration;
using System.IO;
using System.Xml.Linq;


namespace CRES.DAL.Repository
{
    public class V1CalcRepository : IV1CalcRepository
    {

        public DataSet GetCalcRequestData(string objectID, int objectTypeId, string userID, string analysisID, int CalcType)
        {
            DataSet ds = new DataSet();
            try
            {
                /*
                182    27  Note
                283 27  Deal
                */
                Helper.Helper hp = new Helper.Helper();
                if (CalcType == 776)
                {
                    SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                    SqlParameter p1 = new SqlParameter { ParameterName = "@DealID_any", Value = objectID };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@Analysis_ID", Value = new Guid(analysisID) };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@CalcTypeID", Value = CalcType };
                    SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                    ds = hp.ExecDataSet("usp_GetCalcJsonByDealID_Prepayment", sqlparam);
                }
                else
                {
                    if (objectTypeId == 283)
                    {
                        SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                        SqlParameter p1 = new SqlParameter { ParameterName = "@DealID_any", Value = objectID };
                        SqlParameter p2 = new SqlParameter { ParameterName = "@Analysis_ID", Value = new Guid(analysisID) };
                        SqlParameter p3 = new SqlParameter { ParameterName = "@CalcTypeID", Value = CalcType };
                        SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                        ds = hp.ExecDataSet("usp_GetCalcJsonByDealID", sqlparam);
                    }
                    else if (objectTypeId == 182)
                    {
                        SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                        SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID_any", Value = objectID };
                        SqlParameter p2 = new SqlParameter { ParameterName = "@Analysis_ID", Value = new Guid(analysisID) };
                        SqlParameter p3 = new SqlParameter { ParameterName = "@CalcTypeID", Value = CalcType };
                        SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                        ds = hp.ExecDataSet("usp_GetCalcJsonByNoteID", sqlparam);
                    }
                }


                DataTable dtTableInfo = new DataTable();
                dtTableInfo = ds.Tables[ds.Tables.Count - 1];
                dtTableInfo.TableName = "json_info";

                for (int i = 0; i <= ds.Tables.Count - 2; i++)
                {
                    ds.Tables[i].TableName = dtTableInfo.Rows[i]["table_name"].ToString();
                }

            }
            catch (Exception ex)
            {
            }
            return ds;
        }
        public int InsertUpdateNotePeriodicCalc(DataTable dtperiodicoutput, string AnalysisID, string CreatedBy, string crenoteid)
        {

            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@creNoteID", Value = crenoteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecDataSet("dbo.usp_DeleteNotePeriodicCalcByNoteID_V1", sqlparam);

                Guid noteid = new Guid(res.Tables[0].Rows[0]["NoteID"].ToString());
                Guid AccountId = new Guid(res.Tables[0].Rows[0]["AccountId"].ToString());
                PeriodicRepository pr = new PeriodicRepository();
                DateTime? LastAccountingCloseDate = pr.GetLastAccountingCloseDateByDealIDORNoteID(null, noteid);


                dtperiodicoutput.Columns.Add("AccountId", typeof(Guid));
                dtperiodicoutput.Columns.Add("AnalysisID", typeof(Guid));
                dtperiodicoutput.Columns.Add("createdby", typeof(string));
                dtperiodicoutput.Columns.Add("updatedby", typeof(string));
                dtperiodicoutput.Columns.Add("createddate", typeof(DateTime));
                dtperiodicoutput.Columns.Add("updateddate", typeof(DateTime));
                dtperiodicoutput.Columns.Add("CalcEngineType", typeof(int));
                dtperiodicoutput.Columns.Add("accountingclosedate", typeof(DateTime));

                if (res.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < dtperiodicoutput.Rows.Count; i++)
                    {
                        dtperiodicoutput.Rows[i]["AccountId"] = AccountId;
                        dtperiodicoutput.Rows[i]["AnalysisID"] = AnalysisID;
                        dtperiodicoutput.Rows[i]["createdby"] = CreatedBy;
                        dtperiodicoutput.Rows[i]["updatedby"] = CreatedBy;
                        dtperiodicoutput.Rows[i]["createddate"] = DateTime.Now;
                        dtperiodicoutput.Rows[i]["updateddate"] = DateTime.Now;
                        dtperiodicoutput.Rows[i]["CalcEngineType"] = 798;
                        dtperiodicoutput.Rows[i]["accountingclosedate"] = DBNull.Value;


                    }
                }
                //code for close data
                DataTable closedt = GetNotePeriodicCalcFromAccountingClose(noteid.ToString(), AnalysisID);

                foreach (DataRow closedrow in closedt.Rows)
                {
                    DataRow newrow = dtperiodicoutput.NewRow();

                    newrow["AccountId"] = closedrow["AccountId"];
                    newrow["Date"] = closedrow["PeriodEndDate"];
                    newrow["initbal_periodic"] = closedrow["BeginningBalance"];
                    newrow["funding"] = closedrow["TotalFutureAdvancesForThePeriod"];
                    newrow["paydown"] = closedrow["TotalDiscretionaryCurtailmentsforthePeriod"];
                    newrow["schprin"] = closedrow["ScheduledPrincipal"];
                    newrow["periodpikint"] = closedrow["periodpikint"];
                    newrow["act_pikprinpaid"] = closedrow["PIKPrincipalPaidForThePeriod"];
                    newrow["endbal"] = closedrow["EndingBalance"];
                    newrow["clean_cost"] = closedrow["CleanCost"];
                    newrow["cum_am_fee"] = closedrow["AccumulatedAmort"];
                    newrow["gaapbasis"] = closedrow["DeferredFeeGAAPBasis"];
                    newrow["gaapbv"] = closedrow["EndingGAAPBookValue"];
                    newrow["intsuspensebal"] = closedrow["InterestSuspenseAccountBalance"];
                    newrow["allincouponrate"] = closedrow["AllInCouponRate"];
                    newrow["gross_def_fees"] = closedrow["GrossDeferredFees"];
                    newrow["rvrslof_intaccr"] = closedrow["ReversalofPriorInterestAccrual"];
                    newrow["curperintaccr"] = closedrow["CurrentPeriodInterestAccrual"];
                    newrow["intrcvdcurper"] = closedrow["InterestReceivedinCurrentPeriod"];
                    newrow["totgaapintper"] = closedrow["TotalGAAPInterestFortheCurrentPeriod"];
                    newrow["am_cost"] = closedrow["AmortizedCost"];
                    newrow["AnalysisID"] = closedrow["AnalysisID"];
                    newrow["createdby"] = closedrow["CreatedBy"];
                    newrow["createddate"] = closedrow["CreatedDate"];
                    newrow["updatedby"] = closedrow["UpdatedBy"];
                    newrow["updateddate"] = closedrow["UpdatedDate"];
                    newrow["CalcEngineType"] = closedrow["CalcEngineType"];
                    newrow["balloon"] = closedrow["BalloonPayment"];
                    newrow["rem_unfunded_commitment"] = closedrow["RemainingUnfundedCommitment"];
                    newrow["month"] = closedrow["Month"];
                    newrow["levyld"] = closedrow["levyld"];
                    newrow["cum_am_disc"] = closedrow["DiscountPremiumAccumulatedAmort"];
                    newrow["cum_dailypikint"] = closedrow["cum_dailypikint"];
                    newrow["cum_baladdon_am"] = closedrow["cum_baladdon_am"];
                    newrow["cum_baladdon_nonam"] = closedrow["cum_baladdon_nonam"];
                    newrow["cum_dailyint"] = closedrow["cum_dailyint"];
                    newrow["cum_ddbaladdon"] = closedrow["cum_ddbaladdon"];
                    newrow["cum_ddintdelta"] = closedrow["cum_ddintdelta"];
                    newrow["cum_am_capcosts"] = closedrow["CapitalizedCostAccumulatedAmort"];
                    newrow["initbal"] = closedrow["initbal"];
                    newrow["cum_fee_levyld"] = closedrow["cum_fee_levyld"];
                    newrow["period_ddintdelta_shifted"] = closedrow["period_ddintdelta_shifted"];
                    newrow["intdeltabal"] = closedrow["intdeltabal"];
                    newrow["cum_exit_fee_excl_lv_yield"] = closedrow["cum_exit_fee_excl_lv_yield"];
                    newrow["accountingclosedate"] = closedrow["accountingclosedate"];
                    newrow["periodend"] = closedrow["AccPeriodEnd"];
                    newrow["periodstart"] = closedrow["AccPeriodStart"];
                    newrow["pmtdtnotadj"] = closedrow["pmtdtnotadj"];
                    newrow["pmtdt"] = closedrow["pmtdt"];
                    newrow["periodpikint"] = closedrow["periodpikint"];
                    newrow["yld_capcosts"] = closedrow["CapitalizedCostLevelYield"];
                    newrow["bas_capcosts"] = closedrow["CapitalizedCostGAAPBasis"];
                    newrow["am_capcosts"] = closedrow["CapitalizedCostAccrual"];
                    newrow["yld_disc"] = closedrow["DiscountPremiumLevelYield"];
                    newrow["bas_disc"] = closedrow["DiscountPremiumGAAPBasis"];
                    newrow["am_disc"] = closedrow["DiscountPremiumAccrual"];
                    newrow["feeamort"] = closedrow["TotalAmortAccrualForPeriod"];

                    newrow["pastdueint"] = closedrow["InterestPastDue"];
                    newrow["dailyavgbal"] = closedrow["AverageDailyBalance"];

                    //newrow["curperpikintaccr"] = closedrow["CurrentPeriodPIKInterestAccrual"];
                    newrow["curperpikintaccr"] = closedrow["CurrentPeriodPIKInterestAccrual"];

                    newrow["curperpikintaccrmon"] = closedrow["CurrentPeriodPIKInterestAccrualPeriodEnddate"];
                    newrow["curperintaccrmon"] = closedrow["CurrentPeriodInterestAccrualPeriodEnddate"];
                    newrow["act_actualdelta"] = closedrow["InterestSuspenseAccountActivityforthePeriod"];
                    newrow["cum_unusedfee"] = closedrow["cum_unusedfee"];

                    newrow["netperiodpikamount"] = closedrow["NetPIKAmountForThePeriod"];
                    newrow["cashint"] = closedrow["CashInterest"];
                    newrow["capitalizedint"] = closedrow["CapitalizedInterest"];
                    newrow["pikballoonsepcomp"] = closedrow["PIKBalanceBalloonPayment"];
                    newrow["pikendbalsepcomp"] = closedrow["EndingPIKBalanceNotInsideLoanBalance"];

                    newrow["cum_daily_pik_from_interest"] = closedrow["CumulativeDailyPIKFromInterest"];
                    newrow["cum_dailypikcomp"] = closedrow["CumulativeDailyPIKCompounding"];
                    newrow["cum_dailyintonpik"] = closedrow["CumulativeDailyIntoPIK"];

                    newrow["pmtdtpikint"] = closedrow["PIKInterestAppliedForThePeriod"];


                    dtperiodicoutput.Rows.Add(newrow);
                }


                //code for Bulk copy
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;

                //insert record
                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = "[CRE].[NotePeriodicCalc]";

                bulkcopy.ColumnMappings.Add("AccountId", "AccountId");
                bulkcopy.ColumnMappings.Add("Date", "PeriodEndDate");

                bulkcopy.ColumnMappings.Add("initbal_periodic", "BeginningBalance");
                bulkcopy.ColumnMappings.Add("funding", "TotalFutureAdvancesForThePeriod");
                bulkcopy.ColumnMappings.Add("paydown", "TotalDiscretionaryCurtailmentsforthePeriod");
                bulkcopy.ColumnMappings.Add("schprin", "PrincipalPaid");

                bulkcopy.ColumnMappings.Add("pmtdtpikint", "PIKInterestAppliedForThePeriod");
                bulkcopy.ColumnMappings.Add("act_pikprinpaid", "PIKPrincipalPaidForThePeriod");
                bulkcopy.ColumnMappings.Add("endbal", "EndingBalance");

                bulkcopy.ColumnMappings.Add("clean_cost", "CleanCost");
                bulkcopy.ColumnMappings.Add("cum_am_fee", "AccumulatedAmort");
                bulkcopy.ColumnMappings.Add("gaapbasis", "DeferredFeeGAAPBasis");
                bulkcopy.ColumnMappings.Add("gaapbv", "EndingGAAPBookValue");

                bulkcopy.ColumnMappings.Add("curperintaccrmon", "CurrentPeriodInterestAccrualPeriodEnddate");
                bulkcopy.ColumnMappings.Add("curperpikintaccrmon", "CurrentPeriodPIKInterestAccrualPeriodEnddate");
                bulkcopy.ColumnMappings.Add("intsuspensebal", "InterestSuspenseAccountBalance");
                bulkcopy.ColumnMappings.Add("allincouponrate", "AllInCouponRate");
                bulkcopy.ColumnMappings.Add("gross_def_fees", "GrossDeferredFees");
                bulkcopy.ColumnMappings.Add("rvrslof_intaccr", "ReversalofPriorInterestAccrual");
                bulkcopy.ColumnMappings.Add("curperintaccr", "CurrentPeriodInterestAccrual");
                bulkcopy.ColumnMappings.Add("intrcvdcurper", "InterestReceivedinCurrentPeriod");
                bulkcopy.ColumnMappings.Add("totgaapintper", "TotalGAAPInterestFortheCurrentPeriod");
                bulkcopy.ColumnMappings.Add("am_cost", "AmortizedCost");

                bulkcopy.ColumnMappings.Add("AnalysisID", "AnalysisID");
                bulkcopy.ColumnMappings.Add("createdby", "CreatedBy");
                bulkcopy.ColumnMappings.Add("createddate", "CreatedDate");
                bulkcopy.ColumnMappings.Add("updatedby", "UpdatedBy");
                bulkcopy.ColumnMappings.Add("updateddate", "UpdatedDate");
                bulkcopy.ColumnMappings.Add("CalcEngineType", "CalcEngineType");
                bulkcopy.ColumnMappings.Add("balloon", "BalloonPayment");
                bulkcopy.ColumnMappings.Add("rem_unfunded_commitment", "RemainingUnfundedCommitment");
                bulkcopy.ColumnMappings.Add("month", "Month");
                bulkcopy.ColumnMappings.Add("levyld", "levyld");
                bulkcopy.ColumnMappings.Add("cum_am_disc", "DiscountPremiumAccumulatedAmort");
                bulkcopy.ColumnMappings.Add("cum_dailypikint", "cum_dailypikint");
                bulkcopy.ColumnMappings.Add("cum_baladdon_am", "cum_baladdon_am");
                bulkcopy.ColumnMappings.Add("cum_baladdon_nonam", "cum_baladdon_nonam");
                bulkcopy.ColumnMappings.Add("cum_dailyint", "cum_dailyint");
                bulkcopy.ColumnMappings.Add("cum_ddbaladdon", "cum_ddbaladdon");
                bulkcopy.ColumnMappings.Add("cum_ddintdelta", "cum_ddintdelta");
                bulkcopy.ColumnMappings.Add("cum_am_capcosts", "CapitalizedCostAccumulatedAmort");
                bulkcopy.ColumnMappings.Add("initbal", "initbal");
                bulkcopy.ColumnMappings.Add("cum_fee_levyld", "cum_fee_levyld");
                bulkcopy.ColumnMappings.Add("period_ddintdelta_shifted", "period_ddintdelta_shifted");
                bulkcopy.ColumnMappings.Add("intdeltabal", "intdeltabal");
                bulkcopy.ColumnMappings.Add("cum_exit_fee_excl_lv_yield", "cum_exit_fee_excl_lv_yield");
                bulkcopy.ColumnMappings.Add("accountingclosedate", "accountingclosedate");
                bulkcopy.ColumnMappings.Add("periodend", "AccPeriodEnd");
                bulkcopy.ColumnMappings.Add("periodstart", "AccPeriodStart");
                bulkcopy.ColumnMappings.Add("pmtdtnotadj", "pmtdtnotadj");
                bulkcopy.ColumnMappings.Add("pmtdt", "pmtdt");
                //bulkcopy.ColumnMappings.Add("pmtdtpikint", "pmtdtpikint");
                bulkcopy.ColumnMappings.Add("yld_capcosts", "CapitalizedCostLevelYield");
                bulkcopy.ColumnMappings.Add("bas_capcosts", "CapitalizedCostGAAPBasis");
                bulkcopy.ColumnMappings.Add("am_capcosts", "CapitalizedCostAccrual");
                bulkcopy.ColumnMappings.Add("yld_disc", "DiscountPremiumLevelYield");
                bulkcopy.ColumnMappings.Add("bas_disc", "DiscountPremiumGAAPBasis");
                bulkcopy.ColumnMappings.Add("am_disc", "DiscountPremiumAccrual");
                bulkcopy.ColumnMappings.Add("feeamort", "TotalAmortAccrualForPeriod");

                bulkcopy.ColumnMappings.Add("dailyavgbal", "AverageDailyBalance");
                bulkcopy.ColumnMappings.Add("pastdueint", "InterestPastDue");

                bulkcopy.ColumnMappings.Add("curperpikintaccr", "CurrentPeriodPIKInterestAccrual");
                bulkcopy.ColumnMappings.Add("act_actualdelta", "InterestSuspenseAccountActivityforthePeriod");

                bulkcopy.ColumnMappings.Add("pikinitbalsepcomp", "BeginningPIKBalanceNotInsideLoanBalance");
                bulkcopy.ColumnMappings.Add("pikintsepcomp", "PIKInterestForPeriodNotInsideLoanBalance");
                bulkcopy.ColumnMappings.Add("pikballoonsepcomp", "PIKBalanceBalloonPayment");
                bulkcopy.ColumnMappings.Add("pikendbalsepcomp", "EndingPIKBalanceNotInsideLoanBalance");

                bulkcopy.ColumnMappings.Add("periodpikint", "periodpikint");
                bulkcopy.ColumnMappings.Add("cum_unusedfee", "cum_unusedfee");

                bulkcopy.ColumnMappings.Add("netperiodpikamount", "NetPIKAmountForThePeriod");
                bulkcopy.ColumnMappings.Add("cashint", "CashInterest");
                bulkcopy.ColumnMappings.Add("capitalizedint", "CapitalizedInterest");
                bulkcopy.ColumnMappings.Add("act_periodpikintpaid", "PIKInterestPaidForThePeriod");
                bulkcopy.ColumnMappings.Add("periodpikinterestforperiod", "PIKInterestForThePeriod");
                bulkcopy.ColumnMappings.Add("cum_daily_pik_from_interest", "CumulativeDailyPIKFromInterest");
                bulkcopy.ColumnMappings.Add("cum_dailypikcomp", "CumulativeDailyPIKCompounding");
                bulkcopy.ColumnMappings.Add("cum_dailyintonpik", "CumulativeDailyIntoPIK");


                bulkcopy.WriteToServer(dtperiodicoutput);
                return 1;

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        public void DeleteTransactionEntry(string AnalysisID, string crenoteid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@creNoteID", Value = crenoteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecDataSet("dbo.usp_GetTransactionEntryMaxIDByNoteID_V1", sqlparam);

                string MaxID = (res.Tables[0].Rows[0]["TranEntryAutoID"]).ToString();
                string NoteID = res.Tables[0].Rows[0]["NoteID"].ToString();
                //Guid AccountId = new Guid(res.Tables[0].Rows[0]["AccountId"].ToString());

                Helper.Helper hp1 = new Helper.Helper();

                SqlParameter p3 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@MaxID", Value = MaxID };
                SqlParameter[] sqlparam1 = new SqlParameter[] { p3, p4, p5 };
                hp1.ExecDataSet("dbo.usp_DeleteTransactionEntryByNoteID_V1", sqlparam1);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public int InsertTransactionEntry(DataTable dtTransactionsoutput, string AnalysisID, string CreatedBy, string crenoteid, string StrCreatedBy, string noteid, DateTime? LastAccountingCloseDate)
        {
            // var res = 0;
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@creNoteID", Value = crenoteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecDataSet("dbo.usp_GetTransactionEntryMaxIDByNoteID_V1", sqlparam);

                string MaxID = (res.Tables[0].Rows[0]["TranEntryAutoID"]).ToString();
                string NoteID = res.Tables[0].Rows[0]["NoteID"].ToString();
                Guid AccountId = new Guid(res.Tables[0].Rows[0]["AccountId"].ToString());


                //Bulk Insert changes
                dtTransactionsoutput.Columns.Add("AccountId", typeof(Guid));
                dtTransactionsoutput.Columns.Add("AnalysisID", typeof(Guid));
                dtTransactionsoutput.Columns.Add("createdby", typeof(string));
                dtTransactionsoutput.Columns.Add("updatedby", typeof(string));
                dtTransactionsoutput.Columns.Add("createddate", typeof(DateTime));
                dtTransactionsoutput.Columns.Add("updateddate", typeof(DateTime));
                dtTransactionsoutput.Columns.Add("GeneratedBy", typeof(string));
                dtTransactionsoutput.Columns.Add("StrCreatedBy", typeof(string));
                dtTransactionsoutput.Columns.Add("accountingclosedate", typeof(DateTime));


                if (res.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < dtTransactionsoutput.Rows.Count; i++)
                    {
                        dtTransactionsoutput.Rows[i]["AccountId"] = AccountId;
                        dtTransactionsoutput.Rows[i]["AnalysisID"] = AnalysisID;
                        dtTransactionsoutput.Rows[i]["createdby"] = CreatedBy;
                        dtTransactionsoutput.Rows[i]["updatedby"] = CreatedBy;
                        dtTransactionsoutput.Rows[i]["createddate"] = DateTime.Now;
                        dtTransactionsoutput.Rows[i]["updateddate"] = DateTime.Now;
                        dtTransactionsoutput.Rows[i]["GeneratedBy"] = "Calculator";
                        dtTransactionsoutput.Rows[i]["StrCreatedBy"] = StrCreatedBy;
                        dtTransactionsoutput.Rows[i]["accountingclosedate"] = DBNull.Value;

                    }
                }

                DataTable closedt = GetTransactionEntryFromAccountingClose(noteid, AnalysisID);
                DataTable joinDataTable = new DataTable();

                foreach (DataRow closedrow in closedt.Rows)
                {
                    DataRow newrow = dtTransactionsoutput.NewRow();

                    newrow["AccountId"] = closedrow["AccountId"];
                    newrow["Date"] = closedrow["Date"];
                    newrow["value"] = closedrow["Amount"];
                    newrow["type"] = closedrow["Type"];
                    newrow["AnalysisID"] = closedrow["AnalysisID"];
                    newrow["createdby"] = closedrow["CreatedBy"];
                    newrow["createddate"] = closedrow["CreatedDate"];
                    newrow["updatedby"] = closedrow["UpdatedBy"];
                    newrow["updateddate"] = closedrow["UpdatedDate"];
                    newrow["Fee Name"] = closedrow["FeeName"];
                    newrow["IO Term End Date"] = closedrow["IOTermEndDate"];
                    newrow["purpose"] = closedrow["PurposeType"];
                    newrow["GeneratedBy"] = closedrow["GeneratedBy"];
                    newrow["StrCreatedBy"] = closedrow["StrCreatedBy"];
                    newrow["remit_dt"] = closedrow["RemitDate"];
                    newrow["transdtbyrule_dt"] = closedrow["TransactionDateByRule"];
                    newrow["trans_dt"] = closedrow["TransactionDateServicingLog"];
                    newrow["LIBORPercentage"] = closedrow["LIBORPercentage"];
                    newrow["PIKInterestPercentage"] = closedrow["PIKInterestPercentage"];
                    newrow["PIKLiborPercentage"] = closedrow["PIKLiborPercentage"];
                    newrow["SpreadPercentage"] = closedrow["SpreadPercentage"];
                    newrow["AllInCouponRate"] = closedrow["AllInCouponRate"];
                    newrow["accountingclosedate"] = closedrow["accountingclosedate"];
                    newrow["adjustmenttype"] = closedrow["AdjustmentType"];

                    dtTransactionsoutput.Rows.Add(newrow);
                }


                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;

                using (SqlConnection sqlConn = new SqlConnection(conString.ToString()))
                {
                    sqlConn.Open();
                    using (SqlTransaction sqlTran = sqlConn.BeginTransaction())
                    {

                        using (SqlBulkCopy bulkcopy = new SqlBulkCopy(sqlConn, SqlBulkCopyOptions.Default, sqlTran))
                        {
                            bulkcopy.BulkCopyTimeout = 36000;
                            bulkcopy.DestinationTableName = "[CRE].[TransactionEntry]";

                            bulkcopy.ColumnMappings.Add("AccountId", "AccountId");
                            bulkcopy.ColumnMappings.Add("Date", "Date");
                            bulkcopy.ColumnMappings.Add("value", "Amount");
                            bulkcopy.ColumnMappings.Add("type", "Type");
                            bulkcopy.ColumnMappings.Add("AnalysisID", "AnalysisID");
                            bulkcopy.ColumnMappings.Add("createdby", "CreatedBy");
                            bulkcopy.ColumnMappings.Add("createddate", "CreatedDate");
                            bulkcopy.ColumnMappings.Add("updatedby", "UpdatedBy");
                            bulkcopy.ColumnMappings.Add("updateddate", "UpdatedDate");
                            bulkcopy.ColumnMappings.Add("Fee Name", "FeeName");
                            bulkcopy.ColumnMappings.Add("IO Term End Date", "IOTermEndDate");
                            bulkcopy.ColumnMappings.Add("purpose", "PurposeType");
                            bulkcopy.ColumnMappings.Add("GeneratedBy", "GeneratedBy");
                            bulkcopy.ColumnMappings.Add("StrCreatedBy", "StrCreatedBy");
                            bulkcopy.ColumnMappings.Add("remit_dt", "RemitDate");
                            bulkcopy.ColumnMappings.Add("transdtbyrule_dt", "TransactionDateByRule");
                            bulkcopy.ColumnMappings.Add("trans_dt", "TransactionDateServicingLog");

                            bulkcopy.ColumnMappings.Add("OriginalIndex", "LIBORPercentage");
                            bulkcopy.ColumnMappings.Add("PIKInterestPercentage", "PIKInterestPercentage");
                            bulkcopy.ColumnMappings.Add("PIKLiborPercentage", "PIKLiborPercentage");
                            bulkcopy.ColumnMappings.Add("SpreadPercentage", "SpreadPercentage");
                            bulkcopy.ColumnMappings.Add("AllInCouponRate", "AllInCouponRate");
                            bulkcopy.ColumnMappings.Add("accountingclosedate", "accountingclosedate");
                            bulkcopy.ColumnMappings.Add("adjustmenttype", "AdjustmentType");
                            bulkcopy.ColumnMappings.Add("BalloonRepayAmount", "BalloonRepayAmount");
                            bulkcopy.ColumnMappings.Add("Comments", "Comment");

                            bulkcopy.ColumnMappings.Add("IndexValue", "IndexValue");
                            bulkcopy.ColumnMappings.Add("SpreadValue", "SpreadValue");
                            bulkcopy.ColumnMappings.Add("OriginalIndex", "OriginalIndex");


                            try
                            {
                                bulkcopy.WriteToServer(dtTransactionsoutput);
                                sqlTran.Commit();


                                //delete old Transaction entry
                                Helper.Helper hp1 = new Helper.Helper();

                                SqlParameter p3 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
                                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                                SqlParameter p5 = new SqlParameter { ParameterName = "@MaxID", Value = MaxID };
                                SqlParameter[] sqlparam1 = new SqlParameter[] { p3, p4, p5 };
                                hp1.ExecDataSet("dbo.usp_DeleteTransactionEntryByNoteID_V1", sqlparam1);
                            }
                            catch (Exception ex)
                            {
                                sqlTran.Rollback();
                                throw ex;
                            }
                        }
                    }
                }

                return 1;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


        public int InsertPayRuleDistribution(DataTable dtoutput, string AnalysisID, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@tbltype_PayRuleDist_V1", Value = dtoutput };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = CreatedBy };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            var res = hp.ExecDataTablewithparams("dbo.usp_InsertUpdatePayruleDistributions_v1", sqlparam);
            return res;
        }

        public int UpdateTransactionEntryCash_NonCash(string NoteId, string AnalysisID, DateTime LastAccountingclosedate, DateTime? MaturityUsedInCalc)
        {
            var res = 0;
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@accountingclosedate", Value = LastAccountingclosedate };
            SqlParameter p4 = new SqlParameter { ParameterName = "@MaturityUsedInCalc", Value = MaturityUsedInCalc };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            res = hp.ExecDataTablewithparams("CRE.usp_UpdateTransactionEntryCash_NonCash", sqlparam);

            return res;
        }


        public void UpdateCalculationStatusForDependents(string CRENoteID, string AnalysisID)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@CRENoteID", Value = CRENoteID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("usp_UpdateCalculationStatusForDependents_V1", sqlparam);
            }
            catch (Exception ex)
            {

                throw;
            }

        }

        //
        public List<V1CalculationStatusDataContract> GetAllDealsProcessingstatus()
        {
            List<V1CalculationStatusDataContract> lstresult = new List<V1CalculationStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_getDealidandRequestIDfromCalculationRequests");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                _dealDC.DealID = Convert.ToString(dr["DealID"]);
                _dealDC.RequestID = Convert.ToString(dr["RequestID"]);
                _dealDC.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                lstresult.Add(_dealDC);
            }
            return lstresult;
        }

        public List<V1CalculationStatusDataContract> GetRecordsFromCalculationRequest()
        {
            List<V1CalculationStatusDataContract> lstresult = new List<V1CalculationStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_getDealidfromCalculationRequests");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                _dealDC.objectID = Convert.ToString(dr["objectID"]);
                _dealDC.objectTypeId = CommonHelper.ToInt32(dr["objectTypeId"]);
                _dealDC.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                _dealDC.CalcType = CommonHelper.ToInt32(dr["CalcType"]);

                lstresult.Add(_dealDC);
            }
            return lstresult;
        }

        public List<V1CalculationStatusDataContract> GetDealidForPrepaymentCalculation()
        {
            List<V1CalculationStatusDataContract> lstresult = new List<V1CalculationStatusDataContract>();

            Helper.Helper hp = new Helper.Helper(); 
            DataTable dt = hp.ExecDataTable("dbo.usp_getDealidfromCalculationRequestsPrepayment");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                _dealDC.objectID = Convert.ToString(dr["objectID"]);
                _dealDC.objectTypeId = CommonHelper.ToInt32(dr["objectTypeId"]);
                _dealDC.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                _dealDC.CalcType = CommonHelper.ToInt32(dr["CalcType"]);

                lstresult.Add(_dealDC);
            }
            return lstresult;
        }

        public List<V1CalculationStatusDataContract> GetRequestIDFromCalculationQueueRequest()
        {
            List<V1CalculationStatusDataContract> lstResult = new List<V1CalculationStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetRequestIDFromCalculationQueueRequest");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract v1CalcDC = new V1CalculationStatusDataContract();
                v1CalcDC.RequestID = Convert.ToString(dr["RequestID"]);
                v1CalcDC.TransactionOutput = CommonHelper.ToInt32(dr["TransactionOutput"]);
                v1CalcDC.NotePeriodicOutput = CommonHelper.ToInt32(dr["NotePeriodicOutput"]);
                v1CalcDC.StrippingOutput = CommonHelper.ToInt32(dr["StrippingOutput"]);
                v1CalcDC.Prepaypremium_Output = CommonHelper.ToInt32(dr["Prepaypremium_Output"]);
                v1CalcDC.Prepayallocations_Output = CommonHelper.ToInt32(dr["Prepayallocations_Output"]);
                v1CalcDC.DailyInterestAccOutput = CommonHelper.ToInt32(dr["DailyInterestAccOutput"]);

                lstResult.Add(v1CalcDC);
            }
            return lstResult;
        }

        public void InsertUpdateCalculationQueueRequest(string RequestID, int? TransactionOutput, int? NotePeriodicOutput, int? StrippingOutput, int? Prepaypremium_Output, int? Prepayallocations_Output, int? DailyInterestAcc_Output, int IsRetry, string CreatedBy)
        {
            // 
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TransactionOutput", Value = TransactionOutput };
            SqlParameter p3 = new SqlParameter { ParameterName = "@NotePeriodicOutput", Value = NotePeriodicOutput };
            SqlParameter p4 = new SqlParameter { ParameterName = "@StrippingOutput", Value = StrippingOutput };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Prepaypremium_Output", Value = Prepaypremium_Output };
            SqlParameter p6 = new SqlParameter { ParameterName = "@Prepayallocations_Output", Value = Prepayallocations_Output };

            SqlParameter p7 = new SqlParameter { ParameterName = "@DailyInterestAccOutput", Value = DailyInterestAcc_Output };
            SqlParameter p8 = new SqlParameter { ParameterName = "@IsRetry", Value = IsRetry };
            //
            SqlParameter p9 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9 };
            hp.ExecDataTable("usp_InsertUpdateCalculationQueueRequest", sqlparam);

        }

        public void UpdateCalculationRequestsStatus(string dealid, string RequestID, int Status, string AnalysisID, string UserID, string errmsg)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = dealid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p6 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                hp.ExecDataTable("dbo.usp_UpdateCalculationRequests", sqlparam);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public string UpdateM61EngineCalcStatus(string RequestID, int Status, string errmsg)
        {
            string rtrmsg = "";
            try
            {

                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                DataTable dt = hp.ExecDataTable("dbo.usp_updateM61EnginecalcStatus", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                    rtrmsg = Convert.ToString(dr["ret_status"]);
                }

                if (rtrmsg == "" || rtrmsg == null)
                {
                    rtrmsg = "sp did not update";
                }

                return rtrmsg;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public string UpdateM61EngineCalcStatusForLiability(string RequestID, int Status, string errmsg)
        {
            string rtrmsg = "";
            try
            {

                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                DataTable dt = hp.ExecDataTable("dbo.usp_UpdateM61EngineCalcStatusForLiability", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                    rtrmsg = Convert.ToString(dr["ret_status"]);
                }

                if (rtrmsg == "" || rtrmsg == null)
                {
                    rtrmsg = "sp did not update";
                }

                return rtrmsg;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public DataTable GetDataFromCalculationRequestsByRequestID(string requestid)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = requestid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetDataFromCalculationRequestsByRequestID", sqlparam);

            return dt;
        }

        public V1CalcQueueSaveOutput GetDataFromCalculationRequestsLiabilityByRequestID(string requestid)
        {
            Helper.Helper hp = new Helper.Helper();
            V1CalcQueueSaveOutput v1data = new V1CalcQueueSaveOutput();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = requestid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetDataFromCalculationRequestsLiabilityByRequestID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                v1data.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                v1data.username = Convert.ToString(dr["UserName"]);
                v1data.CalcType = Convert.ToInt32(dr["CalcType"]);
                v1data.requestid = requestid;
            }
            return v1data;
        }

        public int InsertCalculatorOutputJsonInfo_V1(string RequestID, Guid? UserID, String FileName, string FileType)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@FileName", Value = FileName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@FileType", Value = FileType };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            int result = hp.ExecNonquery("dbo.usp_InsertCalculatorOutputJsonInfo_V1", sqlparam);
            return result;
        }

        public int InsertPrepayPremiumEntry(DataTable dtPrepayPremiumoutput, string CreatedBy)
        {

            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblPrepayPremiumoutput", Value = dtPrepayPremiumoutput };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataSet("dbo.usp_InsertDealPrepayProjection", sqlparam);

            return 1;

        }

        public int InsertPrepayAllocationsEntry(DataTable dtPrepayallocationsoutput, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblPrepayallocationsoutput", Value = dtPrepayallocationsoutput };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataSet("dbo.usp_InsertDealPrepayAllocations", sqlparam);

            return 1;

        }

        public void InsertIntoCalculatorExtensionDbSave(string NoteID, string AnalysisID, string RequestID, string FileName, int ServerFileCount)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@FileName", Value = FileName };
            SqlParameter p5 = new SqlParameter { ParameterName = "@ServerFileCount", Value = ServerFileCount };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            int result = hp.ExecNonquery("dbo.usp_InsertIntoCalculatorExtensionDbSave", sqlparam);

        }

        public DataTable GetTransactionEntryFromAccountingClose(string Noteid, string AnalysisID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = Noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetTransactionEntryFromAccountingClose", sqlparam);

            return dt;
        }

        public DataTable GetNoteInfoForPIKExport_V1(string Noteid)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@noteid", Value = Noteid };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetNoteInfoForPIKExport_V1", sqlparam);
            return dt;
        }



        public DataTable GetNotePeriodicCalcFromAccountingClose(string Noteid, string AnalysisID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = Noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetNotePeriodicCalcFromAccountingClose", sqlparam);

            return dt;
        }

        public DataTable GetTransactionTypeIsClub_V1()
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetTransactionTypeIsClub_V1");
            return dt;
        }

        public void InsertNoteExtentionCalcField(string CRENoteID, Guid? AnalysisID, DateTime? MaturityUsedInCalc, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CRENoteID", Value = CRENoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@MaturityUsedInCalc", Value = MaturityUsedInCalc };
            SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            hp.ExecDataTable("usp_InsertNoteExtentionCalcField", sqlparam);
        }




        public string CheckRequestIdInCalcTable(string RequestID)
        {
            string tablename = "";
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                DataTable dt = hp.ExecDataTable("dbo.usp_CheckRequestIdInCalcTable", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                    tablename = Convert.ToString(dr["TableName"]);
                }
                return tablename;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

    }
}
