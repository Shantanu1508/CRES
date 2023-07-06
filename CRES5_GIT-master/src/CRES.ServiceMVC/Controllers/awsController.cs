using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.Services.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
#pragma warning disable CS0105 // The using directive for 'CRES.BusinessLogic' appeared previously in this namespace
#pragma warning restore CS0105 // The using directive for 'CRES.BusinessLogic' appeared previously in this namespace

namespace CRES.Services.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class awsController : ControllerBase
    {
        AWSS3Operations objaws = new AWSS3Operations();

        [HttpGet]
        [Route("api/aws/getFile")]
        public IActionResult getObjectByFile(string ID)
        {
            MemoryStream objMemory = objaws.ReadDataObjectMemory(ID);

            var result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ByteArrayContent(objMemory.ToArray())
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");

            return new FileContentResult(objMemory.ToArray(), "application/octet-stream");
        }

        [HttpGet]
        [Route("api/aws/clone")]
        public IActionResult cloneFolder(string ID, string IDDest)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {

                var result = objaws.CopyTo(ID, IDDest);
                if (result == null)
                    return BadRequest("Failed");

                else
                    return Ok("Success");
            }
            catch (System.Exception ex)
            {
                return BadRequest("Failed");
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        [HttpPost]
        [Route("api/aws/updateFile")]
        public IActionResult UpdateFileAws([FromBody] FileDetail parameters)
        {
            string fileName = "", fileContent = "";
            //var queryString = Request.RequestUri.ParseQueryString();
            //if (queryString["fileName"] != null && queryString["fileContent"] != null)
            //{
            //    fileName = queryString["fileName"];
            //    fileContent = queryString["fileContent"];
            //}

            if (HttpContext.Request.Query["fileName"] != "" && HttpContext.Request.Query["fileContent"] != "")
            {
                fileName = HttpContext.Request.Query["fileName"];
                fileContent = HttpContext.Request.Query["fileContent"];
            }

            objaws.WriteAnObject(parameters.FileName, parameters.FileContent);
            return Ok("Success");
        }

        [HttpPost]
        [Route("api/aws/updateFileFunction")]
        public IActionResult UpdateFileFunctionAws([FromBody] FileDetail parameters)
        {
            string s = HttpContext.Request.Query[""].ToString();
            string fileName = "", fileContent = "";
            //var queryString = Request.RequestUri.ParseQueryString();

            //if (queryString["fileName"] != null && queryString["fileContent"] != null)
            //{
            //    fileName = queryString["fileName"];
            //    fileContent = queryString["fileContent"];
            //}
            if (HttpContext.Request.Query["fileName"] != "" && HttpContext.Request.Query["fileContent"] != "")
            {
                fileName = HttpContext.Request.Query["fileName"];
                fileContent = HttpContext.Request.Query["fileContent"];
            }

            objaws.WriteAnObject(parameters.FileName, parameters.FileContent);

            //update function default vlaue
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            FastFunctionDataContract _ffDc = new FastFunctionDataContract
            {
                FunctionName = parameters.FunctionName,
                FunctionType = 2,
                CreatedBy = headerUserID.ToString(),
                IsDefault = parameters.IsDefault
            };
            UpdateFunction(_ffDc);
            //

            return Ok("Success");
        }

        [HttpGet]
        [Route("api/aws/getfolders")]
        public IActionResult getAwsListFolders()
        {
            List<string> items = objaws.getListFolder();
            return Ok(items);
        }
        [HttpGet]
        [Route("api/aws/getfilesbyfolder")]
        public IActionResult getAwsListFileByFolder(string ID)
        {
            List<string> items = objaws.ListObjects(ID);
            return Ok(items);
        }

        [HttpGet]
        [Route("api/aws/createzip")]
        public IActionResult awsCreateZip(string ID)
        {
            objaws.zip(ID);
            return Ok("Success");
        }

        [HttpPost]
        [Route("api/aws/createFunction")]
        //public IActionResult awsCreateFunction(string ID, string IDDest)
        public IActionResult awsCreateFunction([FromBody] FunctionDetail parameters)

        {
            string zipFile;
            Boolean isSuccess = false;



            //copy folder
            var result = objaws.CopyTo(parameters.SourceName, parameters.DestName);
            if (result != null)
            {
                //Created zip
                zipFile = objaws.zip(parameters.DestName);
                if (!string.IsNullOrEmpty(zipFile))
                {
                    isSuccess = objaws.CreateFunction(parameters.DestName, parameters.DestName + "/" + zipFile);
                    objaws.DeleteAllZipFile(parameters.DestName);

                    if (isSuccess)
                    {
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
                        IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
                        var headerUserID = new Guid();

                        if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                        {
                            headerUserID = new Guid(Request.Headers["TokenUId"]);
                        }

                        FastFunctionLogic ffLogic = new FastFunctionLogic();
                        FastFunctionDataContract _ffDc = new FastFunctionDataContract
                        {
                            FunctionName = parameters.DestName,
                            FunctionType = 1,
                            CreatedBy = headerUserID.ToString(),
                            IsDefault = parameters.IsDefault
                        };

                        ffLogic.InsertUpdateFastFunction(_ffDc);
                    }
                }
            }


            if (!isSuccess)
            {
                return BadRequest("Failed");

            }
            return Ok("Success");
        }


        [HttpPost]
        [Route("api/aws/updatefunction")]
        //public IActionResult awsCreateFunction(string ID, string IDDest)
        public IActionResult awsUpdateFunction([FromBody] FunctionDetail parameters)
        {
            var zipFile = objaws.zip(parameters.SourceName);
            string zipfile = objaws.GetZipFileByFolder(parameters.SourceName);

            bool isSuccess = false;
            isSuccess = objaws.UpdateFunction(parameters.SourceName, zipfile);
            objaws.DeleteAllZipFile(parameters.SourceName);

            if (isSuccess)
            {
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
                IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
                var headerUserID = new Guid();

                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = new Guid(Request.Headers["TokenUId"]);
                }

                FastFunctionLogic ffLogic = new FastFunctionLogic();
                FastFunctionDataContract _ffDc = new FastFunctionDataContract
                {
                    FunctionName = parameters.SourceName,
                    FunctionType = 2,
                    CreatedBy = headerUserID.ToString(),
                    IsDefault = parameters.IsDefault
                };

                ffLogic.InsertUpdateFastFunction(_ffDc);
            }

            if (!isSuccess)
                return BadRequest("Failed");
            return Ok("Success");
        }

        //[HttpGet]
        //[Route("api/aws/invokefunction")]
        //public IActionResult awsInvokeFunction(string ID, string IDDest)
        //{
        //    //get zip file of selected folder
        //    bool isSuccess = false;
        //    string result = "";
        //    string payLoad = "{\"JsonData\" : {\"Deal\": {\"size\": \"44200000.00\",\"name\": \"StewModelTieout\",\"description\": \"Stew Model Tie Out 20160718 excel file\",\"id\": \"12341234\", \"issueDate\": \"20161020\",\"settlementDate\": \"20161020\",\"firstPayDate\": \"20161108\", \"calculationFrequency\": \"dynamic\", \"calculateDeal\": \"dealSimStandard\"         },        \"Notes\": [{    \"name\": \"A\",    \"type\": \"Note\",    \"description\": \"A Note\",    \"id\": \"11115\",    \"InitialFundingAmount\": 17100000.00,     \"balanceTarget\": 22100000.00,     \"paymentFrequency\": \"monthly\",    \"dayCount\": \"30360\",     \"rateType\": \"floating\",    \"rateIndex\": \"L30\",     \"spreadCash\": 0.025,    \"spreadMaintain\": 0.025,    \"amRate\": 0.052,    \"amTerm\": 360,    \"ioTerm\": 36,    \"loanTerm\": 60,    \"stubAdvance\": \"true\",    \"originationFee\": 0.01,    \"exitFee\": 0.01,    \"extensionFee\": 0.01,    \"extensionTerm\": 18,    \"minimumFee\": 0.01,    \"additionalPik\": 0,    \"maturityDate\":\"20220120\",    \"closingDate\": \"20170120\",    \"registers\": [\"eopBal\", \"principal\", \"interest\"],    \"calculateAccount\": \"loanSimStandard\",    \"settlementDate\":\"20170123\",    \"PayFrequency\":\"M\"            }        ],        \"Accounts\" :[{    \"name\": \"EQUITYACORE\",    \"type\": \"Entity\",    \"description\": \"ACORE Lender Account\",    \"id\": \"21115\",    \"balanceInit\": 0,    \"registers\": [\"cash\"]            },            {    \"name\": \"EQUITYDELPHI\",    \"type\": \"Entity\",    \"description\": \"DELPHI Lender Account\",    \"id\": \"21116\",    \"balanceInit\": 0,    \"registers\": [\"cash\"]},{    \"name\": \"BORROWERCASH\",    \"type\": \"Entity\",    \"description\": \"Borrower Account\",    \"id\": \"21117\",    \"balanceInit\": 0,    \"registers\": [\"cash\"]}],        \"variables\": [{    \"arbitrary2DArrayxxxxx\": [        [0, 10],        [30, 50],        [90, 100]    ]},{    \"asOfDate\": \"20160901\"}        ],        \"Rules\": [{       \"Name\" : \"1\",    \"description\": \"Transfer $1038483 from Note 123 to Entity 232043 on Settlement Date of Note 123\",    \"when\": {    \"condition\": \"Period\",    \"conditionParameters\": {        \"type\": \"Note\",        \"id\": \"11115\",        \"attribute\": \"settlementDate\"    }    },    \"action\": {    \"Name\": \"Transfer\",    \"actionParameters\": {        \"Amount\": \"1038483\",        \"From\": {        \"type\": \"Note\",        \"id\": \"11115\"        },        \"To\": {        \"type\": \"Entity\",        \"id\": \"21115\"}    }    },    \"priority\": \"6\"},{    \"Name\" : \"2\",    \"description\": \"Calculate Note 123 for every period\",    \"when\": \"\",    \"action\": {    \"actionHandler\": \"Note\",    \"Name\": \"Calculate\",    \"actionParameters\": {\"type\": \"Note\",\"id\": \"11115\"    }    },    \"priority\": \"5\"}]    }}";
        //    result = objaws.InvokeFunction(ID,"", IDDest);
        //    return Ok(result);
        //}

        [HttpPost]
        [Route("api/aws/invokefunction")]
        public IActionResult awsInvokeFunction([FromBody] InvokeDetail parameters)
        {
            //get zip file of selected folder
            //bool isSuccess = false;
            string result = string.Empty;
            IActionResult res = null;
            //parameters.PlayLoad = Encoding.Default.GetString(objaws.ReadDataObjectMemory(parameters.FunctionName + "/InputJson.py").ToArray());
            //var json = File.ReadAllText(System.Web.HttpContext.Current.Server.MapPath("~/inputjson.json"));
            parameters.PlayLoad = parameters.PlayLoad.Replace("\r\n", "").Replace("JsonData = ", "");
            result = objaws.InvokeFunction(parameters.FunctionName, "", parameters.PlayLoad);

            if (!string.IsNullOrEmpty(result))
            {
                var headerUserID = string.Empty;

                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                }

                res = InsertNotePeriodicCalcDynamicColumns(Path.GetFileName(result), headerUserID);
                if (res != Ok())
                    BadRequest("Error inserting note periodic output");
            }
            else
            {
                return BadRequest("Error in invoking lamda function " + parameters.FunctionName);

            }


            return Ok("");
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/aws/getallFastFunction")]
        public IActionResult GetAllFastFunction()
        {

            List<FastFunctionDataContract> result = new List<FastFunctionDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            FastFunctionLogic ffLogic = new FastFunctionLogic();
            result = ffLogic.GetAllFastFunction();

            return Ok(result);
        }


        public void UpdateFunction(FastFunctionDataContract _ffDc)
        {
            if (_ffDc != null)
            {
                FastFunctionLogic ffLogic = new FastFunctionLogic();
                ffLogic.InsertUpdateFastFunction(_ffDc);
            }
        }

        [HttpGet]
        [Route("api/aws/NotePeriodicCalcDynamicColumns")]
        public IActionResult InsertNotePeriodicCalcDynamicColumns(string fileName, string userid)
        {
            // bulk insert

            try
            {

                string json = objaws.ReadDataObject("scriptengine-output", fileName);

                var t = JsonConvert.DeserializeObject<NotePeriodicCalcDynamicColumns>(json);
                string NoteiDs = string.Join(",", t.Transaction.Note.Select(c => c.Id).ToArray());
                string ColumnNames = "NotePeriodicCalcID,NoteID,PeriodEndDate,CreatedBy,UpdatedBy," + string.Join(",", t.Transaction.Output);

                //insert dynamic columns in the table
                FastFunctionLogic ffLogic = new FastFunctionLogic();
                ffLogic.InsertNotePeriodicCalcDynamicColumn(ColumnNames, NoteiDs, "");

                //create datatable with dynamic column
                var table = new DataTable();
                table.Columns.Add("NotePeriodicCalcID", System.Type.GetType("System.Guid"));
                table.Columns.Add("NoteID", System.Type.GetType("System.Guid"));
                table.Columns.Add("PeriodEndDate", System.Type.GetType("System.DateTime"));
                table.Columns.Add("CreatedBy", System.Type.GetType("System.String"));
                table.Columns.Add("UpdatedBy", System.Type.GetType("System.String"));

                foreach (var item in t.Transaction.Output)
                {
                    table.Columns.Add(item, System.Type.GetType("System.Decimal"));
                }

                //insert data in to datatable
                foreach (var note in t.Transaction.Note)
                {
                    int icount = 0;
                    int startIndex = t.Transaction.Date.ToList().IndexOf(note.ClosingDate);
                    int endIndex = note.Output.Count();
                    var lstDate = t.Transaction.Date.Skip(startIndex).Take(endIndex - startIndex);

                    foreach (var d in lstDate)
                    {
                        DataRow dr = table.NewRow();
                        dr["NotePeriodicCalcID"] = Guid.NewGuid().ToString();
                        dr["NoteID"] = note.Id;
                        dr["PeriodEndDate"] = d;
                        dr["CreatedBy"] = userid;
                        dr["UpdatedBy"] = userid;
                        for (var k = 0; k < t.Transaction.Output.Count(); k++)
                        {
                            dr[t.Transaction.Output[k]] = note.Output[icount][k];
                        }
                        table.Rows.Add(dr);
                        icount += 1;
                    }

                }

                //bulk insert
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LoggingInDB"].ConnectionString;
                using (var bulk = new SqlBulkCopy(connectionString))
                {
                    bulk.DestinationTableName = "NotePeriodicCalcTest";
                    foreach (var item in ColumnNames.Split(','))
                    {
                        bulk.ColumnMappings.Add(item, item);
                    }
                    bulk.WriteToServer(table);
                }
                return Ok("");
            }
            catch (Exception ex)
            {
                string exc = ex.Message;
                return BadRequest(exc);
            }


            /*
             // traditional insert
             try
             {
                 //var json = File.ReadAllText(System.Web.HttpContext.Current.Server.MapPath("~/FastJsonOutPut.json"));
                 //string json = objaws.ReadDataObject("scriptengine-output", "65a00eb3-b64f-11e8-8bbd-8591b6046e91.json");
                 string json = objaws.ReadDataObject("scriptengine-output", fileName);

                 var t = JsonConvert.DeserializeObject<NotePeriodicCalcDynamicColumns>(json);

                 string NoteiDs = string.Join(",", t.Transaction.Note.Select(c => c.Id).ToArray());
                 string ColumnNames = "NotePeriodicCalcID,PeriodEndDate,NoteID," + string.Join(",", t.Transaction.Output);
                 string str = "insert into NotePeriodicCalcTest (" + ColumnNames + ") values";

                 StringBuilder sb = new StringBuilder();
                 foreach (var note in t.Transaction.Note)
                 {
                     int icount = 0;
                     int startIndex = t.Transaction.Date.ToList().IndexOf(note.ClosingDate);
                     int endIndex = note.Output.Count();
                     var lstDate = t.Transaction.Date.Skip(startIndex).Take(endIndex - startIndex);
                     foreach (var date in lstDate)
                     {

                         sb.Append(str + " ('" + Guid.NewGuid() + "','" + date.ToString() + "', '"+note.Id+"'");

                         for (var k = 0; k < t.Transaction.Output.Count(); k++)
                         {
                             sb.Append("," + note.Output[icount][k] + "");
                         }

                         icount += 1;
                         sb.Append(")");
                         sb.Append(Environment.NewLine);
                     }
                 }
                 string finalStr = sb.ToString();
                 FastFunctionLogic ffLogic = new FastFunctionLogic();

                 //temp increate records-10 times of json
                 //string testing1 = "";
                 //for (int i = 0; i <= 9; i++)
                 //{
                 //    testing1 += sb.ToString();
                 //}
                 ffLogic.InsertNotePeriodicCalcDynamicColumn(ColumnNames, NoteiDs, finalStr);

                 //ffLogic.InsertNotePeriodicCalcDynamicColumn(ColumnNames, NoteiDs, finalStr);

                 return Ok("");
             }
             catch (Exception ex)
             {
                 string exc = ex.Message;
                 return Request.CreateResponse(HttpStatusCode.ExpectationFailed, exc);
             }

             */
        }
    }

    public class FileDetail
    {
        public string FileName { get; set; }
        public string FileContent { get; set; }
        public string FunctionName { get; set; }
        public bool IsDefault { get; set; }

    }

    public class InvokeDetail
    {
        public string FunctionName { get; set; }
        public string PlayLoad { get; set; }
    }

    public class FunctionDetail
    {
        public string SourceName { get; set; }
        public string DestName { get; set; }
        public bool IsDefault { get; set; }
    }

    public partial class NotePeriodicCalcDynamicColumns
    {
        [JsonProperty("Transaction")]
        public Transaction Transaction { get; set; }
    }

    public partial class Transaction
    {
        [JsonProperty("Note")]
        public Note[] Note { get; set; }

        [JsonProperty("Deal")]
        public Deal Deal { get; set; }

        [JsonProperty("Date")]
        public string[] Date { get; set; }

        [JsonProperty("Output")]
        public string[] Output { get; set; }
    }

    public partial class Deal
    {
        [JsonProperty("DealName")]
        public string DealName { get; set; }

        [JsonProperty("CREDealID")]
        public string CreDealId { get; set; }
    }

    public partial class Note
    {
        [JsonProperty("ID")]
        public string Id { get; set; }

        [JsonProperty("Output")]
        public double[][] Output { get; set; }

        [JsonProperty("ClosingDate")]
        public string ClosingDate { get; set; }
    }

}