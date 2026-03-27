

Declare @CurrentDBName nvarchar(256)
Declare @DBName_QA nvarchar(256)
Declare @DBName_Integration nvarchar(256)
Declare @DBName_Staging nvarchar(256)
Declare @DBName_Dev nvarchar(256)
Declare @DBName_Alpha nvarchar(256)
Declare @DBName_PIKMode nvarchar(256)
Declare @DBName_Demo nvarchar(256)

SET @CurrentDBName = (SELECT DB_NAME())
SET @DBName_QA  = 'CRES4_QA_New'
SET @DBName_Integration = 'CRES4_Integration_New'
SET @DBName_Staging= 'CRES4_Staging'
SET @DBName_Dev= 'CRES4_DEV_New'
SET @DBName_Alpha= 'CRES4_Alpha'
SET @DBName_PIKMode= 'CRES4_PIKMode'
SET @DBName_Demo= 'CRES4_Demo'
----=============================================


IF(@CurrentDBName = @DBName_QA OR @CurrentDBName = @DBName_Alpha)
BEGIN
	IF(@CurrentDBName = @DBName_Alpha)
		Print('Create Alpha users')
	ELSE
		Print('Create QA users')
		

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'BIViewerUser')
	DROP USER BIViewerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Acore_BIViewer')
		DROP ROLE  Acore_BIViewer

	CREATE USER BIViewerUser FROM LOGIN BIViewer;
	CREATE ROLE  Acore_BIViewer AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Acore_BIViewer', 'BIViewerUser';
	ALTER ROLE db_owner Add Member Acore_BIViewer

	---=========================================
	--IF(@CurrentDBName = @DBName_QA)
	--BEGIN
		IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'Cres4_qa_user')
			DROP USER Cres4_qa_user
		IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Cres4_qa_role')
			DROP ROLE  Cres4_qa_role

		CREATE USER Cres4_qa_user FROM LOGIN Cres4_qa;
		CREATE ROLE  Cres4_qa_role AUTHORIZATION [dbo]
		EXEC sp_addrolemember 'Cres4_qa_role', 'Cres4_qa_user';
		ALTER ROLE db_owner Add Member Cres4_qa_role
	--END
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESAccountingUser')
		DROP USER CRESAccountingUser
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESAccounting_Role')
		DROP ROLE  CRESAccounting_Role

	CREATE USER CRESAccountingUser FROM LOGIN CRESAccounting;
	CREATE ROLE  CRESAccounting_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESAccounting_Role', 'CRESAccountingUser';
	GRANT SELECT ON [DealEquityAmount] TO CRESAccounting_Role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_user')
		DROP USER CresReader_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_role')
		DROP ROLE  CresReader_role

	CREATE USER CresReader_user FROM LOGIN CresReader;
	CREATE ROLE  CresReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_role', 'CresReader_user';
	ALTER ROLE db_datareader Add Member CresReader_role

	--======================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_temp_user')
	DROP USER CresReader_temp_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_temp_role')
		DROP ROLE  CresReader_temp_role

	CREATE USER CresReader_temp_user FROM LOGIN CresReader_temp;
	CREATE ROLE  CresReader_temp_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_temp_role', 'CresReader_temp_user';
	ALTER ROLE db_datareader Add Member CresReader_temp_role

	--======================================


	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ReadScriptUser')
		DROP USER ReadScriptUser

	CREATE USER ReadScriptUser
		   FOR LOGIN ReadScriptUser
		   WITH DEFAULT_SCHEMA = dbo

	-- Add user to the database owner role
	ALTER ROLE [db_datareader] ADD MEMBER ReadScriptUser

	GRANT VIEW DEFINITION TO ReadScriptUser;
	grant execute on dbo.usp_getnotecashflowsexportdata to ReadScriptUser
	--======================================


	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUserQA')
		DROP USER sizerUserQA
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_ModifyQA')
		DROP ROLE  sizer_ModifyQA

	CREATE USER sizerUserQA FROM LOGIN SizerQA;
	CREATE ROLE  sizer_ModifyQA AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_ModifyQA', 'sizerUserQA';
	ALTER ROLE db_owner Add Member sizer_ModifyQA
	--===========================================================
		
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'RohitAdmin_user')
		DROP USER RohitAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'RohitAdmin_role')
		DROP ROLE  RohitAdmin_role

	CREATE USER RohitAdmin_user FROM LOGIN RohitAdmin;
	CREATE ROLE  RohitAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'RohitAdmin_role', 'RohitAdmin_user';
	ALTER ROLE db_owner Add Member RohitAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'VishalAdmin_user')
		DROP USER VishalAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'VishalAdmin_role')
		DROP ROLE  VishalAdmin_role


	CREATE USER VishalAdmin_user FROM LOGIN VishalAdmin;
	CREATE ROLE  VishalAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'VishalAdmin_role', 'VishalAdmin_user';
	ALTER ROLE db_owner Add Member VishalAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'KrishnaAdmin_user')
		DROP USER KrishnaAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'KrishnaAdmin_role')
		DROP ROLE  KrishnaAdmin_role


	CREATE USER KrishnaAdmin_user FROM LOGIN KrishnaAdmin;
	CREATE ROLE  KrishnaAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'KrishnaAdmin_role', 'KrishnaAdmin_user';
	ALTER ROLE db_owner Add Member KrishnaAdmin_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ValuationQA_User')
		DROP USER ValuationQA_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'ValuationQA_role')
		DROP ROLE  ValuationQA_role

	CREATE USER ValuationQA_User FROM LOGIN ValuationQA;
	CREATE ROLE  ValuationQA_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'ValuationQA_role', 'ValuationQA_User';
	ALTER ROLE db_owner Add Member ValuationQA_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Reader_Swapna_user')
		DROP USER CRES4_Reader_Swapna_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Reader_Swapna_role')
		DROP ROLE  CRES4_Reader_Swapna_role

	CREATE USER CRES4_Reader_Swapna_user FROM LOGIN CRES4_Reader_Swapna;
	CREATE ROLE  CRES4_Reader_Swapna_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Reader_Swapna_role', 'CRES4_Reader_Swapna_user';
	ALTER ROLE db_datareader Add Member CRES4_Reader_Swapna_role

END

IF(@CurrentDBName = @DBName_Integration)
BEGIN
	Print('Create Integration users')

    IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'BIViewerUser')
	DROP USER BIViewerUser 

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Acore_BIViewer')
		DROP ROLE  Acore_BIViewer

	CREATE USER BIViewerUser FROM LOGIN BIViewer;
	CREATE ROLE  Acore_BIViewer AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Acore_BIViewer', 'BIViewerUser';
	ALTER ROLE db_owner Add Member Acore_BIViewer
	---=========================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Integration_user')
		DROP USER CRES4_Integration_user

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Integration_role')
		DROP ROLE  CRES4_Integration_role

	CREATE USER CRES4_Integration_user FROM LOGIN CRES4_Integration;
	CREATE ROLE  CRES4_Integration_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Integration_role', 'CRES4_Integration_user';
	ALTER ROLE db_owner Add Member CRES4_Integration_role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESAccountingUser')
		DROP USER CRESAccountingUser

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESAccounting_Role')
		DROP ROLE  CRESAccounting_Role

	CREATE USER CRESAccountingUser FROM LOGIN CRESAccounting;
	CREATE ROLE  CRESAccounting_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESAccounting_Role', 'CRESAccountingUser';
	GRANT SELECT ON [DealEquityAmount] TO CRESAccounting_Role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_user')
		DROP USER CresReader_user 

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_role')
		DROP ROLE  CresReader_role

	CREATE USER CresReader_user FROM LOGIN CresReader;
	CREATE ROLE  CresReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_role', 'CresReader_user';
	ALTER ROLE db_datareader Add Member CresReader_role

	--======================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUserIntegration')
		DROP USER sizerUserIntegration

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_ModifyIntegration')
		DROP ROLE  sizer_ModifyIntegration

	CREATE USER sizerUserIntegration FROM LOGIN SizerIntegration;
	CREATE ROLE  sizer_ModifyIntegration AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_ModifyIntegration', 'sizerUserIntegration';
	ALTER ROLE db_owner Add Member sizer_ModifyIntegration
	--======================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresBsViewer_User')
		DROP USER CresBsViewer_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresBsViewer_role')
		DROP ROLE  CresBsViewer_role

	CREATE USER CresBsViewer_User FROM LOGIN CresBsViewer;
	CREATE ROLE  CresBsViewer_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresBsViewer_role', 'CresBsViewer_User';

	GRANT SELECT ON [dbo].[View_NoteDetail]  TO CresBsViewer_role
	GRANT SELECT ON [dbo].[View_NoteInterest] TO CresBsViewer_role

	---==========================================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'RohitAdmin_user')
		DROP USER RohitAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'RohitAdmin_role')
		DROP ROLE  RohitAdmin_role

	CREATE USER RohitAdmin_user FROM LOGIN RohitAdmin;
	CREATE ROLE  RohitAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'RohitAdmin_role', 'RohitAdmin_user';
	ALTER ROLE db_owner Add Member RohitAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'VishalAdmin_user')
		DROP USER VishalAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'VishalAdmin_role')
		DROP ROLE  VishalAdmin_role


	CREATE USER VishalAdmin_user FROM LOGIN VishalAdmin;
	CREATE ROLE  VishalAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'VishalAdmin_role', 'VishalAdmin_user';
	ALTER ROLE db_owner Add Member VishalAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'KrishnaAdmin_user')
		DROP USER KrishnaAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'KrishnaAdmin_role')
		DROP ROLE  KrishnaAdmin_role


	CREATE USER KrishnaAdmin_user FROM LOGIN KrishnaAdmin;
	CREATE ROLE  KrishnaAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'KrishnaAdmin_role', 'KrishnaAdmin_user';
	ALTER ROLE db_owner Add Member KrishnaAdmin_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ValuationQA_User')
		DROP USER ValuationQA_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'ValuationQA_role')
		DROP ROLE  ValuationQA_role

	CREATE USER ValuationQA_User FROM LOGIN ValuationQA;
	CREATE ROLE  ValuationQA_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'ValuationQA_role', 'ValuationQA_User';
	ALTER ROLE db_owner Add Member ValuationQA_role

	---=================================================
	---CREATE LOGIN M61DBReader  WITH password='EhuvWuP)9h})W[W';

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'M61DBReader_user')
		DROP USER M61DBReader_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'M61DBReader_role')
		DROP ROLE  M61DBReader_role

	CREATE USER M61DBReader_user FROM LOGIN M61DBReader;
	CREATE ROLE  M61DBReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'M61DBReader_role', 'M61DBReader_user';
	ALTER ROLE db_datareader Add Member M61DBReader_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Reader_Swapna_user')
		DROP USER CRES4_Reader_Swapna_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Reader_Swapna_role')
		DROP ROLE  CRES4_Reader_Swapna_role

	CREATE USER CRES4_Reader_Swapna_user FROM LOGIN CRES4_Reader_Swapna;
	CREATE ROLE  CRES4_Reader_Swapna_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Reader_Swapna_role', 'CRES4_Reader_Swapna_user';
	ALTER ROLE db_datareader Add Member CRES4_Reader_Swapna_role


	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_Int_user')
		DROP USER CresReader_Int_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_Int_role')
		DROP ROLE  CresReader_Int_role

	CREATE USER CresReader_Int_user FROM LOGIN CresReader_Int;
	CREATE ROLE  CresReader_Int_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_Int_role', 'CresReader_Int_user';
	ALTER ROLE db_datareader Add Member CresReader_Int_role


END

IF(@CurrentDBName = @DBName_Staging)
BEGIN
    Print('Create Staging users')
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'BIViewerUser')
	DROP USER BIViewerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Acore_BIViewer')
		DROP ROLE  Acore_BIViewer

	CREATE USER BIViewerUser FROM LOGIN BIViewer;
	CREATE ROLE  Acore_BIViewer AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Acore_BIViewer', 'BIViewerUser';
	ALTER ROLE db_owner Add Member Acore_BIViewer

	---=========================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'Cres4_stag_user')
		DROP USER Cres4_stag_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Cres4_stag_role')
		DROP ROLE  Cres4_stag_role

	CREATE USER Cres4_stag_user FROM LOGIN Cres4_staging;
	CREATE ROLE  Cres4_stag_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Cres4_stag_role', 'Cres4_stag_user';
	ALTER ROLE db_owner Add Member Cres4_stag_role
	---=========================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESAccountingUser')
		DROP USER CRESAccountingUser
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESAccounting_Role')
		DROP ROLE  CRESAccounting_Role

	CREATE USER CRESAccountingUser FROM LOGIN CRESAccounting;
	CREATE ROLE  CRESAccounting_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESAccounting_Role', 'CRESAccountingUser';
	GRANT SELECT ON [DealEquityAmount] TO CRESAccounting_Role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_user')
		DROP USER CresReader_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_role')
		DROP ROLE  CresReader_role

	CREATE USER CresReader_user FROM LOGIN CresReader;
	CREATE ROLE  CresReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_role', 'CresReader_user';
	ALTER ROLE db_datareader Add Member CresReader_role

	--======================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUser')
		DROP USER sizerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_Modify')
		DROP ROLE  sizer_Modify
	
	CREATE USER sizerUser FROM LOGIN Sizer;
	CREATE ROLE  sizer_Modify AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_Modify', 'sizerUser';
	ALTER ROLE db_owner Add Member sizer_Modify
	--================================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'RohitAdmin_user')
		DROP USER RohitAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'RohitAdmin_role')
		DROP ROLE  RohitAdmin_role

	CREATE USER RohitAdmin_user FROM LOGIN RohitAdmin;
	CREATE ROLE  RohitAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'RohitAdmin_role', 'RohitAdmin_user';
	ALTER ROLE db_owner Add Member RohitAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'VishalAdmin_user')
		DROP USER VishalAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'VishalAdmin_role')
		DROP ROLE  VishalAdmin_role


	CREATE USER VishalAdmin_user FROM LOGIN VishalAdmin;
	CREATE ROLE  VishalAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'VishalAdmin_role', 'VishalAdmin_user';
	ALTER ROLE db_owner Add Member VishalAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'KrishnaAdmin_user')
		DROP USER KrishnaAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'KrishnaAdmin_role')
		DROP ROLE  KrishnaAdmin_role


	CREATE USER KrishnaAdmin_user FROM LOGIN KrishnaAdmin;
	CREATE ROLE  KrishnaAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'KrishnaAdmin_role', 'KrishnaAdmin_user';
	ALTER ROLE db_owner Add Member KrishnaAdmin_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ValuationQA_User')
		DROP USER ValuationQA_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'ValuationQA_role')
		DROP ROLE  ValuationQA_role

	CREATE USER ValuationQA_User FROM LOGIN ValuationQA;
	CREATE ROLE  ValuationQA_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'ValuationQA_role', 'ValuationQA_User';
	ALTER ROLE db_owner Add Member ValuationQA_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Reader_Swapna_user')
		DROP USER CRES4_Reader_Swapna_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Reader_Swapna_role')
		DROP ROLE  CRES4_Reader_Swapna_role

	CREATE USER CRES4_Reader_Swapna_user FROM LOGIN CRES4_Reader_Swapna;
	CREATE ROLE  CRES4_Reader_Swapna_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Reader_Swapna_role', 'CRES4_Reader_Swapna_user';
	ALTER ROLE db_datareader Add Member CRES4_Reader_Swapna_role


	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUserStaging')
	DROP USER sizerUserStaging
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_ModifyStaging')
		DROP ROLE  sizer_ModifyStaging

	CREATE USER sizerUserStaging FROM LOGIN SizerStaging;
	CREATE ROLE  sizer_ModifyStaging AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_ModifyStaging', 'sizerUserStaging';
	ALTER ROLE db_owner Add Member sizer_ModifyStaging
END

IF(@CurrentDBName = @DBName_Dev)
BEGIN
	Print('Create Dev users')
	

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'BIViewerUser')
		DROP USER BIViewerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Acore_BIViewer')
		DROP ROLE  Acore_BIViewer

	CREATE USER BIViewerUser FROM LOGIN BIViewer;
	CREATE ROLE  Acore_BIViewer AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Acore_BIViewer', 'BIViewerUser';
	ALTER ROLE db_owner Add Member Acore_BIViewer
	---=========================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'Cres4_dev_user')
		DROP USER Cres4_dev_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Cres4_dev_role')
		DROP ROLE  Cres4_dev_role

	CREATE USER Cres4_dev_user FROM LOGIN Cres4_dev;
	CREATE ROLE  Cres4_dev_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Cres4_dev_role', 'Cres4_dev_user';
	ALTER ROLE db_owner Add Member Cres4_dev_role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESAccountingUser')
		DROP USER CRESAccountingUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESAccounting_Role')
		DROP ROLE  CRESAccounting_Role

	CREATE USER CRESAccountingUser FROM LOGIN CRESAccounting;
	CREATE ROLE  CRESAccounting_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESAccounting_Role', 'CRESAccountingUser';
	GRANT SELECT ON [DealEquityAmount] TO CRESAccounting_Role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_user')
		DROP USER CresReader_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_role')
		DROP ROLE  CresReader_role

	CREATE USER CresReader_user FROM LOGIN CresReader;
	CREATE ROLE  CresReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_role', 'CresReader_user';
	ALTER ROLE db_datareader Add Member CresReader_role

	--======================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_DEV_user')
		DROP USER CresReader_DEV_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_DEV_role')
		DROP ROLE  CresReader_DEV_role

	CREATE USER CresReader_DEV_user FROM LOGIN CresReader_DEV;
	CREATE ROLE  CresReader_DEV_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_DEV_role', 'CresReader_DEV_user';
	ALTER ROLE db_datareader Add Member CresReader_DEV_role
	--======================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUser')
		DROP USER sizerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_Modify')
		DROP ROLE  sizer_Modify

	CREATE USER sizerUser FROM LOGIN Sizer;
	CREATE ROLE  sizer_Modify AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_Modify', 'sizerUser';
	ALTER ROLE db_owner Add Member sizer_Modify
	--=================================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'RohitAdmin_user')
		DROP USER RohitAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'RohitAdmin_role')
		DROP ROLE  RohitAdmin_role

	CREATE USER RohitAdmin_user FROM LOGIN RohitAdmin;
	CREATE ROLE  RohitAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'RohitAdmin_role', 'RohitAdmin_user';
	ALTER ROLE db_owner Add Member RohitAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'VishalAdmin_user')
		DROP USER VishalAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'VishalAdmin_role')
		DROP ROLE  VishalAdmin_role


	CREATE USER VishalAdmin_user FROM LOGIN VishalAdmin;
	CREATE ROLE  VishalAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'VishalAdmin_role', 'VishalAdmin_user';
	ALTER ROLE db_owner Add Member VishalAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'KrishnaAdmin_user')
		DROP USER KrishnaAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'KrishnaAdmin_role')
		DROP ROLE  KrishnaAdmin_role


	CREATE USER KrishnaAdmin_user FROM LOGIN KrishnaAdmin;
	CREATE ROLE  KrishnaAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'KrishnaAdmin_role', 'KrishnaAdmin_user';
	ALTER ROLE db_owner Add Member KrishnaAdmin_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ValuationQA_User')
		DROP USER ValuationQA_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'ValuationQA_role')
		DROP ROLE  ValuationQA_role

	CREATE USER ValuationQA_User FROM LOGIN ValuationQA;
	CREATE ROLE  ValuationQA_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'ValuationQA_role', 'ValuationQA_User';
	ALTER ROLE db_owner Add Member ValuationQA_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Reader_Swapna_user')
		DROP USER CRES4_Reader_Swapna_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Reader_Swapna_role')
		DROP ROLE  CRES4_Reader_Swapna_role

	CREATE USER CRES4_Reader_Swapna_user FROM LOGIN CRES4_Reader_Swapna;
	CREATE ROLE  CRES4_Reader_Swapna_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Reader_Swapna_role', 'CRES4_Reader_Swapna_user';
	ALTER ROLE db_datareader Add Member CRES4_Reader_Swapna_role

END

