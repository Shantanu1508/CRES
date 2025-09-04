CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusAndTime_CalculationRequests] 
@CalculationRequestID uniqueidentifier,
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX),
@UpdatedBy nvarchar(256)
 
AS
BEGIN
 

Declare @Query AS NVARCHAR(MAX)

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

IF(@ColumnName = 'EndTime')
BEGIN
	update core.CalculationRequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	EndTime = getdate() ,
	ErrorMessage=@ErrorMessage
	where CalculationRequestID=@CalculationRequestID 
	and CalcType = 853
END


IF(@ColumnName = 'StartTime')
BEGIN
	update core.CalculationRequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	StartTime = getdate()
	where CalculationRequestID=@CalculationRequestID 
	and CalcType = 853
END



 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

