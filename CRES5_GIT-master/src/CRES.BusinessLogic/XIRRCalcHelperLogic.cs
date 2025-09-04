using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading;

namespace CRES.BusinessLogic
{
    public class XIRRCalcHelperLogic
    {
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
                    Thread FirstThread = new Thread(() => InsertXIRR_InputCashflow(config, new Guid(UserName)));
                    FirstThread.Start();
                }
            }
            catch (Exception ex)
            {
                Log.WriteLogException("XIRRDealCalc", "Error occurred  while CalculateXIRRAfterDealSave: Deal ID " + CREDealID, CREDealID, UserName, ex.TargetSite.Name.ToString(), "", ex);
                throw;
            }
        }


        public void InsertXIRR_InputCashflow(XIRRConfigParamDataContract XIRRConfigParam, Guid UserID)
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

        public void GenerateXIRRInptFiles(XIRRConfigParamDataContract XIRRConfigParam)
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
                    ExceluploadHelperLogic exc = new ExceluploadHelperLogic();                   
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