IF(@CurrentDBName = @DBName_PIKMode)
BEGIN
	Print('Create PIK Mode users')
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'BIViewerUser')
		DROP USER BIViewerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Acore_BIViewer')
		DROP ROLE  Acore_BIViewer

	CREATE USER BIViewerUser FROM LOGIN BIViewer;
	CREATE ROLE  Acore_BIViewer AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Acore_BIViewer', 'BIViewerUser';
	ALTER ROLE db_owner Add Member Acore_BIViewer
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESPIKModeUser')
		DROP USER CRESPIKModeUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESPIKMode_Role')
		DROP ROLE  CRESPIKMode_Role

	CREATE USER CRESPIKModeUser FROM LOGIN CRESPIKMode;
	CREATE ROLE  CRESPIKMode_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESPIKMode_Role', 'CRESPIKModeUser';
	ALTER ROLE db_owner Add Member CRESPIKMode_Role
	---=========================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESAccountingUser')
		DROP USER CRESAccountingUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESAccounting_Role')
		DROP ROLE  CRESAccounting_Role

	CREATE USER CRESAccountingUser FROM LOGIN CRESAccounting;
	CREATE ROLE  CRESAccounting_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESAccounting_Role', 'CRESAccountingUser';
	GRANT SELECT ON [DealEquityAmount] TO CRESAccounting_Role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_user')
		DROP USER CresReader_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_role')
		DROP ROLE  CresReader_role

	CREATE USER CresReader_user FROM LOGIN CresReader;
	CREATE ROLE  CresReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_role', 'CresReader_user';
	ALTER ROLE db_datareader Add Member CresReader_role

	--======================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUser')
		DROP USER sizerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_Modify')
		DROP ROLE  sizer_Modify

	CREATE USER sizerUser FROM LOGIN Sizer;
	CREATE ROLE  sizer_Modify AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_Modify', 'sizerUser';
	ALTER ROLE db_owner Add Member sizer_Modify
	--==========================================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'RohitAdmin_user')
		DROP USER RohitAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'RohitAdmin_role')
		DROP ROLE  RohitAdmin_role

	CREATE USER RohitAdmin_user FROM LOGIN RohitAdmin;
	CREATE ROLE  RohitAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'RohitAdmin_role', 'RohitAdmin_user';
	ALTER ROLE db_owner Add Member RohitAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'VishalAdmin_user')
		DROP USER VishalAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'VishalAdmin_role')
		DROP ROLE  VishalAdmin_role


	CREATE USER VishalAdmin_user FROM LOGIN VishalAdmin;
	CREATE ROLE  VishalAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'VishalAdmin_role', 'VishalAdmin_user';
	ALTER ROLE db_owner Add Member VishalAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'KrishnaAdmin_user')
		DROP USER KrishnaAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'KrishnaAdmin_role')
		DROP ROLE  KrishnaAdmin_role


	CREATE USER KrishnaAdmin_user FROM LOGIN KrishnaAdmin;
	CREATE ROLE  KrishnaAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'KrishnaAdmin_role', 'KrishnaAdmin_user';
	ALTER ROLE db_owner Add Member KrishnaAdmin_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ValuationQA_User')
		DROP USER ValuationQA_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'ValuationQA_role')
		DROP ROLE  ValuationQA_role

	CREATE USER ValuationQA_User FROM LOGIN ValuationQA;
	CREATE ROLE  ValuationQA_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'ValuationQA_role', 'ValuationQA_User';
	ALTER ROLE db_owner Add Member ValuationQA_role

		---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Reader_Swapna_user')
		DROP USER CRES4_Reader_Swapna_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Reader_Swapna_role')
		DROP ROLE  CRES4_Reader_Swapna_role

	CREATE USER CRES4_Reader_Swapna_user FROM LOGIN CRES4_Reader_Swapna;
	CREATE ROLE  CRES4_Reader_Swapna_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Reader_Swapna_role', 'CRES4_Reader_Swapna_user';
	ALTER ROLE db_datareader Add Member CRES4_Reader_Swapna_role
END


IF(@CurrentDBName = @DBName_Demo)
BEGIN
	Print('Create Demo users')
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'BIViewerUser')
		DROP USER BIViewerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Acore_BIViewer')
		DROP ROLE  Acore_BIViewer

	CREATE USER BIViewerUser FROM LOGIN BIViewer;
	CREATE ROLE  Acore_BIViewer AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Acore_BIViewer', 'BIViewerUser';
	ALTER ROLE db_owner Add Member Acore_BIViewer
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'Cres4_Demo_user')
		DROP USER Cres4_Demo_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'Cres4_Demo_role')
		DROP ROLE  Cres4_Demo_role

	CREATE USER Cres4_Demo_user FROM LOGIN Cres4_Demo;
	CREATE ROLE  Cres4_Demo_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'Cres4_Demo_role', 'Cres4_Demo_user';
	ALTER ROLE db_owner Add Member Cres4_Demo_role
	---=========================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRESAccountingUser')
		DROP USER CRESAccountingUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRESAccounting_Role')
		DROP ROLE  CRESAccounting_Role

	CREATE USER CRESAccountingUser FROM LOGIN CRESAccounting;
	CREATE ROLE  CRESAccounting_Role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRESAccounting_Role', 'CRESAccountingUser';
	GRANT SELECT ON [DealEquityAmount] TO CRESAccounting_Role
	---=========================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CresReader_user')
		DROP USER CresReader_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CresReader_role')
		DROP ROLE  CresReader_role

	CREATE USER CresReader_user FROM LOGIN CresReader;
	CREATE ROLE  CresReader_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CresReader_role', 'CresReader_user';
	ALTER ROLE db_datareader Add Member CresReader_role

	--======================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'sizerUser')
		DROP USER sizerUser 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'sizer_Modify')
		DROP ROLE  sizer_Modify

	CREATE USER sizerUser FROM LOGIN Sizer;
	CREATE ROLE  sizer_Modify AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'sizer_Modify', 'sizerUser';
	ALTER ROLE db_owner Add Member sizer_Modify
	---================================================

	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'RohitAdmin_user')
		DROP USER RohitAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'RohitAdmin_role')
		DROP ROLE  RohitAdmin_role

	CREATE USER RohitAdmin_user FROM LOGIN RohitAdmin;
	CREATE ROLE  RohitAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'RohitAdmin_role', 'RohitAdmin_user';
	ALTER ROLE db_owner Add Member RohitAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'VishalAdmin_user')
		DROP USER VishalAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'VishalAdmin_role')
		DROP ROLE  VishalAdmin_role


	CREATE USER VishalAdmin_user FROM LOGIN VishalAdmin;
	CREATE ROLE  VishalAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'VishalAdmin_role', 'VishalAdmin_user';
	ALTER ROLE db_owner Add Member VishalAdmin_role
	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'KrishnaAdmin_user')
		DROP USER KrishnaAdmin_user
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'KrishnaAdmin_role')
		DROP ROLE  KrishnaAdmin_role


	CREATE USER KrishnaAdmin_user FROM LOGIN KrishnaAdmin;
	CREATE ROLE  KrishnaAdmin_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'KrishnaAdmin_role', 'KrishnaAdmin_user';
	ALTER ROLE db_owner Add Member KrishnaAdmin_role

	---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'ValuationQA_User')
		DROP USER ValuationQA_User 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'ValuationQA_role')
		DROP ROLE  ValuationQA_role

	CREATE USER ValuationQA_User FROM LOGIN ValuationQA;
	CREATE ROLE  ValuationQA_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'ValuationQA_role', 'ValuationQA_User';
	ALTER ROLE db_owner Add Member ValuationQA_role

		---========================================================================================================================
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'S' AND [name] = N'CRES4_Reader_Swapna_user')
		DROP USER CRES4_Reader_Swapna_user 
	IF EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [type] = N'R' AND [name] = N'CRES4_Reader_Swapna_role')
		DROP ROLE  CRES4_Reader_Swapna_role

	CREATE USER CRES4_Reader_Swapna_user FROM LOGIN CRES4_Reader_Swapna;
	CREATE ROLE  CRES4_Reader_Swapna_role AUTHORIZATION [dbo]
	EXEC sp_addrolemember 'CRES4_Reader_Swapna_role', 'CRES4_Reader_Swapna_user';
	ALTER ROLE db_datareader Add Member CRES4_Reader_Swapna_role
  
END
---================================================================
IF(@CurrentDBName = @DBName_QA OR @CurrentDBName = @DBName_Integration OR @CurrentDBName = @DBName_Staging OR @CurrentDBName = @DBName_Dev OR @CurrentDBName = @DBName_Alpha OR @CurrentDBName = @DBName_PIKMode OR @CurrentDBName = @DBName_Demo)  
BEGIN

--==Elastic query start==============================================
Print('Elastic query set up for: Import cres production data in cres integration')
IF(1 = 1)
BEGIN
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_TransactionEntry')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_TransactionEntry]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_NotePeriodicCalc')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_NotePeriodicCalc]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_Account')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_Account]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_Note')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_Note]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_Event')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_Event]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_FundingSchedule')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_FundingSchedule]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_DealFunding')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_DealFunding]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_Deal')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_Deal] 
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_Indexes')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_Indexes] 
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_HoliDays')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_HoliDays]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_Analysis')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_Analysis]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_WFTaskDetail')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskDetail]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_WFTaskDetailArchive')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskDetailArchive]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_WFCheckListDetail')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_WFCheckListDetail] 
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_WFTaskAdditionalDetail')
	DROP EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskAdditionalDetail]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_WFNotification')
	Drop EXTERNAL TABLE [dbo].[Ex_Prod_WFNotification]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Prod_NoteTransactionDetail')
	Drop EXTERNAL TABLE [dbo].[Ex_Prod_NoteTransactionDetail]

IF EXISTS(select [name] from sys.external_data_sources where name = 'RemoteReferenceCRESProduction')
	Drop EXTERNAL DATA SOURCE RemoteReferenceCRESProduction 
IF EXISTS(select [name] from sys.database_scoped_credentials where name = 'CredentialCRESProduction')
	Drop DATABASE SCOPED CREDENTIAL CredentialCRESProduction


--CREATE DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL CredentialCRESProduction  WITH IDENTITY = 'AcoreProd',  SECRET = 'rB^`6eB3LsbX=Fx'

--CREATE EXTERNAL DATA SOURCE
Create EXTERNAL DATA SOURCE RemoteReferenceCRESProduction
WITH 
( 
    TYPE=RDBMS, 
    LOCATION='tcp:b0xesubcki.database.windows.net,1433', 
    DATABASE_NAME='CRES4_Acore', 
    CREDENTIAL= CredentialCRESProduction 
); 


CREATE EXTERNAL TABLE [dbo].[Ex_Prod_NoteTransactionDetail] (
NoteTransactionDetailID	uniqueidentifier  NOT NULL ,
NoteID uniqueidentifier  NOT NULL,
TransactionDate date  null,
TransactionType int  null,
Amount decimal(28,15) null,
RelatedtoModeledPMTDate date  null,
ModeledPayment decimal(28,15),
AmountOutstandingafterCurrentPayment decimal(28,15),
ServicingAmount Decimal(28,15) NULL,
CalculatedAmount Decimal(28,15) NULL,
Delta Decimal(28,15) NULL,
M61Value bit ,
ServicerValue bit ,
Ignore bit ,
OverrideValue Decimal(28,15) NULL,
comments nvarchar(max) NULL,
PostedDate Datetime,
ServicerMasterID int NULL,
Deleted bit ,
CreatedBy      	nvarchar(256) NULL,
CreatedDate      	datetime NULL,
UpdatedBy      	nvarchar(256) NULL,
UpdatedDate      	datetime NULL,

TransactionTypeText nvarchar(256) NULL,

TranscationReconciliationID uniqueidentifier  NULL ,
RemittanceDate [Datetime] NULL,
Exception nvarchar(256) null,
Adjustment Decimal(28,15) NULL,
ActualDelta Decimal(28,15) NULL,
OverrideReason int null,
NoteTransactionDetailAutoID int not null,
BerAddlint Decimal(28,15) NULL ,
TransactionEntryAmount decimal(28,15) null,
Orig_ServicerMasterID int NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'NoteTransactionDetail'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Account] (
	[AccountID] [uniqueidentifier] NOT NULL,
	[AccountTypeID] [int] NULL,
	[StatusID] [int] NULL,
	[Name] [varchar](256) NULL,	
	[BaseCurrencyID] [int] NULL,
	[PayFrequency] [int] NULL,
	[ClientNoteID] [nvarchar](256) NULL,	
	[IsDeleted] [bit] NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CORE',
	   Object_Name = 'Account'
);


-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Note] (
	--[NoteID] [uniqueidentifier] NOT NULL,
	--[Account_AccountID] [uniqueidentifier] NOT NULL,
	--[DealID] [uniqueidentifier] NOT NULL,
	--[CRENoteID] [nvarchar](256) NULL,
	--[ClientNoteID] [nvarchar](256) NULL,
	NoteID	uniqueidentifier  NOT NULL,
	Account_AccountID	uniqueidentifier 	   NOT NULL,
	DealID	uniqueidentifier 	   NOT NULL,
	CRENoteID	nvarchar(256)	    NULL,
	ClientNoteID	nvarchar(256)	    NULL,
	Comments	nvarchar(256)	    NULL,
	InitialInterestAccrualEndDate	date	    NULL,
	AccrualFrequency	int	    NULL,
	DeterminationDateLeadDays	int	    NULL,
	DeterminationDateReferenceDayoftheMonth	int	    NULL,
	DeterminationDateInterestAccrualPeriod	int	    NULL,
	DeterminationDateHolidayList	Int	    NULL,
	FirstPaymentDate	date	    NULL,
	InitialMonthEndPMTDateBiWeekly	date	    NULL,
	PaymentDateBusinessDayLag	int	    NULL,
	IOTerm	int	    NULL,
	AmortTerm	int	    NULL,
	PIKSeparateCompounding	int	    NULL,
	MonthlyDSOverridewhenAmortizing	decimal(28,15)	    NULL,
	AccrualPeriodPaymentDayWhenNotEOMonth	int	    NULL,
	FirstPeriodInterestPaymentOverride	decimal(28,15)	    NULL,
	FirstPeriodPrincipalPaymentOverride	decimal(28,15)	    NULL,
	FinalInterestAccrualEndDateOverride	date	    NULL,
	AmortType	int	    NULL,
	RateType	Int	    NULL,
	ReAmortizeMonthly	Int	    NULL,
	ReAmortizeatPMTReset	Int	    NULL,
	StubPaidInArrears	Int	    NULL,
	RelativePaymentMonth	Int	    NULL,
	SettleWithAccrualFlag	Int	    NULL,
	InterestDueAtMaturity	int	    NULL,
	RateIndexResetFreq	decimal(28,15)	    NULL,
	FirstRateIndexResetDate	date	    NULL,
	LoanPurchase	Int	    NULL,
	AmortIntCalcDayCount	int	    NULL,
	StubPaidinAdvanceYN	Int	    NULL,
	FullPeriodInterestDueatMaturity	Int	    NULL,
	ProspectiveAccountingMode	Int	    NULL,
	IsCapitalized	Int	    NULL,
	SelectedMaturityDateScenario	int	    NULL,
	SelectedMaturityDate	date	    NULL,
	InitialMaturityDate	date	    NULL,
	ExpectedMaturityDate	date	    NULL,

	OpenPrepaymentDate	date	    NULL,
	CashflowEngineID	int	    NULL,
	LoanType	Int	    NULL,
	Classification	Int	    NULL,
	SubClassification	Int	    NULL,
	GAAPDesignation	Int	    NULL,
	PortfolioID	int	    NULL,
	GeographicLocation	Int	    NULL,
	PropertyType	Int	    NULL,
	RatingAgency	int	    NULL,
	RiskRating	int	    NULL,
	PurchasePrice	decimal(28,15)	    NULL,
	FutureFeesUsedforLevelYeild	decimal(28,15)	    NULL,
	TotalToBeAmortized	decimal(28,15)	    NULL,
	StubPeriodInterest	decimal(28,15)	    NULL,
	WDPAssetMultiple	decimal(28,15)	    NULL,
	WDPEquityMultiple	decimal(28,15)	    NULL,
	PurchaseBalance	decimal(28,15)	    NULL,
	DaysofAccrued	int	    NULL,
	InterestRate	decimal(28,15)	    NULL,
	PurchasedInterestCalc	decimal(28,15)	    NULL,
	ModelFinancingDrawsForFutureFundings	int	    NULL,
	NumberOfBusinessDaysLagForFinancingDraw	int	    NULL,
	FinancingFacilityID	uniqueidentifier	    NULL,
	FinancingInitialMaturityDate	date	    NULL,
	FinancingExtendedMaturityDate	date	    NULL,
	FinancingPayFrequency	Int	    NULL,
	FinancingInterestPaymentDay	int	    NULL,
	ClosingDate	date	    NULL,
	InitialFundingAmount	decimal(28,15)	    NULL,
	Discount	decimal(28,15)	    NULL,
	OriginationFee	decimal(28,15)	    NULL,
	CapitalizedClosingCosts	decimal(28,15)	    NULL,
	PurchaseDate	date	    NULL,
	PurchaseAccruedFromDate	decimal(28,15)	    NULL,
	PurchasedInterestOverride	decimal(28,15)	    NULL,
	DiscountRate decimal(28,15)	    NULL,
	ValuationDate date	    NULL,
	FairValue decimal(28,15)	    NULL,
	DiscountRatePlus decimal(28,15)	    NULL,
	FairValuePlus decimal(28,15)	    NULL,
	DiscountRateMinus decimal(28,15)	    NULL,
	FairValueMinus decimal(28,15)	    NULL,
	InitialIndexValueOverride decimal(28,15)	    NULL,
	IncludeServicingPaymentOverrideinLevelYield int null,
	OngoingAnnualizedServicingFee	decimal(28,15)	    NULL,
	IndexRoundingRule int  NULL,
	RoundingMethod int NULL,
	StubInterestPaidonFutureAdvances int NULL,
	TaxAmortCheck [nvarchar](256) NULL,
	PIKWoCompCheck [nvarchar](256) NULL,
	GAAPAmortCheck [nvarchar](256) NULL,
	StubIntOverride decimal(28,15)	    NULL,
	PurchasedIntOverride decimal(28,15)	    NULL,
	ExitFeeFreePrepayAmt decimal(28,15)	    NULL,
	ExitFeeBaseAmountOverride decimal(28,15)	    NULL,
	ExitFeeAmortCheck int	    NULL,
	FixedAmortScheduleCheck int null,				
	GeneratedBy      	Int,
	--PayRule
	UseRuletoDetermineNoteFunding int null,
	NoteFundingRule int null,
	FundingPriority int null,
	NoteBalanceCap decimal(28,15)	 NULL,
	RepaymentPriority int null,
	NoofdaysrelPaymentDaterollnextpaymentcycle int null,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL, 
	UseIndexOverrides bit null,
	IndexNameID int null,
	ServicerID nvarchar(256)	    NULL,
	TotalCommitment decimal(28,15)	 NULL,
	ClientName nvarchar(256) null ,
	Portfolio nvarchar(256) null ,
	Tag1 nvarchar(256) null ,
	Tag2 nvarchar(256) null ,
	Tag3 nvarchar(256) null ,
	Tag4 nvarchar(256) null ,
	ExtendedMaturityScenario1	date	    NULL,
	ExtendedMaturityScenario2	date	    NULL,
	ExtendedMaturityScenario3	date	    NULL,
	ActualPayoffDate	date	    NULL,
	FullyExtendedMaturityDate 	date	    NULL,
	TotalCommitmentExtensionFeeisBasedOn decimal(28,15)	 NULL,
	LienPriority  int ,
	UnusedFeeThresholdBalance  decimal(28,15)	 NULL,
	UnusedFeePaymentFrequency int null,
	lienposition int null ,
	[priority] int null,
	Servicer int null,
	FullInterestAtPPayoff int ,
	NoteRule nvarchar(2000) null,

	ClientID int null,
	FinancingSourceID int null,
	DebtTypeID int null,
	BillingNotesID int null,
	CapStack  int null,
	FundID  int null,
	PoolId int null,

	--Added column for wells
	TaxVendorLoanNumber	nvarchar(256)	null,
	TAXBILLSTATUS	nvarchar(256)	null,
	CURRTAXCONSTANT	int	null,
	InsuranceBillStatusCode	nvarchar(256)	null,
	RESERVETYPE	nvarchar(256)	null,
	ResDescOwnName	nvarchar(256)	null,
	MONTHLYPAYMENTAMT	int	null,
	IORPLANCODE	nvarchar(256)	null,
	NoDaysbeforeAssessment	decimal(28,15)	null,
	LateChargeRateorFee	decimal(28,15)	null,
	DefaultOfDaysto	decimal(28,15)	null,
	OddDaysIntAmount decimal(28,15) null,
	InterestRateFloor decimal(28,15) null,
	InterestRateCeiling decimal(28,15) null,
	Dayslookback nvarchar(256)  NULL,
	CurrentBls decimal(28,15) null,
	WF_Companyname	nvarchar(256)	null,
	WF_FirstName	nvarchar(256)	null,
	WF_Lastname	nvarchar(256)	null,
	WF_StreetName	nvarchar(256)	null,
	WF_ZipCodePostal	nvarchar(256)	null,
	WF_PayeeName	nvarchar(256)	null,
	WF_TelephoneNumber1	nvarchar(256)	null,
	WF_FederalID1	nvarchar(max)	null,
	WF_City	nvarchar(256)	null,
	WF_State	nvarchar(256)	null,
	StubInterestRateOverride decimal(28,15) null,
	LiborDataAsofDate datetime	    NULL,
	ServicerNameID int null,
	BusinessdaylafrelativetoPMTDate int null,
	DayoftheMonth int null,
	InterestCalculationRuleForPaydowns int null,
	PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate int null
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'Note'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Event] (
	EventID uniqueidentifier   NULL ,
	AccountID uniqueidentifier   NULL,
	Date date   NULL,
	EventTypeID int   NULL,
	EffectiveStartDate date   NULL,
	EffectiveEndDate date   NULL,
	SingleEventValue decimal(28,15)   NULL,
	[StatusID] int null,
	CreatedBy      	nvarchar(256)  NULL,
	CreatedDate      	datetime NULL,
	UpdatedBy      	nvarchar(256) NULL,
	UpdatedDate      	datetime
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CORE',
	   Object_Name = 'EVENT'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_FundingSchedule] (
	FundingScheduleID	uniqueidentifier   NULL,
	EventId	uniqueidentifier  null,
	Date	date null,
	Value	decimal(28,15)null,
	PurposeID int null,
	Applied bit null,
	CreatedBy  nvarchar(256) null,
	CreatedDate   datetime null,
	UpdatedBy   nvarchar(256) null,
	UpdatedDate    datetime null,
	DrawFundingId nvarchar(256) null,
	Comments nvarchar(max) null,
	Issaved	bit null,
	DealFundingRowno	int null,
	DealFundingID	UNIQUEIDENTIFIER null,
	WF_CurrentStatus nvarchar(256) null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CORE',
	   Object_Name = 'FundingSchedule'
);

