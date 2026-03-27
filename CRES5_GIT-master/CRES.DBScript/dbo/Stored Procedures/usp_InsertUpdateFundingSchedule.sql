--Drop PROCEDURE [dbo].[usp_InsertUpdateFundingSchedule]      
CREATE PROCEDURE [dbo].[usp_InsertUpdateFundingSchedule]       
 @notefunding [TableTypeFundingSchedule] READONLY,      
 @CreatedBy nvarchar(256),      
 @UpdatedBy nvarchar(256),      
 @SavingFromDeal bit = 0
AS      
BEGIN      
      
      
SET NOCOUNT ON;      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      

----------------------------------------------
----Select * into dbo.FFtempVishal from @notefunding

--truncate table [dbo].[TableTypeFundingSchedule_temp]
--INSERT INTO [dbo].[TableTypeFundingSchedule_temp] ([NoteID]  ,[Value] ,[Date] ,[PurposeID] ,[AccountId] ,[Applied],[DrawFundingId] ,[Comments] ,[DealFundingRowno]  ,[isDeleted]  ,[WF_CurrentStatus] ,[GeneratedBy] )
--Select [NoteID]  ,[Value] ,[Date] ,[PurposeID] ,[AccountId] ,[Applied],[DrawFundingId] ,[Comments] ,[DealFundingRowno]  ,[isDeleted]  ,[WF_CurrentStatus] ,[GeneratedBy] 
--from @notefunding


--DECLARE @DealID_temp UNIQUEIDENTIFIER = (Select top 1 dealid from cre.note where noteid in (Select top 1 noteid from @notefunding))   
--delete from dbo.tempFF_Status where dealid = 'e484c0c5-0a6f-4d0f-8bcb-bff9f3282ee1'
--Declare @startdate datetime = getdate()
----------------------------------------------

Declare @DealID_g UNIQUEIDENTIFIER = (Select top 1 n.DealID from @notefunding nf inner join cre.note n on n.noteid = nf.NoteID Where nf.NoteId is not null)

-----=======================================================================================

IF OBJECT_ID('tempdb..#tblnotefundingPrincipalWriteoff') IS NOT NULL                   
DROP TABLE #tblnotefundingPrincipalWriteoff                 
                  
create table #tblnotefundingPrincipalWriteoff              
(         
 NoteID UNIQUEIDENTIFIER NULL,      
 Value [decimal](28, 12) NULL,      
 Date [date] NULL,      
 PurposeID [int] NULL,      
 AccountId nvarchar(MAX) NULL,      
 Applied bit null,    
 AdjustmentType  INT null,  
 DrawFundingId nvarchar(256) null,      
 Comments nvarchar(256) null,      
 [DealFundingRowno] [int] NULL,      
 isDeleted int null,      
 WF_CurrentStatus nvarchar(256) null,     
 ClosingDate Date null   ,
 [GeneratedBy]  int   NULL ,
 DealFundingID UNIQUEIDENTIFIER
)                  
insert into #tblnotefundingPrincipalWriteoff(NoteID,Value,Date,PurposeID,AccountId,Applied,AdjustmentType,DrawFundingId,Comments,[DealFundingRowno],isDeleted,WF_CurrentStatus,ClosingDate,[GeneratedBy],DealFundingID)        
Select nf.NoteID,ISNULL(nf.Value,0) as [Value],nf.Date,nf.PurposeID,n.Account_AccountID as AccountId,nf.Applied,nf.AdjustmentType,nf.DrawFundingId,nf.Comments,nf.[DealFundingRowno],ISNULL(nf.isDeleted,0) as isDeleted,nf.WF_CurrentStatus ,isnull(n.ClosingDate,getdate()) ,nf.GeneratedBy,df.DealFundingID
from @notefunding nf    
Inner join cre.note n on n.NoteID = nf.NoteID   
left join (      
	select Distinct DealFundingID,DealFundingRowno       
	from cre.DealFunding df where dealid = @DealID_g 
	and df.DealFundingRowno is not null      
)df on df.DealFundingRowno = nf.DealFundingRowno  

where nf.[Date] is not null    
and nf.PurposeID = 840

---================================
      
