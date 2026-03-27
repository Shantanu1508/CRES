using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.Utilities;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net.Http;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using System.Collections.Specialized;
using Microsoft.Extensions.Configuration;
using System.IO;
using System.Linq;


namespace CRES.BusinessLogic
{
    public class BackShopExportLogic
    {
        Microsoft.Extensions.Configuration.IConfigurationSection Sectionroot = null;
        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        public DataTable ExportFFandPIKgetrecordsforJson(string DealID, string NoteID, string userName, string flag)
        {
            BackShopExportRepository repo = new BackShopExportRepository();

            return repo.ExportFFandPIKgetrecordsforJson(DealID, NoteID, userName, flag);
        }

        public void ExportFFandPIKUpdateStatus(string DealID, string NoteID, string Status, string userName, string UpdateFor)
        {
            BackShopExportRepository repo = new BackShopExportRepository();
            repo.ExportFFandPIKUpdateStatus(DealID, NoteID, Status, userName, UpdateFor);
        }

        public void VerifyFutureFundingM61andBackshop(string DealID, string NoteID, string userName, string verificationFor)
        {
            BackShopExportRepository repo = new BackShopExportRepository();
            repo.VerifyFutureFundingM61andBackshop(DealID, NoteID, userName, verificationFor);
        }

        public List<BackShopExportDataContract> CreateFundingJson(DataTable dt)
        {
            List<BackShopExportDataContract> ListData = new List<BackShopExportDataContract>();
            try
            {


                DataView view = new DataView(dt);
                DataTable distinctValues = view.ToTable(true, "Noteid_F");
                foreach (DataRow dv in distinctValues.Rows)
                {
                    BackShopExportDataContract bse = new BackShopExportDataContract();
                    bse.NoteId = Convert.ToString(dv["Noteid_F"]);

                    List<BackShopNoteFundingsDataContract> notelist = new List<BackShopNoteFundingsDataContract>();

                    foreach (DataRow dr in dt.Rows)
                    {
                        var FF_BlankJson = CommonHelper.ToBooleanNotNullable(dr["FF_BlankJson"]);
                        bse.Type = Convert.ToString(dr["Type"]);
                        if (FF_BlankJson != true)
                        {

                            if (bse.NoteId == Convert.ToString(dr["Noteid_F"]))
                            {
                                BackShopNoteFundingsDataContract funding = new BackShopNoteFundingsDataContract();
                                funding.FundingId = null;
                                funding.Noteid_F = Convert.ToString(dr["Noteid_F"]);
                                funding.Applied = CommonHelper.ToBooleanNotNullable(dr["Applied"]);
                                funding.FundingDate = CommonHelper.ToDateTime(dr["FundingDate"]);
                                funding.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]); ;
                                funding.FundingPurposeCD_F = Convert.ToString(dr["FundingPurposeCD_F"]);
                                funding.FundingExpense = CommonHelper.ToDecimal(dr["FundingExpense"]); ;
                                funding.Comments = Convert.ToString(dr["Comments"]);
                                funding.NoteFundingReasonCD_F = Convert.ToString(dr["NoteFundingReasonCD_F"]);
                                funding.GeneratedBy = Convert.ToString(dr["GeneratedBy"]);
                                funding.Status = Convert.ToString(dr["Status"]);
                                funding.AuditUserName = Convert.ToString(dr["AuditUserName"]);
                                funding.WireConfirm = CommonHelper.ToBooleanNotNullable(dr["WireConfirm"]);
                                funding.AdjustmentType = Convert.ToString(dr["AdjustmentType"]);
                                funding.FundingAdjustmentTypeCd_F = Convert.ToString(dr["FundingAdjustmentTypeCd_F"]);
                                notelist.Add(funding);
                            }
                        }


                    }
                    bse.NoteFundings = notelist;
                    ListData.Add(bse);
                }


            }
            catch (Exception ex)
            {

                throw;
            }

