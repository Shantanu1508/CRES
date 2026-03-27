import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Note } from '../domain/note.model';
import { devDashBoard } from '../domain/devDashBoard.model';
import { NoteAdditionalList } from "../../core/domain/noteAdditionalList.model";
import { ActivityLog } from "../../core/domain/activityLog.model";


@Injectable()
export class NoteService {
  private _noteGetNotesByDealIdAPI: string = 'api/note/getnotesbydealId';
  private _noteAddNewNoteAPI: string = 'api/note/addnewnote';
  private _notegetnotesfromdealdetailbydealIDAPI: string = 'api/note/getnotesfromdealdetailbydealID';
  private _noteAddNoteAPI: string = 'api/note/addnote';
  private _noteGetNoteByNoteIdAPI: string = 'api/note/getnotebynoteId';
  private _noteAddNoteobjectAPI: string = 'api/note/addnoteobject';
  private _notegetallLookupAPI: string = 'api/note/getallLookup';
  private _noteAddextraNoteAPI: string = 'api/note/addnoteadditionalfeilds';
  private _noteAddextralistAPI: string = 'api/note/addupdatenoteadditionallist';
  private _noteAddArchieveextralistAPI: string = 'api/note/addupdatenotearchieveadditionallist';
  private _notegetextraNoteAPI: string = 'api/note/getnoteadditinalfeildsbynoteId';
  private _notegetaditionalListAPI: string = 'api/note/getnoteadditinallist';
  private _getPeriodicDataByNoteIdAPI: string = 'api/note/GetPeriodicDataByNoteId';
  private _getnotecalculatordatabynoteIdAPI: string = 'api/note/getnotecalculatordatabynoteId';
  private _queuenoteforcalculation: string = 'api/note/queuenoteforcalculation';


  private _getNoteCalculatorJsonByNoteIdAPI: string = 'api/note/getnotecalculatorjsonbynoteid';
  private _getnotecalculatordatabyjsonAPI: string = 'api/note/getnotecalculatordatabyjson';

  private _getliborscheduledatabynoteIdAPI: string = 'api/note/getliborscheduledatabynoteId';
  private _getHistoricalDataOfModuleByNoteIdAPI: string = 'api/note/GetHistoricalDataOfModuleByNoteId';

  private _getAllScheduleLatestDataByNoteIdAPI: string = 'api/note/getAllScheduleLatestDataByNoteId';
  private _fwarehouseGetAllFinancingWarehouseAPI: string = 'api/account/GetFinancingWarehouse';

  private _getNotePeriodicCalcByNoteId: string = 'api/note/getNotePeriodicCalcByNoteId';
  private _getNoteOutputNPVdataByNoteId: string = 'api/note/getNoteOutputNPVdataByNoteId';

  private _checkduplicatenoteAPI: string = 'api/note/checkduplicatenote';
  private _checkduplicateCashflowTransAPI: string = 'api/note/checkduplicatetransactionCashflow';
  private _Getnoteexceptions: string = 'api/note/getnoteexceptions';

  private _validatenoteobj: string = 'api/note/validatenoteobj';
  private _getNoteCashflowsExportDataAPI: string = 'api/note/getNoteCashflowsExportExcel';
  private _noteSearchNoteByCRENoteIdAPI: string = 'api/note/searchnote';
  private _noteGetActivityLogByModuleIdAPI: string = 'api/note/getactivitylogbymoduleid';

  private _notecheckconcurrentupdateAPI: string = 'api/note/checkconcurrentupdate';

  private _getLastUpdatedDateAndUpdatedByForScheduleAPI: string = 'api/note/GetLastUpdatedDateAndUpdatedByForSchedule';
  private _functionAddUpdateNoteRuleByNoteIdAPI: string = 'api/note/addupdatenoterulebynoteId';
  private _getAllClient: string = 'api/note/getAllClient';
  private _getAllFund: string = 'api/note/getAllFund';

  private _getAllFeeTypesFromFeeSchedulesConfig: string = 'api/note/GetAllFeeTypesFromFeeSchedulesConfig';

  private _getTransactionEntryByNoteIdAPI: string = 'api/note/getTransactionEntryByNoteId';
  private _getnotecalcinfobynoteId: string = 'api/note/getnotecalcinfobynoteId';

  private _getFeeCouponStripReceivableDataByNoteIdAPI: string = 'api/note/getFeeCouponStripReceivableDataByNoteId';

  private _noteGetLookupForMasterAPI: string = 'api/note/GetLookupForMaster';
  private _noteGetFinancingSourceAPI: string = 'api/note/GetFinancingSource';
  private _getalltransactiontypes: string = 'api/account/getAlltransactionTypes';
  private _getholidaymasterAPI: string = 'api/note/getholidaymaster';
  private _getmaturitybynoteidAPI: string = 'api/note/getmaturitybynoteid';
  private _copynotedAPI: string = 'api/note/copynote';
  private _addupdatenoteruletypesetupAPI: string = 'api/note/AddUpdateNoteRuleTypeSetup';
  private getruletypesetupbynoteidAPI: string = 'api/note/GetRuleTypeSetupByNoteId';
  private _getAllTagNameXIRRAPI: string = 'api/note/getAllTagNameXIRR';
  private _updateNoteEditListRSSFEEPIK: string = 'api/note/UpdateNoteRSSFEEPIK';
  private _updateUserPreferencesAPI: string = 'api/note/InsertUpdateUserPreference';
  private _getUserPreferenceAPI: string = 'api/note/GetUserPreferenceByUserID';

