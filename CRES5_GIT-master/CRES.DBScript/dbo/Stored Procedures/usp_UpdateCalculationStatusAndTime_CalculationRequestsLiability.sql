
CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusAndTime_CalculationRequestsLiability] 
@CalculationRequestsID nvarchar(256),
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX),
@RequestId nvarchar(256),
@CalculationModeID int
AS
BEGIN
 

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
declare @CalculationRequestsID_FeeInterest nvarchar(256)
declare @StatusIDCalcWait nvarchar(256)=(Select lookupid from CORE.Lookup where name = 'CalcWait' and ParentID = 40)
declare @StatusIDProcessing nvarchar(256)=(Select lookupid from CORE.Lookup where name = 'Processing' and ParentID = 40)
declare @AccountID nvarchar(256)=(select AccountId from [Core].[CalculationRequestsLiability] where CalculationRequestID=@CalculationRequestsID)
declare @StatusID int = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40)
declare @StatusIDCalcSubmit nvarchar(256)=(Select lookupid from CORE.Lookup where name = 'CalcSubmit' and ParentID = 40)  

IF (@CalculationModeID=797) --C# (Existing)
BEGIN

IF(@ColumnName = 'EndTime')
BEGIN
	update [Core].[CalculationRequestsLiability] set 
	[StatusID] = @StatusID,
	EndTime = getdate() ,
	ErrorMessage=@ErrorMessage
	where CalculationRequestID = @CalculationRequestsID

	IF(@StatusText='Completed')
	BEGIN
	    update [Core].[CalculationRequestsLiability] set 
		[StatusID] = @StatusIDProcessing
		where AccountId = @AccountID and StatusID=@StatusIDCalcWait
	END
	ELSE
	BEGIN
	 update [Core].[CalculationRequestsLiability] set 
		[StatusID] = @StatusID
		where AccountId = @AccountID and StatusID=@StatusIDCalcWait
	END

END


IF(@ColumnName = 'StartTime')
BEGIN
	update [Core].[CalculationRequestsLiability] set 
	[StatusID] = @StatusID,
	StartTime = getdate() 
	where CalculationRequestID = @CalculationRequestsID
END

END
ELSE --V1 (New)
BEGIN

	if(@StatusText= 'CalcSubmit') 
	begin
   
	  update [Core].[CalculationRequestsLiability] set   
	  [StatusID] = @StatusIDCalcSubmit  ,
	  RequestID=@RequestId
	  where CalculationRequestID  = @CalculationRequestsID 
	end 


   IF(@ColumnName = 'EndTime')
	BEGIN
		update [Core].[CalculationRequestsLiability] set 
		[StatusID] = @StatusID,
		RequestID=@RequestId,
		EndTime = getdate() ,
		ErrorMessage=@ErrorMessage
		where CalculationRequestID = @CalculationRequestsID
	
	END


   IF(@ColumnName = 'StartTime')
	BEGIN
		update [Core].[CalculationRequestsLiability] set 
		[StatusID] = @StatusID,
		StartTime = getdate() 
		where CalculationRequestID = @CalculationRequestsID
	END

END

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

