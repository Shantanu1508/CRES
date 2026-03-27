using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using CRES.DAL.IRepository;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class TagXIRRRepository : ITagXIRRRepository
    {
        public DataTable GetAllNoteTagsXIRR(Guid? UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllTagMasterXIRR", sqlparam);
            return dt;
        }
        public void InsertUpdateNoteTagsXIRR(DataTable NoteTagsXIRR, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TabletypXIRR", Value = NoteTagsXIRR };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataTablewithparams("dbo.usp_InsertUpdateTagMasterXIRR", sqlparam);
        }
        public void deleteNoteTagsXIRR(int? TagMasterXIRRID, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TagMasterXIRRID", Value = TagMasterXIRRID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var count = hp.ExecNonquery("dbo.usp_DeleteTagMasterXIRR", sqlparam);
        }
        public List<TagMasterXIRRDataContract> GetTagMasterXIRRByAccountID(string NoteAccountID)
        {
            Helper.Helper hp = new Helper.Helper();
            List<TagMasterXIRRDataContract> TagData = new List<TagMasterXIRRDataContract>();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = NoteAccountID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("usp_GetTagMasterXIRRByAccountID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                TagMasterXIRRDataContract lsttagData = new TagMasterXIRRDataContract();
                lsttagData.TagMasterXIRRID = Convert.ToInt32(dr["TagMasterXIRRID"]);
                lsttagData.Name = Convert.ToString(dr["Name"]);
                TagData.Add(lsttagData);
            }
            return TagData;
        }
        public void InsertUpdateTagAccountMappingXIRR(string NoteAccountID, List<TagMasterXIRRDataContract> _tagXIRRDC, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                int result;

                List<int> tagIdsList = _tagXIRRDC.Select(tag => tag.TagMasterXIRRID).ToList();


                string tagIdsString = string.Join(",", tagIdsList);

                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = NoteAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TagIds", Value = tagIdsString };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                result = hp.ExecDataTablewithparams("dbo.usp_InsertUpdateTagAccountMappingXIRR", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataTable GetXIRROutputByConfigID(int XIRRConfigID, string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutputByConfigID", sqlparam);
            return dt;
        }

        public List<XIRRCalculationRequestsDataContract> GetProcessingXIRRRequestsFromDB()
        {
            List<XIRRCalculationRequestsDataContract> list = new List<XIRRCalculationRequestsDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetRequestsFromXirrCalculationRequest");
            foreach (DataRow dr in dt.Rows)
            {
                XIRRCalculationRequestsDataContract lstData = new XIRRCalculationRequestsDataContract();

                lstData.XIRRCalculationRequestsID = CommonHelper.ToInt32(dr["XIRRCalculationRequestsID"]);
                lstData.XIRRConfigID = CommonHelper.ToInt32(dr["XIRRConfigID"]);
                lstData.XIRRReturnGroupID = CommonHelper.ToInt32(dr["XIRRReturnGroupID"]);
                lstData.DealAccountID = Convert.ToString(dr["DealAccountID"]);
                lstData.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                lstData.Type = Convert.ToString(dr["Type"]);
                lstData.UserID = Convert.ToString(dr["UserID"]);
                lstData.IsCreateFile = Convert.ToBoolean(dr["IsCreateFile"]);

                list.Add(lstData);
            }
            return list;
        }

        public DataTable GetTransactionsForXirrCalculation(int? XIRRConfigID, int? XIRRReturnGroupID, string Type, string DealAccountID, string AnalysisID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XIRRReturnGroupID ", Value = XIRRReturnGroupID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Type", Value = Type };
            SqlParameter p4 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
            SqlParameter p5 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetTransactionsForXirrCalculation", sqlparam);
            return dt;
        }

        public void ArchiveXIRROutput(XIRRConfigParamDataContract XIRRConfigParam, string UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigIDs", Value = XIRRConfigParam.XIRRConfigIDs };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ArchiveDate", Value = XIRRConfigParam.ArchiveDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            var count = hp.ExecNonquery("dbo.usp_ArchiveXIRROutput", sqlparam);
        }

        public void UpdateCalcStatus(int? XIRRCalculationRequestsID, string StatusText, string ColumnName, string ErrorMessage, string UpdatedBy)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRCalculationRequestsID", Value = XIRRCalculationRequestsID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@StatusText", Value = StatusText.ToString() };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ColumnName", Value = ColumnName.ToString() };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ErrorMessage", Value = ErrorMessage.ToString() };
                SqlParameter p5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy.ToString() };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                hp.ExecNonquery("usp_UpdateCalculationStatusAndTime_XIRRCalculationRequests", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }


        public void InsertXIRROutput(int? XIRRConfigID, int? XIRRReturnGroupID, string Type, string DealAccountID, decimal XIRRValue, string AnalysisID, string UserID)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@XIRRReturnGroupID", Value = XIRRReturnGroupID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Type", Value = Type };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@XIRRValue", Value = XIRRValue };
                SqlParameter p6 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
                hp.ExecNonquery("dbo.usp_InsertXIRROutput", sqlparam);
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }



        public void DeleteXIRRByXIRRConfigID(int deletedXIRRConfigID)
        {
            Helper.Helper hp = new Helper.Helper();

            try
            {
                SqlParameter p11 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = deletedXIRRConfigID };
                SqlParameter[] sqlparamDelete = new SqlParameter[] { p11 };
                var count = hp.ExecNonquery("dbo.usp_DeleteXIRRByXIRRConfigID", sqlparamDelete);
            }
            catch (Exception)
            {

                throw;
            }

        }

        public int InsertUpdateXIRRConfigs(XIRRConfigDataContract xirrConfig, Guid UserID)
        {
            int NewXIRRConfigID;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = xirrConfig.XIRRConfigID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ReturnName", Value = xirrConfig.ReturnName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Type", Value = xirrConfig.Type };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = xirrConfig.AnalysisID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Comments", Value = xirrConfig.Comments };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Group1", Value = xirrConfig.Group1 };
                SqlParameter p7 = new SqlParameter { ParameterName = "@Group2", Value = xirrConfig.Group2 };
                SqlParameter p8 = new SqlParameter { ParameterName = "@ArchivalRequirement", Value = xirrConfig.ArchivalRequirement };
                SqlParameter p9 = new SqlParameter { ParameterName = "@ReferencingDealLevelReturn", Value = xirrConfig.ReferencingDealLevelReturn ?? (object)DBNull.Value };
                SqlParameter p10 = new SqlParameter { ParameterName = "@UpdateXIRRLinkedDeal", Value = xirrConfig.UpdateXIRRLinkedDeal };
                SqlParameter p11 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p12 = new SqlParameter { ParameterName = "@isSystemGenerated", Value = xirrConfig.isSystemGenerated };
                SqlParameter p13 = new SqlParameter { ParameterName = "@NewXIRRConfigID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p14 = new SqlParameter { ParameterName = "@CutoffRelativeDateID", Value = xirrConfig.CutoffRelativeDateID ?? (object)DBNull.Value };
                SqlParameter p15 = new SqlParameter { ParameterName = "@CutoffDateOverride", Value = xirrConfig.CutoffDateOverride ?? (object)DBNull.Value };
                SqlParameter p16 = new SqlParameter { ParameterName = "@ShowReturnonDealScreen", Value = xirrConfig.ShowReturnonDealScreen ?? (object)DBNull.Value };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16 };
                hp.ExecDataTablewithparams("dbo.usp_InsertUpdateXIRRConfig", sqlparam);
                NewXIRRConfigID = Convert.ToInt32(p13.Value);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            if (NewXIRRConfigID != 0)
                return NewXIRRConfigID;
            else
                return 0;
        }

        public void InsertUpdateXIRRConfigDetail(List<XIRRConfigDataContract> ListXirrConfig, List<XIRRConfigFilterDataContract> ListXirrConfigFilter, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable XIRRConfigData = new DataTable();
            XIRRConfigData.Columns.Add("XIRRConfigID");
            XIRRConfigData.Columns.Add("ObjectType");
            XIRRConfigData.Columns.Add("ObjectID");

            if (ListXirrConfig != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(ListXirrConfig);

                foreach (DataRow dr in dt.Rows)
                {
                    XIRRConfigData.ImportRow(dr);
                }
            }

            DataTable XIRRFilterData = new DataTable();
            XIRRFilterData.Columns.Add("XIRRConfigID");
            XIRRFilterData.Columns.Add("XIRRFilterSetupID");
            XIRRFilterData.Columns.Add("FilterDropDownValue");

            if (ListXirrConfigFilter != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(ListXirrConfigFilter);

                foreach (DataRow dr in dt.Rows)
                {
                    XIRRFilterData.ImportRow(dr);
                }
            }

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeXIRRConfigDetail", Value = XIRRConfigData };
            SqlParameter p2 = new SqlParameter { ParameterName = "@tbltypXIRRConfigFilters", Value = XIRRFilterData };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecDataTablewithparams("dbo.usp_InsertUpdateXIRRConfigDetail", sqlparam);
        }

        public int? GetReferencingDealLevelReturnWithSameConfig(int XIRRConfigID)
        {
            int? RefrencingDealLevel_XIRRConfigID = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@RefrencingDealLevel_XIRRConfigID", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("dbo.usp_GetReferencingDealLevelReturnWithSameConfig", sqlparam);
                if (p2.Value != DBNull.Value)
                {
                    RefrencingDealLevel_XIRRConfigID = Convert.ToInt32(p2.Value);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return RefrencingDealLevel_XIRRConfigID;
        }


        public List<TransactionTypesDataContract> GetAllTransactionTypesforXIRRConfig()
        {
            DataTable dt = new DataTable();
            List<TransactionTypesDataContract> lstDC = new List<TransactionTypesDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetAllTransactionTypesforXIRRConfig");

            foreach (DataRow dr in dt.Rows)
            {
                TransactionTypesDataContract TT = new TransactionTypesDataContract();
                TT.TransactionName = Convert.ToString(dr["TransactionName"]);
                TT.TransactionTypesID = CommonHelper.ToInt32(dr["TransactionTypesID"]);
                TT.TransactionCategory = Convert.ToString(dr["XIRRCategory"]);
                lstDC.Add(TT);
            }

            return lstDC;
        }
        public List<XIRRFiltersLookupDataContract> GetLookupforXIRRFilters(int XIRRConfigID)
        {
            DataTable dt = new DataTable();
            List<XIRRFiltersLookupDataContract> lstDC = new List<XIRRFiltersLookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetLookupforXIRRFilters", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                XIRRFiltersLookupDataContract XirrFilters = new XIRRFiltersLookupDataContract();
                XirrFilters.LookupID = Convert.ToString(dr["LookupID"]);
                XirrFilters.Name = Convert.ToString(dr["Name"]);
                XirrFilters.Type = Convert.ToString(dr["Type"]);
                lstDC.Add(XirrFilters);
            }

            return lstDC;
        }

        public List<LookupDataContract> GetXIRRReferencingDealLevelReturnLookup()
        {
            DataTable dt = new DataTable();
            List<LookupDataContract> lstDC = new List<LookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetXIRRReferencingDealLevelReturnLookup");

            foreach (DataRow dr in dt.Rows)
            {
                LookupDataContract lookup = new LookupDataContract();
                lookup.LookupID = Convert.ToInt32(dr["XIRRConfigID"]);
                lookup.Name = Convert.ToString(dr["ReturnName"]);
                lstDC.Add(lookup);
            }

            return lstDC;
        }

        public void UpdateReferencingDealLevelReturnforPortfolioType(int? XIRRConfigIdDealCopy, int XIRRConfigIdPortfolio)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigIdDealCopy", Value = XIRRConfigIdDealCopy };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XIRRConfigIdPortfolio", Value = XIRRConfigIdPortfolio };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataTablewithparams("dbo.usp_UpdateReferencingDealLevelReturnforPortfolioType", sqlparam);
        }

        public DataTable GetXIRRConfig()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetXIRRConfig");
            return dt;
        }

        public List<XIRRConfigFilterDataContract> GetXIRRFilters()
        {
            DataTable dt = new DataTable();
            List<XIRRConfigFilterDataContract> lstfilters = new List<XIRRConfigFilterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetXIRRFilters");

            foreach (DataRow dr in dt.Rows)
            {
                XIRRConfigFilterDataContract XirrFilters = new XIRRConfigFilterDataContract();
                XirrFilters.RowNumber = CommonHelper.ToInt32(dr["RowNumber"]);
                XirrFilters.XIRRConfigID = CommonHelper.ToInt32(dr["XIRRConfigID"]);
                XirrFilters.XIRRFilterSetupID = CommonHelper.ToInt32(dr["XIRRFilterSetupID"]);
                XirrFilters.FilterDropDownValue = Convert.ToString(dr["FilterDropDownValue"]);

                lstfilters.Add(XirrFilters);
            }
            return lstfilters;
        }
        public List<XIRRConfigFilterDataContract> GetXirrFilterSetupNames()
        {
            DataTable dt = new DataTable();
            List<XIRRConfigFilterDataContract> lstfilterNames = new List<XIRRConfigFilterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetXirrFilterSetupNames");

            foreach (DataRow dr in dt.Rows)
            {
                XIRRConfigFilterDataContract xirrFilter = new XIRRConfigFilterDataContract();
                xirrFilter.XIRRFilterSetupID = CommonHelper.ToInt32(dr["XIRRFilterSetupID"]);
                xirrFilter.FilterName = Convert.ToString(dr["Name"]);

                lstfilterNames.Add(xirrFilter);
            }
            return lstfilterNames;
        }

        public DataTable GetXIRROutputByObjectID(string ObjectType, string AccountID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectType", Value = ObjectType };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectID", Value = AccountID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutputByObjectID", sqlparam);
            return dt;
        }

        public DataTable GetXIRRCalculationStatusByObjectID(string XIRRCalculationRequestsID, string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRCalculationRequestsID", Value = XIRRCalculationRequestsID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRCalculationStatusByObjectID", sqlparam);
            return dt;
        }

        public DataTable GetXIRRViewNotesByObjectID(string ObjectID, int? XIRRConfigID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectID", Value = ObjectID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRViewNotesByObjectID", sqlparam);
            return dt;
        }

        public void InsertXIRRCalculationInput(XIRRConfigParamDataContract XIRRConfigParam, string UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigIDs", Value = XIRRConfigParam.XIRRConfigIDs };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var count = hp.ExecNonquery("dbo.usp_InsertXIRRCalculationInput", sqlparam);
        }
        public List<XIRRArchiveDataContract> GetAllArchiveXIRROutput(Guid? UserID)
        {
            List<XIRRArchiveDataContract> lstxirr = new List<XIRRArchiveDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllArchiveXIRROutput", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                XIRRArchiveDataContract xirr = new XIRRArchiveDataContract();
                xirr.XIRRConfigID = Convert.ToInt32(dr["XIRRConfigID"]);
                xirr.FileNameInput = Convert.ToString(dr["FileNameInput"]);
                xirr.FileNameOutput = Convert.ToString(dr["FileNameOutput"]);
                xirr.ReturnName = Convert.ToString(dr["ReturnName"]);
                xirr.Tags = Convert.ToString(dr["Tag"]);
                xirr.Type = Convert.ToString(dr["Type"]);
                xirr.TransactionType = Convert.ToString(dr["Transaction"]);
                xirr.Scenario = Convert.ToString(dr["Scenario"]);
                xirr.ArchiveDate = CommonHelper.ToDateTime(dr["ArchiveDate"]);
                xirr.Comments = Convert.ToString(dr["Comments"]);
                lstxirr.Add(xirr);
            }
            return lstxirr;
        }

        public DataTable GetXIRROutputArchive(int XIRRConfigID, DateTime ArchiveDate, string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ArchiveDate", Value = ArchiveDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutputArchive", sqlparam);
            return dt;
        }

        public DataTable GetViewAttachedNotes(int? TagMasterXIRRID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TagMasterXIRRID", Value = TagMasterXIRRID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetViewAttachedNotes", sqlparam);
            return dt;
        }


        public DataTable GetXIRRInputByConfigID(int XIRRConfigID, string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRInputByConfigID", sqlparam);
            return dt;
        }

        public XIRRConfigDataContract GetXIRRConfigByID(int XIRRConfigID, string UserID)
        {
            DataTable dt = new DataTable();
            XIRRConfigDataContract xirrDC = new XIRRConfigDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRConfigByID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                xirrDC.XIRRConfigID = Convert.ToInt32(dr["XIRRConfigID"]);
                xirrDC.ReturnName = dr["ReturnName"].ToString();
                xirrDC.AnalysisID = dr["AnalysisID"].ToString();
                xirrDC.Name = dr["Name"].ToString();
                xirrDC.Type = dr["Type"].ToString();
                xirrDC.UpdatedDate = dr["UpdatedDate"].ToDateTime();
                xirrDC.Comments = dr["Comments"].ToString();
                xirrDC.Group1 = CommonHelper.ToInt32(dr["Group1"]);
                xirrDC.Group2 = CommonHelper.ToInt32(dr["Group2"]);
                xirrDC.ArchivalRequirement = CommonHelper.ToInt32(dr["ArchivalRequirement"]);
                xirrDC.ReferencingDealLevelReturn = CommonHelper.ToInt32(dr["ReferencingDealLevelReturn"]);
                xirrDC.FileNameInput = Convert.ToString(dr["FileNameInput"]);
                xirrDC.FileNameOutput = Convert.ToString(dr["FileNameOutput"]);

            }

            if (xirrDC.XIRRConfigID == 0)
            {
                xirrDC = null;
            }

            return xirrDC;
            //
        }


        public DataTable GetXIRROutputPortfolioLevel(int XIRRConfigID, string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutputPortfolioLevel", sqlparam);
            return dt;

        }

        public DataTable GetXIRROutputDealLevel(int XIRRConfigID, string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            //SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutputDealLevel", sqlparam);

            return dt;

        }


        public void UpdateXIRRInputOutputFiles(int XIRRReturnGroupID, string FileNameInput, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRReturnGroupID", Value = XIRRReturnGroupID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@FileNameInput", Value = FileNameInput };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecNonquery("dbo.usp_UpdateXIRRInputOutputFiles", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public void UpdateXIRRInputFiles(int XIRRConfigID, string FileNameInput, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@FileNameInput", Value = FileNameInput };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecNonquery("dbo.usp_UpdateXIRRInputFile", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public DataTable GetXIRROutputDealLevelFromXirrDashBoard(int XIRRConfigID, string group1, string group2, string loanstatus)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@GValue1", Value = group1 };
            SqlParameter p3 = new SqlParameter { ParameterName = "@GValue2", Value = group2 };
            SqlParameter p4 = new SqlParameter { ParameterName = "@LoanStatus", Value = loanstatus };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutputDealLevel", sqlparam);

            return dt;

        }
        public void DeleteXIRRInputCashflow(int? XIRRConfigID)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecNonquery("dbo.usp_DeleteXIRRInputCashflow", sqlparam);
        }

        public DataTable GetXIRRFilterExtractData(int? XIRRConfigID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRFilterExtractData", sqlparam);
            return dt;
        }

        public DataTable GetXIRRConfigByXIRRConfigGUID(string XIRRConfigGUID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigGUID", Value = XIRRConfigGUID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRConfigByXIRRConfigGUID", sqlparam);
            return dt;
        }

        public List<XIRRConfigFilterDataContract> GetXIRRFiltersByXIRRConfigID(int? XIRRConfigID)
        {
            DataTable dt = new DataTable();
            List<XIRRConfigFilterDataContract> lstfilters = new List<XIRRConfigFilterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRFiltersByXIRRConfigID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                XIRRConfigFilterDataContract XirrFilters = new XIRRConfigFilterDataContract();
                XirrFilters.RowNumber = CommonHelper.ToInt32(dr["RowNumber"]);
                XirrFilters.XIRRConfigID = CommonHelper.ToInt32(dr["XIRRConfigID"]);
                XirrFilters.XIRRFilterSetupID = CommonHelper.ToInt32(dr["XIRRFilterSetupID"]);
                XirrFilters.FilterDropDownValue = Convert.ToString(dr["FilterDropDownValue"]);

                lstfilters.Add(XirrFilters);
            }

            return lstfilters;
        }

        public XIRRReturnGroupDataContract GetXIRRReturnGroupByID(int XIRRReturnGroupID, string UserID)
        {
            DataTable dt = new DataTable();
            XIRRReturnGroupDataContract xirrDC = new XIRRReturnGroupDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRReturnGroupID", Value = XIRRReturnGroupID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRRReturnGroupByID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                xirrDC.XIRRReturnGroupID = Convert.ToInt32(dr["XIRRReturnGroupID"]);
                xirrDC.XIRRConfigID = Convert.ToInt32(dr["XIRRConfigID"]);
                xirrDC.Type = dr["Type"].ToString();
                xirrDC.ReturnName = dr["ReturnName"].ToString();
                xirrDC.ChildReturnName = dr["ChildReturnName"].ToString();
                xirrDC.Group1 = dr["Group1"].ToString();
                xirrDC.Group2 = dr["Group2"].ToString();
                xirrDC.AnalysisID = dr["AnalysisID"].ToString();
            }

            if (xirrDC.XIRRConfigID == 0)
            {
                xirrDC = null;
            }

            return xirrDC;
        }

        public XIRRReturnGroupDataContract GetFileNameForCashflow(XIRRReturnGroupDataContract retDC, string UserID)
        {
            DataTable dt = new DataTable();
            XIRRReturnGroupDataContract xirrDC = new XIRRReturnGroupDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = retDC.XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@GValue1", Value = retDC.Group1 };
            SqlParameter p3 = new SqlParameter { ParameterName = "@GValue2", Value = retDC.Group2 };
            SqlParameter p4 = new SqlParameter { ParameterName = "@LoanStatus", Value = retDC.LoanStatus };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Type", Value = retDC.Type };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetFileNameForCashflow", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                xirrDC.XIRRReturnGroupID = Convert.ToInt32(dr["XIRRReturnGroupID"]);
                xirrDC.XIRRConfigID = Convert.ToInt32(dr["XIRRConfigID"]);
                xirrDC.FileName_Input = dr["FileName_Input"].ToString();
            }

            if (xirrDC.XIRRConfigID == 0)
            {
                xirrDC = null;
            }
            return xirrDC;
        }


        public string CheckDuplicateXIRRConfig(int XIRRConfigID, string ReturnName)
        {
            string isexist = "";
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ReturnName", Value = ReturnName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_CheckDuplicateXIRRConfig", sqlparam);

                isexist = dt.Rows[0].ItemArray[0].ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isexist;
        }

        public void UpdateXIRRInputOutputArchiveFiles(int XIRRConfigID, string FileNameInput, string FileNameOutput, DateTime ArchiveDate, string Comments, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@FileNameInput", Value = FileNameInput };
                SqlParameter p3 = new SqlParameter { ParameterName = "@FileNameOutput", Value = FileNameOutput };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ArchiveDate", Value = ArchiveDate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Comments", Value = Comments };

                SqlParameter p6 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                hp.ExecNonquery("dbo.usp_UpdateXIRRInputOutputArchiveFiles", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataTable GetAllFileNameXIRR()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetXIRRFileToBeDeleteFromBlob");
            return dt;
        }

        public void InsertXIRRDeleteBlobFiles(string FileName, string Path, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@FileName", Value = FileName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Path", Value = Path };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecNonquery("dbo.usp_InsertXIRRDeleteBlobFiles", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateXIRRDeleteBlobFiles(int XIRRDeleteBlobFilesID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRDeleteBlobFilesID", Value = XIRRDeleteBlobFilesID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecNonquery("dbo.usp_UpdateXIRRDeleteBlobFiles", sqlparam);
        }

        public void UpdateXIRRDealOutputCalculated(int XIRRConfigID, DateTime CutOffDate, Guid UserID)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CutOffDate", Value = CutOffDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparamInputCashflow = new SqlParameter[] { p1, p3 };
                hp.ExecNonquery("usp_InsertXIRR_InputCashflow_AtRefresh", sqlparamInputCashflow);

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecNonquery("usp_UpdateXIRRDealOutputforCutOffDate", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }
        public void CalculateXIRRAfterDealSave(string DealAccountid, string UserId)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountid", Value = DealAccountid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserId", Value = UserId };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("dbo.usp_CalculateXIRRAfterDealSave", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable CalculateXIRRAfterDealCalculate(string UserId)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = UserId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                DataTable dt = hp.ExecDataTable("dbo.usp_CalculateXIRRAfterDealCalculate", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void InsertXIRR_InputCashflow(int XIRRConfigID, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@XIRRConfigID", Value = XIRRConfigID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataTablewithparams("dbo.usp_InsertXIRR_InputCashflow", sqlparam);
        }

        public DataTable CalculateXirrNightlty()
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetALLXIRRConfigIDs");
            return dt;
        }

    }
}
