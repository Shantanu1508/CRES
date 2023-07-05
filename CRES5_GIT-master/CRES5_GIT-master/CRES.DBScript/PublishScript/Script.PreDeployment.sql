/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

Print('Start Pre Deployment Script')
Print('This is Master Branch')

:r .\DBRefresh\DBRefresh_Common.sql



--:r .\DBRefresh\$(DBRefreshFileName).sql
--IF((SELECT DB_NAME()) = 'CRES4_QA')
--BEGIN
--    exec usp_DBRefresh_QA
--END
--IF((SELECT DB_NAME()) = 'CRES4_Integration')
--BEGIN
--    exec usp_DBRefresh_Integration
--END
--IF((SELECT DB_NAME()) = 'CRES4_Staging')
--BEGIN
--    exec usp_DBRefresh_Staging
--END


Print('End Pre Deployment Script')