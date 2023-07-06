import { Component, Input, Output, Renderer2, ViewChild, ElementRef, EventEmitter } from '@angular/core';
import { BusySpinnerService } from '../../core/services/busyspinnerService';

@Component({
    selector: 'busy-spinner',
    templateUrl: 'app/components/shared/busyspinner.component.html'
    //styleUrls: ['./busyspinner.component.min.css']
})
export class BusySpinnerComponent {
    @Input() busyIndicator: Boolean;

    constructor(public busySpinnerService: BusySpinnerService) {
    }

    ngOnInit() {
        this.busySpinnerService.dispatcher.subscribe((val: Boolean) => { this.busyIndicator = val });
    }
}