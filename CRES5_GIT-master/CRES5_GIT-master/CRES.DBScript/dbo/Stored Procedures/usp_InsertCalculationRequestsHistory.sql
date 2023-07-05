
CREATE PROCEDURE [dbo].[usp_InsertCalculationRequestsHistory] 
AS
BEGIN

    SET NOCOUNT ON;


Declare @BatchID int = 0;
SET @BatchID = (Select ISNULL(MAX(BatchID),0) from [Core].[CalculationRequestsHistory] )

INSERT INTO [Core].[CalculationRequestsHistory](
BatchID,
BatchDate,
CalculationRequestID,
NoteId,
RequestTime,
StatusID,
UserName,
ApplicationID,
StartTime,
EndTime,
ServerName,
PriorityID,
ErrorMessage,
ErrorDetails,
ServerIndex,
AnalysisID,
CalculationModeID,
CalcBatch,
NumberOfRetries,
DealID,
RequestID,
CalcType
)
Select 
(@BatchID + 1) as BatchID,
getdate() as BatchDate,
CalculationRequestID,
NoteId,
RequestTime,
StatusID,
UserName,
ApplicationID,
StartTime,
EndTime,
ServerName,
PriorityID,
ErrorMessage,
ErrorDetails,
ServerIndex,
AnalysisID,
CalculationModeID,
CalcBatch,
NumberOfRetries,
DealID,
RequestID,
CalcType 
from [Core].[CalculationRequests] 




END
GO

