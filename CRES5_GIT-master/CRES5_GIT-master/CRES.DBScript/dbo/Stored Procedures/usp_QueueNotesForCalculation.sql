-- Procedure

CREATE PROCEDURE [dbo].[usp_QueueNotesForCalculation] 
    @calculationRequest [TableTypeCalculationRequests] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256),
	@BatchType varchar(50)='',
	@PortfolioMasterGuid nvarchar(256)=''
AS
BEGIN


	

Declare @Default_AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from core.analysis where name = 'Default')

--=======================================================================================================================
Delete From Core.CalculationRequests where noteid in (
	SELECT distinct n.noteid 
	from Core.CalculationRequests cr 
	inner join CRE.Note n on n.NoteId=cr.NoteId
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
	CalcType int null
)

INSERT INTO [dbo].[#TempcalculationRequest](NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalculationModeID,CalcType)
Select cr.NoteId,StatusText,UserName,ApplicationText,PriorityText,ISNULL(AnalysisID,@Default_AnalysisID) as AnalysisID,CalculationModeID ,ISNULL(CalcType,775) as CalcType
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



---delete 'Real Time' note-----------------
Delete From Core.CalculationRequests 
where noteid in (SELECT distinct noteid from @calculationRequest where [PriorityText] = 'Real Time')
and AnalysisID = ISNULL(AnalysisID,@Default_AnalysisID)
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
SELECT @cnt = COUNT(distinct n.[NoteId])
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
			 and n.EnableM61Calculations = 3
			 and cr.CalcType = 775
			 --and cr.AnalysisID = @AnalysisID


--check when user select all notes for calculator
IF(@cnt = (Select COUNT(DISTINCT NoteId) from [dbo].[#TempcalculationRequest] where AnalysisID = @AnalysisID ))	
BEGIN
	
	--Insert in history table
	exec [dbo].[usp_InsertCalculationRequestsHistory] 
	
	 --Truncate table Core.CalculationRequests
	 Delete from Core.CalculationRequests where  AnalysisID = @AnalysisID 
	
	INSERT INTO Core.CalculationRequests(NoteId,RequestTime,StatusID,UserName,ApplicationID,PriorityID,AnalysisID,CalculationModeID,NumberOfRetries,CalcType) 
	select NoteId,getdate(),lStatus.[LookupID] as StatusID,UserName,lApplication.[LookupID] as ApplicationID,lPriority.[LookupID] as PriorityID  ,AnalysisID,@CalculationModeID,1 as NumberOfRetries,CalcType
	from [dbo].[#TempcalculationRequest] cr 
	left join core.Lookup lStatus on cr.StatusText =lStatus.Name 
	left join core.Lookup lApplication on cr.ApplicationText =lApplication.Name 
	left join core.Lookup lPriority on cr.PriorityText =lPriority.Name 	
	Where cr.AnalysisID = @AnalysisID


	---update status of child note as Dependent in CalculationRequests table if it inserted before parent
	update Core.CalculationRequests
	set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') 
	where NoteId in (select StripTransferTo from CRE.PayruleSetup)
	and AnalysisID = @AnalysisID
	 and CalcType = 775

	
END
ELSE
BEGIN

   
	--uncomment for testing all notes
	--Update  [Core].[BatchCalculationMaster] SET BatchType='All',[Status]='In-Process' where BatchCalculationMasterID = @NewBatchCalculationMasterID and @AnalysisID IS NOT NULL
	
	----Update Status to 'Processing' if note running more than 20 min------------
	Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,NumberOfRetries = 1
	where NoteID in (
		--SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidRunning and datediff(minute,StartTime, getdate()) > 20 and AnalysisID = @AnalysisID
		SELECT distinct cr.NoteID FROM Core.CalculationRequests cr
		inner join cre.note n on n.noteid = cr.noteid
		WHERE cr.StatusID = @lookupidRunning and datediff(minute,cr.StartTime, getdate()) > ISNULL(n.CalculationTimeInMin,15)
		and AnalysisID = @AnalysisID
		and CalcType = 775
	
	)
	and AnalysisID = @AnalysisID
	and CalcType = 775

	----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------
	Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,NumberOfRetries = 1
	where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') and AnalysisID = @AnalysisID and CalcType = 775)
	and AnalysisID = @AnalysisID
	and CalcType = 775
	------------------------------------------------------------------------------	
	
	select @requestCount =  count(distinct NoteId) from [dbo].[#TempcalculationRequest]

	DECLARE @NoteId UNIQUEIDENTIFIER, 
	@existingId UNIQUEIDENTIFIER;

	IF CURSOR_STATUS('global','CursorNoteCR')>=-1    
	BEGIN    
	DEALLOCATE CursorNoteCR    
	END   
 
	DECLARE CursorNoteCR CURSOR     
	FOR    
	(    
		Select DISTINCT NoteId from [dbo].[#TempcalculationRequest] 

	)
	OPEN CursorNoteCR     
	FETCH NEXT FROM CursorNoteCR    
	INTO @NoteId
	WHILE @@FETCH_STATUS = 0    
	BEGIN 

		SET @existingId = (SELECT top 1 CalculationRequestID FROM Core.CalculationRequests WHERE NoteID = @NoteID AND StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Failed','Completed')) 
			and AnalysisID = @AnalysisID and CalcType = 775)

		IF @existingId IS NULL
		BEGIN
			--Delete note as well as its child note
			Delete from Core.CalculationRequests where NoteId= @NoteId and StatusID in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Failed','Completed')) and AnalysisID = @AnalysisID and CalcType = 775
			Delete from Core.CalculationRequests where NoteId in(select StripTransferTo from [CRE].[PayruleSetup] where StripTransferFrom =@NoteID ) and AnalysisID = @AnalysisID and CalcType = 775
	
			--and StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Running'))
			--select StripTransferTo from [CRE].[PayruleSetup] where StripTransferFrom =@NoteID

			--if requested notes<10 then set priority as realtime so it will process first.
				
			INSERT INTO Core.CalculationRequests(NoteId,RequestTime,StatusID,UserName,ApplicationID,PriorityID,AnalysisID,CalculationModeID,NumberOfRetries,CalcType) 
			select NoteId,getdate(),lStatus.[LookupID] as StatusID,UserName,lApplication.[LookupID] as ApplicationID,
			PriorityID = (case when @requestCount<10 then @lookupidRealTime else lPriority.[LookupID] end) ,AnalysisID,@CalculationModeID,1 as NumberOfRetries,CalcType
			from [dbo].[#TempcalculationRequest] cr 
			left join core.Lookup lStatus on cr.StatusText =lStatus.Name 
			left join core.Lookup lApplication on cr.ApplicationText =lApplication.Name 
			left join core.Lookup lPriority on cr.PriorityText =lPriority.Name 
			where cr.NoteId=@NoteId
			
			UNION

			--Insert child note if not in calculation request table
			select  distinct StripTransferTo
			,getdate()
			,(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') 
			,@CreatedBy
			,null ApplicationID
			,null
			,@AnalysisID as AnalysisID
			,@CalculationModeID as CalculationModeID
			,1 as NumberOfRetries
			,775 as CalcType
			 from CRE.PayruleSetup where StripTransferFrom= @NoteId 
			 and StripTransferTo not in (select NoteID from Core.CalculationRequests where StatusID not in (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME in('Running')) and AnalysisID = @AnalysisID)

			---update status of child note as Dependent in CalculationRequests table if it inserted before parent
			update Core.CalculationRequests
			set StatusID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents') 
			where NoteId in (select StripTransferTo from CRE.PayruleSetup where StripTransferFrom= @NoteId)
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
	INTO @NoteId
	END  


END

--==========================================================

--Update dealid's for notes
Update Core.CalculationRequests SET Core.CalculationRequests.DealID = a.dealid
From(
	Select noteid,dealid from cre.note where noteid in (Select distinct noteid from @calculationRequest)
	union
	Select noteid,dealid from cre.note where noteid in (Select distinct noteid from core.calculationrequests where AnalysisID = @AnalysisID)

)a
where Core.CalculationRequests.noteid = a.noteid



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
Delete from core.CalculationRequests where AnalysisID = @AnalysisID and NoteId in (Select NoteID from cre.Note where EnableM61Calculations = 4)
--==========================================================


--temp
Update Core.CalculationRequests set CalcType = 775 where CalcType is null

END
