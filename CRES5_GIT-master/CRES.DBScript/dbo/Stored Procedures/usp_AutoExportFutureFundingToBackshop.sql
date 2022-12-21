
CREATE PROCEDURE [dbo].[usp_AutoExportFutureFundingToBackshop]  
 
AS  
BEGIN  
 
 SET NOCOUNT ON;  
   

--Called inside [DW].[usp_Calculations_CalendarBI]

	Declare @CRENoteID [nvarchar](MAX)
	Declare @AuditUserName [nvarchar](MAX)

	IF CURSOR_STATUS('global','CursorFF')>=-1
	BEGIN
		DEALLOCATE CursorFF
	END

	DECLARE CursorFF CURSOR 
	for
	(
		Select DISTINCT [CRENoteID],(Select top 1 Login  from app.[user] where FirstName = 'Krishna') as AuditUserName
		from [IO].[out_FutureFunding] where  [Status] = 'ExportFailed' 
	)
	OPEN CursorFF 

	FETCH NEXT FROM CursorFF
	INTO @CRENoteID,@AuditUserName

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		DELETE FROM [IO].[out_FutureFunding] where [CRENoteID] = @CRENoteID
		EXEC [dbo].[usp_ExportFutureFundingToBackshop] @CRENoteID,@AuditUserName

	FETCH NEXT FROM CursorFF
	INTO @CRENoteID,@AuditUserName
	END
	CLOSE CursorFF   
	DEALLOCATE CursorFF



END
