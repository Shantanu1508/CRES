using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.NoteCalculator;
using CRES.Utilities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

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
        //[Services.Controllers.DeflateCompression]
        [HttpPost]
        [Route("api/note/calculatenote")]
        public IActionResult CalculateNote([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _acationResult = null;
            NoteDataContract objNote = new NoteDataContract();
            CalculationMaster cm = new CalculationMaster();
            string trace = "trace is not enabled";
            objNote = cm.StartCalculation(_noteDC);


            if (_noteDC.EnableTrace.GetValueOrDefault())
            {
                trace = "Dates,";
                trace += Environment.NewLine + cm.ListDatesTab.ToCsv<DatesTab>();
                trace += Environment.NewLine + "Rates,";
                trace += Environment.NewLine + cm.ListRateTab.ToCsv<RateTab>();
                trace += Environment.NewLine + "Balance,";
                trace += Environment.NewLine + cm.ListBalanceTab.ToCsv<BalanceTab>();
                trace += Environment.NewLine + "Fees,";
                trace += Environment.NewLine + cm.ListFeesTab.ToCsv<FeesTab>();
                trace += Environment.NewLine + "Coupon,";
                trace += Environment.NewLine + cm.ListCouponTab.ToCsv<CouponTab>();
                trace += Environment.NewLine + "PIK,";
                trace += Environment.NewLine + cm.ListPIKInterestTab.ToCsv<PIKInterestTab>();
                trace += Environment.NewLine + "GAAP Basis,";
                trace += Environment.NewLine + cm.ListGAAPBasisTab.ToCsv<GAAPBasisTab>();
                trace += Environment.NewLine + "Financing,";
                trace += Environment.NewLine + cm.ListFinancingTab.ToCsv<FinancingTab>();
            }

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
                        Trace = trace,
                        ListCalcVal = objNote.ListCalcValues,
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

        [HttpPost]
        [Route("api/note/notecalculator")]
        public GenericResult NoteCalculator([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _acationResult = null;
            NoteDataContract objNote = new NoteDataContract();
            CalculationMaster cm = new CalculationMaster();
            //objNote = _noteDC;
            try
            {
                objNote = cm.StartCalculation(_noteDC);

                if (objNote != null)
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Calculation succeeded",
                        lstNotePeriodicOutputsDataContract = objNote.ListNotePeriodicOutputs,
                        ListOutputNPVdata = objNote.ListOutputNPVdata,
                        ListOutputAllTabData = objNote.ListOutputAllTabData
                        //NoteData = objNote
                    };
                }
                else
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Error occured while calculating note"
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
            return _acationResult;
        }

        [HttpPost]
        [Route("api/note/calculatenotetest")]
        public IActionResult CalculateNoteTest()
        {
            //  [FromBody] NoteDataContract _noteDC
            // NoteDataContract _noteDC = new NoteDataContract();

            GenericResult _acationResult = null;

            try
            {


                _acationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "tested",
                };
            }
            catch (Exception ex)
            {
                _acationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_acationResult);
        }

        [HttpPost]
        [Route("api/note/CalculateNoteAndSaveByNoteID")]
        public IActionResult CalculateNoteAndSaveByNoteID([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _acationResult = null;

            NoteDataContract objNote = new NoteDataContract();
            objNote = CalculateDataSaveInputAndOutput(_noteDC, false);

            #region trace

            CalculationMaster cm = new CalculationMaster();
            string trace = "trace is not enabled";
            if (_noteDC.EnableTrace.GetValueOrDefault())
            {
                trace = "Dates,";
                trace += Environment.NewLine + cm.ListDatesTab.ToCsv<DatesTab>();
                trace += Environment.NewLine + "Rates,";
                trace += Environment.NewLine + cm.ListRateTab.ToCsv<RateTab>();
                trace += Environment.NewLine + "Balance,";
                trace += Environment.NewLine + cm.ListBalanceTab.ToCsv<BalanceTab>();
                trace += Environment.NewLine + "Fees,";
                trace += Environment.NewLine + cm.ListFeesTab.ToCsv<FeesTab>();
                trace += Environment.NewLine + "Coupon,";
                trace += Environment.NewLine + cm.ListCouponTab.ToCsv<CouponTab>();
                trace += Environment.NewLine + "PIK,";
                trace += Environment.NewLine + cm.ListPIKInterestTab.ToCsv<PIKInterestTab>();
                trace += Environment.NewLine + "GAAP Basis,";
                trace += Environment.NewLine + cm.ListGAAPBasisTab.ToCsv<GAAPBasisTab>();
                trace += Environment.NewLine + "Financing,";
                trace += Environment.NewLine + cm.ListFinancingTab.ToCsv<FinancingTab>();
            }

            #endregion trace

            try
            {
                if (objNote != null)
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Calculation succeeded",
                        lstNotePeriodicOutputsDataContract = objNote.ListNotePeriodicOutputs,
                        ListOutputNPVdata = objNote.ListOutputNPVdata,
                        ListOutputAllTabData = objNote.ListOutputAllTabData,
                        Trace = trace
                        //NoteData = objNote
                    };
                }
                else
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Error occured while calculating note and Save."
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

        [HttpPost]
        [Route("api/note/CalculateNoteSaveInputAndOutput")]
        public IActionResult CalculateNoteSaveInputAndOutput([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _acationResult = null;

            if (_noteDC != null)
            {
                NoteDataContract objNote = new NoteDataContract();
                objNote = CalculateDataSaveInputAndOutput(_noteDC, true);

                #region trace

                CalculationMaster cm = new CalculationMaster();
                string trace = "trace is not enabled";
                if (_noteDC.EnableTrace.GetValueOrDefault())
                {
                    trace = "Dates,";
                    trace += Environment.NewLine + cm.ListDatesTab.ToCsv<DatesTab>();
                    trace += Environment.NewLine + "Rates,";
                    trace += Environment.NewLine + cm.ListRateTab.ToCsv<RateTab>();
                    trace += Environment.NewLine + "Balance,";
                    trace += Environment.NewLine + cm.ListBalanceTab.ToCsv<BalanceTab>();
                    trace += Environment.NewLine + "Fees,";
                    trace += Environment.NewLine + cm.ListFeesTab.ToCsv<FeesTab>();
                    trace += Environment.NewLine + "Coupon,";
                    trace += Environment.NewLine + cm.ListCouponTab.ToCsv<CouponTab>();
                    trace += Environment.NewLine + "PIK,";
                    trace += Environment.NewLine + cm.ListPIKInterestTab.ToCsv<PIKInterestTab>();
                    trace += Environment.NewLine + "GAAP Basis,";
                    trace += Environment.NewLine + cm.ListGAAPBasisTab.ToCsv<GAAPBasisTab>();
                    trace += Environment.NewLine + "Financing,";
                    trace += Environment.NewLine + cm.ListFinancingTab.ToCsv<FinancingTab>();
                }

                #endregion trace

                try
                {
                    if (objNote != null)
                    {
                        if (objNote.CRENoteID != null && objNote.CalculatorExceptionMessage == "Succeed")
                        {
                            _acationResult = new GenericResult()
                            {
                                Succeeded = true,
                                Message = "Calculation succeeded",
                                lstNotePeriodicOutputsDataContract = objNote.ListNotePeriodicOutputs,
                                ListOutputNPVdata = objNote.ListOutputNPVdata,
                                ListOutputAllTabData = objNote.ListOutputAllTabData,
                                Trace = trace,
                                ListCalcVal = objNote.ListCalcValues,
                                ListTransaction = objNote.ListTransaction,
                                CalculatorExceptionMessage = objNote.CalculatorExceptionMessage
                                //NoteData = objNote
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
                        Message = ExceptionHelper.GetFullMessage(ex)
                    };
                }
            }
            return Ok(_acationResult);
        }

        public NoteDataContract CalculateDataSaveInputAndOutput([FromBody] NoteDataContract _noteDC, Boolean isAllJsonParameter)
        {
            NoteDataContract ret_objNote = new NoteDataContract();

            NoteDataContract _noteDCCalculator = new NoteDataContract();
            NoteLogic _notelogic = new NoteLogic();

            Guid? UserID = null;
            int? pageIndex = 0;
            int? pageSize = 0;

            try
            {
                NoteDataContract objNote = new NoteDataContract();

                //set NoteDataContract for calculator input
                if (isAllJsonParameter)
                {
                    _noteDCCalculator = _noteDC;
                }
                else
                {
                    _noteDCCalculator = _notelogic.GetNoteAllDataForCalculatorByNoteId(_noteDC.NoteId, UserID, _noteDC.AnalysisID, pageIndex, pageSize);
                }

                #region ForDealAndNoteIDSave

                DealLogic _deallogic = new DealLogic();
                DealDataContract _dealDC = new DealDataContract();
                // Check and save deal if not exist
                _dealDC = _deallogic.GetDealByCREDealId(_noteDC.DealID); //check deal exist
                if (_dealDC == null)
                {
                    //Insert Deal
                    _dealDC = new DealDataContract();
                    _dealDC.CREDealID = _noteDC.DealID;

                    _dealDC.DealName = _noteDC.DealName;
                    if (_noteDC.DealName == null)
                    {
                        _dealDC.DealName = _noteDC.DealID;
                    }
                    string dealid_guid = _deallogic.InsertUpdateDeal(_dealDC);
                    _dealDC.DealID = new Guid(dealid_guid); //= _deallogic.GetDealByCREDealId(_noteDC.DealID); //check deal exist
                }
                NoteDataContract ndc = new NoteDataContract();
                _noteDC.NoteId = _notelogic.GetOrCreateNoteByCRENoteId(_noteDC.CRENoteID, _dealDC.DealID, _noteDC.CreatedBy);
                _noteDC.DealID = _dealDC.DealID.ToString();

                #endregion ForDealAndNoteIDSave

                SaveInputData(_noteDC, isAllJsonParameter, UserID);

                ////Start thread for saving input json.
                //Thread FirstThread = new Thread(() => SaveInputData(_noteDC, isAllJsonParameter, UserID));
                //FirstThread.Start();
                ////===================================

                #region Run Calculator

                if (_noteDC.SaveWithoutCalc.ToLower() == "y")
                {
                    //Do not calc
                }
                else
                {
                    CalculationMaster cm = new CalculationMaster();
                    objNote = cm.StartCalculation(_noteDCCalculator);
                }

                #endregion Run Calculator

                //Start thread for saving input json.
                Thread FirstThread = new Thread(() => SaveOutputData(_noteDC, isAllJsonParameter, objNote));
                FirstThread.Start();
                //===================================

                if (objNote != null)
                {
                    if (objNote.CRENoteID != null)
                    {
                        ret_objNote = objNote;
                    }
                    else
                    {
                        ret_objNote = objNote;
                    }
                }
                else
                {
                    ret_objNote = objNote;
                }
            }
            catch (Exception ex)
            {
                ret_objNote.CalculatorExceptionMessage = "Error in CalculateDataSaveInputAndOutput method - " + System.Environment.NewLine + "" + ex.InnerException;
            }

            return ret_objNote;
        }

        public void SaveInputData(NoteDataContract _noteDC, Boolean isAllJsonParameter, Guid? UserID)
        {
            NoteLogic _notelogic = new NoteLogic();

            #region Save json input

            if (isAllJsonParameter)
            {
                #region Save note master data

                List<NoteDataContract> lstNoteDC = new List<NoteDataContract> { _noteDC };
                string noteid_guid = _notelogic.AddUpdateNoteFromCalculatorService(UserID, lstNoteDC);

                _noteDC.NoteId = noteid_guid;

                #endregion Save note master data

                #region Save note additional list datatable2

                _notelogic.ExecDataTablewithtable(_noteDC, "usp_InsertUpdateNoteCalculatorJsonAdditinalList");

                _notelogic.InsertNoteTransactionDetail(_noteDC.ListServicingLogTab, _noteDC.NoteId, UserID.ToString());

                #endregion Save note additional list datatable2

                #region Commented : Save note additional list data

                //NoteAdditinalListDataContract _noteaddlistdc = new NoteAdditinalListDataContract();

                ////// List objects /////
                //_noteaddlistdc.lstRateSpreadSchedule = _noteDC.RateSpreadScheduleList;
                //_noteaddlistdc.lstStrippingSchedule = _noteDC.NoteStrippingList;
                //_noteaddlistdc.lstMaturity = _noteDC.MaturityScenariosList;
                //_noteaddlistdc.lstDefaultSchedule = _noteDC.NoteDefaultScheduleList;
                //_noteaddlistdc.lstNotePrepayFeeSchedule = _noteDC.NotePrepayAndAdditionalFeeScheduleList;
                //_noteaddlistdc.lstFutureFundingScheduleTab = _noteDC.ListFutureFundingScheduleTab;
                //_noteaddlistdc.lstPIKDetailScheduleTab = _noteDC.ListPIKfromPIKSourceNoteTab;
                //_noteaddlistdc.lstFeeCouponStripReceivableTab = _noteDC.ListFeeCouponStripReceivable;
                //_noteaddlistdc.lstLaborScheduleTab = _noteDC.ListLiborScheduleTab;
                //_noteaddlistdc.lstFixedAmortScheduleTab = _noteDC.ListFixedAmortScheduleTab;
                //_noteaddlistdc.lstServicingFeeSchedule = _noteDC.NoteServicingFeeScheduleList;
                //_noteaddlistdc.lstFinancingSchedule = _noteDC.NoteFinancingScheduleList;

                //NoteLogic _noteLogic = new NoteLogic();
                //int count = _noteLogic.AddUpdateNoteAdditinalList(UserID, _noteaddlistdc, UserID.ToString(), UserID.ToString());

                #endregion Commented : Save note additional list data
            }

            #endregion Save json input
        }

        public void SaveOutputData(NoteDataContract _noteDC, Boolean isAllJsonParameter, NoteDataContract objNote)
        {
            NoteLogic _notelogic = new NoteLogic();
            #region Save json output

            if (objNote.ListNotePeriodicOutputs != null)
            {
                foreach (var item in objNote.ListNotePeriodicOutputs)
                {
                    item.NoteID = new Guid(_noteDC.NoteId);
                    item.CreatedBy = _noteDC.CreatedBy;
                    item.UpdatedBy = _noteDC.UpdatedBy;
                }
                _notelogic.InsertNotePeriodicCalc(objNote.ListNotePeriodicOutputs);
                _notelogic.InsertInterestCalculator(objNote.ListInterestCalculator, _noteDC.NoteId, _noteDC.UpdatedBy);
            }


            if (objNote.ListCashflowTransactionEntry != null)
            {
                _notelogic.InsertCashflowTransaction(objNote.ListCashflowTransactionEntry, _noteDC.NoteId, _noteDC.UpdatedBy);
            }
            #endregion Save json output
        }

        public void CalculateMutipleNote(List<CalculationManagerDataContract> _lstCalcManagerDC)
        {
            var exceptions = new ConcurrentQueue<Exception>();

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
                                                          nl.InsertCashflowTransaction(objNote.ListCashflowTransactionEntry, _cmDC.NoteId, _noteDC.UpdatedBy);
                                                          CollectCalculatorLogs("15.Saving Process Ended for Cashflow Transactions: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);

                                                          nl.InsertInterestCalculator(objNote.ListInterestCalculator, _cmDC.NoteId, _noteDC.UpdatedBy);

                                                          if (_noteDC.AllowYieldConfigData == true)
                                                          {
                                                              CollectCalculatorLogs("Saving Process started for ListYieldCalcInput : noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                              nl.InsertYieldCalcInput(objNote.ListYieldCalcInput, _noteDC.UpdatedBy);
                                                              CollectCalculatorLogs("Saving Process Ended for ListYieldCalcInput: noteid ID ", _noteDC.NoteId.ToString(), _noteDC.CRENoteID, _noteDC.CollectCalculatorLogs);
                                                          }
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

                                                          if (objNote.ListDailyGAAPBasisComponents != null)
                                                          {
                                                              nl.InsertDailyGAAPBasisComponents(objNote.ListDailyGAAPBasisComponents, _cmDC.NoteId, _noteDC.UpdatedBy);

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

                                                      // calculate commitment data after note is calculated
                                                      CommitmentEquityHelper ce = new CommitmentEquityHelper();
                                                      _noteDC.ListCashflowTransactionEntry = objNote.ListCashflowTransactionEntry;
                                                      //List<NoteCommitmentEquityDataContract> calcNoteCommitmentdata = ce.calcNoteCommitment(_noteDC);
                                                      //calculationlogic.InsertNoteCommitmentDataFromCaluclator(calcNoteCommitmentdata);

                                                      DbEndtime = DateTime.Now;
                                                      EndTime = DateTime.Now;
                                                      int TotalMinutes = Convert.ToInt32(Math.Ceiling((EndTime - StartTime).TotalMinutes));

                                                      TotalTime = Convert.ToDecimal((EndTime - StartTime).TotalSeconds);
                                                      CalcProcessTime = Convert.ToDecimal((calcEndtime - calcStarttime).TotalSeconds);
                                                      DbProcessTime = DbProcessTime.GetValueOrDefault(0) + Convert.ToDecimal((DbEndtime - DbStarttime).TotalSeconds);

                                                      calculationlogic.UpdateCalculationTimeInMinByNoteID(new Guid(_noteDC.NoteId), TotalMinutes);

                                                      calculationlogic.InsertIntoCalculatorStatistics(_noteDC.NoteId.ToString(), CalcProcessTime, DbProcessTime, TotalTime, _cmDC.AnalysisID.ToString());
                                                      InsertUpdatedNoteWiseEndingBalance(new Guid(_noteDC.NoteId));

                                                  }
                                                  else
                                                  {
                                                      calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Failed", "EndTime", objNote.CalculatorExceptionMessage.ToString());
                                                      LoggerLogic Log = new LoggerLogic();
                                                      Log.WriteLogExceptionMessage(CRESEnums.Module.Calculator.ToString(), "Error in calculating note:: Note ID " + _noteDC.CRENoteID + " " + objNote.CalculatorstackTrace, _noteDC.NoteId.ToString(), "B0E6697B-3534-4C09-BE0A-04473401AB93", "StartCalculation", objNote.CalculatorExceptionMessage);
                                                  }
                                              }
                                              catch (Exception ex)
                                              {

                                                  string errormessage = LoggerHelper.GetExceptionString(ex);
                                                  calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Failed", "EndTime", errormessage);

                                                  LoggerLogic Log = new LoggerLogic();
                                                  Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in Saving outputs: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), "B0E6697B-3534-4C09-BE0A-04473401AB93", ex.TargetSite.Name.ToString(), "", ex);

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
                throw new AggregateException(exceptions);
            }
        }

        /// <summary>
        /// //////////
        /// </summary>
        [HttpGet]
        [Route("api/note/getcalcrequestcount-new")]
        public void GetCalcRequestCount()

        {
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                LoggerLogic Log = new LoggerLogic();

                int requestCount = calculationlogic.getCalcStatusByServerIndex(1);
                if (requestCount > 0)
                {

                    // Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Found loans for calulcation", "", "B0E6697B-3534-4C09-BE0A-04473401AB93");
                    List<CalculationManagerDataContract> list = calculationlogic.NotesListForCalculationByServerIndex(1);
                    if (list.Count > 0)
                    {
                        CalculateMutipleNote(list);
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
                    Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error while creating tag for batch", "", "B0E6697B-3534-4C09-BE0A-04473401AB93", ex.TargetSite.Name.ToString(), "", ex);
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error occurred while calculating multiple loans", "", "B0E6697B-3534-4C09-BE0A-04473401AB93", ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        [HttpGet]
        [Route("api/note/getcalcrequestcountbyserverindex-new")]
        public void GetCalcRequestCountByServerIndex(int ServerIndex)
        {
            try
            {
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                int requestCount = calculationlogic.getCalcStatusByServerIndex(ServerIndex);
                if (requestCount > 0)
                {
                    List<CalculationManagerDataContract> list = calculationlogic.NotesListForCalculationByServerIndex(ServerIndex);
                    if (list.Count > 0)
                    {
                        CalculateMutipleNote(list);
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
                    Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error while creating tag for batch ", "", "B0E6697B-3534-4C09-BE0A-04473401AB93", ex.TargetSite.Name.ToString(), "", ex);
                }

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error occurred while calculating multiple loans", "", "B0E6697B-3534-4C09-BE0A-04473401AB93", ex.TargetSite.Name.ToString(), "", ex);
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
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
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
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
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
                Log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), message + crenoteid + " ", noteid, "B0E6697B-3534-4C09-BE0A-04473401AB93");
            }
        }

        public void InsertUpdatedNoteWiseEndingBalance(Guid NoteID)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
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
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
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