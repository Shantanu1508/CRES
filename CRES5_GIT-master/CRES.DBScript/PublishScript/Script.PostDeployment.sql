/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
Print('Start Post Deployment Script')

--:r .\Lookup\Lookup.sql

--:r .\OneTime_4_2\010.OneTimeForModuleTabMaster.sql




--:r .\OneTime_3_8\010.Onetime_AppConfig.sql
--:r .\OneTime_3_8\020.Onetimejsonformatcalcv1.sql


--:r .\OneTime_3_7\010.OnetimeForRateSpreadSchedule.sql
--:r .\OneTime_3_7\020.Onetimejsonformatcalcv1.sql
--:r .\OneTime_3_7\030.Onetime_ExcelReport_PIPE.sql


--:r .\OneTime_3_6\010.OnetimeForModuleTypeMaster.sql
--:r .\OneTime_3_6\020.UpdateDecodeInTransactionType.sql
--:r .\OneTime_3_6\030.OnetimeForFirstRateINdexResetDate.sql
--:r .\OneTime_3_6\040.OnetimeForFirstRateINdexResetDate.sql


--:r .\OneTime_3_5\010.AddInEmailNotification.sql

--:r .\OneTime_3_4\010.AddInEmailNotification.sql
--:r .\OneTime_3_4\020.OnetimeForNoteBI.sql

---:r .\OneTime_3_2\010.AddInEmailNotification.sql

--:r .\OneTime_2_22\000.OnetimeforAppConfig.sql
--:r .\OneTime_2_22\010.Onetime_UpdateBalanceAware.sql
--:r .\OneTime_2_22\020.ONetime_JsonTemplateMaster.sql
--:r .\OneTime_2_22\030.Onetime_JsonTemplate.sql
--:r .\OneTime_2_22\040.Onetime_RootV1Calc.sql
--:r .\OneTime_2_22\050.Onetime_JsonFormatCalcV1.sql
--:r .\OneTime_2_22\060.Onetime_UpdateRateSpreadSchedule.sql
--:r .\OneTime_2_22\070.Onetime_RuleTypeTables.sql
--:r .\OneTime_2_22\080.Onetime_AnalysisTables.sql
--:r .\OneTime_2_22\090.UpdateAnalysisParameterColumn.sql
--:r .\OneTime_2_22\100.SetPagePermission.sql
--:r .\OneTime_2_22\110.OnetimeScenarioSetup.sql



--:r .\OneTime_2_19_1\010.UpdateParentClientAndNotificationEmail.sql
--:r .\OneTime_2_19_1\020.OnetimeEmailNotificationForMissingParentClient.sql


--:r .\OneTime_2_19\000_Onetime_AppConfig.sql
--:r .\OneTime_2_19\010.Onetime_UpdateBalanceAware.sql
--:r .\OneTime_2_19\020.ONetime_JsonTemplateMaster.sql
--:r .\OneTime_2_19\030.Onetime_JsonTemplate.sql
--:r .\OneTime_2_19\040.Onetime_RootV1Calc.sql
--:r .\OneTime_2_19\050.Onetime_JsonFormatCalcV1.sql
--:r .\OneTime_2_19\060.Onetime_UpdateRateSpreadSchedule.sql
--:r .\OneTime_2_19\070.Onetime_RuleTypeTables.sql
--:r .\OneTime_2_19\080.Onetime_AnalysisTables.sql
--:r .\OneTime_2_19\090.Ontime_Insert_Cancel_Reserve__Final_Notification.sql
--:r .\OneTime_2_19\100.UpdateCheckListDetail.sql




--:r .\OneTime_2_18_8\010.Onetime_UpdateBalanceAware.sql
--:r .\OneTime_2_18_8\020.ONetime_JsonTemplateMaster.sql
--:r .\OneTime_2_18_8\030.Onetime_JsonTemplate.sql
--:r .\OneTime_2_18_8\040.Onetime_RootV1Calc.sql
--:r .\OneTime_2_18_8\050.Onetime_JsonFormatCalcV1.sql
--:r .\OneTime_2_18_8\060.Onetime_UpdateRateSpreadSchedule.sql
--:r .\OneTime_2_18_8\070.Onetime_RuleTypeTables.sql
--:r .\OneTime_2_18_8\080.Onetime_UpdateWorkflowChecklistItemText.sql
--:r .\OneTime_2_18_8\090_Onetime_Workflow_CalcelNotification.sql
--:r .\OneTime_2_18_8\100_Onetime_AppConfig_Dynamics.sql
--:r .\OneTime_2_18_8\110_Onetime_WFNotificationMasterEmail.sql
--:r .\OneTime_2_18_8\120_Onetime_AppConfigForDynamics.sql
--:r .\OneTime_2_18_8\130.UpdateFinancingSourceGroup.sql
--:r .\OneTime_2_18_8\140.OnetimeForModuleTypeMaster.sql



