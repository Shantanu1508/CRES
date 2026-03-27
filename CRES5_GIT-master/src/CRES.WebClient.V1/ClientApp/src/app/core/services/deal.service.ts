import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { deals, DealFunding, AutoSpreadRule, DealLiabilityDataContract, PrincipalWriteoff } from '../domain/deals.model';
import { Module } from '../domain/module.model';

@Injectable()
export class dealService {
  private _dealGetAllDealAPI: string = 'api/deal/getalldeals';
  private _dealGetDealByDealIdAPI: string = 'api/deal/getdealbydealid';
  private _dealGetAllLookupAPI: string = 'api/deal/getallLookup';
  private _dealSaveDealAPI: string = 'api/deal/SaveDeal';
  private _dealSaveDealArchieveAPI: string = 'api/deal/SaveDealArchieve';
  private _dealGetDealFundingByDealIDAPI: string = 'api/deal/GetDealFundingByDealID';
  private _dealGetNoteDealFundingByDealIDAPI: string = 'api/deal/GetNoteDealFundingByDealID';
  private dealGetNoteSequenceByDealIDAPI: string = 'api/deal/GetNoteSequenceByDealID';
  private dealGetNoteSequenceHistoryByDealIDAPI: string = 'api/deal/GetNoteSequenceHistoryByDealID';
  private dealGetNoteFundingByDealIDAPI: string = 'api/deal/GetNoteFundingByDealID';
  private _dealGenerateFutureFundingAPI: string = 'api/deal/GenerateFutureFunding';
  private checkduplicatedealAPI: string = 'api/deal/checkduplicatedeal';
  private checkduplicateNoteAPI = 'api/deal/checkduplicateNoteExist';
  private checkCopyduplicateNoteAPI = 'api/deal/checkduplicateCopyNoteExist';
  private getpayrulesetupdatabydealidDAPI: string = 'api/deal/getpayrulesetupdatabydealid';
  private copydealAPI: string = 'api/deal/copydeal';
  private _dealSearchDealByCREDealIdOrDealNameAPI: string = 'api/deal/searchdealbycredealidordealname';
  private _dealdeletemodulebyidAPI: string = 'api/deal/deletemodulebyid';
  private _checkconcurrentupdateAPI: string = 'api/deal/checkconcurrentupdate';
  private _accountGetHolidayListAPI: string = 'api/account/GetHolidayList';
  private _getAllLiborAPI: string = 'api/note/getAllLiborSchedule';
  private _getWFNoteFundingAPI: string = 'api/deal/GetWFNoteFunding';
  private _getNoteAllocationPercentageAPI: string = 'api/deal/GetNoteAllocationPercentage';
  private _getAutoSpreadRuleAPI: string = 'api/deal/GetAutoSpreadRuleByDealID';
  private _importdealAPI: string = 'api/deal/ImportDealByCREDealID';
  private _deletedealAPI: string = 'api/deal/DeleteDealByCREDealID';
  private _getNoteDetailForDealAmortByDealIDAPI: string = 'api/deal/GetNoteDetailForDealAmortByDealID';
  private _getDealAmortizationByDealIDAPI: string = 'api/deal/GetDealAmortizationByDealID';
  private _getFutureFundingForAmortByDealIDAPI: string = 'api/deal/GenerateDealAmortization';
  private _getAmortScheduleByDealIDAPI: string = 'api/deal/GetAmortScheduleByDealID';
  private _getadjustedtotalcommitmentAPI: string = 'api/deal/GetAdjustedtotalCommitmentByDealID';
  private _getPayloadDataAPI: string = 'api/deal/getPayloadData';
  private _accountingreportdownloadobjectfileAPI: string = 'api/excelupload/downloadobjectfile';
  private _getdealfundingbydealfundingIDAPI: string = 'api/deal/getdealfundingbydealfundingID';
  private _getallfeeinvoiceAPI: string = 'api/wfcontroller/getAllFeeInvoice';
  private _getprojectedpayoffdatebyDealId: string = 'api/deal/getprojectedPayOffDateByDealID';
  private _getprojectedpayoffDBDatabydealid: string = 'api/deal/getprojectedPayOffDBDataByDealID';
  private _savefeeinvoicesAPI: string = 'api/wfcontroller/saveFeeInvoices';
  private _downloadexcelfileAPI: string = 'api/excelupload/downloadexcelfile';
  private _getMaturityDatesbyDealid: string = 'api/deal/getmaturitybydealid';
  private _getscheduleeffectivedatecountAPI = 'api/deal/getscheduleeffectivedatecountbydealId';
  private _getAllReserveAccountsAPI: string = 'api/deal/getallreserveaccountbydealid';
  private _getAllReserveScheduleAPI: string = 'api/deal/getreserveschedulebydealid';
  private _getWFPayOffNoteFundingAPI: string = 'api/deal/getwfpayoffnotefunding';
  private _addNewPrepayScheduleAPI: string = 'api/deal/addNewPrepaySchedule';
  private getprepaypremiumDetaildatabydealAPI: string = 'api/deal/getprepaypremiumDetaildatabydeal';
  private getruletypesetupbydealidAPI: string = 'api/deal/GetRuleTypeSetupByDealId';
  private _addupdatedealruletypesetupAPI: string = 'api/deal/AddUpdateDealRuleTypeSetup';
  private _getallpropertytypeAPI: string = 'api/deal/GetAllPropertyType';
  private _getallloanstatusAPI: string = 'api/deal/GetAllLoanStatus';
  private _getallreserveaccountmasterAPI: string = 'api/deal/GetAllReserveAccountMaster';

  
  private GetDealCalculationStatusAPI: string = 'api/deal/GetDealCalculationStatus';
  private _addCalculaterrepay: string = 'api/deal/calculaterrepay';
 
