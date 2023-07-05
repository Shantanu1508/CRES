
CREATE PROCEDURE [dbo].[usp_PIKNoteInCalculation] 
	@calculationRequest [TableTypeCalculationRequests] READONLY,   
	@CreatedBy nvarchar(256)
AS
BEGIN

DECLARE @PIK_Source_Target_Note TABLE
	(
		SourceNoteID UNIQUEIDENTIFIER,
		TargetNoteID UNIQUEIDENTIFIER
	)

	INSERT INTO @PIK_Source_Target_Note(SourceNoteID,TargetNoteID)
	Select 
	sourceNote.NoteID as SourceNoteID,
	DestNote.NoteID as TargetNoteID

	--MainNote.NoteID as MainNoteID,
	--sourceNote.NoteID as SourceNoteID,
	--DestNote.NoteID as TargetNoteID,
	--MainNote.CreNoteID as MainNote,
	--sourceNote.CRENoteID as sourceNote,
	--DestNote.CRENoteID as DestNote
	from [CORE].PikSchedule pik
	inner JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID
	inner JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId
	INNER JOIN 
				(
						
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PikSchedule')
						and acc.IsDeleted = 0
						--and n.CRENoteID = '1459'  
						GROUP BY n.Account_AccountID,EventTypeID
				) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	inner JOIN [CORE].[Account] MainAcc ON MainAcc.AccountID = e.AccountID
	inner JOIN [CRE].[Note] sourceNote ON sourceNote.Account_AccountID = pik.SourceAccountID
	inner JOIN [CRE].[Note] DestNote ON DestNote.Account_AccountID = pik.TargetAccountID
	inner JOIN [CRE].[Note] MainNote ON MainNote.Account_AccountID = MainAcc.AccountID

	where pik.SourceAccountID is not null or pik.TargetAccountID is not null

--Select SourceNoteID,TargetNoteID from @PIK_Source_Target_Note
	


-----Insert into calculation manager---------------------------------
declare @cashflowEngineId int;

Select @cashflowEngineId=lookupid from core.Lookup where ParentID=47 and Name='Default'
Declare @lookupidProcessing int = (SELECT LookupID from core.Lookup where Name='Processing' and ParentID=40);


Declare @cnt int;
SELECT @cnt = COUNT(n.[NoteId])
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.NoteId=cr.NoteId
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId
			  left join Core.Lookup l ON cr.[StatusID]=l.LookupID
			  left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
			  left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null) and ac.isdeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')
			 and CalcType = 775


--check when user select all notes for calculator
IF(@cnt = (Select COUNT(DISTINCT NoteId) from @calculationRequest ))	
BEGIN
	---update status of child note as Dependent in CalculationRequests table if it inserted before parent
	update Core.CalculationRequests
	set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') 
	where NoteId in (Select TargetNoteID from @PIK_Source_Target_Note)
	and CalcType = 775

END
ELSE
BEGIN
	
	DECLARE @NoteId UNIQUEIDENTIFIER, 
	@existingId UNIQUEIDENTIFIER;

	IF CURSOR_STATUS('global','CursorNoteCR')>=-1    
	BEGIN    
	DEALLOCATE CursorNoteCR    
	END    
 
	DECLARE CursorNoteCR CURSOR     
	FOR    
	(    
		Select Distinct SourceNoteID from @PIK_Source_Target_Note
	)
	OPEN CursorNoteCR     
	FETCH NEXT FROM CursorNoteCR    
	INTO @NoteId
	WHILE @@FETCH_STATUS = 0    
	BEGIN 

	SET @existingId = (SELECT top 1 CalculationRequestID FROM Core.CalculationRequests WHERE NoteID = @NoteID AND StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Failed','Completed')) and CalcType = 775)

	IF @existingId IS NULL 
	BEGIN
	--IF not is 'Failed'/'Completed'

	--Delete note as well as its child note
	Delete from Core.CalculationRequests where NoteId= @NoteId and StatusID in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Failed','Completed')) and CalcType = 775
	Delete from Core.CalculationRequests where NoteId in (Select TargetNoteID from @PIK_Source_Target_Note where SourceNoteID = @NoteID) and CalcType = 775


	--Insert parent note
	INSERT INTO Core.CalculationRequests(NoteId,RequestTime,StatusID,UserName,ApplicationID,PriorityID,CalcType) 
	select @NoteId as SourceNoteID,getdate(),@lookupidProcessing as StatusID,@CreatedBy,null as ApplicationID,null as PriorityID  ,775
	
	UNION

	--Insert child note if not in calculation request table
	select  distinct TargetNoteID
	,getdate()
	,(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') 
	,@CreatedBy
	,null ApplicationID
	,null
	,775
	from @PIK_Source_Target_Note where SourceNoteID= @NoteId 
	and TargetNoteID not in (select NoteID from Core.CalculationRequests where StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Running')) and CalcType = 775)


	---update status of child note as Dependent in CalculationRequests table if it inserted before parent
	update Core.CalculationRequests
	set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') 
	where NoteId in (Select TargetNoteID from @PIK_Source_Target_Note where SourceNoteID = @NoteID)
	and CalcType = 775


	END

	FETCH NEXT FROM CursorNoteCR    
	INTO @NoteId

	END  
END


END
