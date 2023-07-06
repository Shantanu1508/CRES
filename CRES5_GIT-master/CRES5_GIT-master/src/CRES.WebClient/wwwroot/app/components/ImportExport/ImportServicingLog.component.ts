import { Component, OnInit, AfterViewInit, ViewChild, Injectable, Input, Output, EventEmitter } from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute, Params } from '@angular/router';
import { ImportServicingLogService } from '../../core/services/importservicinglogservice';
import { PermissionService } from '../../core/services/PermissionService';
import { isLoggedIn } from '../../core/services/is-logged-in';
import { backshopImport } from '../../core/domain/backshopImport';
import { IN_UnderwritingNotes } from '../../core/domain/IN_UnderwritingNotes';
import { UtilityService } from '../../core/services/utilityService';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { FileUploadService } from '../../core/services/fileuploadservice';
import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import * as wjcCore from 'wijmo/wijmo'


@Component({
    templateUrl: "app/components/ImportExport/ImportServicingLog.html",
    providers: [ImportServicingLogService, FileUploadService, PermissionService]
})


export class ImportServicingLogComponent {
    public isProcessComplete: boolean = false;
    fileReaded: any;
    validationmessage: any;
    _isconfirmed: boolean = false;
    public fileList: FileList;
    private myFileInputIdentifier: string = "tHiS_Id_IS_sPeeCiAL";
    public actionLog: string = "";
    errors: Array<string> = []; 
    _ShowdivMsgWar: boolean = false;
    _WarmsgdashBoad: any;
    dragAreaClass: string = 'dragarea';
    @Input() projectId: number = 0;
    @Input() sectionId: number = 0;
    @Input() fileExt: string = "xlsx";
    @Input() maxFiles: number = 1;
    @Input() maxSize: number = 15; // 15MB
    @Output() uploadStatus = new EventEmitter();
    _FromDate: Date;
    _ToDate: Date;
  //  FromDate: any=Date.toString();
   // ToDate: any=Date.toString();

    constructor(private ng2FileInputService: Ng2FileInputService,
        public fileUploadService: FileUploadService,
        public permissionService: PermissionService,
        public utilityService: UtilityService,
        private _router: Router) {
        this.GetUserPermission();
        this.utilityService.setPageTitle("M61-Sevicing Integration");       
    }

    AfterViewInit()
    {
        //reset ng2-file-input control after error occoured
        this.resetFileInput();
    }

