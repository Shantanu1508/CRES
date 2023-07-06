import { Injectable, Output, EventEmitter } from '@angular/core';
import { Observable } from 'rxjs';
import { Subject } from 'rxjs';

@Injectable()
export class BusySpinnerService {
  dispatcher = new Subject();
  constructor() { }
}
