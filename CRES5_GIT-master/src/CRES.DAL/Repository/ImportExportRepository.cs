using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class ImportExportRepository
    {

        //usp_ImportBackShopInLandingtable
        public void ImportBackShopInUnderwritingtable(string dealname, string username,Guid? BatchLogID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealname };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserName", Value = username };
            SqlParameter p3 = new SqlParameter { ParameterName = "@BatchLogID", Value = BatchLogID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_ImportBackShopInLandingtable", sqlparam);
           // int cnt = dbContext.usp_ImportBackShopInLandingtable(dealname, username, BatchLogID);
        }


        public void ImportLandingtableToMainDB(string dealname, string username,Guid? BatchLogID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealname };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserName", Value = username };
            SqlParameter p3 = new SqlParameter { ParameterName = "@BatchLogID", Value = BatchLogID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
             var res = hp.ExecNonquery("dbo.usp_ImportLandingtableToMainDB", sqlparam);         
           
        }


        public void DeleteINUnderwritingDealDataByDealID(string dealid, Guid? userid)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
           hp.ExecNonquery("dbo.usp_DeleteINUnderwritingDealDataByDealID", sqlparam);
          //  int cnt = dbContext.usp_DeleteINUnderwritingDealDataByDealID(dealid, userid);
        }

        public List<IN_UnderwritingNoteDataContract> GetInUnderwritingNotesByDealID(string dealName, Guid? userid)
        {
            DataTable dt = new DataTable();
            List<IN_UnderwritingNoteDataContract> _iN_UnderwritingNoteDataContractList = new List<IN_UnderwritingNoteDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealName };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetInUnderwritingNotesByDealID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                IN_UnderwritingNoteDataContract _iN_UnderwritingNoteDataContract = new IN_UnderwritingNoteDataContract();

                if (Convert.ToString(dr["IN_UnderwritingNoteID"]) != "")
                {
                    _iN_UnderwritingNoteDataContract.IN_UnderwritingNoteID = new Guid(Convert.ToString(dr["IN_UnderwritingNoteID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingAccountID"]) != "")
                {
                    _iN_UnderwritingNoteDataContract.IN_UnderwritingAccountID = new Guid(Convert.ToString(dr["IN_UnderwritingAccountID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingDealID"]) != "")
                {
                    _iN_UnderwritingNoteDataContract.IN_UnderwritingDealID = new Guid(Convert.ToString(dr["IN_UnderwritingDealID"]));
                }
                _iN_UnderwritingNoteDataContract.Name = Convert.ToString(dr["FeeTypeNameText"]); 
                _iN_UnderwritingNoteDataContract.PayFrequency = CommonHelper.ToInt32(dr["PayFrequency"]); 
                _iN_UnderwritingNoteDataContract.PayFrequencyText = Convert.ToString(dr["PayFrequencyText"]);
                _iN_UnderwritingNoteDataContract.ClientNoteID = Convert.ToString(dr["ClientNoteID"]); 
                _iN_UnderwritingNoteDataContract.ClosingDate = CommonHelper.ToDateTime(dr["ClosingDate"]);
                _iN_UnderwritingNoteDataContract.FirstPaymentDate = CommonHelper.ToDateTime(dr["FirstPaymentDate"]); 
                _iN_UnderwritingNoteDataContract.SelectedMaturityDate = CommonHelper.ToDateTime(dr["SelectedMaturityDate"]); 
                _iN_UnderwritingNoteDataContract.InitialFundingAmount = CommonHelper.ToDecimal(dr["InitialFundingAmount"]);
                _iN_UnderwritingNoteDataContract.OriginationFee = CommonHelper.ToDecimal(dr["OriginationFee"]); 
                _iN_UnderwritingNoteDataContract.IOTerm = CommonHelper.ToInt32(dr["IOTerm"]);
                _iN_UnderwritingNoteDataContract.AmortTerm = CommonHelper.ToInt32(dr["AmortTerm"]); 
                _iN_UnderwritingNoteDataContract.DeterminationDateLeadDays = CommonHelper.ToInt32(dr["DeterminationDateLeadDays"]); 
                _iN_UnderwritingNoteDataContract.DeterminationDateReferenceDayoftheMonth = CommonHelper.ToInt32(dr["DeterminationDateReferenceDayoftheMonth"]); 
                _iN_UnderwritingNoteDataContract.RoundingMethod = CommonHelper.ToInt32(dr["RoundingMethod"]); 
                _iN_UnderwritingNoteDataContract.RoundingMethodText = Convert.ToString(dr["RoundingMethodText"]); 
                _iN_UnderwritingNoteDataContract.IndexRoundingRule = CommonHelper.ToInt32(dr["IndexRoundingRule"]);
                _iN_UnderwritingNoteDataContract.StatusID = CommonHelper.ToInt32(dr["StatusID"]); 
                _iN_UnderwritingNoteDataContract.StatusIDText = Convert.ToString(dr["StatusIDText"]); 
                 _iN_UnderwritingNoteDataContract.ExpectedMaturityDate = CommonHelper.ToDateTime(dr["ExpectedMaturityDate"]); 
                _iN_UnderwritingNoteDataContract.ExtendedMaturityScenario1 = CommonHelper.ToDateTime(dr["ExtendedMaturityScenario1"]); 
                _iN_UnderwritingNoteDataContract.ExtendedMaturityScenario2 = CommonHelper.ToDateTime(dr["ExtendedMaturityScenario2"]); 
                _iN_UnderwritingNoteDataContract.ExtendedMaturityScenario3 = CommonHelper.ToDateTime(dr["ExtendedMaturityScenario3"]); 

                _iN_UnderwritingNoteDataContract.InitialMaturityDate = CommonHelper.ToDateTime(dr["InitialMaturityDate"]);

                _iN_UnderwritingNoteDataContract.lienposition = CommonHelper.ToInt32(dr["lienposition"]);
                _iN_UnderwritingNoteDataContract.lienpositionText = Convert.ToString(dr["lienpositionText"]);
                _iN_UnderwritingNoteDataContract.priority = CommonHelper.ToInt32(dr["priority"]);

                _iN_UnderwritingNoteDataContract.NoteExistsInDiffDeal = Convert.ToInt32(dr["NoteExistsInDiffDeal"]);
                _iN_UnderwritingNoteDataContract.NoteExistsInDiffDealName = Convert.ToString(dr["NoteExistsInDiffDealName"]);

                _iN_UnderwritingNoteDataContractList.Add(_iN_UnderwritingNoteDataContract);

            }

            return _iN_UnderwritingNoteDataContractList;
        }

        public BackShopImportDataContract GetBackshopDealByDealName(string dealname)
        {

            DataTable dt = new DataTable();
            BackShopImportDataContract _backShopImportDataContract = new BackShopImportDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealName", Value = dealname };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("IO.usp_GetBackshopDealByDealName", sqlparam);

            // var backshopdealList = dbContext.usp_GetBackshopDealByDealName(dealname);
            foreach (DataRow dr in dt.Rows)
            {
                _backShopImportDataContract.DealName = Convert.ToString(dr["DealName"]); 
                _backShopImportDataContract.DealID = Convert.ToString(dr["DealID"]); 
            }

            return _backShopImportDataContract;
        }

        public List<IN_UnderwritingNoteDataContract> GetInUnderwritingNotesByDealName(string dealName, Guid? userid)
        {

            //CRESEntities dbContext = new CRESEntities();
            List<IN_UnderwritingNoteDataContract> _iN_UnderwritingNoteDataContractList = new List<IN_UnderwritingNoteDataContract>();

            //var in_UnderwritingNoteList = dbContext.usp_GetInUnderwritingNotesByDealName(dealName, userid);
            //foreach (var item in in_UnderwritingNoteList)
            //{
            //    IN_UnderwritingNoteDataContract _iN_UnderwritingNoteDataContract = new IN_UnderwritingNoteDataContract();

            //    _iN_UnderwritingNoteDataContract.IN_UnderwritingNoteID = item.IN_UnderwritingNoteID;
            //    _iN_UnderwritingNoteDataContract.IN_UnderwritingAccountID = item.IN_UnderwritingAccountID;
            //    _iN_UnderwritingNoteDataContract.IN_UnderwritingDealID = item.IN_UnderwritingDealID;
            //    _iN_UnderwritingNoteDataContract.Name = item.Name;
            //    _iN_UnderwritingNoteDataContract.PayFrequency = item.PayFrequency;
            //    _iN_UnderwritingNoteDataContract.PayFrequencyText = item.PayFrequencyText;
            //    _iN_UnderwritingNoteDataContract.ClientNoteID = item.ClientNoteID;
            //    _iN_UnderwritingNoteDataContract.ClosingDate = item.ClosingDate;
            //    _iN_UnderwritingNoteDataContract.FirstPaymentDate = item.FirstPaymentDate;
            //    _iN_UnderwritingNoteDataContract.SelectedMaturityDate = item.SelectedMaturityDate;
            //    _iN_UnderwritingNoteDataContract.InitialFundingAmount = item.InitialFundingAmount;
            //    _iN_UnderwritingNoteDataContract.OriginationFee = item.OriginationFee;
            //    _iN_UnderwritingNoteDataContract.IOTerm = item.IOTerm;
            //    _iN_UnderwritingNoteDataContract.AmortTerm = item.AmortTerm;
            //    _iN_UnderwritingNoteDataContract.DeterminationDateLeadDays = item.DeterminationDateLeadDays;
            //    _iN_UnderwritingNoteDataContract.DeterminationDateReferenceDayoftheMonth = item.DeterminationDateReferenceDayoftheMonth;
            //    _iN_UnderwritingNoteDataContract.RoundingMethod = item.RoundingMethod;
            //    _iN_UnderwritingNoteDataContract.RoundingMethodText = item.RoundingMethodText;
            //    _iN_UnderwritingNoteDataContract.IndexRoundingRule = item.IndexRoundingRule;
            //    _iN_UnderwritingNoteDataContract.StatusID = item.StatusID;
            //    _iN_UnderwritingNoteDataContract.StatusIDText = item.StatusIDText;

            //    _iN_UnderwritingNoteDataContractList.Add(_iN_UnderwritingNoteDataContract);

            //}

            return _iN_UnderwritingNoteDataContractList;
        }

        public List<IN_UnderwritingRateSpreadScheduleDataContract> GetINUnderwritingRateSpreadScheduleByNoteID(Guid? noteid, Guid? userid)
        {

            DataTable dt = new DataTable();
            List<IN_UnderwritingRateSpreadScheduleDataContract> _iN_UnderwritingRateSpreadScheduleDataContractList = new List<IN_UnderwritingRateSpreadScheduleDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetINUnderwritingRateSpreadScheduleByNoteID", sqlparam);

           // var in_UnderwritingRSList = dbContext.usp_GetINUnderwritingRateSpreadScheduleByNoteID(noteid, userid);

            foreach (DataRow dr in dt.Rows)
            {
                IN_UnderwritingRateSpreadScheduleDataContract _in_UnderwritingRateSpreadScheduleDataContract = new IN_UnderwritingRateSpreadScheduleDataContract();
                if (Convert.ToString(dr["IN_UnderwritingNoteID"]) != "")
                {
                    _in_UnderwritingRateSpreadScheduleDataContract.IN_UnderwritingNoteID = new Guid(Convert.ToString(dr["IN_UnderwritingNoteID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingAccountID"]) != "")
                {
                    _in_UnderwritingRateSpreadScheduleDataContract.IN_UnderwritingAccountID = new Guid(Convert.ToString(dr["IN_UnderwritingAccountID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingRateSpreadScheduleID"]) != "")
                {
                    _in_UnderwritingRateSpreadScheduleDataContract.IN_UnderwritingRateSpreadScheduleID = new Guid(Convert.ToString(dr["IN_UnderwritingRateSpreadScheduleID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingEventID"]) != "")
                {
                    _in_UnderwritingRateSpreadScheduleDataContract.IN_UnderwritingEventID = new Guid(Convert.ToString(dr["IN_UnderwritingEventID"])); 
                }
                _in_UnderwritingRateSpreadScheduleDataContract.Date = CommonHelper.ToDateTime(dr["Date"]);
                _in_UnderwritingRateSpreadScheduleDataContract.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                _in_UnderwritingRateSpreadScheduleDataContract.ValueTypeIDText = Convert.ToString(dr["ValueTypeIDText"]); 
                _in_UnderwritingRateSpreadScheduleDataContract.Value = CommonHelper.ToDecimal(dr["Value"]);
                _in_UnderwritingRateSpreadScheduleDataContract.IntCalcMethodID = CommonHelper.ToInt32(dr["IntCalcMethodID"]);
                _in_UnderwritingRateSpreadScheduleDataContract.IntCalcMethodIDText = Convert.ToString(dr["IntCalcMethodIDText"]);
                _in_UnderwritingRateSpreadScheduleDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]); 
                _in_UnderwritingRateSpreadScheduleDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _in_UnderwritingRateSpreadScheduleDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]); 
                _in_UnderwritingRateSpreadScheduleDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                _iN_UnderwritingRateSpreadScheduleDataContractList.Add(_in_UnderwritingRateSpreadScheduleDataContract);

            }

            return _iN_UnderwritingRateSpreadScheduleDataContractList;
        }

        
        public List<IN_UnderwritingStrippingScheduleDataContract> GetINUnderwritingStrippingScheduleByNoteID(Guid? noteid, Guid? userid)
        {

                DataTable dt = new DataTable();
                List<IN_UnderwritingStrippingScheduleDataContract> _in_UnderwritingStrippingScheduleDataContractList = new List<IN_UnderwritingStrippingScheduleDataContract>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetINUnderwritingStrippingScheduleByNoteID", sqlparam);

               // var in_UnderwritingSSList = dbContext.usp_GetINUnderwritingStrippingScheduleByNoteID(noteid, userid);
            foreach (DataRow dr in dt.Rows)
            {
                IN_UnderwritingStrippingScheduleDataContract _in_UnderwritingStrippingScheduleDataContract= new IN_UnderwritingStrippingScheduleDataContract();
                if (Convert.ToString(dr["IN_UnderwritingNoteID"]) != "")
                {
                    _in_UnderwritingStrippingScheduleDataContract.IN_UnderwritingNoteID = new Guid(Convert.ToString(dr["IN_UnderwritingNoteID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingAccountID"]) != "")
                {
                    _in_UnderwritingStrippingScheduleDataContract.IN_UnderwritingAccountID = new Guid(Convert.ToString(dr["IN_UnderwritingAccountID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingStrippingScheduleID"]) != "")
                {
                    _in_UnderwritingStrippingScheduleDataContract.IN_UnderwritingStrippingScheduleID = new Guid(Convert.ToString(dr["IN_UnderwritingStrippingScheduleID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingEventID"]) != "")
                {
                    _in_UnderwritingStrippingScheduleDataContract.IN_UnderwritingEventID = new Guid(Convert.ToString(dr["IN_UnderwritingEventID"]));
                }
               
                _in_UnderwritingStrippingScheduleDataContract.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                _in_UnderwritingStrippingScheduleDataContract.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                _in_UnderwritingStrippingScheduleDataContract.ValueTypeIDText = Convert.ToString(dr["ValueTypeIDText"]);
                _in_UnderwritingStrippingScheduleDataContract.Value = Convert.ToDecimal(dr["Value"]);
                _in_UnderwritingStrippingScheduleDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _in_UnderwritingStrippingScheduleDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _in_UnderwritingStrippingScheduleDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _in_UnderwritingStrippingScheduleDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);


                _in_UnderwritingStrippingScheduleDataContractList.Add(_in_UnderwritingStrippingScheduleDataContract);

            }

            return _in_UnderwritingStrippingScheduleDataContractList;
        }


        public List<IN_UnderwritingPIKScheduleDataContract> GetINUnderwritingPIKScheduleByNoteID(Guid? noteid, Guid? userid)
        {
            DataTable dt = new DataTable();
            List<IN_UnderwritingPIKScheduleDataContract> _in_UnderwritingPIKScheduleDataContractList = new List<IN_UnderwritingPIKScheduleDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("IO.usp_GetINUnderwritingPIKScheduleByNoteID", sqlparam);

            // var in_UnderwritingSSList = dbContext.usp_GetINUnderwritingPIKScheduleByNoteID(noteid, userid);
            foreach (DataRow dr in dt.Rows)
            {
                IN_UnderwritingPIKScheduleDataContract _in_UnderwritingPIKScheduleDataContract = new IN_UnderwritingPIKScheduleDataContract();
                if (Convert.ToString(dr["IN_UnderwritingNoteID"]) != "")
                {
                    _in_UnderwritingPIKScheduleDataContract.IN_UnderwritingNoteID = new Guid(Convert.ToString(dr["IN_UnderwritingNoteID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingAccountID"]) != "")
                {
                    _in_UnderwritingPIKScheduleDataContract.IN_UnderwritingAccountID = new Guid(Convert.ToString(dr["IN_UnderwritingAccountID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingPIKScheduleID"]) != "")
                {
                    _in_UnderwritingPIKScheduleDataContract.IN_UnderwritingPIKScheduleID = new Guid(Convert.ToString(dr["IN_UnderwritingPIKScheduleID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingEventID"]) != "")
                {
                    _in_UnderwritingPIKScheduleDataContract.IN_UnderwritingEventID = new Guid(Convert.ToString(dr["IN_UnderwritingEventID"]));
                }

                _in_UnderwritingPIKScheduleDataContract.AdditionalIntRate = CommonHelper.ToDecimal(dr["AdditionalIntRate"]);
                _in_UnderwritingPIKScheduleDataContract.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                _in_UnderwritingPIKScheduleDataContract.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                _in_UnderwritingPIKScheduleDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _in_UnderwritingPIKScheduleDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _in_UnderwritingPIKScheduleDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _in_UnderwritingPIKScheduleDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                _in_UnderwritingPIKScheduleDataContractList.Add(_in_UnderwritingPIKScheduleDataContract);

            }

            return _in_UnderwritingPIKScheduleDataContractList;
        }


        public List<IN_UnderwritingFundingScheduleDataContract> GetINUnderwritingFundingScheduleByNoteID(Guid? noteid, Guid? userid)
        {
            DataTable dt = new DataTable();
            List<IN_UnderwritingFundingScheduleDataContract> _in_UnderwritingFundingScheduleDataContractList = new List<IN_UnderwritingFundingScheduleDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("IO.usp_GetINUnderwritingFundingScheduleByNoteID", sqlparam);

            //var in_UnderwritingFFList = dbContext.usp_GetINUnderwritingFundingScheduleByNoteID(noteid, userid);

            foreach (DataRow dr in dt.Rows)
            {
                IN_UnderwritingFundingScheduleDataContract _in_UnderwritingFundingScheduleDataContract = new IN_UnderwritingFundingScheduleDataContract();

                if (Convert.ToString(dr["IN_UnderwritingNoteID"]) != "")
                {
                    _in_UnderwritingFundingScheduleDataContract.IN_UnderwritingNoteID = new Guid(Convert.ToString(dr["IN_UnderwritingNoteID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingAccountID"]) != "")
                {
                    _in_UnderwritingFundingScheduleDataContract.IN_UnderwritingAccountID = new Guid(Convert.ToString(dr["IN_UnderwritingAccountID"]));
                }
                if (Convert.ToString(dr["IN_UnderwritingFundingScheduleID"]) != "")
                {
                    _in_UnderwritingFundingScheduleDataContract.IN_UnderwritingFundingScheduleID = new Guid(Convert.ToString(dr["IN_UnderwritingFundingScheduleID"]));
                }

                _in_UnderwritingFundingScheduleDataContract.Date = CommonHelper.ToDateTime(dr["Date"]);
                _in_UnderwritingFundingScheduleDataContract.Value = CommonHelper.ToDecimal(dr["Value"]);


                _in_UnderwritingFundingScheduleDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _in_UnderwritingFundingScheduleDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _in_UnderwritingFundingScheduleDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _in_UnderwritingFundingScheduleDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                _in_UnderwritingFundingScheduleDataContractList.Add(_in_UnderwritingFundingScheduleDataContract);

            }

            return _in_UnderwritingFundingScheduleDataContractList;
        }



        public int InsertBatchLog(BatchLogDataContract _batchLogDataContract, out Guid? outBatchLogID,string username)
        {
            // ObjectParameter PoutBatchLogID = new ObjectParameter("outBatchLogID", typeof(Guid));
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchTypeID", Value = _batchLogDataContract.BatchTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@StartedByUserID", Value = _batchLogDataContract.StartedByUserID};
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserName", Value = username };
            SqlParameter p4 = new SqlParameter { ParameterName = "@outBatchLogID", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            int result = hp.ExecNonquery("IO.usp_InsertBatchLog", sqlparam);
            //var res = dbContext.usp_InsertBatchLog(
            //_batchLogDataContract.BatchTypeID,
            //_batchLogDataContract.StartedByUserID,
            //username,

            //PoutBatchLogID
            //);


           // outBatchLogID = new Guid(PoutBatchLogID.Value.ToString());

           // return res;

            outBatchLogID = new Guid(p4.Value.ToString());
            return result;
        }



        public void DeleteBatchLogByBatchLogID(Guid? BatchLogID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogID", Value = BatchLogID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
             hp.ExecNonquery("IO.usp_DeleteBatchLogByBatchLogID", sqlparam);
           // int cnt = dbContext.usp_DeleteBatchLogByBatchLogID(BatchLogID);
        }


        public IN_UnderwritingDealDataContract GetINUnderwritingDealByDealIdorDealName(string dealnameordealid)
        {

            DataTable dt = new DataTable();
            IN_UnderwritingDealDataContract _iN_UnderwritingDealDataContract = new IN_UnderwritingDealDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealName", Value = dealnameordealid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("IO.usp_GetINUnderwritingDealByDealIdorDealName", sqlparam);

            // var inUnderwritingdealList = dbContext.usp_GetINUnderwritingDealByDealIdorDealName(dealnameordealid);
            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["IN_UnderwritingDealID"]) != "")
                {
                    _iN_UnderwritingDealDataContract.IN_UnderwritingDealID = new Guid(Convert.ToString(dr["IN_UnderwritingDealID"]));
                }
               
                _iN_UnderwritingDealDataContract.ClientDealID = Convert.ToString(dr["ClientDealID"]);
                _iN_UnderwritingDealDataContract.DealName = Convert.ToString(dr["DealName"]); 
                _iN_UnderwritingDealDataContract.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                _iN_UnderwritingDealDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]); 
                _iN_UnderwritingDealDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]); 
                _iN_UnderwritingDealDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]); 
                _iN_UnderwritingDealDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]); 

                _iN_UnderwritingDealDataContract.AssetManager = Convert.ToString(dr["AssetManager"]); 
                _iN_UnderwritingDealDataContract.DealCity = Convert.ToString(dr["DealCity"]); 
                _iN_UnderwritingDealDataContract.DealState = Convert.ToString(dr["DealState"]); 
                _iN_UnderwritingDealDataContract.DealPropertyType = Convert.ToString(dr["DealPropertyType"]); 
                _iN_UnderwritingDealDataContract.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                _iN_UnderwritingDealDataContract.FullyExtMaturityDate = CommonHelper.ToDateTime(dr["FullyExtMaturityDate"]); 
            }
            return _iN_UnderwritingDealDataContract;
        }
        public List<FileImportMasterDataContract> GetFileImportMaster()
        {
            List<FileImportMasterDataContract> lstfiles = new List<FileImportMasterDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetFileImportMaster", null);
            foreach (DataRow dr in dt.Rows)
            {
                FileImportMasterDataContract reportfiledc = new FileImportMasterDataContract();
                reportfiledc.FileImportMasterID = Convert.ToInt32(dr["FileImportMasterID"]);
                reportfiledc.FileName = Convert.ToString(dr["FileName"].ToString());
                reportfiledc.ObjectTypeID = Convert.ToInt32(dr["ObjectTypeID"]);
                reportfiledc.SourceStorageTypeID = Convert.ToInt32(dr["SourceStorageTypeID"]);
                reportfiledc.SourceStorageLocation = Convert.ToString(dr["SourceStorageLocation"]);
                reportfiledc.HeaderPosition = Convert.ToInt32(dr["HeaderPosition"]);
                reportfiledc.Status = Convert.ToInt32(dr["Status"]);
                reportfiledc.Frequency = Convert.ToString(dr["Frequency"]);
                reportfiledc.LastExecutionTime = CommonHelper.ToDateTime(dr["LastExecutionTime"]);
                lstfiles.Add(reportfiledc);
            }
            return lstfiles;
        }

        public List<FileImportColumnMappingDataContract> GetFileImportColumnMappingByID(int FileImportMasterID)
        {
            List<FileImportColumnMappingDataContract> lstfiles = new List<FileImportColumnMappingDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@FileImportMasterID", Value = FileImportMasterID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFileImportColumnMappingByID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                FileImportColumnMappingDataContract reportfiledc = new FileImportColumnMappingDataContract();
                reportfiledc.FileImportColumnMappingID = Convert.ToInt32(dr["FileImportColumnMappingID"]);
                reportfiledc.FileImportMasterID = Convert.ToInt32(dr["FileImportMasterID"]);
                reportfiledc.FileColumnName = Convert.ToString(dr["FileColumnName"].ToString());
                reportfiledc.LandingColumnName = Convert.ToString(dr["LandingColumnName"]);
                lstfiles.Add(reportfiledc);
            }
            return lstfiles;
        }

        public int InsertBerkadiaDataTap(DataTable dtBerkadia, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeBerkadiaDataTap", Value = dtBerkadia };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            return hp.ExecDataTablewithparams("dbo.usp_InsertBerkadiaDataTap", sqlparam);
        }

        public void ImportServicerBalance()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecDataTablewithparams("dw.usp_ImportServicerBalance");
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        //public int InsertWellsDataTap(DataTable dtWells, string CreatedBy)
        //{
        //    Helper.Helper hp = new Helper.Helper();
        //    SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeWellsDataTap", Value = dtWells };
        //    SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
        //    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
        //    return hp.ExecDataTablewithparams("dbo.usp_InsertWellsDataTap", sqlparam);
        //}
    }
}
