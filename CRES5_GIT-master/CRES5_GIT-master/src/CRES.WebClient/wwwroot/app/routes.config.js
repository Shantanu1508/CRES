"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppRoutingModule = exports.appRoutes = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var auth_guard_1 = require("./core/authorization/auth.guard");
var pagenotfound_component_1 = require("./components/pagenotfound.component");
exports.appRoutes = [
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
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/dashboard.component#DashboardModule'
    },
    {
        path: 'deal',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/deal.component#DealListModule'
    },
    {
        path: 'note',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/note.component#NoteListModule'
    },
    {
        path: 'workflowdetail/:id/:tasktype',
        loadChildren: 'app/components/WorkflowDetail.component#WorkflowDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'workflowdetail/a/:id/:tasktype',
        loadChildren: 'app/components/WorkflowDetail.component#WorkflowDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'workflow',
        loadChildren: 'app/components/workflow.component#WorkflowListModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'feeconfiguration',
        loadChildren: 'app/components/feeconfiguration.component#FeeConfigurationModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'feeconfiguration/a',
        loadChildren: 'app/components/feeconfiguration.component#FeeConfigurationModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'dealdetail/:id',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'dealdetail/a/:id',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'dealdetail/:id/:tab',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'dealdetail/a/:id/:tab',
        loadChildren: 'app/components/dealdetail.component#DealDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'notedetail/:id',
        loadChildren: 'app/components/notedetail.component#NoteDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'notedetail/a/:id',
        loadChildren: 'app/components/notedetail.component#NoteDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'financingWareHouse',
        loadChildren: 'app/components/financingWarehouse.component#FinancingWareModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'financingdetail/:id',
        loadChildren: 'app/components/fianancingWarehousedetail.component#FinancingWareDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'financingdetail/a/:id',
        loadChildren: 'app/components/fianancingWarehousedetail.component#FinancingWareDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'property',
        loadChildren: 'app/components/property.component#PropertyModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'ImportUnderwriting',
        loadChildren: 'app/components/ImportExport/ImportUnderwriting.component#ImportUnderwritingModule',
        canActivate: [auth_guard_1.AuthGuard]
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
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'reportdetail/:id',
        loadChildren: 'app/components/reportdetail.component#ReportDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'a/CalculationManager',
        loadChildren: 'app/components/CalculationManager.component#CalculationManagerModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'CalculationManager',
        loadChildren: 'app/components/CalculationManager.component#CalculationManagerModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'scenarios',
        loadChildren: 'app/components/scenario.component#ScenarioModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'scenariodetail/:id',
        loadChildren: 'app/components/scenariodetail.component#ScenarioDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'indexes',
        loadChildren: 'app/components/indexes.component#IndexesModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'indexesdetail/:id',
        loadChildren: 'app/components/indexesdetail.component#IndexesDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'userpermission',
        loadChildren: 'app/account/userpermission.component#userpermissionModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'datamanagement',
        loadChildren: 'app/account/dataManagement.component#DataManagementModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'notificationsubscription',
        loadChildren: 'app/account/NotificationSubscription.component#NotificationSubscriptionModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'allnotifications',
        loadChildren: 'app/components/Notification.component#NotificationModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'taskdetail/a/:id',
        loadChildren: 'app/components/Taskdetail.component#TaskDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'taskdetail/:id',
        loadChildren: 'app/components/Taskdetail.component#TaskDetailModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'task',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/TaskList.component#TaskListModule'
    },
    {
        path: 'help',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/Help.component#HelpModule'
    },
    {
        path: 'devdashboard',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/DevDashBoard.component#DevDashBoardModule'
    },
    {
        path: 'tags',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/TagMaster.component#TagMasterModule'
    },
    {
        path: 'a/tags',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/TagMaster.component#TagMasterModule'
    },
    {
        path: 'taskactivity/:id',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/TaskActivity.component#TaskActivityModule'
    },
    {
        path: 'ImportServicingLog',
        loadChildren: 'app/components/ImportExport/ImportServicingLog.component#ImportServicingLogComponentModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'function',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/function.component#FucntionModule'
    },
    {
        path: 'Transcationreconciliation',
        loadChildren: 'app/components/ImportExport/Transcationreconciliation.component#TranscationreconciliationComponentModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'Transactionaudit',
        loadChildren: 'app/components/TransactionAudit.component#TransactionAuditComponentModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'Transactionauditdetail/:batchid',
        loadChildren: 'app/components/TransactionAuditDetail.component#TransactionAuditDetailComponentModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'portfolio',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/portfolio.component#PortfolioModule'
    },
    {
        path: 'portfoliodetail/:id',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/portfoliodetail.component#PortfolioDetailModule'
    },
    {
        path: 'periodicclose',
        loadChildren: 'app/components/periodicClose.component#PeriodicCloseModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'a/periodicclose',
        loadChildren: 'app/components/periodicClose.component#PeriodicCloseModule',
        canActivate: [auth_guard_1.AuthGuard]
    },
    {
        path: 'reporthistory',
        canActivate: [auth_guard_1.AuthGuard],
        loadChildren: 'app/components/AccountingReports/AccountingReportHistory.component#AccountingReportHistoryModule'
    },
    {
        path: '**',
        component: pagenotfound_component_1.PageNotFoundComponent,
        canActivate: [auth_guard_1.AuthGuard]
    }
];
var AppRoutingModule = /** @class */ (function () {
    function AppRoutingModule() {
    }
    AppRoutingModule = __decorate([
        (0, core_1.NgModule)({
            imports: [router_1.RouterModule.forRoot(exports.appRoutes)],
            exports: [router_1.RouterModule]
        })
    ], AppRoutingModule);
    return AppRoutingModule;
}());
exports.AppRoutingModule = AppRoutingModule;
//export const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes);
//# sourceMappingURL=routes.config.js.map