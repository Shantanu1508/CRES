

CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusAndTime] --'EE1EAE55-C8D9-4B79-94AF-3EC6DC7F6211','EE1EAE55-C8D9-4B79-94AF-3EC6DC7F6211','Running','StartTime'
@CalculationRequestID uniqueidentifier,
@NoteID uniqueidentifier,
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX)
 
AS
BEGIN


Declare @AnalysisID UNIQUEIDENTIFIER = ( SELECT AnalysisID FROM core.CalculationRequests where  CalculationRequestID = @CalculationRequestID)

Declare @Query AS NVARCHAR(MAX)

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

 declare @StatusFailed int =(Select lookupid from CORE.Lookup where name = 'Failed' and ParentID = 40)
 declare @StatusProcessing int =(Select lookupid from CORE.Lookup where name = 'Processing' and ParentID = 40)
 declare @StatusComplete int =(Select lookupid from CORE.Lookup where name = 'Completed' and ParentID = 40)
 declare @tBatchCalculationMasterID as table
 (
  ID int Identity(1,1),
  BatchCalculationMasterID int,
  UserID uniqueidentifier,
  BatchType varchar(50)
 )
 DECLARE @ID int=1
 DECLARE @BatchCalculationMasterID int
 DECLARE @UserID uniqueidentifier
 DECLARE @BatchType varchar(50)

----Dynamic query for update StartTime/EndTime
--set @Query=' update Core.CalculationRequests set 
--StatusID = (Select lookupid from CORE.Lookup where name = '''+convert(nvarchar(MAX),@StatusText)+''' and ParentID = 40),
--'+convert(nvarchar(MAX),@ColumnName)+'= getdate() ,
--ErrorMessage='''+convert(nvarchar(MAX),@ErrorMessage)+'''
--where NoteID='''+convert(nvarchar(MAX),@NoteID)+''' and CalculationRequestID = '''+convert(nvarchar(MAX),@CalculationRequestID)+'''
--';	
--exec(@Query);

IF(@ColumnName = 'EndTime')
BEGIN
	update Core.CalculationRequests set 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	--EndTime = getdate() ,
	EndTime=case when (@ErrorMessage LIKE '%deadlocked%' or @ErrorMessage LIKE '%Timeout Expired%') then null else getdate() end,
	ErrorMessage=@ErrorMessage
	where NoteID=@NoteID and CalculationRequestID = @CalculationRequestID and AnalysisID = @AnalysisID
	

	Update Core.BatchCalculationDetail SET 
	StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40),
	EndTime=case when (@ErrorMessage LIKE '%deadlocked%' or @ErrorMessage LIKE '%Timeout Expired%') then null else getdate() end,
	ErrorMessage=@ErrorMessage
	where NoteID=@NoteID and  
	BatchCalculationMasterID in (select BatchCalculationMasterID from Core.BatchCalculationMaster where AnalysisID=@AnalysisID) 
	and EndTime is null
     
	 
	 --update end time in batch master if all the note has been processed
	   
	   /*
	   update [Core].[BatchCalculationMaster] set EndTime=getdate() from 
		(
		select BatchCalculationMasterID from [Core].[BatchCalculationDetail] where BatchCalculationMasterID not in 
		(
		select distinct BatchCalculationMasterID from [Core].[BatchCalculationDetail] where EndTime is null)
		) t
		where t.BatchCalculationMasterID=[Core].[BatchCalculationMaster].BatchCalculationMasterID and [Core].[BatchCalculationMaster].AnalysisID = @AnalysisID 
		*/
		
		insert into @tBatchCalculationMasterID
		select BatchCalculationMasterID,UserID,BatchType from [Core].[BatchCalculationMaster]  where BatchCalculationMasterID not in 
		(
		   select m.BatchCalculationMasterID from [Core].[BatchCalculationDetail] d  join [Core].[BatchCalculationMaster] m on d.BatchCalculationMasterID=m.BatchCalculationMasterID
			where m.EndTime is null  
			and m.AnalysisID=@AnalysisID
			and d.EndTime is null
		)
		and EndTime is null and AnalysisID=@AnalysisID

		update [Core].[BatchCalculationMaster] set EndTime=getdate() where  BatchCalculationMasterID in 
		(
			select BatchCalculationMasterID FROM @tBatchCalculationMasterID
		)

		update [Core].[BatchCalculationMaster] set [Status]='Completed' where  BatchCalculationMasterID in 
		(
			select BatchCalculationMasterID FROM @tBatchCalculationMasterID where (BatchType='Single' or BatchType='ALL')
		)
		
END


