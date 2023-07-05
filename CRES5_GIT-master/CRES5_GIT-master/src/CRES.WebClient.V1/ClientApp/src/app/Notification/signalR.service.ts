// import the packages  
import { Injectable, EventEmitter, Inject } from '@angular/core';
import appsettings from '../../../../appsettings.json';
import { GetClockTime } from '../getClocktime.model';
import { PushNotificationService } from '../core/services/pushNotification.service';
//import { CalculationManagerComponent } from '../components/calculationmanager.component';
//import { Notificationsettings } from '../../../../appsettings.json';
declare var $: any;
// declare the global variables  
@Injectable()
export class SignalRService {
  private proxy: any;
  private proxyName: string = 'chatHub';
  private connection: any;
  public lstNotification: any = null;
  public messageReceived: EventEmitter<any>;
  public connectionEstablished: EventEmitter<Boolean>;
  public connectionExists: Boolean;
  public updateCalcNotification: EventEmitter<string> = new EventEmitter<string>();

  constructor(public pushNotificationService: PushNotificationService) {
    // Constructor initialization        
    this.connectionEstablished = new EventEmitter<Boolean>();
    this.messageReceived = new EventEmitter<GetClockTime>();
    this.connectionExists = false;
    // create hub connection  
    this.connection = $.hubConnection(appsettings.Notificationsettings._notificationserver);
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
  public SendNotification(_notificationMsg: string,) {
    // server side hub method using proxy.invoke with method name pass as param  
    this.proxy.invoke('SendToOtherUsers', 'testing', _notificationMsg);
  }

  public SendCalcNotification(message: string) {
    // server side hub method using proxy.invoke with method name pass as param  
    this.proxy.invoke('UpdateCalcStatus', message);
  }

  public SendTaskToOthers(_taskId: string, _message: string) {
    // server side hub method using proxy.invoke with method name pass as param  
    this.proxy.invoke('SendTaskToOthers', _taskId, _message);
  }





  // check in the browser console for either signalr connected or not  
  private startConnection(): void {
    this.connection.start().done((data: any) => {
      console.log('Now connected ' + data.transport.name + ', connection ID= ' + data.id);
      this.connectionEstablished.emit(true);
      this.connectionExists = true;
    }).fail((error: any) => {
      console.log('Could not connect ' + error);
      this.connectionEstablished.emit(false);
    });
  }

  private registerOnServerEvents(): void {

    this.proxy.on('addMessage', (userName:any, message:any) => {
      var isnotificationchanged = localStorage.getItem('notificationchanged');
      if (this.lstNotification == null || isnotificationchanged == "YES") {
        this.pushNotificationService.getnotificationsubscription(1, 30).subscribe(res => {
          if (res.Succeeded) {
            this.lstNotification = res.lstSubscription;

            var user:any = localStorage.getItem('user');
            var username = JSON.parse(user);
            //var isuserexist = _lstsubscriber.indexOf(username.UserID);

            var _pushNotification = message.split('|*|');
            var issubscribed = this.lstNotification.find((x:any) => x.Name == _pushNotification[0]).Status;

            if (issubscribed == true && username.UserID != _pushNotification[3]) {
              if ($("#notificationscount").text() == "") {
                $("#notificationscount").text("0");
              }

              $("#notificationscount").text(parseInt($("#notificationscount").text()) + 1);
              this.messageReceived.emit(_pushNotification[1]);
              $('#ptitle').html(_pushNotification[1]);
              $("#displayNotification").click()
            }
          }
        });
      }
      else {

        // console.log('elseeee' + $("#notificationscount").text());
        var user: any = localStorage.getItem('user');
        var username = JSON.parse(user);
        var _pushNotification = message.split('|*|');
        var issubscribed = this.lstNotification.find((x:any) => x.Name == _pushNotification[0]).Status;

        if (issubscribed == true && username.UserID != _pushNotification[3]) {
          if ($("#notificationscount").text() == "") {
            $("#notificationscount").text("0");
          }
          $("#notificationscount").text(parseInt($("#notificationscount").text()) + 1);
          this.messageReceived.emit(_pushNotification[1]);
          $('#ptitle').html(_pushNotification[1]);
          $("#displayNotification").click()
        }
      }
    })

    this.proxy.on('updateClientCalcStatus', (_noteid:any, UpdateCalcStatus:any) => {
      // console.log("Client " + Date() +" Server: " + strcalctime + " signalr : " + signalrtime);         
      this.updateCalcNotification.emit(_noteid);
    });

    this.proxy.on('SendTaskToOtherUsers', (_taskid:any, _message:any) => {
      var _pushNotification = _message.split('|*|');
      var _lstsubscriber = _pushNotification[3].split(',');
      //  var _subscriberusers = _lstsubscriber.split('|**|');
      var user: any = localStorage.getItem('user');
      var username = JSON.parse(user);
      var isuserexist = _lstsubscriber.indexOf(username.UserID);
      var env = _pushNotification[2];

      if (appsettings.Notificationsettings._notificationenvironment == env && isuserexist > -1) {
        $('#ptitle').html(_pushNotification[1]);
        $("#displayNotification").click()
        this.messageReceived.emit(_pushNotification[1]);
        if ($("#notificationscount").text() == "") {
          $("#notificationscount").text("0");
        }
        $("#notificationscount").text(parseInt($("#notificationscount").text()) + 1);
      }
    });

  }
}

