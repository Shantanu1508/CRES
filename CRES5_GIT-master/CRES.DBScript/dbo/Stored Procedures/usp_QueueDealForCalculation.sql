--[dbo].[usp_QueueDealForCalculation] '4d2ec541-d491-4f06-a5a1-3c0f28a6684b','3bbeac70-f8a0-49ee-906d-1e4d40cd16e7','d0ead735-ba55-45c6-bc53-126cdce6664a'
CREATE PROCEDURE [dbo].[usp_QueueDealForCalculation]

 @DealID  [nvarchar](256) ,
 @UpdatedBy [nvarchar](256) ,
 @AnalysisID nvarchar(256),
 @CalcType int

AS
Begin


	Declare  @tmpCalcNotes TABLE(Noteid uniqueidentifier )
	INSERT INTO  @tmpCalcNotes(Noteid)
			SELECT 
			  Distinct n.[NoteId]	
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID=@AnalysisID
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId	
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')
			 and  d.DealId=@DealID	



	declare @TableTypeCalculationRequests TableTypeCalculationRequests
	insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
	Select Noteid,'Processing',@UpdatedBy,'Real Time', @AnalysisID ,@CalcType From @tmpCalcNotes
	--Select NoteId,'Processing',@UpdatedBy,'Real Time',@AnalysisID From Cre.Note where dealid=@DealID
	
	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy, NULL, NULL, 'Deal'

END


--Select NoteId,* From Cre.Note where dealid='4e74fd6a-cf0e-49d5-a8ae-9c7280a2489f'
