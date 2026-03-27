import { Injectable } from '@angular/core';
import { DataService } from './data.service';

@Injectable()
export class functionService {
  private _functionGetfilesAPI: string = 'api/aws/getfiles';
  private _functionGetfileAPI: string = 'api/aws/getFile';
  private _functionGetfoldersAPI: string = 'api/aws/getfolders';
  private _functionGetgetfilesbyfolderAPI: string = 'api/aws/getfilesbyfolder';
  private _functionclonefolderAPI: string = 'api/aws/clone';
  private _functioncreatezipAPI: string = 'api/aws/createzip';
  private _functionUpdateFileAPI: string = 'api/aws/updateFile';

  private _functiondeployZipAPI: string = 'api/aws/deployzip';
  private _functionCreateFunctionAPI: string = 'api/aws/createFunction';
  private _functionUpdateFunctionAPI: string = 'api/aws/updatefunction';
  private _functionInvokeFunctionAPI: string = 'api/aws/invokefunction';
  private _functiongetallFastFunctionAPI: string = 'api/aws/getallFastFunction';
  private _functionUpdateFileFunctionAPI: string = 'api/aws/updateFileFunction';

  constructor(public accountService: DataService) { }
  //getAllDeals(_user:User) {
  //    this.accountService.set(this._accountGetAllDeal);
  //    return this.accountService.post(_user);
  //}

  getfiles() {
    this.accountService.set(this._functionGetfilesAPI);
    return this.accountService.getAll();
  }

  getfile(id: string) {
    this.accountService.set(this._functionGetfileAPI);
    return this.accountService.getByIDWithOutJson(id);

  }

  getfolders() {
    this.accountService.set(this._functionGetfoldersAPI);
    return this.accountService.getAll();
  }
  getfilesbyfolder(id: string) {
    this.accountService.set(this._functionGetgetfilesbyfolderAPI);
    return this.accountService.getByID(id);
  }

  clonefolder(id: string, iddest: string) {
    this.accountService.set(this._functionclonefolderAPI);
    return this.accountService.getByIDAndIDDest(id, iddest);
  }

  createzip(id: string) {
    this.accountService.set(this._functioncreatezipAPI);
    return this.accountService.getByID(id);

  }

  updateFile(parameters:any) {
    this.accountService.set(this._functionUpdateFileAPI);
    //return this.accountService.PostWithParam(parameters);
    return this.accountService.post(JSON.stringify(parameters));
  }


  deployZip(id: string, iddest: string) {
    this.accountService.set(this._functiondeployZipAPI);
    return this.accountService.getByIDAndIDDest(id, iddest);
  }

  createFunction(parameters: any) {
    this.accountService.set(this._functionCreateFunctionAPI);
    return this.accountService.post(JSON.stringify(parameters));

  }

  updateFunction(parameters: any) {
    this.accountService.set(this._functionUpdateFunctionAPI);
    return this.accountService.post(JSON.stringify(parameters));
  }  

  invokeFunction(parameters: any) {
    this.accountService.set(this._functionInvokeFunctionAPI);
    return this.accountService.post(JSON.stringify(parameters));

  }

   

  updateFileFunction(parameters: any) {
    this.accountService.set(this._functionUpdateFileFunctionAPI);
    //return this.accountService.PostWithParam(parameters);
    return this.accountService.post(JSON.stringify(parameters));
  }


}
