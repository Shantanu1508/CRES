
CREATE FUNCTION [dbo].[Fn_GetMaturityDateByNoteID] 
(
   @NoteID uniqueidentifier
)
RETURNS date
AS
BEGIN
   DECLARE @Result date 

	--select  @Result = case when n.ActualPayoffDate is not null then n.ActualPayoffDate	
	--				when (select SelectedMaturityDate from core.Maturity where EventID=
	--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))
	--) >getdate() or (n.ExtendedMaturityScenario1 is  null and n.ExtendedMaturityScenario2 is  null and n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null)
	--then  (select SelectedMaturityDate from core.Maturity where EventID=
	--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))
	--)  else
	--case when  n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is  null and n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else
	--case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else
	--case when  n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then  n.ExtendedMaturityScenario3 else
	----case when  n.ExtendedMaturityScenario3 >GETDATE() then  n.FullyExtendedMaturityDate else
	--n.FullyExtendedMaturityDate end  --end
	--end end end 
	--from cre.note n where n.NoteID = @NoteID
    
	

	Select @Result = ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) 
	from cre.note n1
	Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
	Left Join(
		Select noteid,MaturityType,MaturityDate,Approved
		from (
				Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
				ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11
					and n.noteid = @NoteID     
					and acc.IsDeleted = 0  
					and eve.StatusID = 1
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				where n.noteid = @NoteID
				and mat.MaturityDate > getdate()
				and lApproved.name = 'Y'
				and e.StatusID = 1
		)a where a.rno = 1
	)currMat on currMat.noteid = n1.noteid
	where acc1.IsDeleted <> 1
	and n1.noteid = @NoteID

	
	RETURN @Result
END
