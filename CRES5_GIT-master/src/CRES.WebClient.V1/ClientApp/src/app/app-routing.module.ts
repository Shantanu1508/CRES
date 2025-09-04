import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuard } from './core/authorization/auth.guard';
import { PageNotFoundComponent } from './components/pagenotfound.component';
import { DndDirective } from './directives/dnd.directive';

export const appRoutes: Routes = [
  {
    path: '', redirectTo: 'login', pathMatch: 'full'
  },
  {
    path: 'login',
    loadChildren: () => import('./account/login.component').then(m => m.loginModule)
  },
  {
    path: 'logininternal',
    loadChildren: () => import('./account/logininternal.component').then(m => m.logininternalModule)
  }  ,
  {
    path: 'unauthorized',
    loadChildren: () => import('./account/unauthorized.component').then(m => m.unauthorizedModule)
  },
  {
    path: 'dashboard',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/dashboard.component').then(m => m.dashboardModule)
  },
  {
    path: 'myaccount',
    loadChildren: () => import('./account/changePassword.component').then(m => m.changePasswordModule)
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
    path: 'scenariodetail/:id',
    loadChildren: () => import('./components/scenarioDetail.component').then(m => m.scenarioDetailModule)
  },
  {
    path: 'datamanagement',
    loadChildren: () => import('./account/dataManagement.component').then(m => m.dataManagementModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'forgotpassword',
    loadChildren: () => import('./account/forgotPassword.component').then(m => m.forgotPasswordModule),
  },
  {
    path: 'resetpassword/:id',
    loadChildren: () => import('./account/resetPassword.component').then(m => m.resetPasswordModule)
  },
  {
    path: 'notificationsubscription',
    loadChildren: () => import('./account/notificationSubscription.component').then(m => m.notificationSubscriptionModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'automation',
    loadChildren: () => import('./components/automation.component').then(m => m.AutomationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'calculationmanager',
    loadChildren: () => import('./components/calculationManager.component').then(m => m.calculationManagerModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'deal',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/deal.component').then(m => m.dealListModule)
  },
  {
    path: 'devdashboard',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/devDashBoard.component').then(m => m.devDashBoardModule)
  },
  {
    path: 'feeconfiguration',
    loadChildren: () => import('./components/feeConfiguration.component').then(m => m.feeConfigurationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'feeconfigurationliability/a',
    loadChildren: () => import('./components/feeConfigurationLiability.component').then(m => m.feeConfigurationLiabilityModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'feeconfigurationliability',
    loadChildren: () => import('./components/feeConfigurationLiability.component').then(m => m.feeConfigurationLiabilityModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'feeconfiguration/a',
    loadChildren: () => import('./components/feeConfiguration.component').then(m => m.feeConfigurationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'financingWareHouse',
    loadChildren: () => import('./components/financingWarehouse.component').then(m => m.financingWarehouseModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'financingdetail/:id',
    loadChildren: () => import('./components/financingWarehouseDetail.component').then(m => m.financingWareDetailModule),
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
    loadChildren: () => import('./components/function.component').then(m => m.functionModule)
  },
  {
    path: 'help',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/help.component').then(m => m.helpModule)
  },
  {
    path: 'indexes',
    loadChildren: () => import('./components/indexes.component').then(m => m.indexesModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'indexesdetail/:id',
    loadChildren: () => import('./components/indexesDetail.component').then(m => m.indexesDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'note',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/note.component').then(m => m.noteListModule)
  },
  {
    path: 'notedetail/:id',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/noteDetail.component').then(m => m.noteDetailModule)
  },
  {
    path: 'notedetail/a/:id',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/noteDetail.component').then(m => m.noteDetailModule)
  },
  {
    path: 'allnotifications',
    loadChildren: () => import('./components/notification.component').then(m => m.notificationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'periodicclose',
    loadChildren: () => import('./components/periodicClose.component').then(m => m.periodicCloseModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'a/periodicclose',
    loadChildren: () => import('./components/periodicClose.component').then(m => m.periodicCloseModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'portfolio',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/portfolio.component').then(m => m.portfolioModule)
  },
  {
    path: 'portfoliodetail/:id',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/portfolioDetail.component').then(m => m.portfolioDetailModule)
  },
  {
    path: 'reportdetail/:id',
    loadChildren: () => import('./components/reportDetail.component').then(m => m.reportDetailModule),
    canActivate: [AuthGuard]

  },
  {
    path: 'reportdetail/:tenantid/:id',
    loadChildren: () => import('./components/reportDetail.component').then(m => m.reportDetailModule),
    canActivate: [AuthGuard]

  },
  {
    path: 'property',
    loadChildren: () => import('./components/property.component').then(m => m.propertyModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'report',
    loadChildren: () => import('./components/reportPage.component').then(m => m.reportModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'tags',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/tagMaster.component').then(m => m.tagMasterModule)
  },

  {
    path: 'a/tags',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/tagMaster.component').then(m => m.tagMasterModule)
  },
  {
    path: 'taskactivity/:id',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/taskActivity.component').then(m => m.taskActivityModule)
  },
  {
    path: 'taskdetail/a/:id',
    loadChildren: () => import('./components/taskDetail.component').then(m => m.taskDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'taskdetail/:id',
    loadChildren: () => import('./components/taskDetail.component').then(m => m.taskDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'task',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/taskList.component').then(m => m.taskListModule)
  },
  {
    path: 'transactionaudit',
    loadChildren: () => import('./components/transactionAudit.component').then(m => m.transactionAuditComponentModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'transactionauditdetail/:batchid',
    loadChildren: () => import('./components/transactionAuditDetail.component').then(m => m.transactionAuditDetailComponentModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'workflowdetail/:id/:tasktype',
    loadChildren: () => import('./components/workFlowDetail.component').then(m => m.WorkFlowDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'workflowdetail/a/:id/:tasktype',
    loadChildren: () => import('./components/workFlowDetail.component').then(m => m.WorkFlowDetailModule),
    canActivate: [AuthGuard]
  },

  {
    path: 'workflow',
    loadChildren: () => import('./components/workFlow.component').then(m => m.workflowListModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'reporthistory',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/AccountingReports/accountingReportHistory.component').then(m => m.accountingReportHistoryModule)
  },
  {
    path: 'dealdetail/:id',
    loadChildren: () => import('./components/dealDetail.component').then(m => m.dealDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'dealdetail/a/:id',
    loadChildren: () => import('./components/dealDetail.component').then(m => m.dealDetailModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'importservicinglog',
    canActivate: [AuthGuard],
    loadChildren: () => import('./components/importExport/importServicingLog.component').then(m => m.importServicingLogComponentModule),
  },
  {
    path: 'importunderwriting',
    loadChildren: () => import('./components/importExport/importUnderwriting.component').then(m => m.importUnderwritingModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'inunderwritingdealdetail',
    loadChildren: () => import('./components/importExport/inUnderwritingDealDetail.component').then(m => m.inUnderwritingDealModule),
    //canActivate: [AuthGuard]
  },
  {
    path: 'transcationreconciliation',
    loadChildren: () => import('./components/importExport/transactionReconciliation.component').then(m => m.TranscationreconciliationComponentModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'transcationreconliability',
    loadChildren: () => import('./components/importExport/transactionReconLiability.component').then(m => m.TranscationreconLiabilityModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'inUnderwritingNoteDetail/:inUnNoteid',
    loadChildren: () => import('./components/importExport/inUnderwritingNoteDetail.component').then(m => m.inUnderwritingNoteModule),
  },
  {
    path: 'accountingclose',
    loadChildren: () => import('./components/accountingClose.component').then(m => m.AccountingCloseModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'equity',
    loadChildren: () => import('./components/equity.component').then(m => m.equityModule),
  }
  ,
  {
    path: 'equity/n/:nid',
    loadChildren: () => import('./components/equity.component').then(m => m.equityModule),
  }
  ,
  {
    path: 'equity/u/:nid',
    loadChildren: () => import('./components/equity.component').then(m => m.equityModule),
  },
  {
    path: 'investors',
    loadChildren: () => import('./components/investors.component').then(m => m.investorsModule),
  },
  {
    path: 'debt',
    loadChildren: () => import('./components/debt.component').then(m => m.debtModule),
  },
  {
    path: 'liabilityNote',
    loadChildren: () => import('./components/liabilityNote.component').then(m => m.liabilityNoteModule),
  },
  {
    path: 'liabilityNote/a/:id',
    loadChildren: () => import('./components/liabilityNote.component').then(m => m.liabilityNoteModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'liabilityNote/n/:nid',
    loadChildren: () => import('./components/liabilityNote.component').then(m => m.liabilityNoteModule),
    canActivate: [AuthGuard]
  }
  ,
  {
    path: 'liabilityNote/d/:nid',
    loadChildren: () => import('./components/liabilityNote.component').then(m => m.liabilityNoteModule),
    canActivate: [AuthGuard]
  }
  ,
  {
    path: 'liabilityNote/u/:nid',
    loadChildren: () => import('./components/liabilityNote.component').then(m => m.liabilityNoteModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'debt/n/:nid',
    loadChildren: () => import('./components/debt.component').then(m => m.debtModule),
  },
  {
    path: 'debt/u/:nid',
    loadChildren: () => import('./components/debt.component').then(m => m.debtModule),
  }
  ,
  {
    path: 'journalLedger',
    loadChildren: () => import('./components/journalLedger.component').then(m => m.journalledgerModule),
  },
  {
    path: 'journalLedger/n/:nid',
    loadChildren: () => import('./components/journalLedger.component').then(m => m.journalledgerModule),
  }
  ,
  {
    path: 'journalLedger/u/:nid',
    loadChildren: () => import('./components/journalLedger.component').then(m => m.journalledgerModule),
  },
  {
    path: 'xirr',
    loadChildren: () => import('./components/xirrSetup.component').then(m => m.xirrSetupModule),
    canActivate: [AuthGuard]
  }, {
    path: 'xirr/u',
    loadChildren: () => import('./components/xirrSetup.component').then(m => m.xirrSetupModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'xirrConfiguration/a/:id',
    loadChildren: () => import('./components/xirrConfiguration.component').then(m => m.xirrConfigurationModule),
    canActivate: [AuthGuard]
  }, {
    path: 'xirrConfiguration/u/:id',
    loadChildren: () => import('./components/xirrConfiguration.component').then(m => m.xirrConfigurationModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'liabilityCalculationManager',
    loadChildren: () => import('./components/liabilityCalculationManager.component').then(m => m.LiabilityCalculationManagerModule),
    canActivate: [AuthGuard]
  }  ,
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