-----------------------------------------------


CREATE EXTERNAL TABLE [dbo].[Ex_Prod_DealFunding] (
	DealFundingID uniqueidentifier   NULL ,
	DealID uniqueidentifier   NULL,
	[Date] date null,
	Amount decimal(28,15) null,
	Comment nvarchar(max),
	PurposeID int null,
	Applied bit null,
	Issaved bit null ,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL,
	DrawFundingId nvarchar(256) null,
	DealFundingRowno	int null,
	DeadLineDate	date null,
	LegalDeal_DealFundingID	UNIQUEIDENTIFIER null,
	EquityAmount	decimal(28,15) null,
	RemainingFFCommitment	decimal(28,15) null,
	RemainingEquityCommitment	decimal(28,15) null,
	SubPurposeType nvarchar(256)


)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'DealFunding'
);
-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Deal] (
DealID uniqueidentifier   NULL ,
DealName      	nvarchar(256),
CREDealID	nvarchar(256),
SourceDealID uniqueidentifier,
DealType      	Int,
LoanProgram	Int,
LoanPurpose      	Int,
Status      	Int,
AppReceived      	date,
EstClosingDate      	date,
BorrowerRequest      	nvarchar(256),
RecommendedLoan      	decimal(28,15),
TotalFutureFunding      	decimal(28,15),
Source      	Int,
BrokerageFirm      	nvarchar(256),
BrokerageContact      	nvarchar(256),
Sponsor      	nvarchar(256),
Principal      	nvarchar(256),
NetWorth      	decimal(28,15),
Liquidity      	decimal(28,15),
ClientDealID	nvarchar(256),
GeneratedBy      	Int,
TotalCommitment decimal (28,15),
AdjustedTotalCommitment   decimal (28,15),
AggregatedTotal    decimal (28,15),
AssetManagerComment nvarchar(max),
[DealComment] [nvarchar](max) NULL,
AssetManager nvarchar(256),
DealCity nvarchar(256),
DealState nvarchar(256),
DealPropertyType nvarchar(256),
FullyExtMaturityDate date,
UnderwritingStatus int null,
LinkedDealID  nvarchar(256) null,
IsDeleted bit null ,
AllowSizerUpload int null,
CreatedBy      	nvarchar(256),
CreatedDate      	datetime,
UpdatedBy      	nvarchar(256),
UpdatedDate      	datetime,
AMUserID uniqueidentifier null,
DealRule nvarchar(2000) null,
AMTeamLeadUserID uniqueidentifier null,
AMSecondUserID uniqueidentifier null
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'Deal'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_TransactionEntry] (
	[TransactionEntryID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NULL,
	[Date] [datetime] NULL,
	[Amount] [decimal](28, 15) NULL,
	[Type] nvarchar(MAX) null,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,

	AnalysisID uniqueidentifier null,
	FeeName nvarchar(256) null,
	StrCreatedBy 	nvarchar(256) NULL,
	GeneratedBy 	nvarchar(256) NULL,
	TransactionDateByRule	date null,
TransactionDateServicingLog	 date null,
RemitDate date null
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'TransactionEntry'
);
-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_NotePeriodicCalc] (
[NotePeriodicCalcID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NULL,
	[PeriodEndDate] [date] NULL,
	[Month] [int] NULL,
	[ActualCashFlows] [decimal](28, 15) NULL,
	[GAAPCashFlows] [decimal](28, 15) NULL,
	[EndingGAAPBookValue] [decimal](28, 15) NULL,
	--[TotalGAAPIncomeforthePeriod] [decimal](28, 15) NULL,
	--[InterestAccrualforthePeriod] [decimal](28, 15) NULL,
	--[PIKInterestAccrualforthePeriod] [decimal](28, 15) NULL,
	[TotalAmortAccrualForPeriod] [decimal](28, 15) NULL,
	[AccumulatedAmort] [decimal](28, 15) NULL,
	[BeginningBalance] [decimal](28, 15) NULL,
	[TotalFutureAdvancesForThePeriod] [decimal](28, 15) NULL,
	[TotalDiscretionaryCurtailmentsforthePeriod] [decimal](28, 15) NULL,
	[InterestPaidOnPaymentDate] [decimal](28, 15) NULL,
	[TotalCouponStrippedforthePeriod] [decimal](28, 15) NULL,
	[CouponStrippedonPaymentDate] [decimal](28, 15) NULL,
	[ScheduledPrincipal] [decimal](28, 15) NULL,
	[PrincipalPaid] [decimal](28, 15) NULL,
	[BalloonPayment] [decimal](28, 15) NULL,
	[EndingBalance] [decimal](28, 15) NULL,
	[ExitFeeIncludedInLevelYield] [decimal](28, 15) NULL,
	[ExitFeeExcludedFromLevelYield] [decimal](28, 15) NULL,
	[AdditionalFeesIncludedInLevelYield] [decimal](28, 15) NULL,
	[AdditionalFeesExcludedFromLevelYield] [decimal](28, 15) NULL,
	[OriginationFeeStripping] [decimal](28, 15) NULL,
	[ExitFeeStrippingIncldinLevelYield] [decimal](28, 15) NULL,
	[ExitFeeStrippingExcldfromLevelYield] [decimal](28, 15) NULL,
	[AddlFeesStrippingIncldinLevelYield] [decimal](28, 15) NULL,
	[AddlFeesStrippingExcldfromLevelYield] [decimal](28, 15) NULL,
	[EndOfPeriodWAL] [decimal](28, 15) NULL,
	[PIKInterestFromPIKSourceNote] [decimal](28, 15) NULL,
	[PIKInterestTransferredToRelatedNote] [decimal](28, 15) NULL,
	[PIKInterestForThePeriod] [decimal](28, 15) NULL,
	[BeginningPIKBalanceNotInsideLoanBalance] [decimal](28, 15) NULL,
	[PIKInterestForPeriodNotInsideLoanBalance] [decimal](28, 15) NULL,
	[PIKBalanceBalloonPayment] [decimal](28, 15) NULL,
	[EndingPIKBalanceNotInsideLoanBalance] [decimal](28, 15) NULL,
	[CostBasis] [decimal](28, 15) NULL,
	[PreCapBasis] [decimal](28, 15) NULL,
	[BasisCap] [decimal](28, 15) NULL,
	[AmortAccrualLevelYield] [decimal](28, 15) NULL,
	[ScheduledPrincipalShortfall] [decimal](28, 15) NULL,
	[PrincipalShortfall] [decimal](28, 15) NULL,
	[PrincipalLoss] [decimal](28, 15) NULL,
	[InterestForPeriodShortfall] [decimal](28, 15) NULL,
	[InterestPaidOnPMTDateShortfall] [decimal](28, 15) NULL,
	[CumulativeInterestPaidOnPMTDateShortfall] [decimal](28, 15) NULL,
	[InterestShortfallLoss] [decimal](28, 15) NULL,
	[InterestShortfallRecovery] [decimal](28, 15) NULL,
	[BeginningFinancingBalance] [decimal](28, 15) NULL,
	[TotalFinancingDrawsCurtailmentsForPeriod] [decimal](28, 15) NULL,
	[FinancingBalloon] [decimal](28, 15) NULL,
	[EndingFinancingBalance] [decimal](28, 15) NULL,
	[FinancingInterestPaid] [decimal](28, 15) NULL,
	[FinancingFeesPaid] [decimal](28, 15) NULL,
	[PeriodLeveredYield] [decimal](28, 15) NULL,
	[OrigFeeAccrual] [decimal](28, 15) NULL,
	[DiscountPremiumAccrual] [decimal](28, 15) NULL,
	[ExitFeeAccrual] [decimal](28, 15) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[AllInCouponRate] [decimal](28, 15) NULL,

	[CleanCost] [decimal](28, 15) NULL,	
	[GrossDeferredFees] [decimal](28, 15) NULL,
	[DeferredFeesReceivable] [decimal](28, 15) NULL,
	[CleanCostPrice] [decimal](28, 15) NULL,
	[AmortizedCostPrice] [decimal](28, 15) NULL,
	[AdditionalFeeAccrual] [decimal](28, 15) NULL,
	[CapitalizedCostAccrual] [decimal](28, 15) NULL,
	[DailySpreadInterestbeforeStrippingRule] [decimal](28, 15) NULL,
	[DailyLiborInterestbeforeStrippingRule] [decimal](28, 15) NULL,
	[ReversalofPriorInterestAccrual] [decimal](28, 15) NULL,
	[InterestReceivedinCurrentPeriod] [decimal](28, 15) NULL,
	[CurrentPeriodInterestAccrual] [decimal](28, 15) NULL,
	[TotalGAAPInterestFortheCurrentPeriod] [decimal](28, 15) NULL,

	InvestmentBasis decimal(28,15) null,
	--CurrentPeriodInterestAccrualPeriodEnddate  [decimal](28, 15) NULL, 
	LIBORPercentage  [decimal](28, 15) NULL,
	SpreadPercentage  [decimal](28, 15) NULL,
	AnalysisID UNIQUEIDENTIFIER null,
	FeeStrippedforthePeriod [decimal](28, 15) NULL,
	PIKInterestPercentage [decimal](28, 15) NULL,
	AmortizedCost [decimal](28, 15) NULL,
	InterestSuspenseAccountActivityforthePeriod decimal(28,15) null,
	InterestSuspenseAccountBalance  decimal(28,15) null
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction ,
	   Schema_Name = 'CRE',
	   Object_Name = 'NotePeriodicCalc'
);

--==================

CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Indexes] (
	[IndexesId] [uniqueidentifier] NOT NULL,
	[AnalysisID] [uniqueidentifier] NULL,
	[Date] [date] NULL,
	[IndexType] [int] NULL,
	[Value] [decimal](28, 15) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CORE',
	   Object_Name = 'Indexes'
);

--==================

CREATE EXTERNAL TABLE [dbo].[Ex_Prod_HoliDays] (
	[HoliDayDate] [date] NOT NULL,
	[HoliDayTypeID] [int] NOT NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'APP',
	   Object_Name = 'HoliDays'
);

CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Analysis] (
	
	AnalysisID uniqueidentifier  NOT NULL,
	[Name] varchar(256)  NULL,
	StatusID int  NULL,
	Description varchar(256)   NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ScenarioColor] [nvarchar](256) NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'Core',
	   Object_Name = 'Analysis'
);

--===========Work Flow========


CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskDetail] (	
	WFTaskDetailID [int] NOT NULL,
	WFStatusPurposeMappingID  int   NULL,
	TaskID   nvarchar(MAX)	    NULL,
	TaskTypeID  int   NULL, 
	Comment    nvarchar(MAX)	    NULL,
	SubmitType int null,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL,
	IsDeleted bit not null 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'WFTaskDetail'
);
 
CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskDetailArchive] (	
WFTaskDetailArchiveID [int] NOT NULL,
WFTaskDetailID int null,
WFStatusPurposeMappingID  int   NULL,
TaskID   nvarchar(MAX)	    NULL,
TaskTypeID  int   NULL, 
Comment    nvarchar(MAX)	    NULL,
SubmitType int null,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL,
IsDeleted bit not null 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'WFTaskDetailArchive'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFCheckListDetail] (	
WFCheckListDetailID [int] NOT NULL,
TaskId nvarchar(MAX) NULL,
WFCheckListMasterID int null,
CheckListName nvarchar(256)	    NULL,
CheckListStatus  int null,
Comment  	nvarchar(MAX)	    NULL,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'WFCheckListDetail'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskAdditionalDetail] (	
WFTaskAdditionalDetailID [int]  NOT NULL,
TaskID nvarchar(MAX)	    NULL,
SpecialInstruction nvarchar(MAX)	    NULL,
AdditionalComment nvarchar(MAX)	    NULL,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'WFTaskAdditionalDetail'
);



CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFNotification] (	
[WFNotificationID] [int] NOT NULL,
[WFNotificationGuID] [uniqueidentifier] NOT NULL,
[WFNotificationMasterID] [int] NULL,
[TaskID] [uniqueidentifier]  NULL,
[MessageHTML] [nvarchar](max) NULL,
[ScheduledDateTime] [datetime] NULL,
[ActionType] [int] NULL,
AdditionalText nvarchar(256) null,
[CreatedBy] [nvarchar](256) NULL,
[CreatedDate] [datetime] NULL,
[UpdatedBy] [nvarchar](256) NULL,
[UpdatedDate] [datetime] NULL,
[NotificationType] [nvarchar](256) NULL,
[MessageData] [nvarchar](max) NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESProduction,
	   Schema_Name = 'CRE',
	   Object_Name = 'WFNotification'
);
--==================
--================================================
END


Print('Elastic query set up for: Import backshop production data (Deal/Note) in cres')
IF(1 = 1)
BEGIN
IF EXISTS(select name from sys.external_tables where name = 'tblControlMaster')
	DROP EXTERNAL TABLE [dbo].[tblControlMaster]
IF EXISTS(select name from sys.external_tables where name = 'tblBorrower')
	DROP EXTERNAL TABLE [dbo].[tblBorrower]
IF EXISTS(select name from sys.external_tables where name = 'tblEscrow')
	DROP EXTERNAL TABLE [dbo].[tblEscrow]
IF EXISTS(select name from sys.external_tables where name = 'tblPrepayment')
	DROP EXTERNAL TABLE [dbo].[tblPrepayment]
IF EXISTS(select name from sys.external_tables where name = 'tblNoteExp')
	DROP EXTERNAL TABLE [dbo].[tblNoteExp]
IF EXISTS(select name from sys.external_tables where name = 'tblProperty')
	DROP EXTERNAL TABLE [dbo].[tblProperty]
IF EXISTS(select name from sys.external_tables where name = 'tblContact')
	DROP EXTERNAL TABLE [dbo].[tblContact]
IF EXISTS(select name from sys.external_tables where name = 'tblPropertyExp')
	DROP EXTERNAL TABLE [tblPropertyExp]
IF EXISTS(select name from sys.external_tables where name = 'tblzCdPropertyCondition')
	DROP EXTERNAL TABLE [tblzCdPropertyCondition]
IF EXISTS(select name from sys.external_tables where name = 'tblNote')
	DROP EXTERNAL TABLE [tblNote]
IF EXISTS(select name from sys.external_tables where name = 'tblBorrowerOwnershipHierarchy')
	DROP EXTERNAL TABLE [dbo].[tblBorrowerOwnershipHierarchy]
IF EXISTS(select name from sys.external_tables where name = 'tblGroundLease')
	DROP EXTERNAL TABLE [dbo].[tblGroundLease]
IF EXISTS(select name from sys.external_tables where name = 'tblzCdPropertyTypeMajor')
	DROP EXTERNAL TABLE [dbo].[tblzCdPropertyTypeMajor]
IF EXISTS(select name from sys.external_tables where name = 'tblzCdEscrowStatus')
	DROP EXTERNAL TABLE [dbo].tblzCdEscrowStatus
IF EXISTS(select name from sys.external_tables where name = 'tblzCdAcoreServicingFeeSchedule')
	Drop EXTERNAL TABLE [dbo].tblzCdAcoreServicingFeeSchedule  
IF EXISTS(select name from sys.external_tables where name = 'Ex_BS_tblNote')
	Drop EXTERNAL TABLE [dbo].[Ex_BS_tblNote]
IF EXISTS(select name from sys.external_tables where name = 'tblNoteARM')
	Drop EXTERNAL TABLE [dbo].[tblNoteARM]

IF EXISTS(select [name] from sys.external_data_sources where name = 'RemoteReferenceData')
	Drop EXTERNAL DATA SOURCE RemoteReferenceData 
IF EXISTS(select [name] from sys.database_scoped_credentials where name = 'CredentialAcore')
	Drop DATABASE SCOPED CREDENTIAL CredentialAcore
--DROP MASTER KEY

--CREATE MASTER KEY
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'admin123*';

--CREATE DATABASE SCOPED CREDENTIAL (Login: ACOREBackshopReader,pass: 2@chazuzEv&J)
CREATE DATABASE SCOPED CREDENTIAL CredentialAcore  WITH IDENTITY = 'ACOREAccounting',  SECRET = '25t30239urong24ep21h!jfekzkj*)^'

--CREATE EXTERNAL DATA SOURCE
Create EXTERNAL DATA SOURCE RemoteReferenceData 
WITH 
( 
    TYPE=RDBMS, 
    LOCATION='acore-sql-backshop-dev.database.windows.net', 
    DATABASE_NAME='BackshopQA', 
    CREDENTIAL= CredentialAcore 
); 

CREATE EXTERNAL TABLE [dbo].[Ex_BS_tblNote] (
	[NoteId] int NOT NULL,
	[ControlId_F] nvarchar(10)  NOT NULL ,
	[NoteName] nvarchar(60)  NOT NULL ,
	[FirstPIPaymentDate] datetime  NULL ,
	[StubAmortBalanceAmt] float  NULL ,
	[OrigLoanAmount] money  NULL  
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblnote'
);


CREATE EXTERNAL TABLE [dbo].[tblNoteARM] (
	[NoteId_F] int  NOT NULL ,
	[DeterminationMethodDay] nvarchar(2)  NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblNoteARM'
);

CREATE EXTERNAL TABLE [dbo].[tblControlMaster] (
	[ControlId] nvarchar(10)  NOT NULL ,
	[DealName] nvarchar(75)  NOT NULL ,
	[DealBorrowerContact1_ContactId_F] int  NULL ,
	[Sponsor_OrgId_F] int  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);

CREATE EXTERNAL TABLE [dbo].[tblBorrower] (
 [BorrowerId] int  NULL ,
[BorrowerTypeCd_F] nvarchar(3)  NULL ,
[LastNameOrOrgName] nvarchar(100)  NULL ,
[FirstName] nvarchar(15)  NULL ,
[LastNameOrOrgNameContinued] nvarchar(100)  NULL ,
[StreetAddress] nvarchar(50)  NULL ,
[City] nvarchar(25)  NULL ,
[State] nvarchar(2)  NULL ,
[Country] nvarchar(50)  NULL ,
[Zip] nvarchar(15)  NULL ,
[PhoneNumber] nvarchar(20)  NULL ,
[TaxId] nvarchar(100)  NULL ,

[NetWorth] money  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);

CREATE EXTERNAL TABLE [dbo].[tblEscrow] (
 [EscrowId] int  NULL ,
  [ControlMasterId_F] nvarchar(10)  NULL ,
  [NoteId_F] int  NULL ,
  [PropertyId_F] int  NULL ,
  [EscrowTypeCode] nvarchar(50)  NULL ,
  [EscrowTypeDesc] nvarchar(50)  NULL ,
  [InitialBalance] money  NULL ,
  [CurrentBalance] money  NULL ,
  [MonthlyBalance] money  NULL ,
  [PledgedToLender] nvarchar(3)  NULL ,
  [BalanceAsOfDate] datetime  NULL ,
  [ReserveType] nvarchar(40)  NULL ,
  [SortOrder] int  NULL ,
  --[Comment] ntext(max)  NULL ,
  [AuditAddDate] datetime  NULL ,
  [AuditAddUserId] nvarchar(150)  NULL ,
  [AuditUpdateDate] datetime  NULL ,
  [AuditUpdateUserId] nvarchar(150)  NULL ,
  [EscrowStatus] nvarchar(20)  NULL ,
  [EscrowCap] money  NULL ,
  [InterestEarnedCredited] nvarchar(40)  NULL ,
  [EscrowLock] bit  NULL ,
  [ReserveBalanceAtContribution] money  NULL ,
  [EscrowDisbursement] money  NULL ,
  [LOCExpirationDate] datetime  NULL ,
  [EscrowAccountNumber] nvarchar(50)  NULL ,

  [EscrowDueDate] datetime  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);

CREATE EXTERNAL TABLE [dbo].[tblPrepayment] (
	[PrepaymentId_NoteId_F] int  NULL ,
	[GracePeriod] int  NULL ,
	[LateFee] float  NULL ,
	[MonetaryDefaultDays] int  NULL ,
	DefaultRate float  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);


CREATE EXTERNAL TABLE [dbo].[tblNoteExp] (
[NoteExpId] int  NULL ,
[NoteId_F] int  NOT NULL ,
[ServicerLoanNumber] nvarchar(20)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);


