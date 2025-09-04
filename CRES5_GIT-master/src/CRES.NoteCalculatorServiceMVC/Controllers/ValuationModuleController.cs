using CRES.BusinessLogic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Hosting;
using CRES.DataContract;
using System.Collections.Generic;
using System.ComponentModel;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using CRES.Utilities;
using System;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Xml.Linq;
using static Microsoft.Practices.EnterpriseLibrary.Common.Configuration.Design.CommonDesignTime;
using System.Data;
using System.IO;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class ValuationModuleController : Controller
    {
        private readonly IEmailNotification _iEmailNotification;
        private IHostingEnvironment _env;
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        public ValuationModuleController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }

        [HttpPost]
        [Route("api/ValuationModule/SaveDealList")]
        public IActionResult SaveDealList([FromBody] dynamic DealList)
        {
            LoggerLogic log = new LoggerLogic();
            string CalcAndSave = "";
            DateTime markdate = DateTime.MinValue;
            v1GenericResult _authenticationResult = null;
            try
            {
                string CreatedBy = "";
                List<ValuationModuleDealListDataContract> VMDealList = new List<ValuationModuleDealListDataContract>();
                for (var i = 0; i < DealList.Count; i++)
                {

                    ValuationModuleDealListDataContract VM = new ValuationModuleDealListDataContract();

                    VM.Calculate = DealList[i].Calculate;
                    VM.DealID = DealList[i].DealID;
                    VM.Scenario = DealList[i].Scenario;
                    if (VM.Scenario == "")
                    {
                        VM.Scenario = "Default";
                    }

                    VM.IndexType = DealList[i].IndexType;
                    VM.IndexForecast = CommonHelper.StringToDecimal(DealList[i].IndexForecast);
                    VM.IndexFloor = CommonHelper.StringToDecimal(DealList[i].IndexFloor);
                    VM.ExcludefromServerCalculation = DealList[i].ExcludefromServerCalculation;
                    VM.PORTFOLIO = DealList[i].PORTFOLIO;
                    VM.LastIndexReset = CommonHelper.StringToDecimal(DealList[i].LastIndexReset);
                    VM.PaymentDay = CommonHelper.ToInt32(DealList[i].PaymentDay);
                    VM.PriceCaptoThirdParty = CommonHelper.StringToDecimal(DealList[i].PriceCaptoThirdParty);
                    VM.DealNominalDMOrPriceForMark = CommonHelper.StringToDecimal(DealList[i].DealNominalDMOrPriceForMark);
                    VM.DMAdjustment = CommonHelper.StringToDecimal(DealList[i].DMAdjustment);
                    VM.StubInterestinAdvancelastaccrualDate = CommonHelper.ToDateTimeWithMinValue(DealList[i].StubInterestinAdvancelastaccrualDate);
                    VM.IOValuationmo = CommonHelper.StringToDecimal(DealList[i].IOValuationmo);
                    VM.PendingPayoff = CommonHelper.StringToDecimal(DealList[i].PendingPayoff);
                    VM.PpayAdjustedAL = CommonHelper.StringToDecimal(DealList[i].PpayAdjustedAL);

                    VM.MaterialMezz = DealList[i].MaterialMezz;
                    VM.SliverMezz = DealList[i].SliverMezz;
                    VM.CreatedBy = DealList[i].CreatedBy;
                    VM.UserID = DealList[i].CreatedBy;
                    VM.MarkedDate = CommonHelper.ToDateTime(DealList[i].MarkedDate);
                    markdate = VM.MarkedDate.Value;
                    VM.IsCashFlowLive = DealList[i].UseLiveCashflowData;

                    CalcAndSave = DealList[i].CalcAndSave;
                    CreatedBy = DealList[i].CreatedBy;
                    VMDealList.Add(VM);
                }
                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.SaveDealList(VMDealList, CreatedBy);
                vml.InsertCashFlowDataIntoValCashflowData(markdate, CreatedBy);

                vml.InsertSECMastHolding(Convert.ToDateTime(markdate), CreatedBy);
                vml.InsertProjectedPayoffCalc(markdate, CreatedBy);

                if (CalcAndSave.ToLower() == "true")
                {
                    QueueDealsForValuationCalculation(VMDealList);
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved SaveDealList ", "", useridforSys_Scheduler);
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in SaveDealList ", "", useridforSys_Scheduler, "SaveDealList", "", ex);
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/SaveGlobalAndPricingData")]
        public IActionResult SaveGlobalAndPricingData([FromBody] dynamic inputjson)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            string Actiontype = "ImportbuttonClick";

            ValuationModuleLogic Vmlogic = new ValuationModuleLogic();
            try
            {

                ValuationMasterDataContract vm = new ValuationMasterDataContract();

                vm.UseDurSpreadVolWt = inputjson["UseDurSpreadVolWt"];
                vm.GAAPBasisInputsIncludeAccrued = Convert.ToString(inputjson["GAAPBasisInputsIncludeAccrued"]);
                vm.MinimumExcessIOCredit = CommonHelper.ToInt32(inputjson["MinimumExcessIOCredit"]);
                vm.PercentageofFloorValueincludedinMark = CommonHelper.StringToDecimal(inputjson["PercentageofFloorValueincludedinMark"]);
                vm.MarkedDate = CommonHelper.ToDateTime(inputjson["MarkedDate"]);
                vm.FloorIndexDate = CommonHelper.ToDateTime(inputjson["FloorIndexDate"]);
                Actiontype = inputjson["ActionType"];
                vm.CreatedBy = inputjson["CreatedBy"];
                vm.CalcAndSave = inputjson["CalcAndSave"];
                vm.PricingGridKey = inputjson["PricingGridKey"];
                vm.PricingGridMarketSOFRFloor = CommonHelper.StringToDecimal(inputjson["PricingGridMarketSOFRFloor"]);
                vm.LIBORForecast = CommonHelper.StringToDecimal(inputjson["LIBORForecast"]);

                Vmlogic.InsertUpdatedMarkedDateMaster(vm.MarkedDate, vm.CreatedBy);
                Vmlogic.InsertUpdateGobalSetup(vm);

                //code moved to save deal list method
                //Vmlogic.InsertSECMastHolding(Convert.ToDateTime(vm.MarkedDate), vm.CreatedBy);
                //Vmlogic.InsertProjectedPayoffCalc(vm.MarkedDate.Value, vm.CreatedBy);

                if (Actiontype == "")
                {
                    var PricingGridjson = inputjson["PricingGridList"];
                    List<ValuationModuleCurrentGridDataContract> PricingGridList = new List<ValuationModuleCurrentGridDataContract>();
                    for (var i = 0; i < PricingGridjson.Count; i++)
                    {
                        ValuationModuleCurrentGridDataContract vm1 = new ValuationModuleCurrentGridDataContract();

                        vm1.MarkedDate = PricingGridjson[i].MarkedDate;
                        vm1.PropertyType = PricingGridjson[i].PropertyType;
                        vm1.DealType = (PricingGridjson[i].DealType);
                        vm1.AnoteLTV = CommonHelper.StringToDecimal(PricingGridjson[i].AnoteLTV);
                        vm1.AnoteSpread = CommonHelper.StringToDecimal(PricingGridjson[i].AnoteSpread);
                        vm1.ABwholeLoanLTV = CommonHelper.StringToDecimal(PricingGridjson[i].ABwholeLoanLTV);
                        vm1.ABwholeLoanSpread = CommonHelper.StringToDecimal(PricingGridjson[i].ABwholeLoanSpread);
                        vm1.EquityLTV = CommonHelper.StringToDecimal(PricingGridjson[i].EquityLTV);
                        vm1.EquityYield = CommonHelper.StringToDecimal(PricingGridjson[i].EquityYield);
                        vm1.UserID = PricingGridjson[i].UserdID;

                        PricingGridList.Add(vm1);
                    }
                    var PricingGridFeeAssumptionsjson = inputjson["PricingGridFeeAssumptionsList"];
                    List<ValuationPricingGridFeeAssumptionsListDataContract> PricingGridFeeAssumptionsList = new List<ValuationPricingGridFeeAssumptionsListDataContract>();
                    for (var i = 0; i < PricingGridFeeAssumptionsjson.Count; i++)
                    {
                        ValuationPricingGridFeeAssumptionsListDataContract vm1 = new ValuationPricingGridFeeAssumptionsListDataContract();

                        vm1.MarkedDate = PricingGridFeeAssumptionsjson[i].MarkedDate;
                        vm1.ValueType = PricingGridFeeAssumptionsjson[i].ValueType;
                        vm1.Nonconstruction = CommonHelper.StringToDecimal(PricingGridFeeAssumptionsjson[i].Nonconstruction);
                        vm1.Construction = CommonHelper.StringToDecimal(PricingGridFeeAssumptionsjson[i].Construction);
                        vm1.UserID = PricingGridFeeAssumptionsjson[i].UserdID;

                        PricingGridFeeAssumptionsList.Add(vm1);
                    }
                    var PricingGridMappingMasterJson = inputjson["PricingGridMappingMasterList"];
                    List<PricingGridMappingMasterListDataContract> PricingGridMappingMasterList = new List<PricingGridMappingMasterListDataContract>();
                    for (var i = 0; i < PricingGridMappingMasterJson.Count; i++)
                    {
                        PricingGridMappingMasterListDataContract vm1 = new PricingGridMappingMasterListDataContract();

                        vm1.MarkedDate = PricingGridMappingMasterJson[i].MarkedDate;
                        vm1.DealTypeName = PricingGridMappingMasterJson[i].DealTypeName;
                        vm1.DealTypeMapping = PricingGridMappingMasterJson[i].DealTypeMapping;
                        vm1.UserID = PricingGridMappingMasterJson[i].UserdID;

                        PricingGridMappingMasterList.Add(vm1);
                    }

                    var FloorValueMasterJson = inputjson["ListFloorValueMaster"];
                    List<FloorValueMasterDataContract> ListFloorValueMaster = new List<FloorValueMasterDataContract>();
                    for (var i = 0; i < FloorValueMasterJson.Count; i++)
                    {
                        FloorValueMasterDataContract vm1 = new FloorValueMasterDataContract();

                        vm1.IndexTypeName = FloorValueMasterJson[i].IndexTypeName;
                        vm1.MarkedDate = FloorValueMasterJson[i].MarkedDate;
                        vm1.CurrentMarketLoanFloor = CommonHelper.StringToDecimal(FloorValueMasterJson[i].CurrentMarketLoanFloor);
                        vm1.Term = CommonHelper.StringToDecimal(FloorValueMasterJson[i].Term);
                        vm1.LoanFloor = CommonHelper.StringToDecimal(FloorValueMasterJson[i].LoanFloor);
                        vm1.CreatedBy = FloorValueMasterJson[i].CreatedBy;
                        ListFloorValueMaster.Add(vm1);
                    }
                    var FloorValueDetailJson = inputjson["ListFloorValueDetail"];
                    List<FloorValueDetailDataContract> ListFloorValueDetail = new List<FloorValueDetailDataContract>();
                    if (FloorValueDetailJson != null)
                    {
                        for (var i = 0; i < FloorValueDetailJson.Count; i++)
                        {
                            if (FloorValueDetailJson[i] != null)
                            {
                                FloorValueDetailDataContract vm1 = new FloorValueDetailDataContract();

                                vm1.IndexTypeName = FloorValueDetailJson[i].IndexTypeName;
                                vm1.MarkedDate = FloorValueDetailJson[i].MarkedDate;
                                vm1.Percentage = CommonHelper.StringToDecimal(FloorValueDetailJson[i].Percentage);
                                vm1.Month = CommonHelper.StringToDecimal(FloorValueDetailJson[i].Month);
                                vm1.Value = CommonHelper.StringToDecimal(FloorValueDetailJson[i].Value);
                                vm1.CreatedBy = FloorValueDetailJson[i].CreatedBy;
                                vm1.UserID = FloorValueDetailJson[i].CreatedBy;
                                ListFloorValueDetail.Add(vm1);
                            }
                        }
                    }

                    Vmlogic.DeleteFloorValue(vm.MarkedDate);
                    Vmlogic.InsertUpdatedFloorValue(ListFloorValueMaster);
                    Vmlogic.InsertUpdatedFloorByTerm(ListFloorValueDetail);

                    Vmlogic.InsertUpdatedPricingGrid(PricingGridList);
                    Vmlogic.InsertUpdatedPricingGridFeeAssumptions(PricingGridFeeAssumptionsList);

                    Vmlogic.InsertUpdatePricingGridMappingMaster(PricingGridMappingMasterList);
                }

                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved SaveGlobalAndPricingData ", "", useridforSys_Scheduler);
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in SaveGlobalAndPricingData ", "", useridforSys_Scheduler, "SaveDealList", "", ex);
            }

            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Route("api/ValuationModule/saveValuationOutput")]
        public IActionResult SaveValuationOutput([FromBody] dynamic ValuationOutput)
        {
            LoggerLogic log = new LoggerLogic();
            string dealid = "";
            string userid = "";
            DateTime? MarkedDate = DateTime.MinValue;
            v1GenericResult _authenticationResult = null;
            ValuationModuleLogic vml = new ValuationModuleLogic();

            try
            {
                List<ValuationDealOutputDataContract> ListDealOutput = new List<ValuationDealOutputDataContract>();
                var ValuationDealOutputJson = ValuationOutput["ListDealoutput"];
                for (var i = 0; i < ValuationDealOutputJson.Count; i++)
                {
                    ValuationDealOutputDataContract vd = new ValuationDealOutputDataContract();

                    vd.DealID = ValuationDealOutputJson[i].DealID;
                    dealid = vd.DealID;
                    vd.CalculationStatus = "Completed";
                    vd.LastCalculatedon = DateTime.Now;

                    vd.MarkedDate = CommonHelper.ToDateTime(ValuationDealOutputJson[i].MarkedDate);
                    MarkedDate = CommonHelper.ToDateTime(ValuationDealOutputJson[i].MarkedDate);
                    vd.PayoffExtended = CommonHelper.ToInt16_NotNullable(ValuationDealOutputJson[i].PayoffExtended);

                    vd.DealMarkPriceClean = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealMarkPriceClean);
                    vd.DealGAAPPriceClean = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealGAAPPriceClean);
                    vd.DealMarkClean = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealMarkClean);
                    vd.DealUPB = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealUPB);
                    vd.DealCommitment = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealCommitment);
                    vd.DealGAAPBasisDirty = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealGAAPBasisDirty);
                    vd.DealYieldatParClean = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealYieldatParclean);
                    vd.DealYieldatGAAPBasis = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealYieldatGAAPBasis);
                    vd.DealMarkYield = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealMarkYield);
                    vd.CalculatedDealAccruedRate = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].CalculatedDealAccruedRate);
                    vd.DealGAAPDM_GtrFLR_Index = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealGAAPDMIndex);
                    vd.DealMarkDM_GtrFLR_Index = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealMarkDMgtrFLRIndex);
                    vd.DealDuration_OnCommitment = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DealDurationonCommitment);
                    vd.GrossFloorValuefromGrid = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].GrossFloorValuefromGrid);
                    vd.GrossValue_UsageScalar = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].GrossValueUsageScalar);
                    vd.DollarValueofFloorinMark = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DollarValueofFloorinMark);
                    vd.PointvalueofFloorinMark = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].PointvalueofFloorinMark);
                    vd.Term = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].Termmo);
                    vd.Strike = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DLStrike);
                    vd.MktStrike = CommonHelper.StringToDecimalWithRound(ValuationDealOutputJson[i].DLMktStrike);

                    vd.UserID = ValuationDealOutputJson[i].CreatedBy;
                    userid = vd.UserID;
                    ListDealOutput.Add(vd);
                }
                List<ValuationNoteOutputDataContract> ListNoteOutputData = new List<ValuationNoteOutputDataContract>();

                var NoteoutputJson = ValuationOutput["ListNoteoutput"];
                for (var i = 0; i < NoteoutputJson.Count; i++)
                {
                    ValuationNoteOutputDataContract VN = new ValuationNoteOutputDataContract();
                    VN.DealID = NoteoutputJson[i].DealID;
                    VN.NoteID = NoteoutputJson[i].DLNoteID;
                    VN.CalculationStatus = "Completed";

                    VN.MarkedDate = CommonHelper.ToDateTime(NoteoutputJson[i].MarkedDate);

                    VN.NoteMarkPriceClean = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteMarkPriceClean);
                    VN.NoteGAAPPriceClean = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteGAAPPriceClean);
                    VN.NoteUPB = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteUPB);
                    VN.NoteMarkClean = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteMarkClean);
                    VN.NoteCommitment = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteCommitment);
                    VN.NoteBasisDirty = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteBasisDirty);
                    VN.NoteYieldatGAAPBasis = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteYieldatGAAPBasis);
                    VN.CalculatedNoteAccruedRate = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].CalculatedNoteAccruedRate);
                    VN.NoteGAAPDMIndex = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteGAAPDMIndex);
                    VN.NoteMarkYield = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteMarkYield);
                    VN.NoteMarkDMgtrFLRIndex = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteMarkDMgtrFLRIndex);
                    VN.NoteDurationonCommitment = CommonHelper.StringToDecimalWithRound(NoteoutputJson[i].NoteDurationonCommitment);

                    VN.UserID = NoteoutputJson[i].UserID;
                    ListNoteOutputData.Add(VN);
                }
                vml.updateCalcStatus(0, dealid, "Completed", "EndTime", "", userid, MarkedDate);
                vml.InsertUpdatedDealOutput(ListDealOutput);
                vml.InsertUpdatedNoteOutput(ListNoteOutputData);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved from server file SaveValuationOutput  ", dealid, useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                vml.updateCalcStatus(0, dealid, "Failed", "EndTime", ex.StackTrace, userid, MarkedDate);
                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Data Saved from server file SaveValuationOutput ", dealid, "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50", "SaveValuationOutput", "", ex);
            }

            return Ok(_authenticationResult);
        }


        [HttpGet]
        [Route("api/ValuationModule/CheckValuation")]
        public void CheckValuation()
        {
            //List<ValuationDealOutputDataContract> ListDealoutput = new List<ValuationDealOutputDataContract>();
            //ValuationDealOutputDataContract vd = new ValuationDealOutputDataContract();
            //vd.DealID = "19-028";
            //vd.DealMarkClean = 2m;

            //ListDealoutput.Add(vd);
            //ListDealoutput.Add(vd);

            //List<ValuationNoteOutputDataContract> ListNoteoutput = new List<ValuationNoteOutputDataContract>();

            //ValuationNoteOutputDataContract VN = new ValuationNoteOutputDataContract();
            //VN.NoteID = "2304";
            //VN.DealID = "19-028";
            //ListNoteoutput.Add(VN);
            //ListNoteoutput.Add(VN);

            //ValuationMasterDataContract Vm = new ValuationMasterDataContract();

            //Vm.MarkedDate = DateTime.Now;
            //Vm.ListDealoutput = ListDealoutput;
            //Vm.ListNoteoutput = ListNoteoutput;

            //var Resultjson = JsonConvert.SerializeObject(Vm);
            ValuationModuleLogic vml = new ValuationModuleLogic();
            vml.SendValuationDealsForReCalc();


        }


        [HttpGet]
        [Route("api/ValuationModule/CheckApiHealth")]
        public IActionResult CheckApiHealth()
        {
            v1GenericResult _authenticationResult = null;
            try
            {

                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
                LoggerLogic log = new LoggerLogic();
                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Valuation api CheckApiHealth called ", "", "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50");

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
            }
            return Ok(_authenticationResult);
        }

        public IActionResult QueueDealsForValuationCalculation(List<ValuationModuleDealListDataContract> DealList)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {

                List<ValuationModuleDealListDataContract> DealListForCalculation = new List<ValuationModuleDealListDataContract>();
                foreach (var item in DealList)
                {
                    if (item.Calculate != null)
                    {
                        if (item.Calculate.ToLower() == "yes")
                        {
                            DealListForCalculation.Add(item);

                        }
                    }
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.QueueDealsForValuationCalculation(DealListForCalculation);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved QueueDealsForValuationCalculation ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in QueueDealsForValuationCalculation ", "", useridforSys_Scheduler, "QueueDealsForValuationCalculation", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/ArchiveValuationOutputData")]
        public IActionResult ArchiveValuationOutputData([FromBody] dynamic inputjson)
        {
            DateTime MarkedDate = DateTime.MinValue;
            string UserID = "";
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                MarkedDate = inputjson["MarkedDate"];
                UserID = inputjson["CreatedBy"];

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.ArchiveValuationOutputData(MarkedDate, UserID);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved ArchiveValuationOutputData ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedProjectedPayoffCalc ", "", useridforSys_Scheduler, "SaveDealList", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/LogDataFromServerFile")]
        public IActionResult LogDataFromServerFile([FromBody] dynamic inputjson)
        {
            string LogType = "";
            string Message = "";
            string dealID = "";
            DateTime? MarkedDate = DateTime.MinValue;
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                LogType = inputjson["LogType"];
                Message = inputjson["Message"];
                dealID = inputjson["DealID"];
                MarkedDate = CommonHelper.ToDateTime(inputjson["MarkedDate"]);

                if (Message.Contains("Data loading Starting") == true)
                {
                    ValuationModuleLogic vml = new ValuationModuleLogic();
                    vml.updateCalcStatus(0, dealID, "Running", "StartTime", "", useridforSys_Scheduler, MarkedDate);
                }

                if (LogType == "Info")
                {
                    log.WriteLogInfo(CRESEnums.Module.ValuationServer.ToString(), Message, dealID, useridforSys_Scheduler, "LogDataFromServerFile");
                }
                else
                {
                    if (Message.Contains("No Data to Calculate") == true)
                    {
                        ValuationModuleLogic vml = new ValuationModuleLogic();
                        vml.updateCalcStatus(0, dealID, "Failed", "EndTime", "Deal skipped from calculation as there is no data in projected payoff tab or sec master holding tab.", useridforSys_Scheduler, MarkedDate);
                        log.WriteLogExceptionMessage(CRESEnums.Module.ValuationServer.ToString(), "Error in server file ", dealID, useridforSys_Scheduler, "LogDataFromServerFile", Message);
                    }
                    else
                    {
                        ValuationModuleLogic vml = new ValuationModuleLogic();
                        vml.updateCalcStatus(0, dealID, "Failed", "EndTime", Message, useridforSys_Scheduler, MarkedDate);
                        log.WriteLogExceptionMessage(CRESEnums.Module.ValuationServer.ToString(), "Error in server file ", dealID, useridforSys_Scheduler, "LogDataFromServerFile", Message);
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
            catch (Exception ex)
            {

                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in LogDataFromServerFile ", "", useridforSys_Scheduler, "SaveDealList", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/InsertUpdatedNoteMatrix")]
        public IActionResult InsertUpdatedNoteMatrix([FromBody] dynamic NoteMatrixList)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {

                List<ValuationNoteMatrixDataContract> VmNoteMatrix = new List<ValuationNoteMatrixDataContract>();
                for (var i = 0; i < NoteMatrixList.Count; i++)
                {

                    ValuationNoteMatrixDataContract VM = new ValuationNoteMatrixDataContract();

                    VM.MarkedDate = CommonHelper.ToDateTime(NoteMatrixList[i].MarkedDate);

                    VM.NoteMatrixSheetName = (NoteMatrixList[i].NoteMatrixSheetName);
                    VM.DealID = (NoteMatrixList[i].DealID);
                    VM.DealGroupID = (NoteMatrixList[i].DealGroupID);
                    VM.NoteID = (NoteMatrixList[i].NoteID);
                    VM.DealName = (NoteMatrixList[i].DealName);
                    VM.NoteName = (NoteMatrixList[i].NoteName);
                    VM.Commitment = CommonHelper.StringToDecimal(NoteMatrixList[i].Commitment);
                    VM.InitialFunding = CommonHelper.ToDateTime(NoteMatrixList[i].InitialFunding);
                    VM.CurrentMaturity_Date = CommonHelper.ToDateTime(NoteMatrixList[i].CurrentMaturity_Date);
                    VM.OriginationFee = CommonHelper.StringToDecimal(NoteMatrixList[i].OriginationFee);
                    VM.ExtensionFee1 = CommonHelper.StringToDecimal(NoteMatrixList[i].ExtensionFee1);
                    VM.ExtensionFee2 = CommonHelper.StringToDecimal(NoteMatrixList[i].ExtensionFee2);
                    VM.ExtensionFee3 = CommonHelper.StringToDecimal(NoteMatrixList[i].ExtensionFee3);
                    VM.ExitFee = CommonHelper.StringToDecimal(NoteMatrixList[i].ExitFee);
                    VM.ProductType = (NoteMatrixList[i].ProductType);
                    VM.AcoreOrig = CommonHelper.StringToDecimal(NoteMatrixList[i].AcoreOrig);
                    VM.UserID = (NoteMatrixList[i].CreatedBy);

                    VmNoteMatrix.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdatedNoteMatrixData(VmNoteMatrix);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdatedNoteMatrix ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedNoteMatrix ", "", useridforSys_Scheduler, "SaveDealList", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/InsertUpdateNoteCashflowOverride")]
        public IActionResult InsertUpdateNoteCashflowOverride([FromBody] dynamic NoteCashflowOverrideList)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                List<ValuationNoteCashFlowDataContract> VmNoteList = new List<ValuationNoteCashFlowDataContract>();
                for (var i = 0; i < NoteCashflowOverrideList.Count; i++)
                {
                    ValuationNoteCashFlowDataContract VM = new ValuationNoteCashFlowDataContract();
                    VM.NoteCashFlowID = CommonHelper.ToInt32(NoteCashflowOverrideList[i].NoteCashFlowID);
                    VM.MarkedDate = CommonHelper.ToDateTime(NoteCashflowOverrideList[i].MarkedDate);
                    VM.ValueOverride = CommonHelper.StringToDecimal(NoteCashflowOverrideList[i].ValueOverride);
                    VM.UserID = (NoteCashflowOverrideList[i].UserID);
                    VmNoteList.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdateNoteCashflowOverride(VmNoteList);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdateNoteCashflowOverride ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedProjectedPayoffCalc ", "", useridforSys_Scheduler, "SaveDealList", "", ex);
            }

            return Ok(_authenticationResult);
        }


        //start index
        public string StartStopAzureVM(string actiontype, string vmname)
        {
            string status = "";
            try
            {
                string constantUrl = "https://vm-valuation-powerfunction.azurewebsites.net/api/HttpTrigger1?code=";
                string secretcode = "Sp7EuZqNsJjp1dMIrQoxYuJiHyLURiw31Dhlm5WqVqo7AzFuCxsu_g==";
                string resourcegroup = "NONPROD-ACOREVALUATION";
                // string vmname = "NonProdExcelServer01";

                string Url = constantUrl + secretcode + "&resourcegroup=" + resourcegroup + "&vm=" + vmname + "&action=" + actiontype;
                ValuationModuleLogic vml = new ValuationModuleLogic();
                var res = (vml.StartStopVirtualMachine(Url));

                if (res.Contains("AzureError") == false)
                {
                    if (actiontype == "get")
                    {
                        JArray CalcResponse = JArray.Parse(res);
                        for (var i = 0; i < CalcResponse.Count; i++)
                        {
                            if (CalcResponse[i]["Name"].ToString() == vmname)
                            {
                                status = CalcResponse[i]["PowerState"].ToString();
                            }
                        }
                    }
                    else if (actiontype == "start" || actiontype == "stop")
                    {
                        dynamic CalcResponse = JObject.Parse(res);
                    }
                }
                else
                {
                    // to code for error
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return status;
        }


        [HttpGet]
        [Route("api/ValuationModule/CheckAndStartStopAzureVM")]
        public IActionResult CheckAndStartStopAzureVM()
        {
            int? Failed = 0;
            int? Completed = 0;
            int? Running = 0;
            int? Processing = 0;

            v1GenericResult _authenticationResult = null;
            string status = "";
            LoggerLogic log = new LoggerLogic();
            //string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
            try
            {
                ValuationModuleLogic vml = new ValuationModuleLogic();
                DataTable dt = vml.GetValuationRequestsCount();

                //Failed Completed Running Processing

                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["Name"].ToString() == "Failed")
                    {
                        Failed = CommonHelper.ToInt32(dr["Count"]);
                    }
                    if (dr["Name"].ToString() == "Completed")
                    {
                        Completed = CommonHelper.ToInt32(dr["Count"]);
                    }
                    if (dr["Name"].ToString() == "Running")
                    {
                        Running = CommonHelper.ToInt32(dr["Count"]);
                    }
                    if (dr["Name"].ToString() == "Processing")
                    {
                        Processing = CommonHelper.ToInt32(dr["Count"]);
                    }
                }
                if (Processing > 0)
                {
                    //start the servers
                    DataTable VMMasterData = vml.GetVMMasterData();
                    foreach (DataRow dr in VMMasterData.Rows)
                    {
                        //"VM deallocating"
                        string vmstatus = StartStopAzureVM("get", dr["VMName"].ToString());

                        if (vmstatus == "VM deallocating" || vmstatus == "VM deallocated")
                        {
                            StartStopAzureVM("start", dr["VMName"].ToString());
                            vml.UpdatedVMMaster(dr["VMName"].ToString(), "START");
                            log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), dr["VMName"].ToString() + " : VM started ", "", useridforSys_Scheduler);
                        }
                    }
                }
                else if ((Running + Processing) == 0)
                {
                    DataTable VMMasterData = vml.GetVMMasterData();
                    foreach (DataRow dr in VMMasterData.Rows)
                    {
                        string vmstatus = StartStopAzureVM("get", dr["VMName"].ToString());
                        if (vmstatus == "VM running")
                        {
                            StartStopAzureVM("stop", dr["VMName"].ToString());
                            vml.UpdatedVMMaster(dr["VMName"].ToString(), "STOP");
                            log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), dr["VMName"].ToString() + " :Azure VM stoped ", "", useridforSys_Scheduler);
                        }
                    }
                    vml.SendValuationDealsForReCalc();
                    CheackAndSendValuationAfterCalcEmail();

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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in CheckAndCallDealsForCalculation " + ex.Message, "", useridforSys_Scheduler, "CalculateAllDeals", "", ex);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };


            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/ValuationModule/CheackAndSendValuationAfterCalcEmail")]
        public IActionResult CheackAndSendValuationAfterCalcEmail()
        {
            int? Running = 0;
            int? Processing = 0;
            LoggerLogic log = new LoggerLogic();
            try
            {
                {
                    ValuationModuleLogic vml = new ValuationModuleLogic();
                    DataTable dt1 = vml.GetValuationRequestsCount();
                    //Running Processing
                    foreach (DataRow dr in dt1.Rows)
                    {
                        if (dr["Name"].ToString() == "Running")
                        {
                            Running = CommonHelper.ToInt32(dr["Count"]);
                        }
                        if (dr["Name"].ToString() == "Processing")
                        {
                            Processing = CommonHelper.ToInt32(dr["Count"]);
                        }
                    }

                    if ((Running + Processing) == 0)
                    {
                        DataTable dt = vml.GetValuationRequestsDataForEmail();
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            MemoryStream ms = GetStreamfromDatatable(dt);
                            string randomstring = DateTime.Now.ToString("MM_dd_yyyy_hhmmss");
                            _iEmailNotification.SendValuationAfterCalculationEmail(dt, ms, "Valuation_Calculation _Summary_" + randomstring + ".xlsx");
                            vml.UpdateEmailSentToYes();
                            log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Valuation After Calc Email sent successfully", "", useridforSys_Scheduler);

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in CheackAndSendValuationAfterCalcEmail " + ex.Message, "", useridforSys_Scheduler, "CheackAndSendValuationAfterCalcEmail", "", ex);
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError, ex);
            }
            return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status200OK, "Email Sent");
        }

        public MemoryStream GetStreamfromDatatable(DataTable dt)
        {
            dt.TableName = "Calculation_Summary";
            Stream ms = new MemoryStream();
            DataSet ds = new DataSet();
            ds.Tables.Add(dt);
            Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "Valuation_Calculation _Summary.xlsx").BaseStream;
            ms = WriteDataToExcel.DataSetToExcel(ds, stream);
            return (MemoryStream)ms;
        }

        [HttpGet]
        [Route("api/ValuationModule/RestartinactiveAzureVM")]
        public IActionResult RestartinactiveAzureVM()
        {
            v1GenericResult _authenticationResult = null;
            string status = "";
            LoggerLogic log = new LoggerLogic();

            try
            {
                ValuationModuleLogic vml = new ValuationModuleLogic();
                DataTable VMMasterData = vml.GetIdealVMMachine();
                foreach (DataRow dr in VMMasterData.Rows)
                {
                    StartStopAzureVM("stop", dr["VMName"].ToString());
                    vml.UpdatedVMMaster(dr["VMName"].ToString(), "STOP");
                    log.WriteLogInfo(CRESEnums.Module.ValuationModuleAutoMation.ToString(), dr["VMName"].ToString() + " :Azure VM stoped due to inactivity", "", useridforSys_Scheduler);

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

                log.WriteLogException(CRESEnums.Module.ValuationModuleAutoMation.ToString(), "Error in RestartinactiveAzureVM " + ex.Message, "", useridforSys_Scheduler, "CalculateAllDeals", "", ex);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };

            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Route("api/ValuationModule/InsertUpdateNotesWeight")]
        public IActionResult InsertUpdateNotesWeight([FromBody] dynamic NotesWeightList)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                List<ValuationNotesWeightDataContract> VmNoteList = new List<ValuationNotesWeightDataContract>();
                for (var i = 0; i < NotesWeightList.Count; i++)
                {
                    ValuationNotesWeightDataContract VM = new ValuationNotesWeightDataContract();
                    VM.MarkedDate = CommonHelper.ToDateTime(NotesWeightList[i].MarkedDate);
                    VM.PropertyType = NotesWeightList[i].PropertyType;
                    VM.Header = NotesWeightList[i].Header;
                    VM.SortOrder = CommonHelper.ToInt32(NotesWeightList[i].SortOrder);
                    VM.Value = CommonHelper.StringToDecimal(NotesWeightList[i].Value);
                    VM.UserID = (NotesWeightList[i].UserID);
                    VmNoteList.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdateNotesWeight(VmNoteList);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdateNotesWeight ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedsWeight ", "", useridforSys_Scheduler, "SaveNotesWeight", "", ex);
            }

            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Route("api/ValuationModule/InsertUpdateAdjustedLTVs")]
        public IActionResult InsertUpdateAdjustedLTVs([FromBody] dynamic AdjustedLTVs)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                List<ValuationAdjustedLTVDataContract> VmList = new List<ValuationAdjustedLTVDataContract>();
                for (var i = 0; i < AdjustedLTVs.Count; i++)
                {
                    ValuationAdjustedLTVDataContract VM = new ValuationAdjustedLTVDataContract();
                    VM.MarkedDate = CommonHelper.ToDateTime(AdjustedLTVs[i].MarkedDate);
                    VM.CREDealID = Convert.ToString(AdjustedLTVs[i].CREDealID);
                    VM.CREDealName = Convert.ToString(AdjustedLTVs[i].CREDealName);
                    VM.FundedDate = CommonHelper.ToDateTime(AdjustedLTVs[i].FundedDate);
                    VM.TotalCommitment = CommonHelper.StringToDecimal(AdjustedLTVs[i].TotalCommitment);
                    VM.AsStabilizedAppraisal = CommonHelper.StringToDecimal(AdjustedLTVs[i].AsStabilizedAppraisal);
                    VM.PropertyType = Convert.ToString(AdjustedLTVs[i].PropertyType);
                    VM.ValueDecline = CommonHelper.StringToDecimal(AdjustedLTVs[i].ValueDecline);
                    VM.AdjustedAsStabilizedValue = CommonHelper.StringToDecimal(AdjustedLTVs[i].AdjustedAsStabilizedValue);
                    VM.RecourseCurrent = CommonHelper.StringToDecimal(AdjustedLTVs[i].RecourseCurrent);
                    VM.AdjustedAsStabilizedValuewithRecourse = CommonHelper.StringToDecimal(AdjustedLTVs[i].AdjustedAsStabilizedValuewithRecourse);
                    VM.AdjustedAsStabilizedLTV = CommonHelper.StringToDecimal(AdjustedLTVs[i].AdjustedAsStabilizedLTV);
                    VM.UnadjustedAsStabilizedLTV = CommonHelper.StringToDecimal(AdjustedLTVs[i].UnadjustedAsStabilizedLTV);

                    VM.UserID = Convert.ToString(AdjustedLTVs[i].UserID);
                    VmList.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdateAdjustedLTVs(VmList);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdateAdjustedLTVs ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdateAdjustedLTVs ", "", useridforSys_Scheduler, "InsertUpdateAdjustedLTVs", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/InsertUpdatedNoteList")]
        public IActionResult InsertUpdatedNoteList([FromBody] dynamic NoteList)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                List<ValuationNoteListDataContract> VmNoteList = new List<ValuationNoteListDataContract>();
                for (var i = 0; i < NoteList.Count; i++)
                {
                    ValuationNoteListDataContract VM = new ValuationNoteListDataContract();
                    VM.MarkedDate = CommonHelper.ToDateTime(NoteList[i].MarkedDate);

                    VM.CREDealID = NoteList[i].CREDealID;
                    VM.CREDealName = NoteList[i].CREDealName;
                    VM.NoteID = NoteList[i].NoteID;
                    VM.NoteNominalDMOrPriceForMark = CommonHelper.StringToDecimal(NoteList[i].NoteNominalDMOrPriceForMark);
                    VM.UserID = (NoteList[i].UserID);
                    VmNoteList.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdatedNoteList(VmNoteList);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdatedNoteList ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedNoteList ", "", useridforSys_Scheduler, "InsertUpdatedNoteList", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/InsertUpdateValueDeclineByPropertyType")]
        public IActionResult InsertUpdateValueDeclineByPropertyType([FromBody] dynamic ListType)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                List<ValuationValueDeclineDataContract> VmNoteList = new List<ValuationValueDeclineDataContract>();
                for (var i = 0; i < ListType.Count; i++)
                {
                    ValuationValueDeclineDataContract VM = new ValuationValueDeclineDataContract();
                    VM.MarkedDate = CommonHelper.ToDateTime(ListType[i].MarkedDate);
                    VM.PropertyType = ListType[i].PropertyType;
                    VM.ValueDecline = CommonHelper.StringToDecimal(ListType[i].ValueDecline);
                    VM.UserID = (ListType[i].UserID);
                    VmNoteList.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdateValueDeclineByPropertyType(VmNoteList);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdateValueDeclineByPropertyType ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedNoteList ", "", useridforSys_Scheduler, "InsertUpdatedNoteList", "", ex);
            }

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/ValuationModule/InsertUpdateRateExtension")]
        public IActionResult InsertUpdateRateExtension([FromBody] dynamic ListType)
        {
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            try
            {
                List<ValuationRateExtensionDataContract> VmNoteList = new List<ValuationRateExtensionDataContract>();
                for (var i = 0; i < ListType.Count; i++)
                {
                    ValuationRateExtensionDataContract VM = new ValuationRateExtensionDataContract();
                    VM.MarkedDate = CommonHelper.ToDateTime(ListType[i].MarkedDate);
                    VM.Value = CommonHelper.StringToDecimal(ListType[i].Value);
                    VM.UserID = (ListType[i].UserID);
                    VmNoteList.Add(VM);
                }

                ValuationModuleLogic vml = new ValuationModuleLogic();
                vml.InsertUpdateRateExtension(VmNoteList);

                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Data Saved InsertUpdateRateExtension ", "", useridforSys_Scheduler);
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
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

                log.WriteLogException(CRESEnums.Module.ValuationModule.ToString(), "Error in InsertUpdatedNoteList ", "", useridforSys_Scheduler, "InsertUpdatedNoteList", "", ex);
            }

            return Ok(_authenticationResult);
        }

    }
}
