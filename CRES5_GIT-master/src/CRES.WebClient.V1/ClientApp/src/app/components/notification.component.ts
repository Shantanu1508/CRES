import { Component, Inject, OnInit, ViewChild, HostListener, AfterViewInit } from '@angular/core';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { PushNotificationService } from '../core/services/pushNotification.service';
import { UserNotification } from '../core/domain/userNotification.model';
import { SearchService } from '../core/services/search.service';
import { Paginated } from '../core/common/paginated.service';

@Component({
  selector: 'notification',
  providers: [PushNotificationService, SearchService],
  templateUrl: './notification.html'
})
export class Notification extends Paginated {
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;
  public _subscriptionlist: any;
  public _isSubscriptionUpdating: boolean = false;
  //  private _isnotificationFetching: boolean = false;
  //  @ViewChild('flexsubscription') flex: wjcGrid.FlexGrid;
  public _chkSelectAll: boolean;
  public Message: any = '';
  public _TotalNotificationCount: string;
  public _Notifications: string;
  public _isNotificationsshow: boolean = false;
  public _Notificationscount: number;
  public notificationmessage: string;
  public notificationcount: number = 0;
  public unotification = new Array<UserNotification>();
  public currentnotification = new Array<UserNotification>();
  constructor(
    public pushNotificationService: PushNotificationService,
    public searchService: SearchService

  ) {
    super(20, 1, 0);
    this.GetAllUserNotification();

  }
  ngAfterViewInit() {

    this.setHeight();
  }

  setHeight() {
    var notifi = document.getElementById('notifi');
    notifi.style.height = (window.innerHeight - 150).toString() + 'px';
  }


  onScrollnotifi() {
    //For paginging ----uncomment below code

    var myDiv = $('#notifi');

    if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {

      if (this.notificationcount < this._totalCount) {
        this._pageIndex = this._pageIndex + 1;
        this.GetAllUserNotification();

      }
    }

  }

  GetAllUserNotification(): void {
    this._isNotificationsshow = true;
    this._isNotificationsshow = true;
    var d = new Date();
    this.notificationmessage = "";
    var datestring = d.getFullYear() + "-" + (d.getMonth()) + "-" + d.getDate() + " " +
      d.getHours() + ":" + d.getMinutes();
    this.currentnotification = new Array<UserNotification>();

    this.pushNotificationService.getallnotification(datestring.toString(), this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        this.currentnotification = res.lstUserNotification;
        this._totalCount = res.TotalCount;
        this.notificationcount = this.notificationcount + this.currentnotification.length;
        if (this.notificationcount > 0) {
          for (var i = 0; i < this.unotification.length; i++) {
            if (window.location.href.indexOf("dealdetail/a") > -1) {
              this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('dealdetail/a/', 'dealdetail/');

            }
            else if (this.unotification[i].Msg.indexOf("dealdetail/") > -1) {
              this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('dealdetail/', 'dealdetail/a/');

            }
            if (window.location.href.indexOf("notedetail/a") > -1) {
              this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('notedetail/a/', 'notedetail/');

            }
            else if (this.unotification[i].Msg.indexOf("notedetail/") > -1) {
              this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('notedetail/', 'notedetail/a/');

            }

            this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('/a/a/', '/a/');
            debugger;
          }

        }
        else {
          this.unotification = new Array<UserNotification>();
          this._isNotificationsshow = false;
          this.notificationmessage = "No new notifications found";
        }

        this.unotification = this.unotification.concat(this.currentnotification);
        this._isNotificationsshow = false;
      }

    });

    error => console.error('Error: ' + error)

  }

  ClearAllNotification(): void {

    this.pushNotificationService.ClearAllUserNotification().subscribe(res => {
      if (res.Succeeded) {

        this.unotification = new Array<UserNotification>();
        this.notificationcount = 0;
        this.notificationmessage = "No new notifications found";
      }

    });
  }

}




const routes: Routes = [

  { path: '', component: Notification }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule],
  declarations: [Notification]

})

export class notificationModule { }
