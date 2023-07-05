import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SelectUserComponent } from './select-user/select-user.component';

@NgModule({
    imports: [
        CommonModule
    ],
    declarations: [SelectUserComponent],
    exports: [
        SelectUserComponent
    ]
})
export class ImpersonateUserModule { }