            return ListData;
        }


        public List<BackShopExportProjectionDataContract> CreateProjectionJson(DataTable dt)
        {
            List<BackShopExportProjectionDataContract> ListData = new List<BackShopExportProjectionDataContract>();
            try
            {

                DataView view = new DataView(dt);
                DataTable distinctValues = view.ToTable(true, "Noteid_F");
                foreach (DataRow dv in distinctValues.Rows)
                {
                    BackShopExportProjectionDataContract bse = new BackShopExportProjectionDataContract();
                    bse.NoteId = Convert.ToString(dv["Noteid_F"]);

                    List<BackShopNoteProjectionDataContract> notelist = new List<BackShopNoteProjectionDataContract>();

                    foreach (DataRow dr in dt.Rows)
                    {
                        //bse.Type = Convert.ToString(dr["Type"]);
                        if (bse.NoteId == Convert.ToString(dr["Noteid_F"]))
                        {
                            BackShopNoteProjectionDataContract Projection = new BackShopNoteProjectionDataContract();

                            Projection.Noteid_F = Convert.ToString(dr["Noteid_F"]);
                            Projection.Applied = CommonHelper.ToBooleanNotNullable(dr["Applied"]);
                            Projection.PaymentDate = CommonHelper.ToDateTime(dr["FundingDate"]);
                            Projection.Amount = CommonHelper.ToDecimal(dr["FundingAmount"]); ;
                            Projection.FundingPurposeCD_F = Convert.ToString(dr["FundingPurposeCD_F"]);
                            Projection.FundingExpense = CommonHelper.ToDecimal(dr["FundingExpense"]); ;
                            Projection.Comments = Convert.ToString(dr["Comments"]);
                            Projection.GeneratedBy = Convert.ToString(dr["GeneratedBy"]);
                            Projection.InactiveSw = "false";
                            Projection.AuditUserName = Convert.ToString(dr["AuditUserName"]);
                            Projection.SortOrder = 0;

                            notelist.Add(Projection);
                        }

                    }
                    bse.NoteProjectedPayments = notelist;
                    ListData.Add(bse);
                }


            }
            catch (Exception ex)
            {

                throw;
            }

            return ListData;
        }

        public string CallBackShopAPI(string backshopconsturl, string ApiConstantUrl, string jsonstring, string BackshopExportUserName, string BackshopExportPassword)
        {
            LoggerLogic Log = new LoggerLogic();
            string Outputresponse = "";
            int retryCount = 2;
            string token = EstablishToken(backshopconsturl, BackshopExportUserName, BackshopExportPassword);
            Log.WriteLogInfo("BackShopExport", "Token created.", "", "EstablishToken");
            while (retryCount > 0)
            {
                if (token.Contains("BackshopError"))
                {
                    Outputresponse = token;
                    break;
                }
                Log.WriteLogInfo("BackShopExport", "Token created: " + token, "", "EstablishToken");
                var content = new StringContent(jsonstring, Encoding.UTF8, "application/json");
                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Add("Authorization", "Bearer " + token);
                    client.Timeout = TimeSpan.FromMinutes(10);

                    try
                    {
                        var res = client.PostAsync(ApiConstantUrl, content).Result;

                        HttpResponseMessage response1 = res.EnsureSuccessStatusCode();

                        if (response1.IsSuccessStatusCode)
                        {

                            Outputresponse = response1.Content.ReadAsStringAsync().Result;
                            Log.WriteLogInfo("BackShopExport", "Data Exported : " + Outputresponse, "", "EstablishToken");
                            break;
                        }
                    }
                    catch (Exception e)
                    {
                        Outputresponse = "BackshopError: " + e.Message;

                        if (e.Message.Contains("deadlocked"))
                        {
                            retryCount--;
                            continue;
                        }
                        else if (e.Message.Contains("Server unavailable"))
                        {
                            retryCount--;
                            continue;
                        }
                        else if (e.Message.Contains("timeout"))
                        {
                            retryCount--;
                            continue;
                        }

                        Log.WriteLogExceptionMessage("BackShopExport", "Error in BackShopExport", "", "", "CallBackShopAPI", Outputresponse);
                    }
                }

                break;
            }

            return Outputresponse;
        }

        public void UpdateStatusInDataBase(string Outputresponse, string dealid, string noteid, string username, string type, string verificationFor)
        {
            try
            {
                string IsSuccess = "";
                string Error = "";
                BackShopExportLogic backlogic = new BackShopExportLogic();
                LoggerLogic Log = new LoggerLogic();

                if (Outputresponse.Contains("BackshopError") == false)
                {
                    var CalcResponse = JObject.Parse(Outputresponse);
                    IsSuccess = CalcResponse["IsSuccess"].ToString();
                    Error = CalcResponse["Errors"].ToString();
                }
                else
                {
                    IsSuccess = "false";
                    Error = Outputresponse;
                }
                if (IsSuccess.ToLower() == "true" && Error == "[]")
                {
                    backlogic.ExportFFandPIKUpdateStatus(dealid, noteid, "Exported", username, type);
                    backlogic.VerifyFutureFundingM61andBackshop(dealid, noteid, username, verificationFor);
                    Log.WriteLogInfo(CRESEnums.Module.ExportFutureFunding.ToString(), "Backshop export api invoked successfully " + dealid, dealid, username);
                }
                else
                {
                    //to do log errors and Email
                    backlogic.ExportFFandPIKUpdateStatus(dealid, noteid, "ExportFailed", username, type);
                    Log.WriteLogExceptionMessage(CRESEnums.Module.ExportFutureFunding.ToString(), "Error : " + dealid + " " + Error, dealid, username, "DealController.ExportDataToBackShop", Error);

                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        public string EstablishToken(string backshopconsturl, string BackshopExportUserName, string BackshopExportPassword)
        {
            string token = "";
            var data = new NameValueCollection();
            data["UserName"] = BackshopExportUserName;
            data["Password"] = BackshopExportPassword;
            string ApiConstantUrl = backshopconsturl + "token";

            var content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
            System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
            using (var client = new WebClient())
            {
                try
                {

                    var response1 = client.UploadValues(ApiConstantUrl, "POST", data);
                    string responseInString = Encoding.UTF8.GetString(response1);

                    var vlaidjson = IsValidJson(responseInString);
                    if (vlaidjson == true)
                    {
                        var response = JObject.Parse(responseInString);
                        token = response["Token"].ToString();
                    }
                    else
                    {
                        token = "BackshopError :" + responseInString;
                    }

                }
                catch (Exception e)
                {
                    throw e;
                }
            }
            return token;
        }

        public string ExportDataToBackShop(string dealid, string username, string noteid, string type)
        {

            string jsonArrayString = "[";// + json1 + "," + json2 + "]";
            LoggerLogic Log = new LoggerLogic();
            try
            {
                Log.WriteLogInfo("BackShopExport", "BackShopExport Started 1." + " dealid: " + dealid + "noteid: " + noteid + "For Type:  " + type, "", username, "ExportDataToBackShop");

                GetConfigSetting();
                string ApiConstantUrl = "";
                string BackshopExportPassword = "";
                string BackshopExportUserName = "";
                string AllowBackshopFF = "";
                string AllowBackshopPIKPrincipal = "";
                AppConfigLogic appl = new AppConfigLogic();
                string jsonstring = "";
                String[] stringarr = null;
                if (type == "PIK")
                {
                    stringarr = new String[] { "Fundings" };
                }
                else if (type == "Balloon")
                {
                    stringarr = new String[] { "Fundings" };
                }
                else
                {
                    stringarr = new String[] { "Fundings", "Projection" };
                }

                string backshopconsturl = "";
                BackShopExportLogic backlogic = new BackShopExportLogic();
                AppConfigLogic acl = new AppConfigLogic();

                List<AppConfigDataContract> listappconfig = acl.GetAllAppConfig(new Guid(username));
                foreach (AppConfigDataContract item in listappconfig)
                {
                    if (item.Key == "BackshopExportPassword")
                    {
                        BackshopExportPassword = item.Value;
                    }

                    if (item.Key == "BackshopExportUserName")
                    {
                        BackshopExportUserName = item.Value;
                    }
                    if (item.Key == "AllowBackshopFF")
                    {
                        AllowBackshopFF = item.Value;
                    }
                    if (item.Key == "AllowBackshopPIKPrincipal")
                    {
                        AllowBackshopPIKPrincipal = item.Value;
                    }
                }

                string IsSuccess = "";
                string Error = "";
                string verificationFor = "";
                backshopconsturl = Sectionroot.GetSection("BackshopImportConstantUrl").Value;
                DataTable dt = backlogic.ExportFFandPIKgetrecordsforJson(dealid, noteid, username, type);
                var countdeleted = dt.Select("IsDeleted = True").Count();

                for (var i = 0; i < stringarr.Length; i++)
                {
                    DataTable tblFiltered = new DataTable();
                    string datatype = stringarr[i];
                    if (datatype == "Projection")
                    {
                        var count = dt.Select("IsProjectedPaydown = True and IsDeleted=False").Count();
                        if (count > 0)
                        {
                            tblFiltered = dt.Select("IsProjectedPaydown = True and IsDeleted=False").CopyToDataTable();
                            //create data
                            List<BackShopExportProjectionDataContract> data = backlogic.CreateProjectionJson(tblFiltered);
                            var objectd = new { Notes = data };
                            jsonstring = JsonConvert.SerializeObject(objectd);
                            ApiConstantUrl = backshopconsturl + "acore/noteprojectedpayment/SaveNoteProjectedPayments";
                            verificationFor = "Projection";
                        }
                    }
                    else
                    {
                        var count = dt.Select("IsProjectedPaydown = False  and IsDeleted=False").Count();
                        if (count > 0)
                        {
                            tblFiltered = dt.Select("IsProjectedPaydown = False and IsDeleted=False").CopyToDataTable();
                            List<BackShopExportDataContract> data = backlogic.CreateFundingJson(tblFiltered);

                            var objectd = new { Notes = data };
                            jsonstring = JsonConvert.SerializeObject(objectd);
                            ApiConstantUrl = backshopconsturl + "acore/notefunding/saveNote";
                            verificationFor = "FF";
                        }
                    }
                    if (type == "PIK")
                    {
                        verificationFor = "PIK";
                    }
                    else if (type == "Balloon")
                    {
                        verificationFor = "Balloon";
                    }
                    if (tblFiltered != null && tblFiltered.Rows.Count > 0)
                    {
                        Log.WriteLogInfo("BackShopExport", "BackShop Api Calling Start." + " dealid: " + dealid + "noteid: " + noteid + "For Type:  " + type, "", username, "ExportDataToBackShop");
                        jsonArrayString = jsonArrayString + jsonstring + ",";
                        var Outputresponse = CallBackShopAPI(backshopconsturl, ApiConstantUrl, jsonstring, BackshopExportUserName, BackshopExportPassword);
                        Log.WriteLogInfo("BackShopExport", "BackShop Api Calling End." + " dealid: " + dealid + "noteid: " + noteid + "For Type:  " + type, "", username, "ExportDataToBackShop");
                        UpdateStatusInDataBase(Outputresponse, dealid, noteid, username, type, verificationFor);
                    }

                }

                jsonArrayString = jsonArrayString.Remove(jsonArrayString.Length - 1, 1);
                jsonArrayString = jsonArrayString + "]";
                if (countdeleted > 0)
                {
                    var dtdeleted = dt.Select("IsDeleted = True").CopyToDataTable();
                    var countprojectiondelete = dtdeleted.Select("IsProjectedPaydown = True").Count();
                    var countFFPIKdelete = dtdeleted.Select("IsProjectedPaydown = False").Count();
                    if (countFFPIKdelete > 0)
                    {
                        DataTable table = dt.Select("IsProjectedPaydown = False and IsDeleted=True").CopyToDataTable();
                        var records = new JArray();
                        foreach (DataRow dr in table.Rows)
                        {
                            dynamic obj = new JObject();

                            obj.NoteId = Convert.ToString(dr["Noteid_F"]);
                            obj.Type = Convert.ToString(dr["Type"]);
                            obj.NoteFundings = new JArray();
                            records.Add(obj);
                        }
                        var objectd = new { Notes = records };

                        jsonstring = JsonConvert.SerializeObject(objectd);
                        ApiConstantUrl = backshopconsturl + "acore/notefunding/saveNote";
                        verificationFor = "FF";
                        if (type == "PIK")
                        {
                            verificationFor = "PIK";
                        }
                        var Outputresponse = CallBackShopAPI(backshopconsturl, ApiConstantUrl, jsonstring, BackshopExportUserName, BackshopExportPassword);
                        UpdateStatusInDataBase(Outputresponse, dealid, noteid, username, type, verificationFor);
                    }

                    if (countprojectiondelete > 0)
                    {
                        DataTable table = dt.Select("IsProjectedPaydown = True and IsDeleted=True").CopyToDataTable();

                        var records = new JArray();
                        foreach (DataRow dr in table.Rows)
                        {
                            dynamic obj = new JObject();

                            obj.NoteId = Convert.ToString(dr["Noteid_F"]);
                            obj.NoteProjectedPayments = new JArray();
                            records.Add(obj);
                        }
                        var objectd = new { Notes = records };

                        jsonstring = JsonConvert.SerializeObject(objectd);
                        ApiConstantUrl = backshopconsturl + "acore/noteprojectedpayment/SaveNoteProjectedPayments";
                        verificationFor = "Projection";
                        if (type == "PIK")
                        {
                            verificationFor = "PIK";
                        }
                        var Outputresponse = CallBackShopAPI(backshopconsturl, ApiConstantUrl, jsonstring, BackshopExportUserName, BackshopExportPassword);
                        UpdateStatusInDataBase(Outputresponse, dealid, noteid, username, type, verificationFor);
                    }
                }
            }
            catch (Exception ex)
            {
                BackShopExportLogic backlogic = new BackShopExportLogic();
                Log.WriteLogException(CRESEnums.Module.ExportFutureFunding.ToString(), "Error occured in ExportDataToBackShop for deal id " + dealid, dealid, username, ex.TargetSite.Name.ToString(), "", ex);
                backlogic.ExportFFandPIKUpdateStatus(dealid, noteid, "ExportFailed", username, type);
                throw ex;
            }

            return jsonArrayString;
        }

        internal static bool IsValidJson(string data)
        {
            data = data.Trim();
            try
            {
                if (data.StartsWith("{") && data.EndsWith("}"))
                {
                    JToken.Parse(data);
                }
                else if (data.StartsWith("[") && data.EndsWith("]"))
                {
                    JArray.Parse(data);
                }
                else
                {
                    return false;
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public void ExportFutureFundingFromCRES_API(List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleDataContract, string headerUserID, DealDataContract DealDC)
        {
            LoggerLogic Log = new LoggerLogic();
            string exceptionMessage = "success";
            string BackShopStatus = "";
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.ExportFutureFunding.ToString(), "ExportFutureFundingFromCRES_API called", DealDC.DealID.ToString(), "");
                NoteLogic nl = new NoteLogic();
                exceptionMessage = nl.ExportFutureFundingFromCRES_API(PayruleTargetNoteFundingScheduleDataContract, headerUserID, DealDC);
                if (exceptionMessage.ToLower() != "success")
                {
                    Log.WriteLogExceptionMessage(CRESEnums.Module.ExportFutureFunding.ToString(), exceptionMessage, DealDC.DealID.ToString(), "", "ExportFutureFundingFromCRES_API", "Error occurred  while export FF backshop : Deal ID");
                }
                else if (exceptionMessage.ToLower() == "success")
                {

                    ExportDataToBackShop(DealDC.DealID.ToString(), headerUserID, "", "FF");
                }
                Log.WriteLogInfo(CRESEnums.Module.ExportFutureFunding.ToString(), "ExportFutureFundingFromCRES_API Ended", DealDC.DealID.ToString(), "");
            }
            catch (Exception ex)
            {

                exceptionMessage = ex.StackTrace.ToString();
                Log.WriteLogException(CRESEnums.Module.ExportFutureFunding.ToString(), "Error occurred  while export FF backshop : Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                throw ex;
            }
        }
        public void ExportPIKPrincipalFromCRES_API(string CRENoteID, string CreatedBy)
        {
            BackShopExportRepository repo = new BackShopExportRepository();
            repo.ExportPIKPrincipalFromCRES_API(CRENoteID, CreatedBy);
        }
    }
}
