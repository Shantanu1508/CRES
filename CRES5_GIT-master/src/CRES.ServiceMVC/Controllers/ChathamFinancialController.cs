using CRES.BusinessLogic;
using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.Services;
using CRES.Utilities;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Graph;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Policy;
using System.Threading;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class ChathamFinancialController : ControllerBase
    {
        public IEmailNotification _iEmailNotification;
        private IHostingEnvironment _env;
        public ChathamFinancialController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";


        [HttpGet]
        [Route("api/ChathamFinancial/GetChathamFinancialForwardRateQuarterly")]
        public IActionResult GetChathamFinancialForwardRateQuarterly()
        {

            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            string Outputresponse = "";
            string ApiConstantUrl = "";
            string fwrateGuid = "";
            string error = "";
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.DailyRatePull.ToString(), "Chatham Financial Quarterly Rate Api called ", "", useridforSys_Scheduler);
                DateTime today = DateTime.Today.Date;
                var dt = DateExtensions.GetNextQuarterEndDate(today);

                NoteLogic _NoteLogic = new NoteLogic();
                List<HolidayListDataContract> ListHoliday = _NoteLogic.GetHolidayList();

                DateTime holidayadjQuarterdate = DateExtensions.GetWorkingDayUsingOffset(dt, -1, "US", ListHoliday);
                if (holidayadjQuarterdate.Date == today.Date)
                {
                    ChathamFinancialLogic ChathamLogic = new ChathamFinancialLogic();
                    DataTable dtconfig = ChathamLogic.GetChathamConfig("QuarterlyForwardRate");
                    foreach (DataRow dr in dtconfig.Rows)
                    {
                        ApiConstantUrl = dr["URL"].ToString() + dr["RatesCode"].ToString();

                        fwrateGuid = dr["IndexesMasterGuid"].ToString();
                        System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                        dynamic CalcResponse = null;
                        using (var client = new HttpClient())
                        {

                            client.Timeout = TimeSpan.FromMinutes(10);
                            var res = client.GetAsync(ApiConstantUrl);
                            try
                            {
                                HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                                if (response1.IsSuccessStatusCode)
                                {
                                    Outputresponse = response1.Content.ReadAsStringAsync().Result;
                                    CalcResponse = JObject.Parse(Outputresponse);
                                }
                            }
                            catch (Exception e)
                            {
                                error = "Chatham Financial Error";
                                Outputresponse = "Chatham Financial Error :" + e.Message;
                            }
                        }
                        if (error == "")
                        {
                            DataTable dtexcel = new DataTable();
                            dtexcel.Columns.Add("Date", typeof(DateTime));
                            dtexcel.Columns.Add("1 Month Term SOFR Forward Curve", typeof(decimal));

                            DataTable dtindexes = new DataTable();
                            dtindexes.Columns.Add("Date");
                            dtindexes.Columns.Add("Name");
                            dtindexes.Columns.Add("Value");
                            dtindexes.Columns.Add("IndexesMasterGuid");

                            var ListRates = CalcResponse["Rates"];
                            if (ListRates != null)
                            {
                                for (var j = 0; j < ListRates.Count; j++)
                                {
                                    DataRow frwrate = dtindexes.NewRow();
                                    frwrate["Date"] = CommonHelper.ToDateTime(ListRates[j].Date);
                                    frwrate["Value"] = CommonHelper.StringToDecimal(ListRates[j].Rate);
                                    frwrate["Name"] = "1M Term SOFR";
                                    frwrate["IndexesMasterGuid"] = fwrateGuid;
                                    dtindexes.Rows.Add(frwrate);

                                    DataRow frwrexcelate = dtexcel.NewRow();
                                    frwrexcelate["Date"] = CommonHelper.ToDateTime(ListRates[j].Date);
                                    frwrexcelate["1 Month Term SOFR Forward Curve"] = CommonHelper.StringToDecimal(ListRates[j].Rate);
                                    dtexcel.Rows.Add(frwrexcelate);

                                }
                            }
                            IndexTypeRepository indexTypeRepository = new IndexTypeRepository();

                            indexTypeRepository.AddUpdateIndexList(dtindexes, useridforSys_Scheduler, useridforSys_Scheduler);
                            // update master 

                            IndexesMasterDataContract _indexesMasterDC = indexTypeRepository.GetIndexesMasterDetailByIndexesMaster(new Guid(fwrateGuid), useridforSys_Scheduler);
                            _indexesMasterDC.Description = "Forward Rate " + DateTime.Now.ToString("MM.dd.yyyy");
                            _indexesMasterDC.UpdatedBy = useridforSys_Scheduler;
                            _indexesMasterDC.UpdatedDate = DateTime.Now;

                            indexTypeRepository.InsertUpdateIndexesMasterDetail(_indexesMasterDC);

                            Log.WriteLogInfo(CRESEnums.Module.DailyRatePull.ToString(), "Chatham Financial Quarterly Rate Api data saved for Forward Rate ", "", useridforSys_Scheduler);

                            Thread FirstThread = new Thread(() => UploadChathamFinancialJson(Outputresponse));
                            FirstThread.Start();

                            string returnMessage = " Quarterly SOFR forward curve rates has been pulled successfully from Chatham Financial.";

                            MemoryStream ms = GetStreamfromDatatable(dtexcel);
                            string randomstring = DateTime.Now.ToString("MM_dd_yyyy");
                            _iEmailNotification.SendChathamFinancialQuarterlyForwardRateNotification(returnMessage, ms, "Chatham_One_Month_Term_SOFR_Forward_Curve_" + randomstring + ".xlsx");

                            _authenticationResult = new v1GenericResult()
                            {
                                Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                                Succeeded = true,
                                Message = "Chatham Financial Quarterly Rate Api data saved for Forward Rate",
                                ErrorDetails = ""
                            };
                        }
                        else
                        {
                            Log.WriteLogExceptionMessage(CRESEnums.Module.DailyRatePull.ToString(), "Chatham Financial Quarterly Rate Api:" + Outputresponse, "", useridforSys_Scheduler, "GetChathamFinancialForwardRateQuarterly", Outputresponse);
                            _authenticationResult = new v1GenericResult()
                            {
                                Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                                Succeeded = false,
                                Message = "Error",
                                ErrorDetails = Outputresponse
                            };
                            _iEmailNotification.SendChathamFinancialDailyRateNotification("An error occurred in the Quarterly SOFR pull from Chatham Financial. M61 systems team is looking for solution.", "Quarterly", "Fail");
                        }
                    }
                }
            }
            catch (Exception ex)
            {

                Log.WriteLogException(CRESEnums.Module.DailyRatePull.ToString(), "Error occured in GetChathamFinancialForwardRateQuarterly ", "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };
                _iEmailNotification.SendChathamFinancialDailyRateNotification("An error occurred in the Quarterly SOFR pull from Chatham Financial. M61 systems team is looking for solution.", "Quarterly", "Fail");
            }
            return Ok(_authenticationResult);

        }
        public void UploadChathamFinancialJson(string jsonStr)
        {
            LoggerLogic Log = new LoggerLogic();
            try
            {
                string filename = "Chatham_USForwardCurves_" + DateTime.Now.ToString("MM_dd_yyyy_HH_mm_ss") + ".json";
                var isJSONSaved = AzureStorageReadFile.UploadChathamFinancialJsonFileToAzureBlob(jsonStr, filename);
                if (isJSONSaved == false)
                {

                    Log.WriteLogExceptionMessage(CRESEnums.Module.DailyRatePull.ToString(), "Error occured in UploadChathamFinancialJson", "", "Error occured in UploadChathamFinancialJson", "", "");
                }
            }
            catch (Exception ex)
            {

                Log.WriteLogException(CRESEnums.Module.DailyRatePull.ToString(), "Error occured in Upload DealFunding Json for ", "", "", ex.TargetSite.Name.ToString(), "", ex);
            }

        }

        public MemoryStream GetStreamfromDatatable(DataTable dt)
        {
            dt.TableName = "Chatham_USForwardCurves";
            Stream ms = new MemoryStream();
            DataSet ds = new DataSet();
            ds.Tables.Add(dt);
            Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "Chatham_USForwardCurves.xlsx").BaseStream;
            ms = WriteDataToExcel.DataSetToExcel(ds, stream);
            return (MemoryStream)ms;
        }
        [HttpGet]
        [Route("api/importrate/getCMEGroupSofrRate")]
        public IActionResult GetCMEGroupSofrRate()
        {
            string ApiConstantUrl = "https://www.cmegroup.com/services/sofr-strip-rates/?isProtected&_t=1698335626025";
            decimal? CurrentPrice = 0;
            JObject resultsStrip = new JObject();

            decimal? Overnight = 0;
            DateTime? CurrentDate = DateTime.MinValue;
            string CREIndexType = "";
            string Outputresponse = "";

            string error = "";
            string returnMessage = "";

            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();

            DataTable dtimport = new DataTable();
            dtimport.Columns.Add("Date");
            dtimport.Columns.Add("Value");
            dtimport.Columns.Add("IndexType");
            DataTable dtcopy = new DataTable();
            DataTable dtconfig = new DataTable();

            try
            {
                Log.WriteLogInfo(CRESEnums.Module.DailyRatePull.ToString(), "CME Group Daily Rate Api called ", "", useridforSys_Scheduler);

                ChathamFinancialLogic ChathamLogic = new ChathamFinancialLogic();
                dtconfig = ChathamLogic.GetChathamConfig("DailyRate");
                //
                string useragent = DateTime.Now.ToString("MMddyyyyHHmmss") + "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36";
                if (dtconfig != null && dtconfig.Rows.Count > 0)
                {
                    if (!string.IsNullOrEmpty(ApiConstantUrl))
                    {
                        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiConstantUrl);
                        request.Method = "GET";
                        request.ContentType = "application/json";
                        request.Headers.Add("Accept", "*/*");
                        request.Headers.Add("Accept-Encoding", "gzip, deflate, br");
                        request.Headers.Add("Accept-Language", "en-US,en;q=0.5");
                        request.Headers.Add("Connection", "keep-alive");
                        request.Headers.Add("Upgrade-Insecure-Requests", "keep-alive");
                        request.Headers.Add("Host", "www.cmegroup.com");
                        request.Headers.Add("Cache-Control", "max-age=0");
                        request.Headers.Add("user-agent", useragent);
                        request.Headers.Add("Cookie", "_evga_e567={%22uuid%22:%22f7ada21a5539f9f5%22}; _sfid_848a={%22anonymousId%22:%22f7ada21a5539f9f5%22%2C%22consents%22:[{%22consent%22:{%22provider%22:%22Consent%20Provider%22%2C%22purpose%22:%22Personalization%22%2C%22status%22:%22Opt%20In%22}%2C%22lastUpdateTime%22:%222025-07-29T05:43:31.282Z%22%2C%22lastSentTime%22:%222025-07-29T05:43:31.290Z%22}]}; kppid=2x10TkFa7Hb; fpestid=TULTelibwyrRHEigsAn7LWzxraSqVQomJrN1MMcSd5hRzv1AieUV9KrFrfq6ZOCbYiZXEQ; __Secure-Fgp=CE44B5AFD9EDED456023EAED18832B5B00DF7155D8BD5617E56EF557A7BFDF3AA2D76553D88F3277E2B9E9A2F9800364E25A; userId=398082; cmeToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsYXN0TmFtZSI6InNpbmdoIiwiY3JlYXRlZERhdGUiOjE3NTM3Njc4NjEsImZpc3ROYW1lIjoibWFuaXNoIiwidW5vSWQiOiJVUjAwMDUyNTgyMiIsInVzZXJGaW5nZXJwcmludCI6IjYxRUEyMjdBMURBQTIwNjY1MDhEQzhGMjQzOUJBNTQzQUQ2MDNGRkNFRTQ0NkY1NDdEQjMzNzc5NjI2Qjg1RjUiLCJpc3MiOiJhdXRoMCIsInVzZXJUeXBlIjoiQiIsImV4cCI6MTc4NTMwMzg2MSwidXNlcklkIjoiMzk4MDgyIiwiZW1haWwiOiJtc2luZ2hAaHZhbnRhZ2UuY29tIn0.ESlOUZaVo4AqBKxEa-ihQDA9vp5kbZy3oholn9o4_Xg; userinfo={\"token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsYXN0TmFtZSI6InNpbmdoIiwiY3JlYXRlZERhdGUiOjE3NTM3Njc4NjEsImZpc3ROYW1lIjoibWFuaXNoIiwidW5vSWQiOiJVUjAwMDUyNTgyMiIsInVzZXJGaW5nZXJwcmludCI6IjYxRUEyMjdBMURBQTIwNjY1MDhEQzhGMjQzOUJBNTQzQUQ2MDNGRkNFRTQ0NkY1NDdEQjMzNzc5NjI2Qjg1RjUiLCJpc3MiOiJhdXRoMCIsInVzZXJUeXBlIjoiQiIsImV4cCI6MTc4NTMwMzg2MSwidXNlcklkIjoiMzk4MDgyIiwiZW1haWwiOiJtc2luZ2hAaHZhbnRhZ2UuY29tIn0.ESlOUZaVo4AqBKxEa-ihQDA9vp5kbZy3oholn9o4_Xg\",\"userId\":\"398082\",\"userName\":\"manish+singh\",\"onePass\":\"UR000525822\",\"email\":\"msingh@hvantage.com\",\"firstName\":\"manish\",\"lastName\":\"singh\",\"firstLogIn\":false,\"jobRole\":\"Technology\",\"company\":\"hvantage\",\"companyType\":\"FinTech\",\"country\":\"IN\",\"isLite\":false,\"loginFrom\":\"/\",\"hashedEmail\":\"49cd717cb2f54206768d2f12769a280d3309205a60b3bfc6e9156265d3206699\"}; _gcl_au=1.1.463668116.1753767884; loginStatus=Tue Jul 29 2025 11:14:43 GMT+0530 (India Standard Time); OptanonAlertBoxClosed=2025-07-29T05:44:43.837Z; isLoggedInHere=true; pardotLoginCookie=%7B%22date%22:%22Wed%20Jul%2029%202026%2011:16:58%20GMT+0530%20(India%20Standard%20Time)%22,%22newRegistration%22:%20%22false%22%7D; _gid=GA1.2.1352278789.1754564096; _ga_9CVGRV95TZ=GS2.1.s1754564124$o2$g0$t1754564127$j57$l0$h0; _ga=GA1.1.1919140755.1753767851; _ga_EQM54JZTNM=GS2.1.s1754564096$o1$g1$t1754564193$j49$l0$h0; _ga_ZTSZFS6N23=GS2.1.s1754564096$o1$g1$t1754564193$j49$l0$h0; bm_mi=1DBBB58CEC011D5AD98DF5628B94FA46~YAAQvDtAF81Wg1mYAQAAxd0ciBxSixm4KUrkAalGXCcDpKoqF3TrfEbIbVV8hMpuPt7MmswrrQ38AaKpWV0YiRkILqsQJCyA7XvhmOlW5J5OT4mJtr9zL9K9IR5y9cxKMCjjq7qzLq6pSoYiVXfVSueests4RgDBg1gUOT1p906FA/KxHP3tjj2rqJjSEq2cPgeBV04o1MGlzwL6Qan5CuZkC4/p9lBWzdUJbWZxqF1vWo9zyavcevBppRjMw8PJOIax9kxf7lfAqYEGoS8Fz2eWDjKY2g8Z0yIG1ahRW6vjTD1IVCL3I69zt4kepThm8u3aOH1Sh9hTnWxYI/7+mUJdMx7utIks53m/4r3l3MZ1dF9zOqLKVQpAdTL1cXifcaAwubg/QjuoA046TvREHKkMpM+62KEWkIgRdYj71W00DrwRhaRYHhK6z/yCtUxH2bPtqKAjE0AdnYaAmiG76MQk3gwoRdozTAAwvqFeKTQerNjVDAf24BoIxACp+4SrBIwhCdkuFcaHETS/TQ60/8SLyZ3OlqonwsLAvEgdsNf7Jg==~1; AKA_A2=A; _ga_K5RBZ8QKRC=GS2.1.s1754630248$o5$g1$t1754630253$j55$l0$h0; OptanonConsent=isGpcEnabled=0&datestamp=Fri+Aug+08+2025+10%3A47%3A34+GMT%2B0530+(India+Standard+Time)&version=202505.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=cb3f0f0f-bfe5-4ea3-868f-ddbbd61a8f68&interactionCount=3&isAnonUser=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0003%3A1%2CC0004%3A1&AwaitingReconsent=false&intType=1&geolocation=IN%3BMP; RT=\"z=1&dm=www.cmegroup.com&si=f665365c-a99c-45d6-b276-7b8f0067bdcb&ss=me2djn8d&sl=1&tt=35c&rl=1\"; ak_bmsc=DE655454A014F0679CC6D7C06A5BA49A~000000000000000000000000000000~YAAQvDtAF7pZg1mYAQAAt/QciBxMcoqghHdQyxW4W2Kk96V53z+GbzmqZ7fV+e9cRmcP5A+xdbMnDUzcJJXiPvAdJ8CI9k7lEWe+8wMF4bgAt/j8Y+P5E2WgchMy6P/fqHhJFbPzqFvR3jWIIqX1zzTbGaUkLdpiS01iHv/+hUOGvVez4cc8vR3fF7+X03SmASWaLCTe/Cq+YRmgKdDn2jWBEkrchiMq0LsVJfuUfyTpd3wlW9kzIZA1txfAaHKs5zQAIN1bJa5vvpoGE2O34iMA9Jq4ugz4YX8e/yLFP3N6Olmuj+M0TMN3/z3fg8cyHXYyO11hkGq2T0pWT7aBf/cFmUmMM3J3WYSJxwv2QaCa9TrNMkHWlZN8aGQyBiwa/tZxfFBEaJNAxNP9HRknbM7iwWcjHuW4oQ3ezfXC5b+j0XtJ+q7YgLMeWJA6CyamNZCkg6LmcX1aw4uv1Fw/oUI9gzywHpoLP7POq86dsPA/YWPkcW61iq1D/lWWX1qoDoZX0Rpgh3w1wMbjbOcINItp72lgudTNsk6M+Y9C+tcnbjmK9AJBd0VECmY5KgfLCphAMGNoND0KdXA9PmPQXgGskFSxqlvS/Z8PcNI134J1wBITCQM8ct2wMVyTQ6fmvYFKBUcqtaGskTYJWPFA/n/cExzMXH7R2oFlm2ZIGjaJOWiCukVS7uCXFStcDNjlXdc+6xkduzvwVQcE5VeSWtfnMZfUJhM3; _ga_L69G7D7MMN=GS2.1.s1754630250$o5$g1$t1754630255$j53$l0$h0; _lr_hb_-yvmlpa%2Fcme-group={%22heartbeat%22:1754630255893}; _lr_tabs_-yvmlpa%2Fcme-group={%22recordingID%22:%226-0198881c-e784-7b8c-885d-bceb67fcbf8e%22%2C%22sessionID%22:0%2C%22lastActivity%22:1754630256192%2C%22confirmed%22:true}; bm_sv=EE45A71B99C647AF9E46DC4144DE1AA6~YAAQvDtAF3Jbg1mYAQAAxAAdiBwY1dBog+QRQwCAzL4k9+fzCnh2JEhxHpLjJ50sPPJwsj2JQbwxWTDA9FiXJOZ+crC9rHoV/uG4sZ3Ro0rZKxUR104o4VU8awqy9gdibNZWQmzWMWKNOrdrJ/q2aghSEfcqdhXjXKUlASyrCLq+dML12s705C50BCAlpaVrircdmxmwQWMi+bd8F7bBmrF8pYI7eLn7foomYxlZ5SyI/+iET+Czya9yYshJ0x4hMYQr~1");


                        request.AutomaticDecompression = DecompressionMethods.GZip;
                        request.UseDefaultCredentials = true;
                        request.Timeout = 5000;
                        request.UserAgent = useragent;
                        request.Proxy.Credentials = System.Net.CredentialCache.DefaultCredentials;


                        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;

                        WebResponse response = request.GetResponse();
                        Log.WriteLogInfo(CRESEnums.Module.DailyRatePull.ToString(), "Got response from CME", "", useridforSys_Scheduler);
                        try
                        {
                            using (var reader = new StreamReader(response.GetResponseStream()))
                            {
                                Outputresponse = reader.ReadToEnd();
                                var CalcResponse = JObject.Parse(Outputresponse);
                                resultsStrip = CalcResponse["resultsStrip"][0] as JObject;
                                var sofrRatesFixingArray = CalcResponse["resultsStrip"][0]["rates"]["sofrRatesFixing"];

                                if (error == "")
                                {
                                    foreach (DataRow dr in dtconfig.Rows)
                                    {
                                        string url = dr["URL"].ToString();
                                        bool res = url.Contains("https://www.cmegroup.com/services/sofr-strip-rates/");

                                        if (res == true)
                                        {
                                            string dbindextype = dr["IndexType"].ToString();
                                            if (dbindextype == "1M Term SOFR")
                                            {
                                                CREIndexType = "1M";
                                            }
                                            else if (dbindextype == "3M Term SOFR")
                                            {
                                                CREIndexType = "3M";
                                            }
                                            else if (dbindextype == "SOFR")
                                            {
                                                CREIndexType = "SOFR";
                                            }
                                            if (CREIndexType == "SOFR")
                                            {
                                                //to read from lastest date 
                                                //CurrentDate = CommonHelper.ToDateTime(resultsStrip["date"]);                                          
                                                //CurrentPrice = resultsStrip["overnight"].ToString() == "-" ? 0 : CommonHelper.StringToDecimal(resultsStrip["overnight"]);

                                                var sofrRates = CalcResponse["resultsStrip"][1];
                                                CurrentDate = CommonHelper.ToDateTime(sofrRates["date"]);
                                                CurrentPrice = sofrRates["overnight"].ToString() == "-" ? 0 : CommonHelper.StringToDecimal(sofrRates["overnight"]);
                                            }
                                            else
                                            {
                                                foreach (JObject rate in sofrRatesFixingArray)
                                                {
                                                    var CurrentTerm = rate["term"].ToString();
                                                    if (CurrentTerm == CREIndexType)
                                                    {
                                                        CurrentPrice = CommonHelper.StringToDecimal(rate["price"]);
                                                        CurrentDate = CommonHelper.ToDateTime(rate["timestamp"]);
                                                        break;
                                                    }
                                                }
                                            }

                                            //dtindexes is used in data saving
                                            DataTable dtindexes = new DataTable();
                                            dtindexes.Columns.Add("Date");
                                            dtindexes.Columns.Add("Name");
                                            dtindexes.Columns.Add("Value");
                                            dtindexes.Columns.Add("IndexesMasterGuid");

                                            DataRow data1 = dtindexes.NewRow();
                                            data1["Date"] = CurrentDate;
                                            data1["Name"] = dr["IndexType"].ToString();
                                            data1["Value"] = CurrentPrice / 100;
                                            data1["IndexesMasterGuid"] = dr["IndexesMasterGuid"].ToString();
                                            dtindexes.Rows.Add(data1);

                                            //add data in import datatable for email
                                            DataRow rmport = dtimport.NewRow();
                                            rmport["Date"] = CurrentDate;
                                            rmport["Value"] = CurrentPrice;

                                            if (dbindextype == "SOFR")
                                            {
                                                rmport["IndexType"] = "Daily SOFR";
                                            }
                                            else
                                            {
                                                rmport["IndexType"] = dbindextype;
                                            }

                                            dtimport.Rows.Add(rmport);

                                            //save data for index in table
                                            IndexTypeRepository indexTypeRepository = new IndexTypeRepository();
                                            indexTypeRepository.AddUpdateIndexList(dtindexes, useridforSys_Scheduler, useridforSys_Scheduler);

                                            //Check Missing Data for sofr
                                            dtcopy = indexTypeRepository.InsertUpdateMissingIndexList(dr["IndexesMasterGuid"].ToString(), Convert.ToInt16(dr["IndexTypeID"]), useridforSys_Scheduler);
                                        }
                                    }
                                }
                                else
                                {
                                    Log.WriteLogExceptionMessage(CRESEnums.Module.DailyRatePull.ToString(), "CME Group Daily Rate:" + Outputresponse, "", useridforSys_Scheduler, "GetCMEGroupDailyRate", Outputresponse);
                                    _authenticationResult = new v1GenericResult()
                                    {
                                        Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                                        Succeeded = false,
                                        Message = returnMessage,
                                        ErrorDetails = Outputresponse
                                    };

                                    // _iEmailNotification.SendChathamFinancialDailyRateNotification("An error occurred in the daily SOFR pull from Chatham Financial. M61 systems team is looking for solution.", "Daily", "Fail");
                                }

                            }
                        }
                        catch (Exception ex)
                        {
                            error = "CME Data Pull";
                            Outputresponse = "CME Data Pull Error :" + ex.Message;
                        }
                    }
                }
                //code to import prime from chatham
                DataTable dt = GetChathamFinancialDailyRate(dtconfig);
                foreach (DataRow dr in dt.Rows)
                {
                    dtimport.ImportRow(dr);
                }
                //send email
                _iEmailNotification.SendChathamFinancialDailyRateNotificationSucces(dtimport, dtcopy, "CME Group And Chatham Financial");
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = returnMessage,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };

                Log.WriteLogException(CRESEnums.Module.DailyRatePull.ToString(), "Error occured in GetCMEGroupSofrRate ", "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                // _iEmailNotification.SendChathamFinancialDailyRateNotification("An error occurred in the daily CME Group rate pull.M61 systems team is looking for the solution.", "Daily", "Fail");
            }
            return Ok(_authenticationResult);
        }

        public DataTable GetChathamFinancialDailyRate(DataTable dtconfig)
        {
            decimal? Currentrate = 0;
            DateTime? CurrentDate = DateTime.MinValue;
            string Outputresponse = "";
            string ApiConstantUrl = "";
            string error = "";

            LoggerLogic Log = new LoggerLogic();

            DataTable dtimport = new DataTable();
            dtimport.Columns.Add("Date");
            dtimport.Columns.Add("Value");
            dtimport.Columns.Add("IndexType");

            try
            {
                Log.WriteLogInfo(CRESEnums.Module.DailyRatePull.ToString(), "Chatham Financial Daily Rate Api called ", "", useridforSys_Scheduler);
                //ChathamFinancialLogic ChathamLogic = new ChathamFinancialLogic();
                //DataTable dtconfig = ChathamLogic.GetChathamConfig("DailyRate");

                foreach (DataRow dr in dtconfig.Rows)
                {
                    string url = dr["URL"].ToString();
                    bool reschatam = url.Contains("https://www.chathamfinancial.com/getrates/");
                    if (reschatam == true)
                    {
                        ApiConstantUrl = dr["URL"].ToString() + dr["RatesCode"].ToString();
                        System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                        using (var client = new HttpClient())
                        {
                            client.Timeout = TimeSpan.FromMinutes(10);
                            var res = client.GetAsync(ApiConstantUrl);
                            try
                            {
                                HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                                if (response1.IsSuccessStatusCode)
                                {
                                    Outputresponse = response1.Content.ReadAsStringAsync().Result;
                                    var CalcResponse = JObject.Parse(Outputresponse);

                                    if (dr["Description"].ToString() == "5 Year Treasury" || dr["Description"].ToString() == "10 Year Treasury")
                                    {
                                        string trimstring = dr["Description"].ToString();
                                        string result = trimstring.Replace("Treasury", "").Trim();

                                        dynamic stuff = JsonConvert.DeserializeObject(Outputresponse);
                                        var Rates = stuff["Rates"];
                                        for (var i = 0; i < Rates.Count; i++)
                                        {
                                            if (Convert.ToString(Rates[i].Year) == result)
                                            {
                                                Currentrate = CommonHelper.StringToDecimal(Rates[i].PreviousDayYield) / 100;
                                                CurrentDate = CommonHelper.ToDateTime(CalcResponse["PreviousDayDate"]);
                                            }
                                        }

                                    }
                                    else
                                    {
                                        Currentrate = CommonHelper.StringToDecimal(CalcResponse["PreviousDay"]) / 100;
                                        CurrentDate = CommonHelper.ToDateTime(CalcResponse["CurrentDate"]);
                                    }



                                }
                            }
                            catch (Exception e)
                            {
                                error = "Chatham Financial Error";
                                Outputresponse = "Chatham Financial Error :" + e.Message;
                            }
                        }

                        if (error == "")
                        {
                            DataTable dtindexes = new DataTable();
                            dtindexes.Columns.Add("Date");
                            dtindexes.Columns.Add("Name");
                            dtindexes.Columns.Add("Value");
                            dtindexes.Columns.Add("IndexesMasterGuid");

                            DataRow data1 = dtindexes.NewRow();
                            data1["Date"] = CurrentDate;

                            data1["Name"] = dr["IndexType"].ToString();

                            data1["Value"] = Currentrate;
                            data1["IndexesMasterGuid"] = dr["IndexesMasterGuid"].ToString();
                            dtindexes.Rows.Add(data1);

                            //add data in import datatable for email
                            DataRow rmport = dtimport.NewRow();
                            rmport["Date"] = CurrentDate;

                            if (dr["IndexType"].ToString() == "SOFR")
                            {
                                rmport["IndexType"] = "Daily SOFR";
                            }
                            else
                            {
                                rmport["IndexType"] = dr["IndexType"].ToString();
                            }
                            rmport["Value"] = Currentrate * 100;
                            dtimport.Rows.Add(rmport);

                            //save data for index in table
                            IndexTypeRepository indexTypeRepository = new IndexTypeRepository();
                            indexTypeRepository.AddUpdateIndexList(dtindexes, useridforSys_Scheduler, useridforSys_Scheduler);

                            //Check Missing Data for sofr
                            indexTypeRepository.InsertUpdateMissingIndexList(dr["IndexesMasterGuid"].ToString(), Convert.ToInt16(dr["IndexTypeID"]), useridforSys_Scheduler);

                        }
                        else
                        {
                            Log.WriteLogExceptionMessage(CRESEnums.Module.DailyRatePull.ToString(), "Chatham Financial Daily Rate:" + Outputresponse, "", useridforSys_Scheduler, "GetChathamFinancialDailyRate", Outputresponse);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Log.WriteLogException(CRESEnums.Module.DailyRatePull.ToString(), "Error occured in GetChathamFinancialDailyRate ", "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
            }
            return dtimport;
        }

        [HttpGet]
        [Route("api/ratepull/CheckPull")]
        public void CheckPull()
        {
            ChathamFinancialLogic ChathamLogic = new ChathamFinancialLogic();
            DataTable dtconfig = ChathamLogic.GetChathamConfig("DailyRate");
            GetChathamFinancialDailyRate(dtconfig);

        }


        [HttpGet]
        [Route("api/importdailysofrrate/ImportDailySofrRateFromApi")]
        public IActionResult ImportDailySofrRateFromApi()
        {
            
            decimal? CurrentPrice = 0;
            JObject resultsStrip = new JObject();

            decimal? Overnight = 0;
            DateTime? CurrentDate = DateTime.MinValue;
            string CREIndexType = "";
            string Outputresponse = "";

            string error = "";
            string returnMessage = "";

            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();

            DataTable dtimport = new DataTable();
            dtimport.Columns.Add("Date");
            dtimport.Columns.Add("Value");
            dtimport.Columns.Add("IndexType");
            DataTable dtcopy = new DataTable();
            DataTable dtconfig = new DataTable();

            try
            {
                Log.WriteLogInfo(CRESEnums.Module.DailyRatePull.ToString(), "Daily Rate Api called ", "", useridforSys_Scheduler);

                ChathamFinancialLogic ChathamLogic = new ChathamFinancialLogic();
                dtconfig = ChathamLogic.GetChathamConfig("DailyRate");
                
                //code to import prime from chatham
                DataTable dt = GetChathamFinancialDailyRate(dtconfig);
                foreach (DataRow dr in dt.Rows)
                {
                    dtimport.ImportRow(dr);
                }
                //send email
                _iEmailNotification.SendChathamFinancialDailyRateNotificationSucces(dtimport, dtcopy, "CME Group And Chatham Financial");
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = returnMessage,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };

                Log.WriteLogException(CRESEnums.Module.DailyRatePull.ToString(), "Error occured in GetCMEGroupSofrRate ", "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                 _iEmailNotification.SendChathamFinancialDailyRateNotification("An error occurred in the daily rate pull.M61 systems team is looking for the solution.", "Daily", "Fail");
            }
            return Ok(_authenticationResult);
        }

    }
}