CREATE EXTERNAL TABLE [dbo].[tblProperty] (
[PropertyId] int  NULL ,
[ControlId_F] nvarchar(10)  NULL ,
[BorrowerId_F] int  NULL ,
[PropertyNumber] nvarchar(20)  NULL ,
[PropertyName] nvarchar(100)  NULL ,
[PropertyTypeMajorCd_F] nvarchar(3)  NULL ,
[PropertyTypeMinorCd_F] nvarchar(3)  NULL ,
[StreetAddress] nvarchar(150)  NULL ,
[City] nvarchar(50)  NULL ,
[State] nvarchar(10)  NULL ,
[ZipCode] nvarchar(15)  NULL ,
[County] nvarchar(50)  NULL ,
[Country] nvarchar(50)  NULL ,
[PercentOwnOcc] float  NULL ,
[AcquisitionAmount] money  NULL ,
[YearBuilt] int  NULL ,
[NumberOfStories] int  NULL ,
[UnitMeasurePrimary] nvarchar(10)  NULL ,
[NumberOfUnitsPrimary] int  NULL ,
[NRSFPrimary] int  NULL ,
[YearRenovated] int  NULL ,
[InspectionDate] datetime  NULL ,
[DealAllocationAmt] money  NULL ,
[LienPosition] nvarchar(25)  NULL ,
[DealAllocationAmtPCT] float  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);



CREATE EXTERNAL TABLE [dbo].[tblContact] (
  [ContactID] int  NULL ,
  [OrganizationID_F] int  NOT NULL ,
  [FirstName] nvarchar(50)  NOT NULL ,
  [LastName] nvarchar(50)  NOT NULL ,
  [AddressID_F] int  NULL ,
  [HomeAddressID_F] int  NULL ,
  [BusinessPhone] nvarchar(50)  NULL ,
  [BusinessPhoneExt] nvarchar(10)  NULL ,
  [HomePhone] nvarchar(50)  NULL ,
  [Mobile] nvarchar(50)  NULL ,
  [Fax] nvarchar(50)  NULL ,
  [Pager] nvarchar(50)  NULL ,
  [IPPhone] nvarchar(50)  NULL ,
  [IMUserName] nvarchar(50)  NULL ,
  [EmailAddress] nvarchar(128)  NULL ,
  [WebsiteURL] nvarchar(128)  NULL ,
  [DateofBirth] datetime  NULL ,
  [Initials] nvarchar(10)  NULL ,
  [Title] nvarchar(50)  NULL ,
  [IsDeleted] bit  NULL ,
  [Tier] tinyint  NULL ,
  [Ranking] tinyint  NULL ,
  [Anniversary] datetime  NULL ,
  [SpouseName] nvarchar(50)  NULL ,
  [ChildrenName] nvarchar(50)  NULL ,
  [OptOutFromEmail] bit  NULL ,
  [AuditAddDate] datetime  NOT NULL ,
  [AuditUpdateDate] datetime  NULL ,
  [AuditAddUserId] nvarchar(150)  NULL ,
  [AuditUpdateUserId] nvarchar(150)  NULL ,
  [UseOrgAddressSw] bit  NULL ,
  [FormOfAddress] nvarchar(10)  NULL ,
  [AssistantName] nvarchar(50)  NULL ,
  [Department] nvarchar(50)  NULL ,
  [MismoPartyID] bigint  NULL ,
  [IsPrimary] bit  NULL ,
  [OfficerId] nvarchar(30)  NULL ,
  [Comments] nvarchar(max)  NULL ,
  [ClientIdentifier] nvarchar(200)  NULL ,
  [GenderCode] int  NULL ,
  [Salution] nvarchar(50)  NULL ,
  [AddressName] nvarchar(50)  NULL ,
  [AssistantPhone] nvarchar(50)  NULL ,
  [PersonalFax] nvarchar(50)  NULL ,
  [EmailAddress2] nvarchar(128)  NULL ,
  [EmailAddress3] nvarchar(128)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);



CREATE EXTERNAL TABLE [dbo].[tblPropertyExp] (
  [PropertyExpId] int  NULL ,
  [PropertyId_F] int  NOT NULL ,
  [PropertyConditionCd_F] nvarchar(10)  NULL ,
  [NumOfTenants] int  NULL ,
   [PropertyRollUpSW] bit  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);



CREATE EXTERNAL TABLE [dbo].[tblzCdPropertyCondition] (
	[PropertyConditionCd] nvarchar(10)  NOT NULL ,
	[PropertyConditionDesc] nvarchar(50)  NULL ,
	[OrderKey] int  NULL ,
	[InactiveSw] bit  NOT NULL ,
	[AuditAddDate] datetime  NOT NULL ,
	[AuditAddUserId] nvarchar(150)  NULL ,
	[AuditUpdateDate] datetime  NOT NULL ,
	[AuditUpdateUserId] nvarchar(150)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);



CREATE EXTERNAL TABLE  [dbo].[tblNote] (
  [NoteId] int NULL ,
  [ControlId_F] nvarchar(10)  NOT NULL ,
  [PrimaryDebtFlag] nvarchar(3)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);


CREATE EXTERNAL TABLE [dbo].[tblBorrowerOwnershipHierarchy] (
  [BorrowerOwnershipHierarchyId] int  NULL ,
  [NoteId_F] int  NULL ,
  [ParentBorrowerId_F] int  NOT NULL ,
  [ChildBorrowerId_F] int  NULL ,
  [OwnershipPct] float  NULL , 
  [PrimarySponsorSW] bit  NULL 
 
  )
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);


CREATE EXTERNAL TABLE [dbo].[tblGroundLease]  (
  [GroundLeaseId] int  NULL ,
  [PropertyId_F] int  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);


CREATE EXTERNAL TABLE [dbo].[tblzCdPropertyTypeMajor]  (
  [PropertyTypeMajorCd] nvarchar(3)   NULL ,
  [PropertyTypeMajorDesc] nvarchar(25)  NULL ,
   [UAH_VacancyFactor] float  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);



CREATE EXTERNAL TABLE [dbo].tblzCdEscrowStatus  (
  [EscrowStatusCD] nvarchar(3)   NULL ,
  [EscrowStatusDesc] nvarchar(50)  NULL ,
  [OrderKey] int  NULL ,
  [InactiveSw] bit  NOT NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData 
);




CREATE EXTERNAL TABLE [dbo].tblzCdAcoreServicingFeeSchedule  (
  [AcoreServicingFeeScheduleId] int  NULL ,
  [InvestorId] int  NULL ,
  [MinimumBalance] money  NOT NULL ,
  [MaximumBalance] money  NOT NULL ,
  [FeePct] float  NOT NULL ,
  [AuditAddDate] datetime  NOT NULL ,
  [AuditAddUserid] nvarchar(150)  NOT NULL ,
  [AuditUpdateDate] datetime  NULL ,
  [AuditUpdateUserid] nvarchar(150)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData ,
	   Schema_Name = 'ACORE',
	   Object_Name = 'tblzCdAcoreServicingFeeSchedule'
);

END


--================================================
Print('Elastic query set up for: Import/export FF data from/to backshop')
IF(1 = 1)
BEGIN
IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'spNoteFundingsGet')
	Drop PROCEDURE dbo.spNoteFundingsGet
IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'sp_NoteFundingsDeleteByNoteId')
	Drop PROCEDURE  dbo.sp_NoteFundingsDeleteByNoteId
IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'spNoteFundingsSave')
	Drop PROCEDURE  dbo.spNoteFundingsSave
IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'sp_NoteFundingsDeleteByNoteIdPIK')
	Drop PROCEDURE  dbo.sp_NoteFundingsDeleteByNoteIdPIK

IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'spNoteProjectedPaymentDeleteByNoteId')
	Drop PROCEDURE  dbo.spNoteProjectedPaymentDeleteByNoteId
IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'spNoteProjectedPaymentSave')
	Drop PROCEDURE  dbo.spNoteProjectedPaymentSave

IF EXISTS(select [name] from sys.external_data_sources where name = 'RemoteReferenceDataFF')
	Drop EXTERNAL DATA SOURCE RemoteReferenceDataFF 

IF EXISTS(select [name] from sys.database_scoped_credentials where name = 'CredentialAcoreFF')
	Drop DATABASE SCOPED CREDENTIAL CredentialAcoreFF

--CREATE DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL CredentialAcoreFF  WITH IDENTITY = 'ACOREAccounting',  SECRET = '25t30239urong24ep21h!jfekzkj*)^'

--CREATE EXTERNAL DATA SOURCE
Create EXTERNAL DATA SOURCE RemoteReferenceDataFF 
WITH 
( 
    TYPE=RDBMS, 
    LOCATION='acore-sql-backshop-dev.database.windows.net', 
    DATABASE_NAME='BackshopQA', 
    CREDENTIAL= CredentialAcoreFF 
); 


exec('
CREATE PROCEDURE dbo.spNoteFundingsGet
    @FundingId int,
	@NoteId_F int,
	@Applied bit
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N''RemoteReferenceDataFF'', 
@stmt = N''dbo.spNoteFundingsGet @FundingId, @NoteId_F, @Applied'', 
@params = N''@FundingId int,@NoteId_F int,@Applied bit'',
@FundingId = @FundingId, @NoteId_F = @NoteId_F,@Applied=@Applied

END
')

exec('
CREATE PROCEDURE dbo.sp_NoteFundingsDeleteByNoteId
    @NoteId int
	
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N''RemoteReferenceDataFF'', 
@stmt = N''acore.sp_NoteFundingsDeleteByNoteId @NoteId'', 
@params = N''@NoteId int'',
@NoteId = @NoteId

END
')

exec('
CREATE PROCEDURE dbo.sp_NoteFundingsDeleteByNoteIdPIK
    @NoteId int	
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N''RemoteReferenceDataFF'', 
@stmt = N''acore.sp_NoteFundingsDeleteByNoteIdPIK @NoteId'', 
@params = N''@NoteId int'',
@NoteId = @NoteId

END')


exec('
CREATE PROCEDURE dbo.spNoteFundingsSave
	@FundingID int,
	@NoteId_F int,
	@Applied bit,
	@FundingDate DateTime,
	@FundingAmount decimal(28,12),
	@Comments nvarchar(max),
	@FundingPurposeCD_F nvarchar(max),
	@FundingDrawId  nvarchar(max),
	@FundingExpense  decimal(28,12),
	@ExpenseComments  nvarchar(max),
	@WireConfirm bit,
	@AuditUserName nvarchar(max),
	@Status nvarchar(256),
	@NoteFundingReasonCD_F nvarchar(10),
	@GeneratedBy nvarchar(255)

AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N''RemoteReferenceDataFF'', 
@stmt = N''dbo.spNoteFundingsSave @FundingID,
@NoteId_F,
@Applied,
@FundingDate,
@FundingAmount,
@Comments,
@FundingPurposeCD_F,
@FundingDrawId,
@FundingExpense,
@ExpenseComments,
@WireConfirm,
@AuditUserName,
@Status,
@NoteFundingReasonCD_F,
@GeneratedBy
'', 
@params = N''@FundingID int,
	@NoteId_F int,
	@Applied bit,
	@FundingDate DateTime,
	@FundingAmount decimal(28,12),
	@Comments nvarchar(max),
	@FundingPurposeCD_F nvarchar(max),
	@FundingDrawId  nvarchar(max),
	@FundingExpense  decimal(28,12),
	@ExpenseComments  nvarchar(max),
	@WireConfirm bit,
	@AuditUserName nvarchar(max),
	@Status nvarchar(256),
	@NoteFundingReasonCD_F nvarchar(10),
	@GeneratedBy nvarchar(255)'',

@FundingID  = @FundingID ,
@NoteId_F  = @NoteId_F ,
@Applied  = @Applied ,
@FundingDate  = @FundingDate ,
@FundingAmount  = @FundingAmount ,
@Comments  = @Comments ,
@FundingPurposeCD_F  = @FundingPurposeCD_F ,
@FundingDrawId  = @FundingDrawId ,
@FundingExpense  = @FundingExpense ,
@ExpenseComments  = @ExpenseComments ,
@WireConfirm  = @WireConfirm ,
@AuditUserName  = @AuditUserName,
@Status  = @Status,
@NoteFundingReasonCD_F = @NoteFundingReasonCD_F,
@GeneratedBy = @GeneratedBy

END')



---projected prepayment
exec('
CREATE PROCEDURE dbo.spNoteProjectedPaymentDeleteByNoteId
    @NoteId int
	
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N''RemoteReferenceDataFF'', 
@stmt = N''acore.spNoteProjectedPaymentDeleteByNoteId @NoteId'', 
@params = N''@NoteId int'',
@NoteId = @NoteId

END
')




exec('
CREATE PROCEDURE dbo.spNoteProjectedPaymentSave
	@ProjectedPaymentId int,
	@NoteId_F int,	
	@PaymentDate DateTime,
	@Amount decimal(28,12),
	@FundingPurposeCD_F nvarchar(max),	
	@Comments nvarchar(max),
	@InactiveSw bit,
	@SortOrder int,
	@AuditUserName nvarchar(max),
	@GeneratedBy nvarchar(255)
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N''RemoteReferenceDataFF'', 
@stmt = N''acore.spNoteProjectedPaymentSave @ProjectedPaymentId,
@NoteId_F,	
@PaymentDate,
@Amount,
@FundingPurposeCD_F,	
@Comments,
@InactiveSw,
@SortOrder,
@AuditUserName,
@GeneratedBy
'', 
@params = N''@ProjectedPaymentId int,
	@NoteId_F int,	
	@PaymentDate DateTime,
	@Amount decimal(28,12),
	@FundingPurposeCD_F nvarchar(max),	
	@Comments nvarchar(max),
	@InactiveSw bit,
	@SortOrder int,
	@AuditUserName nvarchar(max),
	@GeneratedBy nvarchar(255)'',

@ProjectedPaymentId = @ProjectedPaymentId,
@NoteId_F = @NoteId_F,
@PaymentDate = @PaymentDate,
@Amount = @Amount,
@FundingPurposeCD_F = @FundingPurposeCD_F,
@Comments = @Comments,
@InactiveSw = @InactiveSw,
@SortOrder = @SortOrder,
@AuditUserName = @AuditUserName,
@GeneratedBy = @GeneratedBy


END')

END


Print('Elastic query set up for: get backshop production data for Reconcilation HUB')
IF(1 = 1)
BEGIN	

IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblControlMaster')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblControlMaster]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblNote')
	DROP EXTERNAL TABLE [EX_RH_tblNote]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzcdFinancingSource')
	DROP EXTERNAL TABLE [EX_RH_tblzcdFinancingSource]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzCdRateType')
	DROP EXTERNAL TABLE [EX_RH_tblzCdRateType]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzCdLienPosition')
	DROP EXTERNAL TABLE [EX_RH_tblzCdLienPosition]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_viewNote')
	DROP EXTERNAL TABLE [dbo].[EX_RH_viewNote]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_vw_AcctNoteExt')
	DROP EXTERNAL TABLE [dbo].[EX_RH_vw_AcctNoteExt]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_vw_AcctNote')
	DROP EXTERNAL TABLE [dbo].[EX_RH_vw_AcctNote]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblNoteFunding')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblNoteFunding]

IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzCdPropertyTypeMajor')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblzCdPropertyTypeMajor]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzCdCollateralStatus')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblzCdCollateralStatus]	
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblDealHistory')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblDealHistory]	
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblProperty')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblProperty]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzCDZipCode')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblzCDZipCode]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblStatusLog')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblStatusLog]
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblPropertyExp')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblPropertyExp] 
IF EXISTS(select name from sys.external_tables where name = 'EX_RH_tblzCdLoanStatus')
	DROP EXTERNAL TABLE [dbo].[EX_RH_tblzCdLoanStatus] 

IF EXISTS(select [name] from sys.external_data_sources where name = 'RemoteReferenceData_ReconHub')
	Drop EXTERNAL DATA SOURCE RemoteReferenceData_ReconHub 
IF EXISTS(select [name] from sys.database_scoped_credentials where name = 'CredentialBSProd')
	Drop DATABASE SCOPED CREDENTIAL CredentialBSProd

--DROP MASTER KEY

--CREATE MASTER KEY
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'admin123*';

--CREATE DATABASE SCOPED CREDENTIAL (Login: ACOREBackshopReader,pass: 2@chazuzEv&J)
CREATE DATABASE SCOPED CREDENTIAL CredentialBSProd  WITH IDENTITY = 'ACOREAccounting',  SECRET = '25t30239urong24ep21h!jfekzkj*)^'

--CREATE EXTERNAL DATA SOURCE
Create EXTERNAL DATA SOURCE RemoteReferenceData_ReconHub 
WITH 
( 
    TYPE=RDBMS, 
    LOCATION='acore-sql-backshop-dev.database.windows.net', 
    DATABASE_NAME='BackshopQA', 
    CREDENTIAL= CredentialBSProd 
); 


CREATE EXTERNAL TABLE [dbo].[EX_RH_tblControlMaster] (
	[ControlId] nvarchar(10)  NOT NULL ,
	[DealName] nvarchar(75)  NOT NULL ,
	[DealBorrowerContact1_ContactId_F] int  NULL ,
	[Sponsor_OrgId_F] int  NULL ,
	[REITPropertyTypeCd_F] nvarchar(10)  NULL ,
	[CollateralStatusCd_F] nvarchar(10)  NULL ,
	[LoanStatusCd_F] nvarchar(1)  NULL 
)
WITH 
( 
        DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblControlMaster'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_tblNote] (
	[NoteId] int NOT NULL,
	[ControlId_F] nvarchar(10)  NOT NULL ,
	[NoteName] nvarchar(60)  NOT NULL ,
	[RateTypeCd_F] nvarchar(1)  NULL ,
	[LienPositionCd_F] nvarchar(1)  NULL ,
	[FinancingSource] nvarchar(50)  NULL ,
	[Priority] int  NULL ,
	[FundingDate] datetime  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblnote'
);


CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzcdFinancingSource] (
	[FinancingSourceCD] nvarchar(50)  NOT NULL ,
	[FinancingSourceDesc] nvarchar(50)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblzcdFinancingSource'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzCdRateType] (
	[RateTypeCode] nvarchar(1)  NOT NULL ,
	[RateTypeDesc] nvarchar(100)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblzCdRateType'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzCdLienPosition] (
	[LienPositionCd] nvarchar(1)  NOT NULL ,
	[LienPositionDesc] nvarchar(20)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblzCdLienPosition'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_viewNote] (
	[NoteId] int NOT NULL,
	[OrigLoanAmount] money  NULL ,
	[CommitmentAdjustment] money  NULL ,
	[Priority] int  NULL ,
	[LoanTerm] int  NULL ,
	[IndexName] nvarchar(20)  NULL ,
	[InterestSpread] float  NULL ,
	[InterestRateFloorPct] float  NULL ,
	[OriginationFeePct] float  NULL ,
	[StatedMaturityDate] datetime  NULL ,
	AmortIOPeriod int  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'viewNote'
);


CREATE EXTERNAL TABLE [dbo].[EX_RH_vw_AcctNoteExt] (
	[ControlId] nvarchar(10)  NOT NULL ,
	[NoteId_F] int  NULL ,
	[NoteExtensionId] int  NOT NULL ,
	[ExtStatedMaturityDate] datetime  NULL ,
	[ExecutedSw] bit  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'acore',
	   Object_Name = 'vw_AcctNoteExt'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_vw_AcctNote] (
	[ControlId] nvarchar(10)  NOT NULL ,
	[NoteId] int  NOT NULL ,
	[NoteName] nvarchar(60)  NOT NULL ,
	[FundingDate] datetime  NULL ,
	[TotalCommitment] money  NULL ,
	[TotalCurrentAdjustedCommitment] decimal(34,4)  NULL ,
	[Current UPB] float  NULL ,
	[FirstPIPaymentDate] datetime  NULL ,
	[StatedMaturityDate] datetime  NULL ,
	[OrigLoanAmount] money  NULL ,
	[OriginationFee] money  NULL ,
	[LiborFloor] float  NULL ,
	[OriginationFeePct] float  NULL ,
	[InterestSpread] float  NULL ,
	[AmortIOPeriod] int  NULL ,
	[AmortizationTerm] int  NULL ,
	[PaymentFreqCd_F] int  NULL ,
	[PaymentFreqDesc] nvarchar(15)  NULL ,
	[IntCalcMethodDesc] nvarchar(15)  NULL ,
	[LienPosition] nvarchar(20)  NULL ,
	[Priority] int  NULL ,
	[AccrualRate] float  NULL ,
	[DeterminationMethodDay] nvarchar(2)  NULL ,
	[DeterminationDate] nvarchar(2)  NULL ,
	[RoundingType] nvarchar(20)  NULL ,
	[RoundingDenominator] int  NULL ,
	[FinancingSourceDesc] nvarchar(50)  NULL ,
	[InvestorName] nvarchar(128)  NULL ,
	[Servicer] nvarchar(255)  NULL ,
	[Fund] nvarchar(50)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'acore',
	   Object_Name = 'vw_AcctNote'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_tblNoteFunding] (
	[Noteid_F] int  NOT NULL ,
	[Applied] bit  NULL ,
	[FundingDate] datetime  NULL ,
	[FundingAmount] money  NULL ,
	[FundingPurposeCD_F] nvarchar(10)  NULL ,
	[WireConfirm] bit  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblNoteFunding'
);


CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzCdPropertyTypeMajor] (
	[PropertyTypeMajorCd] nvarchar(3)  NOT NULL ,
	[PropertyTypeMajorDesc] nvarchar(25)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblzCdPropertyTypeMajor'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzCdCollateralStatus] (
	[CollateralStatusCD] nvarchar(10)  NOT NULL ,
	[CollateralStatusDesc] nvarchar(100)  NOT NULL ,
	[OrderKey] int  NULL ,
	[InactiveSw] bit  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'acore',
	   Object_Name = 'tblzCdCollateralStatus'
);



