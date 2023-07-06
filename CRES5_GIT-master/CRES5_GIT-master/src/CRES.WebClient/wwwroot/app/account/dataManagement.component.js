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
exports.TreeItem = exports.DataManagementModule = exports.DataManagement = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var membershipservice_1 = require("../core/services/membershipservice");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var notificationservice_1 = require("../core/services/notificationservice");
var permissionService_1 = require("../core/services/permissionService");
var wjcGrid = require("wijmo/wijmo.grid");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wjcCore = require("wijmo/wijmo");
var deals_1 = require("../core/domain/deals");
var ruleType_1 = require("../core/domain/ruleType");
var dealservice_1 = require("../core/services/dealservice");
var utilityService_1 = require("../core/services/utilityService");
var NoteService_1 = require("../core/services/NoteService");
var note_1 = require("../core/domain/note");
var Module_1 = require("../core/domain/Module");
var ng2_file_input_1 = require("ng2-file-input");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var appsettings_1 = require("../core/common/appsettings");
var dataService_1 = require("../core/services/dataService");
var Note_1 = require("../core/domain/Note");
var changepassword_1 = require("../core/domain/changepassword");
var scenarioService_1 = require("../core/services/scenarioService");
var wijmo_angular2_nav_1 = require("wijmo/wijmo.angular2.nav");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var DataManagement = /** @class */ (function () {
    function DataManagement(notesvc, utilityService, notificationService, dealSrv, membershipService, router, dataService, scenarioService, permissionService, fileUploadService, _actrouting, ng2FileInputService) {
        var _this = this;
        this.notesvc = notesvc;
        this.utilityService = utilityService;
        this.notificationService = notificationService;
        this.dealSrv = dealSrv;
        this.membershipService = membershipService;
        this.router = router;
        this.dataService = dataService;
        this.scenarioService = scenarioService;
        this.permissionService = permissionService;
        this.fileUploadService = fileUploadService;
        this._actrouting = _actrouting;
        this.ng2FileInputService = ng2FileInputService;
        this.isAnimated = false;
        this.autoCollapse = false;
        this.expandOnClick = true;
        this._dealListFetching = false;
        this._isNoteListFetching = false;
        this._dvEmptyDealSearchMsg = false;
        this._ShowSuccessmessagediv = false;
        this._isShowNoteGrid = false;
        this._isShowDealGrid = false;
        this._isShowLoader = false;
        this.myFileInputIdentifier = "tHiS_Id_IS_sPeeCiAL";
        this.actionLog = "";
        this.errors = [];
        this.fileExt = "XLS, XLSX";
        this.maxFiles = 5;
        this.maxSize = 15; //15MB
        this.uploadStatus = new core_1.EventEmitter();
        this._ShowmessagedivWar = false;
        this._ShowmessagedivMsgWar = '';
        this.hideenvqa = true;
        this.hideenvinteg = true;
        this.hideenvstag = true;
        this.importingstatus = false;
        this.importprocessbar = false;
        this.environmentName = "";
        this._envprod = true;
        this.lstServicer = [];
        this.newjsontemplatename = '';
        this.JsonTemplateValue = '';
        this.JsonTemplateName = [];
        this.lstTemplatename = [];
        this.LastselectedRule = '';
        this.LastParentNode = '';
        this.selectedRule = '';
        this.ParentNode = '';
        this.ChangedRule = '';
        this.ChangedParentNode = '';
        this._isRuleChanged = false;
        this._isShowaddnewvalidation = false;
        this.validationtxt = '';
        this.listtransactiontype = [];
        this.transactionerror = false;
        this.lstHolidayCalendar = [];
        this.lstChangedTemplate = [];
        this.lstCalendarName = [];
        this.newCalendarname = '';
        this.myDefault = {
            HolidayMasterID: 411
        };
        this._isSavedHolidayDate = false;
        this._issyncbtnClicked = false;
        this.rolename = '';
        this._isShowAllTabs = true;
        this._isShowPowerBITab = false;
        permissionService.GetUserPermissionBySuperAdmin();
        this._deal = new deals_1.deals('');
        this.listruletype = new ruleType_1.ruletype('');
        ruleType_1.ruletype;
        this._note = new note_1.Note('');
        this._changepowerbipasswrd = new changepassword_1.changepowerbipasswrd();
        this._templatename = new Note_1.TemplateName();
        this._module = new Module_1.Module('');
        this.checkenv();
        this.servicer = new Note_1.Servicer(null, null, null);
        var _date = new Date();
        this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
        this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time
        if (this._dtUTCHours < 6) {
            this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        else {
            this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            this.rolename = rolename;
        }
        $.getScript("/js/editorfunction.js");
        localStorage.setItem("EditorValueChanged", "false");
        this._actrouting.queryParams.subscribe(function (params) {
            if (params['tab'] == "rule") {
                var ActiveTabID = 'aJsontemplatetab';
                setTimeout(function () {
                    document.getElementById(ActiveTabID).click();
                }.bind(_this), 200);
                _this.paraparentnode = params['ruletype'];
                _this.paraselectedrule = params['filename'];
            }
            else {
                var ActiveTabID = 'adeletedeal';
                setTimeout(function () {
                    document.getElementById(ActiveTabID).click();
                }.bind(_this), 200);
            }
        });
    }
    DataManagement.prototype.redirectonItemClicked = function (selectedrule, parentnode) {
        var _this = this;
        try {
            this._isShowLoader = true;
            this.selectedRule = "";
            this.ParentNode = "";
            if (this.isParentnodeClicked() == false) {
                var result = this.AllRulesList.find(function (x) { return x.RuleTypeDetailID == selectedrule; }).FileName;
                this._isShowLoader = true;
                this.selectedRule = result;
                this.ParentNode = parentnode;
                this._isShowLoader = true;
                var EditorValueChanged = localStorage.getItem('EditorValueChanged');
                if (EditorValueChanged == "true") {
                    this.JsonTemplateValueChange();
                    this._isRuleChanged = true;
                }
                else {
                    this._isRuleChanged = false;
                }
                this.LastselectedRule = result;
                this.LastParentNode = parentnode;
                if (this._isRuleChanged == true) {
                    //show dialog box and get data
                    this.RuleDataChanged();
                }
                else {
                    var getcontentfromdb = true;
                    if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
                        var tempselected = this.lstChangedTemplate.find(function (x) { return x.FileName == _this.selectedRule; });
                        if (tempselected != undefined && tempselected != null) {
                            getcontentfromdb = false;
                            this.JsonTemplateValue = tempselected.Content;
                            localStorage.setItem('editorData', tempselected.Content);
                            setTimeout("setData()", 500);
                            this.SetEditorParameterAfterDataLoad();
                        }
                    }
                    if (getcontentfromdb == true) {
                        this.GetContentByRule(this.selectedRule);
                    }
                }
            }
            else {
                this._isShowLoader = false;
            }
        }
        catch (e) {
            this._isShowLoader = false;
        }
    };
    DataManagement.prototype.searchDeal = function () {
        var _this = this;
        if (this._deal.CREDealID != '' && this._deal.CREDealID !== undefined) {
            this._dealListFetching = true;
            this._deal.DealID = this._deal.DealID.length != 36 ? '00000000-0000-0000-0000-000000000000' : this._deal.DealID;
            this.dealSrv.searchDealByCREDealIdOrDealName(this._deal)
                .subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lstdeal = res.lstDeals;
                    _this._dealListFetching = false;
                    if (_this.lstdeal.length == 0) {
                        _this._isShowDealGrid = false;
                        _this._ShowErrorMessage = "No matching records found";
                        _this._dvEmptyDealSearchMsg = true;
                        setTimeout(function () {
                            this._dvEmptyDealSearchMsg = false;
                        }.bind(_this), 5000);
                    }
                    else {
                        _this._isShowDealGrid = true;
                    }
                    setTimeout(function () {
                        this.flex.invalidate();
                        this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                        this.flex.columns[0].width = 350; // for Note Id
                    }.bind(_this), 1);
                    //
                }
                else {
                    _this._ShowErrorMessage = "Something went wrong.Please try after some time";
                    _this._dvEmptyDealSearchMsg = true;
                    setTimeout(function () {
                        this._dvEmptyDealSearchMsg = false;
                    }.bind(_this), 5000);
                    //this.utilityService.navigateToSignIn();
                }
            }, function (error) {
                if (error.status == 401) {
                    _this.notificationService.printErrorMessage('Authentication required');
                    _this.utilityService.navigateToSignIn();
                }
            });
        }
    };
    DataManagement.prototype.searchNote = function () {
        var _this = this;
        if (this._note.CRENoteID != '' && this._note.CRENoteID !== undefined) {
            this._isNoteListFetching = true;
            this.notesvc.searchNoteByCRENoteId(this._note)
                .subscribe(function (res) {
                if (res.Succeeded) {
                    _this._notelist = res.lstNotes;
                    _this._isNoteListFetching = false;
                    if (_this._notelist.length == 0) {
                        _this._isShowNoteGrid = false;
                        _this._ShowErrorMessage = "No matching records found";
                        _this._dvEmptyDealSearchMsg = true;
                        setTimeout(function () {
                            this._dvEmptyDealSearchMsg = false;
                        }.bind(_this), 5000);
                    }
                    else {
                        _this._isShowNoteGrid = true;
                    }
                    //
                }
                else {
                    _this._ShowErrorMessage = "Something went wrong.Please try after some time";
                    _this._dvEmptyDealSearchMsg = true;
                    setTimeout(function () {
                        this._dvEmptyDealSearchMsg = false;
                    }.bind(_this), 5000);
                    //this.utilityService.navigateToSignIn();
                }
            }, function (error) {
                if (error.status == 401) {
                    _this.notificationService.printErrorMessage('Authentication required');
                    _this.utilityService.navigateToSignIn();
                }
            });
        }
    };
    DataManagement.prototype.deleteModuleByID = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this._isShowLoader = true;
        this.ClosePopUp();
        this._module.DealID = this._module.DealID.length != 36 ? '00000000-0000-0000-0000-000000000000' : this._module.DealID;
        this._module.ModuleID = this._module.ModuleID.length != 36 ? '00000000-0000-0000-0000-000000000000' : this._module.ModuleID;
        this.dealSrv.deleteModuleByID(this._module)
            .subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowLoader = false;
                if (_this._module.ModuleName == "Deal") {
                    _this._isShowDealGrid = false;
                    _this._deal.CREDealID = "";
                }
                else {
                    _this._isShowNoteGrid = false;
                    _this._note.CRENoteID = "";
                }
                _this._ShowSuccessmessage = 'Record deleted successfully.';
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
                //
            }
            else {
                _this.ClosePopUp();
                _this._isShowLoader = false;
                _this._ShowErrorMessage = "Something went wrong.Please try after some time";
                _this._dvEmptyDealSearchMsg = true;
                setTimeout(function () {
                    this._dvEmptyDealSearchMsg = false;
                }.bind(_this), 5000);
                //this.utilityService.navigateToSignIn();
            }
        }, function (error) {
            if (error.status == 401) {
                _this.notificationService.printErrorMessage('Authentication required');
                _this.utilityService.navigateToSignIn();
            }
        });
    };
    DataManagement.prototype.showDialog = function (deletetype, moduleID, dealID, credealornoteId, dealornoteName) {
        var customdialogbox = document.getElementById('customdialogbox');
        customdialogbox.style.display = "block";
        this._module.ModuleID = moduleID;
        this._module.ModuleName = 'Note';
        this._module.DealID = dealID;
        if (deletetype == 'Deal') {
            this._module.ModuleName = 'Deal';
        }
        this._MsgText = 'You will not be able to recover the deleted ' + this._module.ModuleName.toLowerCase() + ' data. Are you sure you want to delete the ' + this._module.ModuleName.toLowerCase() + ': [' + credealornoteId + '] - [' + dealornoteName + ']?';
        $.getScript("/js/jsDrag.js");
    };
    DataManagement.prototype.ClosePopUp = function () {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
        //this.isProcessComplete = false;
    };
    DataManagement.prototype.onAdded = function (event, id) {
        this.filename = event.file.name;
        this.showWellsDialog();
    };
    DataManagement.prototype.onAction = function (event, uploadtype) {
        debugger;
        this.fileList = event.currentFiles;
        this.uploadtype = uploadtype;
    };
    DataManagement.prototype.showWellsDialog = function () {
        var modaltrans = document.getElementById('myModal');
        modaltrans.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DataManagement.prototype.CloseWellsPopUp = function () {
        //  this.isProcessComplete = false;
        var modal = document.getElementById('myModal');
        modal.style.display = "none";
    };
    DataManagement.prototype.ImportFile = function () {
        this.CloseWellsPopUp();
        this.saveFiles();
    };
    DataManagement.prototype.saveFiles = function () {
        var _this = this;
        this._isShowLoader = true;
        var files = this.fileList;
        this.errors = []; // Clear error
        debugger;
        if (!(Boolean(files)) || files == null || files.length == 0) {
            this.errors.push("Please select file with " + this.fileExt + " extension.");
            this.CustomAlert(this.errors);
            this._isShowLoader = false;
            return;
        }
        // Validate file size and allowed extensions
        else if (files.length > 0 && (!this.isValidFiles(files))) {
            this.CustomAlert(this.errors);
            this.uploadStatus.emit(false);
            this._isShowLoader = false;
            return;
        }
        else if (files.length > 0) {
            debugger;
            var formData = new FormData();
            for (var j = 0; j < files.length; j++) {
                formData.append("file[]", files[j], files[j].name);
            }
            var user = JSON.parse(localStorage.getItem('user'));
            var parameters = {
                userid: user.UserID,
                ObjectTypeID: 588,
                StorageType: appsettings_1.AppSettings._storageType,
                UploadType: this.uploadtype
            };
            this.fileUploadService.uploadObjectDocumentByStorageType(formData, parameters)
                .subscribe(function (success) {
                var smessage = success.split('==');
                if (smessage[0] == "Success") {
                    _this.uploadStatus.emit(true);
                    _this._ShowSuccessmessage = 'File uploaded successfully.';
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                        this._ShowSuccessmessage = "";
                    }.bind(_this), 5000);
                }
                else {
                    _this.uploadStatus.emit(true);
                    _this._ShowmessagedivMsgWar = smessage[1];
                    _this._ShowmessagedivWar = true;
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                        this._ShowmessagedivMsgWar = "";
                    }.bind(_this), 5000);
                }
                _this._isShowLoader = false;
                _this.fileList = null;
            }, function (error) {
                console.log(error);
                _this._isShowLoader = false;
                _this.uploadStatus.emit(true);
                _this.errors.push(error.ExceptionMessage);
            });
        }
    };
    DataManagement.prototype.isValidFiles = function (files) {
        // Check Number of files
        if (files.length > this.maxFiles) {
            this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
            return;
        }
        this.isValidFileExtension(files);
        return this.errors.length === 0;
    };
    DataManagement.prototype.isValidFileExtension = function (files) {
        // Make array of file extensions
        var extensions = (this.fileExt.split(','))
            .map(function (x) { return x.toLocaleUpperCase().trim(); });
        for (var i = 0; i < files.length; i++) {
            // Get file extension
            var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
            // Check the extension exists
            var exists = extensions.includes(ext);
            if (!exists) {
                this.errors.push("<BR/>Please upload file " + files[i].name + " with " + this.fileExt + " extension.");
            }
            // Check file size
            this.isValidFileSize(files[i]);
        }
    };
    DataManagement.prototype.isValidFileSize = function (file) {
        var fileSizeinMB = file.size / (1024 * 1000);
        var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
        if (size > this.maxSize)
            this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
    };
    DataManagement.prototype.CustomAlert = function (dialog) {
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
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    };
    DataManagement.prototype.resetFileInput = function () {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    };
    DataManagement.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
        this.CloseWellsPopUp();
    };
    DataManagement.prototype.checkenv = function () {
        this.environmentName = this.dataService._environmentNamae;
        if (this.environmentName.trim() == "- QA") {
            this.hideenvqa = false;
        }
        if (this.environmentName.trim() == "- St") {
            this.hideenvstag = false;
        }
        if (this.environmentName.trim() == "- In") {
            this.hideenvinteg = false;
        }
        if (this.environmentName.trim() == "") {
            this._envprod = false;
        }
    };
    DataManagement.prototype.importDeal = function () {
        var _this = this;
        var checkdealmsg = "";
        this.importprocessbar = true;
        if (this._deal.CREDealID == null) {
            checkdealmsg = checkdealmsg + "<p>" + "Source CREDealID is a required field.";
        }
        if (this._deal.envname == null) {
            checkdealmsg = checkdealmsg + "<p>" + "Source Environment is a required field.";
        }
        if (this._deal.CopyDealID == null) {
            checkdealmsg = checkdealmsg + "<p>" + "NewCREDealID is a required field.";
        }
        if (this._deal.CopyDealName == null) {
            checkdealmsg = checkdealmsg + "<p>" + "NewDealName is a required field.";
        }
        if (this._deal.CREDealID == this._deal.CopyDealID && this._deal.CREDealID != null) {
            checkdealmsg = checkdealmsg + "Credealid and NewcredealId can not be same";
        }
        if (!checkdealmsg) {
            this.dealSrv.ImportDeal(this._deal).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.importprocessbar = false;
                    if (res.TotalCount == 0) {
                        checkdealmsg = checkdealmsg + "<p>" + "Deal imported successfully and sent to calculation ";
                        _this.importingstatus = true;
                    }
                    else if (res.TotalCount == 2) {
                        checkdealmsg = checkdealmsg + "<p>" + "Deal does not exist in source environment";
                    }
                    else {
                        checkdealmsg = checkdealmsg + "<p>" + _this._deal.CopyDealID + " already exists";
                    }
                }
                _this.CustomAlert(checkdealmsg);
            });
        }
        else {
            this.importprocessbar = false;
            this.CustomAlert(checkdealmsg);
        }
    };
    DataManagement.prototype.GetAllServicer = function () {
        var _this = this;
        this._isShowLoader = true;
        this.permissionService.GetAllServicer().subscribe(function (res) {
            if (res.Succeeded == true) {
                _this._isShowLoader = false;
                _this.lstServicer = res.ServicerList;
            }
        });
    };
    DataManagement.prototype.ServicerNameChange = function (newvalue, servicerboxname) {
        for (var i = 0; i < this.lstServicer.length; i++) {
            if (servicerboxname == "Name") {
                if (this.lstServicer[i].ServicerMasterID == newvalue) {
                    this.servicermasterid = this.lstServicer[i].ServicerMasterID;
                    this.repaymentdropdate = this.lstServicer[i].RepaymentDropDate;
                    this.servicerdropdate = this.lstServicer[i].ServicerDropDate;
                }
            }
            if (this.lstServicer[i].ServicerMasterID == this.servicermasterid) {
                if (servicerboxname == "ServicerDropDate") {
                    this.servicerdropdate = newvalue;
                }
                if (servicerboxname == "RepaymentDropDate") {
                    this.repaymentdropdate = newvalue;
                }
            }
        }
    };
    DataManagement.prototype.SaveServicer = function () {
        var _this = this;
        this._errormessage = "";
        var runvalidation = false;
        var servicermsg = "";
        this.servicer.ServicerMasterID = this.servicermasterid;
        this.servicer.ServicerDropDate = this.servicerdropdate;
        this.servicer.RepaymentDropDate = this.repaymentdropdate;
        if (this.servicer.ServicerDropDate == undefined || this.servicer.RepaymentDropDate == undefined || this.servicer.ServicerMasterID == undefined) {
            this._errormessage = "Please select servicer name.";
            this.CustomAlert(this._errormessage);
        }
        if (this.servicer.ServicerDropDate < 1 || this.servicer.ServicerDropDate > 28) {
            servicermsg = servicermsg + "servicer drop date,";
            if (this.servicer.RepaymentDropDate < 1 || this.servicer.RepaymentDropDate > 28) {
                runvalidation = true;
            }
        }
        else {
            runvalidation = true;
        }
        if (runvalidation == true) {
            if (this.servicer.RepaymentDropDate < 1 || this.servicer.RepaymentDropDate > 28) {
                servicermsg = servicermsg + " repayment drop date ";
            }
        }
        if (servicermsg) {
            this._errormessage = this._errormessage + "Please enter " + servicermsg.slice(0, -1) + " between 1 to 28.";
            this.CustomAlert(this._errormessage);
        }
        if (runvalidation == false) {
            servicermsg = "";
        }
        if (!this._errormessage) {
            this.permissionService.SaveServicerByServicerID(this.servicer).subscribe(function (res) {
                if (res.Succeeded == true) {
                    _this._ShowSuccessmessage = "Servicer updated successfully.";
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                }
                else {
                    _this._ShowErrorMessage = "Something went wrong.Please try after some time.";
                    _this._dvEmptyDealSearchMsg = true;
                    setTimeout(function () {
                        this._dvEmptyDealSearchMsg = false;
                    }.bind(_this), 5000);
                }
            });
        }
    };
    DataManagement.prototype.addFooterRow = function (flexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
        flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
        // sigma on the header       
    };
    DataManagement.prototype.GetAllLookups = function () {
        var _this = this;
        this.dealSrv.getAllLookup().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstCalculated = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstCashflowdownlaod = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstAllowcalculationOverride = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstGAAPCalculations = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstServicingRecocilliation = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstCashNonCash = data.filter(function (x) { return x.ParentID == "121"; });
            _this._bindGridDropdows();
        });
    };
    DataManagement.prototype._bindGridDropdows = function () {
        var transflex = this.transactionflex;
        if (transflex) {
            var colCalculated = transflex.columns.getColumn('CalculatedText');
            var colCashflowdownlaod = transflex.columns.getColumn('IncludeCashflowDownloadText');
            var colServicingRecocilliation = transflex.columns.getColumn('IncludeServicingReconciliationText');
            var colGAAPCalculations = transflex.columns.getColumn('IncludeGAAPCalculationsText');
            var colAllowcalculationOverride = transflex.columns.getColumn('AllowCalculationOverrideText');
            //lstCashNonCash
            var colCashNonCash = transflex.columns.getColumn('Cash_NonCashText');
            if (colCalculated) {
                colCalculated.showDropDown = true;
                colCalculated.dataMap = this._buildDataMap(this.lstCalculated);
            }
            if (colCashflowdownlaod) {
                colCashflowdownlaod.showDropDown = true;
                colCashflowdownlaod.dataMap = this._buildDataMap(this.lstCashflowdownlaod);
            }
            if (colServicingRecocilliation) {
                colServicingRecocilliation.showDropDown = true;
                colServicingRecocilliation.dataMap = this._buildDataMap(this.lstServicingRecocilliation);
            }
            if (colGAAPCalculations) {
                colGAAPCalculations.showDropDown = true;
                colGAAPCalculations.dataMap = this._buildDataMap(this.lstGAAPCalculations);
            }
            if (colAllowcalculationOverride) {
                colAllowcalculationOverride.showDropDown = true;
                colAllowcalculationOverride.dataMap = this._buildDataMap(this.lstAllowcalculationOverride);
            }
            if (colCashNonCash) {
                colCashNonCash.showDropDown = true;
                colCashNonCash.dataMap = this._buildDataMap(this.lstCashNonCash);
            }
        }
    };
    // build a data map from a string array using the indices as keys
    DataManagement.prototype._buildDataMap = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['LookupID'], value: obj['Name'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    DataManagement.prototype.getTransactionTypes = function () {
        var _this = this;
        this._isShowLoader = true;
        this.permissionService.GetTransactionTypes().subscribe(function (res) {
            if (res.Succeeded == true) {
                _this._isShowLoader = false;
                var data = res.dt;
                _this.listtransactiontype = data;
                _this._transactiontypeslist = new wjcCore.CollectionView(data);
                _this._transactiontypeslist.trackChanges = true;
                _this.GetAllLookups();
                _this.transactionflex.invalidate();
                //setTimeout(function(){
                //    this.transactionflex.invalidate();
                //}.bind(this),100);
            }
            else {
                _this._isShowLoader = false;
                var data = null;
                _this._transactiontypeslist = new wjcCore.CollectionView(data);
                _this._transactiontypeslist.trackChanges = true;
                _this.GetAllLookups();
                _this.transactionflex.invalidate();
            }
        });
    };
    DataManagement.prototype.AssignvaluestoTransactiontypeDropdown = function (data, e) {
        var datatext;
        if (data == 4 || data == "4") {
            datatext = "N";
        }
        else if (data == 3 || data == "3") {
            datatext = "Y";
        }
        else {
            datatext = data;
        }
        return datatext;
    };
    DataManagement.prototype.CopiedTransactiontypes = function (s, e) {
        var _this = this;
        for (var k = 0; k < this.transactionflex.rows.length - 1; k++) {
            if (!(Number(this.transactionflex.rows[k].dataItem["CalculatedText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["CalculatedText"]) == 0)) {
                this.transactionflex.rows[k].dataItem["Calculated"] = this.transactionflex.rows[k].dataItem["CalculatedText"];
                this.transactionflex.rows[k].dataItem["CalculatedText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["CalculatedText"], k);
                var calculateddata = this.transactionflex.rows[k].dataItem["CalculatedText"];
                if (!(calculateddata == "Y" || calculateddata == "3")) {
                    this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"] = null;
                    this.transactionflex.rows[k].dataItem["AllowCalculationOverride"] = null;
                }
            }
            else {
                this.transactionflex.rows[k].dataItem["Calculated"] = this.transactionflex.rows[k].dataItem["Calculated"];
            }
            if (!(Number(this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"]) == 0)) {
                this.transactionflex.rows[k].dataItem["IncludeCashflowDownload"] = this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"];
                this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"], k);
            }
            else {
                this.transactionflex.rows[k].dataItem["IncludeCashflowDownload"] = this.transactionflex.rows[k].dataItem["IncludeCashflowDownload"];
            }
            if (!(Number(this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"]) == 0)) {
                this.transactionflex.rows[k].dataItem["IncludeServicingReconciliation"] = this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"];
                this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"], k);
            }
            else {
                this.transactionflex.rows[k].dataItem["IncludeServicingReconciliation"] = this.transactionflex.rows[k].dataItem["IncludeServicingReconciliation"];
            }
            if (!(Number(this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"]) == 0)) {
                this.transactionflex.rows[k].dataItem["IncludeGAAPCalculations"] = this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"];
                this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"], k);
            }
            else {
                this.transactionflex.rows[k].dataItem["IncludeGAAPCalculations"] = this.transactionflex.rows[k].dataItem["IncludeGAAPCalculations"];
            }
            if (!(Number(this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"]) == 0)) {
                this.transactionflex.rows[k].dataItem["AllowCalculationOverride"] = this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"];
                this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"], k);
            }
            else {
                this.transactionflex.rows[k].dataItem["AllowCalculationOverride"] = this.transactionflex.rows[k].dataItem["AllowCalculationOverride"];
            }
            if (!(Number(this.transactionflex.rows[k].dataItem["Cash_NonCashText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["Cash_NonCashText"]) == 0)) {
                this.transactionflex.rows[k].dataItem["Cash_NonCashID"] = this.transactionflex.rows[k].dataItem["Cash_NonCashText"];
                this.transactionflex.rows[k].dataItem["Cash_NonCashText"] = this.lstCashNonCash.find(function (x) { return x.LookupID == _this.transactionflex.rows[e.row].dataItem["Cash_NonCashID"]; }).Name;
            }
            else {
                this.transactionflex.rows[k].dataItem["Cash_NonCashID"] = this.transactionflex.rows[k].dataItem["Cash_NonCashID"];
                this.transactionflex.rows[k].dataItem["Cash_NonCashText"] = this.transactionflex.rows[k].dataItem["Cash_NonCashText"];
            }
        }
    };
    DataManagement.prototype.cellEditTransactionTypes = function (s, e) {
        var _this = this;
        if (e.col == 4) {
            if (!(Number(this.transactionflex.rows[e.row].dataItem["CalculatedText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["CalculatedText"]) == 0)) {
                this.transactionflex.rows[e.row].dataItem["Calculated"] = this.transactionflex.rows[e.row].dataItem["CalculatedText"];
                this.transactionflex.rows[e.row].dataItem["CalculatedText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["CalculatedText"], e.row);
                var calculateddata = this.transactionflex.rows[e.row].dataItem["CalculatedText"];
                if (calculateddata == "N" || calculateddata == null || calculateddata == undefined || calculateddata == "" || calculateddata == "4") {
                    this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"] = null;
                    this.transactionflex.rows[e.row].dataItem["AllowCalculationOverride"] = null;
                }
            }
        }
        if (e.col == 5) {
            if (!(Number(this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"]) == 0)) {
                this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownload"] = this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"];
                this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"], e.row);
            }
        }
        if (e.col == 6) {
            if (!(Number(this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"]) == 0)) {
                this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliation"] = this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"];
                this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"], e.row);
            }
        }
        if (e.col == 7) {
            if (!(Number(this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"]) == 0)) {
                this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculations"] = this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"];
                this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"], e.row);
            }
        }
        if (e.col == 8) {
            if (!(Number(this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"]) == 0)) {
                this.transactionflex.rows[e.row].dataItem["AllowCalculationOverride"] = this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"];
                this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"], e.row);
            }
        }
        if (e.col == 9) {
            if (!(Number(this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"]) == 0)) {
                this.transactionflex.rows[e.row].dataItem["Cash_NonCashID"] = this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"];
                this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"] = this.lstCashNonCash.find(function (x) { return x.LookupID == _this.transactionflex.rows[e.row].dataItem["Cash_NonCashID"]; }).Name;
            }
        }
    };
    DataManagement.prototype.TransactionTypeValidation = function () {
        var errtransaction = "";
        var errortrans = "";
        this._isShowLoader = true;
        if (this.listtransactiontype) {
            for (var j = 0; j < this.listtransactiontype.length; j++) {
                //check for required fields
                if (this.listtransactiontype[j].TransactionName == null || this.listtransactiontype[j].TransactionName == "" || this.listtransactiontype[j].TransactionName == undefined) {
                    errortrans = "Transaction Name ,";
                    this.transactionerror = true;
                }
                if (this.listtransactiontype[j].TransactionCategory == null || this.listtransactiontype[j].TransactionCategory == "" || this.listtransactiontype[j].TransactionCategory == undefined) {
                    errortrans = errortrans + "Transaction Category ,";
                    this.transactionerror = true;
                }
                if (this.listtransactiontype[j].CalculatedText == null || this.listtransactiontype[j].CalculatedText == "" || this.listtransactiontype[j].CalculatedText == undefined) {
                    errortrans = errortrans + "Calculated ,";
                    this.transactionerror = true;
                }
                if (this.listtransactiontype[j].IncludeCashflowDownloadText == null || this.listtransactiontype[j].IncludeCashflowDownloadText == "" || this.listtransactiontype[j].IncludeCashflowDownloadText == undefined) {
                    errortrans = errortrans + "Include in Cashflow Download ,";
                    this.transactionerror = true;
                }
                if (this.listtransactiontype[j].IncludeServicingReconciliationText == null || this.listtransactiontype[j].IncludeServicingReconciliationText == "" || this.listtransactiontype[j].IncludeServicingReconciliationText == undefined) {
                    errortrans = errortrans + "Include in Servicing Reconciliation ,";
                    this.transactionerror = true;
                }
                if (this.listtransactiontype[j].IncludeGAAPCalculationsText == null || this.listtransactiontype[j].IncludeGAAPCalculationsText == "" || this.listtransactiontype[j].IncludeGAAPCalculationsText == undefined) {
                    errortrans = errortrans + "Include in GAAP Calculations ";
                    this.transactionerror = true;
                }
                if (errortrans != "") {
                    break;
                }
            }
            //check duplicate name
            for (var k = 0; k < this.listtransactiontype.length - 1; k++) {
                for (var m = k + 1; m < this.listtransactiontype.length; m++) {
                    if (this.listtransactiontype[k].TransactionName == this.listtransactiontype[m].TransactionName) {
                        errtransaction = errtransaction + "<p>" + "Transaction name can not be same." + "</p>";
                        this.transactionerror = true;
                    }
                }
                if (errtransaction != "") {
                    break;
                }
            }
            if (errortrans != "" || errtransaction != "") {
                if (errortrans != "") {
                    errtransaction = errtransaction + "<p>" + errortrans.slice(0, -1) + " are required field(s)." + "</p>";
                }
                this.CustomAlert(errtransaction);
                this._isShowLoader = false;
            }
            else {
                this.saveTransactionType();
            }
        }
    };
    DataManagement.prototype.saveTransactionType = function () {
        var _this = this;
        var dtlisttransactiontype = [];
        for (var k = 0; k < this.listtransactiontype.length; k++) {
            dtlisttransactiontype.push({
                "TransactionTypesID": (!this.listtransactiontype[k].TransactionTypesID) ? 0 : this.listtransactiontype[k].TransactionTypesID,
                "TransactionName": this.listtransactiontype[k].TransactionName,
                "TransactionCategory": this.listtransactiontype[k].TransactionCategory,
                "TransactionGroup": this.listtransactiontype[k].TransactionGroup,
                "Calculated": this.listtransactiontype[k].Calculated,
                "IncludeCashflowDownload": this.listtransactiontype[k].IncludeCashflowDownload,
                "IncludeServicingReconciliation": this.listtransactiontype[k].IncludeServicingReconciliation,
                "IncludeGAAPCalculations": this.listtransactiontype[k].IncludeGAAPCalculations,
                "AllowCalculationOverride": this.listtransactiontype[k].AllowCalculationOverride,
                "CreatedBy": this.listtransactiontype[k].CreatedBy,
                "CreatedDate": this.listtransactiontype[k].CreatedDate,
                "UpdatedBy": this.listtransactiontype[k].UpdatedBy,
                "UpdatedDate": this.listtransactiontype[k].UpdatedDate,
                "Cash_NonCash": this.listtransactiontype[k].Cash_NonCashText,
                "AccountName": this.listtransactiontype[k].AccountName,
            });
        }
        this.permissionService.SaveTransactionTypes(dtlisttransactiontype).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowLoader = false;
                _this._ShowSuccessmessage = "Transaction types updated successfully.";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            else {
                _this._isShowLoader = false;
                _this._ShowErrorMessage = "Something went wrong.Please try after some time.";
                _this._dvEmptyDealSearchMsg = true;
                setTimeout(function () {
                    this._dvEmptyDealSearchMsg = false;
                }.bind(_this), 5000);
            }
        });
    };
    DataManagement.prototype.showDialogbox = function (Name, ID, deleteRowIndex) {
        this.deleteRowIndex = deleteRowIndex;
        this._deltransactiontypeid = ID;
        var modaltrans = document.getElementById('custombox');
        modaltrans.style.display = "block";
        this._MsgText = 'Are you sure you want to delete the ' + Name.toLowerCase() + '?';
        $.getScript("/js/jsDrag.js");
    };
    DataManagement.prototype.CloseTransactionPopUp = function () {
        var modal = document.getElementById('custombox');
        modal.style.display = "none";
    };
    DataManagement.prototype.deleteTransactionType = function () {
        var _this = this;
        this._isShowLoader = true;
        this.CloseTransactionPopUp();
        this._transactiontypeslist.removeAt(this.deleteRowIndex);
        this.permissionService.deleteTransactionType(this._deltransactiontypeid).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowLoader = false;
                _this._ShowSuccessmessage = "Transaction types deleted successfully.";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            else {
                _this._isShowLoader = false;
                _this._ShowErrorMessage = "Something went wrong.Please try after some time.";
                _this._dvEmptyDealSearchMsg = true;
                setTimeout(function () {
                    this._dvEmptyDealSearchMsg = false;
                }.bind(_this), 5000);
            }
        });
    };
    DataManagement.prototype.convertDateToBindable = function (data) {
        for (var k = 0; k < data.length; k++) {
            if (this.lstHolidayCalendar[k].HoliDayDate != null) {
                this.lstHolidayCalendar[k].HoliDayDate = new Date(data[k].HoliDayDate.toString());
            }
        }
    };
    DataManagement.prototype.GetAllJsonTemplate = function () {
        var _this = this;
        this._isShowLoader = true;
        this.permissionService.GetAllRules().subscribe(function (res) {
            if (res.Succeeded == true) {
                var filename;
                _this.AllRulesList = res.AllRulesList;
                _this.CreateTreeViewData(_this.AllRulesList);
                if (_this.paraselectedrule != null) {
                    filename = _this.AllRulesList.find(function (x) { return x.RuleTypeDetailID == _this.paraselectedrule; }).FileName;
                    _this.redirectonItemClicked(_this.paraselectedrule, _this.paraparentnode);
                }
                setTimeout(function () {
                    $('#mainSpliter').enhsplitter({ handle: 'lotsofdots', position: 300, leftMinSize: 0, fixed: false });
                    if (this.paraselectedrule != null) {
                        var theItem = this._findItem(this.theTree.itemsSource, filename);
                        var theNode = this.theTree.getNode(theItem);
                        theNode.select();
                    }
                }.bind(_this), 1000);
                _this._isShowLoader = false;
                _this.JsonTemplateName = 0;
            }
        });
    };
    DataManagement.prototype._findItem = function (items, text) {
        var node = null;
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item.header == text) {
                return item;
            }
            if (item.items) {
                item = this._findItem(item.items, text);
                if (item) {
                    return item;
                }
            }
        }
        return null; //  not found
    };
    DataManagement.prototype.UpdateJsonTemplate = function () {
        var _this = this;
        try {
            this._isShowLoader = true;
            //manish
            var EditorValueChanged = localStorage.getItem('EditorValueChanged');
            if (EditorValueChanged == "true") {
                this.JsonTemplateValueChange();
            }
            if (this._isRuleChanged == true) {
                this.JsonTemplateValue = this.GetEditorCurrentData();
                this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
                this._isRuleChanged = false;
                localStorage.setItem("EditorValueChanged", "false");
            }
            var ruletypelist = [];
            if (this.lstChangedTemplate.length > 0) {
                for (var k = 0; k < this.lstChangedTemplate.length; k++) {
                    var temp = new ruleType_1.ruletype('');
                    var rule = this.AllRulesList.find(function (x) { return x.FileName == _this.lstChangedTemplate[k].FileName; });
                    if (rule !== undefined && rule != null) {
                        temp.DBFileName = rule.FileName;
                        temp.IsBalanceAware = rule.IsBalanceAware;
                        temp.RuleTypeDetailID = rule.RuleTypeDetailID;
                        temp.RuleTypeMasterID = rule.RuleTypeMasterID;
                        temp.RuleTypeName = rule.RuleTypeName;
                        temp.Type = rule.Type;
                        temp.Content = this.lstChangedTemplate[k].Content;
                        temp.Comments = rule.Comments;
                        temp.FileName = rule.FileName;
                    }
                    else {
                        var masterid = this.AllRulesList.find(function (x) { return x.RuleTypeName == _this.lstChangedTemplate[k].RuleTypeName; }).RuleTypeMasterID;
                        //in case of new
                        temp.DBFileName = this.lstChangedTemplate[k].FileName;
                        temp.IsBalanceAware = false;
                        temp.RuleTypeDetailID = 0;
                        temp.RuleTypeMasterID = masterid;
                        temp.RuleTypeName = this.lstChangedTemplate[k].RuleTypeName;
                        temp.Type = 'json';
                        temp.Content = this.lstChangedTemplate[k].Content;
                        temp.Comments = "";
                        temp.FileName = this.lstChangedTemplate[k].FileName;
                    }
                    ruletypelist.push(temp);
                }
            }
            this.permissionService.UpdateJsonTemplate(ruletypelist).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.AllRulesList = res.AllRulesList;
                    _this.lstChangedTemplate = [];
                    _this._isShowLoader = false;
                    _this._ShowSuccessmessage = " Rules saved successfully.";
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                }
                else {
                    _this._isShowLoader = false;
                    _this._ShowErrorMessage = "Something went wrong.Please try again.";
                }
            });
        }
        catch (e) {
            this._isShowLoader = false;
            this._ShowErrorMessage = "Something went wrong.Please try again.";
            setTimeout(function () {
                this._ShowSuccessmessagediv = false;
            }.bind(this), 5000);
        }
    };
    DataManagement.prototype.ngOnInit = function () {
        // get return url from route parameters or default to '/'
        // $('#mainSpliter').enhsplitter({ handle: 'lotsofdots', position: 435, leftMinSize: 400, fixed: false });
    };
    DataManagement.prototype.getHolidayCalendar = function () {
        var _this = this;
        this._isShowLoader = true;
        this.permissionService.GetHolidayCalendar().subscribe(function (res) {
            if (res.Succeeded == true) {
                _this._isShowLoader = false;
                _this.lstCalendarName = [];
                _this.lstHolidayCalendar = [];
                var data = res.dt;
                var calendarnamelist = res.dtholidaymaster;
                var refreshlist = [];
                _this.lstCalendarName = calendarnamelist;
                _this.lstHolidayCalendar = data;
                _this.convertDateToBindable(_this.lstHolidayCalendar);
                for (var j = 0; j < _this.lstHolidayCalendar.length; j++) {
                    if (_this._isSavedHolidayDate == false) {
                        if (_this.lstHolidayCalendar[j].CalendarName == 'US') {
                            if (_this.lstHolidayCalendar[j].HoliDayDate != null) {
                                refreshlist.push({ "HoliDayDate": _this.lstHolidayCalendar[j].HoliDayDate });
                            }
                        }
                    }
                    else {
                        if (_this.lstHolidayCalendar[j].HolidayMasterID.toString() == _this.changedCalendarId.toString()) {
                            if (_this.lstHolidayCalendar[j].HoliDayDate != null) {
                                refreshlist.push({ "HoliDayDate": _this.lstHolidayCalendar[j].HoliDayDate });
                            }
                        }
                    }
                }
                _this._isSavedHolidayDate = false;
                _this.lstHolidaycalendardate = new wjcCore.CollectionView(refreshlist);
                _this.lstHolidaycalendardate.trackChanges = true;
                _this.holidaycalendarflex.invalidate();
            }
            else {
                _this._isShowLoader = false;
                var data = null;
                _this.lstHolidaycalendardate = new wjcCore.CollectionView(data);
                _this.lstHolidaycalendardate.trackChanges = true;
                _this.holidaycalendarflex.invalidate();
            }
        });
    };
    DataManagement.prototype.CalendarNameChange = function (newvalue) {
        this.changedCalendarId = newvalue;
        var calendarname = this.lstCalendarName.find(function (x) { return x.HolidayMasterID.toString() == newvalue; }).CalendarName;
        this.newCalendarname = calendarname;
        var selectedval = [];
        for (var j = 0; j < this.lstHolidayCalendar.length; j++) {
            if (this.newCalendarname == this.lstHolidayCalendar[j].CalendarName) {
                if (this.lstHolidayCalendar[j].HoliDayDate != null) {
                    selectedval.push({ "HoliDayDate": this.lstHolidayCalendar[j].HoliDayDate });
                }
            }
        }
        this.lstHolidaycalendardate = new wjcCore.CollectionView(selectedval);
        this.lstHolidaycalendardate.trackChanges = true;
        this.holidaycalendarflex.refresh();
    };
    DataManagement.prototype.OpenCalendarNamepopup = function () {
        this.newCalendarname = '';
        var modal = document.getElementById('AddCalendarNamedialogbox');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DataManagement.prototype.CloseAddCalendarPopUp = function () {
        var modal = document.getElementById('AddCalendarNamedialogbox');
        modal.style.display = "none";
    };
    DataManagement.prototype.AddNewCalendarName = function () {
        var _this = this;
        this._isShowLoader = true;
        var foundName = '';
        var _isfoundName = false;
        for (var k = 0; k < this.lstCalendarName.length; k++) {
            if (this.lstCalendarName[k].CalendarName.toLowerCase() == this.newCalendarname.toLowerCase()) {
                _isfoundName = true;
            }
        }
        if (_isfoundName == true) {
            this._isShowLoader = false;
            this.CloseAddCalendarPopUp();
            foundName = "Calendar name " + this.newCalendarname + " already exists.";
            this.CustomAlert(foundName);
        }
        else {
            this.permissionService.addHolidayCalendarName(this.newCalendarname).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._isShowLoader = false;
                    _this.CloseAddCalendarPopUp();
                    _this._ShowSuccessmessage = "Calendar name saved successfully.";
                    _this._ShowSuccessmessagediv = true;
                    _this.getHolidayCalendar();
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                }
                else {
                    _this._isShowLoader = false;
                    _this.CloseAddCalendarPopUp();
                    _this._ShowErrorMessage = "Something went wrong.Please try after some time.";
                    _this._dvEmptyDealSearchMsg = true;
                    setTimeout(function () {
                        this._dvEmptyDealSearchMsg = false;
                    }.bind(_this), 5000);
                }
            });
        }
    };
    DataManagement.prototype.cellEditHolidaysDate = function (s, e) {
        var items = s.collectionView.items;
        this.checkDuplicateHolidayDates(items, 'edit');
        s.invalidate();
    };
    DataManagement.prototype.CopiedHolidaysDate = function (s, e) {
        var items = s.collectionView.items;
        this.checkDuplicateHolidayDates(items, 'copy');
        s.invalidate();
    };
    DataManagement.prototype.checkDuplicateHolidayDates = function (data, mode) {
        var founddates = '';
        var duplicatedateerror = '';
        for (var k = 0; k < data.length; k++) {
            for (var j = k + 1; j < data.length; j++) {
                if (Object.keys(data[j]).length > 0) {
                    if (data[j].HoliDayDate.getTime() == data[k].HoliDayDate.getTime()) {
                        var month = new Date(data[k].HoliDayDate).getMonth() + 1;
                        var date = month + '/' + new Date(data[k].HoliDayDate).getDate() + '/' + new Date(data[k].HoliDayDate).getFullYear();
                        founddates = founddates + date + ", ";
                    }
                }
            }
        }
        if (founddates != "") {
            founddates = founddates.substring(0, founddates.length - 1);
            duplicatedateerror = "<p> Holiday date(s) found duplicates " + founddates.slice(0, -1) + "</p>";
            this.CustomAlert(duplicatedateerror);
        }
        else {
            if (mode == 'save') {
                this.saveHolidayDate(data);
            }
        }
    };
    DataManagement.prototype.convertDatetoGMT = function (date) {
        if (date != null) {
            date = new Date(date);
            date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
            return date;
        }
        else
            return date;
    };
    DataManagement.prototype.InsertHolidayDatesByID = function () {
        this._isShowLoader = true;
        var dtholidaydates = [];
        if (!this.changedCalendarId) {
            this.changedCalendarId = "411";
        }
        for (var k = 0; k < this.holidaycalendarflex.rows.length - 1; k++) {
            if (this.holidaycalendarflex.rows[k].dataItem.HoliDayDate) {
                dtholidaydates.push({
                    "HolidayMasterId": this.changedCalendarId,
                    "HoliDayDate": this.convertDatetoGMT(this.holidaycalendarflex.rows[k].dataItem.HoliDayDate)
                });
            }
        }
        if (dtholidaydates.length == 0) {
            dtholidaydates.push({
                "HolidayMasterId": this.changedCalendarId,
                "HoliDayDate": null
            });
        }
        this.checkDuplicateHolidayDates(dtholidaydates, 'save');
        this._isShowLoader = false;
    };
    DataManagement.prototype.saveHolidayDate = function (dtholidaydates) {
        var _this = this;
        this.permissionService.addHolidayDates(dtholidaydates).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowLoader = false;
                _this.CloseAddCalendarPopUp();
                _this._ShowSuccessmessage = "Holiday dates updated successfully.";
                _this._ShowSuccessmessagediv = true;
                _this._isSavedHolidayDate = true;
                _this.getHolidayCalendar();
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            else {
                _this._isShowLoader = false;
                _this._ShowErrorMessage = "Something went wrong.Please try after some time.";
                _this._dvEmptyDealSearchMsg = true;
                setTimeout(function () {
                    this._dvEmptyDealSearchMsg = false;
                }.bind(_this), 5000);
            }
        });
    };
    DataManagement.prototype.showDeleteDialogbox = function (Name, rowval, deleteRowIndex) {
        this.deleteRowIndex = deleteRowIndex;
        var modaltrans = document.getElementById('deletebox');
        modaltrans.style.display = "block";
        var month = new Date(rowval).getMonth() + 1;
        var mm = month < 10 ? '0' + month : month;
        var dd = new Date(rowval).getDate() < 10 ? '0' + new Date(rowval).getDate() : new Date(rowval).getDate();
        var date = mm + '/' + dd + '/' + new Date(rowval).getFullYear();
        this._MsgText = 'Are you sure you want to delete the ' + Name.toLowerCase() + '-' + date + '?';
        $.getScript("/js/jsDrag.js");
    };
    DataManagement.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('deletebox');
        modal.style.display = "none";
    };
    DataManagement.prototype.deleteFromModuleList = function (moduleName) {
        if (moduleName == "HolidayCalendar") {
            this.CloseDeletePopUp();
            this.lstHolidaycalendardate.removeAt(this.deleteRowIndex);
        }
    };
    DataManagement.prototype.getPowerBIPassword = function () {
        var _this = this;
        this._isShowLoader = true;
        this._isShowPowerBITab = true;
        this.permissionService.getpowerBIpassword().subscribe(function (res) {
            if (res.Succeeded == true) {
                _this._isShowLoader = false;
                _this._changepowerbipasswrd.Value = res.appconfigpowerBI;
            }
        });
    };
    DataManagement.prototype.updatepowerbipassword = function () {
        var _this = this;
        this._isShowLoader = true;
        this._changepowerbipasswrd.key = "PowerBIPassword";
        this.permissionService.UpdatePowerBIPassword(this._changepowerbipasswrd).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowLoader = false;
                _this._ShowSuccessmessage = " Password Saved successfully.";
                _this._ShowSuccessmessagediv = true;
                _this._changepowerbipasswrd.Value = "";
                _this._isShowPowerBITab = false;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            else {
                _this._isShowLoader = false;
                _this._ShowErrorMessage = "Something went wrong.Please try again.";
            }
        });
    };
    DataManagement.prototype.syncQuickbook = function () {
        var _this = this;
        this._isShowLoader = true;
        if (this._issyncbtnClicked == true) {
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = "Please wait while Quickbooks sync is in process.";
            this._isShowLoader = false;
            setTimeout(function () {
                this._ShowmessagedivWar = false;
                this._ShowmessagedivMsgWar = "";
            }.bind(this), 5000);
        }
        else {
            this._issyncbtnClicked = true;
            this.permissionService.syncQuickbook().subscribe(function (res) {
                if (res.Succeeded) {
                    _this._isShowLoader = false;
                    setTimeout(function () {
                        this._issyncbtnClicked = false;
                    }.bind(_this), 60000);
                    _this._ShowSuccessmessage = "Request sent successfully. It might take approx 15-20 minutes to sync the data.";
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                }
                else {
                    _this._isShowLoader = false;
                    _this._ShowErrorMessage = "Something went wrong.Please try after some time.";
                    _this._dvEmptyDealSearchMsg = true;
                    setTimeout(function () {
                        this._dvEmptyDealSearchMsg = false;
                    }.bind(_this), 5000);
                }
            });
        }
    };
    /// editor code start
    //manish
    DataManagement.prototype.onItemClicked = function (s) {
        var _this = this;
        try {
            this._isShowLoader = true;
            this.selectedRule = "";
            this.ParentNode = "";
            if (this.isParentnodeClicked() == false) {
                this._isShowLoader = true;
                this.selectedRule = s.selectedItem.header;
                this.ParentNode = s.selectedPath[0];
                this._isShowLoader = true;
                var EditorValueChanged = localStorage.getItem('EditorValueChanged');
                if (EditorValueChanged == "true") {
                    this.JsonTemplateValueChange();
                    this._isRuleChanged = true;
                }
                else {
                    this._isRuleChanged = false;
                }
                this.LastselectedRule = s.selectedItem.header;
                this.LastParentNode = s.selectedPath[0];
                if (this._isRuleChanged == true) {
                    //show dialog box and get data
                    this.RuleDataChanged();
                }
                else {
                    var getcontentfromdb = true;
                    if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
                        var tempselected = this.lstChangedTemplate.find(function (x) { return x.FileName == _this.selectedRule; });
                        if (tempselected != undefined && tempselected != null) {
                            getcontentfromdb = false;
                            this.JsonTemplateValue = tempselected.Content;
                            localStorage.setItem('editorData', tempselected.Content);
                            setTimeout("setData()", 500);
                            this.SetEditorParameterAfterDataLoad();
                        }
                    }
                    if (getcontentfromdb == true) {
                        this.GetContentByRule(this.selectedRule);
                    }
                }
            }
            else {
                this._isShowLoader = false;
            }
        }
        catch (e) {
            this._isShowLoader = false;
        }
    };
    DataManagement.prototype.GetContentByRule = function (selectedRule) {
        var _this = this;
        var RuleTypeDetailID;
        var result = this.AllRulesList.find(function (x) { return x.FileName == selectedRule; });
        if (result !== undefined && result !== null) {
            RuleTypeDetailID = this.AllRulesList.find(function (x) { return x.FileName == selectedRule; }).DBFileName;
            this.permissionService.GetContentByRuleTypeDetailID(RuleTypeDetailID).subscribe(function (res) {
                if (res.Succeeded == true) {
                    _this.JsonTemplateValue = res.RuleContent;
                    localStorage.setItem('editorData', _this.JsonTemplateValue);
                    setTimeout("setData()", 500);
                    setTimeout(function () {
                        this._isRuleChanged = false;
                        localStorage.setItem("EditorValueChanged", "false");
                        this._isShowLoader = false;
                    }.bind(_this), 1000);
                }
                else {
                    setTimeout(function () {
                        this._isRuleChanged = false;
                        localStorage.setItem("EditorValueChanged", "false");
                        this._isShowLoader = false;
                    }.bind(_this), 1000);
                }
            });
        }
        else {
            localStorage.setItem('editorData', "");
            setTimeout("setData()", 500);
            setTimeout(function () {
                this._isRuleChanged = false;
                localStorage.setItem("EditorValueChanged", "false");
                this._isShowLoader = false;
            }.bind(this), 1000);
        }
    };
    DataManagement.prototype.SetEditorParameterAfterDataLoad = function () {
        setTimeout(function () {
            this._isRuleChanged = false;
            localStorage.setItem("EditorValueChanged", "false");
            this._isShowLoader = false;
        }.bind(this), 1000);
    };
    DataManagement.prototype.JsonTemplateValueChange = function () {
        this.ChangedRule = this.LastselectedRule;
        this.ChangedParentNode = this.LastParentNode;
        this._isRuleChanged = true;
    };
    DataManagement.prototype.RuleDataChanged = function () {
        this.GenericDialogBody = "You have made changes to " + this.ChangedRule + ", do you want to save them before switching to another rule?";
        this.showDialogGeneric("myGenericDialog");
    };
    DataManagement.prototype.isValidFileName = function (filename) {
        var message = "";
        var extenionallowed = "json,py";
        // Make array of file extensions
        var extensions = (extenionallowed.split(','))
            .map(function (x) { return x.toLocaleUpperCase().trim(); });
        var res = filename.slice((filename.lastIndexOf(".") - 1 >>> 0) + 2);
        if (res != "") {
            var ext = filename.toUpperCase().split('.').pop() || filename;
            var exists = extensions.includes(ext);
            if (!exists) {
                message = "Only .json and .py files allowed.";
            }
        }
        else {
            message = "Please enter proper template type name.";
        }
        return message;
    };
    DataManagement.prototype.addnewRuleType = function (rulename) {
        var duplicate = false;
        var res = this.isValidFileName(rulename);
        if (res != "") {
            duplicate = true;
        }
        for (var k = 0; k < this.TreeViewdata.length; k++) {
            for (var il = 0; il < this.TreeViewdata[k].items.length; il++) {
                if (this.TreeViewdata[k].items[il].header.toLowerCase() == rulename.toLowerCase()) {
                    duplicate = true;
                    break;
                }
            }
        }
        if (duplicate == true) {
            duplicate = true;
            this._isShowaddnewvalidation = true;
            if (res == "") {
                this.validationtxt = "Rule with same name already exists.";
            }
            else {
                this.validationtxt = res;
            }
            setTimeout(function () {
                this._isShowaddnewvalidation = false;
            }.bind(this), 5000);
        }
        else {
            var theTree = this.theTree;
            var node = theTree.selectedNode;
            this.TreeViewdata[node.index].items.push({ header: rulename });
            this.theTree.itemsSource = [];
            this.theTree.itemsSource = this.TreeViewdata;
            //setTimeout(function () {
            //    this.theTree.collapseToLevel(10);
            //}.bind(this), 500);
            //this.JsonTemplateValue = "";
            // localStorage.setItem('editorData', this.JsonTemplateValue);
            this.CloseContextMenuDialog();
        }
    };
    DataManagement.prototype.showContextMenu = function (e) {
        if (this.isParentnodeClicked() == true) {
            e.preventDefault();
            this.theMenu.show(e);
        }
    };
    DataManagement.prototype.isParentnodeClicked = function () {
        var Parentnode = false;
        var theTree = this.theTree;
        var node = theTree.selectedNode;
        if (node) {
            if (node.level == 0 && node.hasChildren == true) {
                Parentnode = true;
            }
            else {
                Parentnode = false;
            }
        }
        else {
            Parentnode = false;
        }
        return Parentnode;
    };
    DataManagement.prototype.menuItemClick = function (contextMenu) {
        var modal = document.getElementById('ContextMenudialogbox');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
        document.getElementById('rulename')["value"] = "";
    };
    DataManagement.prototype.ContextMenuUpdatedialogbox = function () {
        var newruletype = document.getElementById('rulename')["value"];
        if (newruletype != "") {
            this.addnewRuleType(newruletype);
        }
    };
    DataManagement.prototype.CloseContextMenuDialog = function () {
        var modal = document.getElementById('ContextMenudialogbox');
        modal.style.display = "none";
    };
    DataManagement.prototype.getData = function () {
        return [
            {
                header: 'Parent 1', items: [
                    { header: 'Child 1.1' },
                    { header: 'Child 1.2' },
                    { header: 'Child 1.3' }
                ]
            },
            {
                header: 'Parent 2',
                items: [
                    { header: 'Child 2.1' },
                    { header: 'Child 2.2' }
                ]
            },
            {
                header: 'Parent 3', items: [
                    { header: 'Child 3.1' }
                ]
            }
        ];
    };
    DataManagement.prototype.CreateTreeViewData = function (data) {
        var distinct = [];
        var Treedata = [];
        var uniquedates = {};
        for (var k = 0; k < data.length; k++) {
            var valuetoCheck = data[k].RuleTypeName;
            if (valuetoCheck) {
                if (!(valuetoCheck in uniquedates)) {
                    uniquedates[valuetoCheck] = 1;
                    distinct.push(valuetoCheck);
                }
            }
        }
        if (distinct.length > 0) {
            for (var m = 0; m < distinct.length; m++) {
                for (var mk = 0; mk < data.length; mk++) {
                    if (data[mk].RuleTypeName == distinct[m]) {
                        var itemcheck = Treedata.filter(function (x) { return x.header == distinct[m]; });
                        if (itemcheck.length == 0) {
                            Treedata.push({ header: distinct[m], items: [{ header: data[mk].FileName }] });
                        }
                        else {
                            Treedata[m].items.push({ header: data[mk].FileName });
                        }
                    }
                }
            }
        }
        this.TreeViewdata = Treedata;
    };
    DataManagement.prototype.onNodeEditStarting = function (s, e) {
        if (e.node.hasChildren) {
            e.cancel = true;
        }
    };
    DataManagement.prototype.onnodeEditEnding = function (s, e) {
        var oldname = e.node.dataItem.header;
        var newname = e.node.element.innerText;
        this.selectedRule = e.node.element.innerText;
        this.ParentNode = s.selectedPath[0];
        for (var mk = 0; mk < this.AllRulesList.length; mk++) {
            if (this.AllRulesList[mk].FileName == oldname) {
                this.AllRulesList[mk].FileName = newname;
            }
        }
        for (var ch = 0; ch < this.lstChangedTemplate.length; ch++) {
            if (this.lstChangedTemplate[ch].FileName == oldname) {
                this.lstChangedTemplate[ch].FileName = newname;
            }
        }
        if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
            var temp = this.lstChangedTemplate.find(function (x) { return x.FileName == newname; });
            if (temp != null) {
                for (var tp1 = 0; tp1 < this.lstChangedTemplate.length; tp1++) {
                    if (this.lstChangedTemplate[tp1].FileName == newname) {
                        this.lstChangedTemplate[tp1].Content = temp.Content;
                    }
                }
            }
            else {
                this.lstChangedTemplate.push({ FileName: newname, RuleTypeName: s.selectedPath[0], Content: this.JsonTemplateValue });
            }
        }
        else {
            this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: s.selectedPath[0], Content: this.JsonTemplateValue });
        }
    };
    DataManagement.prototype.GetEditorCurrentData = function () {
        var value;
        var $editor = $('#editor');
        if ($editor.length > 0) {
            var objeditor = eval("ace.edit('editor')");
            value = objeditor.getValue();
        }
        return value;
    };
    ///editor code end
    //dialog code start
    DataManagement.prototype.showDialogGeneric = function (controlid) {
        var modalRole = document.getElementById(controlid);
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DataManagement.prototype.CloseDialogGeneric = function (controlid) {
        this.GetContentByRule(this.selectedRule);
        this.DialogModulename = "";
        var modal = document.getElementById(controlid);
        modal.style.display = "none";
    };
    DataManagement.prototype.GenricOkButtonClick = function () {
        this.AddDataToChangedList();
    };
    DataManagement.prototype.AddDataToChangedList = function () {
        var _this = this;
        this.JsonTemplateValue = this.GetEditorCurrentData();
        var getcontentfromdb = true;
        if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
            var temp = this.lstChangedTemplate.find(function (x) { return x.FileName == _this.ChangedRule; });
            if (temp != null) {
                for (var mk = 0; mk < this.lstChangedTemplate.length; mk++) {
                    if (this.lstChangedTemplate[mk].FileName == this.ChangedRule) {
                        this.lstChangedTemplate[mk].Content = this.JsonTemplateValue;
                    }
                }
            }
            else {
                this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
            }
        }
        else {
            this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
        }
        //this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
        //get data from list if already changed otherwsie get it from db
        if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
            var tempselected = this.lstChangedTemplate.find(function (x) { return x.FileName == _this.selectedRule; });
            if (tempselected != undefined && tempselected != null) {
                getcontentfromdb = false;
                this.JsonTemplateValue = tempselected.Content;
                localStorage.setItem('editorData', this.JsonTemplateValue);
                setTimeout("setData()", 500);
            }
        }
        if (getcontentfromdb == true) {
            this.GetContentByRule(this.selectedRule);
        }
        this._isShowLoader = false;
        this._isRuleChanged = false;
        localStorage.setItem("EditorValueChanged", "false");
        this.CloseDialogGeneric("myGenericDialog");
    };
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k;
    __decorate([
        (0, core_1.ViewChild)('flexpermission'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], DataManagement.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('flex'),
        __metadata("design:type", typeof (_b = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _b : Object)
    ], DataManagement.prototype, "Userflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('transactionflex'),
        __metadata("design:type", typeof (_c = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _c : Object)
    ], DataManagement.prototype, "transactionflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('holidaycalendarflex'),
        __metadata("design:type", typeof (_d = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _d : Object)
    ], DataManagement.prototype, "holidaycalendarflex", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", String)
    ], DataManagement.prototype, "fileExt", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Number)
    ], DataManagement.prototype, "maxFiles", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Number)
    ], DataManagement.prototype, "maxSize", void 0);
    __decorate([
        (0, core_1.Output)(),
        __metadata("design:type", Object)
    ], DataManagement.prototype, "uploadStatus", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiselholidaycalendarname'),
        __metadata("design:type", typeof (_e = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _e : Object)
    ], DataManagement.prototype, "multiselholidaycalendarname", void 0);
    __decorate([
        (0, core_1.ViewChild)('theTree'),
        __metadata("design:type", typeof (_f = typeof wijmo_angular2_nav_1.WjTreeView !== "undefined" && wijmo_angular2_nav_1.WjTreeView) === "function" ? _f : Object)
    ], DataManagement.prototype, "theTree", void 0);
    __decorate([
        (0, core_1.ViewChild)('theMenu'),
        __metadata("design:type", typeof (_g = typeof wijmo_angular2_input_1.WjMenu !== "undefined" && wijmo_angular2_input_1.WjMenu) === "function" ? _g : Object)
    ], DataManagement.prototype, "theMenu", void 0);
    DataManagement = __decorate([
        (0, core_1.Component)({
            selector: 'datamanagement',
            providers: [NoteService_1.NoteService, dealservice_1.dealService, membershipservice_1.MembershipService, notificationservice_1.NotificationService, permissionService_1.PermissionService, fileuploadservice_1.FileUploadService],
            templateUrl: 'app/account/dataManagement.html'
        }),
        __metadata("design:paramtypes", [NoteService_1.NoteService, utilityService_1.UtilityService, notificationservice_1.NotificationService, dealservice_1.dealService, membershipservice_1.MembershipService, typeof (_h = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _h : Object, dataService_1.DataService,
            scenarioService_1.scenarioService,
            permissionService_1.PermissionService,
            fileuploadservice_1.FileUploadService, typeof (_j = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _j : Object, typeof (_k = typeof ng2_file_input_1.Ng2FileInputService !== "undefined" && ng2_file_input_1.Ng2FileInputService) === "function" ? _k : Object])
    ], DataManagement);
    return DataManagement;
}());
exports.DataManagement = DataManagement;
var routes = [
    { path: '', component: DataManagement }
];
var DataManagementModule = /** @class */ (function () {
    function DataManagementModule() {
    }
    DataManagementModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, ng2_file_input_1.Ng2FileInputModule.forRoot(), wijmo_angular2_nav_1.WjNavModule],
            declarations: [DataManagement]
        })
    ], DataManagementModule);
    return DataManagementModule;
}());
exports.DataManagementModule = DataManagementModule;
var TreeItem = /** @class */ (function () {
    function TreeItem() {
    }
    return TreeItem;
}());
exports.TreeItem = TreeItem;
//# sourceMappingURL=dataManagement.component.js.map