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
using System.Data;
using System.Threading;
namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class XIRRController : ControllerBase
    {
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/M61XIRR/calcXIRR")]
        public IActionResult CheckAndCalcXIRR()
        {
            LoggerLogic Log = new LoggerLogic();
            string status = "";
            try
            {
                TagXIRRLogic XIRRLogic = new TagXIRRLogic();
                List<XIRRCalculationRequestsDataContract> lstData = new List<XIRRCalculationRequestsDataContract>();
                lstData = XIRRLogic.GetProcessingXIRRRequestsFromDB();
                if (lstData != null || lstData.Count > 0)
                {
                    Parallel.ForEach(lstData, new ParallelOptions { MaxDegreeOfParallelism = 5 },
                        (item, state) =>
                        {
                            status = CalcXIRR(item);
                        }
                     );
                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.XIRRCalculator.ToString(), "No record in CheckAndCalcXIRR ", "", useridforSys_Scheduler);
                }

                //call this method to queue deal for calcualation
                DataTable dt = XIRRLogic.CalculateXIRRAfterDealCalculate(useridforSys_Scheduler);
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        CalculateXIRRAtEnd(dt);
                    }
                }

            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                Log.WriteLogException(CRESEnums.Module.XIRRCalculator.ToString(), "Error in CheckAndCalcXIRR :" + message, "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError, "InternalServerError");
            }
            return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status200OK, "Calc request submited successfully");

        }
        public string CalcXIRR(XIRRCalculationRequestsDataContract item)
        {
            string status = "";
            TagXIRRLogic XIRRLogic = new TagXIRRLogic();
            LoggerLogic Log = new LoggerLogic();
            try
            {
                DataTable dt = new DataTable();

                //get data from data
                XIRRLogic.UpdateCalcStatus(item.XIRRCalculationRequestsID, "Running", "StartTime", "", item.UserID);
                dt = XIRRLogic.GetTransactionsForXirrCalculation(item.XIRRConfigID, item.XIRRReturnGroupID, item.Type, item.DealAccountID, item.AnalysisID);
                //calc xirr                
                List<decimal> values = new List<decimal>();
                List<DateTime> datelist = new List<DateTime>();
                foreach (DataRow dr in dt.Rows)
                {
                    decimal val = new decimal();
                    DateTime dte = new DateTime();

                    dte = Convert.ToDateTime(dr["TransactionDate"]);
                    val = Convert.ToDecimal(dr["Amount"]);
                    values.Add(val);
                    datelist.Add(dte);
                }
                double XIRRValue = Financial.cXIRR(values, datelist);
                //save 
                if (XIRRValue != 9999)
                {
                    XIRRLogic.InsertXIRROutput(item.XIRRConfigID, item.XIRRReturnGroupID, item.Type, item.DealAccountID, Convert.ToDecimal(XIRRValue), item.AnalysisID, item.UserID);
                    XIRRLogic.UpdateCalcStatus(item.XIRRCalculationRequestsID, "Completed", "EndTime", "", item.UserID);
                    //generate excel xirr input and output excell file

                    if (item.IsCreateFile)
                    {
                        System.Data.DataView view = new System.Data.DataView(dt);
                        System.Data.DataTable dtFile =
                        view.ToTable("Selected", false, "DealName", "DealID", "NoteID", "NoteName", "TransactionDate", "Amount", "TransactionType", "SpreadPercentage", "OriginalIndex", "IndexValue", "EffectiveRate", "RemitDate", "FeeName");
                        Thread FirstThread = new Thread(() => GenerateXIRRInptOutputFiles(item, dtFile));
                        FirstThread.Start();
                    }
                }
                else
                {
                    Log.WriteLogExceptionMessage(CRESEnums.Module.XIRRCalculator.ToString(), "Error in CheckAndCalcXIRR : Arithmetic overflow and the value returned is NaN", "", item.UserID, "CalcXIRR", "Arithmetic overflow and the value returned is NaN");
                    XIRRLogic.InsertXIRROutput(item.XIRRConfigID, item.XIRRReturnGroupID, item.Type, item.DealAccountID, Convert.ToDecimal(XIRRValue), item.AnalysisID, item.UserID);
                    XIRRLogic.UpdateCalcStatus(item.XIRRCalculationRequestsID, "Failed", "EndTime", "Calculation Failed: Arithmetic overflow and the value returned is NaN ", item.UserID);
                }

                XIRRLogic.DeleteXIRRInputCashflow(item.XIRRConfigID);
                status = "Completed";
            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                Log.WriteLogException(CRESEnums.Module.XIRRCalculator.ToString(), "Error in CheckAndCalcXIRR :" + message, "", item.UserID, ex.TargetSite.Name.ToString(), "", ex);
                XIRRLogic.UpdateCalcStatus(item.XIRRCalculationRequestsID, "Failed", "EndTime", ex.StackTrace, item.UserID);
                status = "Failed";
            }

            return status;
        }

        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/M61XIRR/TestCalcXIRR")]
        public IActionResult TestCalcXIRR()
        {
            LoggerLogic Log = new LoggerLogic();
            string status = "";
            try
            {
                XIRRCalculationRequestsDataContract item = new XIRRCalculationRequestsDataContract();
                item.XIRRConfigID = 32;
                item.XIRRReturnGroupID = 1728;
                item.Type = "Portfolio";
                item.AnalysisID = "C10F3372-0FC2-4861-A9F5-148F1F80804F";
                item.UserID = useridforSys_Scheduler;
                //item.DealAccountID = "62A107E7-F58C-4767-917A-0BAE3AEF449E";
                CalcXIRR(item);


            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                Log.WriteLogException(CRESEnums.Module.XIRRCalculator.ToString(), "Error in CheckAndCalcXIRR :" + message, "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError, "InternalServerError");
            }
            return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status200OK, "Calc request submited successfully");

        }
        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/M61XIRR/GenerateXIRRFiles")]
        public IActionResult GenerateXIRRInptOutputFiles(XIRRCalculationRequestsDataContract item, DataTable dtXIRR)
        {

            string FilenameInput = "";
            string FilenameOutput = "";
            GenericResult _genericResult = null;
            XIRRConfigDataContract xirrDc = new XIRRConfigDataContract();
            XIRRReturnGroupDataContract retDC = new XIRRReturnGroupDataContract();
            string currDate = DateTime.Now.ToString("MMddyyyyHHmmss");
            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            try
            {
                //xirrDc = tagXIRRLogic.GetXIRRConfigByID(item.XIRRConfigID, "");

                if (dtXIRR != null && dtXIRR.Rows.Count > 0)
                {
                    //tagXIRRLogic.ArchiveXIRROutput(XIRRConfigParam, headerUserID.ToString());

                    retDC = tagXIRRLogic.GetXIRRReturnGroupByID(Convert.ToInt32(item.XIRRReturnGroupID), "");
                    DataTable dt = new DataTable();
                    ExceluploadController exc = new ExceluploadController();
                    ReportFileDataContract reportDC = new ReportFileDataContract();
                    reportDC.SourceStorageLocation = "XIRRTemplates";
                    reportDC.ReportFileFormat = "xlsx";
                    reportDC.SourceStorageTypeID = 392;
                    reportDC.DestinationStorageTypeID = 392;

                    try
                    {
                        //upload xirr input file    
                        reportDC.ReportFileName = "XIRR_Input";
                        reportDC.ReportFileTemplate = "XIRR_Input" + "." + reportDC.ReportFileFormat;
                        reportDC.DestinationStorageLocation = "XIRRInput";
                        //reportDC.NewFileName = xirrDc.ReturnName + "_" + xirrDc.Name + "_" + xirrDc.Type + "_Input_" + currDate + "." + reportDC.ReportFileFormat;
                        reportDC.NewFileName = "Input_" + item.XIRRReturnGroupID + "_" + retDC.ChildReturnName + "_" + currDate + "." + reportDC.ReportFileFormat;
                        FilenameInput = reportDC.NewFileName;
                        var result = exc.UploadXIRRFiles(reportDC, dtXIRR, false);
                        tagXIRRLogic.UpdateXIRRInputOutputFiles(Convert.ToInt32(item.XIRRReturnGroupID), reportDC.NewFileName, "");
                        tagXIRRLogic.InsertXIRRDeleteBlobFiles(reportDC.NewFileName, reportDC.DestinationStorageLocation, "");
                    }
                    catch (Exception ex)
                    {
                        //delete files from blob

                        LoggerLogic Log = new LoggerLogic();
                        Log.WriteLogException(CRESEnums.Module.XIRR.ToString(), "Error occurred in GenerateXIRRInptOutputFiles", "", "", ex.TargetSite.Name.ToString(), "", ex);

                        _genericResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = ex.Message
                        };
                    }
                }
                _genericResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Data uploaded successfully.",
                };
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.XIRR.ToString(), "Error occurred in GenerateXIRRInptOutputFiles", "", "", ex.TargetSite.Name.ToString(), "", ex);

                _genericResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_genericResult);

        }


        [HttpGet]
        [NoteCalculatorServiceMVC.Controllers.DeflateCompression]
        [Route("api/M61XIRR/TestGenerateXIRRFiles")]
        public IActionResult TestGenerateXIRRInptOutputFiles()
        {
            DataTable dt = new DataTable();
            for (int i = 0; i < 1; i++)
            {
                //GenerateXIRRInptOutputFiles(30,dt);
            }
            return Ok();

        }

        public void CalculateXIRRAtEnd(DataTable dt)
        {
            foreach (DataRow dr in dt.Rows)
            {
                CalculateXIRRAfterDealSave(dr["credealid"].ToString(), useridforSys_Scheduler);
            }
        }
        public void CalculateXIRRAfterDealSave(string CREDealID, string UserName)
        {
            LoggerLogic Log = new LoggerLogic();
            try
            {
                string noteidarray = "";
                DynamicSizerLogic dynamicSizerLogic = new DynamicSizerLogic();
                DataTable dt = dynamicSizerLogic.CalculateXIRRAfterDealSave_FromSizer(CREDealID, UserName);
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        noteidarray = noteidarray + Convert.ToString(dr["XIRRConfigID"]) + ",";
                    }
                    if (noteidarray != "")
                    {
                        noteidarray = noteidarray.Remove(noteidarray.Length - 1);
                        noteidarray = noteidarray.Replace("\n", "");
                        noteidarray = noteidarray.Replace("\t", "");
                    }
                    TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
                    XIRRConfigParamDataContract config = new XIRRConfigParamDataContract();
                    config.XIRRConfigIDs = noteidarray.ToString();
                    tagXIRRLogic.InsertXIRRCalculationInput(config, UserName);
                    Log.WriteLogInfo("XIRRDealCalc", "CalculateXIRRAfterDealSave End ", CREDealID, UserName);

                    //generate portfolio level input file 
                    Thread FirstThread = new Thread(() => InsertXIRR_InputCashflow(config, new Guid(useridforSys_Scheduler)));
                    FirstThread.Start();
                }
            }
            catch (Exception ex)
            {
                Log.WriteLogException("XIRRDealCalc", "Error occurred  while CalculateXIRRAfterDealSave: Deal ID " + CREDealID, CREDealID, UserName, ex.TargetSite.Name.ToString(), "", ex);
                throw;
            }
        }
        public void InsertXIRR_InputCashflow([FromBody] XIRRConfigParamDataContract XIRRConfigParam, Guid UserID)
        {
            GenericResult _genericResult = null;
            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            foreach (string configid in XIRRConfigParam.XIRRConfigIDs.Split(","))
            {
                try
                {
                    tagXIRRLogic.InsertXIRR_InputCashflow(Convert.ToInt32(configid), UserID);
                    _genericResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Data uploaded successfully.",
                    };
                }
                catch (Exception ex)
                {
                    LoggerLogic Log = new LoggerLogic();
                    Log.WriteLogException(CRESEnums.Module.XIRR.ToString(), "Error occurred in InsertXIRR_InputCashflow", "", "", ex.TargetSite.Name.ToString(), "", ex);

                    _genericResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = ex.Message
                    };
                }
            }
            GenerateXIRRInptFiles(XIRRConfigParam);
        }

        public void GenerateXIRRInptFiles([FromBody] XIRRConfigParamDataContract XIRRConfigParam)
        {
            GenericResult _genericResult = null;
            XIRRConfigDataContract xirrDc = new XIRRConfigDataContract();
            string currDate = DateTime.Now.ToString("MMddyyyyHHmmss");
            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            foreach (string configid in XIRRConfigParam.XIRRConfigIDs.Split(","))
            {
                try
                {
                    DataTable dt = new DataTable();
                    ExceluploadController exc = new ExceluploadController();
                    //upload xirr input file
                    ReportFileDataContract reportDC = new ReportFileDataContract();
                    reportDC.ReportFileName = "XIRR_Input";
                    reportDC.ReportFileFormat = "xlsx";
                    reportDC.SourceStorageLocation = "XIRRTemplates";
                    reportDC.SourceStorageTypeID = 392;
                    reportDC.ReportFileTemplate = "XIRR_Input_PortfolioLevel" + "." + reportDC.ReportFileFormat;

                    reportDC.DestinationStorageTypeID = 392;
                    reportDC.DestinationStorageLocation = "XIRRInput";


                    xirrDc = tagXIRRLogic.GetXIRRConfigByID(Convert.ToInt32(configid), "");
                    //reportDC.NewFileName = reportDC.ReportFileName + "_" + currDate + "." + reportDC.ReportFileFormat;
                    reportDC.NewFileName = "Input_" + xirrDc.XIRRConfigID + "_" + xirrDc.ReturnName + "_" + xirrDc.Name + "_" + xirrDc.Type + "_" + currDate + "." + reportDC.ReportFileFormat;

                    DataTable dtXIRR = new DataTable();
                    dtXIRR = tagXIRRLogic.GetXIRRInputByConfigID(Convert.ToInt32(configid), "");
                    var result = exc.UploadXIRRFiles(reportDC, dtXIRR);
                    tagXIRRLogic.UpdateXIRRInputFiles(Convert.ToInt32(configid), reportDC.NewFileName, "");
                    tagXIRRLogic.InsertXIRRDeleteBlobFiles(reportDC.NewFileName, reportDC.DestinationStorageLocation, "");

                    _genericResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Data uploaded successfully.",
                    };
                }
                catch (Exception ex)
                {
                    LoggerLogic Log = new LoggerLogic();
                    Log.WriteLogException(CRESEnums.Module.XIRR.ToString(), "Error occurred in UploadXIRRInptOutputToBlob", "", "", ex.TargetSite.Name.ToString(), "", ex);

                    _genericResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = ex.Message
                    };
                }
            }


        }
    }
}
