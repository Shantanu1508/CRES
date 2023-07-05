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
exports.PushNotificationComponent = void 0;
var core_1 = require("@angular/core");
var PushNotificationComponent = /** @class */ (function () {
    function PushNotificationComponent() {
        this.dir = 'auto';
        this.lang = 'en-US';
        this.renotify = false;
        this.sticky = false;
        this.noscreen = false;
        this.silent = true;
        this.closeDelay = 0;
        this.onLoad = new core_1.EventEmitter();
        this.onShow = new core_1.EventEmitter();
        this.onClose = new core_1.EventEmitter();
        this.onError = new core_1.EventEmitter();
        this.onClick = new core_1.EventEmitter();
        this.instances = [];
    }
    PushNotificationComponent.prototype.checkCompatibility = function () {
        return !!('Notification' in window);
    };
    PushNotificationComponent.prototype.isPermissionGranted = function (permission) {
        return permission === 'granted';
    };
    PushNotificationComponent.prototype.requestPermission = function (callback) {
        return Notification.requestPermission(callback);
    };
    PushNotificationComponent.prototype.show = function () {
        var _this = this;
        if (!this.checkCompatibility()) {
            return console.log('Notification API not available in this browser.');
        }
        return this.requestPermission(function (permission) {
            if (_this.isPermissionGranted(permission)) {
                _this.create();
            }
        });
    };
    PushNotificationComponent.prototype.create = function () {
        var notification = new Notification(this.title, {
            dir: this.dir,
            lang: this.lang,
            data: this.data,
            tag: this.tag,
            body: this.body,
            icon: this.icon,
            silent: this.silent,
            sound: this.sound,
            renotify: this.renotify,
            sticky: this.sticky,
            vibrate: this.vibrate,
            noscreen: this.noscreen
        });
        this.instances.push(notification);
        this.attachEventHandlers(notification);
        this.close(notification);
        return notification;
    };
    PushNotificationComponent.prototype.close = function (notification) {
        if (this.closeDelay) {
            setTimeout(function () {
                notification.close();
            }, this.closeDelay);
        }
        else {
            notification.close();
        }
    };
    PushNotificationComponent.prototype.closeAll = function () {
        var _this = this;
        this.instances.map(function (notification) { return _this.close(notification); });
        this.instances = [];
    };
    PushNotificationComponent.prototype.attachEventHandlers = function (notification) {
        var _this = this;
        notification.onshow = function () {
            _this.onShow.emit({ notification: notification });
        };
        //notification.onclick = (event) => {
        //    debugger;
        //  window.open(this.notificationroutepath);
        //  notification.close();
        //// this.onClick.emit({ event, notification });
        //};
        notification.onerror = function () {
            _this.onError.emit({ notification: notification });
        };
        notification.onclose = function () {
            _this.onClose.emit({ notification: notification });
        };
    };
    PushNotificationComponent.prototype.ngOnInit = function () {
        this.onLoad.emit({});
    };
    PushNotificationComponent.prototype.ngOnDestroy = function () {
        this.closeAll();
    };
    PushNotificationComponent.prototype.ngOnChanges = function () {
    };
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "title", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "body", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "icon", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "sound", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Object)
    ], PushNotificationComponent.prototype, "data", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "tag", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "dir", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], PushNotificationComponent.prototype, "lang", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Boolean)
    ], PushNotificationComponent.prototype, "renotify", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Boolean)
    ], PushNotificationComponent.prototype, "sticky", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Array)
    ], PushNotificationComponent.prototype, "vibrate", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Boolean)
    ], PushNotificationComponent.prototype, "noscreen", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Boolean)
    ], PushNotificationComponent.prototype, "silent", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], PushNotificationComponent.prototype, "closeDelay", void 0);
    __decorate([
        core_1.Output('load'),
        __metadata("design:type", core_1.EventEmitter)
    ], PushNotificationComponent.prototype, "onLoad", void 0);
    __decorate([
        core_1.Output('show'),
        __metadata("design:type", core_1.EventEmitter)
    ], PushNotificationComponent.prototype, "onShow", void 0);
    __decorate([
        core_1.Output('close'),
        __metadata("design:type", core_1.EventEmitter)
    ], PushNotificationComponent.prototype, "onClose", void 0);
    __decorate([
        core_1.Output('error'),
        __metadata("design:type", core_1.EventEmitter)
    ], PushNotificationComponent.prototype, "onError", void 0);
    __decorate([
        core_1.Output('action'),
        __metadata("design:type", core_1.EventEmitter)
    ], PushNotificationComponent.prototype, "onClick", void 0);
    PushNotificationComponent = __decorate([
        core_1.Component({
            selector: 'push-notification',
            styles: [':host { display: none; }'],
            template: ''
        })
    ], PushNotificationComponent);
    return PushNotificationComponent;
}());
exports.PushNotificationComponent = PushNotificationComponent;
//# sourceMappingURL=notification.component.js.map