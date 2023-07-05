"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NoteListModule = exports.NoteListComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var note_1 = require("../core/domain/note");
var NoteService_1 = require("../core/services/NoteService");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var NoteListComponent = /** @class */ (function (_super) {
    __extends(NoteListComponent, _super);
    function NoteListComponent(router, notesvc, utilityService) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this.router = router;
        _this.notesvc = notesvc;
        _this.utilityService = utilityService;
        //private routes = Routes;
        _this.updatedRowNo = [];
        _this.rowsToUpdate = [];
        _this._isNoteListFetching = false;
        _this._dvEmptyNoteSearchMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._ShowmessagedivWar = false;
        _this._ShowmessagedivMsgWar = '';
        _this._ShowmessagedivSequenceInfo = false;
        _this._ShowmessagedivSequenceMsgInfo = '';
        _this._note = new note_1.Note('');
        _this._noteCreate = new note_1.Note('');
        _this.getNotes(_this._note);
        _this.utilityService.setPageTitle("M61-Notes");
        return _this;
        //setTimeout(function () {
        //    this.flexnote.autoSizeColumns(0, this.flex.columns.length - 1, false, 20);
        //    this.flex.columns[0].width = 180; // for Note Id
        //    this.flex.columns[1].width = 320; // for DEal Name
        //}.bind(this), 1500);
    }
    // Component views are initialized
    NoteListComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        // commit row changes when scrolling the grid
        this.flexnote.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flexnote').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                //alert('this.flex.rows.length ' + this.flex.rows.length + 'this._totalCount ' + this._totalCount);
                if (_this.flexnote.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.getNotes(_this._note);
                }
            }
        });
    };
    NoteListComponent.prototype.getNotes = function (_note) {
        var _this = this;
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
        this.notesvc.getNotesByDealId(_note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstNotes;
                _this._totalCount = res.TotalCount;
                if (_this._pageIndex == 1) {
                    _this.lstNotes = data;
                    //remove first cell selection
                    _this.flexnote.selectionMode = wjcGrid.SelectionMode.None;
                    if (res.TotalCount == 0) {
                        _this._dvEmptyNoteSearchMsg = true;
                        //setTimeout(() => {
                        //    this._dvEmptyNoteSearchMsg = false;
                        //}, 2000);
                    }
                    //format date
                    for (var i = 0; i < _this.lstNotes.length; i++) {
                        if (_this.lstNotes[i].FirstPaymentDate != null) {
                            _this.lstNotes[i].FirstPaymentDate = new Date(_this.lstNotes[i].FirstPaymentDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                        if (_this.lstNotes[i].InitialInterestAccrualEndDate != null) {
                            _this.lstNotes[i].InitialInterestAccrualEndDate = new Date(_this.lstNotes[i].InitialInterestAccrualEndDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                    }
                }
                else {
                    data.forEach(function (obj, i) {
                        //format date
                        if (obj.FirstPaymentDate != null) {
                            obj.FirstPaymentDate = new Date(obj.FirstPaymentDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                        if (obj.InitialInterestAccrualEndDate != null) {
                            obj.InitialInterestAccrualEndDate = new Date(obj.InitialInterestAccrualEndDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                        //this.flex.rows.push(new wjcGrid.Row(obj));
                    });
                    _this.lstNotes = _this.lstNotes.concat(data);
                }
                _this._isNoteListFetching = false;
                //setTimeout(function () {
                //    this.flexnote.invalidate();
                //    this.flexnote.autoSizeColumns(0, this.flexnote.columns.length, false, 20);
                //    this.flexnote.columns[0].width = 350; // for Note Id
                //}.bind(this), 1);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    NoteListComponent.prototype.clickednote = function () {
        this._isNoteListFetching = true;
    };
    NoteListComponent.prototype.GetAllNoteLookups = function () {
        this.notesvc.getAllLookupById().subscribe(function (res) {
            var data = res.lstLookups;
            //this.lstRateType = data.filter(x => x.ParentID == "16"); 
            //this.lstRateTypemap = new wijmo.grid.DataMap(this.lstRateType, "LookupID", "Name"); 
            // alert('GetAll Look up' +JSON.stringify(this.lstRateTypemap) );
        });
    };
    NoteListComponent.prototype.selectionChangedHandler = function () {
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
    };
    NoteListComponent.prototype.AddUpdateNote = function () {
        try {
            this.rowsToUpdate = [];
            for (var i = 0; i < this.updatedRowNo.length; i++) {
                this.rowsToUpdate.push(this.lstNotes[this.updatedRowNo[i]]);
            }
        }
        catch (err) {
            console.log(err);
        }
        this._note = this.rowsToUpdate;
        this.notesvc.addNewNote(this._note).subscribe(function (res) {
            if (res.Succeeded) {
                //   alert("Succeed");   
            }
            else {
                //  alert("Fail");
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    NoteListComponent.prototype.AddNewNote = function () {
        this.noteaddpath = ['notedetail', { id: "00000000-0000-0000-0000-000000000000" }];
        this._router.navigate(this.noteaddpath);
    };
    // add a footer row to display column aggregates below the data
    NoteListComponent.prototype.addFooterRow = function (flexnote) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        // flex.columnFooters.rows.push(row); // add the row to the column footer panel
        // flex.bottomLeftCells.setCellData(0, 0, '\u03A3'); // sigma on the header
    };
    var _a, _b;
    __decorate([
        (0, core_1.ViewChild)('flexnote'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], NoteListComponent.prototype, "flexnote", void 0);
    NoteListComponent = __decorate([
        (0, core_1.Component)({
            selector: "note",
            templateUrl: "app/components/note.html?v=" + $.getVersion(),
            providers: [NoteService_1.NoteService]
        })
        //@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
        //    return isLoggedIn(next, previous);
        //})
        ,
        __metadata("design:paramtypes", [typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, NoteService_1.NoteService,
            utilityService_1.UtilityService])
    ], NoteListComponent);
    return NoteListComponent;
}(paginated_1.Paginated));
exports.NoteListComponent = NoteListComponent;
var routes = [
    { path: '', component: NoteListComponent }
];
var NoteListModule = /** @class */ (function () {
    function NoteListModule() {
    }
    NoteListModule = __decorate([
        (0, core_2.NgModule)({
            //  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [NoteListComponent]
        })
    ], NoteListModule);
    return NoteListModule;
}());
exports.NoteListModule = NoteListModule;
//# sourceMappingURL=note.component.js.map