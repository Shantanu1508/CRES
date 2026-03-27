import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { JournalLedger } from '../domain/journalLedger.model';

@Injectable()
export class journalLedgerService {

  private _GetJournalLedgerbyJournalEntryMasterGuidAPI: string = 'api/journalLedger/GetJournalLedgerbyJournalEntryMasterGuid';
  private _InsertUpdateJournalLedger: string = 'api/journalLedger/InsertUpdateJournalEntry';
  constructor(public datasrv: DataService) { }

  InsertUpdateJournalLedger(jldc) {
    this.datasrv.set(this._InsertUpdateJournalLedger);
    return this.datasrv.post(JSON.stringify(jldc));
  }

  GetJournalLedgerbyJournalEntryMasterGuid(JournalEntryMasterGuid: any) {
    this.datasrv.set(this._GetJournalLedgerbyJournalEntryMasterGuidAPI);
    return this.datasrv.post(JSON.stringify(JournalEntryMasterGuid));
  }
}
