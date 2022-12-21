

CREATE PROCEDURE [dbo].[usp_InsertUpdateReserveAccountSchedule]  
@tblTypeReserveAccSchedule TableTypeReserveSchedule readonly,
@UserID UNIQUEIDENTIFIER
AS  
BEGIN  
    SET NOCOUNT ON;  


Declare @DealID UNIQUEIDENTIFIER;
SET @DealID = (Select top 1 dealid from @tblTypeReserveAccSchedule)


CREATE TABLE #tblReserveAccountSchedule (
[DealReserveScheduleID] INT NULL,
[DealReserveScheduleGUID] UNIQUEIDENTIFIER,
DealID uniqueidentifier null,
Date Date null,
PurposeID int null,
Comment NVARCHAR (256) null,
Applied bit null,
isDeleted bit null,
ReserveAccountID int,
CREReserveAccountID NVARCHAR (256),
ReserveScheduleAmount DECIMAL (28, 15),
RNO int null,
[Status] NVARCHAR (256),
);


INSERT INTO #tblReserveAccountSchedule
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
	RNO,
	[Status] 
)
SELECT DISTINCT [DealReserveScheduleID],
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
	RNO,
	'insert' as [Status]
from @tblTypeReserveAccSchedule
where ISNULL(isDeleted,0) <> 1


Update #tblReserveAccountSchedule SET #tblReserveAccountSchedule.[Status] = 'Update'
From(
	SELECT t.[DealReserveScheduleID],t.ReserveAccountID
	from #tblReserveAccountSchedule t
	Inner join [CRE].[ReserveAccountSchedule] r on r.DealReserveScheduleID = t.DealReserveScheduleID and r.ReserveAccountID = t.ReserveAccountID
	where ISNULL(isDeleted,0) <> 1
)a
Where #tblReserveAccountSchedule.DealReserveScheduleID = a.DealReserveScheduleID and #tblReserveAccountSchedule.ReserveAccountID = a.ReserveAccountID




--================================================
--INsert Reserve account Schedule

INSERT INTO [CRE].[ReserveAccountSchedule]
([DealReserveScheduleID]
,[ReserveAccountID]
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

SELECT  [DealReserveScheduleID]
,[ReserveAccountID]
,[Date]
,ReserveScheduleAmount
,[PurposeID]
,[Comment]
,[Applied]
,@UserID,
getdate(),
@UserID,
getdate(),
Rno
from #tblReserveAccountSchedule
where [Status] = 'insert'



Update [CRE].[ReserveAccountSchedule] set 
[CRE].[ReserveAccountSchedule].Date = a.Date,
[CRE].[ReserveAccountSchedule].Amount = a.ReserveScheduleAmount,
[CRE].[ReserveAccountSchedule].PurposeID = a.PurposeID,
[CRE].[ReserveAccountSchedule].Comment = a.Comment,
[CRE].[ReserveAccountSchedule].Applied = a.Applied,
[CRE].[ReserveAccountSchedule].UpdatedBy = @UserID,
[CRE].[ReserveAccountSchedule].UpdatedDate = getdate()
From(
	SELECT  [DealReserveScheduleID]
	,[ReserveAccountID]
	,[Date]
	,ReserveScheduleAmount
	,[PurposeID]
	,[Comment]
	,[Applied]	
	,Rno
	from #tblReserveAccountSchedule
	where [Status] = 'update'
)a
Where [CRE].[ReserveAccountSchedule].DealReserveScheduleID = a.DealReserveScheduleID and [CRE].[ReserveAccountSchedule].ReserveAccountID = a.ReserveAccountID



Delete from [CRE].[ReserveAccountSchedule] WHERE DealReserveScheduleID in (SELECT DealReserveScheduleID from @tblTypeReserveAccSchedule where ISNULL(isDeleted,0)=1)

--=====================================================================================


Update [CRE].[DealReserveSchedule] set RNO = null where DealID = @DealID

Update [CRE].[ReserveAccountSchedule] set RNO = null where ReserveAccountScheduleID in (
	Select rs.ReserveAccountScheduleID 
	from [CRE].[ReserveAccountSchedule] rs
	inner join cre.ReserveAccount ra on ra.ReserveAccountID = rs.ReserveAccountID
	Where ra.DealID = @DealID
)



END