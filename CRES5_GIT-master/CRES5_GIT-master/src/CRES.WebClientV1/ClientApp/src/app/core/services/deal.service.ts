import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { deals, DealFunding, AutoSpreadRule } from '../domain/deals.model';
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
    return this.accountService.getByIDStorageTypeAndLocationWithBlob(id, storagetypeid, location);
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

}
