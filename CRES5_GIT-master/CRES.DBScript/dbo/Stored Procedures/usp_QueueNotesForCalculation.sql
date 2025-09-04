-- Procedure    
    
CREATE PROCEDURE [dbo].[usp_QueueNotesForCalculation]     
	@calculationRequest [TableTypeCalculationRequests] READONLY,    
	@CreatedBy nvarchar(256),    
	@UpdatedBy nvarchar(256),    
	@BatchType varchar(50)='',    
	@PortfolioMasterGuid nvarchar(256)='',
	@RequestFrom nvarchar(256) = NULL
AS    
BEGIN    
    
    
--Select * into dbo.tempcalc from @calculationRequest
    
Declare @Default_AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from core.analysis where name = 'Default')    
    
--=======================================================================================================================    
Delete From Core.CalculationRequests where AccountId in (    
	 SELECT distinct n.Account_AccountID     
	 from Core.CalculationRequests cr     
	 inner join CRE.Note n on n.Account_AccountID=cr.AccountId    
	 inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID         
	 where (n.noteID  in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )    
	 OR  ac.isdeleted=1    
	 OR ISNULL(ac.StatusID,1) <> 1    
	 OR n.EnableM61Calculations = 4)    
)    
    
IF OBJECT_ID('tempdb..[#TempcalculationRequest]') IS NOT NULL                                             
 DROP TABLE [#TempcalculationRequest]      
      
CREATE TABLE  [dbo].[#TempcalculationRequest](    
 NoteId UNIQUEIDENTIFIER NULL,    
 StatusText nvarchar(256) null,    
 UserName nvarchar(256) null,    
 ApplicationText nvarchar(256) null,    
 PriorityText nvarchar(256) null,    
 AnalysisID nvarchar(256) null,    
 CalculationModeID [int] NULL,    
 CalcType int null,    
 [CalcEngineType] int null,
 AccountID UNIQUEIDENTIFIER NULL,
)    
    
INSERT INTO [dbo].[#TempcalculationRequest](AccountID,NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalculationModeID,CalcType)    
Select n.Account_AccountID, cr.NoteId,StatusText,UserName,ApplicationText,PriorityText,ISNULL(AnalysisID,@Default_AnalysisID) as AnalysisID,CalculationModeID ,ISNULL(CalcType,775) as CalcType    
from @calculationRequest cr    
inner join cre.note n on n.noteid =cr.NoteID    
left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID    
where n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )    
and n.EnableM61Calculations = 3    
and ac.isdeleted=0    
and ISNULL(ac.StatusID,1) = 1    
and cr.CalcType = 775    
--=======================================================================================================================    
    
    
Declare @AnalysisID UNIQUEIDENTIFIER = (Select top 1 AnalysisID from [dbo].[#TempcalculationRequest])    
Declare @CalculationModeID int = (Select top 1 CalculationModeID from [dbo].[#TempcalculationRequest])    
    
    
Declare @CalcEngineType int;    
Declare @AllowCalcOverride int;    
    
Declare @UseActuals int = (Select Top 1 UseActuals from core.AnalysisParameter Where  AnalysisID = @AnalysisID);
--Set @RequestFrom = ISNULL(@RequestFrom,'CalcMgr');

select @CalcEngineType = [CalcEngineType] ,@AllowCalcOverride = AllowCalcOverride    
from [Core].[AnalysisParameter]      
where analysisID = @AnalysisID;
    
    
---Update CalcEngineType from scenario    
Update [dbo].[#TempcalculationRequest] set [CalcEngineType] = @CalcEngineType    
    
IF(@AllowCalcOverride =  3)    
BEGIN    
 ---Update CalcEngineType from Deal level    
 Update [dbo].[#TempcalculationRequest] set [dbo].[#TempcalculationRequest].[CalcEngineType] = a.CalcEngineType    
 From(    
  Select n.noteid,d.CalcEngineType     
  from cre.note n    
  inner join cre.deal d on n.DealID =d.dealid    
  where ISNULL(d.CalcEngineType,804) <> 804  ---d.CalcEngineType is not null    
  and n.noteid in (Select Distinct noteid from [dbo].[#TempcalculationRequest])    
 )a    
 where [dbo].[#TempcalculationRequest].noteid = a.noteid    
END    
    
---delete 'Real Time' note-----------------    
Delete From Core.CalculationRequests     
where AccountId in (SELECT distinct n.Account_AccountID from @calculationRequest cr Inner Join cre.note n on n.noteid = cr.NoteId where [PriorityText] = 'Real Time')    
and AnalysisID = ISNULL(@AnalysisID,@Default_AnalysisID)    
and CalcType = 775    
--------------------------------------------    
    
    
    
declare @cashflowEngineId int;    
    
Select @cashflowEngineId=lookupid from core.Lookup where ParentID=47 and Name='Default'    
----Update Status to 'Processing' if note running more than 20 min------------    
Declare @lookupidRunning int = (SELECT LookupID from core.Lookup where Name='Running' and ParentID=40);    
Declare @lookupidProcessing int = (SELECT LookupID from core.Lookup where Name='Processing' and ParentID=40);    
Declare @lookupidFailed int = (SELECT LookupID from core.Lookup where Name='Failed' and ParentID=40);    
Declare @lookupidRealTime int = (SELECT LookupID from core.Lookup where Name='Real Time' and ParentID=42 );    
Declare @requestCount int = 0;    
Declare @PortfolioMasterID int = null    
    
IF (@PortfolioMasterGuid<>'' and @PortfolioMasterGuid<>'00000000-0000-0000-0000-000000000000')    
BEGIN    
     select @PortfolioMasterID= PortfolioMasterID FROM core.PortfolioMaster WHERE PortfolioMasterGuid = @PortfolioMasterGuid    
END    
    
IF (@BatchType<>'')    
BEGIN    
 --start-batche log related code    
 DECLARE @tBatchCalculationMaster TABLE (tBatchCalculationMasterID int)    
 DECLARE @NewBatchCalculationMasterID int     
     
 IF (@AnalysisID IS NOT NULL)    
 BEGIN    
  INSERT INTO [Core].[BatchCalculationMaster]([AnalysisID],[StartTime],[UserID],PortfolioMasterID)     
  OUTPUT inserted.BatchCalculationMasterID INTO @tBatchCalculationMaster(tBatchCalculationMasterID)     
  VALUES(@AnalysisID,getdate(),@CreatedBy,@PortfolioMasterID)    
    
  SELECT @NewBatchCalculationMasterID = tBatchCalculationMasterID FROM @tBatchCalculationMaster;    
     
  INSERT INTO [Core].[BatchCalculationDetail]    
    ([BatchCalculationMasterID]    
    ,[NoteID]    
    ,[StatusID])    
   select distinct @NewBatchCalculationMasterID,NoteId,lStatus.[LookupID]    
  from [dbo].[#TempcalculationRequest] cr     
  left join core.Lookup lStatus on cr.StatusText =lStatus.Name     
  left join core.Lookup lApplication on cr.ApplicationText =lApplication.Name     
  left join core.Lookup lPriority on cr.PriorityText =lPriority.Name     
  Where cr.AnalysisID = @AnalysisID     
    
  ---update status of child note as Dependent in BatchCalculationDetail table    
  update Core.BatchCalculationDetail    
  set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents')     
  where NoteId in (select StripTransferTo from CRE.PayruleSetup)    
  and BatchCalculationMasterID =@NewBatchCalculationMasterID    
    
  --update Batch type -- ALL,TagStatus- 'In-Process'    
  Update  [Core].[BatchCalculationMaster] SET BatchType=@BatchType,[Status]='In-Process' where BatchCalculationMasterID = @NewBatchCalculationMasterID and @AnalysisID IS NOT NULL    
 END    
END    
--end-batche log related code    
    
    
    
    
    
Declare @cnt int;    
SELECT @cnt = COUNT(distinct n.Account_AccountID)    
     from  CRE.Note n    
     left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.CalcType = 775    
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
    and n.EnableM61Calculations = 3    
        
    --and cr.AnalysisID = @AnalysisID    
    
    
--check when user select all notes for calculator    
IF(@cnt = (Select COUNT(DISTINCT NoteId) from [dbo].[#TempcalculationRequest] where AnalysisID = @AnalysisID ))     
BEGIN    
     
 --Insert in history table    
 exec [dbo].[usp_InsertCalculationRequestsHistory]     
     
  --Truncate table Core.CalculationRequests    
  Delete from Core.CalculationRequests where  AnalysisID = @AnalysisID     
     
 INSERT INTO Core.CalculationRequests(AccountId,RequestTime,StatusID,UserName,ApplicationID,PriorityID,AnalysisID,CalculationModeID,NumberOfRetries,CalcType,CalcEngineType,ErrorMessage,UseActuals,RequestFrom)     
 select cr.AccountID,getdate(),lStatus.[LookupID] as StatusID,UserName,lApplication.[LookupID] as ApplicationID,lPriority.[LookupID] as PriorityID  ,AnalysisID,@CalculationModeID,1 as NumberOfRetries,CalcType,cr.CalcEngineType,null,@UseActuals,@RequestFrom    
 from [dbo].[#TempcalculationRequest] cr     
 left join core.Lookup lStatus on cr.StatusText =lStatus.Name     
 left join core.Lookup lApplication on cr.ApplicationText =lApplication.Name     
 left join core.Lookup lPriority on cr.PriorityText =lPriority.Name
 Where cr.AnalysisID = @AnalysisID    
    
    
 ---update status of child note as Dependent in CalculationRequests table if it inserted before parent    
 update Core.CalculationRequests    
 set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents')     
 where AccountId in (Select Account_AccountID from cre.note where noteid in (select StripTransferTo from CRE.PayruleSetup))    
 and AnalysisID = @AnalysisID    
  and CalcType = 775    
    
	-- Update Last calculated date time on AnalysisParameter
--	Update [Core].[AnalysisParameter] Set LastCalculatedDate = GetDate() Where AnalysisID=@AnalysisID;	--Comment this line as requirement of calculation for all Notes was not clear.

END    
ELSE    
BEGIN    
    
       
 --uncomment for testing all notes    
 --Update  [Core].[BatchCalculationMaster] SET BatchType='All',[Status]='In-Process' where BatchCalculationMasterID = @NewBatchCalculationMasterID and @AnalysisID IS NOT NULL    
     
 ----Update Status to 'Processing' if note running more than 20 min------------    
 Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,NumberOfRetries = 1    
 where AccountId in (    
  --SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidRunning and datediff(minute,StartTime, getdate()) > 20 and AnalysisID = @AnalysisID    
  SELECT distinct n.Account_AccountID FROM Core.CalculationRequests cr    
  inner join cre.note n on n.Account_AccountID = cr.AccountId    
  WHERE cr.StatusID = @lookupidRunning and datediff(minute,cr.StartTime, getdate()) > ISNULL(n.CalculationTimeInMin,15)    
  and AnalysisID = @AnalysisID    
  and CalcType = 775    
     
 )    
 and AnalysisID = @AnalysisID    
 and CalcType = 775    
    
 ----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------    
 Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,NumberOfRetries = 1    
 where AccountId in (SELECT distinct AccountId FROM Core.CalculationRequests WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') and AnalysisID = @AnalysisID and CalcType = 775)    
 and AnalysisID = @AnalysisID    
 and CalcType = 775    
 ------------------------------------------------------------------------------     
     
 select @requestCount =  count(distinct NoteId) from [dbo].[#TempcalculationRequest]    
    
 DECLARE @NoteId UNIQUEIDENTIFIER,     
 @existingId UNIQUEIDENTIFIER;    
 DECLARE @AccountId UNIQUEIDENTIFIER    
    
 IF CURSOR_STATUS('global','CursorNoteCR')>=-1        
 BEGIN        
 DEALLOCATE CursorNoteCR        
 END       
     
 DECLARE CursorNoteCR CURSOR         
 FOR        
 (        
  Select DISTINCT NoteId,AccountId   from [dbo].[#TempcalculationRequest]     
    
 )    
 OPEN CursorNoteCR         
 FETCH NEXT FROM CursorNoteCR        
 INTO @NoteId,@AccountId    
 WHILE @@FETCH_STATUS = 0    
 BEGIN     
      
  --update Core.CalculationRequests SET ErrorMessage = 'inside cursor' where noteid = @NoteId    
    
  SET @existingId = (SELECT top 1 CalculationRequestID FROM Core.CalculationRequests WHERE AccountId = @AccountId AND StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Failed','Completed','Pause'))     
   and AnalysisID = @AnalysisID and CalcType = 775)    
    
  IF @existingId IS NULL    
  BEGIN    
   --update Core.CalculationRequests SET ErrorMessage = 'IF @existingId IS NULL' where noteid = @NoteId    
    
   --Delete note as well as its child note    
   Delete from Core.CalculationRequests where AccountId= @AccountId and StatusID in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Failed','Completed','Pause')) and AnalysisID = @AnalysisID and CalcType = 775    
       
   Delete from Core.CalculationRequests where AccountId in(    
    select Account_AccountID from cre.note where noteid in (    
     select StripTransferTo from [CRE].[PayruleSetup] where StripTransferFrom =@NoteID     
    )    
   ) and AnalysisID = @AnalysisID and CalcType = 775    
     
   --and StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Running'))    
   --select StripTransferTo from [CRE].[PayruleSetup] where StripTransferFrom =@NoteID    
    
   --if requested notes<10 then set priority as realtime so it will process first.    
        
   INSERT INTO Core.CalculationRequests(AccountId,RequestTime,StatusID,UserName,ApplicationID,PriorityID,AnalysisID,CalculationModeID,NumberOfRetries,CalcType,CalcEngineType,ErrorMessage,UseActuals,RequestFrom)     
       
   select cr.AccountID,getdate(),lStatus.[LookupID] as StatusID,UserName,lApplication.[LookupID] as ApplicationID,    
   PriorityID = (case when @requestCount<10 then @lookupidRealTime else lPriority.[LookupID] end) ,AnalysisID,@CalculationModeID,1 as NumberOfRetries,CalcType,cr.CalcEngineType,null,@UseActuals,@RequestFrom  
   from [dbo].[#TempcalculationRequest] cr     
   left join core.Lookup lStatus on cr.StatusText =lStatus.Name     
   left join core.Lookup lApplication on cr.ApplicationText =lApplication.Name     
   left join core.Lookup lPriority on cr.PriorityText =lPriority.Name
   where cr.NoteId=@NoteId    
       
   UNION    
    
   --Insert child note if not in calculation request table    
   select  distinct nn.Account_AccountID as StripTransferTo    
   ,getdate()    
   ,(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents')     
   ,@CreatedBy    
   ,null ApplicationID    
   ,null    
   ,@AnalysisID as AnalysisID    
   ,@CalculationModeID as CalculationModeID    
   ,1 as NumberOfRetries    
   ,775 as CalcType    
   ,@CalcEngineType    
   ,null  ---'child'    
   ,@UseActuals
   ,@RequestFrom
    from CRE.PayruleSetup ps
    Inner Join cre.note nn on nn.noteid =  ps.StripTransferTo   
    where StripTransferFrom= @NoteId     
    and StripTransferTo not in (    
		select n.NoteID     
		from Core.CalculationRequests cr     
		Inner Join cre.note n on n.Account_AccountID = cr.AccountId    
		where StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in ('Running')) 
		and AnalysisID = @AnalysisID
	)    
    
    
   DECLARE @PriID INT      
   DECLARE @L_CalcEngineType INT      
       
   Select top 1 @PriID = PriorityID ,@L_CalcEngineType = CalcEngineType    
   FROM Core.CalculationRequests    
   where AnalysisID = @AnalysisID and CalcType = 775 and AccountId = @AccountId     
     
    
   ---update status of child note as Dependent in CalculationRequests table if it inserted before parent    
   update Core.CalculationRequests    
   set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') ,PriorityID = @PriID,CalcEngineType = @L_CalcEngineType    
   where AccountId in (    
    Select Account_AccountID from cre.note where noteid in (    
     select StripTransferTo from CRE.PayruleSetup where StripTransferFrom= @NoteId    
    )    
   )    
   and AnalysisID = @AnalysisID     
   and CalcType = 775    
    
  END    
    
    
    
    
  --Insert Dependent notes into bach detail     
  IF (@BatchType<>'')    
  BEGIN    
   INSERT INTO [Core].[BatchCalculationDetail]    
     ([BatchCalculationMasterID]    
     ,[NoteID]    
     ,[StatusID])    
        
   select  distinct @NewBatchCalculationMasterID,StripTransferTo    
   ,(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents')     
    from CRE.PayruleSetup where StripTransferFrom= @NoteId     
    and StripTransferTo not in (select NoteID from Core.[BatchCalculationDetail] where BatchCalculationMasterID =@NewBatchCalculationMasterID) and @AnalysisID IS NOT NULL    
    
   update Core.[BatchCalculationDetail]    
   set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents')     
   where NoteId in (select StripTransferTo from CRE.PayruleSetup where StripTransferFrom= @NoteId)    
   and BatchCalculationMasterID =@NewBatchCalculationMasterID  and @AnalysisID IS NOT NULL    
  END    
    
    
 FETCH NEXT FROM CursorNoteCR        
 INTO @NoteId,@AccountId    
 END      
    
    
END    
    
--==========================================================    
    
--Update dealid's for notes    
Update Core.CalculationRequests SET Core.CalculationRequests.DealID = a.dealid    
From(    
 Select Account_AccountID,dealid from cre.note where noteid in (Select distinct noteid from @calculationRequest)    
 union    
 Select Account_AccountID,dealid from cre.note where Account_AccountID in (Select distinct AccountId from core.calculationrequests where AnalysisID = @AnalysisID)    
    
)a    
where Core.CalculationRequests.AccountId = a.Account_AccountID    
    
    
    
--==========================================================    
Delete FROM Core.CalculationRequests WHERE Analysisid IS NULL    
    
--EXEC [dbo].[usp_PIKNoteInCalculation]   @calculationRequest,@CreatedBy    
    
--update total note count in batch master    
IF (@BatchType<>'')    
BEGIN    
 Update  [Core].[BatchCalculationMaster] SET Total=(select count(1) from [Core].[BatchCalculationDetail] where     
 BatchCalculationMasterID = @NewBatchCalculationMasterID) where BatchCalculationMasterID = @NewBatchCalculationMasterID and  @AnalysisID IS NOT NULL    
END    
    
--Delete notes from Calculation Requests if EnableM61Calculations = 'N'    
Delete from core.CalculationRequests where AnalysisID = @AnalysisID and AccountId in (Select Account_AccountID from cre.Note where EnableM61Calculations = 4)    
--==========================================================    
    
    
--temp    
Update Core.CalculationRequests set CalcType = 775 where CalcType is null    
    
    
    
----========================================    
IF(@AnalysisID = (Select AnalysisID from core.analysis where name = 'Default') )    
BEGIN    
    
 Declare @L_AnalysisID UNIQUEIDENTIFIER    
     
 IF CURSOR_STATUS('global','CursorDeal')>=-1    
 BEGIN    
  DEALLOCATE CursorDeal    
 END    
    
 DECLARE CursorDeal CURSOR     
 for    
 (    
  Select Distinct ap.AnalysisID from Core.AnalysisParameter ap    
  inner join core.analysis a on a.analysisid = ap.analysisid    
  where AllowCalcAlongWithDefault = 3 and a.[name] <> 'Default'
  and a.ScenarioStatus = 1
  and a.isDeleted <> 1
 )    
 OPEN CursorDeal     
 FETCH NEXT FROM CursorDeal    
 INTO @L_AnalysisID    
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    
  declare @TableTypeCalculationRequests_new TableTypeCalculationRequests    
    
  delete from @TableTypeCalculationRequests_new    
  INSERT INTO @TableTypeCalculationRequests_new (NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalculationModeID,[CalcType])    
  Select NoteId,StatusText,UserName,ApplicationText,PriorityText,@L_AnalysisID as AnalysisID,CalculationModeID,775 from @calculationRequest cr    
    
  Exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests_new,@CreatedBy,@UpdatedBy,@BatchType,@PortfolioMasterGuid, 'CalcAlongWithDefault'
    
 FETCH NEXT FROM CursorDeal    
 INTO @L_AnalysisID    
 END    
 CLOSE CursorDeal       
 DEALLOCATE CursorDeal    
    
END    
----========================================    
  
  

Delete from Core.CalculationRequests where CalculationRequestid in (
	SELECT cr.CalculationRequestid
	--,n.crenoteid,cr.AnalysisID,cr.AccountID,EOMONTH(n.ActualPayOffDate) as EOMONTH_ActualPayOffDate,tbl_Pclose.LastAccountingCloseDate
	from Core.CalculationRequests cr     
	inner join CRE.Note n on n.account_accountID=cr.AccountID    
	inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID   
	Left Join(
		Select Account_AccountID,noteid,LastAccountingCloseDate 
		from(
			Select 
			d.DealID,n.Account_AccountID,n.noteid,p.CloseDate as LastAccountingCloseDate    
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			Inner join (
				Select dealid,CloseDate,updateddate
				from CORE.[Period]
				where CloseDate is not null
			)p on d.dealid = p.dealid 
			Where d.IsDeleted <> 1
		)a
		where a.rno = 1
	)tbl_Pclose on tbl_Pclose.Account_AccountID = cr.AccountID      
	where ac.Isdeleted <> 1
	and tbl_Pclose.LastAccountingCloseDate is not null and n.ActualPayOffDate is not null 
	and EOMONTH(n.ActualPayOffDate) < tbl_Pclose.LastAccountingCloseDate
)


--Delete Duplicate records
delete from core.calculationrequests  where calculationrequestID in (
 
        Select calculationrequestID from(
            Select Analysisid,Accountid,calculationrequestID ,row_number() over(partition by Analysisid,Accountid order by Analysisid,Accountid,RequestTime desc) rno
            from core.calculationrequests 
            where Analysisid in (
                Select Distinct Analysisid from(
                    Select Analysisid,Accountid,count(Accountid) cnt from core.calculationrequests
                    group by Analysisid,Accountid
                    having count(Accountid) > 1
                )a
            )
        )z
        where z.rno > 1
)
  
  Declare @StopV1NoteCalculation int = (Select [Value] from [App].[AppConfig] where [Key] = 'StopV1NoteCalculation') 
  IF(@StopV1NoteCalculation = 1)
  BEGIN
		Delete From Core.CalculationRequests where CalcEngineType = 798 
  END

  Declare @StopC#NoteCalculation int = (Select [Value] from [App].[AppConfig] where [Key] = 'StopC#NoteCalculation') 
  IF(@StopC#NoteCalculation = 1)
  BEGIN
		Delete From Core.CalculationRequests where CalcEngineType = 797 
  END

	--Update Last calculated date time on AnalysisParameter
	Update [Core].[AnalysisParameter] Set LastCalculatedDate = GetDate() Where AnalysisID=@AnalysisID;	
END


