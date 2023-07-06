
-- Procedure
CREATE PROCEDURE [dbo].[usp_GetCalculatorOutputJsonInfo] 
(
	@CalculationRequestID UNIQUEIDENTIFIER, 
	@NoteId UNIQUEIDENTIFIER, 
	@AnalysisID UNIQUEIDENTIFIER, 
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON; 

SELECT [CalculatorOutputJsonInfoID]
      ,[CalculationRequestID]
      ,[NoteId]
      ,[AnalysisID]
      ,[FileName]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [Core].[CalculatorOutputJsonInfo] 
  where CalculationRequestID = @CalculationRequestID 
  and NoteId = @NoteId 
  and  AnalysisID = @AnalysisID 


END




