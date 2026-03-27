CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusAndTime_XIRRCalculationRequests] 
@XIRRCalculationRequestsID int,
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX),
@UpdatedBy nvarchar(256)
 
AS
BEGIN
 

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


IF(@ColumnName = 'EndTime')
BEGIN
	update [CRE].[XIRRCalculationRequests] set 
	[Status] = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	EndTime = getdate() ,
	ErrorMessage=@ErrorMessage,
	UpdatedBy = @UpdatedBy,
	UpdatedDate = getdate()
	where XIRRCalculationRequestsID = @XIRRCalculationRequestsID
END


IF(@ColumnName = 'StartTime')
BEGIN
	update [CRE].[XIRRCalculationRequests] set 
	[Status] = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	StartTime = getdate() ,	
	UpdatedBy = @UpdatedBy,
	UpdatedDate = getdate()
	where XIRRCalculationRequestsID = @XIRRCalculationRequestsID
END



 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