IF OBJECT_ID('tempdb..#tblnotefunding') IS NOT NULL                   
DROP TABLE #tblnotefunding                 
                  
create table #tblnotefunding              
(         
 NoteID UNIQUEIDENTIFIER NULL,      
 Value [decimal](28, 12) NULL,      
 Date [date] NULL,      
 PurposeID [int] NULL,      
 AccountId nvarchar(MAX) NULL,      
 Applied bit null,    
 AdjustmentType  INT null,  
 DrawFundingId nvarchar(256) null,      
 Comments nvarchar(256) null,      
 [DealFundingRowno] [int] NULL,      
 isDeleted int null,      
 WF_CurrentStatus nvarchar(256) null,     
 ClosingDate Date null   ,
 [GeneratedBy]  int   NULL ,
 DealFundingID UNIQUEIDENTIFIER
)                  
insert into #tblnotefunding(NoteID,Value,Date,PurposeID,AccountId,Applied,AdjustmentType,DrawFundingId,Comments,[DealFundingRowno],isDeleted,WF_CurrentStatus,ClosingDate,[GeneratedBy],DealFundingID)        
Select nf.NoteID,ISNULL(nf.Value,0) as [Value],nf.Date,nf.PurposeID,n.Account_AccountID as AccountId,nf.Applied,nf.AdjustmentType,nf.DrawFundingId,nf.Comments,nf.[DealFundingRowno],ISNULL(nf.isDeleted,0) as isDeleted,nf.WF_CurrentStatus ,isnull(n.ClosingDate,getdate()) ,nf.GeneratedBy,df.DealFundingID
from @notefunding nf    
Inner join cre.note n on n.NoteID = nf.NoteID    
left join (      
	select Distinct DealFundingID,DealFundingRowno       
	from cre.DealFunding df where dealid = @DealID_g 
	and df.DealFundingRowno is not null      
)df on df.DealFundingRowno = nf.DealFundingRowno  

where nf.[Date] is not null    
and nf.PurposeID <> 840

     
    
Update #tblnotefunding set [Value] = [Value] + 1 where ISNULL(isDeleted,0) = 1 and [Value] <> 0      
    
delete from #tblnotefunding where ISNULL(isDeleted,0) = 1 and [Value] = 0 --and Noteid = @NoteId     
     
--===============================================================    
IF OBJECT_ID('tempdb..#tblLatest_notefunding') IS NOT NULL                 
DROP TABLE #tblLatest_notefunding       
    
create table #tblLatest_notefunding            
(     
noteid  UNIQUEIDENTIFIER NULL,    
FundingScheduleID UNIQUEIDENTIFIER NULL,    
EventId UNIQUEIDENTIFIER NULL,    
Date [date] NULL,    
Value [decimal](28, 12) NULL,    
PurposeID [int] NULL   ,
Applied bit null
)     
    