  private _getnotetranchepercentageAPI: string = 'api/note/getnotetranchepercentage';
  private _updateNoteTranchePercentageAPI: string = 'api/note/updatenotetranchepercentage';
  private _saveparentclientAPI: string = 'api/note/updateparentclient';
  private _saveparentfundAPI: string = 'api/note/updateparentfund';
  

  constructor(public datasrv: DataService) { }

  getNotesByDealId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._noteGetNotesByDealIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getNotesFromDealDetailByDealId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._notegetnotesfromdealdetailbydealIDAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }
  getAllNotes(_note: Note) {
    this.datasrv.set(this._noteGetNotesByDealIdAPI);
    return this.datasrv.post(JSON.stringify(_note));//
  }

  addNewNote(_note: Note) {
    this.datasrv.set(this._noteAddNewNoteAPI);
    var s = JSON.stringify(_note);
    return this.datasrv.post(s);
  }

  addNoteObject(_noteobj :any) {
    this.datasrv.set(this._noteAddNoteobjectAPI);
    var s = JSON.stringify(_noteobj);
    return this.datasrv.post(s);
  }

  addNote(note:any) {
    this.datasrv.set(this._noteAddNoteAPI);
    return this.datasrv.post(JSON.stringify(note));
  }


  //addNoteExtraFeilds(noteextrafld) {
  //    this.datasrv.set(this._noteAddextraNoteAPI);  
  //    return this.datasrv.post(JSON.stringify(noteextrafld));
  //}

  addNoteExtralist(noteextrafld:any) {
    this.datasrv.set(this._noteAddextralistAPI);
    return this.datasrv.post(JSON.stringify(noteextrafld));
  }
  addNoteArchieveExtralist(noteextraArchievefld:any) {
    this.datasrv.set(this._noteAddArchieveextralistAPI);
    return this.datasrv.post(JSON.stringify(noteextraArchievefld));
  }

  validatenote(validatenote:any) {
    this.datasrv.set(this._validatenoteobj);
    return this.datasrv.post(JSON.stringify(validatenote));
  }

  getNoteByNoteID(_note: Note) {
    this.datasrv.set(this._noteGetNoteByNoteIdAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getAllLookupById() {
    this.datasrv.set(this._notegetallLookupAPI);
    return this.datasrv.getAll();
  }



  getNoteAdditinalListByNoteID(noteextralst: NoteAdditionalList) {
    this.datasrv.set(this._notegetaditionalListAPI);
    return this.datasrv.post(JSON.stringify(noteextralst));
  }


  getPeriodicDataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getPeriodicDataByNoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }




  getNoteCalculatorDataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getnotecalculatordatabynoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  QueueNoteForCalculation(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._queuenoteforcalculation, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getNoteCalculatorDataByJsonRequest(_note: Note, pagesIndex?: number, pagesSize?: number) {

    this.datasrv.set(this._getnotecalculatordatabyjsonAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }



  getNoteCalculatorJsonByNoteId(_note:any) {
    this.datasrv.set(this._getNoteCalculatorJsonByNoteIdAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }



  getHistoricalDataOfModuleByNoteIdAPI(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getHistoricalDataOfModuleByNoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }
  getLiborScheduleDataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getliborscheduledatabynoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getAllScheduleLatestDataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {




    this.datasrv.set(this._getAllScheduleLatestDataByNoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }



  GetAllFinancingWarehouse(pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._fwarehouseGetAllFinancingWarehouseAPI, pagesIndex, pagesSize);
    return this.datasrv.get();
  }
  ////manish
  GetNoteExceptions(objectid:any) {
    this.datasrv.set(this._Getnoteexceptions);
    return this.datasrv.post(JSON.stringify(objectid));
  }
  getNotePeriodicCalcByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getNotePeriodicCalcByNoteId, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getTransactionEntryByNoteId(_note: Note) {
    this.datasrv.set(this._getTransactionEntryByNoteIdAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getnotecalcinfobynoteId(input: devDashBoard) {
    this.datasrv.set(this._getnotecalcinfobynoteId);
    return this.datasrv.post(JSON.stringify(input));
  }

  getNoteOutputNPVdataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getNoteOutputNPVdataByNoteId, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }


  checkduplicatenote(_note: Note) {
    this.datasrv.set(this._checkduplicatenoteAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }

  CheckDuplicateTransactionCashflow(downloadCashFlow: any) {
    this.datasrv.set(this._checkduplicateCashflowTransAPI);
    return this.datasrv.post(JSON.stringify(downloadCashFlow));
  }

  getNoteCashflowsExportData(downloadCashFlow:any) {
    this.datasrv.set(this._getNoteCashflowsExportDataAPI);
    return this.datasrv.postWithBlob(JSON.stringify(downloadCashFlow));
  }
  //downloadexcelfile(dealfunding) {

  //    this.accountService.set(this._downloadexcelfileAPI);
  //    // return this.accountService.getByIDStorageTypeAndLocationWithBlob(null, null, null);
  //    return this.accountService.PostByDataTable((dealfunding));
  //}

  searchNoteByCRENoteId(_note: Note) {
    this.datasrv.set(this._noteSearchNoteByCRENoteIdAPI);
    return this.datasrv.post(JSON.stringify(_note));//
  }

  getActivityLogByModuleId(_activityLog: ActivityLog, pageindex?: number, pagesize?: number) {
    this.datasrv.set(this._noteGetActivityLogByModuleIdAPI, pageindex, pagesize);
    return this.datasrv.post(JSON.stringify(_activityLog));
  }


  CheckConcurrentUpdate(_note: Note) {
    this.datasrv.set(this._notecheckconcurrentupdateAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }

  GetLastUpdatedDateAndUpdatedByForSchedule(_note: Note) {
    this.datasrv.set(this._getLastUpdatedDateAndUpdatedByForScheduleAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }



  AddUpdateNoteRuleByNoteId(_note: Note) {
    this.datasrv.set(this._functionAddUpdateNoteRuleByNoteIdAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getAllClient() {
    this.datasrv.set(this._getAllClient);
    return this.datasrv.getAll();//
  }

  getAllFund() {
    this.datasrv.set(this._getAllFund);
    return this.datasrv.getAll();//
  }

  getFeeTypesFromFeeSchedulesConfig() {
    this.datasrv.set(this._getAllFeeTypesFromFeeSchedulesConfig);
    return this.datasrv.getAll();//
  }

  getFeeCouponStripReceivableDataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getFeeCouponStripReceivableDataByNoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  GetLookupForMaster() {
    this.datasrv.set(this._noteGetLookupForMasterAPI);
    return this.datasrv.getAll();
  }

  GetFinancingSource() {
    this.datasrv.set(this._noteGetFinancingSourceAPI);
    return this.datasrv.getAll();
  }

  GetTransactionTypes() {
    this.datasrv.set(this._getalltransactiontypes);
    return this.datasrv.getAll();
  }

  GetHolidayMaster() {
    this.datasrv.set(this._getholidaymasterAPI);
    return this.datasrv.getAll();
  }

  getMaturityDatesbyNoteid(ID: string) {
    this.datasrv.set(this._getmaturitybynoteidAPI);
    return this.datasrv.getByID(ID);
  }


  CopyNote(_note: Note) {
    this.datasrv.set(this._copynotedAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }

  getNoteCashflowsExportExcel(downloadCashFlow :any) {

    //this.datasrv.set(this._getNoteCashflowsExportDataAPI);
    //return this.datasrv.post(JSON.stringify(downloadCashFlow));


    this.datasrv.set(this._getNoteCashflowsExportDataAPI);

    return this.datasrv.post(JSON.stringify(downloadCashFlow));
    //return this.datasrv.PostByDataTable((downloadCashFlow));
  }
  addupdatenoteruletypesetup(noteruletype: any) {
    this.datasrv.set(this._addupdatenoteruletypesetupAPI);
    return this.datasrv.post(JSON.stringify(noteruletype));
  }

  getruletypesetupbynoteid(_ruletype: any) {
    this.datasrv.set(this.getruletypesetupbynoteidAPI);
    return this.datasrv.post(JSON.stringify(_ruletype));
  }

  GetAllTagsNameXIRR() {
    this.datasrv.set(this._getAllTagNameXIRRAPI);
    return this.datasrv.getAll();
  }

  UpdateNoteEditlistRSSFEEPIK(EditNoteListRssFee: any) {
    this.datasrv.set(this._updateNoteEditListRSSFEEPIK);
    return this.datasrv.post(JSON.stringify(EditNoteListRssFee));
  }
  UpdateUserPreference(UserPreferences: any) {
    this.datasrv.set(this._updateUserPreferencesAPI);
    return this.datasrv.post(JSON.stringify(UserPreferences));
  }
  GetUserPreferenceByUserID() {
    this.datasrv.set(this._getUserPreferenceAPI);
    return this.datasrv.getAll();
  }

  getNoteTranchePercentagebyNoteid(ID: string) {
    this.datasrv.set(this._getnotetranchepercentageAPI);
    return this.datasrv.getByID(ID);
  }

  UpdateNoteTranchePercentage(CreNoteId: any) {
    this.datasrv.set(this._updateNoteTranchePercentageAPI);
    return this.datasrv.post(JSON.stringify(CreNoteId));
  }

  SaveParentClient(parentClient: any) {
    this.datasrv.set(this._saveparentclientAPI);
    return this.datasrv.post(JSON.stringify(parentClient));
  }

  SaveParentFund(parentFund: any) {
    this.datasrv.set(this._saveparentfundAPI);
    return this.datasrv.post(JSON.stringify(parentFund));
  }

}
