  
  
CREATE PROCEDURE [dbo].[usp_InsertUpdateDealReserveSchedule]    
(
@tblTypeReserveSchedule TableTypeReserveSchedule readonly,  
@UserID UNIQUEIDENTIFIER  
)
AS    
BEGIN    
    SET NOCOUNT ON;    
  
------===========================  
----Truncate table [dbo].[temp]  
----INSERT INTO [dbo].[temp] ([DealReserveScheduleID],[DealReserveScheduleGUID],DealID,Date,Amount,PurposeID,Comment,Applied,isDeleted,ReserveAccountID,CREReserveAccountID,ReserveScheduleAmount,RNO)  
----Select [DealReserveScheduleID],[DealReserveScheduleGUID],DealID,Date,Amount,PurposeID,Comment,Applied,isDeleted,ReserveAccountID,CREReserveAccountID,ReserveScheduleAmount,RNO  
----From @tblTypeReserveSchedule  
------===========================  
  
Declare @DealID UNIQUEIDENTIFIER,@currcount int =1, @NewDealReserveScheduleGUID uniqueidentifier;
SET @DealID = (Select top 1 dealid from @tblTypeReserveSchedule)  
 declare @SavedPurpose int,
		 @SavedAmount decimal(28, 15),
		 @SavedDate date,
		 @PurposeID int,
		 @Amount decimal(28, 15),
		 @Date date,
		 @Applied bit,
		 @Comment NVARCHAR (256),
		 @DealReserveScheduleGUID UNIQUEIDENTIFIER,
		 @Rno int

  
  
CREATE TABLE #tblDealReserveSchedule (  
 [DealReserveScheduleID] INT NULL,  
 [DealReserveScheduleGUID] UNIQUEIDENTIFIER,  
 DealID uniqueidentifier null,  
 Date Date null,  
 Amount DECIMAL (28, 15) null,  
 PurposeID int null,  
 Comment NVARCHAR (256) null,  
 Applied bit null,  
 isDeleted bit null,  
 RNO int null  
);  
  
INSERT INTO #tblDealReserveSchedule  
(  
 DealReserveScheduleID,  
 DealReserveScheduleGUID,  
 DealID,  
 Date,  
 Amount,  
 PurposeID,  
 Comment,  
 Applied,  
 isDeleted,  
 RNO  
)  
SELECT DISTINCT   
DealReserveScheduleID,  
DealReserveScheduleGUID,  
DealID,  
Date,  
Amount,  
PurposeID,  
Comment,  
Applied,  
isDeleted,  
RNO  
from @tblTypeReserveSchedule  
where ISNULL(isDeleted,0) <> 1  
    
  
--================================================  
--INsert Deal Reserve Schedule  
  /*commented by shahid
INSERT INTO [CRE].[DealReserveSchedule]  
([DealID]  
,[Date]  
,[Amount]  
,[PurposeID]  
,[Comment]  
,[Applied]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
,RNO)  
SELECT DealID,Date,Amount,PurposeID,Comment,Applied,@UserID,getdate(),@UserID,getdate() ,Rno  
from   
(  
 SELECT DISTINCT DealID,Date,Amount,PurposeID,Comment,Applied,Rno   
 from #tblDealReserveSchedule  
 where DealReserveScheduleGUID = '00000000-0000-0000-0000-000000000000'   
 and  ISNULL(isDeleted,0) <> 1  
)d  
*/

--added by shahid
CREATE TABLE #tblDealReserveScheduleTobeInserted (  
 ID int identity,
 [DealReserveScheduleGUID] UNIQUEIDENTIFIER,  
 DealID uniqueidentifier null,  
 Date Date null,  
 Amount DECIMAL (28, 15) null,  
 PurposeID int null,  
 Comment NVARCHAR (256) null,  
 Applied bit null,
 RNO int null
);  
INSERT INTO #tblDealReserveScheduleTobeInserted  
(  
 DealReserveScheduleGUID,  
 DealID,  
 Date,  
 Amount,  
 PurposeID,  
 Comment,  
 Applied,
 RNO
)  
 SELECT DISTINCT '00000000-0000-0000-0000-000000000000',DealID,Date,Amount,PurposeID,Comment,Applied,Rno   
 from #tblDealReserveSchedule  
 where DealReserveScheduleGUID = '00000000-0000-0000-0000-000000000000'   
 and  ISNULL(isDeleted,0) <> 1   