CREATE EXTERNAL TABLE [dbo].[EX_RH_tblDealHistory] (	 
  [ControlId_F] nvarchar(10)  NOT NULL ,
  [TableName] nvarchar(120)  NOT NULL ,
  [TableId] nvarchar(10)  NOT NULL ,
  [StatusDate] datetime  NOT NULL ,
  [ColumnName] nvarchar(120)  NOT NULL ,
  [ColumnValue] nvarchar(120)  NOT NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'acore',
	   Object_Name = 'tblDealHistory'
);



CREATE EXTERNAL TABLE [dbo].[EX_RH_tblProperty] (	 
	[PropertyId] int  NOT NULL ,
	[ControlId_F] nvarchar(10)  NULL ,
	[PropertyNumber] nvarchar(20)  NULL ,
	[PropertyName] nvarchar(100)  NULL ,
	[PropertyTypeMajorCd_F] nvarchar(3)  NULL ,
	[PropertyTypeMinorCd_F] nvarchar(3)  NULL ,
	[SecondaryPropTypeMajCd_F] nvarchar(3)  NULL ,	
	[StreetAddress] nvarchar(150)  NULL ,
	[City] nvarchar(50)  NULL ,
	[State] nvarchar(10)  NULL ,
	[ZipCode] nvarchar(15)  NULL ,
	[County] nvarchar(50)  NULL ,
	[Country] nvarchar(50)  NULL ,
	[DealAllocationAmt] money  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblProperty'
);



CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzCDZipCode] (	 
	[ZIP_CODE] nvarchar(5)  NOT NULL ,
	[CITY] nvarchar(35)  NULL ,
	[STATE] nvarchar(2)  NULL ,
	[AREA_CODE] nvarchar(3)  NULL ,	  
	[COUNTY_NAME] nvarchar(25)  NULL ,	  
	[MSA_NAME] nvarchar(100)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblzCDZipCode'
);



CREATE EXTERNAL TABLE [dbo].[EX_RH_tblStatusLog] (	 
	[StatusLogId] int   NOT NULL ,
  [ControlId_F] nvarchar(10)  NOT NULL ,
  [LoanStatusCd_F] nvarchar(1)  NOT NULL ,
  [StatusStartDate] datetime  NULL ,
  [StatusEndDate] datetime  NULL ,
  [StatusLogUserFullName] nvarchar(50)  NULL ,
  [AuditAddUserId] nvarchar(150)  NULL ,
  [StatusUpdateDate] datetime  NULL ,
  [LoanStatusReasonCd_F] nvarchar(5)  NULL ,
  [LoanSubStatusCd_F] nvarchar(1)  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblStatusLog'
);

CREATE EXTERNAL TABLE [dbo].[EX_RH_tblPropertyExp] (	 
	 [PropertyId_F] int  NOT NULL ,
	 [PropertyRollupTypeId_F] int  NULL 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblPropertyExp'
);
 
CREATE EXTERNAL TABLE [dbo].[EX_RH_tblzCdLoanStatus] (	 
	[LoanStatusCd] nvarchar(1)  NOT NULL ,
	[LoanStatusDesc] nvarchar(40)  NULL ,
	[OrderKey] int  NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceData_ReconHub ,
	   Schema_Name = 'dbo',
	   Object_Name = 'tblzCdLoanStatus'
);



END
--==Elastic query start==============================================

IF (@CurrentDBName <> @DBName_Staging)
BEGIN



Print('Elastic query set up for: Import cres staging data in cres integration')
IF(1=1)
Begin
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Account')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Account]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Note')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Note]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_TransactionEntry')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_TransactionEntry]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_NotePeriodicCalc')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_NotePeriodicCalc]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Event')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Event]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_FundingSchedule')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_FundingSchedule]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_DealFunding')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_DealFunding]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Deal')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Deal] 
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Analysis')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Analysis]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Client')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Client]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Fund')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Fund]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Maturity')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Maturity]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_PIKSchedule')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_PIKSchedule]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_LatestNoteFunding')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_LatestNoteFunding]

IF EXISTS(select [name] from sys.external_data_sources where name = 'RemoteReferenceCRESStaging')
	Drop EXTERNAL DATA SOURCE RemoteReferenceCRESStaging 
IF EXISTS(select [name] from sys.database_scoped_credentials where name = 'CredentialCRESStaging')
	Drop DATABASE SCOPED CREDENTIAL CredentialCRESStaging


--CREATE DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL CredentialCRESStaging  WITH IDENTITY = 'Cres4_staging',  SECRET = 'h9vWuP)[WEhu})S'

--CREATE EXTERNAL DATA SOURCE
Create EXTERNAL DATA SOURCE RemoteReferenceCRESStaging
WITH 
( 
    TYPE=RDBMS, 
    LOCATION='tcp:b0xesubcki1.database.windows.net,1433', 
    DATABASE_NAME='Cres4_staging', 
    CREDENTIAL= CredentialCRESStaging 
); 



-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Analysis] (
	
	AnalysisID uniqueidentifier  NOT NULL,
	[Name] varchar(256)  NULL,
	StatusID int  NULL,
	Description varchar(256)   NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ScenarioColor] [nvarchar](256) NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'Core',
	   Object_Name = 'Analysis'
);

CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Account] (
	[AccountID] [uniqueidentifier] NOT NULL,
	[AccountTypeID] [int] NULL,
	[StatusID] [int] NULL,
	[Name] [varchar](256) NULL,	
	[BaseCurrencyID] [int] NULL,
	[PayFrequency] [int] NULL,
	[ClientNoteID] [nvarchar](256) NULL,	
	[IsDeleted] [bit] NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'Account'
);


-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Note] (
	--[NoteID] [uniqueidentifier] NOT NULL,
	--[Account_AccountID] [uniqueidentifier] NOT NULL,
	--[DealID] [uniqueidentifier] NOT NULL,
	--[CRENoteID] [nvarchar](256) NULL,
	--[ClientNoteID] [nvarchar](256) NULL,
	NoteID	uniqueidentifier  NOT NULL,
	Account_AccountID	uniqueidentifier 	   NOT NULL,
	DealID	uniqueidentifier 	   NOT NULL,
	CRENoteID	nvarchar(256)	    NULL,
	ClientNoteID	nvarchar(256)	    NULL,
	Comments	nvarchar(256)	    NULL,
	InitialInterestAccrualEndDate	date	    NULL,
	AccrualFrequency	int	    NULL,
	DeterminationDateLeadDays	int	    NULL,
	DeterminationDateReferenceDayoftheMonth	int	    NULL,
	DeterminationDateInterestAccrualPeriod	int	    NULL,
	DeterminationDateHolidayList	Int	    NULL,
	FirstPaymentDate	date	    NULL,
	InitialMonthEndPMTDateBiWeekly	date	    NULL,
	PaymentDateBusinessDayLag	int	    NULL,
	IOTerm	int	    NULL,
	AmortTerm	int	    NULL,
	PIKSeparateCompounding	int	    NULL,
	MonthlyDSOverridewhenAmortizing	decimal(28,15)	    NULL,
	AccrualPeriodPaymentDayWhenNotEOMonth	int	    NULL,
	FirstPeriodInterestPaymentOverride	decimal(28,15)	    NULL,
	FirstPeriodPrincipalPaymentOverride	decimal(28,15)	    NULL,
	FinalInterestAccrualEndDateOverride	date	    NULL,
	AmortType	int	    NULL,
	RateType	Int	    NULL,
	ReAmortizeMonthly	Int	    NULL,
	ReAmortizeatPMTReset	Int	    NULL,
	StubPaidInArrears	Int	    NULL,
	RelativePaymentMonth	Int	    NULL,
	SettleWithAccrualFlag	Int	    NULL,
	InterestDueAtMaturity	int	    NULL,
	RateIndexResetFreq	decimal(28,15)	    NULL,
	FirstRateIndexResetDate	date	    NULL,
	LoanPurchase	Int	    NULL,
	AmortIntCalcDayCount	int	    NULL,
	StubPaidinAdvanceYN	Int	    NULL,
	FullPeriodInterestDueatMaturity	Int	    NULL,
	ProspectiveAccountingMode	Int	    NULL,
	IsCapitalized	Int	    NULL,
	SelectedMaturityDateScenario	int	    NULL,
	SelectedMaturityDate	date	    NULL,
	InitialMaturityDate	date	    NULL,
	ExpectedMaturityDate	date	    NULL,

	OpenPrepaymentDate	date	    NULL,
	CashflowEngineID	int	    NULL,
	LoanType	Int	    NULL,
	Classification	Int	    NULL,
	SubClassification	Int	    NULL,
	GAAPDesignation	Int	    NULL,
	PortfolioID	int	    NULL,
	GeographicLocation	Int	    NULL,
	PropertyType	Int	    NULL,
	RatingAgency	int	    NULL,
	RiskRating	int	    NULL,
	PurchasePrice	decimal(28,15)	    NULL,
	FutureFeesUsedforLevelYeild	decimal(28,15)	    NULL,
	TotalToBeAmortized	decimal(28,15)	    NULL,
	StubPeriodInterest	decimal(28,15)	    NULL,
	WDPAssetMultiple	decimal(28,15)	    NULL,
	WDPEquityMultiple	decimal(28,15)	    NULL,
	PurchaseBalance	decimal(28,15)	    NULL,
	DaysofAccrued	int	    NULL,
	InterestRate	decimal(28,15)	    NULL,
	PurchasedInterestCalc	decimal(28,15)	    NULL,
	ModelFinancingDrawsForFutureFundings	int	    NULL,
	NumberOfBusinessDaysLagForFinancingDraw	int	    NULL,
	FinancingFacilityID	uniqueidentifier	    NULL,
	FinancingInitialMaturityDate	date	    NULL,
	FinancingExtendedMaturityDate	date	    NULL,
	FinancingPayFrequency	Int	    NULL,
	FinancingInterestPaymentDay	int	    NULL,
	ClosingDate	date	    NULL,
	InitialFundingAmount	decimal(28,15)	    NULL,
	Discount	decimal(28,15)	    NULL,
	OriginationFee	decimal(28,15)	    NULL,
	CapitalizedClosingCosts	decimal(28,15)	    NULL,
	PurchaseDate	date	    NULL,
	PurchaseAccruedFromDate	decimal(28,15)	    NULL,
	PurchasedInterestOverride	decimal(28,15)	    NULL,
	DiscountRate decimal(28,15)	    NULL,
	ValuationDate date	    NULL,
	FairValue decimal(28,15)	    NULL,
	DiscountRatePlus decimal(28,15)	    NULL,
	FairValuePlus decimal(28,15)	    NULL,
	DiscountRateMinus decimal(28,15)	    NULL,
	FairValueMinus decimal(28,15)	    NULL,
	InitialIndexValueOverride decimal(28,15)	    NULL,
	IncludeServicingPaymentOverrideinLevelYield int null,
	OngoingAnnualizedServicingFee	decimal(28,15)	    NULL,
	IndexRoundingRule int  NULL,
	RoundingMethod int NULL,
	StubInterestPaidonFutureAdvances int NULL,
	TaxAmortCheck [nvarchar](256) NULL,
	PIKWoCompCheck [nvarchar](256) NULL,
	GAAPAmortCheck [nvarchar](256) NULL,
	StubIntOverride decimal(28,15)	    NULL,
	PurchasedIntOverride decimal(28,15)	    NULL,
	ExitFeeFreePrepayAmt decimal(28,15)	    NULL,
	ExitFeeBaseAmountOverride decimal(28,15)	    NULL,
	ExitFeeAmortCheck int	    NULL,
	FixedAmortScheduleCheck int null,				
	GeneratedBy      	Int,
	--PayRule
	UseRuletoDetermineNoteFunding int null,
	NoteFundingRule int null,
	FundingPriority int null,
	NoteBalanceCap decimal(28,15)	 NULL,
	RepaymentPriority int null,
	NoofdaysrelPaymentDaterollnextpaymentcycle int null,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL, 
	UseIndexOverrides bit null,
	IndexNameID int null,
	ServicerID nvarchar(256)	    NULL,
	TotalCommitment decimal(28,15)	 NULL,
	ClientName nvarchar(256) null ,
	Portfolio nvarchar(256) null ,
	Tag1 nvarchar(256) null ,
	Tag2 nvarchar(256) null ,
	Tag3 nvarchar(256) null ,
	Tag4 nvarchar(256) null ,
	ExtendedMaturityScenario1	date	    NULL,
	ExtendedMaturityScenario2	date	    NULL,
	ExtendedMaturityScenario3	date	    NULL,
	ActualPayoffDate	date	    NULL,
	FullyExtendedMaturityDate 	date	    NULL,
	TotalCommitmentExtensionFeeisBasedOn decimal(28,15)	 NULL,
	LienPriority  int ,
	UnusedFeeThresholdBalance  decimal(28,15)	 NULL,
	UnusedFeePaymentFrequency int null,
	lienposition int null ,
	[priority] int null,
	Servicer int null,
	FullInterestAtPPayoff int ,
	NoteRule nvarchar(2000) null,

	ClientID int null,
	FinancingSourceID int null,
	DebtTypeID int null,
	BillingNotesID int null,
	CapStack  int null,
	FundID  int null,
	PoolId int null,

	--Added column for wells
	TaxVendorLoanNumber	nvarchar(256)	null,
	TAXBILLSTATUS	nvarchar(256)	null,
	CURRTAXCONSTANT	int	null,
	InsuranceBillStatusCode	nvarchar(256)	null,
	RESERVETYPE	nvarchar(256)	null,
	ResDescOwnName	nvarchar(256)	null,
	MONTHLYPAYMENTAMT	int	null,
	IORPLANCODE	nvarchar(256)	null,
	NoDaysbeforeAssessment	decimal(28,15)	null,
	LateChargeRateorFee	decimal(28,15)	null,
	DefaultOfDaysto	decimal(28,15)	null,
	OddDaysIntAmount decimal(28,15) null,
	InterestRateFloor decimal(28,15) null,
	InterestRateCeiling decimal(28,15) null,
	Dayslookback nvarchar(256)  NULL,
	CurrentBls decimal(28,15) null,
	WF_Companyname	nvarchar(256)	null,
	WF_FirstName	nvarchar(256)	null,
	WF_Lastname	nvarchar(256)	null,
	WF_StreetName	nvarchar(256)	null,
	WF_ZipCodePostal	nvarchar(256)	null,
	WF_PayeeName	nvarchar(256)	null,
	WF_TelephoneNumber1	nvarchar(256)	null,
	WF_FederalID1	nvarchar(max)	null,
	WF_City	nvarchar(256)	null,
	WF_State	nvarchar(256)	null,
	StubInterestRateOverride decimal(28,15) null,
	LiborDataAsofDate datetime	    NULL,
	ServicerNameID int null,
	BusinessdaylafrelativetoPMTDate int null,
	DayoftheMonth int null,
	InterestCalculationRuleForPaydowns int null,
	PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate int null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Note'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Event] (
	EventID uniqueidentifier   NULL ,
	AccountID uniqueidentifier   NULL,
	Date date   NULL,
	EventTypeID int   NULL,
	EffectiveStartDate date   NULL,
	EffectiveEndDate date   NULL,
	SingleEventValue decimal(28,15)   NULL,
	[StatusID] int null,
	CreatedBy      	nvarchar(256)  NULL,
	CreatedDate      	datetime NULL,
	UpdatedBy      	nvarchar(256) NULL,
	UpdatedDate      	datetime
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'EVENT'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_FundingSchedule] (
	FundingScheduleID	uniqueidentifier   NULL,
	EventId	uniqueidentifier  null,
	Date	date null,
	Value	decimal(28,15)null,
	PurposeID int null,
	Applied bit null,
	CreatedBy  nvarchar(256) null,
	CreatedDate   datetime null,
	UpdatedBy   nvarchar(256) null,
	UpdatedDate    datetime null,
	DrawFundingId nvarchar(256) null,
	Comments nvarchar(max) null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'FundingSchedule'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_DealFunding] (
	DealFundingID uniqueidentifier   NULL ,
	DealID uniqueidentifier   NULL,
	[Date] date null,
	Amount decimal(28,15) null,
	Comment nvarchar(max),
	PurposeID int null,
	Applied bit null,
	Issaved bit null ,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL,
	DrawFundingId nvarchar(256) null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'DealFunding'
);
-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Deal] (
DealID uniqueidentifier   NULL ,
DealName      	nvarchar(256),
CREDealID	nvarchar(256),
SourceDealID uniqueidentifier,
DealType      	Int,
LoanProgram	Int,
LoanPurpose      	Int,
Status      	Int,
AppReceived      	date,
EstClosingDate      	date,
BorrowerRequest      	nvarchar(256),
RecommendedLoan      	decimal(28,15),
TotalFutureFunding      	decimal(28,15),
Source      	Int,
BrokerageFirm      	nvarchar(256),
BrokerageContact      	nvarchar(256),
Sponsor      	nvarchar(256),
Principal      	nvarchar(256),
NetWorth      	decimal(28,15),
Liquidity      	decimal(28,15),
ClientDealID	nvarchar(256),
GeneratedBy      	Int,
TotalCommitment decimal (28,15),
AdjustedTotalCommitment   decimal (28,15),
AggregatedTotal    decimal (28,15),
AssetManagerComment nvarchar(max),
[DealComment] [nvarchar](max) NULL,
AssetManager nvarchar(256),
DealCity nvarchar(256),
DealState nvarchar(256),
DealPropertyType nvarchar(256),
FullyExtMaturityDate date,
UnderwritingStatus int null,
LinkedDealID  nvarchar(256) null,
IsDeleted bit null ,
AllowSizerUpload int null,
CreatedBy      	nvarchar(256),
CreatedDate      	datetime,
UpdatedBy      	nvarchar(256),
UpdatedDate      	datetime,
AMUserID uniqueidentifier null,
DealRule nvarchar(2000) null,
AMTeamLeadUserID uniqueidentifier null,
AMSecondUserID uniqueidentifier null
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Deal'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_TransactionEntry] (
	[TransactionEntryID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NULL,
	[Date] [datetime] NULL,
	[Amount] [decimal](28, 15) NULL,
	[Type] nvarchar(MAX) null,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,

	AnalysisID uniqueidentifier null,
	FeeName nvarchar(256) null,
	StrCreatedBy 	nvarchar(256) NULL,
	GeneratedBy 	nvarchar(256) NULL

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'TransactionEntry'
);
-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_NotePeriodicCalc] (
[NotePeriodicCalcID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NULL,
	[PeriodEndDate] [date] NULL,
	[Month] [int] NULL,
	[ActualCashFlows] [decimal](28, 15) NULL,
	[GAAPCashFlows] [decimal](28, 15) NULL,
	[EndingGAAPBookValue] [decimal](28, 15) NULL,
	[TotalGAAPIncomeforthePeriod] [decimal](28, 15) NULL,
	[InterestAccrualforthePeriod] [decimal](28, 15) NULL,
	[PIKInterestAccrualforthePeriod] [decimal](28, 15) NULL,
	[TotalAmortAccrualForPeriod] [decimal](28, 15) NULL,
	[AccumulatedAmort] [decimal](28, 15) NULL,
	[BeginningBalance] [decimal](28, 15) NULL,
	[TotalFutureAdvancesForThePeriod] [decimal](28, 15) NULL,
	[TotalDiscretionaryCurtailmentsforthePeriod] [decimal](28, 15) NULL,
	[InterestPaidOnPaymentDate] [decimal](28, 15) NULL,
	[TotalCouponStrippedforthePeriod] [decimal](28, 15) NULL,
	[CouponStrippedonPaymentDate] [decimal](28, 15) NULL,
	[ScheduledPrincipal] [decimal](28, 15) NULL,
	[PrincipalPaid] [decimal](28, 15) NULL,
	[BalloonPayment] [decimal](28, 15) NULL,
	[EndingBalance] [decimal](28, 15) NULL,
	[ExitFeeIncludedInLevelYield] [decimal](28, 15) NULL,
	[ExitFeeExcludedFromLevelYield] [decimal](28, 15) NULL,
	[AdditionalFeesIncludedInLevelYield] [decimal](28, 15) NULL,
	[AdditionalFeesExcludedFromLevelYield] [decimal](28, 15) NULL,
	[OriginationFeeStripping] [decimal](28, 15) NULL,
	[ExitFeeStrippingIncldinLevelYield] [decimal](28, 15) NULL,
	[ExitFeeStrippingExcldfromLevelYield] [decimal](28, 15) NULL,
	[AddlFeesStrippingIncldinLevelYield] [decimal](28, 15) NULL,
	[AddlFeesStrippingExcldfromLevelYield] [decimal](28, 15) NULL,
	[EndOfPeriodWAL] [decimal](28, 15) NULL,
	[PIKInterestFromPIKSourceNote] [decimal](28, 15) NULL,
	[PIKInterestTransferredToRelatedNote] [decimal](28, 15) NULL,
	[PIKInterestForThePeriod] [decimal](28, 15) NULL,
	[BeginningPIKBalanceNotInsideLoanBalance] [decimal](28, 15) NULL,
	[PIKInterestForPeriodNotInsideLoanBalance] [decimal](28, 15) NULL,
	[PIKBalanceBalloonPayment] [decimal](28, 15) NULL,
	[EndingPIKBalanceNotInsideLoanBalance] [decimal](28, 15) NULL,
	[CostBasis] [decimal](28, 15) NULL,
	[PreCapBasis] [decimal](28, 15) NULL,
	[BasisCap] [decimal](28, 15) NULL,
	[AmortAccrualLevelYield] [decimal](28, 15) NULL,
	[ScheduledPrincipalShortfall] [decimal](28, 15) NULL,
	[PrincipalShortfall] [decimal](28, 15) NULL,
	[PrincipalLoss] [decimal](28, 15) NULL,
	[InterestForPeriodShortfall] [decimal](28, 15) NULL,
	[InterestPaidOnPMTDateShortfall] [decimal](28, 15) NULL,
	[CumulativeInterestPaidOnPMTDateShortfall] [decimal](28, 15) NULL,
	[InterestShortfallLoss] [decimal](28, 15) NULL,
	[InterestShortfallRecovery] [decimal](28, 15) NULL,
	[BeginningFinancingBalance] [decimal](28, 15) NULL,
	[TotalFinancingDrawsCurtailmentsForPeriod] [decimal](28, 15) NULL,
	[FinancingBalloon] [decimal](28, 15) NULL,
	[EndingFinancingBalance] [decimal](28, 15) NULL,
	[FinancingInterestPaid] [decimal](28, 15) NULL,
	[FinancingFeesPaid] [decimal](28, 15) NULL,
	[PeriodLeveredYield] [decimal](28, 15) NULL,
	[OrigFeeAccrual] [decimal](28, 15) NULL,
	[DiscountPremiumAccrual] [decimal](28, 15) NULL,
	[ExitFeeAccrual] [decimal](28, 15) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[AllInCouponRate] [decimal](28, 15) NULL,

	[CleanCost] [decimal](28, 15) NULL,	
	[GrossDeferredFees] [decimal](28, 15) NULL,
	[DeferredFeesReceivable] [decimal](28, 15) NULL,
	[CleanCostPrice] [decimal](28, 15) NULL,
	[AmortizedCostPrice] [decimal](28, 15) NULL,
	[AdditionalFeeAccrual] [decimal](28, 15) NULL,
	[CapitalizedCostAccrual] [decimal](28, 15) NULL,
	[DailySpreadInterestbeforeStrippingRule] [decimal](28, 15) NULL,
	[DailyLiborInterestbeforeStrippingRule] [decimal](28, 15) NULL,
	[ReversalofPriorInterestAccrual] [decimal](28, 15) NULL,
	[InterestReceivedinCurrentPeriod] [decimal](28, 15) NULL,
	[CurrentPeriodInterestAccrual] [decimal](28, 15) NULL,
	[TotalGAAPInterestFortheCurrentPeriod] [decimal](28, 15) NULL,

	
	InvestmentBasis decimal(28,15) null,
	CurrentPeriodInterestAccrualPeriodEnddate  [decimal](28, 15) NULL, 
	LIBORPercentage  [decimal](28, 15) NULL,
	SpreadPercentage  [decimal](28, 15) NULL,
	AnalysisID UNIQUEIDENTIFIER null,
	FeeStrippedforthePeriod [decimal](28, 15) NULL,
	PIKInterestPercentage [decimal](28, 15) NULL,
	AmortizedCost [decimal](28, 15) NULL,
	InterestSuspenseAccountActivityforthePeriod decimal(28,15) null,
	InterestSuspenseAccountBalance  decimal(28,15) null


)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging ,
	   Schema_Name = 'CRE',
	   Object_Name = 'NotePeriodicCalc'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Client] (
	
	ClientID [int]  NULL,
ClientName nvarchar(256)	    NULL,
[Status] int null,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL,
EmailId      	nvarchar(256)	    NULL

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Client'
);



CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Fund] (
	
FundID [int]  NULL,
FundName nvarchar(256)	    NULL,
ClientID [int]  NULL,
[Pool] nvarchar(256)	    NULL,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL


)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Fund'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Maturity] (
	
MaturityID	uniqueidentifier  NOT NULL ,
EventId	uniqueidentifier not null,
SelectedMaturityDate date   NULL,
 
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null



)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'Maturity'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_PIKSchedule] (
PIKScheduleID uniqueidentifier  NOT NULL ,
EventID uniqueidentifier  NOT NULL,
SourceAccountID uniqueidentifier   NULL,
TargetAccountID uniqueidentifier   NULL,
AdditionalIntRate decimal(28,15)   NULL,
AdditionalSpread decimal(28,15)   NULL,
IndexFloor decimal(28,15)   NULL,
IntCompoundingRate decimal(28,15)   NULL,
IntCompoundingSpread decimal(28,15)   NULL,
StartDate date   NULL,
EndDate date   NULL,
IntCapAmt decimal(28,15)   NULL,
PurBal decimal(28,15)   NULL,
AccCapBal decimal(28,15)   NULL,
[CreatedBy] [nvarchar](256) NULL,
[CreatedDate] [datetime] NULL,
[UpdatedBy] [nvarchar](256) NULL,
[UpdatedDate] [datetime] NULL

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'PIKSchedule'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_LatestNoteFunding] (
NoteID UNIQUEIDENTIFIER   NULL,
CRENoteID nvarchar(256) null,
TransactionDate Date null,
Amount decimal(28,15)  NULL,
WireConfirm bit null,
PurposeBI nvarchar(256) null,
DrawFundingID nvarchar(256) null,
Comments nvarchar(max) null,
CreatedBy 	nvarchar(256) NULL,
CreatedDate 	datetime ,
UpdatedBy 	nvarchar(256) NULL,
UpdatedDate 	datetime 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'LatestNoteFunding'
);


END

update cre.WFNotificationMasterEmail set EmailID=replace(EmailID,'winthropcm.com','mailinator.com')
update cre.WFNotificationMasterEmail set EmailID=replace(EmailID,'harel-ins.co.il','mailinator.com')
update cre.WFNotificationMasterEmail set EmailID=replace(EmailID,'harel.ins.co.il','mailinator.com')


END


Delete from app.emailnotification where emailid = 'schandak@hvantage.com' and moduleid = 707
Delete from app.emailnotification where emailid = 'support@m61systems.com' and moduleid = 781

Print ('Update Draw fee email id - table-InvoiceDetail')

Update Cre.InvoiceDetail set Cre.InvoiceDetail.Email1 = x.Email1Update,Cre.InvoiceDetail.Email2 = x.Email2Update
From(

	Select Distinct z.InvoiceDetailID,z.Email1,z.Email2,z.Email1Update, ---z.Email2Update,
	STUFF((SELECT ', ' + CAST(Email2Update AS VARCHAR(256)) [text()]
	From(
	Select InvoiceDetailID,Email1,Email2, SUBSTRING(Email1, 0, PATINDEX('%@%',Email1)) + '@mailinator.com' as Email1Update,
	SUBSTRING(fn.value, 0, PATINDEX('%@%',fn.value)) + '@mailinator.com' as Email2Update
	from Cre.InvoiceDetail ind
	outer apply [dbo].[fn_Split] (nullIF(ind.Email2,'')) fn
	where InvoiceDetailID = z.InvoiceDetailID
	)a
	FOR XML PATH(''), TYPE)
	.value('.','NVARCHAR(MAX)'),1,2,' ') Email2Update
	From(
	Select InvoiceDetailID,Email1,Email2, SUBSTRING(Email1, 0, PATINDEX('%@%',Email1)) + '@mailinator.com' as Email1Update,
	SUBSTRING(fn.value, 0, PATINDEX('%@%',fn.value)) + '@mailinator.com' as Email2Update
	from Cre.InvoiceDetail ind
	outer apply [dbo].[fn_Split] (nullIF(ind.Email2,'')) fn
	--where InvoiceDetailID = 101
	)z

)x
Where Cre.InvoiceDetail.InvoiceDetailID= x.InvoiceDetailID


Print ('Insert QuickBookCompany and QuickBookUser in lower env')

truncate table app.QuickBookUser

if not exists(select 1 from app.QuickBookUser where AgentToken ='0S6UPXUS2ALXY312NSNED9VSK5A4')
begin
	insert into app.QuickBookUser(AgentToken,CompanyId,ExternalId,ID,isActive) values('0S6UPXUS2ALXY312NSNED9VSK5A4','M61-QA','','6b4bc674c4c84cba916fcb27971d29b6',1)
end

truncate table app.QuickBookCompany

if not exists(select * from app.QuickBookCompany where name ='M61-QA')
begin
	insert into app.QuickBookCompany (name,endpointid,autofycompanyid,createdby,createdDate,UpdatedBy,UpdatedDate,IsActive)
	values ('M61-QA','fd9d849f22524cf2889ef763056a759b','ffacbd0dc67f482c88b135d677fedfbe','',getdate(),'',getdate(),1)
end

update app.QuickBookCustomer set CompanyName='M61-QA'

Update app.[user] set StatusID = 1 where [login] in ('Pam' , 'sam', 'amo', 'tier1','tier2','Automated')

update app.AppConfig set [Value]=0 where [Key] in ('AllowWFInternalNotification','AllowDrawFeeAMEmail')


Update app.[user] set email = Replace(Email,'acorecapital.com','mailinator.com') where Email in (Select EmailId from app.emailnotification where EmailId like '%@acore%')
Update app.EmailNotification set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com')  where EmailId like '%@acore%'
Update app.[user] set email = Replace(Email,'acorecapital.com','mailinator.com') where Email like '%@acore%'

Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com')



	--mask additional email in workflow with mailination
	declare @temp as table
	(
	WFTaskAdditionalDetailid int ,
	additionalemail nvarchar(1000)
	)
	insert into @temp
	select
	WFTaskAdditionalDetailid,
	REplace(Email,substring(Email,charindex('@',Email),charindex('.com',Email)-charindex('@',Email)),'@mailinator')

	--Email,
	--Len(Email)
	from 
	(
	SELECT A.WFTaskAdditionalDetailid,  
		 Split.a.value('.', 'VARCHAR(100)') AS Email
	FROM  
	(
		SELECT additionalemail, WFTaskAdditionalDetailid, 
			 CAST ('<M>' + REPLACE(additionalemail, ',', '</M><M>') + '</M>' AS XML) AS CVS  
		FROM  cre.WFTaskAdditionalDetail where isnull(additionalemail,'') <>''
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)
	where WFTaskAdditionalDetailid not in  ( 428189,428300,428441,428539,428605,
												432110,
												432256,
												429647,
												432255,
												429655,
												429723,
												429882
												)
	) tbl

	update cre.WFTaskAdditionalDetail set cre.WFTaskAdditionalDetail.AdditionalEmail=tbl1.additionalemail
	from
	(
	SELECT WFTaskAdditionalDetailid, additionalemail = 
		STUFF((SELECT ', ' + additionalemail
			   FROM @temp b 
			   WHERE b.WFTaskAdditionalDetailid = a.WFTaskAdditionalDetailid 
			  FOR XML PATH('')), 1, 2, '')
	FROM @temp a
	GROUP BY WFTaskAdditionalDetailid
	) tbl1
	where cre.WFTaskAdditionalDetail.WFTaskAdditionalDetailID=tbl1.WFTaskAdditionalDetailid


	---upgrade below users to Super Admin role
	UPDATE [App].[UserRoleMap]
   SET [RoleID] = '584B6F94-1028-4AD3-83EB-FEB3F031B07A'
      ,[StatusID] = 1    
      ,[UpdatedDate] = GETDATE()
	WHERE UserRoleMapID in (Select UserRoleMapID from [App].[UserRoleMap] where userid in (select UserID from app.[user] where [login] in ('rtran','aaguilar','elee','bbarron','schang')))

 
END


IF(@CurrentDBName = @DBName_QA)
BEGIN
	---======================================================

	Update app.[user] set login = 'admin_qa' where login in ('admin_integration','admin_acore')
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowDebugInCalc', 'AllowBackshopFF','AllowBackshopPIKPrincipal','AllowFFDeleteFromM61andBackshop','AllowWFInternalNotification','AllowYieldConfigData','AllowDrawFeeAMEmail','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')

	Delete from app.[Emailnotification] where emailid = '%acoreaccounting%'

	Update app.[user] set Password = 'f225999720b317e32fa0ffac27b84269'
	Update app.[User] set password = '222599db8c68e283343c3a7266d27220',email = 'cbansal@hvantage.com' where login = 'cbansal'
	Update app.[User] set password = 'ad9f83a1e44cf23570efc379e0268f00',email = 'rmundhra@hvantage.com' where login = 'rmundhra'
	Update app.[User] set password = '0ff5ee49cabfbd9831418a0c2fe4c9fb',email = 'pjain@hvantage.com' where login = 'hbotuser'
	Update app.[User] set password = 'dcbcba8d2a5c39d5bb4d67a8d6e86b8c',email = 'asaxena@hvantage.com' where login = 'asaxena'

	Update app.EmailNotification set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update app.[user] set email = Replace(Email,'acorecapital.com','mailinator.com')

	Update app.EmailNotification set EmailID = Replace(EmailID,'statestreet.com','mailinator.com') 
	Update app.[user] set email = Replace(Email,'statestreet.com','mailinator.com')
	
	---Update app.[user] set [Password] = '8cf119d3deb242fc73bc25c226443b54' where [Login] = 'admin_qa'

	update app.reportfile set [Status]=1 where ReportFileID=10

	--============================================

	GRANT EXECUTE ON OBJECT::	usp_SaveDealSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetRateSpreadRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteAmortScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteFeeCouponSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteDealFundingByDealIDSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteFundingRepaymentSequenceSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteNoteDataSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteNoteFundingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePIKScheduleDetailSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePrepayScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteRateSpreadScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetAmortRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetDealFundingRecordSetSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetNotePayrulRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetNoteRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetPrepayRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertAmortScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertDealFundingNoteDataSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertFeeCouponStripReceivableSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertFundingRepaymentSequenceSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertNoteFundingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertNoteSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPIKScheduleDetailSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPrepayAndAdditionalFeeScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertRateSpreadScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteDealDataSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetFundingScheduleRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetPayruleSetupRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPayruleSetupSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePayruleSetupByDealIDSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertDealFundingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetDealFundingRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePIKScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetPIKScheduleRecordSetSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPIKScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertLiborAndMaturityScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertUserNotificationSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertStrippingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetStrippingScheduleSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteStrippingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_CheckDuplicateDealSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetDealRecordSetSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetFundingRepaymentSequenceRecordSetSizer  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	[App].usp_AddUpdateObject  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	[dbo].usp_AuthenticateUserSizer  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetSizerDocumentsRecordSet  to sizer_ModifyQA 
	GRANT EXECUTE ON OBJECT::	usp_DeleteSizerDocuments  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertIntoSizerDocumentsNote  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetAllLookupsSizer  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_UpdateNoteExtenstionSizer  to sizer_ModifyQA

	--================================
	Print('Remove client email from workflow')
	truncate  TABLE [CRE].[WFNotificationMasterEmail]
	INSERT INTO [CRE].[WFNotificationMasterEmail](ClientID,ParentClient,LookupID,EmailID) Values(1,'Delphi Financial',604,'capitalcall@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 1,'Delphi Financial',605,'capitalcall@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 2,'TRE ACR',604,'treacrfundingdraw@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 2,'TRE ACR',605,'treacrfundingdraw@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 2,'TRE ACR',607,'treacrfundingdraw@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 5,'ACORE Credit IV',604,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 5,'ACORE Credit IV',605,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 6,'ACORE Credit IV - Offshore',604,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 6,'ACORE Credit IV - Offshore',605,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 8,'Delphi Fixed',604,'capitalcall@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 8,'Delphi Fixed',605,'capitalcall@mailinator.com')

	Update [CRE].[Servicer] set EmailID = 'missing@mailinator.com' 
	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'

	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'cms.trimont.com','mailinator.com') 
	--=====================================================================


	Truncate table cre.WFNotificationMasterEmail

	--Prelim and Final
	INSERT INTO cre.WFNotificationMasterEmail (ClientID,LookupID,ParentClient)
	Select ClientID,LookupID,ParentClient from(
	Select Distinct ParentClient, ClientID,tbl.lookupid
	from cre.FinancingSourceMaster fm 
	left join cre.client c on c.clientname = Replace(fm.ParentClient,'AFLAC US','AFLAC')
	,(Select 604 as lookupid Union ALL Select 605 as lookupid) as tbl
	where PArentClient is not null
	)a

	Update cre.WFNotificationMasterEmail set EmailID = 'missing@mailinator.com'
	Update cre.WFNotificationMasterEmail set EmailID = 'fundingdrawaciv@mailinator.com' where ParentClient =  'ACORE Credit IV'
	Update cre.WFNotificationMasterEmail set EmailID = 'fundingdrawaciv@mailinator.com' where ParentClient =  'ACORE Credit IV - Offshore'
	Update cre.WFNotificationMasterEmail set EmailID = 'capitalcall@mailinator.com' where ParentClient =  'Delphi Financial'
	Update cre.WFNotificationMasterEmail set EmailID = 'capitalcall@mailinator.com' where ParentClient =  'Delphi Fixed'
	Update cre.WFNotificationMasterEmail set EmailID = 'treacrfundingdraw@mailinator.com' where ParentClient =  'TRE ACR'
	Update cre.WFNotificationMasterEmail set EmailID = 'treacrfundingdraw@mailinator.com' where ParentClient =  'AFLAC US'


	--Consolidate
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='ar@mailinator.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'ar@mailinator.com','TRE ACR')
	END
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='ababbitt@mailinator.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'ababbitt@mailinator.com','TRE ACR')
	END
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='igai@mailinator.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'igai@mailinator.com','TRE ACR')
	END
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='rsahu@hvantage.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'rsahu@hvantage.com','TRE ACR')
	END


	if not exists(select 1 from CRE.WFNotificationMasterEmail where lookupid=704)
	begin
		insert into CRE.WFNotificationMasterEmail(lookupID,EmailID,ParentClient)
		select 704,EmailID,ParentClient from [CRE].WFNotificationMasterEmail where lookupid=605
	end
	--===============================================================================================

	delete from app.emailnotification  where moduleid in (606,617,552,614)
	--first draw approver
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,606,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,606 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=606
	)

	--Tier 1 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,617,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,617 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=617
	)

	--Tier 2 users
	insert into app.emailnotification (EmailId,ModuleId,Status) 
	select Email,552,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,552 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=552
	)



	if not exists(select 1 from app.EmailNotification where Emailid='amfinancialcontrols@acorecapital.com' and ModuleId=614)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'amfinancialcontrols@acorecapital.com',614,1


	delete from app.emailnotification  where Emailid='ar@acorecapital.com'

	if not exists(select 1 from app.EmailNotification where Emailid='ar@mailinator.com' and ModuleId=703)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'ar@mailinator.com',703,1

	Update app.EmailNotification set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update app.EmailNotification set EmailID = Replace(EmailID,'statestreet.com','mailinator.com') 
	

	Delete from app.EmailNotification where moduleid = 363
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',363,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',363,1)


	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)
	--===============================================================


	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI
	Truncate table DW.TransactionEntryBI
	Truncate table DW.NotePeriodicCalcBI
	Truncate table DW.InterestCalculatorBI
	Truncate table DW.UwCashflowBI
	Truncate table [DW].[Prod_Cashflow]
	Truncate table [DW].[Prod_TransactionEntry]
	Truncate table [DW].[Prod_NoteFunding]
	Truncate table [DW].[Prod_DealFundingSchdule]
	Truncate table [DW].[Staging_Cashflow]
	Truncate table [DW].[Staging_TransactionEntry]
	Truncate table [DW].[Staging_NoteFunding]
	Truncate table [DW].[Staging_DealFundingSchdule]
	Truncate table [DW].[Staging_Note]
	Truncate table DW.DailyInterestAccrualsBI
	Truncate table [DW].Staging_IntegartionCashFlowBI
	Truncate table DW.AdditionalFee_BalanceBI
	Truncate table DW.AnalysisBI
	Truncate table DW.BackshopCommitmentAdjBI
	Truncate table DW.BackshopCurrentBalanceBI
	Truncate table DW.BackshopDealFundingBI
	Truncate table DW.BackshopNoteBI
	Truncate table DW.BackshopNoteFundingBI
	Truncate table DW.BerkadiaDataTap
	Truncate table DW.BSNoteFundingBI
	Truncate table DW.CalendarBI
	Truncate table DW.CalendarPeriodBI
	Truncate table DW.DailyCalcBI
	Truncate table DW.DailyInterestAccrualsBI
	Truncate table DW.DealBI
	Truncate table DW.DealFundingSchduleBI
	Truncate table DW.DealMatrixBI
	Truncate table DW.DropDateSampleData
	Truncate table DW.EventBasedBalanceBI
	Truncate table DW.ExceptionsBI
	Truncate table DW.FeeBaseAmountDeterminationBI
	Truncate table DW.FeeFunctionsDefinitionBI
	Truncate table DW.FeeScheduleBI
	Truncate table DW.FullAccUnpaidInterest_Interim1BI
	Truncate table DW.FundingSequencesBI
	Truncate table DW.InterestCalculatorBI
	Truncate table DW.InterimDropDateBI
	Truncate table DW.L_BackshopCurrentBalanceBI
	Truncate table DW.L_BSNoteFundingBI
	Truncate table DW.L_DailyCalcBI
	Truncate table DW.L_DailyInterestAccrualsBI
	Truncate table DW.L_DealBI
	Truncate table DW.L_DealFundingSchduleBI
	Truncate table DW.L_ExceptionsBI
	Truncate table DW.L_FundingSequencesBI
	Truncate table DW.L_InterestCalculatorBI
	Truncate table DW.L_NoteBI
	Truncate table DW.L_NoteFundingBI
	Truncate table DW.L_NoteFundingScheduleBI
	Truncate table DW.L_NoteMatrixBI
	Truncate table DW.L_NotePeriodicCalcBI
	Truncate table DW.L_NoteTransactionDetailBI
	Truncate table DW.L_PropertyBI
	Truncate table DW.L_RateSpreadScheduleBI
	Truncate table DW.L_TransactionBI
	Truncate table DW.L_TransactionEntryBI
	Truncate table DW.L_UwCashflowBI
	Truncate table DW.L_UwDealBI
	Truncate table DW.L_UwNoteBI
	Truncate table DW.L_UwNoteCommitmentAdjustmentBI
	Truncate table DW.L_UwNoteFundingBI
	Truncate table DW.L_UwPropertyBI
	Truncate table DW.L_WFCheckListDetailBI
	Truncate table DW.L_WFTaskDetailBI
	Truncate table DW.L_WorkFlowBI
	Truncate table DW.NoteBI
	Truncate table DW.NoteFundingBI
	Truncate table DW.NoteFundingScheduleBI
	Truncate table DW.NoteMatrixBI
	Truncate table DW.NoteMatrixBI_Delphi
	Truncate table DW.NoteMatrixBI_Test
	Truncate table DW.NoteMatrixBI_TestAcoreIV
	Truncate table DW.NotePeriodicCalcBI
	Truncate table DW.NotePeriodicCalcByEntityBI
	Truncate table DW.NoteTranchePercentageBI
	Truncate table DW.NoteTransactionDetailBI
	Truncate table DW.PowerBILog
	Truncate table DW.Prod_Cashflow
	Truncate table DW.Prod_DealFundingSchdule
	Truncate table DW.Prod_NoteFunding
	Truncate table DW.Prod_TransactionEntry
	Truncate table DW.PropertyBI
	Truncate table DW.RateSpreadScheduleBI
	Truncate table DW.ReconciliationDetailBI
	Truncate table DW.ServicingBalanceBI
	Truncate table DW.ServicingTransactionBI
	Truncate table DW.Staging_Cashflow
	Truncate table DW.Staging_DealFundingSchdule
	Truncate table DW.Staging_IntegartionCashFlowBI
	Truncate table DW.Staging_Note
	Truncate table DW.Staging_NoteFunding
	Truncate table DW.Staging_TransactionEntry
	Truncate table DW.TransactionBI
	Truncate table DW.TransactionByEntityBI
	Truncate table DW.TransactionEntryBI
	Truncate table DW.TransactionEntryPivotBI
	Truncate table DW.UwCashflowBI
	Truncate table DW.UwDealBI
	Truncate table DW.UwNoteBI
	Truncate table DW.UwNoteCommitmentAdjustmentBI
	Truncate table DW.UwNoteFundingBI
	Truncate table DW.UwPropertyBI
	Truncate table DW.WellsDataTap
	Truncate table DW.WFCheckListDetailBI
	Truncate table DW.WFTaskDetailBI

	--Truncate table CRE.DailyInterestAccruals
	Truncate table CRE.TransactionEntryClose
	--Truncate table CRE.TransactionEntry
	--Truncate table CRE.NotePeriodicCalc	

	Truncate table CRE.DailyGAAPBasisComponents
	Truncate table dW.NotePeriodicCalcByEntityBI_All

	Print ('Truncate warehouse table data')
	Print ('DB Refresh QA - Done')


	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)


	Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
	Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
	Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	
	---set automate used to superadmin
	Update app.userrolemap set RoleID = '584B6F94-1028-4AD3-83EB-FEB3F031B07A' where userid = '822001E5-A6A9-4F7B-AC45-43913B860830'

	
	Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

	Update app.appconfig set [value] = 1 where [key] = 'StopV1NoteCalculation'


	Update  [VAL].[Configuration] Set [Value] = 'https://qacres5calculator.azurewebsites.net/'  Where env = 'qa'  and [Key]='Service_URL'

