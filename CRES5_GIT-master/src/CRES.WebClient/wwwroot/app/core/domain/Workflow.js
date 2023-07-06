"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WFCheckListStatus = exports.WFClientData = exports.WFNotificationDetailDataContract = exports.WFNotificationMaster = exports.WFStatusData = exports.WFCheckListData = exports.WFAdditionalData = exports.Workflow = void 0;
var Workflow = /** @class */ (function () {
    function Workflow(WFTaskDetailId) {
        this.WFTaskDetailId = WFTaskDetailId;
    }
    return Workflow;
}());
exports.Workflow = Workflow;
var WFAdditionalData = /** @class */ (function () {
    function WFAdditionalData(WFTaskDetailId) {
        this.WFTaskDetailID = WFTaskDetailId;
    }
    return WFAdditionalData;
}());
exports.WFAdditionalData = WFAdditionalData;
var WFCheckListData = /** @class */ (function () {
    function WFCheckListData(WFTaskDetailId) {
        this.WFTaskDetailID = WFTaskDetailId;
    }
    return WFCheckListData;
}());
exports.WFCheckListData = WFCheckListData;
var WFStatusData = /** @class */ (function () {
    function WFStatusData(WFTaskDetailId) {
        this.WFTaskDetailID = WFTaskDetailId;
    }
    return WFStatusData;
}());
exports.WFStatusData = WFStatusData;
var WFNotificationMaster = /** @class */ (function () {
    function WFNotificationMaster(WFNotificationMasterID) {
        this.WFNotificationMasterID = WFNotificationMasterID;
    }
    return WFNotificationMaster;
}());
exports.WFNotificationMaster = WFNotificationMaster;
var WFNotificationDetailDataContract = /** @class */ (function () {
    function WFNotificationDetailDataContract(WFNotificationID) {
        this.WFNotificationID = WFNotificationID;
    }
    return WFNotificationDetailDataContract;
}());
exports.WFNotificationDetailDataContract = WFNotificationDetailDataContract;
var WFClientData = /** @class */ (function () {
    function WFClientData(WFClientID) {
        this.ClientID = WFClientID;
    }
    return WFClientData;
}());
exports.WFClientData = WFClientData;
var WFCheckListStatus = /** @class */ (function () {
    function WFCheckListStatus() {
    }
    return WFCheckListStatus;
}());
exports.WFCheckListStatus = WFCheckListStatus;
//# sourceMappingURL=Workflow.js.map