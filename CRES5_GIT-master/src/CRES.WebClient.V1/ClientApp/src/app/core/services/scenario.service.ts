import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Scenario, Scenariosearch } from '../domain/scenario.model';
import { CalculationManagerList } from "../domain/calculationManagerList.model";

@Injectable()
export class scenarioService {
  private _getscenarioAPI: string = 'api/scenarios/getallscenario';
  private _getallLookupAPI: string = 'api/scenarios/getallLookup';
  private _resetdefaulttoactivescenarioAPI: string = 'api/scenarios/resettodefault';
  private _getscenarioscenarioidAPI: string = 'api/scenarios/getscenarioparameterbyscenarioid';
  private _getindexbyscenarioidAPI: string = 'api/scenarios/getindexbyscenarioid';
  private _insertupdatescenarioAPI: string = 'api/scenarios/insertupdatescenario';

  private _addupdateindextypeAPI: string = 'api/indextype/addupdateindextypefromscenario';

  private _checkduplicatescenarioAPI: string = 'api/scenarios/checkduplicatescenario';

  private _getIndexesFromDateAPI: string = 'api/scenarios/getindexesfromdate';
  private _getIndexesExportDataAPI: string = 'api/scenarios/getindexesexportdata';

  private _getIndexesFromIndexesMasterAPI: string = 'api/indextype/GetIndexesFromIndexesMaster';

  private _getInsertUpdateScenarioUserMapAPI: string = 'api/scenarios/InsertUpdateScenarioUserMap';
  private _getGetScenarioUserMapByUserIDAPI: string = 'api/scenarios/GetScenarioUserMapByUserID';
  private _getGetAllScenarioDistinctAPI: string = 'api/scenarios/GetAllScenarioDistinct';


  private _getGetScenarioDownloadAPI: string = 'api/scenarios/GetScenarioDownload';
  private _getallruletypeAPI: string = 'api/scenarios/GetAllRuleType'
  private _getallruletypedetailAPI: string = 'api/scenarios/GetAllRuleTypeDetail'
  private _addupdateanalysisruletypesetupAPI: string = 'api/scenarios/AddUpdateAnalysisRuleTypeSetup'
  private _getruletypesetupbyobjectIdAPI: string = 'api/scenarios/GetRuleTypeSetupbyObjectId'
  private _deletescenarioAPI: string = 'api/scenarios/deleteScenariobyAnalysisID'
  // 
  constructor(public accountService: DataService) { }

  GetScenario() {
    this.accountService.set(this._getscenarioAPI);
    return this.accountService.getAll();
  }




  ResetDefaultToActiveScenario(_calculationManager: CalculationManagerList) {
    this.accountService.set(this._resetdefaulttoactivescenarioAPI);
    return this.accountService.post(JSON.stringify(_calculationManager));
  }



  AddUpdateIndexType(indtype:any) {
    this.accountService.set(this._addupdateindextypeAPI);
    return this.accountService.post(JSON.stringify(indtype));
  }



  GetScenarioByScenarioID(id: any) {
    this.accountService.set(this._getscenarioscenarioidAPI);
    return this.accountService.post(JSON.stringify(id));

  }

  CheckDuplicateScenario(name: any) {
    this.accountService.set(this._checkduplicatescenarioAPI);
    return this.accountService.post(JSON.stringify(name));
  }



  GetIndexByScenarioID(id: string, pageIndex?: number, pageSize?: number) {
    this.accountService.setbyId(this._getindexbyscenarioidAPI, id, pageIndex, pageSize);
    return this.accountService.getByIdwithPaging();
  }


  GetIndexBetweenDates(_scenariosearch: Scenariosearch) {
    this.accountService.set(this._getIndexesFromDateAPI);
    return this.accountService.post(JSON.stringify(_scenariosearch));
  }

  GetIndexesExportData(_scenariosearch: Scenariosearch) {
    this.accountService.set(this._getIndexesExportDataAPI);
    return this.accountService.post(JSON.stringify(_scenariosearch));
  }

  getAllLookup() {
    this.accountService.set(this._getallLookupAPI);
    return this.accountService.getAll();
  }

  InsertUpdateScenario(scenario: any) {
    this.accountService.set(this._insertupdatescenarioAPI);
    return this.accountService.post(JSON.stringify(scenario));
  }


  getIndexesFromIndexesMaster() {
    this.accountService.set(this._getIndexesFromIndexesMasterAPI);
    return this.accountService.getAll();
  }


  InsertUpdateScenarioUserMap(scenario: any) {
    this.accountService.set(this._getInsertUpdateScenarioUserMapAPI);
    return this.accountService.post(JSON.stringify(scenario));
  }


  getScenarioUserMapByUserID(scenario: any) {
    this.accountService.set(this._getGetScenarioUserMapByUserIDAPI);
    return this.accountService.post(JSON.stringify(scenario));
  }

  getAllScenarioDistinct(scenario: any) {
    this.accountService.set(this._getGetAllScenarioDistinctAPI);
    return this.accountService.post(JSON.stringify(scenario));
  }

  getGetScenarioDownload(_scenariosearch: Scenariosearch) {
    this.accountService.set(this._getGetScenarioDownloadAPI);
    return this.accountService.post(JSON.stringify(_scenariosearch));
  }
  getallruletype() {
    this.accountService.set(this._getallruletypeAPI);
    return this.accountService.getAll();
  }

  getallruletypedetail() {
    this.accountService.set(this._getallruletypedetailAPI);
    return this.accountService.getAll();
  }
  addupdateanalysisruletypesetup(scenario: Scenario) {
    this.accountService.set(this._addupdateanalysisruletypesetupAPI);
    return this.accountService.post(JSON.stringify(scenario));
  }

  getruletypesetupbyobjectId(id) {
    this.accountService.set(this._getruletypesetupbyobjectIdAPI);
    return this.accountService.post(JSON.stringify(id));

  }

  deleteScenario(Sec) {
    this.accountService.set(this._deletescenarioAPI);
    return this.accountService.post(JSON.stringify(Sec));
  }
}
