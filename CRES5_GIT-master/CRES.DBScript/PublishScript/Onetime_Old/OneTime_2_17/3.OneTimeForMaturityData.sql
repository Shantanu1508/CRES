


Print('Update StatusID = 1 in Maturity table')
go

Update CORE.[event] set StatusID = 1 where [EventTypeID] = 11 



GO

Print('One time for Maturity table')
Go
IF OBJECT_ID('tempdb..#tblevent') IS NOT NULL       
	DROP TABLE #tblevent
CREATE TABLE #tblevent
(
	EventId uniqueidentifier,
	MaturityDate Date null,
	MaturityType int null,
	Approved int null	
) 


Declare @NoteID UNIQUEIDENTIFIER;
Declare @EventID UNIQUEIDENTIFIER;

IF CURSOR_STATUS('global','CursorMat')>=-1
BEGIN
	DEALLOCATE CursorMat
END

DECLARE CursorMat CURSOR 
for
(
	Select n.noteid,e.EventId
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
	INNER JOIN [CRE].[Deal] d on d.dealid = n.dealid
	where acc.isdeleted <> 1
	--and d.dealname = 'The Post'
	--and n.crenoteid = '2567'
)
OPEN CursorMat 
FETCH NEXT FROM CursorMat
INTO @NoteID,@EventID

WHILE @@FETCH_STATUS = 0
BEGIN
	--===============================
	INSERT INTO #tblevent(EventId,MaturityDate,MaturityType,Approved)
	
	Select EventId,MaturityDate,MaturityType,Approved
	From(
		Select @EventID as EventId,mat.SelectedMaturityDate as MaturityDate,708 as MaturityType,3 as Approved		
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
		where acc.isdeleted <> 1
		and mat.eventid = @EventID
		and n.noteid = @NoteID

		UNION ALL

		Select @EventID as EventId,MaturityDate,MaturityType,Approved
		From(
			Select NoteId,ExtendedMaturityScenario1 as MaturityDate,709 as MaturityType ,(CASE WHEN ExtendedMaturityScenario1 <= CAST(getdate() as Date) THEN 3 ELSE 4 END) as Approved
			from cre.note Where noteid = @NoteID
			
			UNION ALL
			
			Select NoteId,ExtendedMaturityScenario2 as MaturityDate,709 as MaturityType ,(CASE WHEN ExtendedMaturityScenario2 <= CAST(getdate() as Date) THEN 3 ELSE 4 END) as Approved
			from cre.note Where noteid = @NoteID
			
			UNION ALL

			Select NoteId,ExtendedMaturityScenario3 as MaturityDate,709 as MaturityType ,(CASE WHEN ExtendedMaturityScenario3 <= CAST(getdate() as Date) THEN 3 ELSE 4 END) as Approved
			from cre.note Where noteid = @NoteID
			
			UNION ALL

			Select NoteId,FullyExtendedMaturityDate as MaturityDate,710 as MaturityType,3 as Approved from cre.note Where noteid = @NoteID

		)a where MaturityDate is not null
	)z
	--===============================				 
FETCH NEXT FROM CursorMat
INTO @NoteID,@EventID
END
CLOSE CursorMat   
DEALLOCATE CursorMat


Update core.Maturity  SET core.Maturity.MaturityDate = a.MaturityDate,
core.Maturity.MaturityType = a.MaturityType,
core.Maturity.Approved = a.Approved
From(
	Select EventId,MaturityDate,MaturityType,Approved, 'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy, getdate() CreatedDate,'B0E6697B-3534-4C09-BE0A-04473401AB93' UpdatedBy,getdate() UpdatedDate 
	from #tblevent where MaturityType = 708
)a
Where core.Maturity.EventID = a.EventId and core.Maturity.SelectedMaturityDate is not NULL


INSERT INTO core.Maturity (EventId,MaturityDate,MaturityType,Approved, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
Select EventId,MaturityDate,MaturityType,Approved, 'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy, getdate() CreatedDate,'B0E6697B-3534-4C09-BE0A-04473401AB93' UpdatedBy,getdate() UpdatedDate 
from #tblevent where MaturityType <> 708





go


--Update core.Maturity set 
--core.Maturity.ActualPayoffDate =  z.ActualPayoffDate,
--core.Maturity.ExpectedMaturityDate =  z.ExpectedMaturityDate,
--core.Maturity.OpenPrepaymentDate =  z.OpenPrepaymentDate	
--From(
--	Select Distinct n.crenoteid,e.EventId,n.ActualPayoffDate,n.ExpectedMaturityDate,n.OpenPrepaymentDate	
--	from [CORE].Maturity mat  
--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
--	where acc.isdeleted <> 1
--	--and n.crenoteid = '10021'
--)z
--where z.EventId = core.Maturity.EventId