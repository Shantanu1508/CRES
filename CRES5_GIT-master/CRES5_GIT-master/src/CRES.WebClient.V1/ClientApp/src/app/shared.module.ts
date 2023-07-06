import { NgModule, ModuleWithProviders } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { BusySpinnerComponent } from './components/shared/busySpinner.component';
import { BusySpinnerService } from './core/services/busySpinner.service';

@NgModule({
  imports: [CommonModule, ReactiveFormsModule],
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