--:r .\OneTime_2_18_5\010.Onetime_UpdateBalanceAware.sql
--:r .\OneTime_2_18_5\020.ONetime_JsonTemplateMaster.sql
--:r .\OneTime_2_18_5\030.Onetime_JsonTemplate.sql
--:r .\OneTime_2_18_5\040.Onetime_RootV1Calc.sql
--:r .\OneTime_2_18_5\050.Onetime_JsonFormatCalcV1.sql
--:r .\OneTime_2_18_5\060.Onetime_UpdateRateSpreadSchedule.sql
--:r .\OneTime_2_18_5\070.Onetime_RuleTypeTables.sql
--:r .\OneTime_2_18_5\080.Onetime_PrepaymentTablesV1.sql
--:r .\OneTime_2_18_6\010.OnetimeInsertQBAccountFinancingSourceMapping.sql

--:r .\OneTime_2_18_4\010.OnetimeAppConfigForPBIPwd.sql
--:r .\OneTime_2_18_4\070.OnetimeUpdateinFinancingSourceMaster.sql
--:r .\OneTime_2_18_4\100.OnetimeForModuleTypeMaster.sql
--:r .\OneTime_2_18_4\110.OnetimeWFNotificationMasterEmail.sql

--:r .\OneTime_2_18_3\010.Onetime_InvoiceConfig.sql
--:r .\OneTime_2_18_3\020.OnetimeInsertQBAccountFinancingSourceMapping.sql
--:r .\OneTime_2_18_3\030.OnetimeInsertJsonTemplate.sql
--:r .\OneTime_2_18_3\040.OnetimeForRootV1Calc.sql
--:r .\OneTime_2_18_3\050.OnetimeUpdateStartDateOfRSS sql.sql







--:r .\OneTime_2_18\030.OnetimeUpdateInTransactionTypeMaster.sql
--:r .\OneTime_2_18\040.OneTimeInsertDataDictionaryInvoices.sql
----:r .\OneTime_2_18\060.Onetime_InvoiceConfig.sql
--:r .\OneTime_2_18\070.OnetimeInsertJsonTemplate.sql
--:r .\OneTime_2_18\080.OnetimeForRootV1Calc.sql
----:r .\OneTime_2_18\090.OnetimeInsertQBAccountFinancingSourceMapping.sql




--:r .\OneTime_2_17_3\010.Onetime_insert_FullPayOff_Notification.sql
--:r .\OneTime_2_17_3\030.OneTime_Insert_REO_Email.sql
--:r .\OneTime_2_17_3\040.OneTimeForInsertManualTransactionforScenario.sql
--:r .\OneTime_2_17_3\050.OnetimeforupdatePIKInCalcMehod.sql


--:r .\OneTime_2_17_2\010.OneTime_Update_WFCheckListMaster.sql
--:r .\OneTime_2_17_2\020.OneTime_delete_WFCheckListDetail_for_nonREO.sql


--:r .\OneTime_2_17_1\010.OneTime_UpdateAutospreadCheckBox.sql
--:r .\OneTime_2_17_1\020.OneTime_InsertRepaymentForPIKDeals.sql
--:r .\OneTime_2_17_1\030.OneTime_Update_WFCheckListMaster.sql



