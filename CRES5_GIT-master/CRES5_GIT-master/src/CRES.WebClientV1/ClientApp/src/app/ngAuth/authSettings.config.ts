import { AzureADServiceConstants } from '../ngAuth/authenticators/AzureADServiceConstants.model';
import { Azuresettings } from '../../../../appsettings.json';

//AzureAD Setting
export const serviceConstants: AzureADServiceConstants = new AzureADServiceConstants(
  Azuresettings._azureADClientID,
  Azuresettings._azureADTenanID,
  Azuresettings._azureADRedirectUrl,
  Azuresettings._azureADBackendUrl,
  Azuresettings._azureADGraphUrl
);




//ACORE
//export const serviceConstants: AzureADServiceConstants = new AzureADServiceConstants(
//    "de6d9baf-97c9-4dd7-b694-f90aaaf4d84c",
//    "b8267886-f0c8-4160-ab6f-6e97968fdc90",
//    "http://acore.azurewebsites.net/#/login",
//    "http://acore.azurewebsites.net/#/login",
//    "https://graph.windows.net"
//);


//QACRES5
//export const serviceConstants: AzureADServiceConstants = new AzureADServiceConstants(
//    "cc9501b2-60d2-49e0-baa2-6d3fdcba02a8",
//    "b8267886-f0c8-4160-ab6f-6e97968fdc90",
//    "http://qacres4.azurewebsites.net/#/login",
//    "http://qacres4.azurewebsites.net/#/login",
//    "https://graph.windows.net"
//);

//PPCRES5
//export const serviceConstants: AzureADServiceConstants = new AzureADServiceConstants(
//    "db5b6521-2dcf-4e1e-904d-70ce8ee6a789",
//    "b8267886-f0c8-4160-ab6f-6e97968fdc90",
//    "http://ppcres4.azurewebsites.net/#/login",
//    "http://ppcres4.azurewebsites.net/#/login",
//    "https://graph.windows.net"
//);

//devcres4 - Azure Dev
//export const serviceConstants: AzureADServiceConstants = new AzureADServiceConstants(
//    "318c216d-c50a-4934-9a6c-5184b6ed7eed",
//    "b8267886-f0c8-4160-ab6f-6e97968fdc90",
//    "http://devcres4.azurewebsites.net/#/login",
//    "http://devcres4.azurewebsites.net/#/login",
//    "https://graph.windows.net"
//);
