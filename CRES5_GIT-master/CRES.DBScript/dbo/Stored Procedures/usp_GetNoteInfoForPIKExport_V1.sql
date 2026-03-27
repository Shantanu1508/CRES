-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_GetNoteInfoForPIKExport_V1]  --'e07aba8c-4723-4c82-b1d5-77f7f584ad95'
	@noteid UNIQUEIDENTIFIER 
AS

 BEGIN
  	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @value nvarchar(10);
	SET @value = (Select Cast([Value] as nvarchar(10)) from app.appconfig where [key] = 'AllowBackshopPIKPrincipal')


	Select n.noteid,n.dealid,@value as AllowBackshopPIKPrincipal 
	from cre.note n
	Inner join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and n.noteid = @noteid



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED	 
 END
GO

