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
exports.NotificationSubscriptionModule = exports.NotificationSubscription = void 0;
var core_1 = require("@angular/core");
var membershipservice_1 = require("../core/services/membershipservice");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_1 = require("@angular/router");
var wjcGrid = require("wijmo/wijmo.grid");
var wjcCore = require("wijmo/wijmo");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var pushnotificationservice_1 = require("../core/services/pushnotificationservice");
var NotificationSubscription = /** @class */ (function () {
    function NotificationSubscription(membershipService, pushNotificationService) {
        this.membershipService = membershipService;
        this.pushNotificationService = pushNotificationService;
        this._Showmessagediv = false;
        this._ShowSuccessmessagediv = false;
        this._changesubscriptionlist = new Array();
        this._isSubscriptionUpdating = false;
        this.Message = '';
        this.GetNotificationSubscription();
    }
    NotificationSubscription.prototype.GetNotificationSubscription = function () {
        var _this = this;
        this._isSubscriptionUpdating = true;
        this.pushNotificationService.getnotificationsubscription(0, 30).subscribe(function (res) {
            if (res.Succeeded) {
                _this._subscriptionlist = res.lstSubscription;
                // this._changesubscriptionlist = res.lstSubscription;
                _this._subscriptionlist = new wjcCore.CollectionView(_this._subscriptionlist);
                _this._subscriptionlist.trackChanges = true;
                _this._isSubscriptionUpdating = false;
            }
        });
    };
    NotificationSubscription.prototype.SelectAll = function () {
        this._chkSelectAll = !this._chkSelectAll;
        for (var i = 0; i < this._subscriptionlist.items.length; i++) {
            this._subscriptionlist.items[i].Status = this._chkSelectAll;
        }
        this.flex.invalidate();
    };
    NotificationSubscription.prototype.SaveNotificationSubscription = function () {
        var _this = this;
        this._isSubscriptionUpdating = true;
        try {
            if (this._subscriptionlist.itemsEdited.length > 0) {
                for (var i = 0; i < this._subscriptionlist.itemsEdited.length; i++) {
                    this._changesubscriptionlist[i] = this._subscriptionlist.itemsEdited[i];
                }
                if (this._changesubscriptionlist.length > 0) {
                    this.pushNotificationService.savenotificationsubscription(this._changesubscriptionlist).subscribe(function (res) {
                        if (res.Succeeded) {
                            localStorage.setItem('notificationchanged', "YES");
                            _this._ShowSuccessmessage = res.Message;
                            _this._ShowSuccessmessagediv = true;
                            //  this.GetNotificationSubscription();
                            setTimeout(function () {
                                this._ShowSuccessmessagediv = false;
                                this._isSubscriptionUpdating = false;
                            }.bind(_this), 3000);
                        }
                        else {
                            _this._Showmessagediv = true;
                            _this.Message = res.Message;
                            setTimeout(function () {
                                this._Showmessagediv = false;
                                this._isSubscriptionUpdating = false;
                            }.bind(_this), 3000);
                        }
                    });
                }
                else {
                    this._Showmessagediv = true;
                    this.Message = "No subscription type available.";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._isSubscriptionUpdating = false;
                    }.bind(this), 5000);
                    this._isSubscriptionUpdating = false;
                }
            }
            else {
                this._ShowSuccessmessage = "Subscription updated successfully";
                this._ShowSuccessmessagediv = true;
                this._isSubscriptionUpdating = false;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._isSubscriptionUpdating = false;
                }.bind(this), 3000);
            }
        }
        catch (err) {
            this._isSubscriptionUpdating = false;
            alert(err);
        }
    };
    var _a;
    __decorate([
        (0, core_1.ViewChild)('flexsubscription'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], NotificationSubscription.prototype, "flex", void 0);
    NotificationSubscription = __decorate([
        (0, core_1.Component)({
            selector: 'notificationsubscription',
            providers: [membershipservice_1.MembershipService, pushnotificationservice_1.PushNotificationService],
            templateUrl: 'app/account/NotificationSubscription.html'
        }),
        __metadata("design:paramtypes", [membershipservice_1.MembershipService,
            pushnotificationservice_1.PushNotificationService])
    ], NotificationSubscription);
    return NotificationSubscription;
}());
exports.NotificationSubscription = NotificationSubscription;
var routes = [
    { path: '', component: NotificationSubscription }
];
var NotificationSubscriptionModule = /** @class */ (function () {
    function NotificationSubscriptionModule() {
    }
    NotificationSubscriptionModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_1.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule],
            declarations: [NotificationSubscription]
        })
    ], NotificationSubscriptionModule);
    return NotificationSubscriptionModule;
}());
exports.NotificationSubscriptionModule = NotificationSubscriptionModule;
//# sourceMappingURL=NotificationSubscription.component.js.map