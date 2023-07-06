"use strict";
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
exports.FucntionModule = exports.FucntionComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var functionService_1 = require("../core/services/functionService");
var core_2 = require("@angular/core");
var utilityService_1 = require("../core/services/utilityService");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var FucntionComponent = /** @class */ (function () {
    function FucntionComponent(functionServiceSrv, utilityService, _router) {
        this.functionServiceSrv = functionServiceSrv;
        this.utilityService = utilityService;
        this._router = _router;
        this.zipfiles = [];
        this._isDefault = false;
        $.getScript("/js/editorfunction.js");
        localStorage.setItem('editorData', 'test data');
        setTimeout("setData()", 500);
        //this.getFastFolderListFromDB();
        //this.getFolderList();
        //this.getFileList();
        this.utilityService.setPageTitle("M61–Files");
        //this.foldername = "Select";
        //this.zipfilename = "Select Zip File";
        //   this.zipfiles:any = [];
        //=new Array<string>();
    }
    FucntionComponent.prototype.getFileList = function () {
        var _this = this;
        this._isListFetching = true;
        this.functionServiceSrv.getfiles()
            .subscribe(function (res) {
            _this.data = res;
            _this._isListFetching = false;
        }, function (error) {
            _this.utilityService.navigateToSignIn();
        });
    };
    FucntionComponent.prototype.getFile = function (filename) {
        var _this = this;
        this._currentFileName = filename;
        this._isListFetching = true;
        this.functionServiceSrv.getfile(filename)
            .subscribe(function (res) {
            _this._isListFetching = false;
            localStorage.setItem('editorData', res._body);
            setTimeout("setData()", 500);
            _this._isSaveFile = true;
        }, function (error) {
            alert('error');
            //this.utilityService.navigateToSignIn();
            _this._isListFetching = false;
        });
    };
    FucntionComponent.prototype.ngOnInit = function () {
        // get return url from route parameters or default to '/'
        $('#mainSpliter').enhsplitter({ handle: 'lotsofdots', position: 435, leftMinSize: 0, fixed: false });
    };
    FucntionComponent.prototype.getFolderList = function () {
        var _this = this;
        this._isListFetching = true;
        this.functionServiceSrv.getfolders()
            .subscribe(function (res) {
            _this.lstFolders = res;
            _this._isListFetching = false;
        }, function (error) {
            _this.utilityService.navigateToSignIn();
        });
    };
    FucntionComponent.prototype.getFastFolderListFromDB = function () {
        var _this = this;
        this.functionServiceSrv.getallFastFunction()
            .subscribe(function (res) {
            if (res != null && res.length > 0) {
                _this.lstFolderFromDB = res;
            }
        }, function (error) {
        });
    };
    FucntionComponent.prototype.getFileListByFolder = function () {
        var _this = this;
        this.zipfiles = [];
        this._isListFetching = true;
        this.functionServiceSrv.getfilesbyfolder(this.foldername)
            .subscribe(function (res) {
            if (res != null && res.length > 0) {
                _this.data = res;
                _this._isCopyShow = true;
                for (var i = 0; i < _this.data.length; i++) {
                    if (_this.data[i].replace(/^.*\./, '') == 'zip') {
                        _this.zipfiles.push(_this.data[i]);
                        _this._isDeployZip = true;
                    }
                }
                //$.each(this.data, function (key, value) {
                //    if (value.replace(/^.*\./, '') == 'zip') {
                //        if (this.zipfiles == undefined)
                //        {
                //            this.data1
                //            this.zipfiles = ["Select File"];
                //        }
                //        this.zipfiles.push(key);
                //    }
                //});
                console.log(_this.zipfiles);
            }
            else {
                _this._isCopyShow = false;
            }
            _this._isListFetching = false;
        }, function (error) {
            _this.utilityService.navigateToSignIn();
        });
    };
    FucntionComponent.prototype.cloneFolder = function () {
        var _this = this;
        if (this.foldername == 'Select') {
            alert('Please select source folder');
        }
        else if (this.DestFolder == '' || this.DestFolder == undefined) {
            alert('Please enter destinatio folder name');
        }
        else {
            this._isListFetching = true;
            this.functionServiceSrv.clonefolder(this.foldername, this.DestFolder)
                .subscribe(function (res) {
                _this._isListFetching = false;
                alert('Folder copied successfully');
            }, function (error) {
                alert('Error in copy folder');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    FucntionComponent.prototype.createZip = function () {
        var _this = this;
        if (this.foldername == 'Select') {
            alert('Please select source folder');
        }
        else {
            this._isListFetching = true;
            this.functionServiceSrv.createzip(this.foldername)
                .subscribe(function (res) {
                _this.getFileListByFolder();
                _this._isListFetching = false;
                alert('Zip created successfully');
            }, function (error) {
                alert('Error in creating zip');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    FucntionComponent.prototype.ChangeFolder = function (newvalue) {
        this.foldername = newvalue;
        this.data = null;
        if (newvalue != 'Select') {
            this.lstFolderFromDB.filter;
            var folderexist = this.lstFolderFromDB.filter(function (x) { return x.FunctionName == newvalue; });
            if (folderexist != null && folderexist.length > 0) {
                this._isDefault = folderexist[0].IsDefault;
            }
            else {
                this._isDefault = false;
            }
            this.getFileListByFolder();
        }
        else {
            this._isCopyShow = false;
            this._isDefault = false;
        }
    };
    FucntionComponent.prototype.ChangeZipFile = function (newvalue) {
        this.zipfilename = newvalue;
    };
    FucntionComponent.prototype.updateFile = function () {
        var _this = this;
        this._isListFetching = true;
        setTimeout('getData()', 100);
        setTimeout(function () {
            var fileContent = localStorage.getItem('editorOut');
            var parameters = {
                FileName: _this._currentFileName,
                FileContent: fileContent,
                FunctionName: _this.foldername,
                IsDefault: _this._isDefault
            };
            _this.functionServiceSrv.updateFileFunction(parameters).subscribe(function (res) {
                _this.getFastFolderListFromDB();
                _this._isListFetching = false;
                alert('File saved successfully');
            }, function (error) {
                _this._isListFetching = false;
                alert(error);
            });
        }, 200);
    };
    FucntionComponent.prototype.deployZip = function () {
        var _this = this;
        if (this.zipfilename == 'Select Zip File') {
            alert('Please select zip file to deploy');
        }
        else {
            this._isListFetching = true;
            this.functionServiceSrv.deployZip(this.foldername, this.zipfilename)
                .subscribe(function (res) {
                _this._isListFetching = false;
                alert('zip deploy successfully');
            }, function (error) {
                alert('Error in deploying zip');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    FucntionComponent.prototype.createFunction = function () {
        var _this = this;
        if (this.DestFolder == '' || this.DestFolder == undefined) {
            alert('Please enter function name');
        }
        else {
            this._isListFetching = true;
            var parameters = {
                SourceName: this.foldername,
                DestName: this.DestFolder,
                IsDefault: this._isDefault
            };
            this.functionServiceSrv.createFunction(parameters)
                .subscribe(function (res) {
                _this._isListFetching = false;
                _this.ClosePopUpCreateCopy();
                _this.getFastFolderListFromDB();
                _this.getFolderList();
                alert('function Created successfully');
                _this._isDefault = false;
            }, function (error) {
                alert('Error in creating function');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    FucntionComponent.prototype.updateFunction = function () {
        var _this = this;
        if (this.foldername == 'Select') {
            alert('Please select source folder');
        }
        else {
            this._isListFetching = true;
            var parameters = {
                SourceName: this.foldername,
                DestName: this.DestFolder,
                IsDefault: this._isDefault
            };
            this.functionServiceSrv.updateFunction(parameters)
                .subscribe(function (res) {
                _this._isListFetching = false;
                alert('function updated successfully');
                _this._isDefault = false;
            }, function (error) {
                alert('Error in updating function');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    FucntionComponent.prototype.invokeFunction = function () {
        var _this = this;
        if (this.foldername == 'Select') {
            alert('Please select source folder');
        }
        else {
            this._isListFetching = true;
            var inputjson = {
                "JsonData": {
                    "Deal": {
                        "size": "44200000.00",
                        "name": "StewModelTieout",
                        "description": "Stew Model Tie Out 20160718 excel file",
                        "id": "12341234",
                        "issueDate": "20161020",
                        "settlementDate": "20161020",
                        "firstPayDate": "20161108",
                        "calculationFrequency": "dynamic",
                        "calculateDeal": "dealSimStandard"
                    },
                    "Notes": [{
                            "name": "A",
                            "type": "Note",
                            "description": "A Note",
                            "id": "11115",
                            "InitialFundingAmount": 17100000.00,
                            "balanceTarget": 22100000.00,
                            "paymentFrequency": "monthly",
                            "dayCount": "30360",
                            "rateType": "floating",
                            "rateIndex": "L30",
                            "spreadCash": 0.025,
                            "spreadMaintain": 0.025,
                            "amRate": 0.052,
                            "amTerm": 360,
                            "ioTerm": 36,
                            "loanTerm": 60,
                            "stubAdvance": "true",
                            "originationFee": 0.01,
                            "exitFee": 0.01,
                            "extensionFee": 0.01,
                            "extensionTerm": 18,
                            "minimumFee": 0.01,
                            "additionalPik": 0,
                            "maturityDate": "20220120",
                            "closingDate": "20170120",
                            "registers": ["eopBal", "principal", "interest"],
                            "calculateAccount": "loanSimStandard",
                            "settlementDate": "20170123",
                            "PayFrequency": "M"
                        }
                    ],
                    "Accounts": [{
                            "name": "EQUITYACORE",
                            "type": "Entity",
                            "description": "ACORE Lender Account",
                            "id": "21115",
                            "balanceInit": 0,
                            "registers": ["cash"]
                        },
                        {
                            "name": "EQUITYDELPHI",
                            "type": "Entity",
                            "description": "DELPHI Lender Account",
                            "id": "21116",
                            "balanceInit": 0,
                            "registers": ["cash"]
                        },
                        {
                            "name": "BORROWERCASH",
                            "type": "Entity",
                            "description": "Borrower Account",
                            "id": "21117",
                            "balanceInit": 0,
                            "registers": ["cash"]
                        }],
                    "variables": [{
                            "arbitrary2DArrayxxxxx": [
                                [0, 10],
                                [30, 50],
                                [90, 100]
                            ]
                        },
                        {
                            "asOfDate": "20160901"
                        }
                    ],
                    "Rules": [
                        {
                            "Name": "1",
                            "description": "Transfer $1038483 from Note 123 to Entity 232043 on Settlement Date of Note 123",
                            "when": {
                                "condition": "Period",
                                "conditionParameters": {
                                    "type": "Note",
                                    "id": "11115",
                                    "attribute": "settlementDate"
                                }
                            },
                            "action": {
                                "Name": "Transfer",
                                "actionParameters": {
                                    "Amount": "1038483",
                                    "From": {
                                        "type": "Note",
                                        "id": "11115"
                                    },
                                    "To": {
                                        "type": "Entity",
                                        "id": "21115"
                                    }
                                }
                            },
                            "priority": "6"
                        },
                        {
                            "Name": "2",
                            "description": "Calculate Note 123 for every period",
                            "when": "",
                            "action": {
                                "actionHandler": "Note",
                                "Name": "Calculate",
                                "actionParameters": {
                                    "type": "Note",
                                    "id": "11115"
                                }
                            },
                            "priority": "5"
                        }
                    ]
                }
            };
            //this._isCalcJsonFetched = true;
            var parameters = {
                FunctionName: this.foldername,
                PlayLoad: JSON.stringify(inputjson)
            };
            this.functionServiceSrv.invokeFunction(parameters)
                .subscribe(function (res) {
                _this._isListFetching = false;
                if (res != "")
                    alert(res);
                else
                    alert('Error-Something went wrong');
            }, function (error) {
                alert('Error-Something went wrong');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    FucntionComponent.prototype.showDialogCreateCopy = function () {
        if (this.foldername == 'Select') {
            alert('Please select version');
        }
        else {
            var modal = document.getElementById('myModalCreateCopy');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
    };
    FucntionComponent.prototype.ClosePopUpCreateCopy = function () {
        this.DestFolder = "";
        var modal = document.getElementById('myModalCreateCopy');
        $('#txtNoteJsonForScriptEngine').val('');
        $('#txtNoteJsonResponseForScriptEngine').val('');
        modal.style.display = "none";
    };
    FucntionComponent.prototype.updateAndDeploy = function () {
        var _this = this;
        if (this.foldername == 'Select') {
            alert('Please select version');
        }
        else {
            this._isListFetching = true;
            setTimeout('getData()', 100);
            setTimeout(function () {
                var fileContent = localStorage.getItem('editorOut');
                var parameters = {
                    FileName: _this._currentFileName,
                    FileContent: fileContent
                };
                _this.functionServiceSrv.updateFile(parameters).subscribe(function (res) {
                    //update
                    _this._isListFetching = true;
                    var parameters = {
                        SourceName: _this.foldername,
                        DestName: _this.DestFolder,
                        IsDefault: _this._isDefault
                    };
                    _this.functionServiceSrv.updateFunction(parameters)
                        .subscribe(function (res) {
                        _this.DeployFunction();
                        _this.getFastFolderListFromDB();
                    }, function (error) {
                        alert('Error in updating function');
                        _this.utilityService.navigateToSignIn();
                    });
                    //
                }, function (error) {
                    _this._isListFetching = false;
                    alert(error);
                });
            }, 200);
        }
    };
    FucntionComponent.prototype.DeployFunction = function () {
        var _this = this;
        if (this.foldername == 'Select') {
            alert('Please select version');
        }
        else {
            //this._isCalcJsonFetched = true;
            var parameters = {
                FunctionName: this.foldername
            };
            this.functionServiceSrv.invokeFunction(parameters)
                .subscribe(function (res) {
                //this._isDefault = false;
                _this._isListFetching = false;
                if (res != "")
                    alert(res);
                else
                    alert('Error-Something went wrong');
            }, function (error) {
                alert('Error-Something went wrong');
                _this.utilityService.navigateToSignIn();
            });
        }
    };
    var _a;
    FucntionComponent = __decorate([
        (0, core_1.Component)({
            selector: "function",
            templateUrl: "app/components/function.html?v=" + $.getVersion(),
            providers: [functionService_1.functionService]
        }),
        __metadata("design:paramtypes", [functionService_1.functionService,
            utilityService_1.UtilityService, typeof (_a = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _a : Object])
    ], FucntionComponent);
    return FucntionComponent;
}());
exports.FucntionComponent = FucntionComponent;
var routes = [
    { path: '', component: FucntionComponent }
];
var FucntionModule = /** @class */ (function () {
    function FucntionModule() {
    }
    FucntionModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [FucntionComponent]
        })
    ], FucntionModule);
    return FucntionModule;
}());
exports.FucntionModule = FucntionModule;
//# sourceMappingURL=function.component.js.map