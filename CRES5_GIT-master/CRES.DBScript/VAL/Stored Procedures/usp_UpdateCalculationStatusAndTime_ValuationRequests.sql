CREATE PROCEDURE [VAL].[usp_UpdateCalculationStatusAndTime_ValuationRequests] 
@MarkedDate date,
@ValuationRequestsID int,
@DealID nvarchar(256),
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX),
@UpdatedBy nvarchar(256)
 
AS
BEGIN
 

Declare @Query AS NVARCHAR(MAX)

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


Declare @MarkedDateMasterID int;
SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)




Declare @L_DealID UNIQUEIDENTIFIER = (Select DealID from cre.Deal where credealid = @DealID)


IF(@ColumnName = 'EndTime')
BEGIN
	update val.valuationrequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	EndTime = getdate() ,
	ErrorMessage=@ErrorMessage,
	UpdatedBy = @UpdatedBy,
	UpdatedDate = getdate()
	where DealID=@L_DealID and MarkedDateMasterID = @MarkedDateMasterID
END


IF(@ColumnName = 'StartTime')
BEGIN
	update val.valuationrequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	StartTime = getdate() ,	
	UpdatedBy = @UpdatedBy,
	UpdatedDate = getdate()
	where DealID=@L_DealID and MarkedDateMasterID = @MarkedDateMasterID
END



--Declare @NumberOfRetries int = (Select top 1 [Value] from app.appconfig where [Key] = 'NumberOfCalculationRetries_valuation')

--IF EXISTS(Select DealID from  val.valuationrequests Where DealID=@L_DealID and MarkedDateMasterID = @MarkedDateMasterID and NumberOfRetries = @NumberOfRetries)
--BEGIN
--	Update val.valuationrequests
--	set ErrorMessage = 'Note failed to calculate, forcefully closed after 3 retries: ' + ErrorMessage
--	where NumberOfRetries = @NumberOfRetries 
--	and DealID=@L_DealID and MarkedDateMasterID = @MarkedDateMasterID
--	and StatusID = 265 ---failed
--END



 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

