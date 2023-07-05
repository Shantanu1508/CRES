CREATE Procedure [dbo].[usp_CalculateNoteByCRENoteID]

@crenoteid nvarchar(MAX),
@AnalysisID  nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;

if(@crenoteid<>'')
BEGIN
	
	CREATE TABLE #tblListNotes(
	  CRENoteID VARCHAR(256)
	)
	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@crenoteid);
END;

 
Declare @UpdatedBy UNIQUEIDENTIFIER
 
SET @UpdatedBy = 'B0E6697B-3534-4C09-BE0A-04473401AB93'
declare @TableTypeCalculationRequests TableTypeCalculationRequests

INSERT INTO @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
Select NoteId,'Processing',@UpdatedBy,'Batch',@AnalysisID ,775 as CalcType
From Cre.Note where crenoteid in (select CRENoteID from #tblListNotes)


exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy 
	 
End
