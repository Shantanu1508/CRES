CREATE PROCEDURE [dbo].[usp_InsertUpdateAmortSchedule_New]   
 @notefunding [TableTypeAmortSchedule] READONLY,  
 @CreatedBy nvarchar(256),  
 @UpdatedBy nvarchar(256)
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


-------========      
truncate table dbo.[tblAM]      
INSERT INTO dbo.tblAM (NoteID,Value,Date,AccountId,DealAmortScheduleRowno)
Select NoteID,Value,Date,AccountId,DealAmortScheduleRowno from @notefunding
 
-------======== 



Declare @AmortSchedule  int = 19; 
DECLARE @Active int = 1
DECLARE @Inactive int = 2 

Declare @dealid UNIQUEIDENTIFIER = (Select top 1 dealid from cre.note where noteid in (Select Distinct NoteID from @notefunding ))



IF OBJECT_ID('tempdb..#tblnotefunding') IS NOT NULL               
DROP TABLE #tblnotefunding             
              
create table #tblnotefunding          
(     
 NoteID UNIQUEIDENTIFIER NULL,  
 AccountId nvarchar(MAX) NULL,
 ClosingDate Date null,
 EventID UNIQUEIDENTIFIER NULL,
 Curr_EffectiveDate [date] NULL, 
 Date [date] NULL,  
 Value [decimal](28, 12) NULL,   
 CreatedBy	nvarchar(256) null, 
 CreatedDate	Date null,
 UpdatedBy	nvarchar(256) null, 
 UpdatedDate Date null,   
 DealAmortScheduleRowno [int] NULL, 
 DiffCount int null,
 MinChangedDate date null,
) 

INSERT INTO #tblnotefunding(noteid,AccountID,ClosingDate,EventId,Curr_EffectiveDate,Date,Value,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,DealAmortScheduleRowno,DiffCount,MinChangedDate)

Select ff.noteid,n.Account_AccountID,n.ClosingDate,latestSche.EventId,latestSche.EffectiveStartDate, ff.Date
,ff.Value as [Value], @CreatedBy CreatedBy, GETDATE() as  CreatedDate,@UpdatedBy UpdatedBy,GETDATE() as UpdatedDate,ff.DealAmortScheduleRowno,0 as DiffCount,null as MinChangedDate
from @notefunding ff
Inner join cre.note n on n.noteid = ff.noteid
left Join (
	Select noteid,accountid,EventID,EffectiveStartDate
	From(
		Select n.noteid,eve.accountid,eve.EventID,eve.EffectiveStartDate,ROW_NUMBER() over (Partition by n.noteid order by eve.EffectiveStartDate desc) rowno
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = @AmortSchedule and acc.IsDeleted = 0 and eve.StatusID = 1
		and n.Dealid = @dealid
	)a Where a.rowno = 1
)latestSche on latestSche.NoteID = n.NoteID
where [Value] <> 0
---=========================================================
--Check Diff in Data


IF OBJECT_ID('tempdb..#tblChangedRecordSet') IS NOT NULL               
DROP TABLE #tblChangedRecordSet             
              
create table #tblChangedRecordSet          
(     
 NoteID UNIQUEIDENTIFIER NULL,  
 DiffCnt int NULL,  
 MInChanDate Date NULL,   
)