INSERT INTO #tblLatest_notefunding(noteid,FundingScheduleID,EventId,Date,Value,PurposeID,Applied)    
Select n.noteid,fs.FundingScheduleID,fs.EventId,fs.Date,fs.Value,fs.PurposeID ,fs.Applied 
from [CORE].FundingSchedule fs    
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId    
INNER JOIN (          
 Select     
 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID    
 from [CORE].[Event] eve    
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
 where EventTypeID = 10    
 and acc.IsDeleted = 0 and eve.StatusID = 1    
 and n.NoteID in (Select Distinct NoteId from #tblnotefunding)    
 GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID    
) sEvent    
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID    
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0   
and fs.PurposeID <> 840
--===============================================================    
    
    
IF not exists(Select NoteId from #tblnotefunding where PurposeID is null)      
begin      
      
      
      
DECLARE @ret_Msg Nvarchar(max);      
      
--Variable's--------------------      
Declare  @FundingSchedule  int  =10;      
 DECLARE @Active int = 1    
DECLARE @Inactive int = 2       
       
DECLARE @NoteId UNIQUEIDENTIFIER        
DECLARE @AccountId UNIQUEIDENTIFIER      
DECLARE @ClosingDate Date     
DECLARE @DealID UNIQUEIDENTIFIER     
      
       
IF CURSOR_STATUS('global','CursorNoteFF')>=-1          
BEGIN          
DEALLOCATE CursorNoteFF          
END          
       
DECLARE CursorNoteFF CURSOR           
FOR          
(          
	Select DISTINCT nf.NoteId,nf.AccountId ,nf.ClosingDate from #tblnotefunding nf  
	UNION
	Select DISTINCT np.NoteId,np.AccountId ,np.ClosingDate from #tblnotefundingPrincipalWriteoff np
)      
OPEN CursorNoteFF           
FETCH NEXT FROM CursorNoteFF          
INTO @NoteId,@AccountId ,@ClosingDate    
WHILE @@FETCH_STATUS = 0          
BEGIN       
      
------------------------------------------------
Declare @New_WireConfirmDate date;
Declare @Old_WireConfirmDate date;
Declare @WireConfirm_CutoffDate date;

SET @New_WireConfirmDate = (Select MAX(DATE) from #tblnotefunding where NoteID = @NoteId and applied = 1)
SET @Old_WireConfirmDate = (Select MAX(DATE) from #tblLatest_notefunding where NoteID = @NoteId and applied = 1)

SET @WireConfirm_CutoffDate = (Select LEAST(@New_WireConfirmDate,@Old_WireConfirmDate))
------------------------------------------------

Declare @Diffcount int;     
      
-------------------------get Diff Count ------------------------    
Select @Diffcount = COUNT(*)    
from     
(Select [Date],[Value],PurposeID from #tblLatest_notefunding where NoteId = @NoteId ---and [Date] >= @WireConfirm_CutoffDate
)as FF    
FULL JOIN (    
 Select [Date],[Value],PurposeID from #tblnotefunding where NoteId = @NoteId and [Date]  is not null  --and [Date] >= @WireConfirm_CutoffDate   
) FFforInput    
ON (FF.Date = FFforInput.Date and ROUND(ff.Value,2) = ROUND(FFforInput.Value,2) )     
--and isnull(ff.PurposeID,'') = isnull(FFforInput.PurposeID ,'')    
WHERE FF.Date IS NULL OR FF.Value IS NULL OR FFforInput.Date IS NULL OR FFforInput.Value IS NULL     
--OR isnull(FF.PurposeID,'') IS NULL OR isnull(FFforInput.PurposeID,'') IS NULL     
    
-------------------------get min date ------------------------    
Declare @ChangeDate Date;     
Select @ChangeDate = MIN(ISNULL(FFforInput.[Date],FF.Date)) --MIN(FFforInput.[Date])    
from     
(Select [Date],[Value],PurposeID from #tblLatest_notefunding where NoteId = @NoteId --and [Date] >= @WireConfirm_CutoffDate
)as FF    
FULL JOIN (    
 Select [Date],[Value],PurposeID from #tblnotefunding where NoteId = @NoteId and [Date]  is not null   --and [Date] >= @WireConfirm_CutoffDate  
) FFforInput    
ON (FF.Date = FFforInput.Date and ROUND(ff.Value,2) = ROUND(FFforInput.Value,2))     
--and ff.PurposeID = FFforInput.PurposeID     
WHERE FF.Date IS NULL OR FFforInput.Date IS NULL     
----------------------------------------------------------------    
    
if @ChangeDate< @ClosingDate and @ClosingDate is not null      
Begin      
 set @ChangeDate=@ClosingDate;      
End     
----------------------------------------------------------------      


      
IF(@Diffcount > 0)      
BEGIN      
 PRINT('Difference in FF detail');      
    

	delete from #tblnotefunding where ISNULL(isDeleted,0) = 1
	
	----Vishal
	SET @WireConfirm_CutoffDate = (Select LEAST(@ChangeDate,@New_WireConfirmDate,@Old_WireConfirmDate))

       
 DECLARE @PreviousmonthEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate)-1, -1));      
 --DECLARE @PreviousmonthEOD date = @ChangeDate;      
       
 --Logic changed on 2/28/2018       
 DECLARE @ChangeDateEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate) - 1, -1)); --Previous month EOD      
        
 IF(@ChangeDate > (select DATEADD(MONTH, DATEDIFF(MONTH, -1, getdate())-1, -1)))      
 BEGIN      
  SET @PreviousmonthEOD  = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, getdate())-1, -1));      
  SET @ChangeDateEOD = @PreviousmonthEOD      
 END      
      
      
 IF EXISTS(Select * from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = @FundingSchedule and n.NoteID = @NoteId and e.StatusID=@Active)      
 BEGIN      
  PRINT('EffectiveDate Exit');      
      
  --Main logic start      
  DECLARE @maxEffectiveDate date = (Select MAX(e.EffectiveStartDate) from  CORE.Event e        
           INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID       
           INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID       
           WHERE e.EventTypeID = @FundingSchedule and n.NoteID = @NoteId      
           and e.StatusID = @Active)      
        
  --IF @ChangeDate < closing      
  IF(@ChangeDate <= @ClosingDate)      
  BEGIN      
   SET @ChangeDateEOD = @ClosingDate      
  END      
      
  IF(@ChangeDateEOD < @ClosingDate)      
  BEGIN      
   SET @ChangeDateEOD = @ClosingDate      
  END      
      
      
  IF(@ChangeDateEOD <= @maxEffectiveDate)      
  BEGIN      
   
   Update [Core].[Event] set StatusID = @Inactive Where eventtypeid = @FundingSchedule and EffectiveStartDate > @ChangeDateEOD and accountid = @AccountId       
      
   Print('Change Date <= Max EffectiveDate');      
         
      
   IF EXISTS(Select * from CORE.Event where eventtypeid = @FundingSchedule and EffectiveStartDate = @ChangeDateEOD and accountid = @AccountId and StatusID = @Active)      
   BEGIN      
         
    Print('Effective ChangeDate exist');      
      
    DECLARE @eventid UNIQUEIDENTIFIER = (Select top 1 eventid from CORE.Event where eventtypeid = @FundingSchedule and EffectiveStartDate = @ChangeDateEOD and accountid = @AccountId and StatusID = @Active);      
      
    --Update [Core].[Event] set StatusID = @Active Where eventid = @eventid      
 --need to change    
    Delete from CORE.FundingSchedule where eventid  = @eventid  and [Date] >= @WireConfirm_CutoffDate    
 --Delete from CORE.FundingSchedule where FundingScheduleAutoID in (Select FundingScheduleAutoID from CORE.FundingSchedule where eventid = @eventid)     
          
    INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,[GeneratedBy],DealFundingID,WF_CurrentStatus)      
    SELECT       
    @eventid,      
    t.Date,      
    t.Value,      
    t.PurposeID,      
    ISNULL(t.Applied,0), 
	t.AdjustmentType,      
    ISNULL(t.Applied,0),      
    @CreatedBy,      
    GETDATE(),      
    @UpdatedBy,      
    GETDATE(),      
    DrawFundingId,
	Comments,
	t.DealFundingRowno ,
	t.GeneratedBy,
	t.DealFundingID,
	t.WF_CurrentStatus
    FROM #tblnotefunding t      
    WHERE t.noteid = @NoteId and t.Value is not null and t.Value !=0 
	and [Date] >= @WireConfirm_CutoffDate
   END      
   ELSE      
   BEGIN      
    Print('Effective ChangeDate not exist');      
      
    DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)      
    Declare @EveID uniqueidentifier;      
    Delete from @tEvent      
      
    INSERT INTO [Core].[Event](      
    [EffectiveStartDate],      
    [AccountID],      
    [Date],      
    [EventTypeID],      
    [EffectiveEndDate],      
    [SingleEventValue],      
    [StatusID],      
    [CreatedBy],      
    [CreatedDate],      
    [UpdatedBy],      
    [UpdatedDate])      
    OUTPUT inserted.EventID INTO @tEvent(tEventID)      
    Select       
    @ChangeDateEOD as [EffectiveStartDate],      
    @AccountId,      
    GETDATE() as [Date],      
    @FundingSchedule as [EventTypeID],      
    NUll as [EffectiveEndDate],      
    NUll as [SingleEventValue],      
    @Active,      
    @CreatedBy,      
    getdate(),      
    @UpdatedBy,      
    getdate()      
      
    SELECT @EveID = tEventID FROM @tEvent;      
      
    INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,GeneratedBy,DealFundingID,WF_CurrentStatus)      
          
    SELECT       
    @EveID,      
    t.Date,      
    t.Value,      
    t.PurposeID,      
    ISNULL(t.Applied,0),  
	t.AdjustmentType,   
    ISNULL(t.Applied,0),      
    @CreatedBy,      
    GETDATE(),      
    @UpdatedBy,      
    GETDATE(),      
    DrawFundingId,
	Comments,
	t.DealFundingRowno ,
	t.GeneratedBy ,
	t.DealFundingID,
	t.WF_CurrentStatus
    FROM #tblnotefunding t      
    WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0    
	
   END      
      
      
  END      
  ELSE      
  BEGIN      
   Print('Change Date > Max EffectiveDate');      
      
   IF(@maxEffectiveDate = @PreviousmonthEOD )--or @PreviousmonthEOD is null      
   BEGIN      
    Print('Scedule for same month');      
         
    DECLARE @eventid1 UNIQUEIDENTIFIER = (Select top 1 eventid from CORE.Event where eventtypeid = @FundingSchedule and EffectiveStartDate = @maxEffectiveDate and accountid = @AccountId and StatusId = @Active);      
 --need to change    
    Delete from CORE.FundingSchedule where eventid  = @eventid1    and [Date] >= @WireConfirm_CutoffDate  
    --Delete from CORE.FundingSchedule where FundingScheduleAutoID in (Select FundingScheduleAutoID from CORE.FundingSchedule where eventid = @eventid1)    
       
    INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,GeneratedBy,DealFundingID,WF_CurrentStatus)      
    SELECT       
    @eventid1,      
    t.Date,      
    t.Value,      
    t.PurposeID,      
    ISNULL(t.Applied,0), 
	t.AdjustmentType,     
    ISNULL(t.Applied,0),      
    @CreatedBy,      
    GETDATE(),      
    @UpdatedBy,      
    GETDATE(),      
    DrawFundingId,Comments,t.DealFundingRowno,t.GeneratedBy ,
	t.DealFundingID,
	t.WF_CurrentStatus
    FROM #tblnotefunding t      
    WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0   and [Date] >= @WireConfirm_CutoffDate   
      
   END      
   ELSE      
   BEGIN      
    Print('Scedule for diff month');      
      
    DECLARE @tEvent1 TABLE (tEventID1 UNIQUEIDENTIFIER)      
    Declare @EveID1 uniqueidentifier;      
    Delete from @tEvent1      
      
    INSERT INTO [Core].[Event](      
    [EffectiveStartDate],      
    [AccountID],      
    [Date],      
    [EventTypeID],      
    [EffectiveEndDate],      
    [SingleEventValue],      
    [StatusID],      
    [CreatedBy],      
    [CreatedDate],      
    [UpdatedBy],      
    [UpdatedDate])      
    OUTPUT inserted.EventID INTO @tEvent1(tEventID1)      
    Select           
    @PreviousmonthEOD as [EffectiveStartDate],      
    @AccountId,      
    GETDATE() as [Date],      
    @FundingSchedule as [EventTypeID],      
    NUll as [EffectiveEndDate],      
    NUll as [SingleEventValue],      
    @Active,      
    @CreatedBy,      
    getdate(),      
    @UpdatedBy,      
    getdate()      
      
          
      
    SELECT @EveID1 = tEventID1 FROM @tEvent1;      
      
    INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID, Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,GeneratedBy,DealFundingID,WF_CurrentStatus)      
          
    SELECT       
    @EveID1,      
    t.Date,      
    t.Value,      
    t.PurposeID,      
    ISNULL(t.Applied,0),   
	t.AdjustmentType,   
    ISNULL(t.Applied,0),      
    @CreatedBy,      
    GETDATE(),      
    @UpdatedBy,      
    GETDATE(),      
    DrawFundingId,
	Comments,
	t.DealFundingRowno,
	t.GeneratedBy   ,
	t.DealFundingID,
	t.WF_CurrentStatus
    FROM #tblnotefunding t      
    WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0      
      
   END      
  END      
      
         
 END      
 ELSE      
 BEGIN       
  PRINT('No funding schedule found - Insert');      
          
   DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)      
   Declare @EveID2 uniqueidentifier;      
   Delete from @tEvent2      
      
   INSERT INTO [Core].[Event](      
   [EffectiveStartDate],      
   [AccountID],      
   [Date],      
   [EventTypeID],      
   [EffectiveEndDate],      
   [SingleEventValue],      
   [StatusID],      
   [CreatedBy],      
   [CreatedDate],      
   [UpdatedBy],      
   [UpdatedDate])      
      
   OUTPUT inserted.EventID INTO @tEvent2(tEventID2)      
      
   Select       
   case when (select count(*) from  [Core].[Event] where AccountID=@AccountId and EventTypeID=@FundingSchedule and StatusId = @Active)=0 then      
    (select distinct isnull(ClosingDate,@PreviousmonthEOD) from cre.Note where Account_AccountID=@AccountId)      
    else      
   @PreviousmonthEOD  end as [EffectiveStartDate],      
   @AccountId,      
   GETDATE() as [Date],      
   @FundingSchedule as [EventTypeID],      
   NUll as [EffectiveEndDate],      
   NUll as [SingleEventValue],      
   @Active,      
   @CreatedBy,      
   getdate(),      
   @UpdatedBy,      
   getdate()      
         
   SELECT @EveID2 = tEventID2 FROM @tEvent2;      
      
   INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,GeneratedBy,DealFundingID,WF_CurrentStatus)      
          
   SELECT       
   @EveID2,      
   t.Date,      
   t.Value,      
   t.PurposeID,      
   ISNULL(t.Applied,0),  
   t.AdjustmentType,    
   ISNULL(t.Applied,0),      
   @CreatedBy,      
   GETDATE(),      
   @UpdatedBy,      
   GETDATE(),      
   DrawFundingId,
   Comments,
   t.DealFundingRowno,
   t.GeneratedBy  ,
   t.DealFundingID,
   t.WF_CurrentStatus
   FROM #tblnotefunding t      
   WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0      
 END      
       
      
