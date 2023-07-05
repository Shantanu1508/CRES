"use strict";
/// <reference path="../../components/pagenotfound.component.ts" />
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppSettings = void 0;
var AppSettings = /** @class */ (function () {
    function AppSettings() {
    }
    //System Setting 1
    AppSettings._dateMinRange = '2000-01-01 00:00:00'; //'YYYY-MM-DD'
    AppSettings._dateMinRangeView = '01-01-2000'; //'YYYY-MM-DD'
    AppSettings._storageType = 'AzureBlob'; // 'Box' 'AzureBlob'
    ////Local Environment
    AppSettings._apiPath = 'http://localhost:23550/';
    AppSettings._environmentNamae = '-L';
    AppSettings._environmentCSS = 'headerGreen';
    AppSettings._notificationserver = "http://localhost:23550/";
    AppSettings._notificationenvironment = "L";
    //AzureAD Local Setting
    AppSettings._azureADClientID = "de6d9baf-97c9-4dd7-b694-f90aaaf4d84c";
    AppSettings._azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    AppSettings._azureADRedirectUrl = "http://acore.azurewebsites.net/#/login";
    AppSettings._azureADBackendUrl = "http://acore.azurewebsites.net/#/login";
    AppSettings._azureADGraphUrl = "https://graph.windows.net";
    // public static HbotApiPath = "https://qacres4hbot.azurewebsites.net/";
    //public static dialogflowbaseurl = "https://creshbotcontrollerdevqa.azurewebsites.net/interact";
    //public static API_Key = '1b000bfcf8cd6a629f729c22a7bca73c';
    AppSettings._isAIEnable = "false";
    AppSettings._invoiceStorageType = '392'; // 'Box' 'Blob'
    AppSettings._invoiceLocation = 'Invoice';
    AppSettings._isV1UIEnable = "true";
    return AppSettings;
}());
exports.AppSettings = AppSettings;
//# sourceMappingURL=appsettings.js.map