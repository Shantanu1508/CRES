"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
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
exports.NotificationModule = exports.Notification = void 0;
var core_1 = require("@angular/core");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_1 = require("@angular/router");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var pushnotificationservice_1 = require("../core/services/pushnotificationservice");
var searchService_1 = require("../core/services/searchService");
var paginated_1 = require("../core/common/paginated");
var Notification = /** @class */ (function (_super) {
    __extends(Notification, _super);
    function Notification(pushNotificationService, searchService) {
        var _this = _super.call(this, 20, 1, 0) || this;
        _this.pushNotificationService = pushNotificationService;
        _this.searchService = searchService;
        _this._Showmessagediv = false;
        _this._ShowSuccessmessagediv = false;
        _this._isSubscriptionUpdating = false;
        _this.Message = '';
        _this._isNotificationsshow = false;
        _this.notificationcount = 0;
        _this.unotification = new Array();
        _this.currentnotification = new Array();
        _this.GetAllUserNotification();
        return _this;
    }
    Notification.prototype.ngAfterViewInit = function () {
        this.setHeight();
    };
    Notification.prototype.setHeight = function () {
        var notifi = document.getElementById('notifi');
        notifi.style.height = (window.innerHeight - 150).toString() + 'px';
    };
    Notification.prototype.onScrollnotifi = function () {
        //For paginging ----uncomment below code
        var myDiv = $('#notifi');
        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
            if (this.notificationcount < this._totalCount) {
                this._pageIndex = this._pageIndex + 1;
                this.GetAllUserNotification();
            }
        }
    };
    Notification.prototype.GetAllUserNotification = function () {
        var _this = this;
        this._isNotificationsshow = true;
        this._isNotificationsshow = true;
        var d = new Date();
        this.notificationmessage = "";
        var datestring = d.getFullYear() + "-" + (d.getMonth()) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this.currentnotification = new Array();
        this.pushNotificationService.getallnotification(datestring.toString(), this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this.currentnotification = res.lstUserNotification;
                _this._totalCount = res.TotalCount;
                _this.notificationcount = _this.notificationcount + _this.currentnotification.length;
                if (_this.notificationcount > 0) {
                    for (var i = 0; i < _this.unotification.length; i++) {
                        if (window.location.href.indexOf("dealdetail/a") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('dealdetail/a/', 'dealdetail/');
                        }
                        else if (_this.unotification[i].Msg.indexOf("dealdetail/") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('dealdetail/', 'dealdetail/a/');
                        }
                        if (window.location.href.indexOf("notedetail/a") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('notedetail/a/', 'notedetail/');
                        }
                        else if (_this.unotification[i].Msg.indexOf("notedetail/") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('notedetail/', 'notedetail/a/');
                        }
                        _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('/a/a/', '/a/');
                        debugger;
                    }
                }
                else {
                    _this.unotification = new Array();
                    _this._isNotificationsshow = false;
                    _this.notificationmessage = "No new notifications found";
                }
                _this.unotification = _this.unotification.concat(_this.currentnotification);
                _this._isNotificationsshow = false;
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    Notification.prototype.ClearAllNotification = function () {
        var _this = this;
        this.pushNotificationService.ClearAllUserNotification().subscribe(function (res) {
            if (res.Succeeded) {
                _this.unotification = new Array();
                _this.notificationcount = 0;
                _this.notificationmessage = "No new notifications found";
            }
        });
    };
    Notification = __decorate([
        core_1.Component({
            selector: 'notification',
            providers: [pushnotificationservice_1.PushNotificationService, searchService_1.SearchService],
            templateUrl: 'app/components/Notification.html'
        }),
        __metadata("design:paramtypes", [pushnotificationservice_1.PushNotificationService,
            searchService_1.SearchService])
    ], Notification);
    return Notification;
}(paginated_1.Paginated));
exports.Notification = Notification;
var routes = [
    { path: '', component: Notification }
];
var NotificationModule = /** @class */ (function () {
    function NotificationModule() {
    }
    NotificationModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_1.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule],
            declarations: [Notification]
        })
    ], NotificationModule);
    return NotificationModule;
}());
exports.NotificationModule = NotificationModule;
//# sourceMappingURL=Notification.component.js.map