END

IF(@CurrentDBName = @DBName_Integration)
BEGIN
    --Update login in app.[user] table
	Update app.[user] set login = 'admin_integration',[Password] = 'f225999720b317e32fa0ffac27b84269' where login in ( 'admin_staging', 'admin_acore')
	Delete from app.EmailNotification where EmailId like '%acorecapital.com%'
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowBackshopFF','AllowBackshopPIKPrincipal','AllowDebugInCalc','AllowFFDeleteFromM61andBackshop','AllowYieldConfigData','AllowDealAutomation','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')  ---, 'AllowBackshopFF','AllowBackshopPIKPrincipal',
	
	Update app.appconfig set [Value] = 1 where [Key] in ('AllowBackshopFF','AllowBackshopPIKPrincipal')
	Update app.appconfig set [Value] = 1 where [key] = 'AllowBasicLogin'
	Update app.appconfig SET [value] = 'https://integrationcres4.azurewebsites.net/' where [key] = 'M61BaseUrl'

	--'AllowWFInternalNotification','AllowDrawFeeAMEmail'

	update app.reportfile set [Status]=1 where ReportFileID=10

	--================================================
	delete from app.emailnotification  where moduleid in (606,617,552,614)
	--first draw approver
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,606,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,606 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=606
	)

	--Tier 1 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,617,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,617 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=617
	)

	--Tier 2 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,552,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,552 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=552
	)



	if not exists(select 1 from app.EmailNotification where Emailid='amfinancialcontrols@acorecapital.com' and ModuleId=614)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'amfinancialcontrols@acorecapital.com',614,1


	delete from app.emailnotification  where Emailid='ar@acorecapital.com'

	if not exists(select 1 from app.EmailNotification where Emailid='ar@mailinator.com' and ModuleId=703)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'ar@mailinator.com',703,1
	--===============================================================================================

	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'cms.trimont.com','mailinator.com') 




	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com')
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'statestreet.com','mailinator.com')
	--vishal1111
	Update app.EmailNotification set EmailID = Replace(EmailID,'statestreet.com','mailinator.com') 

	Update app.EmailNotification  set EmailID = 'amfinancialcontrols@mailinator.com' where ModuleId=614
	

	Update app.[user] set password = 'f225999720b317e32fa0ffac27b84269' where login in ('pam', 'sam', 'amo', 'tier1', 'tier2')
	Update [CRE].[Servicer] set EmailID = 'missing@mailinator.com' where EmailID is null


	Delete from app.EmailNotification where moduleid = 363
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',363,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',363,1)


	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)



	if not exists(select 1 from app.emailnotification where moduleid=704 and EmailId = 'allacoreemployees@mailinator.com')
	begin
		insert into app.emailnotification(EmailID,ModuleId,Status)
		values ('allacoreemployees@mailinator.com',704,1)

	end


	if not exists(select 1 from app.emailnotification where moduleid=720 and EmailId = 'jennis@mailinator.com')
	begin
		insert into app.emailnotification(EmailID,ModuleId,Status)
		values ('jennis@mailinator.com',720,1)
	

	end
	if not exists(select 1 from app.emailnotification where moduleid=720 and EmailId = 'dgrocholski@mailinator.com')
	begin
		insert into app.emailnotification(EmailID,ModuleId,Status)
		values ('dgrocholski@mailinator.com',720,1)

	end


	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI


	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)
			update app.[User] set email='jennis@acorecapital.com' where email='jennis@acorecapital.com'
			update app.[User] set email='dgrocholski@acorecapital.com' where email='dgrocholski@acorecapital.com'

			update app.EmailNotification set emailid='jennis@acorecapital.com' where emailid='jennis@mailinator.com'
			update app.EmailNotification set emailid='dgrocholski@acorecapital.com' where emailid='dgrocholski@mailinator.com'
			
			
			update app.QuickBookCompany 
			set [name]='ACORE Capital, LP',
			EndPointID='5f77ec5a02044978a8180f5fe4ae42d4',
			AutofyCompanyID='c545f760592941d7a98a3f33a7011dc8'

			update app.QuickBookCustomer set CompanyName='ACORE Capital, LP'

			update app.QuickBookUser 
			set AgentToken='TWDRQX1H599AE6YMOMAAZAHBL6XI',
			CompanyId='ACORE Capital, LP',
			ID='43513c9b6bcd4b7e8ea0e1214266af3b'

		update cre.WFNotificationMasterEmail set EmailID=replace(EmailID,'winthropcm.com','mailinator.com')
		update cre.WFNotificationMasterEmail set EmailID=replace(EmailID,'harel-ins.co.il','mailinator.com')
		update cre.WFNotificationMasterEmail set EmailID=replace(EmailID,'harel.ins.co.il','mailinator.com')
	

		
		Update app.EmailNotification SET EmailId = REPLACE(EmailId,'acorecapital.com','mailinator.com') where EmailId like '%acorecapital.com%'

		-----Take backup of FF data for deal save automation using API
		if exists (select * from sys.objects where name = 'Backup_FF_API_Test' and type = 'u')
		drop table  [CRE].[Backup_FF_API_Test]

		CREATE TABLE [CRE].[Backup_FF_API_Test] (
		NoteID UNIQUEIDENTIFIER   NULL,
		CRENoteID nvarchar(256) null,
		TransactionDate Date null,
		Amount decimal(28,15)  NULL,
		WireConfirm bit null,
		PurposeBI nvarchar(256) null,
		DrawFundingID nvarchar(256) null,
		Comments nvarchar(max) null,
		CreatedBy 	nvarchar(256) NULL,
		CreatedDate 	datetime ,
		UpdatedBy 	nvarchar(256) NULL,
		UpdatedDate 	datetime 
		);


		CREATE INDEX index_Backup_FF_API_Test_NoteID ON [CRE].[Backup_FF_API_Test] (NoteID,CRENoteID)

		INSERT INTO [CRE].[Backup_FF_API_Test]
		([NoteID]
		,[CRENoteID]
		,[TransactionDate]
		,[WireConfirm]
		,[PurposeBI]
		,[Amount]
		,[DrawFundingID]
		,[Comments]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy] 
		,[UpdatedDate] )

		Select  
		n.NoteID
		,n.crenoteid as crenoteid
		,fs.[Date] as [TransactionDate]
		,fs.Applied as [WireConfirm]
		,LPurposeID.Name as [PurposeBI]
		,fs.Value as [Amount]
		,fs.DrawFundingId as [DrawFundingID]
		,fs.Comments as [Comments]
		,fs.[CreatedBy]
		,fs.[CreatedDate]
		,fs.[UpdatedBy] 
		,fs.[UpdatedDate] 
		from CORE.FundingSchedule fs
		INNER JOIN CORE.Event e on e.EventID = fs.EventId
		INNER JOIN 
		(						
			Select 
			(Select AccountID from CORE.Account ac where ac.AccountID = ns.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
			from CORE.Event eve
			INNER JOIN CRE.Note ns ON ns.Account_AccountID = eve.AccountID
			INNER JOIN CORE.Account acc ON acc.AccountID = ns.Account_AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
			--and ns.NoteID = @NoteId  
			and acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
			GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID
		) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

		left JOIN [Core].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID
		INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0




		Truncate table CRE.DailyGAAPBasisComponents	
		Truncate table DW.DailyInterestAccrualsBI	
		Truncate table CRE.TransactionEntryClose	
		Truncate table DW.InterestCalculatorBI	
		Truncate table DW.Staging_IntegartionCashFlowBI
		Truncate table DW.EventBasedBalanceBI

		Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
		Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
		Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

		---set automate used to superadmin
		Update app.userrolemap set RoleID = '584B6F94-1028-4AD3-83EB-FEB3F031B07A' where userid = '822001E5-A6A9-4F7B-AC45-43913B860830'

		---Anastasia Slipka and Merve Gurbanli should be made Assest Manager and Yoon Costello should be upgraded to Super Admin.
		Update app.userrolemap set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB' where userid in (select userid from app.[user] where [login] in ('aaslipka','mgurbanli'))  --assetMgr
		Update app.userrolemap set RoleID = '584B6F94-1028-4AD3-83EB-FEB3F031B07A' where userid in (select userid from app.[user] where [login] in ('ycostello'))  --SuperAdmin

		Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

		Update app.appconfig set [value] = 0 where [key] = 'StopV1NoteCalculation'

		---Add extra user
		exec [App].[usp_AddUpdateUser] '00000000-0000-0000-0000-000000000000','Easwar','Ayyar','easwar@hvantage.com','easwar','6026a8afe0e53574fe0149119b8a9009',null,1,'584B6F94-1028-4AD3-83EB-FEB3F031B07A',null,'335735a9-cdfe-4e22-9a3f-8adb3d9b931a','Central Standard Time'



		------Report script-------------

		update [App].[ReportFile] set reporttype='Acore' where reportFileFormat is not null
		--here
		--update reportfile table for power bi for integration db- 
		delete from [App].[ReportFile] where ReportType='PowerBI' and ReportFileFormat is null
 
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Accounting Reconciliation' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Accounting Reconciliation','183ce580-6338-42c3-bec4-52849864acb4','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end

		if not exists(select 1 from [App].[ReportFile] where ReportFileName='ACORE Capital Reconciliation Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('ACORE Capital Reconciliation Report','2bc2264f-f8ef-4581-a758-ed9084aaf0ce','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Additional Loan Calcs report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Additional Loan Calcs report','875d73d3-bba6-420b-a10e-337cc5db9cbf','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='AM Reports' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('AM Reports','43586c17-0b9f-4ae4-a0dd-9d2b1288bcea','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end

		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Balance Roll' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Balance Roll','6d2beb6c-b478-403b-9d50-7c01af948589','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Discrepancy Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Discrepancy Report','52fb413f-7d41-4f27-bf64-7f8cd0ccbbc1','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Fee Schedule Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Fee Schedule Report','af4ddc8e-9fce-4ae1-9dcf-e81e9a012a4d','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='LIBOR SOFR Index Tracker' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('LIBOR SOFR Index Tracker','c782f478-d5c2-4384-929c-7c59b6031595','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Principal Export' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('M61 Principal Export','cb93dcf7-5727-41ed-bf82-2569b85eeb5b','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Cap Rec Tool' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Note Cap Rec Tool','cf776896-7449-4b39-bd20-f723ba7510cf','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Funding Rules' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Note Funding Rules','97cee224-a0ba-4db1-87e4-d4fcad45952c','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Matrix Comparison Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Note Matrix Comparison Report','64808a3a-1dd9-43ac-91a1-720e8d59841f','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end

		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Property Level Details' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Property Level Details','9bc54829-2eb8-4a74-873e-333fd4e11b7a','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='QB - AM Fee Details' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('QB - AM Fee Details','1fcd072e-7ed9-4d99-beb7-519f09a88d1f','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Rate Spread Schedule' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Rate Spread Schedule','2274622c-116b-45ad-b6c6-dac228f85187','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		if not exists(select 1 from [App].[ReportFile] where ReportFileName='Unfunded Commitment' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('Unfunded Commitment','33744298-4edb-430a-8da3-b3a5113cdf01','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end

		if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Data Tape' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		begin
		insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
		values('M61 Data Tape','8b7d7c4a-2d0f-477b-84cc-fa10a585bed4','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
		end
		-------------------------


END

IF(@CurrentDBName = @DBName_Staging)
BEGIN

	Update app.[user] set login = 'admin_staging',[Password] = 'f225999720b317e32fa0ffac27b84269' where login = 'admin_acore'
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowDebugInCalc', 'AllowBackshopFF','AllowBackshopPIKPrincipal','AllowFFDeleteFromM61andBackshop','AllowWFInternalNotification','AllowYieldConfigData','AllowDrawFeeAMEmail','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')
	Update app.appconfig set [Value] = 1 where [key] = 'AllowBasicLogin'
	--======================================================================================
	Print('Set workflow email as mailinator')
	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'cms.trimont.com','mailinator.com') 
	--====================



	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com')
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'statestreet.com','mailinator.com')
	
	Update app.EmailNotification  set EmailID = 'amfinancialcontrols@mailinator.com' where ModuleId=614
	update app.reportfile set [Status]=1 where ReportFileID=10
	--======================================================================================
	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)
	--======================================================================================
	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI
	Truncate table DW.TransactionEntryBI
	Truncate table DW.NotePeriodicCalcBI
	Truncate table DW.InterestCalculatorBI
	Truncate table DW.UwCashflowBI
	Truncate table [DW].[Prod_Cashflow]
	Truncate table [DW].[Prod_TransactionEntry]
	Truncate table [DW].[Prod_NoteFunding]
	Truncate table [DW].[Prod_DealFundingSchdule]
	Truncate table [DW].[Staging_Cashflow]
	Truncate table [DW].[Staging_TransactionEntry]
	Truncate table [DW].[Staging_NoteFunding]
	Truncate table [DW].[Staging_DealFundingSchdule]
	Truncate table [DW].[Staging_Note]

	--Truncate table CRE.DailyInterestAccruals
	Truncate table DW.DailyInterestAccrualsBI
	Truncate table CRE.TransactionEntryClose
	Truncate table [DW].Staging_IntegartionCashFlowBI

	Truncate table CRE.DailyGAAPBasisComponents		
	Truncate table DW.InterestCalculatorBI	
	--==========================
	--IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'usp_DeltaJob')
	--	DROP PROCEDURE [DW].[usp_DeltaJob]
	--IF EXISTS(SELECT ROUTINE_NAME  FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_NAME = 'usp_DeltaJobBS')
	--	DROP PROCEDURE [DW].[usp_DeltaJobBS]
	--========================================


	if exists (select * from sys.objects where name = 'LatestNoteFunding' and type = 'u')
		drop table  [CRE].[LatestNoteFunding]

	CREATE TABLE [CRE].[LatestNoteFunding] (
	NoteID UNIQUEIDENTIFIER   NULL,
	CRENoteID nvarchar(256) null,
	TransactionDate Date null,
	Amount decimal(28,15)  NULL,
	WireConfirm bit null,
	PurposeBI nvarchar(256) null,
	DrawFundingID nvarchar(256) null,
	Comments nvarchar(max) null,
	CreatedBy 	nvarchar(256) NULL,
	CreatedDate 	datetime ,
	UpdatedBy 	nvarchar(256) NULL,
	UpdatedDate 	datetime 
	);


	CREATE INDEX iStaging_LatestNoteFunding_NoteID ON [CRE].[LatestNoteFunding] (NoteID,CRENoteID)

	INSERT INTO [CRE].[LatestNoteFunding]
			   ([NoteID]
			   ,[CRENoteID]
			   ,[TransactionDate]
			   ,[WireConfirm]
			   ,[PurposeBI]
			   ,[Amount]
			   ,[DrawFundingID]
			   ,[Comments]
			   ,[CreatedBy]
				,[CreatedDate]
				,[UpdatedBy] 
				,[UpdatedDate] )

	Select  
	n.NoteID
	,n.crenoteid as crenoteid
	,fs.[Date] as [TransactionDate]
	,fs.Applied as [WireConfirm]
	,LPurposeID.Name as [PurposeBI]
	,fs.Value as [Amount]
	,fs.DrawFundingId as [DrawFundingID]
	,fs.Comments as [Comments]
	,fs.[CreatedBy]
	,fs.[CreatedDate]
	,fs.[UpdatedBy] 
	,fs.[UpdatedDate] 
	from CORE.FundingSchedule fs
	INNER JOIN CORE.Event e on e.EventID = fs.EventId
	INNER JOIN 
				(
						
					Select 
						(Select AccountID from CORE.Account ac where ac.AccountID = ns.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
						from CORE.Event eve
						INNER JOIN CRE.Note ns ON ns.Account_AccountID = eve.AccountID
						INNER JOIN CORE.Account acc ON acc.AccountID = ns.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
						--and ns.NoteID = @NoteId  
						and acc.IsDeleted = 0
						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
						GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID

				) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [Core].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID
	INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	--==============================================================
	Print ('DB Refresh Staging - Done')

	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)

	Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
	Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
	Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

	Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

	Update app.appconfig set [value] = 0 where [key] = 'StopV1NoteCalculation'
END

IF(@CurrentDBName = @DBName_Dev)
BEGIN
    --Update login in app.[user] table
	Update app.[user] set login = 'admin_dev',[Password] = 'f225999720b317e32fa0ffac27b84269' where login in ( 'admin_staging', 'admin_acore', 'admin_integration')

	Delete from app.EmailNotification where EmailId like '%acorecapital.com%'
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowDebugInCalc', 'AllowBackshopFF','AllowBackshopPIKPrincipal','AllowFFDeleteFromM61andBackshop','AllowWFInternalNotification','AllowYieldConfigData','AllowDrawFeeAMEmail','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')
	update app.reportfile set [Status]=1 where ReportFileID=10
	Update app.appconfig set [Value] = 1 where [key] = 'AllowBasicLogin'
	--================================================
	delete from app.emailnotification  where moduleid in (606,617,552,614)
	--first draw approver
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,606,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,606 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=606
	)

	--Tier 1 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,617,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,617 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=617
	)

	--Tier 2 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,552,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,552 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=552
	)



	if not exists(select 1 from app.EmailNotification where Emailid='amfinancialcontrols@acorecapital.com' and ModuleId=614)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'amfinancialcontrols@acorecapital.com',614,1

	delete from app.emailnotification  where Emailid='ar@acorecapital.com'

	if not exists(select 1 from app.EmailNotification where Emailid='ar@mailinator.com' and ModuleId=703)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'ar@mailinator.com',703,1
	--===============================================================================================


	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com')
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'statestreet.com','mailinator.com')
	
	Update app.EmailNotification  set EmailID = 'amfinancialcontrols@mailinator.com' where ModuleId=614
	Update app.[user] set password = 'f225999720b317e32fa0ffac27b84269' where login in ('pam', 'sam', 'amo', 'tier1', 'tier2')
	Update [CRE].[Servicer] set EmailID = 'missing@mailinator.com' where EmailID is null
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'cms.trimont.com','mailinator.com') 



	Delete from app.EmailNotification where moduleid = 363
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',363,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',363,1)


	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)


	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI

	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)

	Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
	Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
	Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

	Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

	Update app.appconfig set [value] = 1 where [key] = 'StopV1NoteCalculation'