END      
ELSE      
BEGIN      
Print('No Chnages');      
       
      
END      
      
      
      
------------------------------------------------------------------------------------------------------      
Print('Update Purpose,Applied,Comments,DrawFundingID of note when there is no changes in FF');      
 Declare @L_DealID UNIQUEIDENTIFIER;      
 SET @L_DealID = (Select dealid from cre.note where noteid =@NoteId)      
  
  
 DECLARE @L_maxEffDate date = (Select MAX(e.EffectiveStartDate) from  CORE.Event e        
           INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID       
           INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID       
           WHERE e.EventTypeID = @FundingSchedule and n.NoteID = @NoteId      
           and e.StatusID = @Active)      

		

 DECLARE @L_evntID UNIQUEIDENTIFIER = (Select top 1 eventid from CORE.Event where eventtypeid = @FundingSchedule and EffectiveStartDate = @L_maxEffDate and accountid = @AccountId and StatusId = @Active);      
 
--===========================================

IF OBJECT_ID('tempdb..#tblInsertUpdateFF') IS NOT NULL         
	DROP TABLE #tblInsertUpdateFF


CREATE TABLE #tblInsertUpdateFF (  
ID INT IDENTITY(1, 1) not null,
EventId UNIQUEIDENTIFIER,      
[Date] Date,      
[Value] decimal(28,15),      
PurposeID int,      
Applied bit,
AdjustmentType int,
Issaved bit,      
CreatedBy nvarchar(256),      
CreatedDate DateTIme,      
UpdatedBy nvarchar(256),      
UpdatedDate DateTIme,      
DrawFundingId NVARCHAR (256)   NULL,      
Comments NVARCHAR (MAX)   NULL,
DealFundingRowno int,      
DealFundingID UNIQUEIDENTIFIER,
WF_CurrentStatus NVARCHAR (256)   NULL,     
GeneratedBy int,
Flag NVARCHAR (50)   NULL  
)