  private _getprepaycalculationstatusAPI: string = 'api/deal/GetPrepayCalculationStatus';
  private getdealprepayprojectionbydealidAPI: string = 'api/deal/getdealprepayprojectionbydealid';
  private getdealprepayallocationbydealidAPI: string = 'api/deal/getdealprepayallocationbydealid';
  private _GetEquitySummaryByDealID: string = 'api/deal/GetEquitySummaryByDealID'
  private _downloadexcelfileFundingRuleAPI: string = 'api/excelupload/downloadexcelfileFundingRule';
  private _getAccountingCloseByDealIdAPI: string = 'api/accounting/getaccountingclosebydealId';
  private _savedealaccountingCloseAPI: string = 'api/accounting/savedealaccountingbyclosedate';
  private _savedealaccountingOpenAPI: string = 'api/accounting/savedealaccountingbyopendate';
  private _downloadexcelfileCommitmentAPI: string = 'api/excelupload/downloadexcelcommitment';
  private _dealLiabilityByDealID: string = 'api/deal/getdealliabilitybydealid';
  private _checkduplicateforliabilitesAPI: string = 'api/liabilityNote/checkduplicateforliabilities';

  private _getServicingWatchListDatabyDealidAPI: string = 'api/deal/getServicingWatchListDatabyDealid';
  private _getTransactionEntryLiabilityNoteByDealAccountIdAPI: string = 'api/liabilityNote/GetTransactionEntryLiabilityNoteByDealAccountId';
  private _getAllTagNameXIRRAPI: string = 'api/deal/getAllTagNameXIRR';
  private _getXIRROutputByObjectIDAPI: string = 'api/deal/getXIRROutputByObjectID';
  private _getXIRRCalculationStatusByObjectIDAPI: string = 'api/deal/GetXIRRCalculationStatusByObjectID';

  private _getDealLiabilityCashflowExportExcel: string = 'api/liabilityNote/getDealLiabilityCashflowsExportExcel';
  private _getAutoDistributeWriteoffAPI: string = 'api/deal/GetAutoDistributeWriteoffByDealID';
  private _principalWriteoffAPI: string = 'api/deal/autodistributePrincipalWriteoff';
  private _downloadexcelfileServicingPotentialImpairmentAPI: string = 'api/excelupload/downloadexcelServicingPotentialImpairment';
  private _getDealRelationshipAPI: string = 'api/deal/GetDealRelationshipByDealID';
  private _getPrepaymentGroupAPI: string = 'api/deal/PrepaymentGroupByDealID';
  private _getPayoffStatementFeesAPI: string = 'api/deal/getPayoffStatementFeesByDealID';
  
