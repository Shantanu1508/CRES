import { NgModule, ModuleWithProviders } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { Router } from '@angular/router';
import { BusySpinnerComponent } from './components/shared/busySpinner.component';
import { BusySpinnerService } from './core/services/busySpinner.service';
@NgModule({
  imports: [CommonModule, RouterModule, HttpClient, ReactiveFormsModule],
  declarations: [BusySpinnerComponent],
  exports: [BusySpinnerComponent],
  providers: [BusySpinnerService]
})
export class SharedModule {
  static forRoot(): ModuleWithProviders<any> {
    return {
      ngModule: SharedModule
    }
  }

}