truncate table #tblInsertUpdateFF

INSERT INTO #tblInsertUpdateFF(EventId,[Date],[Value],PurposeID,Applied,AdjustmentType,Issaved,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,DrawFundingId,Comments,DealFundingRowno,DealFundingID,WF_CurrentStatus,GeneratedBy,Flag )
SELECT      
@L_evntID as EventId,      
t.Date,      
t.Value,      
t.PurposeID,      
ISNULL(t.Applied,0) as Applied,
t.AdjustmentType,
ISNULL(t.Applied,0) as Issaved,      
@CreatedBy as CreatedBy,      
GETDATE() as CreatedDate,      
@UpdatedBy as UpdatedBy,      
GETDATE() as UpdatedDate,      
DrawFundingId,      
Comments,  
df.DealFundingRowno,      
t.DealFundingID,
t.WF_CurrentStatus,
t.GeneratedBy,
'Insert'
FROM #tblnotefunding t      
left join (      
	select DealFundingID,DealFundingRowno       
	from cre.DealFunding df where dealid = @L_DealID and df.DealFundingRowno is not null      
)df on df.DealFundingID = t.DealFundingID  ---df.DealFundingRowno = t.DealFundingRowno  
WHERE t.noteid = @NoteId and t.Value is not null and t.Value !=0 and ISNULL(isDeleted,0) = 0  


