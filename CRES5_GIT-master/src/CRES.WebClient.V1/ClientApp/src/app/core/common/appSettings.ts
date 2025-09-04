

export class AppSettings {           

    ////System Setting 12
    public static _dateMinRange: string = '2000-01-01 00:00:00'; //'YYYY-MM-DD'
    public static _dateMinRangeView: string = '01-01-2000'; //'YYYY-MM-DD'
    public static _storageType: string = 'AzureBlob'; // 'Box' 'AzureBlob'

    ////Local Environment
    public static _apiPath: string = 'http://localhost:23550/';
    public static _environmentNamae: string = '-L'; 
    public static _environmentCSS: string = 'headerGreen';
    public static _notificationserver = "http://localhost:23550/";
    public static _notificationenvironment = "L";
    //AzureAD Local Setting
    public static _azureADClientID = "de6d9baf-97c9-4dd7-b694-f90aaaf4d84c";
    public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    public static _azureADRedirectUrl = "http://acore.azurewebsites.net/#/login";
    public static _azureADBackendUrl = "http://acore.azurewebsites.net/#/login";
    public static _azureADGraphUrl = "https://graph.windows.net";
   // public static HbotApiPath = "https://qacres4hbot.azurewebsites.net/";
    //public static dialogflowbaseurl = "https://creshbotcontrollerdevqa.azurewebsites.net/interact";
    //public static API_Key = '1b000bfcf8cd6a629f729c22a7bca73c';
    public static _isAIEnable: string = "false";
    public static _invoiceStorageType: string = '392'; // 'Box' 'Blob'
    public static _invoiceLocation: string = 'Invoice';
    public static _isV1UIEnable: string = "true";
     //392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer
    ///////////////////////////////////////////////////////////////////////////

    ////QA Environment 
    //public static _apiPath: string = 'https://qacres4api.azurewebsites.net/';
    //public static _environmentNamae: string = '- QA';
    //public static _environmentCSS: string = 'headerGreen';
    //public static _notificationserver = "https://devCRES5PushNotificationHub.azurewebsites.net";
    // public static _notificationenvironment = "qa";
    // //  AzureAD Setting
    //public static _azureADClientID = "cc9501b2-60d2-49e0-baa2-6d3fdcba02a8";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://qacres4.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://qacres4.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
    ////public static HbotApiPath= "https://qacres4hbot.azurewebsites.net/";
     //// AI doalogflow API
    // public static dialogflowbaseurl = "https://creshbotcontrollerdevqa.azurewebsites.net/interact";
    //public static API_Key = '1b000bfcf8cd6a629f729c22a7bca73c';
    // public static _isAIEnable: string = "true";
    //public static _invoiceStorageType: string = '392'; // 'Box' 'Blob'
    //public static _invoiceLocation: string = 'Invoice';
    ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

    /////////////////////////////////////////////////////////////////////////

    //Acore for - Acore (CRES5)
    //public static _apiPath: string = 'https://acoreapi.azurewebsites.net/';
    //public static _environmentNamae: string = '';
    //public static _environmentCSS: string = 'header';
    //public static _notificationserver = "https://cres5pushnotification.azurewebsites.net"; 
    // public static _notificationenvironment = "ac";
    ////AzureAD Acore Setting
    //public static _azureADClientID = "de6d9baf-97c9-4dd7-b694-f90aaaf4d84c";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://acore.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://acore.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
    ////public static HbotApiPath= "https://integrationcres4hbot.azurewebsites.net/";
   // public static dialogflowbaseurl = "https://hbotdialogflowclientproductionsc.azurewebsites.net/dialogflowclient?text=";
   //public static API_Key = 'tmqLsuOX5T9jF9ajasM0v6Sk78uWWRBB';
   // public static _isAIEnable: string = "true";
       //public static _invoiceStorageType: string = '392'; // 'Box' 'Blob'
    //public static _invoiceLocation: string = 'Invoice';
  
     ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

    ///////////////////////////////////////////////////////////////////////////


    //////Dev Azure for - azure (CRES5)
    //public static _apiPath: string = 'https://devcres4api.azurewebsites.net/';
    //public static _environmentNamae: string = '- Dev';
    //public static _environmentCSS: string = 'headerOrange';
    //public static _notificationserver = "https://devCRES5PushNotificationHub.azurewebsites.net";
    //public static _notificationenvironment = "dev";
    ////AzureAD Dev Setting
    //public static _azureADClientID = "318c216d-c50a-4934-9a6c-5184b6ed7eed";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://devcres4.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://devcres4.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
     // public static _isAIEnable: string = "false";
     //public static _invoiceStorageType: string = '392'; 
    //public static _invoiceLocation: string = 'Invoice';
   
     ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

