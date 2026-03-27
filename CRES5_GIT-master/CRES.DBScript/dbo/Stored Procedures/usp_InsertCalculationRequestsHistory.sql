
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
n.NoteId,
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
cr.DealID,
RequestID,
CalcType 
from [Core].[CalculationRequests] cr
Inner join cre.Note n on n.Account_AccountID = cr.AccountId




END
GO