---update status of child note as Failed in CalculationRequests table if Parent note failed with check Note not failed due to deadlocked or Timeout
IF(@StatusText = 'Failed' )
BEGIN
	IF(@ErrorMessage LIKE '%deadlocked%' or @ErrorMessage LIKE '%Timeout Expired%')
	BEGIN
	  Print('No update required');
	END
	ELSE
	BEGIN
		update Core.CalculationRequests
		 set StatusID=@StatusFailed,
		 ErrorMessage='Excluded from the calculation as parent note failed to calculate.'
		 where NoteId in (select StripTransferTo from CRE.PayruleSetup where StripTransferFrom= @NoteID)
		 and @StatusFailed=(Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40) 
		 and AnalysisID = @AnalysisID
		 and CalcType = 775


		 Update Core.BatchCalculationDetail SET 
		 StatusID = @StatusFailed,
		 ErrorMessage='Excluded from the calculation as parent note failed to calculate.',
		 StartTime=getdate(),
		 EndTime=getdate()
		 where NoteId in (select StripTransferTo from CRE.PayruleSetup where StripTransferFrom= @NoteID)
		 and @StatusFailed=(Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40) 
		 and BatchCalculationMasterID  in (select BatchCalculationMasterID from Core.BatchCalculationMaster where AnalysisID=@AnalysisID) 
		 and EndTime is null

		 --update total note failed in batch master
		update [Core].[BatchCalculationMaster] set TotalFailed=t.total from 
		(
		select BatchCalculationMasterID,count(statusid) as total ,statusid from [Core].[BatchCalculationDetail] group by BatchCalculationMasterID,statusid having StatusID=@StatusFailed
		and @StatusFailed=(Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40)
		) t
		where t.BatchCalculationMasterID=[Core].[BatchCalculationMaster].BatchCalculationMasterID and AnalysisID = @AnalysisID 

		 
	END

END


---update status of child note as Processing in CalculationRequests table after parents completion
IF( @StatusText = 'Completed')
BEGIN

Declare @PriorityID int = (SELECT LookupID from core.Lookup where Name='Batch' and ParentID=42)

	update Core.CalculationRequests
	set StatusID=@StatusProcessing,
	PriorityID = @PriorityID,
	StartTime = getdate()
	where noteid in
	(select distinct StripTransferTo from CRE.PayruleSetup where StripTransferFrom =@NoteID and StripTransferTo not in (
	select distinct child.StripTransferTo from  Core.CalculationRequests cr  inner join CRE.PayruleSetup child on child.StripTransferFrom=cr.NoteID
	inner join  CRE.PayruleSetup parent on parent.StripTransferTo=child.StripTransferTo and parent.StripTransferFrom!=@NoteID
	inner join Core.CalculationRequests parentStatus on parentStatus.NoteID=parent.StripTransferFrom and ((parentStatus.StatusID!=@StatusComplete and parentStatus.StatusID!=@StatusFailed  ) or(parentStatus.StatusID=@StatusFailed and abs( DATEDIFF(second, parentStatus.RequestTime , parentStatus.RequestTime))>=60))
	where cr.NoteID=@NoteID and parentStatus.AnalysisID = @AnalysisID
	))
	and AnalysisID = @AnalysisID
	and CalcType = 775

	update Core.BatchCalculationDetail
	set StatusID=@StatusProcessing,
	StartTime = getdate()
	where noteid in
	(select distinct StripTransferTo from CRE.PayruleSetup where StripTransferFrom =@NoteID and StripTransferTo not in (
	select distinct child.StripTransferTo from  Core.CalculationRequests cr  inner join CRE.PayruleSetup child on child.StripTransferFrom=cr.NoteID
	inner join  CRE.PayruleSetup parent on parent.StripTransferTo=child.StripTransferTo and parent.StripTransferFrom!=@NoteID
	inner join Core.CalculationRequests parentStatus on parentStatus.NoteID=parent.StripTransferFrom and ((parentStatus.StatusID!=@StatusComplete and parentStatus.StatusID!=@StatusFailed  ) or(parentStatus.StatusID=@StatusFailed and abs( DATEDIFF(second, parentStatus.RequestTime , parentStatus.RequestTime))>=60))
	where cr.NoteID=@NoteID and parentStatus.AnalysisID = @AnalysisID
	))
	and BatchCalculationMasterID in (select BatchCalculationMasterID from Core.BatchCalculationMaster where AnalysisID=@AnalysisID) 
	and EndTime is null

	--update total note completed in batch master
	update [Core].[BatchCalculationMaster] set TotalCompleted=t.total from 
		(
		select BatchCalculationMasterID,count(statusid) as total ,statusid from [Core].[BatchCalculationDetail] group by BatchCalculationMasterID,statusid having StatusID=@StatusComplete
		and @StatusComplete=(Select lookupid from CORE.Lookup where name = 'Completed' and ParentID = 40)
		) t
		where t.BatchCalculationMasterID=[Core].[BatchCalculationMaster].BatchCalculationMasterID and AnalysisID = @AnalysisID


 END
--print(@Query);

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END

