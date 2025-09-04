

CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusAndTime_DealSaveAutomation] 
@AutomationRequestsID int,
@DealID uniqueidentifier,
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX),
@UpdatedBy nvarchar(256),
@DealSaveStatus nvarchar(256)
 
AS
BEGIN
 

Declare @Query AS NVARCHAR(MAX)

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

 --declare @StatusFailed int =(Select lookupid from CORE.Lookup where name = 'Failed' and ParentID = 40)
 --declare @StatusProcessing int =(Select lookupid from CORE.Lookup where name = 'Processing' and ParentID = 40)
 --declare @StatusComplete int =(Select lookupid from CORE.Lookup where name = 'Completed' and ParentID = 40)
 


IF(@ColumnName = 'EndTime')
BEGIN
	update Core.AutomationRequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	EndTime = getdate() ,
	ErrorMessage=@ErrorMessage,
	UpdatedBy = @UpdatedBy,
	UpdatedDate = getdate(),
	DealSaveStatus=@DealSaveStatus
	where DealID=@DealID and AutomationRequestsID = @AutomationRequestsID 
END


IF(@ColumnName = 'StartTime')
BEGIN
	update Core.AutomationRequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	StartTime = getdate() ,	
	UpdatedBy = @UpdatedBy,
	UpdatedDate = getdate()
	where DealID=@DealID and AutomationRequestsID = @AutomationRequestsID 
END



 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END

