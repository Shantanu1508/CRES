using Microsoft.AspNetCore.Mvc;
using CRES.BusinessLogic;
using System.Collections.Generic;
using CRES.DataContract;
using CRES.DataContract.Liability;
using System.Linq;
using System.Dynamic;
using System.Threading.Tasks;
using CRES.NoteCalculator;
using Newtonsoft.Json;
using System;
using CRES.Utilities;
using Syncfusion.Compression;
using System.Data;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.Extensions.Configuration;
using ExcelDataReader;
using Microsoft.WindowsAzure.Storage;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class LiabilityCalcController : ControllerBase
    {

        private IHostingEnvironment _env;
        public LiabilityCalcController(IHostingEnvironment env)
        {
            _env = env;
        }

        IConfigurationSection Sectionroot = null;
        static IConfigurationSection SectionrootStatic = null;
        public string connectionString = "";
        public string sourceContainerName = "";

        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/liabilitycalc/getliabilitycalcrequest")]
        public IActionResult GetLiabilityCalcRequest(string fundIDorName, string analysisID)
        {
            LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
            List<JsonFormatCalcLiability> JFormatCalcLiability = new List<JsonFormatCalcLiability>();
            if (analysisID == null)
            {
                analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            }
            //get data from db and create json
            dynamic objJsonResult = lblogic.GetLiabilityCalcRequestData("", fundIDorName, analysisID);
            return Ok(objJsonResult);
        }


        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/liabilitycalc/calcequitynotes")]
        public IActionResult CalcEquityNotes()
        {
            LoggerLogic Log = new LoggerLogic();
            try
            {
                //FeeCalculator 935
                //BalanceCalculator 910
                //FeeInterestCalculator  911
                LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
                V1CalcLogic v1ogic = new V1CalcLogic();

                List<EquityCalcDataContract> lstEqity = new List<EquityCalcDataContract>();
                lstEqity = lblogic.GetEquityForCalculation();
                if (lstEqity != null || lstEqity.Count > 0)
                {
                    Parallel.ForEach(lstEqity, new ParallelOptions { MaxDegreeOfParallelism = 5 },
                        (item, state) =>
                        {
                            if (item.CalculationModeID == 797) //c#
                            {
                                ProcessCalcEquityNotes(item);
                            }
                            else if (item.CalculationModeID == 798)
                            {
                                if (item.CalcType == 911)
                                {
                                    //interest calc request
                                    v1ogic.SubmitCalcRequestForFeeInterest(item); //v1
                                }
                                else if (item.CalcType == 935)
                                {
                                    //fee calc request
                                    v1ogic.SubmitCalcRequestForFee(item); //v1
                                }

                            }
                        }
                     );
                }

                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status200OK, "Calc request submited successfully");
            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                Log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in CalcEquityNotes :" + message, "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError, "InternalServerError");
            }

        }
        public string ProcessCalcEquityNotes(EquityCalcDataContract eqDc)
        {
            string status = "";
            LoggerLogic Log = new LoggerLogic();
            LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
            GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
            try
            {
                //put equity in running state          
                lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Running", "StartTime", "","", eqDc.CalculationModeID);
                //get data from db and create json
                dynamic objJsonResult = lblogic.GetLiabilityCalcRequestData("", eqDc.AccountID, eqDc.AnalysisID);
                //string objJsonResult = lblogic.readstring();
                status = "Data Loaded.";

                if (objJsonResult != null)
                {
                    try
                    {
                        //call calculator code to process the eqity notes 
                        LiabilityCashflowManager lcm = new LiabilityCashflowManager();
                        LiabilityCFOutput cf = lcm.GenerateLiabilityCashflow(objJsonResult);
                        status = "Calculated";

                        if (cf != null && cf.CalculatorExceptionMessage == "Cashflow generated successfully!")
                        {
                            // save result to trasaction entry    
                            lblogic.InsertLiabilityNoteTransaction(cf.LiabilityNoteTransactions, eqDc.UserName);
                            lblogic.InsertTransactionEntryLiabilityLine(cf.LiabilityLineTransactions, eqDc.UserName);

                            //uncomment this line for testing 
                            //ObjToCsv.CreateCSVFile(ToDataSet(cf.LiabilityLineTransactions).Tables[0], "LiabilityLineTransactions");
                            //ObjToCsv.CreateCSVFile(ToDataSet(cf.LiabilityNoteTransactions).Tables[0], "LiabilityNoteTransactions");
                            
                            //MemoryStream excelStream = ExportToExcel(ToDataSet(cf.LiabilityLineTransactions).Tables[0], ToDataSet(cf.LiabilityNoteTransactions).Tables[0]);
                            //string filename = "LiabilityTransactions_" + DateTime.Now.ToString("MM_dd_yyyy_HH_mm_ss") + ".xlsx";
                            //bool result = UploadLiabilityTransactionsExcelFileToAzureBlob(excelStream, filename);
                            //lblogic.UpdateLiabilityTransactionFileName(eqDc.AutomationRequestsID, filename);

                            lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Completed", "EndTime", "", "", eqDc.CalculationModeID);
                            status = "calculated data saved.";
                        }
                        else
                        {
                            status = "Error in Calculation "  + cf.CalculatorStackTrace;
                            lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID,"Failed", "EndTime", cf.CalculatorExceptionMessage, "", eqDc.CalculationModeID);                            
                            Log.WriteLogExceptionMessage(CRESEnums.Module.EquityCalculator.ToString(), "Error in Calculation in ProcessCalcEquityNotes note:: Note ID " + " " + cf.CalculatorStackTrace, eqDc.AccountID, useridforSys_Scheduler, "StartCalculation", cf.CalculatorExceptionMessage);
                        }
                    }
                    catch (Exception ex)
                    {
                        status = "Error in Calculation.";
                        lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime","Error in Calulation :" + ex.Message, "", eqDc.CalculationModeID);
                        string message = ExceptionHelper.GetFullMessage(ex);
                        status = "Error in Calculation " + message;
                        Log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in ProcessCalcEquityNotes :" + message, eqDc.AccountID, useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                    }

                }
                else
                {
                    status = "Error in generating Json.";
                    lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime","Error in generating Json", "", eqDc.CalculationModeID);
                    Log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in generating Json : " + eqDc.AccountID, useridforSys_Scheduler, "ProcessCalcEquityNotes");
                }
            }
            catch (Exception ex)
            {

                lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime","Error in generating Json" + ex.StackTrace, "", eqDc.CalculationModeID);
                string message = ExceptionHelper.GetFullMessage(ex);
                status = "Error in Calculation " + message;
                Log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in ProcessCalcEquityNotes :" + message, eqDc.AccountID, useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
            }

            return status;
        }

        [HttpGet]
        [Route("api/liabilitycalc/queueAllEquityForCalculation")]
        public IActionResult QueueAllEquityForCalculation()
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();
            int dealcount = 0;
            try
            {
                GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                LiabilityCalcLogic LiabilityCalcLogic = new LiabilityCalcLogic();
                List<GenerateAutomationDataContract> list = LiabilityCalcLogic.GetLiabilitListForCalculation("LiabilityCalculation");
                if (list != null && list.Count > 0)
                {
                    dealcount = list.Count;
                    GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.EquityCalculator.ToString(), "LiabilityCalculation ended for " + dealcount + " Deals", "", "");
                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.EquityCalculator.ToString(), "LiabilityCalculation no record found ", "", "");
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Succeeded LiabilityCalculation for deals " + dealcount,
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.EquityCalculator.ToString(), ex.StackTrace, "", "", "LiabilityCalculation", "Error occurred " + " " + ex.Message);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        //CheckProcess
        [HttpGet]
        [Route("api/liabilitycalc/CheckProcess")]
        public IActionResult CheckAutomation(string LiabilityAccountID)
        {
            v1GenericResult _authenticationResult = null;
            try
            {
                EquityCalcDataContract eqDc = new EquityCalcDataContract();
                eqDc.AnalysisID = "c10f3372-0fc2-4861-a9f5-148f1f80804f";
                eqDc.AccountID = LiabilityAccountID;
                eqDc.AutomationRequestsID = 100;
                eqDc.UserName = "76226bcd-6051-402e-a2c4-ed8e52180b86";
               string status= ProcessCalcEquityNotes(eqDc);

                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = status,
                    ErrorDetails = ""
                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error contact administrator",
                    ErrorDetails = ex.Message
                };

            }
            return Ok(_authenticationResult);
        }

        public static DataSet ToDataSet<T>(IEnumerable<T> list)
        {
            Type elementType = typeof(T);
            DataSet ds = new DataSet();
            System.Data.DataTable t = new System.Data.DataTable();
            ds.Tables.Add(t);

            //add a column to table for each public property on T
            foreach (var propInfo in elementType.GetProperties())
            {
                t.Columns.Add(propInfo.Name);
            }

            //go through each property on T and add each value to the table
            foreach (T item in list)
            {
                DataRow row = t.NewRow();
                foreach (var propInfo in elementType.GetProperties())
                {
                    row[propInfo.Name] = propInfo.GetValue(item, null);
                }

                //This line was missing:
                t.Rows.Add(row);
            }

            return ds;
        }

        public MemoryStream ExportToExcel(DataTable liabilityLineTransactions, DataTable liabilityNoteTransactions)
        {
            DataSet ds = new DataSet();

            liabilityLineTransactions.TableName = "LiabilityLineTransactions";
            ds.Tables.Add(liabilityLineTransactions.Copy());

            liabilityNoteTransactions.TableName = "LiabilityNoteTransactions";
            ds.Tables.Add(liabilityNoteTransactions.Copy());

            Stream templateStream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "LiabilityTransactions.xlsx").BaseStream;

            MemoryStream ms = WriteDataToExcel.DataSetToExcel(ds, templateStream);
            return ms;
        }

        public static Boolean UploadLiabilityTransactionsExcelFileToAzureBlob(MemoryStream stream, string FileName)
        {
            try
            {
                GetConfigSettingforStatic();
                var Container = SectionrootStatic.GetSection("storage:container:name").Value;
                var connectionString = SectionrootStatic.GetSection("storage:container:connectionstring").Value;

                // Get Blob Container
                CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);
                CloudBlobDirectory blobDirectory = container.GetDirectoryReference("LiabilityOutput");
                CloudBlockBlob blockBlob = blobDirectory.GetBlockBlobReference(FileName);

                stream.Position = 0;
                blockBlob.UploadFromStream(stream);

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static void GetConfigSettingforStatic()
        {
            if (SectionrootStatic == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                SectionrootStatic = root.GetSection("Application");
            }
        }


        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/liabilitycalc/getliabilitycalcrequestforfeeinterest")]
        public IActionResult GetLiabilityCalcRequestForFeesAndInterest(string fundIDorName, string analysisID)
        {
            LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
            List<JsonFormatCalcLiability> JFormatCalcLiability = new List<JsonFormatCalcLiability>();
            if (analysisID == null)
            {
                analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            }
            //get data from db and create json
            dynamic objJsonResult = lblogic.GetLiabilityCalcRequestForFeesAndInterest("", fundIDorName, analysisID);
            return Ok(objJsonResult);
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/liabilitycalc/getliabilitycalcrequestforfee")]
        //GetLiabilityCalcRequestForFees
        public IActionResult GetLiabilityCalcRequestForFees(string fundIDorName, string analysisID)
        {
            LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
            List<JsonFormatCalcLiability> JFormatCalcLiability = new List<JsonFormatCalcLiability>();
            if (analysisID == null)
            {
                analysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
            }
            //get data from db and create json
            dynamic objJsonResult = lblogic.GetLiabilityCalcRequestForFees("", fundIDorName, analysisID);
            return Ok(objJsonResult);
        }



    }
}
