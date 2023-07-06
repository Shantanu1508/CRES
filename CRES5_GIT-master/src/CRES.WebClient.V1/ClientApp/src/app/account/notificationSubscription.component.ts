
import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MembershipService } from '../core/services/membership.service';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import * as wjcCore from '@grapecity/wijmo';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { PushNotificationService } from '../core/services/pushNotification.service';
import { NotificationSubs } from "../core/domain/notificationSubscription.model";

@Component({
  selector: 'notificationsubscription',
  providers: [MembershipService, PushNotificationService],
  templateUrl: './notificationSubscription.html'
})


export class NotificationSubscription {
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;
  //  private _subscriptionlist: any;

  public _subscriptionlist !: wjcCore.CollectionView;
  public _changesubscriptionlist = new Array<NotificationSubs>();
  public _isSubscriptionUpdating: boolean = false;
  //  private _isnotificationFetching: boolean = false;

  @ViewChild('flexsubscription') flex !: wjcGrid.FlexGrid;
  public _chkSelectAll !: boolean;
  public Message: any = '';

  constructor(public membershipService: MembershipService,
    public pushNotificationService: PushNotificationService

  ) {



    this.GetNotificationSubscription();
  }


  GetNotificationSubscription(): void {
    this._isSubscriptionUpdating = true;
    this.pushNotificationService.getnotificationsubscription(0, 30).subscribe(res => {
      if (res.Succeeded) {
        this._subscriptionlist = res.lstSubscription;
        // this._changesubscriptionlist = res.lstSubscription;
        this._subscriptionlist = new wjcCore.CollectionView(this._subscriptionlist);
        this._subscriptionlist.trackChanges = true;

        this._isSubscriptionUpdating = false;
      }

    });


  }

  SelectAll(): void {

    this._chkSelectAll = !this._chkSelectAll;

    for (var i = 0; i < this._subscriptionlist.items.length; i++) {
      this._subscriptionlist.items[i].Status = this._chkSelectAll;
    }
    this.flex.invalidate();
  }

  SaveNotificationSubscription(): void {

    this._isSubscriptionUpdating = true;
    try {


      if (this._subscriptionlist.itemsEdited.length > 0) {
        for (var i = 0; i < this._subscriptionlist.itemsEdited.length; i++) {
          this._changesubscriptionlist[i] = this._subscriptionlist.itemsEdited[i];
        }

        if (this._changesubscriptionlist.length > 0) {
          this.pushNotificationService.savenotificationsubscription(this._changesubscriptionlist).subscribe(res => {
            if (res.Succeeded) {
              localStorage.setItem('notificationchanged', "YES");
              this._ShowSuccessmessage = res.Message;
              this._ShowSuccessmessagediv = true;
              //  this.GetNotificationSubscription();
              setTimeout(() => {
                this._ShowSuccessmessagediv = false;
                this._isSubscriptionUpdating = false;
              }, 3000);

            }
            else {
              this._Showmessagediv = true;
              this.Message = res.Message;
              setTimeout(() => {
                this._Showmessagediv = false;
                this._isSubscriptionUpdating = false;
              }, 3000);
            }
          });
        }
        else {
          this._Showmessagediv = true;
          this.Message = "No subscription type available.";
          setTimeout(() => {
            this._Showmessagediv = false;
            this._isSubscriptionUpdating = false;
          }, 5000);
          this._isSubscriptionUpdating = false;
        }
      }
      else {
        this._ShowSuccessmessage = "Subscription updated successfully";
        this._ShowSuccessmessagediv = true;
        this._isSubscriptionUpdating = false;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
          this._isSubscriptionUpdating = false;
        }, 3000);
      }
    } catch (err) {
      this._isSubscriptionUpdating = false;
      alert(err);
    }

  }

}




const routes: Routes = [

  { path: '', component: NotificationSubscription }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule],
  declarations: [NotificationSubscription]

})

export class notificationSubscriptionModule { }
