
Create PROCEDURE [dbo].[usp_GetDiscrepancyForCommitmentData]  
(   
    @DealID UNIQUEIDENTIFIER = null
)	

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



Declare @DealCommitment as table(
DealID UNIQUEIDENTIFIER,
[Type]	int,
[Date]	date,
TypeText	nvarchar(200),
CommitmentType	nvarchar(200)
)


Declare @ObjectIDDeal UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(	
	Select DealID from cre.Deal where IsDeleted <> 1 and [Status] = 323 --and  dealid = '68c693d9-dea6-49f0-a929-4341d5df5e1f'
)
OPEN CursorDeal 
FETCH NEXT FROM CursorDeal
INTO @ObjectIDDeal
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO @DealCommitment(DealID,[Type],[Date],TypeText,CommitmentType)
	exec [dbo].[usp_GetAdjustmentCommitmentByDealID_forCommitQuery] 'b0e6697b-3534-4c09-be0a-04473401ab93',@ObjectIDDeal					 
FETCH NEXT FROM CursorDeal
INTO @ObjectIDDeal
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal




Declare @DealCommitment_distinct as table(
DealID UNIQUEIDENTIFIER,
[Type]	int,
[Date]	date
)

Delete from @DealCommitment_distinct

INSERT INTO @DealCommitment_distinct(DealID,[Type],[Date])
Select distinct DealID,[Type],[Date] from @DealCommitment



Select * from
(
	Select d.DealName as [Deal Name],count(dc.DealID) as [Actual commit count],isnull(tbldb.dc_dbCount,0) as [DB commit count], (count(dc.DealID) - ISNULL(tbldb.dc_dbCount,0)) as Delta
	from @DealCommitment_distinct dc
	left join cre.deal d on d.dealid = dc.dealid
	left join(
		Select dealid,count(a.dealid) dc_dbCount
		from(
			Select distinct DealID,[Type],[Date] 
			from cre.NoteAdjustedCommitmentMaster --where dealid = '8714EEA0-D6C8-45E6-A3C7-1CF13BF5FBA5'
		)a
		group by a.dealid
	)tbldb on tbldb.DealID = dc.DealID

	group by d.dealname,tbldb.dc_dbCount
)a
where a.delta <> 0
order by a.[Deal Name]



		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END