    GetUserPermission(): void {
       
        this.permissionService.GetUserPermissionByPagename("Integration").subscribe(res => {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

                    this.utilityService.navigateUnauthorize();
                }
            }
        });
    }

    public onAction(event: any) {
        console.log(event);
        this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
        console.log(this.actionLog);
        //let fileList: FileList = event.currentFiles;
        this.fileList = event.currentFiles;
        //this.saveFiles(this.fileList);
    }
    public onAdded(event: any) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File added";

    }
    public onRemoved(event: any) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File removed";
    }
    public onInvalidDenied(event: any) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File denied";
    }
    public onCouldNotRemove(event: any) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: Could not remove file";
    }

    public resetFileInput(): void {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    }
    

    public logCurrentFiles(): void {
        let files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
        this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
    }
    private getFileNames(files: File[]): string {
        let names = files.map(file => file.name);
        return names ? names.join(", ") : "No files currently added.";
    }

    private isValidFiles(files) {
        // Check Number of files
        if (files.length > this.maxFiles) {
            this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
            return;
        }
        this.isValidFileExtension(files);
        return this.errors.length === 0;
    }

    private isValidFileExtension(files) {
        // Make array of file extensions
        var extensions = (this.fileExt.split(','))
            .map(function (x) { return x.toLocaleUpperCase().trim() });
        for (var i = 0; i < files.length; i++) {
            // Get file extension
            var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
            // Check the extension exists
            var exists = extensions.includes(ext);
            if (!exists) {
                this.errors.push("Please upload files with " + this.fileExt + " extension.");
            }
            // Check file size
            this.isValidFileSize(files[i]);
        }
    }

    private isValidFileSize(file) {
        var fileSizeinMB = file.size / (1024 * 1000);
        var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
        if (size > this.maxSize)
            this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
    }

    ImportServicing() {
        this.saveFiles();
    }

  

    getTwoDigitString(number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    }

    saveFiles() {
        //debugger;
        this.isProcessComplete = true;
        //this.saveFiles(this.fileList);
        let files = this.fileList;
        //alert('save123456 ' + this.fileList + " " + Boolean(files));
        this.errors = []; // Clear error        
        if (!this._FromDate || !this._ToDate) {
            this.CustomAlert("Please select date range.");
            this.isProcessComplete = false;
            return;
        }
        else if (this._FromDate > this._ToDate) {
            this.CustomAlert("End date can not be smaller then Start date.");
            this.isProcessComplete = false;
            return;
        }
        else if (this._FromDate == this._ToDate)
        {
            this.CustomAlert("Start date and End date can not be equal.");
            this.isProcessComplete = false;
            return;
        }
        if (!(Boolean(files))) {
            this.errors.push("Please select file with " + this.fileExt + " extension.");
            this.CustomAlert(this.errors);
            this.isProcessComplete = false;
            return;
        }
        // Validate file size and allowed extensions
        else if (files.length > 0 && (!this.isValidFiles(files))) {
            this.CustomAlert(this.errors);
            this.uploadStatus.emit(false);
            this.isProcessComplete = false;
            return;
        }
        else if (files.length > 0) {
            let formData: FormData = new FormData();
            for (var j = 0; j < files.length; j++) {
                formData.append("file[]", files[j], files[j].name);
            }

            var user = JSON.parse(localStorage.getItem('user'));
            var parameters = {
                userid: user.UserID,
                Fromdate:this.convertDateToBindable(this._FromDate),
                ToDate: this.convertDateToBindable(this._ToDate),
                isconfirmed: this._isconfirmed
            }
            
            this.fileUploadService.uploadcsv(formData, parameters)
                .subscribe(
                success => {                   
                        var smessage = success._body.split('==');

                    if (smessage[0] == "Success") {
                        this.uploadStatus.emit(true);
                    //    console.log(success);

                        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Servicing log file uploaded successfully'));

                        this._router.navigate(['/dashboard']);
                    }
                    else
                    {                     
                        this.uploadStatus.emit(true);
                       // console.log(success);
                        this._ShowdivMsgWar = true;
                     
                        if (smessage[1].indexOf(" transactions ") != -1) {
                            this.validationmessage = smessage[1];
                            this.showDialog();
                        }
                        else
                        {
                            this._WarmsgdashBoad = smessage[1];
                            this.isProcessComplete = false;
                            setTimeout(function () {
                                this._ShowdivMsgWar = false;
                            }.bind(this), 10000);
                            //reset ng2-file-input control after error occoured
                           // this.resetFileInput();
                        } 
                       
                    }
                },                     
            error => {
               
                    console.log(error);
                    this.isProcessComplete = false;
                    this.uploadStatus.emit(true);
                    this.errors.push(error.ExceptionMessage);
                })
        }

    }

    importServicing() {
        this._isconfirmed = true;
        this.saveFiles();
        this.ClosePopUp();
    }

    showDialog() { 
        this.isProcessComplete = false;
        this._ShowdivMsgWar = false;      
        var modalDelete = document.getElementById('myModal');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    ClosePopUp() {
      //  this.isProcessComplete = false;
        var modal = document.getElementById('myModal');
        modal.style.display = "none";
    }

    convertDateToBindable(date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    }

    CustomAlert(dialog): void {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - web";
        document.getElementById('dialogboxbody').innerHTML = dialog;
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    }
    ok(): void {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    }
}

const routes: Routes = [

    { path: '', component: ImportServicingLogComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjInputModule, Ng2FileInputModule.forRoot()],
    declarations: [ImportServicingLogComponent]
})

export class ImportServicingLogComponentModule {

}

