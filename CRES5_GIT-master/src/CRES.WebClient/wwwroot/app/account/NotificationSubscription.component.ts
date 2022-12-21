
import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MembershipService } from '../core/services/membershipservice';
import { OperationResult } from '../core/domain/operationResult';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import * as wjcGrid from 'wijmo/wijmo.grid';
import * as wjcCore from 'wijmo/wijmo';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { PushNotificationService } from '../core/services/pushnotificationservice';
import { NotificationSubs } from "../core/domain/notificationsubscription";

@Component({
    selector: 'notificationsubscription',
    providers: [MembershipService, PushNotificationService],
    templateUrl: 'app/account/NotificationSubscription.html'
})


export class NotificationSubscription {
    private _Showmessagediv: boolean = false;
    private _ShowSuccessmessagediv: boolean = false;
    private _ShowSuccessmessage: any;
    //  private _subscriptionlist: any;

    private _subscriptionlist: wjcCore.CollectionView;
    private _changesubscriptionlist=new Array<NotificationSubs>();
    private _isSubscriptionUpdating: boolean = false;
    //  private _isnotificationFetching: boolean = false;

    @ViewChild('flexsubscription') flex: wjcGrid.FlexGrid;
    private _chkSelectAll: boolean;
    private Message: any = '';

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
                            setTimeout(function () {
                                this._ShowSuccessmessagediv = false;
                                this._isSubscriptionUpdating = false;
                            }.bind(this), 3000);

                        }
                        else {
                            this._Showmessagediv = true;
                            this.Message = res.Message;
                            setTimeout(function () {
                                this._Showmessagediv = false;
                                this._isSubscriptionUpdating = false;
                            }.bind(this), 3000);
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
            else
            {
                this._ShowSuccessmessage = "Subscription updated successfully";
                this._ShowSuccessmessagediv = true;
                this._isSubscriptionUpdating = false;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._isSubscriptionUpdating = false;
                }.bind(this), 3000);
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

export class NotificationSubscriptionModule { }