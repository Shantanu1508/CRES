CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForAutoSpreadUnderwritingData] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @tbl_AS_UnderwritingData_BS as Table(
ProjectedPayOffHeaderId int null,
ControlId	nvarchar(256) null,
EarliestDate	Date null,
LatestDate		Date null,
OpenDate		Date null,
ExpectedDate	Date null,	
AuditUpdateDate	DateTime null,	
AsOfDate Date null,
CumulativeProbability decimal(28,15) null,
ShardName nvarchar(256) null
)

Declare @l_credealid nvarchar(256)
 
IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	Select Distinct d.credealid
	from cre.Note n
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.Deal d on n.DealID = d.DealID
	where n.ActualPayoffdate is null 
	and acc.IsDeleted <> 1 and d.isdeleted <> 1
	and d.Status = 323
	and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
	and ISNULL(EnableAutoSpreadRepayments,0) = 1
	and AutoUpdateFromUnderwriting  = 1	
)


OPEN CursorDeal 

FETCH NEXT FROM CursorDeal
INTO @l_credealid

WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @query nvarchar(MAX) = N'exec acore.spProjectedPayOffAccounting '''+@l_credealid+''''
	INSERT INTO @tbl_AS_UnderwritingData_BS([ProjectedPayOffHeaderId],[ControlId],[EarliestDate],[LatestDate],OpenDate,[ExpectedDate],[AuditUpdateDate],[AsOfDate],[CumulativeProbability],ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query
					 
FETCH NEXT FROM CursorDeal
INTO @l_credealid
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal
---=================================================

Declare @tbl_AS_UnderwritingData_M61 as Table(
ControlId	nvarchar(256) null,
EarliestDate	Date null,
LatestDate		Date null,
OpenDate		Date null,
ExpectedDate	Date null,	
AuditUpdateDate	DateTime null,	
AsOfDate Date null,
CumulativeProbability decimal(28,15) null
)

INSERT INTO @tbl_AS_UnderwritingData_M61([ControlId],[EarliestDate],[LatestDate],[ExpectedDate],[AuditUpdateDate],[AsOfDate],[CumulativeProbability])
Select distinct d.credealid
,ISNULL(d.EarliestPossibleRepaymentDate,'1/1/1900')  as EarliestPossibleRepaymentDate
,ISNULL(d.LatestPossibleRepaymentDate,'1/1/1900')	 as LatestPossibleRepaymentDate
,ISNULL(d.ExpectedFullRepaymentDate,'1/1/1900')		 as ExpectedFullRepaymentDate
,ISNULL(d.AutoPrepayEffectiveDate,'1/1/1900')		 as AutoPrepayEffectiveDate
,asr.AsOfDate,(asr.CumulativeProbability * 100) as CumulativeProbability
from cre.Deal d 
inner join cre.Note n on n.DealID = d.DealID
inner join core.account acc on acc.accountid = n.account_accountid
Left JOin [CRE].[DealProjectedPayOffAccounting] asr on asr.dealid = d.dealid
where n.ActualPayoffdate is null 
and acc.IsDeleted <> 1 and d.isdeleted <> 1
and d.Status = 323
and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
and ISNULL(EnableAutoSpreadRepayments,0) = 1
and AutoUpdateFromUnderwriting  = 1	
--and credealid <> '15-0461'



--Select Distinct ControlId,EarliestDate as EarliestPossibleRepaymentDate,LatestDate as LatestPossibleRepaymentDate,ExpectedDate as ExpectedFullRepaymentDate,CAST(AuditUpdateDate as date) as AutoPrepayEffectiveDate,AsOfDate,CumulativeProbability
--from @tbl_AS_UnderwritingData_M61
--where controlid = '15-0461'

--Select ControlId,EarliestDate as EarliestPossibleRepaymentDate,LatestDate as LatestPossibleRepaymentDate,ExpectedDate as ExpectedFullRepaymentDate,CAST(AuditUpdateDate as date) as AutoPrepayEffectiveDate,AsOfDate,CumulativeProbability
--from @tbl_AS_UnderwritingData_BS
--where controlid = '15-0461'



Select Distinct ControlId from (
	Select BS.ControlId
	,BS.EarliestPossibleRepaymentDate as BS_EarliestPossibleRepaymentDate
	,BS.LatestPossibleRepaymentDate	  as BS_LatestPossibleRepaymentDate
	,BS.ExpectedFullRepaymentDate	  as BS_ExpectedFullRepaymentDate
	,BS.AutoPrepayEffectiveDate		  as BS_AutoPrepayEffectiveDate

	,M61.EarliestPossibleRepaymentDate as M61_EarliestPossibleRepaymentDate
	,M61.LatestPossibleRepaymentDate   as M61_LatestPossibleRepaymentDate
	,M61.ExpectedFullRepaymentDate	   as M61_ExpectedFullRepaymentDate
	,M61.AutoPrepayEffectiveDate 	   as M61_AutoPrepayEffectiveDate
	,(CASE WHEN (ISNULL(M61.EarliestPossibleRepaymentDate,'1/1/1900') <> BS.EarliestPossibleRepaymentDate OR ISNULL(M61.LatestPossibleRepaymentDate,'1/1/1900') <> BS.LatestPossibleRepaymentDate OR ISNULL(M61.ExpectedFullRepaymentDate,'1/1/1900') <> BS.ExpectedFullRepaymentDate OR ISNULL(M61.AutoPrepayEffectiveDate,'1/1/1900') <> BS.AutoPrepayEffectiveDate) THEN  1 ELSE 0 END) IsDelta
	from (
		Select Distinct ControlId
		,ISNULL(EarliestDate,'1/1/1900') as EarliestPossibleRepaymentDate
		,ISNULL(LatestDate,'1/1/1900') as LatestPossibleRepaymentDate
		,ISNULL(ExpectedDate,'1/1/1900') as ExpectedFullRepaymentDate
		,ISNULL(CAST(AuditUpdateDate as date),'1/1/1900') as AutoPrepayEffectiveDate
		from @tbl_AS_UnderwritingData_BS 		
	)BS
	LEFT JOIN(
		Select Distinct ControlId,EarliestDate as EarliestPossibleRepaymentDate,LatestDate as LatestPossibleRepaymentDate,ExpectedDate as ExpectedFullRepaymentDate,CAST(AuditUpdateDate as date) as AutoPrepayEffectiveDate
		from @tbl_AS_UnderwritingData_M61
		--where controlid = '15-0461'
	)M61 on BS.ControlId = M61.ControlId

)a
where IsDelta = 1

UNION

Select Distinct ControlID
From(
	Select 
	ISNULL(BS.ControlId,M61.ControlId) ControlID,
	BS.AsOfDate as BS_AsOfDate,
	BS.CumulativeProbability as BS_CumulativeProbability,
	M61.ControlId as M61_ControlId,
	M61.AsOfDate as M61_AsOfDate,
	M61.CumulativeProbability as M61_CumulativeProbability
	from (
		Select Distinct ControlId,AsOfDate,CumulativeProbability
		from @tbl_AS_UnderwritingData_BS 	
		--where controlid = '15-0461' 
		--and AsOfDate <> '2027-12-31'
	)BS
	FULL Outer JOIN(
		Select Distinct ControlId,AsOfDate,CumulativeProbability
		from @tbl_AS_UnderwritingData_M61	
		--where controlid = '15-0461'
		--and AsOfDate <> '2026-12-31'
	)M61 on BS.ControlId = M61.ControlId and BS.AsOfDate = M61.AsOfDate and BS.CumulativeProbability = M61.CumulativeProbability

	where (M61.ControlId is null or BS.ControlId is null)
)b




 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END   