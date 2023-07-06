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
exports.SignalRService = void 0;
// import the packages  
var core_1 = require("@angular/core");
var pushnotificationservice_1 = require("../core/services/pushnotificationservice");
var appsettings_1 = require("../core/common/appsettings");
// declare the global variables  
var SignalRService = /** @class */ (function () {
    function SignalRService(pushNotificationService) {
        this.pushNotificationService = pushNotificationService;
        this.proxyName = 'chatHub';
        this.lstNotification = null;
        this.updateCalcNotification = new core_1.EventEmitter();
        // Constructor initialization        
        this.connectionEstablished = new core_1.EventEmitter();
        this.messageReceived = new core_1.EventEmitter();
        this.connectionExists = false;
        // create hub connection  
        this.connection = $.hubConnection(appsettings_1.AppSettings._notificationserver);
        //   this.connection.qs = 'env=dev'; 
        // create new proxy as name already given in top  
        this.proxy = this.connection.createHubProxy(this.proxyName);
        // register on server events  
        this.registerOnServerEvents();
        // call the connecion start method to start the connection to send and receive events.  
        this.startConnection();
        localStorage.setItem('notificationchanged', "NO");
    }
    // method to hit from client  
    SignalRService.prototype.SendNotification = function (_notificationMsg) {
        // server side hub method using proxy.invoke with method name pass as param  
        this.proxy.invoke('SendToOtherUsers', 'testing', _notificationMsg);
    };
    SignalRService.prototype.SendCalcNotification = function (message) {
        // server side hub method using proxy.invoke with method name pass as param  
        this.proxy.invoke('UpdateCalcStatus', message);
    };
    SignalRService.prototype.SendTaskToOthers = function (_taskId, _message) {
        // server side hub method using proxy.invoke with method name pass as param  
        this.proxy.invoke('SendTaskToOthers', _taskId, _message);
    };
    // check in the browser console for either signalr connected or not  
    SignalRService.prototype.startConnection = function () {
        var _this = this;
        this.connection.start().done(function (data) {
            console.log('Now connected ' + data.transport.name + ', connection ID= ' + data.id);
            _this.connectionEstablished.emit(true);
            _this.connectionExists = true;
        }).fail(function (error) {
            console.log('Could not connect ' + error);
            _this.connectionEstablished.emit(false);
        });
    };
    SignalRService.prototype.registerOnServerEvents = function () {
        var _this = this;
        this.proxy.on('addMessage', function (userName, message) {
            var isnotificationchanged = localStorage.getItem('notificationchanged');
            if (_this.lstNotification == null || isnotificationchanged == "YES") {
                _this.pushNotificationService.getnotificationsubscription(1, 30).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.lstNotification = res.lstSubscription;
                        var username = JSON.parse(localStorage.getItem('user'));
                        //var isuserexist = _lstsubscriber.indexOf(username.UserID);
                        var _pushNotification = message.split('|*|');
                        var issubscribed = _this.lstNotification.find(function (x) { return x.Name == _pushNotification[0]; }).Status;
                        if (issubscribed == true && username.UserID != _pushNotification[3]) {
                            if ($("#notificationscount").text() == "") {
                                $("#notificationscount").text("0");
                            }
                            $("#notificationscount").text(parseInt($("#notificationscount").text()) + 1);
                            _this.messageReceived.emit(_pushNotification[1]);
                            $('#ptitle').html(_pushNotification[1]);
                            $("#displayNotification").click();
                        }
                    }
                });
            }
            else {
                // console.log('elseeee' + $("#notificationscount").text());
                var username = JSON.parse(localStorage.getItem('user'));
                var _pushNotification = message.split('|*|');
                var issubscribed = _this.lstNotification.find(function (x) { return x.Name == _pushNotification[0]; }).Status;
                if (issubscribed == true && username.UserID != _pushNotification[3]) {
                    if ($("#notificationscount").text() == "") {
                        $("#notificationscount").text("0");
                    }
                    $("#notificationscount").text(parseInt($("#notificationscount").text()) + 1);
                    _this.messageReceived.emit(_pushNotification[1]);
                    $('#ptitle').html(_pushNotification[1]);
                    $("#displayNotification").click();
                }
            }
        });
        this.proxy.on('updateClientCalcStatus', function (_noteid, UpdateCalcStatus) {
            // console.log("Client " + Date() +" Server: " + strcalctime + " signalr : " + signalrtime);         
            _this.updateCalcNotification.emit(_noteid);
        });
        this.proxy.on('SendTaskToOtherUsers', function (_taskid, _message) {
            var _pushNotification = _message.split('|*|');
            var _lstsubscriber = _pushNotification[3].split(',');
            //  var _subscriberusers = _lstsubscriber.split('|**|');
            var username = JSON.parse(localStorage.getItem('user'));
            var isuserexist = _lstsubscriber.indexOf(username.UserID);
            var env = _pushNotification[2];
            if (appsettings_1.AppSettings._notificationenvironment == env && isuserexist > -1) {
                $('#ptitle').html(_pushNotification[1]);
                $("#displayNotification").click();
                _this.messageReceived.emit(_pushNotification[1]);
                if ($("#notificationscount").text() == "") {
                    $("#notificationscount").text("0");
                }
                $("#notificationscount").text(parseInt($("#notificationscount").text()) + 1);
            }
        });
    };
    SignalRService = __decorate([
        (0, core_1.Injectable)(),
        __metadata("design:paramtypes", [pushnotificationservice_1.PushNotificationService])
    ], SignalRService);
    return SignalRService;
}());
exports.SignalRService = SignalRService;
//# sourceMappingURL=signalRService.js.map