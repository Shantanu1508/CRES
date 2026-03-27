using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.NoteCalculator;
using CRES.Utilities;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System.IO;
using System.Text;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace CRES.NoteCalculatorService.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class NoteCalculatorController : ControllerBase
    {
        IConfigurationSection Sectionroot = null;

        private readonly IEmailNotification _iEmailNotification;
        public NoteCalculatorController(IEmailNotification iemailNotification)
        {
            _iEmailNotification = iemailNotification;
        }

        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        [HttpPost]
        [Route("api/note/calculatenoteweb")]
        public IActionResult CalculateNoteWeb([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _acationResult = null;
            NoteDataContract objNote = new NoteDataContract();
            CalculationMaster cm = new CalculationMaster();


            LoggerLogic Log = new LoggerLogic();
            Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Calculation Started in calculation service for " + _noteDC.CRENoteID, _noteDC.NoteId, System.Environment.UserName);
            objNote = cm.StartCalculation(_noteDC);
            Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Calculation ended in calculation service for " + _noteDC.CRENoteID, _noteDC.NoteId, System.Environment.UserName);
            try
            {
                if (objNote != null && objNote.CalculatorExceptionMessage == "Succeed")
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Calculation succeeded",
                        lstNotePeriodicOutputsDataContract = objNote.ListNotePeriodicOutputs,
                        ListOutputNPVdata = objNote.ListOutputNPVdata,
                        ListOutputAllTabData = objNote.ListOutputAllTabData,
                        ListTransaction = objNote.ListTransaction,
                        CalculatorExceptionMessage = objNote.CalculatorExceptionMessage
                    };
                }
                else
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = objNote.CalculatorExceptionMessage
                    };
                }
            }
            catch (Exception ex)
            {
                _acationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.StackTrace
                };
            }
            return Ok(_acationResult);
        }
        public void CalculateMutipleNote(List<CalculationManagerDataContract> _lstCalcManagerDC, string AllowBackshopPIKPrincipal)
        {
            var exceptions = new ConcurrentQueue<Exception>();
            string SysUser = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";

            Parallel.ForEach(_lstCalcManagerDC,
    new ParallelOptions { MaxDegreeOfParallelism = 2 },
                                      (_cmDC) =>
                                      {
                                          DateTime StartTime = DateTime.MinValue;
                                          DateTime EndTime = DateTime.MinValue;
                                          DateTime calcStarttime = DateTime.MinValue;
                                          DateTime calcEndtime = DateTime.MinValue;
                                          DateTime DbStarttime = DateTime.MinValue;
                                          DateTime DbEndtime = DateTime.MinValue;

                                          decimal? TotalTime = 0, CalcProcessTime = 0, DbProcessTime = 0;
                                          try
                                          {
                                              StartTime = DateTime.Now;
                                              CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                                              NoteLogic nl = new NoteLogic();

                                              #region get note data from Database for calculation

                                              DbStarttime = DateTime.Now;
                                              NoteDataContract _noteDC = nl.GetNoteAllDataForCalculatorByNoteId(_cmDC.NoteId, null, _cmDC.AnalysisID, null, null);
                                              DbEndtime = DateTime.Now;
                                              DbProcessTime = Convert.ToDecimal((DbEndtime - DbStarttime).TotalSeconds);

                                              DbStarttime = DateTime.MinValue;
                                              DbEndtime = DateTime.MinValue;
                                              #endregion get note data from Database for calculation
                                              CollectCalculatorLogs("2.Loading data for note Ended : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                              #region call claculator code

                                              NoteDataContract objNote = new NoteDataContract();
                                              CalculationMaster cm = new CalculationMaster();

                                              CollectCalculatorLogs("3.Note Sent for Calculation : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                              calcStarttime = DateTime.Now;
                                              objNote = cm.StartCalculation(_noteDC);
                                              calcEndtime = DateTime.Now;

                                              CollectCalculatorLogs("4.Calculation Ended for note : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                              #endregion call claculator code

                                              List<PIKDistributionsDataContract> ListPIkDis = new List<PIKDistributionsDataContract>();
                                              if (objNote.NotePIKScheduleList != null)
                                              {
                                                  if (objNote.NotePIKScheduleList.Count > 0)
                                                  {
                                                      foreach (PIKSchedule pik in objNote.NotePIKScheduleList)
                                                      {
                                                          foreach (PIKInterestTab pikc in objNote.ListPIKInterestTab)
                                                          {
                                                              if (pikc.TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod != null && pikc.TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod != 0)
                                                              {
                                                                  PIKDistributionsDataContract pikdc = new PIKDistributionsDataContract();
                                                                  pikdc.SourceNoteID = pik.NoteID;
                                                                  pikdc.ReceiverNoteID = pik.TargateNoteID;
                                                                  pikdc.Amount = pikc.TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod;
                                                                  pikdc.TransactionDate = pikc.Date;
                                                                  ListPIkDis.Add(pikdc);
                                                              }
                                                          }
                                                      }
                                                  }
                                              }
                                              objNote.ListPIKDistribution = ListPIkDis;

                                              #region UpdateCalculationStatusandTime

                                              try
                                              {
                                                  if (objNote != null && objNote.CalculatorExceptionMessage == "Succeed")
                                                  {
                                                      if (_noteDC.EnableDebug == true)
                                                      {
                                                          UploadJSONFile(_noteDC, _cmDC.CalculationRequestID, "InputFile");
                                                          UploadJSONFile(objNote, _cmDC.CalculationRequestID);
                                                      }

                                                      bool isSavedCalcOutput = false;
                                                      //Insert NotePeriodicCalc
                                                      DbStarttime = DateTime.Now;
                                                      if (objNote.ListNotePeriodicOutputs != null)
                                                      {
                                                          CollectCalculatorLogs("5.Saving Process Started : noteid ID ", _noteDC.NoteId.ToString(), _cmDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          CollectCalculatorLogs("6.Saving Process Started for Periodic Outputs: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          nl.InsertNotePeriodicCalcFromCalculationManger(objNote.ListNotePeriodicOutputs, _cmDC.UserName, new Guid(_cmDC.NoteId));
                                                          CollectCalculatorLogs("7.Saving Process Ended for Periodic Outputs: noteid ID ", _cmDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);


                                                          CollectCalculatorLogs("8.Saving Process Started for output daily: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          nl.InsertNotePeriodicCalcFromCalculationDaily(objNote.ListNotePeriodicOutput_Daily, _cmDC.UserName, new Guid(_cmDC.NoteId));
                                                          CollectCalculatorLogs("9.Saving Process Ended for output daily: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          CollectCalculatorLogs("10.Saving Process started for Pvgaap: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          nl.InsertNotePeriodicCalcFromCalculationPVandGaap(objNote.ListNotePeriodicOutput_PVAndGaap, _cmDC.UserName, new Guid(_cmDC.NoteId));
                                                          CollectCalculatorLogs("11.Saving Process ended for Pvgaap: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          CollectCalculatorLogs("12.Saving Process Started for liborandspread: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          nl.InsertNotePeriodicCalcFromCalculationSpreadLibor(objNote.ListNotePeriodicOutput_SpreadAndLibor, _cmDC.UserName, new Guid(_cmDC.NoteId));
                                                          CollectCalculatorLogs("13.Saving Process Ended for liborandspread: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          CollectCalculatorLogs("14.Saving Process Started for Cashflow Transactions: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          if (objNote.ListCashflowTransactionEntry != null)
                                                          {
                                                              if (objNote.ListCashflowTransactionEntry.Count == 0)
                                                              {
                                                                  TransactionEntry te = new TransactionEntry();
                                                                  te.AnalysisID = _cmDC.AnalysisID;
                                                                  objNote.ListCashflowTransactionEntry.Add(te);
                                                              }
                                                          }
                                                          nl.InsertCashflowTransaction(objNote.ListCashflowTransactionEntry, _cmDC.NoteId, _noteDC.UpdatedBy, _noteDC.MaturityUsedInCalc);
                                                          CollectCalculatorLogs("15.Saving Process Ended for Cashflow Transactions: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);


                                                          if (_cmDC.AnalysisID == new Guid("C10F3372-0FC2-4861-A9F5-148F1F80804F"))
                                                          {
                                                              nl.InsertInterestCalculator(objNote.ListInterestCalculator, _cmDC.NoteId, _noteDC.UpdatedBy);
                                                              if (objNote.ListDailyInterestAccruals != null)
                                                              {
                                                                  CollectCalculatorLogs("16.Saving Process started for DailyInterest Accruals: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                                  nl.InsertDailyInterestAccural(objNote.ListDailyInterestAccruals, _cmDC.NoteId, _noteDC.UpdatedBy);
                                                                  CollectCalculatorLogs("17.Saving Process Ended for DailyInterestAccruals: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                              }
                                                              if (objNote.ListPeriodicInterestRateUsed != null)
                                                              {
                                                                  CollectCalculatorLogs("18.Saving Process started for Periodic Interest Rate Used: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                                  nl.InsertPeriodicInterestRateUsed(objNote.ListPeriodicInterestRateUsed, _cmDC.NoteId, _noteDC.UpdatedBy);
                                                                  CollectCalculatorLogs("19.Saving Process Ended for  Periodic Interest Rate Used: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                              }
                                                          }
                                                          if (_noteDC.AllowYieldConfigData == true)
                                                          {
                                                              CollectCalculatorLogs("Saving Process started for ListYieldCalcInput : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                              nl.InsertYieldCalcInput(objNote.ListYieldCalcInput, _noteDC.UpdatedBy);
                                                              CollectCalculatorLogs("Saving Process Ended for ListYieldCalcInput: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          }
                                                          if (_noteDC.AllowDailyGAAPBasisComponents == "Y")
                                                          {
                                                              if (objNote.ListDailyGAAPBasisComponents != null)
                                                              {
                                                                  nl.InsertDailyGAAPBasisComponents(objNote.ListDailyGAAPBasisComponents, _cmDC.NoteId, _noteDC.UpdatedBy);

                                                              }
                                                          }
                                                          isSavedCalcOutput = true;
                                                      }

                                                      if (objNote.ListPIKDistribution != null)
                                                      {
                                                          CollectCalculatorLogs("20.Saving Process started for PIKDistribution: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          nl.InsertPIKDistributions(objNote.ListPIKDistribution, _noteDC.UpdatedBy);
                                                          CollectCalculatorLogs("21.Saving Process Ended for PIKDistribution: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                      }

                                                      if (isSavedCalcOutput)
                                                      {
                                                          PayruleSetupLogic _PayruleSetupLogic = new PayruleSetupLogic();

                                                          CollectCalculatorLogs("22.Saving Process Started for Pay Rule Distribuation : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          _PayruleSetupLogic.InsertUpdatePayruleDistributions(_noteDC.NoteId.ToString(), "", _noteDC.AnalysisID);
                                                          CollectCalculatorLogs("23.Saving Process Ended for Pay Rule Distribuation : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          CollectCalculatorLogs("24.Calculation Status update started: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Completed", "EndTime", "");
                                                          CollectCalculatorLogs("25.Calculation Status update Ended: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          //string noteid = _cmDC.NoteId.ToString();
                                                          //calculationlogic.UpdateCalculationStatusForDependents(noteid,_noteDC.AnalysisID);
                                                      }
                                                      //check for amort check and gaap check
                                                      calculationlogic.InsertExceptionsOfCalculatorComponent(new Guid(_noteDC.NoteId), _noteDC.AnalysisID, _noteDC.UpdatedBy);
                                                      //
                                                      if (AllowBackshopPIKPrincipal == "1")
                                                      {
                                                          if (_cmDC.AnalysisID == new Guid("C10F3372-0FC2-4861-A9F5-148F1F80804F"))
                                                          {
                                                              Thread FirstThread1 = new Thread(() => ExportDatatoBakchsop(_noteDC.DealID, _cmDC.UserName, _noteDC.NoteId));
                                                              FirstThread1.Start();
                                                          }
                                                      }
                                                      WeightedSpreadCalcHelperLogic wsc = new WeightedSpreadCalcHelperLogic();
                                                      Thread FirstCaculateWeightedAvg = new Thread(() => wsc.CaculateWeightedAvg(_noteDC.DealID, _cmDC.UserName, _noteDC.NoteId));
                                                      FirstCaculateWeightedAvg.Start();

                                                      DbEndtime = DateTime.Now;
                                                      EndTime = DateTime.Now;
                                                      int TotalMinutes = Convert.ToInt32(Math.Ceiling((EndTime - StartTime).TotalMinutes));

                                                      TotalTime = Convert.ToDecimal((EndTime - StartTime).TotalSeconds);
                                                      CalcProcessTime = Convert.ToDecimal((calcEndtime - calcStarttime).TotalSeconds);
                                                      DbProcessTime = DbProcessTime.GetValueOrDefault(0) + Convert.ToDecimal((DbEndtime - DbStarttime).TotalSeconds);

                                                      calculationlogic.UpdateCalculationTimeInMinByNoteID(new Guid(_noteDC.NoteId), TotalMinutes);

                                                      calculationlogic.InsertIntoCalculatorStatistics(_noteDC.NoteId.ToString(), CalcProcessTime, DbProcessTime, TotalTime, _cmDC.AnalysisID.ToString());
                                                      InsertUpdatedNoteWiseEndingBalance(new Guid(_noteDC.NoteId));
                                                      CalcNetCapitalInvestedbyNoteId(_noteDC.NoteId);
                                                      //CalculateCommitmentAfterCalc(_noteDC.DealID, _cmDC.UserName);
                                                  }
                                                  else
                                                  {
                                                      calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Failed", "EndTime", objNote.CalculatorExceptionMessage.ToString());
                                                      LoggerLogic Log = new LoggerLogic();
                                                      Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in calculating note:: Note ID " + _noteDC.CRENoteID + " " + objNote.CalculatorstackTrace, _noteDC.NoteId.ToString(), SysUser, "StartCalculation", objNote.CalculatorExceptionMessage);
                                                  }
                                              }
                                              catch (Exception ex)
                                              {

                                                  string errormessage = LoggerHelper.GetExceptionString(ex);
                                                  calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Failed", "EndTime", errormessage);

                                                  LoggerLogic Log = new LoggerLogic();
                                                  Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in Saving outputs: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), SysUser, ex.TargetSite.Name.ToString(), "", ex);

                                                  exceptions.Enqueue(ex);

                                              }

                                              #endregion UpdateCalculationStatusandTime
                                          }
                                          catch (Exception e)
                                          {
                                              CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                                              string errormessage = LoggerHelper.GetExceptionString(e);
                                              errormessage = errormessage.Replace("'", "\"");
                                              calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Failed", "EndTime", errormessage);
                                              exceptions.Enqueue(e);
                                          }
                                      });

            if (exceptions.Count > 0)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in calculating notes ", "", SysUser, "", "");

            }
        }
        public void ExportDatatoBakchsop(string DealID, string UserName, string NoteId)
        {
            try
            {
                BackShopExportLogic backShopExportLogic = new BackShopExportLogic();
                backShopExportLogic.ExportDataToBackShop(DealID, UserName, NoteId, "PIK");
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in ExportDatatoBakchsop ", NoteId, UserName, "ExportDatatoBakchsop", "", ex);
            }
        }
        public void CalculateCommitmentAfterCalc(string DealID, string UserName)
        {
            try
            {
                //// calculate commitment data after note is calculated
                CommitmentEquityHelperLogic ce = new CommitmentEquityHelperLogic();
                List<NoteCommitmentEquityDataContract> calcNoteCommitmentdata = ce.calcNoteCommitment(DealID, new Guid(UserName));

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.ServicerFileImport.ToString(), "Error in CalculateCommitmentAfterCalc :  ", "", "", ex.TargetSite.Name.ToString(), "", ex);

            }
        }
        [HttpGet]
        [Route("api/note/getcalcrequestcount-new")]
        public void GetCalcRequestCount()

        {
            string SysUser = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                LoggerLogic Log = new LoggerLogic();

                int requestCount = calculationlogic.getCalcStatusByServerIndex(1);
                if (requestCount > 0)
                {
                    List<CalculationManagerDataContract> list = calculationlogic.NotesListForCalculationByServerIndex(1);
                    if (list.Count > 0)
                    {
                        CalculateMutipleNote(list, "1");
                    }
                }

                //CreateAutoTag
                try
                {
                    Thread FirstThread = new Thread(() => calculationlogic.CreateBatchCalculationTag());
                    FirstThread.Start();
                    //EmailNotification emailNotification = new EmailNotification();
                    //emailNotification.SendBatchCalculationEmail();
                }
                catch (Exception ex)
                {
                    Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error while creating tag for batch", "", SysUser, ex.TargetSite.Name.ToString(), "", ex);
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error occurred while calculating multiple loans", "", SysUser, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        [HttpGet]
        [Route("api/note/getcalcrequestcountbyserverindex-new")]
        public void GetCalcRequestCountByServerIndex(int ServerIndex)
        {
            string SysUser = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                int requestCount = calculationlogic.getCalcStatusByServerIndex(ServerIndex);
                if (requestCount > 0)
                {
                    List<CalculationManagerDataContract> list = calculationlogic.NotesListForCalculationByServerIndex(ServerIndex);
                    if (list.Count > 0)
                    {
                        string AllowBackshopPIKPrincipal = "1";
                        AppConfigLogic acl = new AppConfigLogic();
                        List<AppConfigDataContract> listappconfig = acl.GetAllAppConfig(new Guid(SysUser));
                        foreach (AppConfigDataContract item in listappconfig)
                        {
                            if (item.Key == "AllowBackshopPIKPrincipal")
                            {
                                AllowBackshopPIKPrincipal = item.Value;
                            }
                        }

                        CalculateMutipleNote(list, AllowBackshopPIKPrincipal);
                    }
                }

                try
                {
                    Thread FirstThread = new Thread(() => calculationlogic.CreateBatchCalculationTag());
                    FirstThread.Start();
                    //_iEmailNotification.SendBatchCalculationEmail();
                }
                catch (Exception ex)
                {
                    LoggerLogic Log = new LoggerLogic();
                    Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error while creating tag for batch ", "", SysUser, ex.TargetSite.Name.ToString(), "", ex);
                }

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error occurred while calculating multiple loans", "", SysUser, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        public void UploadJSONFile(NoteDataContract _noteDC, Guid CalculationRequestID, string FileType = "")
        {
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                Guid? UserID = null;

                if (FileType != "InputFile")
                {
                    // var json = new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListNotePeriodicOutput) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListBalanceTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListCouponTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListPIKInterestTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListFinancingTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListRateTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListFeesTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListDatesTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListGAAPBasisTab) + new JavaScriptSerializer().Serialize(_noteDC.CalculatorDebugData.ListFeeOutput);
                    //  var json = new JavaScriptSerializer() { MaxJsonLength = 999999999 }.Serialize (_noteDC.CalculatorDebugData);
                    var json = JsonConvert.SerializeObject(_noteDC.CalculatorDebugData);
                    var FileName = _noteDC.CRENoteID + "_" + _noteDC.DefaultScenarioParameters.ScenarioName + "_" + DateTime.Now.ToString("MM_dd_yyyy_HH_mm_ss") + ".json";

                    if (UploadJSONFileToAzureBlob(json, FileName))
                    {
                        calculationlogic.InsertCalculatorOutputJsonInfo(CalculationRequestID, new Guid(_noteDC.NoteId), _noteDC.AnalysisID, UserID, FileName, "Output File");
                    }
                }
                else
                {
                    var json = JsonConvert.SerializeObject(_noteDC);
                    var FileName = "InputFile_" + _noteDC.CRENoteID + "_" + _noteDC.DefaultScenarioParameters.ScenarioName + "_" + DateTime.Now.ToString("MM_dd_yyyy_HH_mm_ss") + ".json";

                    if (UploadJSONFileToAzureBlob(json, FileName))
                    {
                        calculationlogic.InsertCalculatorOutputJsonInfo(CalculationRequestID, new Guid(_noteDC.NoteId), _noteDC.AnalysisID, UserID, FileName, "Input File");
                    }
                }

            }
            catch (Exception ex)
            {
                string exception = ex.Message;
            }
        }


        public Boolean UploadJSONFileToAzureBlob(string jsontext, string FileName)
        {
            try
            {
                GetConfigSetting();
                byte[] byteArray = Encoding.ASCII.GetBytes(jsontext);
                MemoryStream stream = new MemoryStream(byteArray);
                var Container = Sectionroot.GetSection("storage:container:name").Value;
                // Get Blob Container
                CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);
                CloudBlobDirectory blobDirectory = container.GetDirectoryReference("CalcDebug");
                CloudBlockBlob blockBlob = blobDirectory.GetBlockBlobReference(FileName);
                blockBlob.UploadFromStream(stream);
                return true;
            }
            catch (Exception ex)
            {
                return false;
                throw;
            }
        }

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

        public void CollectCalculatorLogs(string message, string noteid, string crenoteid, Boolean? collectlog)
        {
            if (collectlog == true)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), message + crenoteid + " ", noteid, "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50");
            }
        }


        public void InsertUpdatedNoteWiseEndingBalance(Guid NoteID)
        {
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                Guid? UserID = null;
                calculationlogic.InsertUpdatedNoteWiseEndingBalance(NoteID, UserID);
            }
            catch (Exception ex)
            {

            }
            finally
            {

            }
        }

        public void CalcNetCapitalInvestedbyNoteId(string NoteID)
        {
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                Guid? UserID = null;
                calculationlogic.CalcNetCapitalInvestedbyNoteId(NoteID);
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in CalcNetCapitalInvestedbyNoteId: Note ID " + NoteID, NoteID.ToString(), "", ex.TargetSite.Name.ToString(), "", ex);

            }
            finally
            {

            }
        }

        [Route("api/note/CheckCalcProcess")]
        public void CheckCalcProcess(string noteid)
        {
            ////CalculateMutipleNote
            List<CalculationManagerDataContract> _lstCalcManagerDC = new List<CalculationManagerDataContract>();
            CalculationManagerDataContract cmm = new CalculationManagerDataContract();
            cmm.NoteId = noteid;
            cmm.CalculationRequestID = new Guid("7D82D27B-3478-4E60-9177-9DAB10DB90F7");
            cmm.UserName = "b0e6697b-3534-4c09-be0a-04473401ab93";
            cmm.AnalysisID = new Guid("C10F3372-0FC2-4861-A9F5-148F1F80804F");
            _lstCalcManagerDC.Add(cmm);

            CalculateMutipleNote(_lstCalcManagerDC, "0");

            // CaculateWeightedAvg("553b8937-4709-43f7-a398-3daf829a00f1",null, "705cf7ff-c0bd-47a1-b7ab-a71cd05b80e2");
            //BackShopExportLogic backShopExportLogic = new BackShopExportLogic();
            //backShopExportLogic.ExportDataToBackShop(null, "b0e6697b-3534-4c09-be0a-04473401ab93", "8550da96-ccac-460c-8ac2-a59b433206c0", "Balloon");



        }

        [HttpGet]
        [Route("api/note/queuenotesforcalculationforduplicatetransaction")]
        public void QueueNotesForCalculationForDuplicateTransaction()
        {
            LoggerLogic Log = new LoggerLogic();

            try
            {
                Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "QueueNotesForCalculationForDuplicateTransaction called", "", useridforSys_Scheduler);
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                calculationlogic.QueueNotesForCalculationForDuplicateTransaction();

            }
            catch (Exception ex)
            {
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error occurred QueueNotesForCalculationForDuplicateTransaction", "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        [HttpGet]
        [Route("api/note/QueueNotesForCalculationIfDWoutofSync")]
        public void QueueNotesForCalculationIfDWoutofSync()
        {
            CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
            LoggerLogic Log = new LoggerLogic();
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "QueueNotesForCalculationIfDWoutofSync called", "", useridforSys_Scheduler);
                calculationlogic.QueueNotesForCalculationIfDWoutofSync();

            }
            catch (Exception ex)
            {
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error occurred QueueNotesForCalculationIfDWoutofSync", "", useridforSys_Scheduler, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

    }


    internal class BlobUtilities
    {

        public static CloudBlobClient GetBlobClient
        {
            get
            {

                IConfigurationSection Sectionroot = null;
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");


                var accountName = Sectionroot.GetSection("storage:account:name").Value;
                var accountKey = Sectionroot.GetSection("storage:account:key").Value;

                CloudStorageAccount storageAccount = CloudStorageAccount.Parse("DefaultEndpointsProtocol=https;AccountName=" + accountName + ";"
                 + "AccountKey=" + accountKey + "");
                CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
                return blobClient;
            }
        }

    }
}