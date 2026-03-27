CREATE Procedure [dbo].[usp_CalculateAllNotes]

@AnalysisID  nvarchar(256),
@UpdatedBy nvarchar(256)

AS
BEGIN
	SET NOCOUNT ON;
 
declare @TableTypeCalculationRequests TableTypeCalculationRequests

INSERT INTO @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
  SELECT
			   distinct n.[NoteId],'Processing',@UpdatedBy,'Batch',@AnalysisID,775 as CalcType
			  from  CRE.Note n		 
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID			  
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )			 
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')

--que all loans for calculation
exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy, NULL, NULL, 'Scenario'

	 
End
