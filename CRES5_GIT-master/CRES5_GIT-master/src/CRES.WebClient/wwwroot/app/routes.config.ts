
import { NgModule, ModuleWithProviders } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { AuthGuard } from './core/authorization/auth.guard';
import { PageNotFoundComponent } from './components/pagenotfound.component';

export const appRoutes: Routes = [    
    {
        path: '',
        redirectTo: 'login',
        pathMatch: 'full'
    },   
    {
        path: 'login',
       //  component: LoginComponent
        loadChildren: 'app/account/login.component#LoginModule'
    },
    {
        path: 'myaccount',
        //  component: LoginComponent
        loadChildren: 'app/account/changePassword.component#changepasswordModule'
    },
    {
        path: 'resetpassword/:id',
        loadChildren: 'app/account/resetPassword.component#resetpasswordModule'
    },
    {
        path: 'forgotpassword',
        loadChildren: 'app/account/forgotPassword.component#forgotpasswordModule'
    },
    {
        path: 'dashboard', 
       canActivate: [AuthGuard],     
       loadChildren: 'app/components/dashboard.component#DashboardModule'
     
    }, 
     
    {
        path: 'deal',    
        canActivate: [AuthGuard], 
        loadChildren: 'app/components/deal.component#DealListModule'
    },
    {
        path: 'note',    
        canActivate: [AuthGuard],
        loadChildren: 'app/components/note.component#NoteListModule'
    },
    {
        path: 'workflowdetail/:id/:tasktype',
        loadChildren: 'app/components/WorkflowDetail.component#WorkflowDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'workflowdetail/a/:id/:tasktype',
        loadChildren: 'app/components/WorkflowDetail.component#WorkflowDetailModule',
        canActivate: [AuthGuard]
    },

    {
        path: 'workflow',
        loadChildren: 'app/components/workflow.component#WorkflowListModule',
        canActivate: [AuthGuard]
    },  
    {
        path: 'feeconfiguration',
        loadChildren: 'app/components/feeconfiguration.component#FeeConfigurationModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'feeconfiguration/a',
        loadChildren: 'app/components/feeconfiguration.component#FeeConfigurationModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'dealdetail/:id',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
       canActivate: [AuthGuard]
    },
    {
        path: 'dealdetail/a/:id',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'dealdetail/:id/:tab',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'dealdetail/a/:id/:tab',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'notedetail/:id',
        loadChildren: 'app/components/notedetail.component#NoteDetailModule',
        canActivate: [AuthGuard]
       
    },
    {
        path: 'notedetail/a/:id',
        loadChildren: 'app/components/notedetail.component#NoteDetailModule',
        canActivate: [AuthGuard]

    },
     {
         path: 'financingWareHouse',
         loadChildren: 'app/components/financingWarehouse.component#FinancingWareModule',
         canActivate: [AuthGuard]
    },
    {
        path: 'financingdetail/:id',
        loadChildren: 'app/components/fianancingWarehousedetail.component#FinancingWareDetailModule',
        canActivate: [AuthGuard]
     },
    {
        path: 'financingdetail/a/:id',
        loadChildren: 'app/components/fianancingWarehousedetail.component#FinancingWareDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'property',
        loadChildren: 'app/components/property.component#PropertyModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'ImportUnderwriting',
        loadChildren: 'app/components/ImportExport/ImportUnderwriting.component#ImportUnderwritingModule',       
        canActivate: [AuthGuard]
    },
    {
        path: 'IN_UnderwritingDealDetail',
        loadChildren: 'app/components/ImportExport/IN_UnderwritingDealDetail.component#IN_UnderwritingDealModule', 
       // component: IN_UnderwritingDealDetailComponent,
        //canActivate: [AuthGuard]
    },
    {
        path: 'IN_UnderwritingNoteDetail/:in_UnNoteid',
        loadChildren: 'app/components/ImportExport/IN_UnderwritingNoteDetail.component#IN_UnderwritingNoteModule', 
        //component: IN_UnderwritingNoteDetailComponent
    },
    {
        path: 'report',
        loadChildren: 'app/components/reportpage.component#ReportModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'reportdetail/:id',
        loadChildren: 'app/components/reportdetail.component#ReportDetailModule',
        canActivate: [AuthGuard]
        
    },
    {
        path: 'a/CalculationManager',
        loadChildren: 'app/components/CalculationManager.component#CalculationManagerModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'CalculationManager',
        loadChildren: 'app/components/CalculationManager.component#CalculationManagerModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'scenarios',
        loadChildren: 'app/components/scenario.component#ScenarioModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'scenariodetail/:id',
        loadChildren: 'app/components/scenariodetail.component#ScenarioDetailModule',
        canActivate: [AuthGuard]
    },  
    {
        path: 'indexes',
        loadChildren: 'app/components/indexes.component#IndexesModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'indexesdetail/:id',
        loadChildren: 'app/components/indexesdetail.component#IndexesDetailModule',
        canActivate: [AuthGuard]
    },    
    {
        path: 'userpermission',
        loadChildren: 'app/account/userpermission.component#userpermissionModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'datamanagement',
        loadChildren: 'app/account/dataManagement.component#DataManagementModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'notificationsubscription',
        loadChildren: 'app/account/NotificationSubscription.component#NotificationSubscriptionModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'allnotifications',
        loadChildren: 'app/components/Notification.component#NotificationModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'taskdetail/a/:id',
        loadChildren: 'app/components/Taskdetail.component#TaskDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'taskdetail/:id',
        loadChildren: 'app/components/Taskdetail.component#TaskDetailModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'task',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/TaskList.component#TaskListModule'
    },
    {
        path: 'help',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/Help.component#HelpModule'
    },
    {
        path: 'devdashboard',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/DevDashBoard.component#DevDashBoardModule'
    },
    {
        path: 'tags',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/TagMaster.component#TagMasterModule'
    },

    {
        path: 'a/tags',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/TagMaster.component#TagMasterModule'
    },

    {
        path: 'taskactivity/:id',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/TaskActivity.component#TaskActivityModule'
    },
    {
        path: 'ImportServicingLog',
        loadChildren: 'app/components/ImportExport/ImportServicingLog.component#ImportServicingLogComponentModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'function',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/function.component#FucntionModule'
    },
    {
        path: 'Transcationreconciliation',
        loadChildren: 'app/components/ImportExport/Transcationreconciliation.component#TranscationreconciliationComponentModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'Transactionaudit',
        loadChildren: 'app/components/TransactionAudit.component#TransactionAuditComponentModule',
        canActivate: [AuthGuard]
    },   
    {
        path: 'Transactionauditdetail/:batchid',
        loadChildren: 'app/components/TransactionAuditDetail.component#TransactionAuditDetailComponentModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'portfolio',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/portfolio.component#PortfolioModule'
    },
    {
        path: 'portfoliodetail/:id',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/portfoliodetail.component#PortfolioDetailModule'
    },    
    {
        path: 'periodicclose',
        loadChildren: 'app/components/periodicClose.component#PeriodicCloseModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'a/periodicclose',
        loadChildren: 'app/components/periodicClose.component#PeriodicCloseModule',
        canActivate: [AuthGuard]
    },
    {
        path: 'reporthistory',
        canActivate: [AuthGuard],
        loadChildren: 'app/components/AccountingReports/AccountingReportHistory.component#AccountingReportHistoryModule'
    },

    {
        path: '**',
        component: PageNotFoundComponent,
        canActivate: [AuthGuard]
    }   
];



@NgModule({
    imports: [RouterModule.forRoot(appRoutes)],
   exports: [RouterModule]
})

export class AppRoutingModule {

}
//export const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes);
