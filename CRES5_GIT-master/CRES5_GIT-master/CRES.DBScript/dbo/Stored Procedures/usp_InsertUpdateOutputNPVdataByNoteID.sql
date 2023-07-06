
CREATE PROCEDURE [dbo].[usp_InsertUpdateOutputNPVdataByNoteID] 
	@noteAdditinallist tempOutputNPVdata READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN
 

Declare @NoteID UNIQUEIDENTIFIER = (select Top 1 noteid from @noteAdditinallist)


IF Exists(Select * from CRE.OutputNPVdata where NoteID = @NoteID)
BEGIN
	DELETE FROM CRE.OutputNPVdata WHERE NoteID = @NoteID
END


INSERT INTO [CRE].OutputNPVdata
(NoteID
,NPVdate
,CashFlowUsedForLevelYieldPrecap
,CashFlowUsedForLevelYieldAmort
,CashFlowAdjustedForServicingInfo
,TotalStrippedCashFlow
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])

Select 
NoteID
,NPVdate
,CashFlowUsedForLevelYieldPrecap
,CashFlowUsedForLevelYieldAmort
,CashFlowAdjustedForServicingInfo
,TotalStrippedCashFlow
,@CreatedBy
,GETDATE()
,@UpdatedBy
,GETDATE()
From  @noteAdditinallist



END