  private _getPrepaymentNoteSetupByDealID: string = 'api/deal/PrepaymentNoteSetupByDealID';
  private _getPrepaymentNoteAllocationByDealID: string = 'api/deal/PrepaymentNoteAllocationSetup';
  private _calcDealForAnalysisIDAPI: string = 'api/deal/CalcDealForAnalysisID';
  private _updateReserveAccountFromBackshopAPI: string = 'api/deal/UpdateReserveAccountFromBackshop';
  private _getGetAccountingBasisAPI: string = 'api/deal/GetAccountingBasisByDealID';
  private _getAllLiabilityTypesDetailAPI: string = 'api/deal/getAllLiabilityTypesDetail';
  private _downloadPayoffStatementExcelAPI: string = 'api/deal/downloadPayoffstatementexcel';
  //private _generatePayOffStatementandSendEmail: string = 'api/deal/GeneratePayOffStatementandSendEmail';
  private _UpdateDealForPayoffStatementConfigurationAPI: string = 'api/deal/UpdateDealForPayoffStatementConfiguration';
  private _importDealFromBackshopByCREDealIdAPI: string = 'api/deal/ImportDealFromBackshopByCREDealId';
  private _getFinancingCommitmentByDealID: string = 'api/deal/GetFinancingCommitmentByDealID'

  constructor(public accountService: DataService) { }
  //getAllDeals(_user:User) {
  //    this.accountService.set(this._accountGetAllDeal);
  //    return this.accountService.post(_user);
  //}

