import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuard } from './core/authorization/auth.guard';
import { PageNotFoundComponent } from './components/pagenotfound.component';

export const appRoutes: Routes = [
  {
    path: '',redirectTo: 'login',pathMatch: 'full'},
  {
    path: 'login',
    loadChildren: () => import('./account/login.component').then(m => m.loginModule) 
  },
  {
    path: 'dashboard',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/dashboard.component').then(m => m.dashboardModule)
  },
  {
    path: 'myaccount',
    loadChildren: ()=> import('./account/changePassword.component').then(m=>m.changePasswordModule)
  },
  {
    path: 'userpermission',
    loadChildren: () => import('./account/userPermission.component').then(m => m.userPermissionModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'scenarios',
    loadChildren: () => import('./components/scenario.component').then(m => m.scenarioModule)
  },
  {
    path: 'datamanagement',
    loadChildren: () => import ('./account/dataManagement.component').then(m=>m.dataManagementModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'forgotpassword',
    loadChildren: ()=> import('./account/forgotPassword.component').then(m=>m.forgotPasswordModule),
  },
  {
    path: 'resetpassword/:id',
    loadChildren: ()=> import('./account/resetPassword.component').then(m=>m.resetPasswordModule)
  },
  {
    path: 'notificationsubscription',
    loadChildren: ()=>import('./account/notificationSubscription.component').then(m=>m.notificationSubscriptionModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'CalculationManager',
    loadChildren: () => import('./components/calculationManager.component').then(m=>m.calculationManagerModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'deal',
    canActivate: [AuthGuard],
    loadChildren: ()=> import('./components/deal.component').then(m=>m.dealListModule)
  },
  {
    path: 'devdashboard',
    canActivate: [AuthGuard],
    loadChildren: ()=> import('./components/devDashBoard.component').then(m=>m.devDashBoardModule)
  },
  {
    path: 'feeconfiguration',
    loadChildren:()=>import('./components/feeConfiguration.component').then(m=>m.feeConfigurationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'feeconfiguration/a',
    loadChildren: () => import('./components/feeConfiguration.component').then(m => m.feeConfigurationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'financingWareHouse',
    loadChildren: ()=> import('./components/financingWarehouse.component').then(m=>m.financingWarehouseModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'financingdetail/:id',
    loadChildren: ()=>import('./components/financingWarehouseDetail.component').then(m=>m.financingWareDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'financingdetail/a/:id',
    loadChildren: () => import('./components/financingWarehouseDetail.component').then(m => m.financingWareDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'function',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/function.component').then(m=> m.functionModule)
  },
  {
    path: 'help',
    canActivate: [AuthGuard],
    loadChildren: ()=> import('./components/help.component').then(m=>m.helpModule)
  },
  {
    path: 'indexes',
    loadChildren:()=>import('./components/indexes.component').then(m=>m.indexesModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'indexesdetail/:id',
    loadChildren: ()=>import('./components/indexesDetail.component').then(m=>m.indexesDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'note',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/note.component').then(m=>m.noteListModule)
  },
  {
    path: '**',
    component: PageNotFoundComponent,
    canActivate: [AuthGuard]
  }
];



@NgModule({
  imports: [RouterModule.forRoot(appRoutes, { useHash: true })],
  exports: [RouterModule]
})





export class AppRoutingModule { }
