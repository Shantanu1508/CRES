using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Globalization;
using Azure.Storage.Queues;
using System.Text.Json;
using Azure.Core;
using Microsoft.VisualBasic;
using static System.Net.Mime.MediaTypeNames;
using System.Reflection;
using System.Xml.Linq;
using Org.BouncyCastle.Asn1.Cmp;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class V1CalcController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public V1CalcController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/getdealcalcrequest")]
        public IActionResult GetDealCalcRequest(string objectID, int objectTypeId, int calctype, string? analysisID)
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            //string analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F"1;
            if (analysisID == null)
            {
                analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            }
            if (calctype == 776)// 776-PrepayCalculator
            {
                PrepayPremiumLogic prepay = new PrepayPremiumLogic();
                dynamic objJsonResult = prepay.GetDealCalcRequestDataForPrepayment(objectID, objectTypeId, analysisID, calctype, false, true);
                var returnType = objJsonResult.GetType();
                return Ok(objJsonResult);
            }
            else
            {
                dynamic objJsonResult = v1logic.GetDealCalcRequestData(objectID, objectTypeId, analysisID, calctype, false, true);
                var returnType = objJsonResult.GetType();
                if (returnType.Name == "Int32")
                {


                }
                return Ok(objJsonResult);
            }


        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/submitCalcRequest")]
        public IActionResult submitCalcRequest(string CreDealID)
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            string analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            v1logic.SubmitCalcRequest(CreDealID, 182, analysisID, 775, false, "");
            return Ok();
        }

        public void GetFileOutput(string requestid, int? TransactionOutput, int? NotePeriodicOutput, int? StrippingOutput, int? Prepaypremium_Output, int? Prepayallocations_Output, int? DailyInterestAccOutput)
        {

            string SavingFailedFor = "";
            string result = "";
            string SourceNoteID = "";
            string username = "";
            string AnalysisID = "";
            string StrCreatedBy = "";
            string noteid = "";
            string crenoteid = "";
            int UseActuals = 0;
            Guid AnalysisIDGuid;
            int CalcType = 0;  // 775 - Cre cal, 776- Prepay calc
            bool AllowDebugInCalc = false;
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
            try
            {
                Log.WriteLogInfo("CalcDataSaving", "inside GetFileOutput 1 " + " Requestid " + requestid, requestid, "");
                V1CalcLogic _V1CalcLogic = new V1CalcLogic();
                DataTable dt = _V1CalcLogic.GetDataFromCalculationRequestsByRequestID(requestid);
                foreach (DataRow dr in dt.Rows)
                {
                    AnalysisID = Convert.ToString(dr["AnalysisID"]);
                    username = Convert.ToString(dr["UserName"]);
                    AllowDebugInCalc = Convert.ToBoolean(dr["AllowDebugInCalc"].ToInt32());
                    StrCreatedBy = Convert.ToString(dr["login"]);
                    noteid = Convert.ToString(dr["NoteId"]);
                    UseActuals = Convert.ToInt16(dr["UseActuals"]);
                    CalcType = Convert.ToInt16(dr["CalcType"]);
                    crenoteid = Convert.ToString(dr["crenoteid"]);

                }
                AnalysisIDGuid = new Guid(AnalysisID);

                GetConfigSetting();
                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

                if (AllowDebugInCalc == true)
                {
                    Thread FirstThread1 = new Thread(() => SaveFileInBlob(requestid, username));
                    FirstThread1.Start();
                }

                Log.WriteLogInfo("CalcDataSaving", "inside GetFileOutput 2 " + " Requestid :" + "CalcType " + CalcType + requestid, requestid, "");
                if (CalcType == 775)
                {
                    string Periodicstatus = "";
                    string trnstatus = "";
                    string stripstatus = "";
                    if (NotePeriodicOutput == 292)
                    {
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, 267, null, null, null, null, 1, username);
                        Periodicstatus = CheckAndSavePeriodicOutput(requestid, headerkey, headerValue, strAPI, crenoteid, AnalysisID, username);

                    }
                    else
                    {
                        Periodicstatus = "Saved";
                    }

                    if (TransactionOutput == 292)
                    {
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, 267, null, null, null, null, null, 1, username);
                        trnstatus = CheckAndSaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, crenoteid, AnalysisID, username, noteid);
                    }
                    else
                    {
                        trnstatus = "Saved";
                    }

                    if (StrippingOutput == 292)
                    {
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, null, 267, null, null, null, 1, username);
                        stripstatus = CheckAndSaveStripingOutput(requestid, headerkey, headerValue, strAPI, crenoteid, AnalysisID, username);

                    }
                    else
                    {
                        stripstatus = "Saved";
                    }

                    if (DailyInterestAccOutput == 292)
                    {
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, null, 267, null, null, null, 1, username);
                        CheckAndSaveDailyData(requestid, headerkey, headerValue, strAPI, noteid, AnalysisID, username);
                    }

                    if (Periodicstatus == "Saved" && stripstatus == "Saved" && trnstatus == "Saved")
                    {
                        _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");
                        _V1CalcLogic.UpdateCalculationStatusForDependents(crenoteid, AnalysisID);
                        Log.WriteLogInfo("CalcDataSaving", " Update Calculation Status For Dependents " + "CrenoteID : Requestid : " + crenoteid + " : " + requestid, requestid, "");

                    }
                    else
                    {
                        _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(-1), "");
                    }

                }

                if (CalcType == 776)
                {
                    string PrepaypremiumOutputSave = "";
                    string prepayallocationsSave = "";
                    if (Prepaypremium_Output == 292)
                    {
                        PrepayPremiumLogic prepay = new PrepayPremiumLogic();
                        PrepaypremiumOutputSave = prepay.SavePrepayPremium(requestid, headerkey, headerValue, strAPI, username);
                    }
                    if (Prepayallocations_Output == 292)
                    {
                        V1CalcLogic v1logic = new V1CalcLogic();
                        v1logic.InsertUpdateCalculationQueueRequest(requestid, null, null, null, null, 267, null, 1, username);
                        // Prepay allocations saving
                        SavingFailedFor = "Prepayallocations_Output";
                        var strPrepayallocationsAPI = strAPI + "/" + requestid + "/outputs/prepayallocations.csv";
                        HttpClient prepayallocationsclient = new HttpClient();
                        prepayallocationsclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                        var apiprepayallocationsresult = prepayallocationsclient.GetAsync(strPrepayallocationsAPI).Result;
                        if (apiprepayallocationsresult.IsSuccessStatusCode == true)
                        {
                            var prepayallocationsresponse = apiprepayallocationsresult.Content.ReadAsStringAsync().Result;
                            var prepayallocationsoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(prepayallocationsresponse);
                            DataTable dtPrepayallocationsoutput = convertStringToDataTable(prepayallocationsoutput.data);

                            _V1CalcLogic.InsertPrepayAllocationsEntry(dtPrepayallocationsoutput, username);
                            v1logic.InsertUpdateCalculationQueueRequest(requestid, null, null, null, null, 266, null, 1, username);
                            prepayallocationsSave = "Saved";
                        }
                    }

                    if (PrepaypremiumOutputSave == "Saved")
                    {
                        _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");
                    }
                    else
                    {
                        _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(-1), "");
                    }

                }

                result = "Saved";
            }
            catch (Exception ex)
            {

                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for :" + SavingFailedFor + " : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    result = SavingFailedFor + " M61 output api did not responds in 60 secs ";
                }

                v1logic.UpdateCalculationRequestsStatus(crenoteid, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB.");
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in saving for  " + SavingFailedFor + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);
            }
            finally
            {
                Log.WriteLogInfo("CalcDataSaving", " finally " + " Requestid  " + requestid + " ex " + result, requestid, "");
            }
        }

        public string CheckAndSavePeriodicOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            var status = v1logic.SavePeriodicOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside PeriodicOutput retry " + " Requestid " + requestid + " status " + status, requestid, "");
                //status = SavePeriodicOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);

                v1logic.InsertUpdateCalculationQueueRequest(requestid, null, 265, null, null, null, null, 1, username);
            }

            return status;
        }

        public string CheckAndSaveDailyData(string requestid, string headerkey, string headerValue, string strAPI, string noteid, string AnalysisID, string username)
        {
            V1CalcLogic v1logic = new V1CalcLogic();

            var status = v1logic.SaveDailyData(requestid, headerkey, headerValue, strAPI, noteid, AnalysisID, username);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside SaveDailyData retry " + " Requestid " + requestid + " status " + status, requestid, "");

                v1logic.InsertUpdateCalculationQueueRequest(requestid, null, null, null, null, null, 265, 1, username);
            }
            return status;
        }




        public string CheckAndSaveTransactionsOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username, string noteid)
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            var status = v1logic.SaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username, noteid);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output retry " + " Requestid " + requestid + " status " + status, requestid, "");

                //status = SaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username, noteid);


                v1logic.InsertUpdateCalculationQueueRequest(requestid, 265, null, null, null, null, null, 1, username);
            }

            return status;
        }

        public string CheckAndSaveStripingOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            var status = v1logic.SaveStripingOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside StripingOutput retry " + " Requestid " + requestid + " status " + status, requestid, "");

                //status = SaveStripingOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);

                v1logic.InsertUpdateCalculationQueueRequest(requestid, null, null, 265, null, null, null, 1, username);
            }

            return status;
        }

        IConfigurationSection Sectionroot = null;
        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(System.IO.Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        public DataTable convertStringToDataTable(string data)
        {
            int loopindex = 0;
            DataTable dtCsv = new DataTable();
            // convert string to stream
            byte[] byteArray = Encoding.UTF8.GetBytes(data);
            MemoryStream Stream = new MemoryStream(byteArray);
            Regex regx = new Regex("," + "(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
            try
            {
                using (StreamReader sr = new StreamReader(Stream))
                {
                    while (!sr.EndOfStream)
                    {
                        var Fulltext = sr.ReadToEnd().ToString(); //read full file text  
                        string[] rows = Fulltext.Split('\n'); //split full file text into rows  
                        for (int i = 0; i < rows.Count() - 1; i++)
                        {
                            string[] rowValues = regx.Split(rows[i]); //split each row with comma to get individual values  
                            {
                                if (i == 0)
                                {
                                    for (int j = 0; j < rowValues.Count(); j++)
                                    {
                                        dtCsv.Columns.Add(rowValues[j]); //add headers  
                                    }
                                }
                                else
                                {
                                    DataRow dr = dtCsv.NewRow();
                                    for (int k = 0; k < rowValues.Count(); k++)
                                    {
                                        // remove the double quotes from the strings
                                        //dr[k] = rowValues[k].ToString();
                                        dr[k] = rowValues[k].Replace("\"", "").ToString();
                                    }
                                    dtCsv.Rows.Add(dr); //add other rows  
                                }
                            }
                            loopindex = loopindex + 1;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dtCsv;
        }

        //scheduler API for save calc output files 
        [HttpGet]
        [Route("api/v1calc/getcalcqueuerequest")]
        public void GetCalcQueueRequest()
        {
            V1CalcLogic v1CalcLogic = new V1CalcLogic();
            List<V1CalculationStatusDataContract> lstCalcRequest = v1CalcLogic.GetRequestIDFromCalculationQueueRequest();

            if (lstCalcRequest != null || lstCalcRequest.Count > 0)
            {
                LoggerLogic logWrite = new LoggerLogic();
                logWrite.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "GetCalcQueueRequest called. Records in Save pending.Count " + lstCalcRequest.Count, "", useridforSys_Scheduler);

                Parallel.ForEach(lstCalcRequest, new ParallelOptions { MaxDegreeOfParallelism = 10 },
                    (item, state) =>
                    {

                        GetFileOutput(item.RequestID, item.TransactionOutput, item.NotePeriodicOutput, item.StrippingOutput, item.Prepaypremium_Output, item.Prepayallocations_Output, item.DailyInterestAccOutput);

                    }
                 );
            }
            else
            {
                LoggerLogic logWrite = new LoggerLogic();
                logWrite.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "GetCalcQueueRequest called. No records in Save pending", "", useridforSys_Scheduler);
            }
        }
        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/CalculateAllDeals")]
        public void CalculateAllDeals()
        {
            try
            {
                LoggerLogic log = new LoggerLogic();
                V1CalcLogic v1logic = new V1CalcLogic();
                List<V1CalculationStatusDataContract> listofdeal = v1logic.GetRecordsFromCalculationRequest();
                CalculatePrepayment();
                log.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "CalculateAllDeals in api using new calculator service ", "", "");
                string res = "";
                // string analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F" 1;
                if (listofdeal != null && listofdeal.Count > 0)
                {
                    Parallel.ForEach(listofdeal, new ParallelOptions { MaxDegreeOfParallelism = 1 },
                               (item, state) =>
                               {
                                   //Log for check submit calc reuest to V1 engine
                                   log.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "CalculateAllDeals in api using calculator service " + item.objectID + " AnalysisID " + item.AnalysisID, "", "");
                                   res = v1logic.SubmitCalcRequest(item.objectID, Convert.ToInt32(item.objectTypeId), item.AnalysisID, Convert.ToInt32(item.CalcType), true, " new");
                                   //commit for testing
                                   if (res == "Batch Canceled")
                                   {
                                       //Log for check Batch Canceled in DB
                                       log.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "Batch Canceled in api  ", "", useridforSys_Scheduler);
                                   }

                               });
                }
                else
                {
                    log.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "no record found in new calculator service ", "", useridforSys_Scheduler);
                }


            }
            catch (Exception ex)
            {
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.V1Calculator.ToString(), "Error in CalculateAllDeals " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "CalculateAllDeals", "", ex);
            }
        }

        public void CalculatePrepayment()
        {

            try
            {
                LoggerLogic log = new LoggerLogic();
                V1CalcLogic v1logic = new V1CalcLogic();
                List<V1CalculationStatusDataContract> listofdeal = v1logic.GetDealidForPrepaymentCalculation();

                log.WriteLogInfo(CRESEnums.Module.PrepaymentCalculator.ToString(), "CalculatePrepayment in api using new calculator service ", "", "");
                string res = "";

                if (listofdeal != null && listofdeal.Count > 0)
                {
                    Parallel.ForEach(listofdeal, new ParallelOptions { MaxDegreeOfParallelism = 1 },
                               (item, state) =>
                               {
                                   //Log for check submit calc reuest to V1 engine
                                   log.WriteLogInfo(CRESEnums.Module.PrepaymentCalculator.ToString(), "Calculating Prepayment " + item.objectID + " AnalysisID " + item.AnalysisID, "", "");
                                   res = v1logic.SubmitCalcRequest(item.objectID, Convert.ToInt32(item.objectTypeId), item.AnalysisID, 776, false, "");
                                   if (res == "Batch Canceled")
                                   {

                                       log.WriteLogInfo(CRESEnums.Module.PrepaymentCalculator.ToString(), "Batch Canceled in api  ", "", useridforSys_Scheduler);
                                   }
                               });
                }
                else
                {
                    log.WriteLogInfo(CRESEnums.Module.PrepaymentCalculator.ToString(), "no record found :CalculatePrepayment ", "", useridforSys_Scheduler);
                }

            }
            catch (Exception ex)
            {
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.PrepaymentCalculator.ToString(), "Error in CalculatePrepayment " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "CalculatePrepayment", "", ex);
            }
        }

        public void SaveFileInBlob(string requestid, string UserID)
        {
            LoggerLogic Log = new LoggerLogic();
            try
            {

                GetConfigSetting();
                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                var strPeriodicAPI = strAPI + "/" + requestid + "/outputs/df.csv";
                HttpClient periodicClient = new HttpClient();
                periodicClient.DefaultRequestHeaders.Add(headerkey, headerValue);

                var apiresult = periodicClient.GetAsync(strPeriodicAPI).Result;
                if (apiresult.IsSuccessStatusCode == true)
                {
                    var dfresponse = apiresult.Content.ReadAsStringAsync().Result;
                    var fileName = "DF_" + requestid + "_" + DateTime.Now.ToString("MM_dd_yyyy_HH_mm_ss") + ".json";
                    var isJSONSaved = AzureStorageRead.UploadJSONFileToAzureBlob(dfresponse, fileName);

                    if (isJSONSaved)
                    {
                        V1CalcLogic v1logic = new V1CalcLogic();
                        v1logic.InsertCalculatorOutputJsonInfo_V1(requestid, new Guid(UserID), fileName, "Output File");
                    }
                    else
                    {
                        Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error occured in Upload Json for request id" + requestid, requestid.ToString(), "", "Error occured in Uploading Json for " + requestid, requestid.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error occured in SaveFileInBlob" + requestid, requestid.ToString(), "", "Error occured in SaveFileInBlob" + requestid, requestid.ToString());
            }
        }
        public void CreateCSVFile(System.Data.DataTable dt, string csvname)
        {
            try
            {
                string path = @"C:\temp";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string strFilePath = "C:\\temp\\" + csvname + ".csv";

                StreamWriter sw = new StreamWriter(strFilePath, false);
                int columnCount = dt.Columns.Count;

                for (int i = 0; i < columnCount; i++)
                {
                    sw.Write(dt.Columns[i]);

                    if (i < columnCount - 1)
                    {
                        sw.Write(",");
                    }
                }

                sw.Write(sw.NewLine);

                foreach (DataRow dr in dt.Rows)
                {
                    for (int i = 0; i < columnCount; i++)
                    {
                        if (!Convert.IsDBNull(dr[i]))
                        {
                            sw.Write(dr[i].ToString());
                        }

                        if (i < columnCount - 1)
                        {
                            sw.Write(",");
                        }
                    }

                    sw.Write(sw.NewLine);
                }

                sw.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpGet]
        [Route("api/v1calc/CheckOutputSaving")]
        public void CheckOutputSaving()
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            try
            {
                string headerkey = "auth_key";

                //QA
                string headerValue = "4fdfcfe813f040e5b468bf778ae3aaf0";
                string strAPI = "https://m61engine-qa.azurewebsites.net/requests";

                ////Dev
                //string headerValue = "d25006feb05c4828b08564d6fac7cbbf";
                //string strAPI = "https://m61engine-dev.azurewebsites.net/requests";

                ////int
                //string headerValue = "4fdfcfe813f040e5b468bf778ae3aaf0";
                //string strAPI = "https://m61engine-int.azurewebsites.net/requests";

                //prod
                // string headerValue = "fc00b7e3880e4f04abffdf03b6fca55d";
                //string strAPI = "https://m61engine.azurewebsites.net/requests";

                string SourceNoteID = "24723";
                string AnalysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
                string username = "eef47d30-b788-4d4c-ad41-4d06b3ce7bff";
                string noteid = "41A1468B-DBDF-469E-B806-4F8398C7BF50";
                string requestid = "cfa44d836a254aefa200868e531d79ef";

                CalculatePrepayment();
                //GetV1Logs(requestid, headerkey, headerValue, strAPI);
                //v1logic.SaveTransactionsOutputForLiabilityFeeAndInterest(requestid, headerkey, headerValue, strAPI, AnalysisID, username, 911);

                v1logic.SaveTransactionsOutputForLiabilityFee(requestid, headerkey, headerValue, strAPI, AnalysisID, username, 935);
                //GetFileOutput(requestid, null, null, null, 292, null, null);
                PrepayPremiumLogic prepay = new PrepayPremiumLogic();
                //prepay.SavePrepayPremium(requestid, headerkey, headerValue, strAPI, username);
                //v1logic.SaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username, noteid);
                //v1logic.SavePeriodicOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
                //SaveDailyData(requestid, headerkey, headerValue, strAPI, noteid, AnalysisID, username);

            }
            catch (Exception ex)
            {
                throw;
            }
        }
        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/GetV1Logs")]
        public IActionResult GetV1Logs(string requestid, string env)
        {
            v1GenericResult _authenticationResult = null;
            string headerkey = "auth_key";
            string headerValue = "";
            string strAPI = "";
            env = env.ToLower();
            if (env == "qa")
            {
                //QA
                headerValue = "4fdfcfe813f040e5b468bf778ae3aaf0";
                strAPI = "https://m61engine-qa.azurewebsites.net/requests";
            }
            else if (env == "dev")
            {
                //Dev
                headerValue = "d25006feb05c4828b08564d6fac7cbbf";
                strAPI = "https://m61engine-dev.azurewebsites.net/requests";
            }
            else if (env == "int")
            {
                //Int
                headerValue = "4fdfcfe813f040e5b468bf778ae3aaf0";
                strAPI = "https://m61engine-int.azurewebsites.net/requests";
            }
            else if (env == "prod")
            {
                //Prod
                headerValue = "fc00b7e3880e4f04abffdf03b6fca55d";
                strAPI = "https://m61engine.azurewebsites.net/requests";
            }

            string status = "";

            try
            {
                //sample url
                //https://m61engine-int.azurewebsites.net/requests/e1f0356a76944db59d06ad8ccbc82928/outputs/logs-e1f0356a76944db59d06ad8ccbc82928.log            
                var strPrepayPremiumAPI = strAPI + "/" + requestid + "/outputs/logs-" + requestid + ".log";
                HttpClient prepaypremiumclient = new HttpClient();
                prepaypremiumclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                var apiprepaypremiumresult = prepaypremiumclient.GetAsync(strPrepayPremiumAPI).Result;


                if (apiprepaypremiumresult.IsSuccessStatusCode == true)
                {
                    var prepaypremiumresponse = apiprepaypremiumresult.Content.ReadAsStringAsync().Result;
                    status = prepaypremiumresponse;

                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = status,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = true,
                    Message = "Error",
                    ErrorDetails = ex.StackTrace
                };

            }

            return Ok(_authenticationResult);

        }
        [HttpPost]
        [Route("api/v1calc/updateM61EnginecalcStatus")]
        //[Route("api/v1calc/updateM61EnginecalcStatus")]

        public IActionResult UpdateM61EngineCalcStatus([FromBody] dynamic json)
        {
            v1GenericResult _authenticationResult = null;
            string headerValues = "";
            ExceptionDataContract edc = new ExceptionDataContract();
            GetConfigSetting();
            LoggerLogic log = new LoggerLogic();
            V1CalcLogic v1logic = new V1CalcLogic();

            V1CalcQueueSaveOutput v1data = new V1CalcQueueSaveOutput();

            string requestid = ""; string status = ""; string message = "";
            requestid = json["request_id"];
            status = json["status"];
            message = json["message"];
            string headerkey = Sectionroot.GetSection("TokenValue").Value;
            if (!string.IsNullOrEmpty(Request.Headers["CRETokenKey"]))
            {
                headerValues = Request.Headers["CRETokenKey"].ToString();
            }
            string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;
            string v1headerkey = Sectionroot.GetSection("Authkeyname").Value;
            string v1headerValue = Sectionroot.GetSection("Authkeyvalue").Value;

            if (headerkey == headerValues)
            {
                try
                {
                    if (requestid != null && status != null)
                    {
                        //Logger log
                        LoggerLogic logWrite = new LoggerLogic();
                        logWrite.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "call UpdateM61EngineCalcStatus API for requestid new  " + requestid + " statusId " + status, requestid, "", "UpdateM61EngineCalcStatus");
                        string TableName = v1logic.CheckRequestIdInCalcTable(requestid);
                        if (!string.IsNullOrEmpty(TableName))
                        {
                            {
                                if (TableName == "CalculationRequests")
                                {
                                    string msg = v1logic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(status), edc.StackTrace);
                                    if (status.ToString() == "2")
                                    {
                                        //manish
                                        // log.WriteLogInfo("CalcDataSaving", "GetFileOutput called." + " Requestid " + requestid, requestid, "");
                                        v1data = GetDataFromCalcRequestsByRequestID(requestid);
                                        v1data.headerkey = v1headerkey;
                                        v1data.headerValue = v1headerValue;
                                        v1data.strAPI = strAPI;
                                        //V1CalcQueueAPI(v1data);
                                    }
                                    else if (status.ToString() == "-1" || status.ToString() == "-2")
                                    {

                                        edc = ReadException(message);
                                        log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in calculating for request id:: " + Convert.ToString(json) + " " + edc.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", edc.MethodName, edc.Summary);
                                    }

                                    _authenticationResult = new v1GenericResult()
                                    {
                                        Status = 1,
                                        Succeeded = true,
                                        Message = "Success",
                                        ErrorDetails = ""
                                    };

                                }
                                else if (TableName == "CalculationRequestsLiability")
                                {
                                    logWrite.WriteLogInfo(CRESEnums.Module.LiabiltyFeeInterestCalculator.ToString(), "called UpdateM61EngineCalcStatus API for CalculationRequestsLiability  " + requestid + " statusId " + status, requestid, "", "UpdateM61EngineCalcStatus");

                                    if (status.ToString() == "2")
                                    {
                                        var res = "";
                                        logWrite.WriteLogInfo(CRESEnums.Module.LiabiltyFeeInterestCalculator.ToString(), "Completed  " + requestid + " statusId " + status, requestid, "", "UpdateM61EngineCalcStatus");
                                        v1data = v1logic.GetDataFromCalculationRequestsLiabilityByRequestID(requestid);
                                        if (v1data.CalcType == 911)
                                        {
                                            res = v1logic.SaveTransactionsOutputForLiabilityFeeAndInterest(requestid, v1headerkey, v1headerValue, strAPI, v1data.AnalysisID, v1data.username, v1data.CalcType);
                                        }
                                        else if (v1data.CalcType == 935)
                                        {
                                            res = v1logic.SaveTransactionsOutputForLiabilityFee(requestid, v1headerkey, v1headerValue, strAPI, v1data.AnalysisID, v1data.username, v1data.CalcType);
                                        }

                                        if (res == "Saved")
                                        {
                                            string msg = v1logic.UpdateM61EngineCalcStatusForLiability(requestid, Convert.ToInt32(status), "");
                                        }
                                    }
                                    else
                                    {

                                        v1logic.UpdateM61EngineCalcStatusForLiability(requestid, Convert.ToInt32(status), message);
                                        if (status.ToString() == "-1" || status.ToString() == "-2")
                                        {
                                            edc = ReadException(message);
                                            log.WriteLogExceptionMessage(CRESEnums.Module.LiabiltyFeeInterestCalculator.ToString(), "Error in calculating for request id:: " + Convert.ToString(json) + " " + edc.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", edc.MethodName, edc.Summary);
                                        }
                                    }

                                    _authenticationResult = new v1GenericResult()
                                    {
                                        Status = 1,
                                        Succeeded = true,
                                        Message = "Success",
                                        ErrorDetails = ""
                                    };
                                }


                            }
                        }



                    }

                }
                catch (Exception ex)
                {
                    _authenticationResult = new v1GenericResult()
                    {
                        Status = 2,
                        Succeeded = false,
                        Message = "Error",
                        ErrorDetails = ex.Message
                    };
                    log.WriteLogException(CRESEnums.Module.V1Calculator.ToString(), "Error in UpdateM61EngineCalcStatus " + Convert.ToString(json), "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "UpdateM61EngineCalcStatus", "", ex);

                }
                return Ok(_authenticationResult);
            }
            else
            {
                log.WriteLogInfo(CRESEnums.Module.V1Calculator.ToString(), "UpdateM61EngineCalcStatus api Unauthorized access", "", "", "UpdateM61EngineCalcStatus");
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status401Unauthorized, "Unauthorized access");
            }
        }
        public ExceptionDataContract ReadException(string errormesg)
        {
            ExceptionDataContract edc = new ExceptionDataContract();
            string errtype = "";
            try
            {
                string innnerexeption = "";
                string[] errortype = { "AttributeError", "KeyError:", "ImportError", "IndexError", "SyntaxError", "NameError", "TypeError", "ValueError", "ConnectionError", "InvalidOperation", "Exception:", "MaxRetryError:" };
                for (int i = 0; i < errortype.Length; i++)
                {
                    var res = errormesg.Contains(errortype[i]);
                    if (res == true)
                    {
                        var errormessage = errormesg.Substring(errormesg.IndexOf(errortype[i]) + (errortype[i]).Length);
                        if (errormessage != "")
                        {
                            errtype = errortype[i];
                            if (errtype == "KeyError:")
                            {
                                int id = errormessage.LastIndexOf(errtype);
                                int indexoferror = errormessage.LastIndexOf("During handling of the above exception, another exception occurred");
                                if (id > 0)
                                {
                                    innnerexeption = errormessage.Substring(id, indexoferror - id);
                                }
                                else
                                {
                                    innnerexeption = errormessage;
                                }
                            }
                            else
                            {
                                int indexoferror = errormessage.IndexOf("During handling of the above exception, another exception occurred");
                                if (indexoferror > 0)
                                {
                                    innnerexeption = errormessage.Substring(0, indexoferror);
                                }
                                else
                                {
                                    innnerexeption = errormessage;
                                }
                            }

                            break;
                        }
                    }
                }

                edc.Summary = innnerexeption;
                edc.MethodName = errtype;
                edc.StackTrace = errormesg;
                return edc;
            }
            catch (Exception ex)
            {
                edc.Summary = ex.Message;
                edc.MethodName = errtype;
                edc.StackTrace = ex.StackTrace;
                return edc;
            }
        }
        //======
        public string GetPurposeTypetext(int? purposeID)
        {
            string purposetype = "";
            switch (purposeID)
            {
                case 315:
                    purposetype = "Property Release";
                    break;
                case 316:
                    purposetype = "Payoff/Paydown";
                    break;
                case 317:
                    purposetype = "Additional Collateral Purchase";
                    break;
                case 318:
                    purposetype = "Capital Expenditure";
                    break;
                case 319:
                    purposetype = "Debt Service / Opex";
                    break;
                case 320:
                    purposetype = "TI/LC";
                    break;
                case 321:
                    purposetype = "Other";
                    break;
                case 351:
                    purposetype = "Amortization";
                    break;
                case 517:
                    purposetype = "Capitalized Interest (Complex)";
                    break;
                case 518:
                    purposetype = "Capitalized Interest (Non-Complex)";
                    break;
                case 519:
                    purposetype = "OpEx";
                    break;
                case 520:
                    purposetype = "Force Funding";
                    break;
                case 581:
                    purposetype = "Capitalized Interest";
                    break;
                case 629:
                    purposetype = "Note Transfer";
                    break;
                case 630:
                    purposetype = "Full Payoff";
                    break;
                case 631:
                    purposetype = "Paydown";
                    break;
                case 840:
                    purposetype = "Principal Writeoff";
                    break;
                case 875:
                    purposetype = "Net Property Income/Loss";
                    break;
                case 879:
                    purposetype = "Equity Distribution";
                    break;
            }
            return purposetype;
        }

        [HttpGet]
        [Route("api/v1calc/GetBackShopExportJson")]
        public IActionResult GetBackShopExportJson(string dealid, string noteid, string type)
        {

            string jsonstring = "";
            string returnjson = "[";
            try
            {
                GetConfigSetting();
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
                backshopconsturl = Sectionroot.GetSection("BackshopImportConstantUrl").Value;
                DataTable dt = backlogic.ExportFFandPIKgetrecordsforJson(dealid, noteid, useridforSys_Scheduler, type);
                var countdeleted = dt.Select("IsDeleted = True").Count();

                for (var i = 0; i < stringarr.Length; i++)
                {
                    jsonstring = "";
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
                        }
                    }

                    returnjson = returnjson + jsonstring + ",";
                }
                if (returnjson != "")
                {
                    returnjson = returnjson.TrimEnd(',');
                }

                returnjson = returnjson + "]";
                return Ok(returnjson);
            }
            catch (Exception ex)
            {
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError, "Internal Server Error");
            }
        }
        //12
        public void ExportDataTobackShop(string noteid, string requestid, string SourceNoteID, string username)
        {
            LoggerLogic Log = new LoggerLogic();
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            try
            {
                string AllowBackshopPIKPrincipal = "";
                string dealID = "";

                DataTable dt = _V1CalcLogic.GetNoteInfoForPIKExport_V1(noteid);
                foreach (DataRow dr in dt.Rows)
                {
                    AllowBackshopPIKPrincipal = Convert.ToString(dr["AllowBackshopPIKPrincipal"]);
                    dealID = Convert.ToString(dr["dealid"]);
                }
                if (AllowBackshopPIKPrincipal == "1")
                {

                    Log.WriteLogInfo("CalcDataSaving", "BackshopPIKPrincipal Started ." + " Requestid " + requestid, requestid, "");
                    BackShopExportLogic backShopExportLogic = new BackShopExportLogic();
                    backShopExportLogic.ExportPIKPrincipalFromCRES_API(SourceNoteID, username);
                    backShopExportLogic.ExportDataToBackShop(dealID, username, noteid, "PIK");
                    Log.WriteLogInfo("CalcDataSaving", "BackshopPIKPrincipal Ended ." + " Requestid " + requestid, requestid, "");

                }
                WeightedSpreadCalcHelperLogic wsc = new WeightedSpreadCalcHelperLogic();
                wsc.CaculateWeightedAvg(dealID, username, noteid);

            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in ExportDataTobackShop : " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "ExportDataTobackShop", ex.Message);
            }
        }

        [HttpPost]
        [Route("api/queuestorage/v1calcQueueAPI")]
        public async Task V1CalcQueueAPI([FromBody] V1CalcQueueSaveOutput v1paramdata)
        {
            string AzureStorageAccConnString = _configuration["Application:AzureStorageAccConnString"];
            string AzureQueueName = _configuration["Application:AzureQueueName"];

            var options = new QueueClientOptions();
            options.MessageEncoding = QueueMessageEncoding.Base64;

            var queClient = new QueueClient(AzureStorageAccConnString, AzureQueueName, options);

            string jsonData = System.Text.Json.JsonSerializer.Serialize(v1paramdata);
            await queClient.SendMessageAsync(jsonData);

        }

        public V1CalcQueueSaveOutput GetDataFromCalcRequestsByRequestID(string requestid)
        {
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            V1CalcQueueSaveOutput v1data = new V1CalcQueueSaveOutput();

            v1data.requestid = requestid;

            DataTable dt = _V1CalcLogic.GetDataFromCalculationRequestsByRequestID(requestid);
            foreach (DataRow dr in dt.Rows)
            {
                v1data.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                v1data.username = Convert.ToString(dr["UserName"]);
                v1data.noteid = Convert.ToString(dr["NoteId"]);
                v1data.SourceNoteID = Convert.ToString(dr["crenoteid"]);
            }
            return v1data;
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/testresponse")]

        public IActionResult testresponse()
        {
            string fileName = "request_rules.json";
            string currentDirectoryPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot//JSONTemplate//" + fileName);

            try
            {
                string finalFileNameWithPath = string.Empty;
                finalFileNameWithPath = string.Format("{0}\\{1}", currentDirectoryPath, fileName);


                string jsonRequest = System.IO.File.ReadAllText(currentDirectoryPath);
                return Ok(jsonRequest);
            }
            catch (Exception ex)
            {
                return Ok(currentDirectoryPath + "-" + ex.Message + " " + ex.StackTrace);
            }

        }

    }
}

public class Jsonresponse
{
    public string message { get; set; }
    public string request_id { get; set; }
}
public class Note
{
    public string noteID { get; set; }
    public string noteName { get; set; }
}

public class ResultContent
{
    public dynamic data { get; set; }
}

public class ResultContentRoot
{
    public ResultContent result_content { get; set; }
}
