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
using System.Threading;
using System.Threading.Tasks;
namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class V1CalcController : ControllerBase
    {
        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/getdealcalcrequest")]
#pragma warning disable CS8632 // The annotation for nullable reference types should only be used in code within a '#nullable' annotations context.
        public IActionResult GetDealCalcRequest(string objectID, int objectTypeId, int calctype, string? analysisID)
#pragma warning restore CS8632 // The annotation for nullable reference types should only be used in code within a '#nullable' annotations context.
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            //string analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            if (analysisID == null)
            {
                analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            }
            dynamic objJsonResult = v1logic.GetDealCalcRequestData(objectID, objectTypeId, analysisID, calctype, false, true);

            var returnType = objJsonResult.GetType();
            if (returnType.Name == "Int32")
            {

            }
            return Ok(objJsonResult);
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/submitCalcRequest")]
        public IActionResult submitCalcRequest(string CreDealID)
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            string analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            v1logic.SubmitCalcRequest(CreDealID, 182, analysisID, 775, false);
            return Ok();
        }

        public void GetFileOutput(string requestid)
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
                    Thread FirstThread2 = new Thread(() => CheckAndSavePeriodicOutput(requestid, headerkey, headerValue, strAPI, crenoteid, AnalysisID, username));
                    FirstThread2.Start();

                    Thread FirstThread3 = new Thread(() => CheckAndSaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, crenoteid, AnalysisID, username, noteid));
                    FirstThread3.Start();

                    Thread FirstThread4 = new Thread(() => CheckAndSaveStripingOutput(requestid, headerkey, headerValue, strAPI, crenoteid, AnalysisID, username));
                    FirstThread4.Start();
                }

                if (CalcType == 775)
                {
                    //daily outputs
                    // transactions saving

                    /*
                    SavingFailedFor = "Daily_Data";
                    var dailyDataAPI = strAPI + "/" + requestid + "/outputs/daily_data.csv";
                    HttpClient DailyData = new HttpClient();
                    DailyData.DefaultRequestHeaders.Add(headerkey, headerValue);
                    var dailyDataresult = DailyData.GetAsync(dailyDataAPI).Result;
                    if (dailyDataresult.IsSuccessStatusCode == true)
                    {
                        NoteLogic nl = new NoteLogic();
                        List<DailyInterestAccrualsDataContract> ListDailyInterest = new List<DailyInterestAccrualsDataContract>();
                        List<PeriodicInterestRateUsed> ListPeriodicInterestRateUsed = new List<PeriodicInterestRateUsed>();

                        var response = dailyDataresult.Content.ReadAsStringAsync().Result;
                        var output = JsonConvert.DeserializeObject<Jsonperiodicresponse>(response);
                        DataTable dtoutput = convertStringToDataTable(output.data);

                        List<string> collist = new List<string>();
                        foreach (DataColumn column in dtoutput.Columns)
                        {
                            collist.Add(column.ColumnName);
                        }

                        foreach (DataRow row in dtoutput.Rows)
                        {
                            DailyInterestAccrualsDataContract dia = new DailyInterestAccrualsDataContract();

                            DateTime? cdate = CommonHelper.ToDateTime(row["Date"]);
                            row["Date"] = CommonHelper.ToDateTime(row["Date"]);
                            dia.Date = cdate;
                            dia.NoteID = noteid;
                            dia.AnalysisID = AnalysisIDGuid;
                            dia.EndingBalance = CommonHelper.StringToDecimal(row["endbal"]).GetValueOrDefault(0);
                            dia.DailyInterestAccrual = CommonHelper.StringToDecimal(row["dailyint"]).GetValueOrDefault(0);
                            ListDailyInterest.Add(dia);

                            PeriodicInterestRateUsed pir = new PeriodicInterestRateUsed();
                            pir.NoteID = noteid;
                            pir.Date = cdate;
                            pir.CouponSpread = CommonHelper.ToDecimal(row["spread_val"]).GetValueOrDefault(0);
                            pir.AllInCouponRate = CommonHelper.ToDecimal(row["allincouponrate"]).GetValueOrDefault(0);
                            pir.AllInPikRate = CommonHelper.ToDecimal(row["allinpikrate"]).GetValueOrDefault(0);
                            pir.LiborRate = CommonHelper.ToDecimal(row["indexrate"]).GetValueOrDefault(0);
                            pir.IndexFloor = CommonHelper.ToDecimal(row["index_floor_val"]).GetValueOrDefault(0);
                            pir.CouponRate = CommonHelper.ToDecimal(row["coupon_floor_val"]).GetValueOrDefault(0);
                            pir.AdditionalPIKinterestRatefromPIKTable = CommonHelper.ToDecimal(row["pikrate_rate"]).GetValueOrDefault(0);
                            pir.AdditionalPIKSpreadfromPIKTable = CommonHelper.ToDecimal(row["pikrate_spread"]).GetValueOrDefault(0);
                            pir.PIKIndexFloorfromPIKTable = CommonHelper.ToDecimal(row["pikrate_index_floor"]).GetValueOrDefault(0);
                            pir.AnalysisID = AnalysisIDGuid;

                            ListPeriodicInterestRateUsed.Add(pir);

                        }
                        if (ListDailyInterest.Count > 0)
                        {
                            nl.InsertDailyInterestAccural(ListDailyInterest, noteid, username);
                        }
                        if (ListPeriodicInterestRateUsed.Count > 0)
                        {
                            nl.InsertPeriodicInterestRateUsed(ListPeriodicInterestRateUsed, noteid, username);
                        }
                    }
                    */

                }

                if (CalcType == 776)
                {
                    // Prepay premium saving
                    SavingFailedFor = "Prepaypremium_Output";
                    var strPrepayPremiumAPI = strAPI + "/" + requestid + "/outputs/prepaypremium.csv";
                    HttpClient prepaypremiumclient = new HttpClient();
                    prepaypremiumclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                    var apiprepaypremiumresult = prepaypremiumclient.GetAsync(strPrepayPremiumAPI).Result;
                    if (apiprepaypremiumresult.IsSuccessStatusCode == true)
                    {
                        var prepaypremiumresponse = apiprepaypremiumresult.Content.ReadAsStringAsync().Result;
                        var prepaypremiumoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(prepaypremiumresponse);
                        DataTable dtPrepaypremiumoutput = convertStringToDataTable(prepaypremiumoutput.data);

                        _V1CalcLogic.InsertPrepayPremiumEntry(dtPrepaypremiumoutput, username);
                    }
                }

                if (CalcType == 776)
                {
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

                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB.");
                Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in saving for  " + SavingFailedFor + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);
            }
            finally
            {
                Log.WriteLogInfo("CalcDataSaving", " finally " + " Requestid  " + requestid + " ex " + result, requestid, "");
            }
        }

        public void CheckAndSavePeriodicOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            var status = SavePeriodicOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside PeriodicOutput retry " + " Requestid " + requestid + " status " + status, requestid, "");
                status = SavePeriodicOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
            }
        }

        public void CheckAndSaveTransactionsOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username, string noteid)
        {

            var status = SaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username, noteid);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output retry " + " Requestid " + requestid + " status " + status, requestid, "");

                status = SaveTransactionsOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username, noteid);
            }
        }

        public void CheckAndSaveStripingOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            var status = SaveStripingOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
            if (status == "Retry")
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo("CalcDataSaving", " inside StripingOutput retry " + " Requestid " + requestid + " status " + status, requestid, "");
                status = SaveStripingOutput(requestid, headerkey, headerValue, strAPI, SourceNoteID, AnalysisID, username);
            }
        }

        public string SavePeriodicOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            string status = "";
            int? responsecode = null;
            LoggerLogic Log = new LoggerLogic();
            try
            {

                var cts = new CancellationTokenSource();

                var strPeriodicAPI = strAPI + "/" + requestid + "/outputs/periodic.csv";
                Log.WriteLogInfo("CalcDataSaving", "inside get Periodic_Output 3 " + " Requestid " + requestid, requestid, "");

                V1CalcLogic _V1CalcLogic = new V1CalcLogic();
                _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");

                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                dynamic response;
                using (var client = new HttpClient())
                using (var request = new HttpRequestMessage())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Add(headerkey, headerValue);
                    client.Timeout = TimeSpan.FromSeconds(60);

                    request.Method = HttpMethod.Get;
                    request.RequestUri = new Uri(strPeriodicAPI);
                    response = client.GetAsync(strPeriodicAPI, cts.Token).Result;
                    responsecode = (int)response.StatusCode;
                    response.EnsureSuccessStatusCode();
                }
                Log.WriteLogInfo("CalcDataSaving", "inside  get Periodic_Output 4 " + " Requestid " + requestid, requestid, "");

                if (response.IsSuccessStatusCode == true)
                {
                    Log.WriteLogInfo("CalcDataSaving", "inside  get Periodic_Output 5 " + " Requestid " + requestid, requestid, "");
                    var periodresponse = response.Content.ReadAsStringAsync().Result;
                    var periodoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(periodresponse);
                    DataTable dtperiodoutput = convertStringToDataTable(periodoutput.data);
                    List<string> Peridiccollist = new List<string>();
                    if (dtperiodoutput.Rows.Count > 0)
                    {
                        SourceNoteID = dtperiodoutput.Rows[0]["Note"].ToString();
                    }
                    foreach (DataRow row in dtperiodoutput.Rows)
                    {
                        row["Date"] = CommonHelper.ToDateTime(row["Date"]);
                        row["initbal"] = CommonHelper.StringToDecimal(row["initbal"]);
                        row["endbal"] = CommonHelper.StringToDecimal(row["endbal"]);
                        row["initbal"] = CommonHelper.StringToDecimal(row["initbal"]);
                        row["schprin"] = CommonHelper.StringToDecimal(row["schprin"]);
                        row["funding"] = CommonHelper.StringToDecimal(row["funding"]);
                        row["act_periodpikint"] = CommonHelper.StringToDecimal(row["act_periodpikint"]);
                        row["paydown"] = CommonHelper.StringToDecimal(row["paydown"]);
                        row["periodpikint"] = CommonHelper.StringToDecimal(row["periodpikint"]);
                        row["act_periodint"] = CommonHelper.StringToDecimal(row["act_periodint"]);
                        row["act_periodpikintpaid"] = CommonHelper.StringToDecimal(row["act_periodpikintpaid"]);
                        row["act_pikprinpaid"] = CommonHelper.StringToDecimal(row["act_pikprinpaid"]);

                        row["clean_cost"] = CommonHelper.StringToDecimal(row["clean_cost"]);
                        row["feeamort"] = CommonHelper.StringToDecimal(row["feeamort"]);
                        row["cum_am_fee"] = CommonHelper.StringToDecimal(row["cum_am_fee"]);
                        row["am_capcosts"] = CommonHelper.StringToDecimal(row["am_capcosts"]);
                        row["am_disc"] = CommonHelper.StringToDecimal(row["am_disc"]);
                        row["gaapbv"] = CommonHelper.StringToDecimal(row["gaapbv"]);

                        row["intaccrual"] = CommonHelper.StringToDecimal(row["intaccrual"]);
                        row["pikintaccrual"] = CommonHelper.StringToDecimal(row["pikintaccrual"]);
                        row["intsuspensebal"] = CommonHelper.StringToDecimal(row["intsuspensebal"]);

                    }
                    if (dtperiodoutput.Rows.Count > 0)
                    {
                        dtperiodoutput.Columns["Date"].SetOrdinal(0);
                        dtperiodoutput.Columns["Note"].SetOrdinal(1);
                        dtperiodoutput.Columns["initbal"].SetOrdinal(2);
                        dtperiodoutput.Columns["funding"].SetOrdinal(3);
                        dtperiodoutput.Columns["paydown"].SetOrdinal(4);
                        dtperiodoutput.Columns["schprin"].SetOrdinal(5);
                        dtperiodoutput.Columns["periodpikint"].SetOrdinal(6);
                        dtperiodoutput.Columns["act_periodint"].SetOrdinal(7);
                        dtperiodoutput.Columns["act_periodpikintpaid"].SetOrdinal(8);
                        dtperiodoutput.Columns["act_periodpikint"].SetOrdinal(9);
                        dtperiodoutput.Columns["act_pikprinpaid"].SetOrdinal(10);
                        dtperiodoutput.Columns["endbal"].SetOrdinal(11);

                        dtperiodoutput.Columns["clean_cost"].SetOrdinal(12);
                        dtperiodoutput.Columns["feeamort"].SetOrdinal(13);
                        dtperiodoutput.Columns["cum_am_fee"].SetOrdinal(14);
                        dtperiodoutput.Columns["am_capcosts"].SetOrdinal(15);
                        dtperiodoutput.Columns["am_disc"].SetOrdinal(16);
                        dtperiodoutput.Columns["gaapbv"].SetOrdinal(17);

                        dtperiodoutput.Columns["intaccrual"].SetOrdinal(18);
                        dtperiodoutput.Columns["pikintaccrual"].SetOrdinal(19);
                        dtperiodoutput.Columns["intsuspensebal"].SetOrdinal(20);

                    }
                    else
                    {
                        Log.WriteLogInfo("CalcDataSaving", "Periodic_Output Row count 0." + " Requestid " + requestid, requestid, "");
                    }

                    Log.WriteLogInfo("CalcDataSaving", "going for Periodic_Output saving " + " Requestid " + requestid, requestid, "");

                    _V1CalcLogic.InsertUpdateNotePeriodicCalc(dtperiodoutput, AnalysisID, username, SourceNoteID);
                    status = "Saved";
                    Log.WriteLogInfo("CalcDataSaving", "Periodic_Output saving ended " + " Requestid " + requestid, requestid, "");
                }
                else
                {
                    Log.WriteLogInfo("CalcDataSaving", "Periodic_Output File not found.Error Code : " + responsecode + " Requestid " + requestid, requestid, "");
                }

            }
            catch (Exception ex)
            {
                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : PeriodicOutput : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : PeriodicOutput as M61 output api did not responds in 10 secs ";
                }

                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in saving for PeriodicOutput " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);

            }
            return status;
        }

        public string SaveTransactionsOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username, string noteid)
        {
            string status = "";
            int? responsecode = 0;
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
#pragma warning disable CS0219 // The variable 'SavingFailedFor' is assigned but its value is never used
            string SavingFailedFor = "";
#pragma warning restore CS0219 // The variable 'SavingFailedFor' is assigned but its value is never used
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();

            try
            {
                _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 1 " + " Requestid " + requestid, requestid, "");
                // transactions saving
                SavingFailedFor = "Transactions_Output";
                var strtransactionAPI = strAPI + "/" + requestid + "/outputs/transactions.csv";
                HttpClient transactionsclient = new HttpClient();
                transactionsclient.Timeout = TimeSpan.FromSeconds(60);
                transactionsclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 2 " + " Requestid " + requestid, requestid, "");
                var apitransactionsresult = transactionsclient.GetAsync(strtransactionAPI, cts.Token).Result;
                responsecode = (int)apitransactionsresult.StatusCode;
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 3 " + " Requestid " + requestid, requestid, "");
                if (apitransactionsresult.IsSuccessStatusCode == true)
                {
                    var transactionsresponse = apitransactionsresult.Content.ReadAsStringAsync().Result;
                    Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 4 " + " Requestid " + requestid, requestid, "");
                    var transactionsoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(transactionsresponse);

                    Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 5 " + " Requestid " + requestid, requestid, "");
                    DataTable dtTransactionsoutput = convertStringToDataTable(transactionsoutput.data);

                    List<string> collist = new List<string>();
                    foreach (DataColumn column in dtTransactionsoutput.Columns)
                    {
                        collist.Add(column.ColumnName);
                    }
                    string[] requiredcol = { "Date", "Note", "type", "value", "Fee Name", "IO Term End Date", "purpose", "remit_dt", "transdtbyrule_dt", "trans_dt", "due_dt" };

                    //remove column which are not required 
                    foreach (var item in collist)
                    {
                        var res = requiredcol.Contains(item);
                        if (res == false)
                        {
                            if (dtTransactionsoutput.Columns.IndexOf(item) != -1)
                            {
                                dtTransactionsoutput.Columns.Remove(item);
                            }
                        }
                    }
                    // add column which are required 
                    foreach (string item in requiredcol)
                    {
                        if (dtTransactionsoutput.Columns.IndexOf(item) == -1)
                        {
                            dtTransactionsoutput.Columns.Add(item);
                        }

                    }
                    foreach (DataRow row in dtTransactionsoutput.Rows)
                    {
                        DateTime? due_dt = CommonHelper.ToDateTime(row["due_dt"]);
                        int? currentpurpose = CommonHelper.ToInt32(CommonHelper.StringToDecimal(row["purpose"]));
                        row["value"] = Math.Round(CommonHelper.StringToDecimal(row["value"]).GetValueOrDefault(0), 10);
                        row["IO Term End Date"] = CommonHelper.ToDateTime(row["IO Term End Date"]);
                        row["purpose"] = currentpurpose;
                        row["remit_dt"] = CommonHelper.ToDateTime(row["remit_dt"]);
                        row["transdtbyrule_dt"] = CommonHelper.ToDateTime(row["transdtbyrule_dt"]);
                        row["trans_dt"] = CommonHelper.ToDateTime(row["trans_dt"]);
                        row["due_dt"] = due_dt;
                        if (currentpurpose != 0)
                        {
                            row["purpose"] = GetPurposeTypetext(currentpurpose);
                        }
                        if (due_dt != null)
                        {
                            row["Date"] = due_dt;
                        }

                    }
                    Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 6 " + " Requestid " + requestid, requestid, "");
                    if (dtTransactionsoutput.Rows.Count > 0)
                    {
                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output saving started ." + dtTransactionsoutput.Rows.Count + " Requestid " + requestid, requestid, "");
                        //Transactions_Output
                        _V1CalcLogic.InsertTransactionEntry(dtTransactionsoutput, AnalysisID, username, SourceNoteID, username);
                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output saving ended ." + dtTransactionsoutput.Rows.Count + " Requestid " + requestid, requestid, "");
                        _V1CalcLogic.UpdateTransactionEntryCash_NonCash(noteid, AnalysisID);

                        Log.WriteLogInfo("CalcDataSaving", "UpdateTransactionEntryCash_NonCash saving ended ." + dtTransactionsoutput.Rows.Count + " Requestid " + requestid, requestid, "");

                        status = "Saved";
                    }
                    else
                    {
                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output Row count 0." + " Requestid " + requestid, requestid, "");
                    }
                }
                else
                {
                    Log.WriteLogInfo("CalcDataSaving", "Transactions_Output File not found.Error Code " + responsecode + " Requestid " + requestid, requestid, "");
                }
            }
            catch (Exception ex)
            {

                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();

                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Transactions_Output as M61 output api did not responds in 60 secs ";
                }
                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in saving for Transactions_Output : " + responsecode + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);

            }

            return status;
        }

        public string SaveStripingOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            string status = "";
