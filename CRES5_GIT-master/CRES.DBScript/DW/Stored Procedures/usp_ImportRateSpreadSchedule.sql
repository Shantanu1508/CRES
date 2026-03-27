-- Procedure

CREATE PROCEDURE [DW].[usp_ImportRateSpreadSchedule]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_RateSpreadScheduleBI',GETDATE())

		DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


Truncate table [DW].[L_RateSpreadScheduleBI]

IF EXISTS(Select top 1 noteid from [DW].[L_NoteBI])
BEGIN
		
INSERT INTO [DW].[L_RateSpreadScheduleBI](
RateSpreadScheduleID,
EventId,
Date,
ValueTypeID,
Value,
IntCalcMethodID,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
RateOrSpreadToBeStripped,
ValueTypeBI,
IntCalcMethodBI,
CreDealId,
DealName,
CreNoteID,
NoteName,
RateSpreadScheduleAutoID,
ScheduleText,
IndexNameID,
IndexNameBI,
EffectiveStartDate)

Select
rs.RateSpreadScheduleID,
rs.EventId,
rs.Date,
rs.ValueTypeID,
rs.Value,
rs.IntCalcMethodID,
rs.CreatedBy,
rs.CreatedDate,
rs.UpdatedBy,
rs.UpdatedDate,
rs.RateOrSpreadToBeStripped,
LValueTypeID.name as ValueTypeBI,
LIntCalcMethodID.name as IntCalcMethodBI,
d.CreDealId,
d.DealName,
n.CreNoteID,
acc.name as NoteName,
rs.RateSpreadScheduleAutoID,
(CASE WHEN e.EffectiveStartDate = tblLatest.EffectiveStartDate THEN 'Latest Schedule' ELSE 'History Schedule' END) as ScheduleText,

rs.IndexNameID,
lindex.name as IndexNameBI,
e.EffectiveStartDate

from [CORE].RateSpreadSchedule rs
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN cre.deal d on d.dealid = n.dealid
Left Join(
	Select 
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)	
	and acc.IsDeleted = 0
	GROUP BY n.Account_AccountID,EventTypeID
)tblLatest on tblLatest.accountid = n.account_accountid
where e.StatusID = 1
and acc.Isdeleted <> 1
and n.noteid in (Select Distinct noteid from [DW].[L_NoteBI])

END

--and n.crenoteid in (
--	Select Distinct n.crenoteid from [CORE].RateSpreadSchedule rs
--	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--	Where e.StatusID = 1 and rs.RateSpreadScheduleAutoID in 
--	(
--		Select Distinct [RateSpreadScheduleAutoID] From(
--			Select	[RateSpreadScheduleAutoID],[CreatedDate],[UpdatedDate]	From core.RateSpreadSchedule
--			EXCEPT
--			Select	[RateSpreadScheduleAutoID],[CreatedDate],[UpdatedDate]	From DW.RateSpreadScheduleBI
--		)a
--	)	
--)



SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportRateSpreadSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


