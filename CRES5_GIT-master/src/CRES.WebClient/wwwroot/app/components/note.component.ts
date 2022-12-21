import { Component, OnInit, AfterViewInit, ViewChild} from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import {Note} from "../core/domain/note"
import { OperationResult } from '../core/domain/operationResult';
import { NoteService } from '../core/services/NoteService';
import { UtilityService } from '../core/services/utilityService';
import { Paginated } from '../core/common/paginated';
import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core'
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
declare var $: any; 
@Component({
    selector: "note",
    templateUrl: "app/components/note.html?v=" + $.getVersion(),
    providers: [NoteService]
})


//@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
//    return isLoggedIn(next, previous);
//})

export class NoteListComponent extends Paginated {

    private _router: Router;
    private _note: Note;
    private _noteCreate: Note;
    private _notelist: any;
    // private test: any;
    noteaddpath: any;
    //private routes = Routes;
    private updatedRowNo: any = [];
    private rowsToUpdate: any = [];
    lstNotes: any;
    lstRateType: any;
    private _isNoteListFetching: boolean = false;
    private _dvEmptyNoteSearchMsg: boolean = false;
    private _Showmessagediv: boolean = false;
    private _ShowmessagedivMsg: string = '';

    private _ShowmessagedivWar: boolean = false;
    private _ShowmessagedivMsgWar: string = '';
    private _ShowmessagedivSequenceInfo: boolean = false;
    private _ShowmessagedivSequenceMsgInfo: string = '';
    @ViewChild('flexnote') flexnote: wjcGrid.FlexGrid;
    lstRateTypemap: wjcGrid.DataMap;

    constructor(private router: Router,
        public notesvc: NoteService,
        public utilityService: UtilityService)
   // public notificationService: NotificationService) 
    {
        super(50, 1, 0);
        this._note = new Note('');
           this._noteCreate = new Note('');
        this.getNotes(this._note);
        this.utilityService.setPageTitle("M61-Notes");
        //setTimeout(function () {
        //    this.flexnote.autoSizeColumns(0, this.flex.columns.length - 1, false, 20);
        //    this.flex.columns[0].width = 180; // for Note Id
        //    this.flex.columns[1].width = 320; // for DEal Name
        //}.bind(this), 1500);
    }