#pragma warning disable CS0219 // The variable 'responsecode' is assigned but its value is never used
            int? responsecode = null;
#pragma warning restore CS0219 // The variable 'responsecode' is assigned but its value is never used
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
#pragma warning disable CS0219 // The variable 'SavingFailedFor' is assigned but its value is never used
            string SavingFailedFor = "";
#pragma warning restore CS0219 // The variable 'SavingFailedFor' is assigned but its value is never used
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();

            try
            {
                // strips saving
                SavingFailedFor = "Striping_Output";
                _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");
                var strstripAPI = strAPI + "/" + requestid + "/outputs/strips.csv";
                HttpClient stripClient = new HttpClient();
                stripClient.DefaultRequestHeaders.Add(headerkey, headerValue);
                var stripres = stripClient.GetAsync(strstripAPI).Result;
                if (stripres.IsSuccessStatusCode == true)
                {
                    var response = stripres.Content.ReadAsStringAsync().Result;
                    var output = JsonConvert.DeserializeObject<Jsonperiodicresponse>(response);
                    DataTable dtoutput = convertStringToDataTable(output.data);

                    string[] requiredcol = { "Date", "Note", "type", "value", "Fee Name", "Rate", "Effective Date", "Parent Note" };

                    foreach (string item in requiredcol)
                    {
                        if (dtoutput.Columns.IndexOf(item) == -1)
                        {
                            dtoutput.Columns.Add(item);
                        }

                    }
                    List<string> collist = new List<string>();
                    foreach (DataColumn column in dtoutput.Columns)
                    {
                        collist.Add(column.ColumnName);
                    }
                    foreach (var item in collist)
                    {
                        var res = requiredcol.Contains(item);
                        if (res == false)
                        {
                            if (dtoutput.Columns.IndexOf(item) != -1)
                            {
                                dtoutput.Columns.Remove(item);
                            }
                        }
                    }
                    foreach (DataRow row in dtoutput.Rows)
                    {
                        row["value"] = CommonHelper.StringToDecimal(row["value"]);
                        row["Rate"] = CommonHelper.StringToDecimal(row["Rate"]);
                        row["Date"] = Convert.ToDateTime(row["Date"]);
                        row["Effective Date"] = Convert.ToDateTime(dtoutput.Rows[0]["Effective Date"]);
                    }
                    if (dtoutput.Rows.Count > 0)
                    {
                        if (dtoutput.Columns.IndexOf("Parent Note") == -1)
                        {
                            dtoutput.Columns.Add("Parent Note");
                        }
                        dtoutput.Columns["Parent Note"].ColumnName = "SourceNoteID";
                        dtoutput.Columns["Date"].SetOrdinal(0);
                        dtoutput.Columns["Note"].SetOrdinal(1);
                        dtoutput.Columns["type"].SetOrdinal(2);
                        dtoutput.Columns["value"].SetOrdinal(3);
                        dtoutput.Columns["Rate"].SetOrdinal(4);
                        dtoutput.Columns["Effective Date"].SetOrdinal(5);
                        dtoutput.Columns["Fee Name"].SetOrdinal(6);
                        dtoutput.Columns["SourceNoteID"].SetOrdinal(7);

                        _V1CalcLogic.InsertPayRuleDistribution(dtoutput, AnalysisID, username);
                        status = "Saved";
                    }
                }
            }
            catch (Exception ex)
            {

                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : Striping_Output : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Striping_Output as M61 output api did not responds in 60 secs ";
                }

                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in saving for Striping_Output " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);
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

            DataTable dtCsv = new DataTable();
            // convert string to stream
            byte[] byteArray = Encoding.UTF8.GetBytes(data);
            MemoryStream Stream = new MemoryStream(byteArray);

            using (StreamReader sr = new StreamReader(Stream))
            {
                while (!sr.EndOfStream)
                {
                    var Fulltext = sr.ReadToEnd().ToString(); //read full file text  
                    string[] rows = Fulltext.Split('\n'); //split full file text into rows  
                    for (int i = 0; i < rows.Count() - 1; i++)
                    {
                        string[] rowValues = rows[i].Split(','); //split each row with comma to get individual values  
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
                                    dr[k] = rowValues[k].ToString();
                                }
                                dtCsv.Rows.Add(dr); //add other rows  
                            }
                        }
                    }
                }
                //}


            }
            return dtCsv;
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/v1calc/CalculateAllDeals")]
        public void CalculateAllDeals()
        {
            try
            {
                V1CalcLogic v1logic = new V1CalcLogic();
                List<V1CalculationStatusDataContract> listofdeal = v1logic.GetRecordsFromCalculationRequest();
                List<V1CalculationStatusDataContract> listofrequestid = v1logic.GetRequestIDFromCalculationRequestsDataNotSaveInDB();

                string res = "";
                // string analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
                if (listofdeal != null && listofdeal.Count > 0)
                {
                    Parallel.ForEach(listofdeal, new ParallelOptions { MaxDegreeOfParallelism = 1 },
                               (item, state) =>
                               {
                                   //Log for check submit calc reuest to V1 engine
                                   //response1.StatusCode
                                   LoggerLogic log = new LoggerLogic();
                                   log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "CalculateAllDeals in api  " + item.objectID + " AnalysisID " + item.AnalysisID, "", "");
                                   res = v1logic.SubmitCalcRequest(item.objectID, Convert.ToInt32(item.objectTypeId), item.AnalysisID, Convert.ToInt32(item.CalcType), true);
                                   //commit for testing
                                   if (res == "Batch Canceled")
                                   {

                                       //Log for check Batch Canceled in DB
                                       //response1.StatusCode
                                       LoggerLogic logBatch = new LoggerLogic();
                                       logBatch.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Batch Canceled in api  " + item.objectID + " AnalysisID " + item.AnalysisID, "", "", "SubmitCalcRequest", "Batch Canceled in api");

                                   }

                               });
                }
                if (listofrequestid != null && listofrequestid.Count > 0)
                {

                }

            }
            catch (Exception ex)
            {
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in CalculateAllDeals " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "CalculateAllDeals", "", ex);
            }
        }

        public void SaveFileInBlob(string requestid, string UserID)
        {
            LoggerLogic Log = new LoggerLogic();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
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
                        Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error occured in Upload Json for request id" + requestid, requestid.ToString(), "", "Error occured in Uploading Json for " + requestid, requestid.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error occured in SaveFileInBlob" + requestid, requestid.ToString(), "", "Error occured in SaveFileInBlob" + requestid, requestid.ToString());
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
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
        public void CheckOutputSaving(string requestid)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                GetFileOutput(requestid);
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }
        [Route("api/v1calc/CheckRetry")]
        public void CheckRetry()
        {
            V1CalcLogic v1logic = new V1CalcLogic();
            List<V1CalculationStatusDataContract> listofrequestid = v1logic.GetRequestIDFromCalculationRequestsDataNotSaveInDB();

            if (listofrequestid != null && listofrequestid.Count > 0)
            {
                foreach (var item in listofrequestid)
                {
                    GetFileOutput(item.RequestID);
                }
            }

        }

        [HttpPost]
        [Route("api/v1calc/updateM61EnginecalcStatus")]
        public IActionResult UpdateM61EngineCalcStatus([FromBody] dynamic json)
        {
            v1GenericResult _authenticationResult = null;
            string headerValues = "";
            ExceptionDataContract edc = new ExceptionDataContract();
            GetConfigSetting();
            LoggerLogic log = new LoggerLogic();
            V1CalcLogic v1logic = new V1CalcLogic();

            string requestid = ""; string status = ""; string message = "";
            requestid = json["request_id"];
            status = json["status"];
            message = json["message"];
            string headerkey = Sectionroot.GetSection("TokenValue").Value;
            if (!string.IsNullOrEmpty(Request.Headers["CRETokenKey"]))
            {
                headerValues = Request.Headers["CRETokenKey"].ToString();
            }
            if (headerkey == headerValues)
            {
                try
                {
                    if (requestid != null && status != null)
                    {
                        //Logger log
                        LoggerLogic logWrite = new LoggerLogic();
                        logWrite.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "call UpdateM61EngineCalcStatus API for requestid " + requestid + " statusId " + status, requestid, "");

                        string msg = v1logic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(status), edc.StackTrace);
                        if (status.ToString() == "2")
                        {
                            //manish
                            log.WriteLogInfo("CalcDataSaving", "GetFileOutput called." + " Requestid " + requestid, requestid, "");
                            Thread FirstThread = new Thread(() => GetFileOutput(requestid));
                            FirstThread.Start();
                        }
                        else if (status.ToString() == "-1" || status.ToString() == "-2")
                        {

                            edc = ReadException(message);
                            log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in calculating for request id:: " + Convert.ToString(json) + " " + edc.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", edc.MethodName, edc.Summary);
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
                catch (Exception ex)
                {
                    _authenticationResult = new v1GenericResult()
                    {
                        Status = 2,
                        Succeeded = false,
                        Message = "Error",
                        ErrorDetails = ex.Message
                    };
                    log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in UpdateM61EngineCalcStatus " + Convert.ToString(json), "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "UpdateM61EngineCalcStatus", "", ex);

                }
                return Ok(_authenticationResult);
            }
            else
            {
                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "UpdateM61EngineCalcStatus api Unauthorized access", "", "");
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
            }
            return purposetype;
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