UPDATE #tblInsertUpdateFF SET Flag='Update'
FROM(
	SELECT temp.ID 
	FROM #tblInsertUpdateFF temp
	inner join (
		Select EventId,DealFundingID from core.FundingSchedule where EventId = @L_evntID
	)nad on nad.EventId = temp.EventId and nad.DealFundingID = temp.DealFundingID

)a WHERE #tblInsertUpdateFF.ID =a.ID



Update  core.FundingSchedule set 
core.FundingSchedule.PurposeID = z.PurposeID,
core.FundingSchedule.Applied = z.Applied,
core.FundingSchedule.AdjustmentType = z.AdjustmentType,
core.FundingSchedule.Issaved = z.Issaved,
core.FundingSchedule.DrawFundingId = z.DrawFundingId,
core.FundingSchedule.Comments = z.Comments,
core.FundingSchedule.DealFundingRowno = z.DealFundingRowno,
core.FundingSchedule.WF_CurrentStatus = z.WF_CurrentStatus,
core.FundingSchedule.GeneratedBy = z.GeneratedBy
From(
	Select EventId,[Date],[Value],PurposeID,Applied,AdjustmentType,Issaved,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,DrawFundingId,Comments,DealFundingRowno,DealFundingID,WF_CurrentStatus,GeneratedBy,Flag 
	FROM #tblInsertUpdateFF
	Where Flag = 'Update'
)z
where core.FundingSchedule.EventId = z.EventId
and core.FundingSchedule.DealFundingID = z.DealFundingID



