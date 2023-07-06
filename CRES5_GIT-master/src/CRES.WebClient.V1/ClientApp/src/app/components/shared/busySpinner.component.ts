import { Component, Input, Output, Renderer2, ViewChild, ElementRef, EventEmitter } from '@angular/core';
import { BusySpinnerService } from '../../core/services/busySpinner.service';

@Component({
  selector: 'busy-spinner',
  templateUrl: './busyspinner.html'
  //styleUrls: ['./busyspinner.component.min.css']
})
export class BusySpinnerComponent {
  @Input() busyIndicator !: Boolean;

  constructor(public busySpinnerService: BusySpinnerService) {
  }

  ngOnInit() {
    this.busySpinnerService.dispatcher.subscribe((val: any) => { this.busyIndicator = val });
  }
}