while exists(select 1 from #tblDealReserveScheduleTobeInserted where ID = @currcount)
BEGIN
 
	 DECLARE @tDealReserveSchedule TABLE (tDealReserveScheduleGUID UNIQUEIDENTIFIER)
	 select		
		@DealReserveScheduleGUID = DealReserveScheduleGUID,
		@DealID = DealID,    
		@Date  = [Date],
		@Amount = Amount,	 
		@Comment  = Comment,
		@PurposeID =PurposeID,
		@Applied = Applied,
		@Rno=Rno
		from #tblDealReserveScheduleTobeInserted where ID = @currcount
 
		 INSERT INTO [CRE].[DealReserveSchedule]  
		([DealID]  
		,[Date]  
		,[Amount]  
		,[PurposeID]  
		,[Comment]  
		,[Applied]  
		,[CreatedBy]  
		,[CreatedDate]  
		,[UpdatedBy]  
		,[UpdatedDate]  
		,RNO)  
		OUTPUT inserted.DealReserveScheduleGUID INTO @tDealReserveSchedule(tDealReserveScheduleGUID)
		values
		(
		@DealID,
		@Date,
		@Amount,
		@PurposeID,
		@Comment,
		@Applied,
		@UserID,
		getdate(),
		@UserID,
		getdate(),
		@Rno
		)

		SELECT @NewDealReserveScheduleGUID = tDealReserveScheduleGUID FROM @tDealReserveSchedule;

		--insert workflow for this schedule
		set @SavedAmount = ABS(@SavedAmount)
		set @Amount = ABS(@Amount)
		exec dbo.[usp_ResetReserveWorkflow] @PurposeID,@Amount,@Date,@PurposeID,@Amount,@Date,@NewDealReserveScheduleGUID,719,@Applied,@UserID

		set @currcount+=1

END


set @currcount=1
CREATE TABLE #tblDealReserveScheduleTobeUpdated (  
 ID int identity,
 [DealReserveScheduleGUID] UNIQUEIDENTIFIER,  
 DealID uniqueidentifier null,  
 Date Date null,  
 Amount DECIMAL (28, 15) null,  
 PurposeID int null,  
 Comment NVARCHAR (256) null,  
 Applied bit null
);  

INSERT INTO #tblDealReserveScheduleTobeUpdated  
(  
 DealReserveScheduleGUID,  
 DealID,  
 Date,  
 Amount,  
 PurposeID,  
 Comment,  
 Applied
)  
 Select DISTINCT DealReserveScheduleGUID,DealID,Date,Amount,PurposeID,Comment,Applied   
 from #tblDealReserveSchedule  
 where DealReserveScheduleGUID <> '00000000-0000-0000-0000-000000000000' and  ISNULL(isDeleted,0)<>1   

