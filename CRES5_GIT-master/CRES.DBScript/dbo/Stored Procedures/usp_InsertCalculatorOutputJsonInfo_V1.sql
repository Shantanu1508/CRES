
-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertCalculatorOutputJsonInfo_V1] 
(
	@RequestID nvarchar(256), 	
	@UserID UNIQUEIDENTIFIER,
	@FileName nvarchar(256),
	@FileType varchar(20)
)
AS
BEGIN
     SET NOCOUNT ON; 

declare @analysisID UNIQUEIDENTIFIER;
declare @CalculationRequestID UNIQUEIDENTIFIER;
declare @Noteid UNIQUEIDENTIFIER;


Select top 1 @analysisID = analysisID ,@CalculationRequestID = CalculationRequestID,@Noteid = Noteid
from core.CalculationRequests where RequestID = @RequestID
and CalcType = 775


INSERT INTO [Core].[CalculatorOutputJsonInfo]
           (RequestID
		   ,CalculationRequestID
		   ,Noteid
		   ,analysisID
           ,[FileName]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,FileType)
     VALUES
           (@RequestID,
		    @CalculationRequestID,
		   @Noteid,
		   @analysisID,
		   @FileName,
		   @UserID,
		   getdate(),
		   @UserID,
		   getdate(),
		   @FileType)



END






