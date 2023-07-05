

CREATE PROCEDURE [DW].[usp_MergeDealFundingSchdule]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'DealFundingSchduleBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealFundingSchduleBI'


DECLARE @RowCount int = 0

IF EXISTS(Select DealID from [dw].[L_DealBI])
BEGIN

--Truncate table [DW].[DealFundingSchduleBI]

Delete from [DW].[DealFundingSchduleBI] where [DealID] in (Select DealID from [dw].[L_DealBI])

INSERT INTO [DW].[DealFundingSchduleBI]
	([DealFundingID]
	,[DealID]
	,[CREDealID]
	,[Date]
	,[Amount]    
	,[PurposeID]  
	,[PurposeBI]
	,[Applied]
	,[Comment]
	,[DrawFundingId]	  
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	,[Projected]
	,GeneratedBy
	,GeneratedByBI )
Select
d.[DealFundingID],
d.[DealID],
deal.[CREDealID],
d.[Date],
d.[Amount],
d.PurposeID,
lPurpose.Name,
d.[Applied],
d.[Comment],
d.[DrawFundingId],
d.[CreatedBy],
d.[CreatedDate],
d.[UpdatedBy],
d.[UpdatedDate],
(CASE WHEN (lPurpose.Name = 'Paydown' and d.GeneratedBy = 747 and d.Applied <> 1) then 'True' ELse 'False' END) as [Projected],
d.GeneratedBy,
Lgb.name as GeneratedByBI
FROM CRE.DealFunding d
inner join cre.Deal deal on d.DealID = deal.DealID
LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50
left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = d.GeneratedBy 

where d.[DealID] in (Select DealID from [dw].[L_DealBI])

SET @RowCount = @@ROWCOUNT

END





UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealFundingSchduleBI'

Print(char(9) +'usp_MergeDealFundingSchdule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