INSERT INTO #tblChangedRecordSet(NoteID,DiffCnt,MInChanDate)
Select noteid,count(Date) as DiffCnt,MIN(Date) as MInChanDate
From(
	Select noteid,Date,Value from #tblnotefunding

	EXCEPT

	Select n.noteid,fs.Date,fs.Value
	from [CORE].AmortSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN (						
		Select 
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = @AmortSchedule
		and acc.IsDeleted = 0	and eve.StatusID = 1
		and n.Dealid = @dealid
		GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
)a
group by noteid


Update #tblnotefunding set #tblnotefunding.DiffCount = z.DiffCnt ,#tblnotefunding.MinChangedDate = z.MInChanDate
From(
	Select NoteID,DiffCnt,MInChanDate from #tblChangedRecordSet
)z
Where #tblnotefunding.noteid = z.noteid
--======================================

---Update MinChangedDate to ClosingDate if MinChangedDate < ClosingDate
Update #tblnotefunding set MinChangedDate = ClosingDate where MinChangedDate < ClosingDate and DiffCount > 1


--Select DISTINCT nf.NoteId,nf.AccountId ,nf.ClosingDate from #tblnotefunding nf 	

--============Cursor Start================
DECLARE @NoteId UNIQUEIDENTIFIER    
DECLARE @AccountId UNIQUEIDENTIFIER  
DECLARE @ClosingDate Date 
DECLARE @EventID UNIQUEIDENTIFIER
DECLARE @Curr_EffectiveDate Date
DECLARE @DiffCount int
DECLARE @ChangeDate Date
  
  

IF CURSOR_STATUS('global','CursorNoteFF')>=-1      
BEGIN      
DEALLOCATE CursorNoteFF      
END      
   
DECLARE CursorNoteFF CURSOR       
FOR      
(      
	Select DISTINCT nf.NoteId,nf.AccountId ,nf.ClosingDate,nf.EventID,nf.Curr_EffectiveDate,nf.DiffCount,nf.MinChangedDate from #tblnotefunding nf 	
)  
OPEN CursorNoteFF       
FETCH NEXT FROM CursorNoteFF      
INTO @NoteId,@AccountId ,@ClosingDate,@EventID,@Curr_EffectiveDate,@DiffCount,@ChangeDate
WHILE @@FETCH_STATUS = 0      
BEGIN  

	--=================================
	IF(@DiffCount > 0)  
	BEGIN  
		PRINT('Difference in FF detail');     
		DECLARE @PreviousmonthEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate)-1, -1));  
		DECLARE @ChangeDateEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate) - 1, -1)); --Previous month EOD  
    
		IF(@ChangeDate > (select DATEADD(MONTH, DATEDIFF(MONTH, -1, getdate())-1, -1)))  
		BEGIN  
			SET @PreviousmonthEOD  = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, getdate())-1, -1));  
			SET @ChangeDateEOD = @PreviousmonthEOD  
		END  
  
  
		IF(@Curr_EffectiveDate is not null)  
		BEGIN  
			PRINT('EffectiveDate Exit');  
  
			--Main logic start  
			DECLARE @maxEffectiveDate date = @Curr_EffectiveDate
			
			SET @ChangeDateEOD = @ChangeDate			
  
			IF(@ChangeDateEOD <= @maxEffectiveDate)  
			BEGIN    
				Update [Core].[Event] set StatusID = @Inactive Where eventtypeid = @AmortSchedule and EffectiveStartDate > @ChangeDateEOD and accountid = @AccountId  
  
				Print('Change Date <= Max EffectiveDate');       
  
				IF(@Curr_EffectiveDate = @ChangeDateEOD)  
				BEGIN       
					Print('Effective ChangeDate exist');  
					Delete from CORE.AmortSchedule where eventid  = @EventID 		
					
					INSERT INTO core.AmortSchedule (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DealAmortScheduleRowno)  
					SELECT @EventID, t.Date, t.Value, t.CreatedBy,GETDATE(), t.UpdatedBy, GETDATE(),t.DealAmortScheduleRowno
					FROM #tblnotefunding t 		
					WHERE t.noteid = @NoteId 

				END  
				ELSE  
				BEGIN  
					Print('Effective ChangeDate not exist');  
  
					DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)  
					Declare @EveID uniqueidentifier;  
					Delete from @tEvent  
  
					INSERT INTO [Core].[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[EffectiveEndDate],[SingleEventValue],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])  
					OUTPUT inserted.EventID INTO @tEvent(tEventID)  
					Select @ChangeDateEOD,@AccountId,GETDATE(),@AmortSchedule,NUll,NUll,1,@CreatedBy,getdate(),@UpdatedBy,getdate()    
					
					SELECT @EveID = tEventID FROM @tEvent;  
  
					INSERT INTO core.AmortSchedule (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DealAmortScheduleRowno)  
					SELECT @EveID, t.Date, t.Value, t.CreatedBy,GETDATE(), t.UpdatedBy, GETDATE(),t.DealAmortScheduleRowno
					FROM #tblnotefunding t 		
					WHERE t.noteid = @NoteId 
								 
				END   
			END  
			ELSE  
			BEGIN  
				Print('Change Date > Max EffectiveDate');  
  
				IF(@maxEffectiveDate = @PreviousmonthEOD )--or @PreviousmonthEOD is null  
				BEGIN  
					Print('Scedule for same month');       
					Delete from CORE.AmortSchedule where eventid  = @EventID 	
					
					INSERT INTO core.AmortSchedule (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DealAmortScheduleRowno)  
					SELECT @EventID, t.Date, t.Value, t.CreatedBy,GETDATE(), t.UpdatedBy, GETDATE(),t.DealAmortScheduleRowno
					FROM #tblnotefunding t 		
					WHERE t.noteid = @NoteId
				
				END  
				ELSE  
				BEGIN  
					Print('Scedule for diff month');  
  
					DECLARE @tEvent1 TABLE (tEventID1 UNIQUEIDENTIFIER)  
					Declare @EveID1 uniqueidentifier;  
					Delete from @tEvent1  
  
					INSERT INTO [Core].[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[EffectiveEndDate],[SingleEventValue],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])  
					OUTPUT inserted.EventID INTO @tEvent1(tEventID1) 
					Select @PreviousmonthEOD,@AccountId,GETDATE(),@AmortSchedule,NUll,NUll,1,@CreatedBy,getdate(),@UpdatedBy,getdate() 
      
					SELECT @EveID1 = tEventID1 FROM @tEvent1;  
  
					INSERT INTO core.AmortSchedule (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DealAmortScheduleRowno)  
					SELECT @EveID1, t.Date, t.Value, t.CreatedBy,GETDATE(), t.UpdatedBy, GETDATE(),t.DealAmortScheduleRowno
					FROM #tblnotefunding t 		
					WHERE t.noteid = @NoteId
  
				END  
			END      
		END  
		ELSE  
		BEGIN   
			PRINT('No funding schedule found - Insert'); 
			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)  
			Declare @EveID2 uniqueidentifier;  
			Delete from @tEvent2
  
			INSERT INTO [Core].[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[EffectiveEndDate],[SingleEventValue],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])  
			OUTPUT inserted.EventID INTO @tEvent2(tEventID2) 
			Select isnull(@ClosingDate,@PreviousmonthEOD),@AccountId,GETDATE(),@AmortSchedule,NUll,NUll,1,@CreatedBy,getdate(),@UpdatedBy,getdate() 
      
			SELECT @EveID2 = tEventID2 FROM @tEvent2;  
  
			INSERT INTO core.AmortSchedule (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DealAmortScheduleRowno)  
			SELECT @EveID2, t.Date, t.Value, t.CreatedBy,GETDATE(), t.UpdatedBy, GETDATE(),t.DealAmortScheduleRowno
			FROM #tblnotefunding t 		
			WHERE t.noteid = @NoteId

			
		END       
	END  
	ELSE  
	BEGIN  
		Print('No Chnages');
		Delete from CORE.AmortSchedule where eventid  = @EventID 
		
		INSERT INTO core.AmortSchedule (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DealAmortScheduleRowno)  
		SELECT @EventID, t.Date, t.Value, t.CreatedBy,GETDATE(), t.UpdatedBy, GETDATE(),t.DealAmortScheduleRowno
		FROM #tblnotefunding t 		
		WHERE t.noteid = @NoteId

	END 


	--=================================
FETCH NEXT FROM CursorNoteFF      
INTO @NoteId,@AccountId ,@ClosingDate,@EventID,@Curr_EffectiveDate,@DiffCount,@ChangeDate
END  




SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
