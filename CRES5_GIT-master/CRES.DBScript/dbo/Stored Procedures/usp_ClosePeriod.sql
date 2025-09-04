--[dbo].[usp_ClosePeriod] '21-0647','8/31/2022','C10F3372-0FC2-4861-A9F5-148F1F80804F','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE procedure [dbo].[usp_ClosePeriod] 
@DealIDs nvarchar(max),
@CloseDate Date,
@AnalysisID UNIQUEIDENTIFIER,
@UserID nvarchar(256),
@Comments nvarchar(max),
@Description nvarchar(max) = null
AS

BEGIN

	SET NOCOUNT ON;

Select @AnalysisID = AnalysisID from core.Analysis where Name='Default'



IF OBJECT_ID('tempdb..#tblDealList') IS NOT NULL         
	DROP TABLE #tblDealList

CREATE TABLE #tblDealList(
	CREDealId nvarchar(256)
)
INSERT INTO #tblDealList(CREDealId)
Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|')
---===============================================================

---Delete deal which already closed on CloseDate
Delete From #tblDealList where credealid in (
	Select d.credealid
	from CORE.[Period] p
	Inner join cre.deal d on d.dealid = p.dealid 
	where p.isdeleted <> 1 and d.isdeleted <> 1 
	and p.closedate = @CloseDate and d.credealid in (Select CREDealId From #tblDealList)
)


INSERT INTO [Core].[Period] (DealID,CloseDate,OpenDate,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AnalysisID,[IsDeleted],LastActivityType,Comments,[Description])
Select d.DealID,@CloseDate,NUll,@UserID,getdate(),@UserID,getdate() ,@AnalysisID,0,'Close',@Comments,@Description
From cre.deal d 
where isdeleted <> 1
and d.credealid in (Select CREDealId From #tblDealList)




Set @DealIDs = (select STUFF((SELECT '|' + (CAST(CREDealId as nvarchar(MAX))) 
                From(
                    Select CREDealId From #tblDealList                   
                 )a
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		)



exec  [dbo].[usp_ImportIntoAccountingClosePeriodicArchive] @DealIDs,@CloseDate,@UserID
exec  [dbo].[usp_ImportIntoAccountingCloseTransationArchive] @DealIDs,@CloseDate,@UserID




-----Queue deal in calculation
Declare  @tmpCalcNotes TABLE(Noteid uniqueidentifier )

INSERT INTO  @tmpCalcNotes(Noteid)
SELECT 
Distinct n.[NoteId]	
from  CRE.Note n
left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'
left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
inner join cre.Deal d on n.DealId = d.DealId	
left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
where  
n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
and ac.IsDeleted=0
and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')
and d.credealid in (Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|'))



Declare @L_PriorityText nvarchar(100);
SET @L_PriorityText = 'Real Time'

IF((Select count(noteid) from @tmpCalcNotes) > 10)
BEGIN
	SET @L_PriorityText = 'Batch'
END


declare @TableTypeCalculationRequests TableTypeCalculationRequests
insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
Select Noteid,'Processing',@UserID,@L_PriorityText, 'C10F3372-0FC2-4861-A9F5-148F1F80804F' ,775 as CalcType From @tmpCalcNotes
	
exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UserID,@UserID, NULL, NULL, 'PeriodClose'
----==========================================


END





