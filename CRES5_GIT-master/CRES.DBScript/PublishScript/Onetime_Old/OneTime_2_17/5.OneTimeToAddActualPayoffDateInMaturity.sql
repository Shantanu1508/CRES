
GO

--Print('Move Actual Pay Off date in Maturity table')
Go

--IF OBJECT_ID('tempdb..#tblevent') IS NOT NULL       
--	DROP TABLE #tblevent
--CREATE TABLE #tblevent
--(
--	EventId uniqueidentifier,
--	MaturityDate Date null,
--	MaturityType int null,
--	Approved int null	
--) 


--Declare @NoteID UNIQUEIDENTIFIER;
--Declare @EventID UNIQUEIDENTIFIER;

--IF CURSOR_STATUS('global','CursorMat')>=-1
--BEGIN
--	DEALLOCATE CursorMat
--END

--DECLARE CursorMat CURSOR 
--for
--(
--	Select Distinct n.noteid,e.EventId
--	from [CORE].Maturity mat  
--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
--	INNER JOIN [CRE].[Deal] d on d.dealid = n.dealid
--	where acc.isdeleted <> 1
--	--and d.dealname = 'The Post'
--	--and n.crenoteid = '2567'
--)
--OPEN CursorMat 
--FETCH NEXT FROM CursorMat
--INTO @NoteID,@EventID

--WHILE @@FETCH_STATUS = 0
--BEGIN
--	--===============================
--	INSERT INTO #tblevent(EventId,MaturityDate,MaturityType,Approved)
	
--	Select EventId,MaturityDate,MaturityType,Approved
--	From(		
--		Select @EventID as EventId,MaturityDate,MaturityType,Approved
--		From(
--			Select NoteId,ActualPayoffDate as MaturityDate,711 as MaturityType ,null as Approved
--			from cre.note Where noteid = @NoteID
			
--			UNION ALL
			
--			Select NoteId,ExpectedMaturityDate as MaturityDate,712 as MaturityType ,null as Approved
--			from cre.note Where noteid = @NoteID
			
--			UNION ALL

--			Select NoteId,OpenPrepaymentDate as MaturityDate,713 as MaturityType ,null as Approved
--			from cre.note Where noteid = @NoteID
--		)a where MaturityDate is not null
--	)z
--	--===============================				 
--FETCH NEXT FROM CursorMat
--INTO @NoteID,@EventID
--END
--CLOSE CursorMat   
--DEALLOCATE CursorMat


--INSERT INTO core.Maturity (EventId,MaturityDate,MaturityType,Approved, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--Select EventId,MaturityDate,MaturityType,Approved, 'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy, getdate() CreatedDate,'B0E6697B-3534-4C09-BE0A-04473401AB93' UpdatedBy,getdate() UpdatedDate 
--from #tblevent 