while exists(select 1 from #tblDealReserveScheduleTobeUpdated where ID = @currcount)
BEGIN

 select		
		@DealReserveScheduleGUID = DealReserveScheduleGUID,
		@DealID = DealID,    
		@Date  = [Date],
		@Amount = Amount,	 
		@Comment  = Comment,
		@PurposeID =PurposeID,
		@Applied = Applied
		from #tblDealReserveScheduleTobeUpdated where ID = @currcount

        select @SavedDate = [Date],@SavedAmount =[Amount] ,@SavedPurpose = [PurposeID]  from [CRE].[DealReserveSchedule]  where DealReserveScheduleGUID=@DealReserveScheduleGUID

		Update [CRE].[DealReserveSchedule] Set   
		[CRE].[DealReserveSchedule].Date = @Date,  
		[CRE].[DealReserveSchedule].Amount = @Amount,  
		[CRE].[DealReserveSchedule].PurposeID = @PurposeID,  
		[CRE].[DealReserveSchedule].Comment = @Comment,  
		[CRE].[DealReserveSchedule].Applied = @Applied,  
		[CRE].[DealReserveSchedule].UpdatedBy = @UserID,  
		[CRE].[DealReserveSchedule].UpdatedDate = getdate()
		Where [CRE].[DealReserveSchedule].DealID = @DealID 
		and [CRE].[DealReserveSchedule].DealReserveScheduleGUID = @DealReserveScheduleGUID 
		
		--update workflow for this schedule
		set @SavedAmount = ABS(@SavedAmount)
		set @Amount = ABS(@Amount)
		exec dbo.[usp_ResetReserveWorkflow] @SavedPurpose,@SavedAmount,@SavedDate,@PurposeID,@Amount,@Date,@DealReserveScheduleGUID,719,@Applied,@UserID

set @currcount+=1
END


--

/*commented by shahid

Update [CRE].[DealReserveSchedule] Set   
[CRE].[DealReserveSchedule].Date = a.Date,  
[CRE].[DealReserveSchedule].Amount = a.Amount,  
[CRE].[DealReserveSchedule].PurposeID = a.PurposeID,  
[CRE].[DealReserveSchedule].Comment = a.Comment,  
[CRE].[DealReserveSchedule].Applied = a.Applied,  
[CRE].[DealReserveSchedule].UpdatedBy = @UserID,  
[CRE].[DealReserveSchedule].UpdatedDate = getdate()  
from (  
 Select DISTINCT DealID,Date,Amount,PurposeID,Comment,Applied,DealReserveScheduleGUID   
 from #tblDealReserveSchedule  
 where DealReserveScheduleGUID <> '00000000-0000-0000-0000-000000000000' and  ISNULL(isDeleted,0)<>1   
)a  
Where [CRE].[DealReserveSchedule].DealID = a.DealID  
and [CRE].[DealReserveSchedule].DealReserveScheduleGUID = a.DealReserveScheduleGUID  
 */
  

  
  
 ----Reserve schedule 
DECLARE @tblResAccScheData TableTypeReserveSchedule  
  
INSERT INTO @tblResAccScheData  
(  
 [DealReserveScheduleID],  
 [DealReserveScheduleGUID] ,  
 DealID,  
 Date,  
 PurposeID,  
 Comment,  
 Applied,  
 isDeleted,  
 ReserveAccountID ,  
 CREReserveAccountID,  
 ReserveScheduleAmount,  
 RNO  
)  
Select [DealReserveScheduleID],[DealReserveScheduleGUID] ,DealID,Date,PurposeID,Comment,Applied,isDeleted,ReserveAccountID ,CREReserveAccountID,ReserveScheduleAmount,RNO  
From(  
 SELECT   
 [DealReserveScheduleID],  
 [DealReserveScheduleGUID] ,  
 DealID,  
 Date,  
 PurposeID,  
 Comment,  
 Applied,  
 isDeleted,  
 ReserveAccountID ,  
 CREReserveAccountID,  
 ReserveScheduleAmount,  
 RNO  
 from @tblTypeReserveSchedule rs where [DealReserveScheduleID] <> 0  
  
 UNION ALL  
  
 SELECT   
 dr.DealReserveScheduleID,  
 dr.DealReserveScheduleGUID,  
 rs.DealID,  
 rs.Date,  
 rs.PurposeID,  
 rs.Comment,  
 rs.Applied,  
 rs.isDeleted,  
 rs.ReserveAccountID ,  
 rs.CREReserveAccountID,  
 rs.ReserveScheduleAmount,  
 rs.RNO  
 from @tblTypeReserveSchedule rs   
 Inner join  [CRE].[DealReserveSchedule] dr on dr.rno = rs.rno   
 where dr.dealid = @dealid  
 and rs.DealReserveScheduleID = 0  
  
)z  
  
  
exec [dbo].[usp_InsertUpdateReserveAccountSchedule]  @tblResAccScheData,@UserID  
---------------------------------------  
  
  
Delete from [CRE].[DealReserveSchedule] WHERE DealReserveScheduleID in (SELECT DealReserveScheduleID from @tblTypeReserveSchedule where ISNULL(isDeleted,0)=1)  
--===================================================================================== 

--delete funding from workflow
Delete from cre.WFTaskDetail where WFTaskDetailID in (Select WFTaskDetailID from cre.WFTaskDetail wt join @tblTypeReserveSchedule tempt on wt.TaskID = tempt.DealReserveScheduleGUID where wt.TaskTypeID=719 and ISNULL(tempt.isDeleted,0)=1)
Delete from cre.WFTaskDetailArchive where WFTaskDetailID in (Select WFTaskDetailID from cre.WFTaskDetailArchive wt join @tblTypeReserveSchedule tempt on wt.TaskID = tempt.DealReserveScheduleGUID where wt.TaskTypeID=719 and ISNULL(tempt.isDeleted,0)=1)
Delete from cre.WFCheckListDetail where WFCheckListDetailID in (Select WFCheckListDetailID from cre.WFCheckListDetail wt join @tblTypeReserveSchedule tempt on wt.TaskID = tempt.DealReserveScheduleGUID where wt.TaskTypeID=719 and ISNULL(tempt.isDeleted,0)=1)

  
  
  
  
  
----INSERT INTO #tblReserveAccountSchedule  
----(  
---- [DealReserveScheduleID],  
---- [DealReserveScheduleGUID] ,  
---- DealID,  
---- Date,  
---- PurposeID,  
---- Comment,  
---- Applied,  
---- isDeleted,  
---- ReserveAccountID ,  
---- CREReserveAccountID,  
---- ReserveScheduleAmount,  
---- RNO  
----)  
----SELECT DISTINCT [DealReserveScheduleID],  
---- [DealReserveScheduleGUID] ,  
---- DealID,  
---- Date,  
---- PurposeID,  
---- Comment,  
---- Applied,  
---- isDeleted,  
---- ReserveAccountID ,  
---- CREReserveAccountID,  
---- ReserveScheduleAmount,  
---- RNO  
----from @tblTypeReserveSchedule  
  
END