import { NgModule, ModuleWithProviders } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { Router } from '@angular/router';
import { BusySpinnerComponent } from './components/shared/busyspinner.component';
import { BusySpinnerService } from './core/services/busyspinnerService';
@NgModule({
    imports: [CommonModule, RouterModule, HttpModule, ReactiveFormsModule],
    declarations: [ BusySpinnerComponent],
    exports: [BusySpinnerComponent],
    providers: [BusySpinnerService]
})
export class SharedModule {
    static forRoot(): ModuleWithProviders {
        return {
            ngModule: SharedModule
        }
    }

}