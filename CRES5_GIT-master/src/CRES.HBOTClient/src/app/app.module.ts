import { BrowserModule } from "@angular/platform-browser";
import { NgModule, Component } from "@angular/core";
import { HttpModule } from "@angular/http";
import { AppComponent } from "./app.component";
import { ChatModule } from "./chat/chat.module";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "./material-module";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { HttpClientModule } from "@angular/common/http";
import { DataService } from "./services/data.service";
import { Routes, RouterModule } from "@angular/router";
import { AuthGuard } from "./auth/auth.guard";
import { ChatDialogComponent } from "./chat/chat-dialog/chat-dialog.component";
import { ErrorComponent } from "./Error/error.component";

export const appRoutes: Routes = [
  {
    path:'',
    component : AppComponent
  },
  {
    path: "error",
    component: ErrorComponent
  },
  {
    path: 'chat',
     canActivate: [AuthGuard],
    component: ChatDialogComponent
  }
];

@NgModule({
  declarations: [AppComponent,ErrorComponent],
  imports: [
    BrowserModule,
    ChatModule,
    MaterialModule,
    FormsModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    HttpClientModule,
    RouterModule.forRoot(appRoutes)
  ],
  providers: [DataService,AuthGuard],
  bootstrap: [AppComponent],
  exports:[RouterModule]
})
export class AppModule {}