----INsert
INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,[GeneratedBy],DealFundingID,WF_CurrentStatus) 
Select EventId,[Date],[Value],PurposeID,Applied,AdjustmentType,Issaved,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,DrawFundingId,Comments,DealFundingRowno,GeneratedBy,DealFundingID,WF_CurrentStatus
FROM #tblInsertUpdateFF
Where Flag = 'Insert'
---=====================================







-----------Delete insert Principal Writeoff -------------
Select @L_maxEffDate 
IF(@L_maxEffDate IS NOT NULL)
BEGIN
	Print('@L_maxEffDate is not null')
	Delete From core.FundingSchedule where FundingScheduleID in (
		Select Distinct fs.FundingScheduleID from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1  and acc.IsDeleted = 0
		and fs.EventId  = @L_evntID    
		and fs.purposeid = 840
		and n.noteid = @NoteId
	)
	INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,DealFundingID,WF_CurrentStatus,GeneratedBy)       
	SELECT      
	@L_evntID as EventId,      
	t.Date,      
	t.Value,      
	t.PurposeID,      
	ISNULL(t.Applied,0) as Applied,
	t.AdjustmentType,
	ISNULL(t.Applied,0) as Issaved,      
	@CreatedBy as CreatedBy,      
	GETDATE() as CreatedDate,      
	@UpdatedBy as UpdatedBy,      
	GETDATE() as UpdatedDate,      
	DrawFundingId,      
	Comments,      
	--t.DealFundingRowno,      
	--df.DealFundingID,    
	df.DealFundingRowno,      
	t.DealFundingID,    
	t.WF_CurrentStatus,
	t.GeneratedBy     
	FROM #tblnotefundingPrincipalWriteoff t      
	left join (      
		select DealFundingID,DealFundingRowno       
		from cre.DealFunding df where dealid = @L_DealID and df.DealFundingRowno is not null      
	)df on df.DealFundingID = t.DealFundingID  ---df.DealFundingRowno = t.DealFundingRowno  
	
	WHERE t.noteid = @NoteId and t.Value is not null and t.Value !=0 and ISNULL(isDeleted,0) = 0   
