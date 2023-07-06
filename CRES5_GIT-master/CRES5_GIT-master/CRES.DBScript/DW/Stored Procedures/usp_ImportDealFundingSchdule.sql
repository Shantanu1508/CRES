
CREATE PROCEDURE [DW].[usp_ImportDealFundingSchdule]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_DealFundingSchduleBI',GETDATE())

	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


--IF EXISTS(Select DealID from [dw].[DealFundingSchduleBI])
--BEGIN

--Truncate table [DW].[L_DealFundingSchduleBI]

--INSERT INTO [DW].[L_DealFundingSchduleBI]
--	([DealFundingID]
--	,[DealID]
--	,[CREDealID]
--	,[Date]
--	,[Amount]    
--	,[PurposeID]  
--	,[PurposeBI]
--	,[Applied]
--	,[Comment]
--	,[DrawFundingId]	  
--	,[CreatedBy]
--	,[CreatedDate]
--	,[UpdatedBy]
--	,[UpdatedDate])
--Select
--d.[DealFundingID],
--d.[DealID],
--deal.[CREDealID],
--d.[Date],
--d.[Amount],
--d.PurposeID,
--lPurpose.Name,
--d.[Applied],
--d.[Comment],
--d.[DrawFundingId],
--d.[CreatedBy],
--d.[CreatedDate],
--d.[UpdatedBy],
--d.[UpdatedDate]
--FROM CRE.DealFunding d
--inner join cre.Deal deal on d.DealID = deal.DealID
--LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50

----WHERE (d.CreatedDate > @LastBatchStart 
----				and d.CreatedDate < @CurrentBatchStart) 
----				OR 
----				(d.UpdatedDate > @LastBatchStart 
----				and d.UpdatedDate < @CurrentBatchStart)


--SET @RowCount = @@ROWCOUNT
--Print(char(9) +'usp_ImportDealFundingSchdule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

--END
--ELSE
--BEGIN

--	Truncate table [DW].[L_DealFundingSchduleBI]
--	INSERT INTO [DW].[L_DealFundingSchduleBI]
--	([DealFundingID]
--	,[DealID]
--	,[CREDealID]
--	,[Date]
--	,[Amount]    
--	,[PurposeID]  
--	,[PurposeBI]
--	,[Applied]
--	,[Comment]
--	,[DrawFundingId]	  
--	,[CreatedBy]
--	,[CreatedDate]
--	,[UpdatedBy]
--	,[UpdatedDate])
--Select
--d.[DealFundingID],
--d.[DealID],
--deal.[CREDealID],
--d.[Date],
--d.[Amount],
--d.PurposeID,
--lPurpose.Name,
--d.[Applied],
--d.[Comment],
--d.[DrawFundingId],
--d.[CreatedBy],
--d.[CreatedDate],
--d.[UpdatedBy],
--d.[UpdatedDate]
--FROM CRE.DealFunding d
--inner join cre.Deal deal on d.DealID = deal.DealID
--LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50

SET @RowCount = 0  ---@@ROWCOUNT
--Print(char(9) +char(9)+'usp_ImportDealFundingSchdule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

--END




UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END


