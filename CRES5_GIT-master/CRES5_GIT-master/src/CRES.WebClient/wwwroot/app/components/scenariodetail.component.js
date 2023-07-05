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
exports.ScenarioDetailModule = exports.ScenarioDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var scenario_1 = require("../core/domain/scenario");
var scenarioService_1 = require("../core/services/scenarioService");
var notificationService_1 = require("../core/services/notificationService");
var dataService_1 = require("../core/services/dataService");
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
var functionService_1 = require("../core/services/functionService");
var ScenarioDetailComponent = /** @class */ (function (_super) {
    __extends(ScenarioDetailComponent, _super);
    function ScenarioDetailComponent(activatedRoute, _router, scenarioService, utilityService, dataService, notificationService, functionServiceSrv) {
        var _this = _super.call(this, 30, 0, 0) || this;
        _this.activatedRoute = activatedRoute;
        _this._router = _router;
        _this.scenarioService = scenarioService;
        _this.utilityService = utilityService;
        _this.dataService = dataService;
        _this.notificationService = notificationService;
        _this.functionServiceSrv = functionServiceSrv;
        _this.indexupdatedRowNo = [];
        _this.indexrowsToUpdate = [];
        _this._ShowmessagedivWar = false;
        _this.TotalCount = 0;
        _this.subCategories = [];
        _this.Message = '';
        _this._Showmessagediv = false;
        _this._isScenarioDetailFetching = true;
        _this._isShowScenarioRuleType = false;
        _this._isScrolled = true;
        _this._scenariosearch = new scenario_1.Scenariosearch();
        _this._isIndexLoad = true;
        _this._isShowLoader = false;
        _this.lstBusinessDayAdjustment = [];
        _this.lstTemplatename = [];
        _this._lstsunruletype = [];
        _this._lstruletype = [];
        _this._lstruletypedetail = [];
        _this.cityMap = [];
        _this.listruletype = [];
        _this._isReadOnlyRuleTypeName = true;
        _this._lstRuleTypeSetupNew = [];
        _this._isShowSaveScenario = true;
        _this.cellRuleTypeEditHandler = function (s, e) {
            var col = s.columns[e.col];
            if (col.binding == 'FileName') {
                var RuleTypeName = s.rows[e.row].dataItem.RuleTypeName;
                switch (RuleTypeName) {
                    case RuleTypeName:
                        this.lstRuleTypebyruleid = this._lstruletypedetail.filter(function (x) { return x.RuleTypeName == RuleTypeName; });
                        this.lstRuleTypebyruleid.sort(this.sortByName);
                        col.dataMap = this._buildDataMapWithoutLookupNew(this.lstRuleTypebyruleid);
                        break;
                    default:
                        col.dataMap = this._buildDataMapWithoutLookupNew(this._lstruletypedetail);
                        break;
                }
            }
        };
        _this.activatedRoute.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                var scenarioaId = params['id'];
                _this._scenariodc = new scenario_1.Scenario(scenarioaId);
                _this.analysisid = scenarioaId;
                //  this.GetAllLookups();
                _this.GetScenarioByID(scenarioaId);
            }
        });
        _this.getFastFolderList();
        _this.utilityService.setPageTitle("M61 – Scenario Details");
        return _this;
    }
    ScenarioDetailComponent.prototype.GetScenarioByID = function (_scenarioaId) {
        var _this = this;
        try {
            this.scenarioService.GetScenarioByScenarioID(_scenarioaId).subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        _this._scenariodc = res.ScenarioParameters;
                        var _isV1UIEnable = _this.dataService._isV1UIEnable;
                        if (_isV1UIEnable == "true") {
                            _this._isShowScenarioRuleType = true;
                        }
                        else {
                            _this._isShowScenarioRuleType = false;
                        }
                        //this.GetIndexByScenarioID(_scenarioaId);
                        _this.GetAllLookups();
                        _this.GetAllIndexes();
                        _this._isScenarioDetailFetching = false;
                    }
                    else {
                        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                        _this.utilityService.navigateUnauthorize();
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    ScenarioDetailComponent.prototype.GetAllLookups = function () {
        var _this = this;
        try {
            //this.onload();
            this.getAllRuleType();
            this.GetAllRuleTypeDetail();
            setTimeout(function () {
                this.GetRuleTypeSetupByObjectId();
            }.bind(this), 1000);
            this.scenarioService.getAllLookup().subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.lstLookups;
                    _this.lstMaturityScenarioOverride = data.filter(function (x) { return x.ParentID == "52"; });
                    _this.lstCalculationMode = data.filter(function (x) { return x.ParentID == "79"; });
                    _this.lstExcludedForcastedPrePayment = data.filter(function (x) { return x.ParentID == "2"; });
                    _this.lstAutoCalcFreq = data.filter(function (x) { return x.ParentID == "98"; });
                    _this.lstUseActuals = data.filter(function (x) { return x.ParentID == "2"; });
                    _this.lstBusinessDayAdjustment = data.filter(function (x) { return x.ParentID == "2"; });
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    ScenarioDetailComponent.prototype._buildDataMapWithoutLookupNew = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['FileName'], value: obj['FileName'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    ScenarioDetailComponent.prototype.getAllRuleType = function () {
        var _this = this;
        this.scenarioService.getallruletype().subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstruletype = res.lstScenariorule;
            }
        });
    };
    ScenarioDetailComponent.prototype.GetAllRuleTypeDetail = function () {
        var _this = this;
        this.scenarioService.getallruletypedetail().subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstruletypedetail = res.lstScenarioRuleDetail;
                var RuleType = _this.RuleTypeList;
                if (RuleType) {
                    var colRuleType = RuleType.columns.getColumn('FileName');
                    if (colRuleType) {
                        colRuleType.showDropDown = true;
                        colRuleType.dataMap = _this._buildDataMapWithoutLookupNew(_this._lstruletypedetail);
                    }
                }
            }
        });
    };
    ScenarioDetailComponent.prototype.GetRuleTypeSetupByObjectId = function () {
        var _this = this;
        this.scenarioService.getruletypesetupbyobjectId(this._scenariodc.AnalysisID).subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstruletype = res.lstScenariorule;
            }
        });
    };
    ScenarioDetailComponent.prototype.sortByName = function (a, b) {
        var textA = a.FileName.toUpperCase();
        var textB = b.FileName.toUpperCase();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    };
    ScenarioDetailComponent.prototype.AddUpdateAnalusisRuleTypeSetup = function () {
        var _this = this;
        var RuleTypelength = 0;
        if (this.RuleTypeList.allowAddNew == false) {
            RuleTypelength = this.RuleTypeList.rows.length;
        }
        else {
            RuleTypelength = this.RuleTypeList.rows.length - 1;
        }
        for (var h = 0; h < RuleTypelength; h++) {
            if (Object.keys(this.RuleTypeList.rows[h]).length > 0) {
                var RuleTypeDetailID = this._lstruletypedetail.find(function (x) { return x.FileName == _this.RuleTypeList.rows[h].dataItem.FileName; }).RuleTypeDetailID;
                this._lstRuleTypeSetupNew.push({
                    'AnalysisID': this._scenariodc.AnalysisID,
                    'RuleTypeMasterID': this._lstruletype[h].RuleTypeMasterID,
                    'RuleTypeDetailID': RuleTypeDetailID,
                });
            }
        }
        this.scenarioService.addupdateanalysisruletypesetup(this._lstRuleTypeSetupNew).subscribe(function (res) {
            if (res.Succeeded) {
            }
        });
    };
    ScenarioDetailComponent.prototype.GetAllIndexes = function () {
        var _this = this;
        try {
            this.scenarioService.getIndexesFromIndexesMaster().subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lstIndexesMaster = res.lstIndexesMaster;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    ScenarioDetailComponent.prototype.DiscardChanges = function () {
        this._router.navigate(['scenarios']);
    };
    ScenarioDetailComponent.prototype.CustomAlert = function (dialog) {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - Validation Error";
        document.getElementById('dialogboxbody').innerHTML = dialog;
    };
    ScenarioDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    ScenarioDetailComponent.prototype.ValidateScenarioAndSave = function (Actionstatus) {
        var _this = this;
        try {
            this._isShowLoader = true;
            this._isShowSaveScenario = false;
            var RuleTypelength = 0;
            var ruletypeerror = '';
            var dtRuleType = [];
            if (this._isShowScenarioRuleType == true) {
                if (this.RuleTypeList.allowAddNew == false) {
                    RuleTypelength = this.RuleTypeList.rows.length;
                }
                else {
                    RuleTypelength = this.RuleTypeList.rows.length - 1;
                }
                for (var h = 0; h < RuleTypelength; h++) {
                    if (Object.keys(this.RuleTypeList.rows[h]).length > 0) {
                        dtRuleType.push({
                            'RuleTypeDetail': this.RuleTypeList.rows[h].dataItem.FileName
                        });
                    }
                }
                for (var l = 0; l < dtRuleType.length; l++) {
                    if (dtRuleType[l].RuleTypeDetail == null || dtRuleType[l].RuleTypeDetail == "" || dtRuleType[l].RuleTypeDetail == undefined) {
                        ruletypeerror = "Please select the template(s).";
                    }
                }
            }
            if (ruletypeerror != "") {
                this._isShowLoader = false;
                this._isShowSaveScenario = true;
                this.CustomAlert(ruletypeerror);
            }
            else {
                this._scenariodc.AnalysisID = this.analysisid;
                if (this._scenariodc.ScenarioName != "" && this._scenariodc.ScenarioName != null) {
                    this.scenarioService.CheckDuplicateScenario(this._scenariodc).subscribe(function (res) {
                        if (res.Succeeded) {
                            if (res.Message != "Duplicate") {
                                _this.InsertUpdateScenario();
                                // this._isShowLoader = false;
                            }
                            else {
                                _this._ShowmessagedivWar = true;
                                _this._ShowmessagedivMsgWar = "Scenario with same name already exits, please use different scenario name.";
                                _this._isScenarioDetailFetching = false;
                                _this._isShowLoader = false;
                                _this._isShowSaveScenario = true;
                                setTimeout(function () {
                                    _this._ShowmessagedivWar = false;
                                    _this._ShowmessagedivMsgWar = "";
                                }, 3000);
                            }
                        }
                        else {
                            _this._router.navigate(['login']);
                        }
                    });
                }
                else {
                    this._ShowmessagedivWar = true;
                    this._ShowmessagedivMsgWar = "Please fill Scenario name.";
                    this._isShowSaveScenario = true;
                    this._isScenarioDetailFetching = false;
                    this._isShowLoader = false;
                    setTimeout(function () {
                        _this._ShowmessagedivWar = false;
                        _this._ShowmessagedivMsgWar = "";
                    }, 3000);
                }
            }
        }
        catch (err) {
        }
    };
    ScenarioDetailComponent.prototype.InsertUpdateScenario = function () {
        var _this = this;
        try {
            this.scenarioService.InsertUpdateScenario(this._scenariodc).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.analysisid = res.newscenarioid;
                    _this._scenariodc.AnalysisID = _this.analysisid;
                    if (_this._isShowScenarioRuleType == true) {
                        _this.AddUpdateAnalusisRuleTypeSetup();
                    }
                    localStorage.setItem('divSucessScenario', JSON.stringify(true));
                    localStorage.setItem('successmsgscenario', JSON.stringify(res.ScenarioMsg));
                    _this._router.navigate(['scenarios']);
                    //this.UpdateIndex(this.analysisid);
                    _this._isShowLoader = false;
                    _this._isShowSaveScenario = true;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    ScenarioDetailComponent.prototype.adjustdescrtiptionheight = function () {
        var cont = $("#Description");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    };
    // index grid saving code
    ScenarioDetailComponent.prototype.ScenarioDetailselectionChanged = function () {
        //var flexIndex = this.flexScenarioDetail;
        //var rowIdx = this.flexScenarioDetail.collectionView.currentPosition;
        try {
            //var count = this.indexupdatedRowNo.indexOf(rowIdx);
            //if (count == -1)
            //    this.indexupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    ScenarioDetailComponent.prototype.beginningEdit = function (modulename) {
        switch (modulename) {
            case "ScenarioDetail":
                var sel = this.flexScenarioDetail.selection;
                if (this.scenarioDetaildata[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this.scenarioDetaildata[sel.topRow].Date;
                break;
        }
    };
    ScenarioDetailComponent.prototype.getFastFolderList = function () {
        var _this = this;
        this.functionServiceSrv.getallFastFunction()
            .subscribe(function (res) {
            _this.lstFolders = res;
            if (_this.lstFolders != null && _this.lstFolders.length > 0) {
                _this.autoVerfoldername = _this.lstFolders[0].FunctionName;
                _this.lstFolders[0].FunctionName = "Auto-Version";
                _this.foldername = "Auto-Version";
            }
        }, function (error) {
            _this.utilityService.navigateToSignIn();
        });
    };
    ScenarioDetailComponent.prototype.ChangeFolder = function (newvalue) {
        this.foldername = newvalue;
    };
    var _a, _b, _c, _d;
    __decorate([
        (0, core_1.ViewChild)('RuleTypeList'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], ScenarioDetailComponent.prototype, "RuleTypeList", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexScenarioDetail'),
        __metadata("design:type", typeof (_b = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _b : Object)
    ], ScenarioDetailComponent.prototype, "flexScenarioDetail", void 0);
    ScenarioDetailComponent = __decorate([
        (0, core_1.Component)({
            selector: "scenariodetail",
            templateUrl: "app/components/Scenariodetail.html",
            providers: [scenarioService_1.scenarioService, notificationService_1.NotificationService, utilityService_1.UtilityService, functionService_1.functionService],
        }),
        __metadata("design:paramtypes", [typeof (_c = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _c : Object, typeof (_d = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _d : Object, scenarioService_1.scenarioService,
            utilityService_1.UtilityService,
            dataService_1.DataService,
            notificationService_1.NotificationService,
            functionService_1.functionService])
    ], ScenarioDetailComponent);
    return ScenarioDetailComponent;
}(paginated_1.Paginated));
exports.ScenarioDetailComponent = ScenarioDetailComponent;
var routes = [
    { path: '', component: ScenarioDetailComponent }
];
var ScenarioDetailModule = /** @class */ (function () {
    function ScenarioDetailModule() {
    }
    ScenarioDetailModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [ScenarioDetailComponent]
        })
    ], ScenarioDetailModule);
    return ScenarioDetailModule;
}());
exports.ScenarioDetailModule = ScenarioDetailModule;
//# sourceMappingURL=scenariodetail.component.js.map