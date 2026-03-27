

CREATE PROCEDURE [dbo].[usp_InsertUpdateMaturitySchedule] 
	@tblMaturityDataForNote [TableTypeMaturityDataForNote] READONLY,	
	@UserID nvarchar(256)
AS
BEGIN



Update cre.Note SET 
cre.Note.ActualPayoffDate = a.[ActualPayoffDate],
cre.Note.ExpectedMaturityDate = a.ExpectedMaturityDate,
cre.Note.OpenPrepaymentDate = a.OpenPrepaymentDate
From(
	Select distinct noteid,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate from @tblMaturityDataForNote
)a
Where cre.Note.NoteId = a.NoteId 


------update ActualPayoffDate
--Update cre.Note SET 
--cre.Note.ActualPayoffDate = a.[ActualPayoffDate]
--From(
--	Select Distinct noteid ,MaturityDate as [ActualPayoffDate] from @tblMaturityDataForNote where MaturityType  = 711
--)a
--Where a.NoteId = cre.Note.NoteId

------update ExpectedMaturityDate
--Update cre.Note SET cre.Note.ExpectedMaturityDate = a.[ExpectedMaturityDate]
--From(
--	Select Distinct noteid ,MaturityDate as [ExpectedMaturityDate] from @tblMaturityDataForNote where MaturityType  = 712
--)a
--Where a.NoteId = cre.Note.NoteId

------update OpenPrepaymentDate
--Update cre.Note SET cre.Note.OpenPrepaymentDate = a.[OpenPrepaymentDate]
--From(
--	Select Distinct noteid ,MaturityDate as [OpenPrepaymentDate] from @tblMaturityDataForNote where MaturityType  = 713
--)a
--Where a.NoteId = cre.Note.NoteId



-----Update ActualPayOffDate in note table
--Update cre.Note SET 
----cre.note.SelectedMaturityDate = a.InitialMaturity,
----cre.note.FullyExtendedMaturityDate = a.FullyExtendedMaturityDate,
--cre.Note.ActualPayoffDate = a.[ActualPayoffDate],
--cre.Note.ExpectedMaturityDate = a.[ExpectedMaturityDate],
--cre.Note.OpenPrepaymentDate = a.[OpenPrepaymentDate]
--From(
--	Select noteid,[ActualPayoffDate],[ExpectedMaturityDate],[OpenPrepaymentDate]   ---[InitialMaturity],[FullyExtendedMaturityDate],
--	From(
--		Select  n.noteid,
--		(CASE 
--			--WHEN t.MaturityType = 708 THEN 'InitialMaturity' 
--			--WHEN t.MaturityType = 710 THEN 'FullyExtendedMaturityDate' 
--			WHEN t.MaturityType = 711 THEN 'ActualPayoffDate' 
--			WHEN t.MaturityType = 712 THEN 'ExpectedMaturityDate' 
--			WHEN t.MaturityType = 713 THEN 'OpenPrepaymentDate' 
--		END
--		) as  MaturityType,t.MaturityDate
--		from @tblMaturityDataForNote t
--		inner join cre.Note n on n.noteid = t.NoteID		
--	) AS SourceTable  
--	PIVOT  
--	(  
--		MIN(MaturityDate)  
--		FOR MaturityType IN ([ActualPayoffDate],[ExpectedMaturityDate],[OpenPrepaymentDate])   --[InitialMaturity],[FullyExtendedMaturityDate],
--	) AS PivotTable
--)a
--Where a.NoteId = cre.Note.NoteId
----------------------------------------------




IF OBJECT_ID('tempdb..#tblMaturityDataForNote') IS NOT NULL       
	DROP TABLE #tblMaturityDataForNote

CREATE TAble [dbo].[#tblMaturityDataForNote](
	NoteID uniqueidentifier,	
	EffectiveDate date,		
	MaturityDate Date null,
	MaturityType int null,
	Approved int null,
	IsDeleted bit null,
	ExtensionType int
	--Old_ActualPayOffDate date null,
);

