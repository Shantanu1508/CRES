CREATE PROCEDURE [dbo].[usp_GetAutoSpreadEffectiveDateChangeBtwBackshopandM61]
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Declare @tbl_ProjectedPayOffAccounting as Table(
ProjectedPayOffHeaderId int null,
ControlId	nvarchar(256) null,
EarliestDate	Date null,
LatestDate		Date null,
OpenDate		Date null,
ExpectedDate	Date null,	
AuditUpdateDate	DateTime null,	
AsOfDate Date null,
CumulativeProbability decimal(28,15) null,
[Status] nvarchar(256) null,
ShardName nvarchar(256) null
)


Declare @CREDealID nvarchar(256) 
Declare @EffectiveDate Date 

IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	select credealid,AutoPrepayEffectiveDate from cre.deal 
	where isdeleted <> 1 
	and Status = 323 
	and EnableAutoSpreadRepayments = 1
	and AutoPrepayEffectiveDate is not null
)
OPEN CursorDeal 
FETCH NEXT FROM CursorDeal
INTO @CREDealID,@EffectiveDate

WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @query nvarchar(MAX) = N'exec acore.spProjectedPayOffAccounting '''+@CREDealID+''''
	INSERT INTO @tbl_ProjectedPayOffAccounting([ProjectedPayOffHeaderId],[ControlId],[EarliestDate],[LatestDate],OpenDate,[ExpectedDate],[AuditUpdateDate],[AsOfDate],[CumulativeProbability],ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query
				 
FETCH NEXT FROM CursorDeal
INTO @CREDealID,@EffectiveDate
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal




select d.Dealname,d.CREDealid,AutoPrepayEffectiveDate ,tblBS.AuditUpdateDate
from cre.deal d
Left Join (
	Select Distinct ControlId,CAST(AuditUpdateDate  as Date) as AuditUpdateDate 
	from @tbl_ProjectedPayOffAccounting
)tblBS on tblBS.ControlId = d.CREDealID
where d.isdeleted <> 1 and d.Status = 323 and d.EnableAutoSpreadRepayments = 1 and d.AutoPrepayEffectiveDate is not null
and AutoPrepayEffectiveDate <> tblBS.AuditUpdateDate


END