    // Component views are initialized
    ngAfterViewInit() {
        // commit row changes when scrolling the grid
        this.flexnote.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flexnote').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                //alert('this.flex.rows.length ' + this.flex.rows.length + 'this._totalCount ' + this._totalCount);
                if (this.flexnote.rows.length < this._totalCount) {
                    this._pageIndex = this.pagePlus(1);
                    this.getNotes(this._note);
                }
            }
        });
    }

    getNotes(_note: Note): void {  
        
        if (localStorage.getItem('divSucessNote') == 'true') {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgNote');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessNote', JSON.stringify(false));
            localStorage.setItem('divSucessMsgNote', JSON.stringify(''));
            setTimeout(function () {
                this._Showmessagediv = false;
            }.bind(this), 5000);
        }
        if (localStorage.getItem('divInfoNote') == 'true') {
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = localStorage.getItem('divInfoMsgNote');
            if (this._ShowmessagedivMsgWar != "") {
                this._ShowmessagedivMsgWar = (this._ShowmessagedivMsgWar.replace('\"', '')).replace('\"', '');
            }
            localStorage.setItem('divInfoNote', JSON.stringify(false));
            localStorage.setItem('divInfoMsgNote', JSON.stringify(''));
            setTimeout(function () {
                this._ShowmessagedivWar = false;
            }.bind(this), 5000);
        }
        if (localStorage.getItem('divWarNote') == 'true') {
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = localStorage.getItem('divWarMsgNote');
            this._ShowmessagedivMsgWar = (this._ShowmessagedivMsgWar.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divWarNote', JSON.stringify(false));
            localStorage.setItem('divWarMsgNote', JSON.stringify(''));
            setTimeout(function () {
                this._ShowmessagedivWar = false;
            }.bind(this), 5000);
        }


        this._isNoteListFetching = true;
        this.notesvc.getNotesByDealId(_note, this._pageIndex, this._pageSize).subscribe(res => {
            if (res.Succeeded) {                
                var data: any = res.lstNotes;
                this._totalCount = res.TotalCount;

                if (this._pageIndex == 1) {
                    this.lstNotes = data;
                  
                    //remove first cell selection
                    this.flexnote.selectionMode = wjcGrid.SelectionMode.None;

                    if (res.TotalCount == 0) {
                        this._dvEmptyNoteSearchMsg = true;
                        //setTimeout(() => {
                        //    this._dvEmptyNoteSearchMsg = false;
                        //}, 2000);
                    }

                    //format date
                    for (var i = 0; i < this.lstNotes.length; i++) {
                        if (this.lstNotes[i].FirstPaymentDate != null) {
                            this.lstNotes[i].FirstPaymentDate = new Date(this.lstNotes[i].FirstPaymentDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                        if (this.lstNotes[i].InitialInterestAccrualEndDate != null) {
                            this.lstNotes[i].InitialInterestAccrualEndDate = new Date(this.lstNotes[i].InitialInterestAccrualEndDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                    }
                }
                else {
                    data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!

                        //format date
                        if (obj.FirstPaymentDate != null) {
                            obj.FirstPaymentDate = new Date(obj.FirstPaymentDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                        if (obj.InitialInterestAccrualEndDate != null) {
                            obj.InitialInterestAccrualEndDate = new Date(obj.InitialInterestAccrualEndDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }

                        //this.flex.rows.push(new wjcGrid.Row(obj));
                    });
                    this.lstNotes = this.lstNotes.concat(data);
                }
                this._isNoteListFetching = false;

                //setTimeout(function () {
                //    this.flexnote.invalidate();
                //    this.flexnote.autoSizeColumns(0, this.flexnote.columns.length, false, 20);
                //    this.flexnote.columns[0].width = 350; // for Note Id
                //}.bind(this), 1);

            }
            else {
                this.utilityService.navigateToSignIn();
            }
        });
        error => console.error('Error: ' + error)
    }

    clickednote() {       
        this._isNoteListFetching = true;
    }

    GetAllNoteLookups(): void {
        this.notesvc.getAllLookupById().subscribe(res => {

            var data = res.lstLookups;
            //this.lstRateType = data.filter(x => x.ParentID == "16"); 
            //this.lstRateTypemap = new wijmo.grid.DataMap(this.lstRateType, "LookupID", "Name"); 
            // alert('GetAll Look up' +JSON.stringify(this.lstRateTypemap) );
        });
    }

    selectionChangedHandler() {
        var flexnote = this.flexnote;
        var rowIdx = this.flexnote.collectionView.currentPosition;
        try {
            var count = this.updatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.updatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    }

    AddUpdateNote(): void {
        try {
            this.rowsToUpdate = [];
            for (var i = 0; i < this.updatedRowNo.length; i++) {
                this.rowsToUpdate.push(this.lstNotes[this.updatedRowNo[i]]);
            }
        }
        catch (err) {
            console.log(err);
        }

        this._note = this.rowsToUpdate

        this.notesvc.addNewNote(this._note).subscribe(res => {
            if (res.Succeeded) {
                //   alert("Succeed");   
            }
            else {
                //  alert("Fail");
            }
        });
        error => console.error('Error: ' + error)
    }

    AddNewNote(): void {
        this.noteaddpath = ['notedetail', { id: "00000000-0000-0000-0000-000000000000" }]
        this._router.navigate(this.noteaddpath)
    }

    // add a footer row to display column aggregates below the data
    addFooterRow(flexnote: wjcGrid.FlexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
       // flex.columnFooters.rows.push(row); // add the row to the column footer panel
       // flex.bottomLeftCells.setCellData(0, 0, '\u03A3'); // sigma on the header
    }


}


const routes: Routes = [

    { path: '', component: NoteListComponent }]

@NgModule({
  //  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    declarations: [NoteListComponent]

})

export class NoteListModule { }






