
-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertCalculatorOutputJsonInfo] 
(
	@CalculationRequestID UNIQUEIDENTIFIER, 
	@NoteId UNIQUEIDENTIFIER, 
	@AnalysisID UNIQUEIDENTIFIER, 
	@UserID UNIQUEIDENTIFIER,
	@FileName nvarchar(256),
	@FileType varchar(20)
)
AS
BEGIN
     SET NOCOUNT ON; 



INSERT INTO [Core].[CalculatorOutputJsonInfo]
           ([CalculationRequestID]
           ,[NoteId]
           ,[AnalysisID]
           ,[FileName]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,FileType)
     VALUES
           (@CalculationRequestID,
		   @NoteId,
		   @AnalysisID,
		   @FileName,
		   @UserID,
		   getdate(),
		   @UserID,
		   getdate(),
		   @FileType)



END






