using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using CRES.Utilities;
using CRES.DAL.IRepository;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace CRES.DAL.Repository
{
    public class TagMasterRepository : ITagMasterRepository
    {
        IConfigurationSection Sectionroot = null;

        public TagMasterRepository()
        {
            IConfigurationBuilder builder = new ConfigurationBuilder();
            builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
            var root = builder.Build();
            Sectionroot = root.GetSection("Application");

        }

        //private string connstring = ConfigurationManager.ConnectionStrings["LoggingInDB"].ToString();   
       // SqlConnection connection = new SqlConnection();

        public List<TagMasterDataContract> GetTagMaster(string UserID, Guid? AnalysisId)
        {
            
            DataTable dt = new DataTable();
            List<TagMasterDataContract> taglist = new List<TagMasterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetTagMaster", sqlparam);

          //  var _taglist = dbContext.usp_GetTagMaster(UserID, AnalysisId);

            foreach (DataRow dr in dt.Rows)
            {
                TagMasterDataContract tdc = new TagMasterDataContract();
                if (Convert.ToString(dr["TagMasterID"]) != "")
                {
                    tdc.TagMasterID = new Guid(Convert.ToString(dr["TagMasterID"]));
                }
               
                tdc.TagName = Convert.ToString(dr["TagName"]); 
                tdc.TagDesc = Convert.ToString(dr["TagDesc"]); 
                tdc.CreatedBy = Convert.ToString(dr["CreatedBy"]); 
                tdc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]); 
                tdc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]); 
                tdc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                tdc.FullName = Convert.ToString(dr["FullName"]);
                if (Convert.ToString(dr["AnalysisID"]) != "")
                {
                    tdc.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                }
                tdc.AnalysisName = Convert.ToString(dr["AnalysisName"]); 
                tdc.StatusText = Convert.ToString(dr["StatusText"]); 
                tdc.TagFileName = Convert.ToString(dr["TagFileName"]); 
                tdc.NewTagFileName = Convert.ToString(dr["NewTagFileName"]); 
                taglist.Add(tdc);

            }


            return taglist;

        }


        public string InsertTagMaster(TagMasterDataContract tmdc, string UserID)
        {
            string result = "";

            try
            {
               
                string NewTagID;
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TagName", Value = tmdc.TagName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TagDesc", Value = tmdc.TagDesc };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = tmdc.AnalysisID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@newTagID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                hp.ExecNonquery("dbo.usp_InsertTagMaster", sqlparam);
                //  ObjectParameter newtagID = new ObjectParameter("NewTagID", typeof(string));

               // var res = dbContext.usp_InsertTagMaster(tmdc.TagName, tmdc.TagDesc, UserID, tmdc.AnalysisID, newtagID);

                NewTagID = Convert.ToString(p5.Value);

                if (NewTagID != "")
                {
                    tmdc.TagMasterID = new Guid(NewTagID);
                }

                result = "TRUE";

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }


        public DataTable GetNoteCashflowsExportDataFromTransactionClose(string AnalysisID, string tagMasterID)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();


            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid("00000000-0000-0000-0000-000000000000") };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = new Guid("00000000-0000-0000-0000-000000000000") };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = new Guid(AnalysisID) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@tagMasterID", Value = new Guid(tagMasterID) };

                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteCashflowsExportDataFromTransactionClose", sqlparam);


            }
            catch (Exception ex)
            {
            }

            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;

        }

        //#Remaining#
        public void DeleteTagByTagID(string UserID, Guid? AnalysisID, Guid? tagMasterID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TagMasterID", Value = tagMasterID };
            SqlParameter[] sqlparam = new SqlParameter[] { p0,p1,p2 };
            hp.ExecNonquery("dbo.usp_DeleteTagByTagID", sqlparam);
        }

        public List<TagMasterDataContract> GetTagFileNameForAzureUpload()
        {
            DataTable dt = new DataTable();
            List<TagMasterDataContract> taglist = new List<TagMasterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetTagFileNameForAzureUpload");

            //var _taglist = dbContext.usp_GetTagFileNameForAzureUpload();

            foreach (DataRow dr in dt.Rows)
            {
                TagMasterDataContract tdc = new TagMasterDataContract();
                if (Convert.ToString(dr["TagMasterID"]) != "")
                {
                    tdc.TagMasterID = new Guid(Convert.ToString(dr["TagMasterID"]));
                }

                tdc.TagName = Convert.ToString(dr["TagName"]);
                tdc.TagDesc = Convert.ToString(dr["TagDesc"]);
                tdc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                tdc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                tdc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                tdc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                tdc.FullName = Convert.ToString(dr["FullName"]);
                if (Convert.ToString(dr["AnalysisID"]) != "")
                {
                    tdc.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                }
                tdc.AnalysisName = Convert.ToString(dr["AnalysisName"]);
                tdc.TagFileName = Convert.ToString(dr["TagFileName"]);
               
                
                taglist.Add(tdc);
            }

            return taglist;
        }


        public void UpdateTagFileName(List<TagFileDataContract> lstTagFile)
        {
           
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XMLTagFile", Value = lstTagFile.ToXML() };
            SqlParameter[] sqlparam = new SqlParameter[] {  p1 };
            hp.ExecNonquery("dbo.usp_UpdateTagFileName", sqlparam);
            //var res = dbContext.usp_UpdateTagFileName(lstTagFile.ToXML());
        }

        public void ImportIntoTransactionEntryCloseArchive(Guid? TagMasterID, Guid? AnalysisID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TagMasterID", Value = TagMasterID.ToString() };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
             hp.ExecNonquery("CRE.usp_InsertTransactionEntryCloseArchive", sqlparam);
          //  var res = dbContext.usp_InsertTransactionEntryCloseArchive(AnalysisID,TagMasterID.ToString());
        }

    }
}