    ////Demo Azure for - azure (CRES5)
    //public static _apiPath: string = 'https://cresdemoapi.azurewebsites.net/';
    //public static _environmentNamae: string = '- D';
    //public static _environmentCSS: string = 'headerOrange';
    //public static _notificationserver = "https://devcres5pushnotificationhub.azurewebsites.net";
    //public static _notificationenvironment = "demo";
    ////AzureAD Dev Setting
    //public static _azureADClientID = "318c216d-c50a-4934-9a6c-5184b6ed7eed";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://devcres4.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://devcres4.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
    ////public static HbotApiPath= "https://democres4hbot.azurewebsites.net/";
    // public static dialogflowbaseurl = "https://hbotdialogflowclientintegrationsc.azurewebsites.net/dialogflowclient?text=";
    //public static API_Key = 'sqJ93jewll1olTCBMHWi9U1oYOL1uKEo';
    //public static _isAIEnable: string = "false";
     //public static _invoiceStorageType: string = '392'; 
    //public static _invoiceLocation: string = 'Invoice';
     ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

    //////Fast-Dev Azure for - azure (CRES5)
    //public static _apiPath: string = 'https://fastwebapi.azurewebsites.net/';
    //public static _environmentNamae: string = '- Fast';
    //public static _environmentCSS: string = 'headerOrange';
    //public static _notificationserver = "https://devCRES5PushNotificationHub.azurewebsites.net";
    //public static _notificationenvironment = "dev";
    ////AzureAD Dev Setting
    //public static _azureADClientID = "318c216d-c50a-4934-9a6c-5184b6ed7eed";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://fastwebdev.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://fastwebdev.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
     // public static _isAIEnable: string = "false";
    ///////////////////////////////////////////////////////////////////////////

    //Staging Azure for - azure (CRES5)
    //public static _apiPath: string = 'https://stagingcres4api.azurewebsites.net/';
    //public static _environmentNamae: string = '- St';
    //public static _environmentCSS: string = 'headerPurple';
    // public static _notificationserver = "https://devCRES5PushNotificationHub.azurewebsites.net";
    // public static _notificationenvironment = "staging";
    ////AzureAD Dev Setting
    //public static _azureADClientID = "4406dbea-e758-4203-8309-fb9d476702b5";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://stagingcres4.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://stagingcres4.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
   // //public static HbotApiPath= "https://stagingcres4hbot.azurewebsites.net/";
     //public static _isAIEnable: string = "false";
    //public static _invoiceStorageType: string = '392'; 
    //public static _invoiceLocation: string = 'Invoice';
    ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

    ///////////////////////////////////////////////////////////////////////////


    //Integration Azure for - (CRES_Integration)
    //public static _apiPath: string = 'https://integrationcres4api.azurewebsites.net/';
    //public static _environmentNamae: string = '- In';
    //public static _environmentCSS: string = 'headerYellow';
    // public static _notificationserver = "https://devCRES5PushNotificationHub.azurewebsites.net";
    // public static _notificationenvironment = "In";
    ////AzureAD Dev Setting
    //public static _azureADClientID = "4588f2e6-3c0d-4105-93f6-f391dc97d076";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://integrationcres4.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://integrationcres4.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
    ////public static HbotApiPath= "https://integrationcres4hbot.azurewebsites.net/";
    //public static dialogflowbaseurl = " https://creshbotcontrollerintegration.azurewebsites.net/interact";
    //public static API_Key = 'sqJ93jewll1olTCBMHWi9U1oYOL1uKEo';
     // public static _isAIEnable: string = "true";
    //public static _invoiceStorageType: string = '392'; 
    //public static _invoiceLocation: string = 'Invoice';
     ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer
    ///////////////////////////////////////////////////////////////////////////


    ////Demo Azure for - azure (CRES5)
    //public static _apiPath: string = 'https://cresdemoapi.azurewebsites.net/';
    //public static _environmentNamae: string = '- D';
    //public static _environmentCSS: string = 'headerOrange';
    //public static _notificationserver = "https://devCRES5PushNotificationHub.azurewebsites.net";
    //public static _notificationenvironment = "demo";
    ////AzureAD Dev Setting
    //public static _azureADClientID = "318c216d-c50a-4934-9a6c-5184b6ed7eed";
    //public static _azureADTenanID = "b8267886-f0c8-4160-ab6f-6e97968fdc90";
    //public static _azureADRedirectUrl = "https://devcres4.azurewebsites.net/#/login";
    //public static _azureADBackendUrl = "https://devcres4.azurewebsites.net/#/login";
    //public static _azureADGraphUrl = "https://graph.windows.net";
    ////public static HbotApiPath= "https://democres4hbot.azurewebsites.net/";
     // public static _isAIEnable: string = "true";
    //public static _invoiceStorageType: string = '392'; 
    //public static _invoiceLocation: string = 'Invoice';
     ////392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer
}
