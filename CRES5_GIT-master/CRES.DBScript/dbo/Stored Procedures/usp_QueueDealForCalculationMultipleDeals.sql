
CREATE PROCEDURE [dbo].[usp_QueueDealForCalculationMultipleDeals]

 @DealIDs  [nvarchar](MAX) ,
 @UpdatedBy [nvarchar](256) ,
 @AnalysisID nvarchar(256),
 @CalcType int

AS
Begin



	IF OBJECT_ID('tempdb..#tblDealListQueue') IS NOT NULL         
		DROP TABLE #tblDealListQueue

	CREATE TABLE #tblDealListQueue(
		CREDealId nvarchar(256)
	)
	INSERT INTO #tblDealListQueue(CREDealId)
	Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|')
	---===============================================================


	Declare  @tmpCalcNotes TABLE(Noteid uniqueidentifier ,AccountID uniqueidentifier )
	INSERT INTO  @tmpCalcNotes(Noteid,AccountID)
	SELECT 
	Distinct n.[NoteId]	,n.Account_AccountID
	from  CRE.Note n
	left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID=@AnalysisID
	left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	inner join cre.Deal d on n.DealId = d.DealId	
	left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
	where n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
	and ac.IsDeleted=0
	and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')
	and  d.CREDealId in (Select CREDealId From #tblDealListQueue)



	declare @TableTypeCalculationRequests TableTypeCalculationRequests
	insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
	Select Noteid,'Processing',@UpdatedBy,'Batch', @AnalysisID ,@CalcType From @tmpCalcNotes
	
	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy, NULL, NULL, 'Deal'

END