  getDealByDealID(deal: deals) {
    this.accountService.set(this._dealGetDealByDealIdAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GenerateFutureFunding(deal: deals) {
    this.accountService.set(this._dealGenerateFutureFundingAPI);
    return this.accountService.post(JSON.stringify(deal));
  }


  GetDealFundingByDealID(deal: deals) {
    this.accountService.set(this._dealGetDealFundingByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }
  GetNoteDealFundingByDealID(deal: deals) {
    this.accountService.set(this._dealGetNoteDealFundingByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }
  GetWFNoteFunding(deal: DealFunding) {
    this.accountService.set(this._getWFNoteFundingAPI);
    return this.accountService.post(JSON.stringify(deal));
  }
  GetNoteAllocationPercentage(deal: DealFunding) {
    this.accountService.set(this._getNoteAllocationPercentageAPI);
    return this.accountService.post(JSON.stringify(deal));
  }



  GetNoteSequenceByDealID(deal: deals) {
    this.accountService.set(this.dealGetNoteSequenceByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetNoteSequenceHistoryByDealID(deal: deals) {
    this.accountService.set(this.dealGetNoteSequenceHistoryByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetNoteFundingByDealID(deal: deals) {
    this.accountService.set(this.dealGetNoteFundingByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  getAllDeals(pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._dealGetAllDealAPI, pagesIndex, pagesSize);
    return this.accountService.get();
  }

  getAllLookup() {
    this.accountService.set(this._dealGetAllLookupAPI);
    return this.accountService.getAll();
  }

  getHolidayList() {
    this.accountService.set(this._accountGetHolidayListAPI);
    return this.accountService.getAll();
  }


  GetNotePayruleSetupDataByDealID(dealid:any) {
    this.accountService.set(this.getpayrulesetupdatabydealidDAPI);
    return this.accountService.post(JSON.stringify(dealid));
  }


  SaveDeal(deal: deals) {
    this.accountService.set(this._dealSaveDealAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  //SaveDealArchieve(deal: deals) {
  //    this.accountService.set(this._dealSaveDealArchieveAPI);
  //    return this.accountService.post(JSON.stringify(deal));
  //}

  checkduplicatedeal(deal: deals) {
    this.accountService.set(this.checkduplicatedealAPI);
    return this.accountService.post(JSON.stringify(deal));
  }


  copydeal(deal: deals) {
    this.accountService.set(this.copydealAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  checkNoteAlreadyExist(lstNotes: any) {

    this.accountService.set(this.checkduplicateNoteAPI);
    return this.accountService.post(JSON.stringify(lstNotes));
    //  return this.accountService.post(lstNotes);

  }


  checkNoteCopyAlreadyExist(lstNotes: any) {
    this.accountService.set(this.checkCopyduplicateNoteAPI);
    return this.accountService.post(JSON.stringify(lstNotes));

  }

  searchDealByCREDealIdOrDealName(deal: deals) {
    this.accountService.set(this._dealSearchDealByCREDealIdOrDealNameAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  deleteModuleByID(_module: Module) {
    this.accountService.set(this._dealdeletemodulebyidAPI);
    return this.accountService.post(JSON.stringify(_module));
  }

  CheckConcurrentUpdate(deal: deals) {
    this.accountService.set(this._checkconcurrentupdateAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetallLiborSchedule() {
    this.accountService.set(this._getAllLiborAPI);
    return this.accountService.getAll();//
  }

  GetAutoSpreadRuleByDealID(deal: deals) {
    this.accountService.set(this._getAutoSpreadRuleAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  ImportDeal(deal: deals) {

    this.accountService.set(this._importdealAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  DeleteDeal(deal: deals) {
    this.accountService.set(this._deletedealAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetNoteDetailForDealAmortByDealID(deal: deals) {
    this.accountService.set(this._getNoteDetailForDealAmortByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetDealAmortizationByDealID(deal: deals) {
    this.accountService.set(this._getDealAmortizationByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }


  FutureFundingForAmort(deal: deals) {
    this.accountService.set(this._getFutureFundingForAmortByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }


  GetAmortDealSchedulebyDealid(deal: deals) {
    this.accountService.set(this._getAmortScheduleByDealIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetAdjustmentTotalCommitment(DealID:any) {
    this.accountService.set(this._getadjustedtotalcommitmentAPI);
    return this.accountService.post(JSON.stringify(DealID));
  }

  //GetPayoffIframeData(iframeUrl: string, iframeTokenKey: string, iframeTokenValue: string) {
  //    this.accountService.set(iframeUrl);
  //    return this.accountService.getIframeData(iframeUrl, iframeTokenKey, iframeTokenValue);//
  //}

  PostPayoffIframeData(_payoff: any, iframeUrl: string, iframeTokenKey: string, iframeTokenValue: string) {
    this.accountService.set(iframeUrl);
    return this.accountService.postIframeData(iframeUrl, iframeTokenKey, iframeTokenValue, _payoff);//
  }
  //postIframeData



  GetPayloadData(deal: deals) {
    this.accountService.set(this._getPayloadDataAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  downloadObjectDocumentByStorageTypeAndLocation(id: string, storagetypeid: string, location: string) {
    this.accountService.set($.trim(this._accountingreportdownloadobjectfileAPI));
    return this.accountService.getByIDStorageTypeAndLocationWithBlobGET(id, storagetypeid, location);
  }

  GetDealFundingByDealFundingID(deal: DealFunding) {
    this.accountService.set(this._getdealfundingbydealfundingIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetAllFeeInvoice(CREDealID: any, pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._getallfeeinvoiceAPI, pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(CREDealID));
  }

  GetProjectedPayoffDatesByDealId(dtDeal:any) {
    this.accountService.set(this._getprojectedpayoffdatebyDealId);
    return this.accountService.post(JSON.stringify(dtDeal));
  }

  GetProjectedPayoffDBDataByDealId(DealID:any) {
    this.accountService.set(this._getprojectedpayoffDBDatabydealid);
    return this.accountService.post(JSON.stringify(DealID));
  }

  SaveFeeInvoices(dtFeeInvoice:any) {
    this.accountService.set(this._savefeeinvoicesAPI);
    return this.accountService.post(JSON.stringify(dtFeeInvoice));
  }



  downloadexcelfile(dealfunding:any) {
    this.accountService.set(this._downloadexcelfileAPI);
    // return this.accountService.getByIDStorageTypeAndLocationWithBlob(null, null, null);
    return this.accountService.PostByDataTable((dealfunding));
  }

  getMaturityDatesbyDealid(ID: string) {
    this.accountService.set(this._getMaturityDatesbyDealid);
    return this.accountService.getByID(ID);
  }


  GetScheduleEffectiveDateCount(ID: string) {
    this.accountService.set(this._getscheduleeffectivedatecountAPI);
    return this.accountService.getByID(ID);
  }
  //GetScheduleEffectiveDateCount(_note: Note, pagesIndex?: number, pagesSize?: number) {
  //    this.accountService.set(this._getscheduleeffectivedatecountAPI, pagesIndex, pagesSize);
  //    return this.accountService.post(JSON.stringify(_note));
  //}

  getAllReserveAccounts(ID: string) {
    this.accountService.set(this._getAllReserveAccountsAPI);
    return this.accountService.getByID(ID);
  }

  getAllReserveSchedule(ID: string) {
    this.accountService.set(this._getAllReserveScheduleAPI);
    return this.accountService.getByID(ID);
  }

  GetWFPayOffNoteFunding(deal: DealFunding) {
    this.accountService.set(this._getWFPayOffNoteFundingAPI);
    return this.accountService.post(JSON.stringify(deal));
  }
  addNewPrepaySchedule(_prepaymentpremium: any) {
    this.accountService.set(this._addNewPrepayScheduleAPI);
    var s = JSON.stringify(_prepaymentpremium);
    return this.accountService.post(s);
  }

  getprepaypremiumdetaildatabydeal(DealId: string) {
    this.accountService.set(this.getprepaypremiumDetaildatabydealAPI);
    return this.accountService.post(JSON.stringify(DealId));
  }
  getruletypesetupbydealid(_ruletype: any) {
    this.accountService.set(this.getruletypesetupbydealidAPI);
    return this.accountService.post(JSON.stringify(_ruletype));
  }
  addupdatedealruletypesetup(dealruletype: any) {
    this.accountService.set(this._addupdatedealruletypesetupAPI);
    return this.accountService.post(JSON.stringify(dealruletype));
  }
  getallpropertytype() {
    this.accountService.set(this._getallpropertytypeAPI);
    return this.accountService.getAll();
  }
  getallloanstatus() {
    this.accountService.set(this._getallloanstatusAPI);
    return this.accountService.getAll();
  }
  GetDealCalculationStatus(DealID) {
    this.accountService.set(this.GetDealCalculationStatusAPI);
    return this.accountService.post(JSON.stringify(DealID));
  }
  CalcPrepaySchedule(deal: deals) {
    this.accountService.set(this._addCalculaterrepay);
    var s = JSON.stringify(deal);
    return this.accountService.post(s);
  }
  getprepaycalculationstatus(dealid) {
    this.accountService.set(this._getprepaycalculationstatusAPI);
    var s = JSON.stringify(dealid);
    return this.accountService.post(s);
  }
  
  getdealprepayprojectionbydealid(DealId: string) {
    this.accountService.set(this.getdealprepayprojectionbydealidAPI);
    return this.accountService.post(JSON.stringify(DealId));
  }

  getdealprepayallocationbydealid(DealId: string) {
    this.accountService.set(this.getdealprepayallocationbydealidAPI);
    return this.accountService.post(JSON.stringify(DealId));
  }
  GetEquitySummaryByDealID(dealid) {
    this.accountService.set(this._GetEquitySummaryByDealID);
    var s = JSON.stringify(dealid);
    return this.accountService.post(s);
  }
  downloadexcelfilefundingRule(fundingrule) {

    this.accountService.set(this._downloadexcelfileFundingRuleAPI);
    return this.accountService.PostByDataTable((fundingrule));
  }

  getAccountingClosebyDealid(DealId, pagesIndex, pagesSize) {
    this.accountService.set(this._getAccountingCloseByDealIdAPI, pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(DealId));
  }


  savedealaccountingClose(str: string) {
    this.accountService.set(this._savedealaccountingCloseAPI);
    return this.accountService.post(JSON.stringify(str));
  }

  savedealaccountingOpen(str: string) {
    this.accountService.set(this._savedealaccountingOpenAPI);
    return this.accountService.post(JSON.stringify(str));
  }


  downloadexcelCommitment(commitment) {

    this.accountService.set(this._downloadexcelfileCommitmentAPI);
    return this.accountService.PostByDataTable((commitment));
  }
  //ServicingWatchlist
  

  GetServicingWatchListDatabyDealid(DealID: any) {
    this.accountService.set(this._getServicingWatchListDatabyDealidAPI);
    return this.accountService.post(JSON.stringify(DealID));
  }
  GetTransactionEntryLiabilityNoteByDealAccountId(DealAccountID: any) {
    this.accountService.set(this._getTransactionEntryLiabilityNoteByDealAccountIdAPI);
    return this.accountService.post(JSON.stringify(DealAccountID));
  }

  GetDealLiabilitybyDealid(DealAccountID: any) {
    this.accountService.set(this._dealLiabilityByDealID);
    return this.accountService.post(JSON.stringify(DealAccountID));
  }
  CheckDuplicateforLiabilities(dealLiability: DealLiabilityDataContract){
    this.accountService.set(this._checkduplicateforliabilitesAPI);
    return this.accountService.post(JSON.stringify(dealLiability));
  }
  GetAllTagsNameXIRR() {
    this.accountService.set(this._getAllTagNameXIRRAPI);
    return this.accountService.getAll();
  }
  GetXIRROutputByObjectID(DealAccountID: any) {
    this.accountService.set(this._getXIRROutputByObjectIDAPI);
    return this.accountService.post(JSON.stringify(DealAccountID));
  }
  GetXIRRCalculationStatusByObjectID(DealAccountID: any) {
    this.accountService.set(this._getXIRRCalculationStatusByObjectIDAPI);
    return this.accountService.post(JSON.stringify(DealAccountID));
  }

  //GetXIRRViewNotesByObjectID(requestdata: any) {
  //  this.accountService.set(this._getXIRRViewNotesByObjectIDAPI);
  //  return this.accountService.post(JSON.stringify(requestdata));
  //}
  GetDealLiabilityCashflowExportExcel(DealAccountID: any) {
    this.accountService.set(this._getDealLiabilityCashflowExportExcel);
    return this.accountService.postWithBlob(JSON.stringify(DealAccountID));
  }

  GetAutoDistributeWriteoffByDealID(deal: deals) {
    this.accountService.set(this._getAutoDistributeWriteoffAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  AutoDistributePrincipalWriteoff(principalwriteoff: PrincipalWriteoff) {
    this.accountService.set(this._principalWriteoffAPI);
    return this.accountService.post(JSON.stringify(principalwriteoff));
  }

  downloadexcelServicingPotentialImpairment(excPotentialImpairment) {

    this.accountService.set(this._downloadexcelfileServicingPotentialImpairmentAPI);
    return this.accountService.PostByDataTable((excPotentialImpairment));
  }

  GetDealRelationshipByDealID(dealID: string) {
    this.accountService.set(this._getDealRelationshipAPI);
    return this.accountService.post(JSON.stringify(dealID));
  }
  GetPrepaymentNoteSetupByDealID(dealID: string) {
    this.accountService.set(this._getPrepaymentNoteSetupByDealID);
    return this.accountService.post(JSON.stringify(dealID));
  }
  GetPrepaymentGroupByDealID(dealID: string) {
    this.accountService.set(this._getPrepaymentGroupAPI);
    return this.accountService.post(JSON.stringify(dealID));
  }

  GetPayoffStatementFeesByDealID(dealID: string) {
    this.accountService.set(this._getPayoffStatementFeesAPI);
    return this.accountService.post(JSON.stringify(dealID));
  }

  GetPrepaymentNoteAllocationSetup(dealID: string) {
    this.accountService.set(this._getPrepaymentNoteAllocationByDealID);
    return this.accountService.post(JSON.stringify(dealID));
  }
  CalcDealForAnalysisID(deal: any) {
    this.accountService.set(this._calcDealForAnalysisIDAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  getallreserveaccountmaster() {
    this.accountService.set(this._getallreserveaccountmasterAPI);
    return this.accountService.getAll();
  }

  updateReserveAccountFromBackshop(dealdc: any) {
    this.accountService.set(this._updateReserveAccountFromBackshopAPI);
    return this.accountService.post(JSON.stringify(dealdc));
  }

  GetAccountingBasisByDealID(dealID: string) {
    this.accountService.set(this._getGetAccountingBasisAPI);
    return this.accountService.post(JSON.stringify(dealID));
  }
  getAllLiabilityTypesDetail() {
    this.accountService.set(this._getAllLiabilityTypesDetailAPI);
    return this.accountService.getAll();
  }
  downloadPayoffStatementExcel(dealID: string, PayoffDate: any, actualPayoffDate: any) {
    this.accountService.set(this._downloadPayoffStatementExcelAPI);
    // return this.dataService.getByID(dealID);
    return this.accountService.getByIDAndID1andID2WithBlob(dealID, PayoffDate, actualPayoffDate);
  }
  UpdateDealForPayoffStatementConfigurationAPI(deal: deals) {
    this.accountService.set(this._UpdateDealForPayoffStatementConfigurationAPI);
    return this.accountService.post(JSON.stringify(deal));
  }  

  ImportDealFromBackshopByCREDealId(deal: deals) {
    this.accountService.set(this._importDealFromBackshopByCREDealIdAPI);
    return this.accountService.post(JSON.stringify(deal));
  }

  GetFinancingCommitmentByDealID(dealid) {
    this.accountService.set(this._getFinancingCommitmentByDealID);
    var s = JSON.stringify(dealid);
    return this.accountService.post(s);
  }
}