--:r .\OneTime_2_17\2.ReportMasterTable_onetime_insert.sql
--:r .\OneTime_2_17\3.OneTimeForMaturityData.sql
--:r .\OneTime_2_17\4.OneTimeforModuleTabMater.sql
--:r .\OneTime_2_17\5.OneTimeToAddActualPayoffDateInMaturity.sql
--:r .\OneTime_2_17\7.AddEffectiveDateSameAsActualPayOffDate.sql
--:r .\OneTime_2_17\8.Onetime_Appconfig_Key_For_Calc_By_New_Maturity_Setup.sql
--:r .\OneTime_2_17\9.OneTimeForUpdateDealColumnForAutoSpread.sql
--:r .\OneTime_2_17\10.Onetime_InvoiceConfig.sql
--:r .\OneTime_2_17\11.Insert_workflow_for_purposetype_ReserveRelease.sql
--:r .\OneTime_2_17\12.WFRejectStatus_Insert_for_Purposetype_ReserveReleasee.sql
--:r .\OneTime_2_17\13.Onetime_Workflow_Update_TaskTypeID.sql
--:r .\OneTime_2_17\14.OneTime_Insert_WFCheckListMaster_For_ReserveWF.sql
--:r .\OneTime_2_17\15.Ontime_Insert_Reserve_Notification.sql
-----:r .\OneTime_2_17\16.InsertScriptForSchenario.sql
--:r .\OneTime_2_17\17.OneTime_StateMaster_added_District_of_Columbia.sql
--:r .\OneTime_2_17\18.OneTime_WFTemplateRecipient_For_ReserveWF.sql



--:r .\OneTime_2_16_3\0010.OnetimeScriptToUpdateDealColumnForAutoRepay.sql
--:r .\OneTime_2_16_3\0020.UpdateRepaymentSequesnceForSomeDeal.sql
--:r .\OneTime_2_16_3\0030.DeleteTransactionForEnableM61_N_Notes_HavingM61Cashflow.sql



--:r .\OneTime_2_16_2\1.OneTimeToUpdateFeeAsNegativeForAcoreOrigFee.sql
--:r .\OneTime_2_16_2\2.ReportMasterTable_onetime_insert.sql


--:r .\OneTime_2_16_1\1.UpdateColumnOfNoteTransactionDetail.sql
--:r .\OneTime_2_16_1\2.OneTime_For_EmailNotification.sql

 
----:r .\OneTime_2_16\1.Add_PIKLiborPercentage_In_TransactionTypes.sql
--:r .\OneTime_2_16\2.onetime_ModuleTabMaster_EnableDrawFeeTab.sql
--:r .\OneTime_2_16\3.onetime_QuickBookCompany_insert.sql
--:r .\OneTime_2_16\4.onetime_QuickBookUser_insert.sql
--:r .\OneTime_2_16\5.onetime_WFCheckListDetail_update_drawfeeapplicable.sql
--:r .\OneTime_2_16\6.onetime_WFCheckListMaster_addDrawFeeApplicable.sql
--:r .\OneTime_2_16\7.Insert_In_Holiday_Master.sql
--:r .\OneTime_2_16\8.Insert_In_DataDictionary.sql
--:r .\OneTime_2_16\9.onetime_AddedStatesinStateMaster.sql
----:r .\OneTime_2_16\10.Onetime_for_create_index_for_NotePeriodicCalc.sql
--:r .\OneTime_2_16\11.Onetime_Appconfig_Key_For_Funding_Download.sql
--:r .\OneTime_2_16\12.OneTime_InsertdatainAnalysis.sql
--:r .\OneTime_2_16\13.OneTime_For_EmailNotification.sql
--:r .\OneTime_2_16\14.OneTime_For_AllowFFSaveJsonIntoBlob.sql
--:r .\OneTime_2_16\15.ReportMasterTable_onetime_insert.sql
--:r .\OneTime_2_16\16.Entity_Update_onetime_for_TMR_and_TMNF.sql
--:r .\OneTime_2_16\17.OneTime_Insert_AppConfig.sql
--:r .\OneTime_2_16\18.AppConfig_Insert_AllowDraFeeAMEmails.sql
--:r .\OneTime_2_16\19.OneTIme_DeleteDuplicateLiborDate.sql
--:r .\OneTime_2_16\20.Insert_workflow_for_purposetype_Additional_Collateral_Purchase.sql
--:r .\OneTime_2_16\21.WFRejectStatus_Insert_for_Purposetype_Additional_Collateral_Purchase.sql
--:r .\OneTime_2_16\22.WorkFlow_Onetime_projected_for_purposetype_Additional_Collateral_Purchase.sql
--:r .\OneTime_2_16\23.ServicerDisplayNameChanges.sql
--:r .\OneTime_2_16\24.OneTime_Update_AdditionalParameters_in_ReportFileSheet.sql
--:r .\OneTime_2_16\25.Onetime_UpdateFinancingSourceMaster_ClientAbbr.sql
--:r .\OneTime_2_16\26.Onetime_DrawApprovalChecklist_AutoSendInvoice_YES.sql
--:r .\OneTime_2_16\27.Onetime_InvoiceDetail_Add_DealID_Update_DealID.sql










Print('End Post Deployment Script')