END
ELSE 
BEGIN
	Print('@L_maxEffDate is null')
	----insert principal writeoff
	DECLARE @tEvent3 TABLE (tEventID3 UNIQUEIDENTIFIER)      
	Declare @EveID3 uniqueidentifier;      
	Delete from @tEvent3

	INSERT INTO [Core].[Event](      
    [EffectiveStartDate],      
    [AccountID],      
    [Date],      
    [EventTypeID],      
    [EffectiveEndDate],      
    [SingleEventValue],      
    [StatusID],      
    [CreatedBy],      
    [CreatedDate],      
    [UpdatedBy],      
    [UpdatedDate])      
    OUTPUT inserted.EventID INTO @tEvent3(tEventID3)      
    Select       
    @ClosingDate as [EffectiveStartDate],      
    @AccountId,      
    GETDATE() as [Date],      
    @FundingSchedule as [EventTypeID],      
    NUll as [EffectiveEndDate],      
    NUll as [SingleEventValue],      
    @Active,      
    @CreatedBy,      
    getdate(),      
    @UpdatedBy,      
    getdate()      
      
    SELECT @EveID3 = tEventID3 FROM @tEvent3;

	INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,AdjustmentType,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,DealFundingID,WF_CurrentStatus,GeneratedBy)       
	SELECT      
	@EveID3 as EventId,      
	t.Date,      
	t.Value,      
	t.PurposeID,      
	ISNULL(t.Applied,0) as Applied,
	t.AdjustmentType,
	ISNULL(t.Applied,0) as Issaved,      
	@CreatedBy as CreatedBy,      
	GETDATE() as CreatedDate,      
	@UpdatedBy as UpdatedBy,      
	GETDATE() as UpdatedDate,      
	DrawFundingId,      
	Comments,      
	--t.DealFundingRowno,      
	--df.DealFundingID,    
	df.DealFundingRowno,      
	t.DealFundingID,    
	t.WF_CurrentStatus,
	t.GeneratedBy     
	FROM #tblnotefundingPrincipalWriteoff t      
	left join (      
		select DealFundingID,DealFundingRowno       
		from cre.DealFunding df where dealid = @L_DealID and df.DealFundingRowno is not null      
	)df on df.DealFundingID = t.DealFundingID  ---df.DealFundingRowno = t.DealFundingRowno  
	WHERE t.noteid = @NoteId and t.Value is not null and t.Value !=0 and ISNULL(isDeleted,0) = 0   
END

------------------------------------------------------------------------------------------------------      
      
      
--EXEC [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] @NoteId      
      
      
FETCH NEXT FROM CursorNoteFF          
INTO @NoteId,@AccountId ,@ClosingDate    
END        
      
 
IF((Select top 1 [Value] from app.AppConfig where [Key] = 'AllowFFDeleteFromM61andBackshop') = 1)
BEGIN
	 Exec [dbo].[usp_DeleteFundingSchedule] @notefunding,@CreatedBy
END

 

 -----Delete PrincipalWriteOff from past effective date
EXEC [dbo].[usp_DeleteFundingScheduleForPrincipalWriteOff]  @notefunding,@CreatedBy

      
End      



--INSERT INTO  dbo.tempFF_Status(DealID,startdate,enddate)VALUES(@DealID_temp,@startdate,getdate())

---===========================Insert into LogTable==================================---------      
--disable log      
/*      
DECLARE @DealID UNIQUEIDENTIFIER = (Select dealid from cre.note where noteid in (Select top 1 noteid from #tblnotefunding))      
EXEC [dbo].[usp_InsertIntoLogTables] 'FundingSchedule', @DealID       
*/      
---=======================================================================================--------      
      
      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
      
END
GO