END

IF(@CurrentDBName = @DBName_Alpha)
BEGIN
	---======================================================

	Update app.[user] set login = 'admin_alpha',[Password] = 'f225999720b317e32fa0ffac27b84269' where login in ('admin_integration','admin_acore','admin_qa')
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowDebugInCalc', 'AllowBackshopFF','AllowBackshopPIKPrincipal','AllowFFDeleteFromM61andBackshop','AllowWFInternalNotification','AllowYieldConfigData','AllowDrawFeeAMEmail','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')

	Delete from app.[Emailnotification] where emailid = '%acoreaccounting%'

	Update app.[user] set Password = 'f225999720b317e32fa0ffac27b84269'
	Update app.[User] set password = '222599db8c68e283343c3a7266d27220',email = 'cbansal@hvantage.com' where login = 'cbansal'
	Update app.[User] set password = 'ad9f83a1e44cf23570efc379e0268f00',email = 'rmundhra@hvantage.com' where login = 'rmundhra'
	Update app.[User] set password = '0ff5ee49cabfbd9831418a0c2fe4c9fb',email = 'pjain@hvantage.com' where login = 'hbotuser'
	Update app.[User] set password = 'dcbcba8d2a5c39d5bb4d67a8d6e86b8c',email = 'asaxena@hvantage.com' where login = 'asaxena'

	Update app.EmailNotification set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update app.[user] set email = Replace(Email,'acorecapital.com','mailinator.com')

	Update app.EmailNotification set EmailID = Replace(EmailID,'statestreet.com','mailinator.com') 
	Update app.[user] set email = Replace(Email,'statestreet.com','mailinator.com')
	

	Update app.[user] set [Password] = '8cf119d3deb242fc73bc25c226443b54' where [Login] = 'admin_qa'

	update app.reportfile set [Status]=1 where ReportFileID=10

	--============================================

	GRANT EXECUTE ON OBJECT::	usp_SaveDealSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetRateSpreadRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteAmortScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteFeeCouponSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteDealFundingByDealIDSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteFundingRepaymentSequenceSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteNoteDataSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteNoteFundingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePIKScheduleDetailSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePrepayScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteRateSpreadScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetAmortRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetDealFundingRecordSetSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetNotePayrulRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetNoteRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetPrepayRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertAmortScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertDealFundingNoteDataSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertFeeCouponStripReceivableSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertFundingRepaymentSequenceSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertNoteFundingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertNoteSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPIKScheduleDetailSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPrepayAndAdditionalFeeScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertRateSpreadScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteDealDataSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetFundingScheduleRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetPayruleSetupRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPayruleSetupSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePayruleSetupByDealIDSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertDealFundingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetDealFundingRecordSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeletePIKScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetPIKScheduleRecordSetSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertPIKScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertLiborAndMaturityScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertUserNotificationSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertStrippingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetStrippingScheduleSet	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_DeleteStrippingScheduleSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_CheckDuplicateDealSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetDealRecordSetSizer	   to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetFundingRepaymentSequenceRecordSetSizer  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	[App].usp_AddUpdateObject  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	[dbo].usp_AuthenticateUserSizer  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetSizerDocumentsRecordSet  to sizer_ModifyQA 
	GRANT EXECUTE ON OBJECT::	usp_DeleteSizerDocuments  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_InsertIntoSizerDocumentsNote  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_GetAllLookupsSizer  to sizer_ModifyQA
	GRANT EXECUTE ON OBJECT::	usp_UpdateNoteExtenstionSizer  to sizer_ModifyQA

	--================================
	Print('Remove client email from workflow')
	truncate  TABLE [CRE].[WFNotificationMasterEmail]
	INSERT INTO [CRE].[WFNotificationMasterEmail](ClientID,ParentClient,LookupID,EmailID) Values(1,'Delphi Financial',604,'capitalcall@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 1,'Delphi Financial',605,'capitalcall@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 2,'TRE ACR',604,'treacrfundingdraw@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 2,'TRE ACR',605,'treacrfundingdraw@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 2,'TRE ACR',607,'treacrfundingdraw@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 5,'ACORE Credit IV',604,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 5,'ACORE Credit IV',605,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 6,'ACORE Credit IV - Offshore',604,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 6,'ACORE Credit IV - Offshore',605,'fundingdrawaciv@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 8,'Delphi Fixed',604,'capitalcall@mailinator.com')
	INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,ParentClient,LookupID,EmailID) Values( 8,'Delphi Fixed',605,'capitalcall@mailinator.com')

	Update [CRE].[Servicer] set EmailID = 'missing@mailinator.com' 
	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'cms.trimont.com','mailinator.com') 

	--=====================================================================


	Truncate table cre.WFNotificationMasterEmail

	--Prelim and Final
	INSERT INTO cre.WFNotificationMasterEmail (ClientID,LookupID,ParentClient)
	Select ClientID,LookupID,ParentClient from(
	Select Distinct ParentClient, ClientID,tbl.lookupid
	from cre.FinancingSourceMaster fm 
	left join cre.client c on c.clientname = Replace(fm.ParentClient,'AFLAC US','AFLAC')
	,(Select 604 as lookupid Union ALL Select 605 as lookupid) as tbl
	where PArentClient is not null
	)a

	Update cre.WFNotificationMasterEmail set EmailID = 'missing@mailinator.com'
	Update cre.WFNotificationMasterEmail set EmailID = 'fundingdrawaciv@mailinator.com' where ParentClient =  'ACORE Credit IV'
	Update cre.WFNotificationMasterEmail set EmailID = 'fundingdrawaciv@mailinator.com' where ParentClient =  'ACORE Credit IV - Offshore'
	Update cre.WFNotificationMasterEmail set EmailID = 'capitalcall@mailinator.com' where ParentClient =  'Delphi Financial'
	Update cre.WFNotificationMasterEmail set EmailID = 'capitalcall@mailinator.com' where ParentClient =  'Delphi Fixed'
	Update cre.WFNotificationMasterEmail set EmailID = 'treacrfundingdraw@mailinator.com' where ParentClient =  'TRE ACR'
	Update cre.WFNotificationMasterEmail set EmailID = 'treacrfundingdraw@mailinator.com' where ParentClient =  'AFLAC US'


	--Consolidate
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='ar@mailinator.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'ar@mailinator.com','TRE ACR')
	END
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='ababbitt@mailinator.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'ababbitt@mailinator.com','TRE ACR')
	END
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='igai@mailinator.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'igai@mailinator.com','TRE ACR')
	END
	if not exists(select 1 from [CRE].[WFNotificationMasterEmail] where emailid='rsahu@hvantage.com' and LookupID=607 and ClientID=2)
	BEGIN
		INSERT INTO [CRE].[WFNotificationMasterEmail] (ClientID,LookupID,EmailID,ParentClient)
		Values(2,607,'rsahu@hvantage.com','TRE ACR')
	END

	--===============================================================================================

	delete from app.emailnotification  where moduleid in (606,617,552,614)
	--first draw approver
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,606,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,606 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=606
	)

	--Tier 1 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,617,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,617 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=617
	)

	--Tier 2 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,552,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,552 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=552
	)



	if not exists(select 1 from app.EmailNotification where Emailid='amfinancialcontrols@acorecapital.com' and ModuleId=614)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'amfinancialcontrols@acorecapital.com',614,1


	delete from app.emailnotification  where Emailid='ar@acorecapital.com'

	if not exists(select 1 from app.EmailNotification where Emailid='ar@mailinator.com' and ModuleId=703)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'ar@mailinator.com',703,1


	Update app.EmailNotification set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update app.EmailNotification set EmailID = Replace(EmailID,'statestreet.com','mailinator.com') 
	

	Delete from app.EmailNotification where moduleid = 363
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',363,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',363,1)


	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)
	--===============================================================


	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI
	Truncate table DW.TransactionEntryBI
	Truncate table DW.NotePeriodicCalcBI
	Truncate table DW.InterestCalculatorBI
	Truncate table DW.UwCashflowBI
	Truncate table [DW].[Prod_Cashflow]
	Truncate table [DW].[Prod_TransactionEntry]
	Truncate table [DW].[Prod_NoteFunding]
	Truncate table [DW].[Prod_DealFundingSchdule]
	Truncate table [DW].[Staging_Cashflow]
	Truncate table [DW].[Staging_TransactionEntry]
	Truncate table [DW].[Staging_NoteFunding]
	Truncate table [DW].[Staging_DealFundingSchdule]
	Truncate table [DW].[Staging_Note]
	Truncate table DW.DailyInterestAccrualsBI
	Truncate table [DW].Staging_IntegartionCashFlowBI
	Truncate table DW.AdditionalFee_BalanceBI
	Truncate table DW.AnalysisBI
	Truncate table DW.BackshopCommitmentAdjBI
	Truncate table DW.BackshopCurrentBalanceBI
	Truncate table DW.BackshopDealFundingBI
	Truncate table DW.BackshopNoteBI
	Truncate table DW.BackshopNoteFundingBI
	Truncate table DW.BerkadiaDataTap
	Truncate table DW.BSNoteFundingBI
	Truncate table DW.CalendarBI
	Truncate table DW.CalendarPeriodBI
	Truncate table DW.DailyCalcBI
	Truncate table DW.DailyInterestAccrualsBI
	Truncate table DW.DealBI
	Truncate table DW.DealFundingSchduleBI
	Truncate table DW.DealMatrixBI
	Truncate table DW.DropDateSampleData
	Truncate table DW.EventBasedBalanceBI
	Truncate table DW.ExceptionsBI
	Truncate table DW.FeeBaseAmountDeterminationBI
	Truncate table DW.FeeFunctionsDefinitionBI
	Truncate table DW.FeeScheduleBI
	Truncate table DW.FullAccUnpaidInterest_Interim1BI
	Truncate table DW.FundingSequencesBI
	Truncate table DW.InterestCalculatorBI
	Truncate table DW.InterimDropDateBI
	Truncate table DW.L_BackshopCurrentBalanceBI
	Truncate table DW.L_BSNoteFundingBI
	Truncate table DW.L_DailyCalcBI
	Truncate table DW.L_DailyInterestAccrualsBI
	Truncate table DW.L_DealBI
	Truncate table DW.L_DealFundingSchduleBI
	Truncate table DW.L_ExceptionsBI
	Truncate table DW.L_FundingSequencesBI
	Truncate table DW.L_InterestCalculatorBI
	Truncate table DW.L_NoteBI
	Truncate table DW.L_NoteFundingBI
	Truncate table DW.L_NoteFundingScheduleBI
	Truncate table DW.L_NoteMatrixBI
	Truncate table DW.L_NotePeriodicCalcBI
	Truncate table DW.L_NoteTransactionDetailBI
	Truncate table DW.L_PropertyBI
	Truncate table DW.L_RateSpreadScheduleBI
	Truncate table DW.L_TransactionBI
	Truncate table DW.L_TransactionEntryBI
	Truncate table DW.L_UwCashflowBI
	Truncate table DW.L_UwDealBI
	Truncate table DW.L_UwNoteBI
	Truncate table DW.L_UwNoteCommitmentAdjustmentBI
	Truncate table DW.L_UwNoteFundingBI
	Truncate table DW.L_UwPropertyBI
	Truncate table DW.L_WFCheckListDetailBI
	Truncate table DW.L_WFTaskDetailBI
	Truncate table DW.L_WorkFlowBI
	Truncate table DW.NoteBI
	Truncate table DW.NoteFundingBI
	Truncate table DW.NoteFundingScheduleBI
	Truncate table DW.NoteMatrixBI
	Truncate table DW.NoteMatrixBI_Delphi
	Truncate table DW.NoteMatrixBI_Test
	Truncate table DW.NoteMatrixBI_TestAcoreIV
	Truncate table DW.NotePeriodicCalcBI
	Truncate table DW.NotePeriodicCalcByEntityBI
	Truncate table DW.NoteTranchePercentageBI
	Truncate table DW.NoteTransactionDetailBI
	Truncate table DW.PowerBILog
	Truncate table DW.Prod_Cashflow
	Truncate table DW.Prod_DealFundingSchdule
	Truncate table DW.Prod_NoteFunding
	Truncate table DW.Prod_TransactionEntry
	Truncate table DW.PropertyBI
	Truncate table DW.RateSpreadScheduleBI
	Truncate table DW.ReconciliationDetailBI
	Truncate table DW.ServicingBalanceBI
	Truncate table DW.ServicingTransactionBI
	Truncate table DW.Staging_Cashflow
	Truncate table DW.Staging_DealFundingSchdule
	Truncate table DW.Staging_IntegartionCashFlowBI
	Truncate table DW.Staging_Note
	Truncate table DW.Staging_NoteFunding
	Truncate table DW.Staging_TransactionEntry
	Truncate table DW.TransactionBI
	Truncate table DW.TransactionByEntityBI
	Truncate table DW.TransactionEntryBI
	Truncate table DW.TransactionEntryPivotBI
	Truncate table DW.UwCashflowBI
	Truncate table DW.UwDealBI
	Truncate table DW.UwNoteBI
	Truncate table DW.UwNoteCommitmentAdjustmentBI
	Truncate table DW.UwNoteFundingBI
	Truncate table DW.UwPropertyBI
	Truncate table DW.WellsDataTap
	Truncate table DW.WFCheckListDetailBI
	Truncate table DW.WFTaskDetailBI

	--Truncate table CRE.DailyInterestAccruals
	Truncate table CRE.TransactionEntryClose
	--Truncate table CRE.TransactionEntry
	--Truncate table CRE.NotePeriodicCalc

	

	Print ('Truncate warehouse table data')
	Print ('DB Refresh Alpha - Done')

	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)

	Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
	Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
	Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

	Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

	Update app.appconfig set [value] = 1 where [key] = 'StopV1NoteCalculation'
END

IF(@CurrentDBName = @DBName_PIKMode)
BEGIN
    --Update login in app.[user] table
	Update app.[user] set login = 'admin_pik',[Password] = 'f225999720b317e32fa0ffac27b84269' where login in ( 'admin_integration','admin_staging', 'admin_acore')
	Delete from app.EmailNotification where EmailId like '%acorecapital.com%'
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowDebugInCalc', 'AllowBackshopFF','AllowBackshopPIKPrincipal','AllowFFDeleteFromM61andBackshop','AllowWFInternalNotification','AllowYieldConfigData','AllowDrawFeeAMEmail','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')
	update app.reportfile set [Status]=1 where ReportFileID=10
	Update app.appconfig set [Value] = 1 where [key] = 'AllowBasicLogin'
	--================================================
	delete from app.emailnotification  where moduleid in (606,617,552,614)
	--first draw approver
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,606,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,606 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=606
	)

	--Tier 1 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,617,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,617 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=617
	)

	--Tier 2 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,552,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,552 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=552
	)



	if not exists(select 1 from app.EmailNotification where Emailid='amfinancialcontrols@acorecapital.com' and ModuleId=614)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'amfinancialcontrols@acorecapital.com',614,1


	delete from app.emailnotification  where Emailid='ar@acorecapital.com'

	if not exists(select 1 from app.EmailNotification where Emailid='ar@mailinator.com' and ModuleId=703)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'ar@mailinator.com',703,1
	--===============================================================================================

	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com')
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'statestreet.com','mailinator.com')
	
	Update app.EmailNotification  set EmailID = 'amfinancialcontrols@mailinator.com' where ModuleId=614
	Update app.[user] set password = 'f225999720b317e32fa0ffac27b84269' where login in ('pam', 'sam', 'amo', 'tier1', 'tier2')
	Update [CRE].[Servicer] set EmailID = 'missing@mailinator.com' where EmailID is null


	Delete from app.EmailNotification where moduleid = 363
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',363,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',363,1)


	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)


	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI

	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)

	Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
	Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
	Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

	Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

	Update app.appconfig set [value] = 1 where [key] = 'StopV1NoteCalculation'
END




IF(@CurrentDBName = @DBName_Demo)
BEGIN
    --Update login in app.[user] table
	Update app.[user] set login = 'admin_demo' where login in ( 'admin_integration','admin_staging', 'admin_acore', 'admin_dev')
	Delete from app.EmailNotification where EmailId like '%acorecapital.com%'
	Update app.appconfig set [Value] = 0 where [Key] in ('AllowDebugInCalc', 'AllowBackshopFF','AllowBackshopPIKPrincipal','AllowFFDeleteFromM61andBackshop','AllowWFInternalNotification','AllowYieldConfigData','AllowDrawFeeAMEmail','AllowDealAutomation','UseDynamicsForInvoice','CalculateXIRRAfterDealSave')
	update app.reportfile set [Status]=1 where ReportFileID=10

	Update app.[user] set [Password] = 'f225999720b317e32fa0ffac27b84269' where [login] = 'admin_demo'
	Update app.appconfig set [Value] = 1 where [key] = 'AllowBasicLogin'
	--================================================
	delete from app.emailnotification  where moduleid in (606,617,552,614)
	--first draw approver
	insert into app.emailnotification (EmailId,ModuleId,Status) 
	select Email,606,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,606 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=606
	)

	--Tier 1 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,617,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,617 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=617
	)

	--Tier 2 users
	insert into app.emailnotification (EmailId,ModuleId,Status)
	select Email,552,1 from app.[user]  where firstname+' '+lastname in 
	(
	'Adele Fairman','JD Swenson','Jessica Yan','David Homsher'
	)
	and email not in 
	(
	 select emailid from app.emailnotification e join 
	 (select Email,552 moduleid,1 [status] from app.[user]  where firstname+' '+lastname in 
		(
		'Adele Fairman','JD Swenson','Jessica Yan','David Homsher','Jason Records','Catherine Laster','Justin Boone'
		)) tbl on e.emailid=tbl.email and e.moduleid=552
	)



	if not exists(select 1 from app.EmailNotification where Emailid='amfinancialcontrols@acorecapital.com' and ModuleId=614)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'amfinancialcontrols@acorecapital.com',614,1


	delete from app.emailnotification  where Emailid='ar@acorecapital.com'

	if not exists(select 1 from app.EmailNotification where Emailid='ar@mailinator.com' and ModuleId=703)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'ar@mailinator.com',703,1
	--===============================================================================================

	Update [CRE].[Servicer] set EmailID = 'Trimontfundingnotice@mailinator.com' where ServicerName = 'Wells Fargo Bank'
	Update [CRE].[Servicer] set EmailID = 'Berkadiafundingnotice@mailinator.com,sgnotices@mailinator.com,donna.reif@mailinator.com' where ServicerName = 'Berkadia Commercial Mortgage'
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com') 
	Update [CRE].[Servicer] set EmailID = Replace(EmailID,'cms.trimont.com','mailinator.com') 



	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'acorecapital.com','mailinator.com')
	Update cre.WFNotificationMasterEmail set EmailID = Replace(EmailID,'statestreet.com','mailinator.com')
	
	Update app.EmailNotification  set EmailID = 'amfinancialcontrols@mailinator.com' where ModuleId=614
	Update app.[user] set password = 'f225999720b317e32fa0ffac27b84269' where login in ('pam', 'sam', 'amo', 'tier1', 'tier2')
	Update [CRE].[Servicer] set EmailID = 'missing@mailinator.com' where EmailID is null


	Delete from app.EmailNotification where moduleid = 363
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',363,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',363,1)


	Delete from App.Emailnotification where  moduleid = 632
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('vbalapure@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',632,1)
	INSERT INTO app.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',632,1)


	Truncate table DW.TransactionByEntityBI
	Truncate table DW.NotePeriodicCalcByEntityBI

	Update [App].[UserRoleMap] Set RoleID = 'AAEE9C2A-6ADF-40D4-AECD-2E2C3B6645AB '
	Where UserID in (
		Select UserID from app.[user] Where login in ('PAM','SAM','AMO','tier1','tier2')
	)

	Update cre.InvoiceDetail set Email1= 'rsahu@mailinator.com'
	Update [App].[AppConfig] set [value] = 0 where [Key] = 'AllowSponsorDetailFromBackshop'
	Update core.AnalysisParameter set AllowCalcAlongWithDefault = 4 where analysisid <> 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

	Update app.EmailNotification set EmailID = Replace(EmailID,'berkadia.com','mailinator.com') where EmailID like '%berkadia%'

	Update app.appconfig set [value] = 1 where [key] = 'StopV1NoteCalculation'
END


