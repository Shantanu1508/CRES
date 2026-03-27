CREATE Procedure [dbo].[usp_CalculateDealByCREDealID]

	@creDealid nvarchar(MAX),
	@AnalysisID  nvarchar(MAX)

AS
BEGIN
	SET NOCOUNT ON;

	IF(@creDealid<>'')
	BEGIN
		CREATE TABLE #tblListDeals(
			CREDealID VARCHAR(256)
		)
		INSERT INTO #tblListDeals(CREDealID)
		select Value from fn_Split(@creDealid);

		CREATE TABLE #tblListNotes(
			CRENoteID VARCHAR(256)
		)
		INSERT INTO #tblListNotes(CRENoteID)
		Select CreNoteID from Cre.Note Where DealID in (Select Distinct D.DealID from Cre.Deal D INNER JOIN #tblListDeals TD ON D.CREDealID = TD.CREDealID)
	END;

	Declare @UpdatedBy UNIQUEIDENTIFIER
 
	SET @UpdatedBy = 'B0E6697B-3534-4C09-BE0A-04473401AB93'
	declare @TableTypeCalculationRequests TableTypeCalculationRequests

	INSERT INTO @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
	Select NoteId,'Processing',@UpdatedBy,'Batch',@AnalysisID ,775 as CalcType
	From Cre.Note where crenoteid in (select CRENoteID from #tblListNotes)

	EXEC [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy , NULL, NULL, 'Deal'
	 
End