INSERT INTO [dbo].[#tblMaturityDataForNote](NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ExtensionType)  --,Old_ActualPayOffDate
Select t.NoteID,t.EffectiveDate,t.MaturityDate,t.MaturityType,t.Approved,t.IsDeleted,t.ExtensionType  ---,n.ActualPayoffDate as Old_ActualPayOffDate
From @tblMaturityDataForNote t
inner join cre.Note n on n.noteid = t.NoteID
where (t.MaturityType not in (711,712,713) and NULLIF(t.MaturityType,'') is not null)




--==========================
Declare @maturity int = 11
DECLARE @NoteId UNIQUEIDENTIFIER  
DECLARE @AccountId UNIQUEIDENTIFIER
DECLARE @EffectiveDate Date
DECLARE @ClosingDate Date

--DECLARE @Old_ActualPayOffDate Date
--DECLARE @New_ActualPayOffDate Date






IF CURSOR_STATUS('global','CursorNoteMat')>=-1    
BEGIN    
DEALLOCATE CursorNoteMat    
END    
 
DECLARE CursorNoteMat CURSOR     
FOR    
(    
	--Select DISTINCT nf.NoteID,acc.AccountID,ClosingDate,ISNULL(N.ActualPayOffDate,EffectiveDate) as EffectiveDate
	--from @tblMaturityDataForNote nf 
	--INNER JOIN CRE.Note N ON N.nOTEid=NF.NoteID 
	--Inner Join core.account acc on acc.accountid = n.account_accountid
	--where acc.isdeleted <> 1 and n.ClosingDate is not null

	Select DISTINCT nf.NoteID,acc.AccountID,n.ClosingDate,nf.EffectiveDate  ---ISNULL(N.ActualPayOffDate,EffectiveDate) as EffectiveDate  ---,nf.Old_ActualPayOffDate,n.ActualPayOffDate as New_ActualPayOffDate
	from [dbo].[#tblMaturityDataForNote] nf 
	INNER JOIN CRE.Note N ON N.nOTEid=NF.NoteID 
	Inner Join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1 and n.ClosingDate is not null and EffectiveDate is not null
)
OPEN CursorNoteMat     
FETCH NEXT FROM CursorNoteMat    
INTO @NoteId,@AccountId,@ClosingDate,@EffectiveDate   ---,@Old_ActualPayOffDate,@New_ActualPayOffDate
WHILE @@FETCH_STATUS = 0    
BEGIN 

	--IF(@Old_ActualPayOffDate is not null and @New_ActualPayOffDate is not null)
	--BEGIN
	--	IF(@Old_ActualPayOffDate <> @New_ActualPayOffDate)
	--	BEGIN
	--		DECLARE @eventid2 UNIQUEIDENTIFIER = (Select top 1 eventid from CORE.Event where eventtypeid = @maturity and EffectiveStartDate = @Old_ActualPayOffDate and accountid = @AccountId );   --and StatusID = @Active   
	--		Delete from CORE.Maturity where eventid = @eventid2
	--		Delete from CORE.Event where eventid = @eventid2	
	--	END		
	--END
	
	IF(@EffectiveDate < @ClosingDate)
	BEGIN
		SET @EffectiveDate = @ClosingDate
	END


	Update [Core].[Event] set StatusID = 2 Where eventtypeid = @maturity and EffectiveStartDate > @EffectiveDate and accountid = @AccountId  

	Declare @LatestEffectiveDate date;     
	
	SET @LatestEffectiveDate = (
			Select MAX(EffectiveStartDate) 
			from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11
			and n.NoteID = @NoteId
			and acc.IsDeleted <> 1
			and eve.StatusID = 1
			GROUP BY n.Account_AccountID,EventTypeID  
		)

	IF(@LatestEffectiveDate is null) 
	BEGIN		
		--No maturity Schedule
		DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)      
		Declare @EveID uniqueidentifier;      
		Delete from @tEvent 

		INSERT INTO [Core].[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])      
		OUTPUT inserted.EventID INTO @tEvent(tEventID)      
		Select @ClosingDate,@AccountId,GETDATE() as [Date],@maturity as [EventTypeID],1,@UserID,getdate(),@UserID,getdate()            			
			
		SELECT @EveID = tEventID FROM @tEvent;  

		INSERT INTO core.Maturity (EventId,MaturityDate,MaturityType,Approved, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,ExtensionType)    --ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,
		SELECT @EveID,MaturityDate,MaturityType,Approved,@UserID,getdate(),@UserID,getdate(),ExtensionType   		--ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,
		FROM [dbo].[#tblMaturityDataForNote]
		where NoteId = @NoteId
		and IsDeleted <> 1
	END
	ELSE
	BEGIN
		--Has Maturity
		IF(@EffectiveDate = @LatestEffectiveDate)
		BEGIN
			--Effective Date already exists
			DECLARE @eventid UNIQUEIDENTIFIER = (Select top 1 eventid from CORE.Event where eventtypeid = @maturity and EffectiveStartDate = @EffectiveDate and accountid = @AccountId and StatusID = 1  );   --and StatusID = @Active   
			Delete from CORE.Maturity where eventid = @eventid

			INSERT INTO core.Maturity (EventId,MaturityDate,MaturityType,Approved, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,ExtensionType)		--ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,
			SELECT @eventid,MaturityDate,MaturityType,Approved,@UserID,getdate(),@UserID,getdate() ,ExtensionType  				--ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,
			FROM [dbo].[#tblMaturityDataForNote]
			where NoteId = @NoteId
			and IsDeleted <> 1

		END
		ELSE
		BEGIN
			
			--IF(@EffectiveDate < @LatestEffectiveDate)
			--BEGIN
			--	Update [Core].[Event] set StatusID = 2 Where eventtypeid = @maturity and EffectiveStartDate > @EffectiveDate and accountid = @AccountId       
			--END

			--No maturity Schedule
			DECLARE @tEvent1 TABLE (tEventID1 UNIQUEIDENTIFIER)      
			Declare @EveID1 uniqueidentifier;      
			Delete from @tEvent1

			INSERT INTO [Core].[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])      
			OUTPUT inserted.EventID INTO @tEvent1(tEventID1)      
			Select @EffectiveDate,@AccountId,GETDATE() as [Date],@maturity as [EventTypeID],1,@UserID,getdate(),@UserID,getdate()            			
			
			SELECT @EveID1 = tEventID1 FROM @tEvent1;  

			INSERT INTO core.Maturity (EventId,MaturityDate,MaturityType,Approved, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,ExtensionType)		--ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,
			SELECT @EveID1,MaturityDate,MaturityType,Approved,@UserID,getdate(),@UserID,getdate()   ,ExtensionType					--ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,
			FROM [dbo].[#tblMaturityDataForNote]
			where NoteId = @NoteId
			and IsDeleted <> 1	
					 
		END
	END


			
FETCH NEXT FROM CursorNoteMat    
INTO @NoteId,@AccountId,@ClosingDate,@EffectiveDate  --,@Old_ActualPayOffDate,@New_ActualPayOffDate
END



END
