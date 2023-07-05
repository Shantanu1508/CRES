
import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { User } from '../domain/user.model';
import { Search } from '../domain/search.model';
import { UserDelegateConfiguration } from '../domain/userDelegateConfiguration.model';

@Injectable()
export class UserService {

  private _UpdateUserCredentialByUserIDAPI: string = 'api/account/UpdateUserCredentialByUserID';
  private _searchGetAutosuggestSearchUserNameAPI: string = 'api/search/getautosuggestsearchusername';
  private _InsertuserdelegateconfigAPI: string = 'api/account/insertuserdelegateconfig';
  private _getAllActiveDelegatedUser: string = 'api/account/getallactivedelegateduser';
  private _InsertdelegatehistoryAPI: string = 'api/account/insertdelegatehistory';
  private _impersonateUserByUserIDAPI: string = 'api/account/impersonateUserByUserID';
  private _revokeUserDelegateConfigByUserDelegateConfigIDAPI: string = 'api/account/RevokeUserDelegateConfigByUserDelegateConfigID';


  constructor(public accountService: DataService) { }

  UpdateUserCredentialByUserID(creds: User) {
    this.accountService.set(this._UpdateUserCredentialByUserIDAPI);
    return this.accountService.post(JSON.stringify(creds));
  }

  getAutosuggestSearchUsername(_search: Search, pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._searchGetAutosuggestSearchUserNameAPI, pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(_search));
  }

  insertUserDelegateConfig(_UserDelegateConfiguration: UserDelegateConfiguration) {
    this.accountService.set(this._InsertuserdelegateconfigAPI);
    return this.accountService.post(JSON.stringify(_UserDelegateConfiguration));
  }
  InsertDelegateHistory(_UserDelegateConfiguration: UserDelegateConfiguration) {
    this.accountService.set(this._InsertdelegatehistoryAPI);
    return this.accountService.post(JSON.stringify(_UserDelegateConfiguration));
  }

  ImpersonateUserByUserID(_udc: UserDelegateConfiguration) {
    this.accountService.set(this._impersonateUserByUserIDAPI);
    return this.accountService.post(JSON.stringify(_udc));
  }

  getAllActiveDelegatedUser() {
    this.accountService.set(this._getAllActiveDelegatedUser);
    return this.accountService.getAll();
  }

  RevokeUserDelegateConfigByUserDelegateConfigID(ID: string) {
    this.accountService.set(this._revokeUserDelegateConfigByUserDelegateConfigIDAPI);
    return this.accountService.getByID(ID);
  }
}
