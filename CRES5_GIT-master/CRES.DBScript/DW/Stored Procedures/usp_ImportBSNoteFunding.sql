
CREATE PROCEDURE [DW].[usp_ImportBSNoteFunding]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_BSNoteFundingBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


truncate table [DW].[L_BSNoteFundingBI]


--DECLARE @BackshopProductionFF TABLE
--(
--[NoteID]	nvarchar(256) null,
--[TransactionDate]	Date null,
--[WireConfirm]	bit null,
--[PurposeID]	nvarchar(256) null,
--[Amount]	decimal(28 ,15) null,
--[DrawFundingID] nvarchar(256) null,
--[Comments]	nvarchar(max) null,
--[AuditAddUserId]  nvarchar(256) null,
--[AuditAddDate] DateTime null,
--[AuditUpdateUserId]  nvarchar(256) null,
--[AuditUpdateDate] DateTime null,
--ShardName nvarchar(256) null
--)

--DECLARE @query nvarchar(max) = N'Select CAST(NoteID_f as varchar(256)),FundingDate,WireConfirm,FundingPurposeCD_F,FundingAmount,FundingDrawId,Cast(Comments as nvarchar(max)) as Comments,AuditAddUserId,AuditAddDate,AuditUpdateUserId,AuditUpdateDate
--from [acore].[vw_AcctNoteFundings] '

--INSERT INTO @BackshopProductionFF
--           ([NoteID]
--           ,[TransactionDate]
--           ,[WireConfirm]
--           ,[PurposeID]
--		   ,[Amount]
--           ,[DrawFundingID]
--           ,[Comments]
--           ,[AuditAddUserId]
--           ,[AuditAddDate]
--           ,[AuditUpdateUserId]
--           ,[AuditUpdateDate]
--		   ,ShardName)
--EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
--@stmt = @query

------------------------------------------------------------


--INSERT INTO [DW].[L_BSNoteFundingBI]
--           ([NoteID]
--           ,[TransactionDate]
--           ,[WireConfirm]
--           ,[PurposeID]
--           ,[PurposeBI]
--           ,[Amount]
--           ,[DrawFundingID]
--           ,[Comments]
--           ,[AuditAddUserId]
--           ,[AuditAddDate]
--           ,[AuditUpdateUserId]
--           ,[AuditUpdateDate])

--		 Select  [NoteID]
--           ,[TransactionDate]
--           ,[WireConfirm]
--			,(CASE [PurposeID]
--			WHEN 'PROPREL' THEN 315
--			WHEN 'PAYOFF' THEN 316
--			WHEN 'ADDCOLLPUR' THEN 317
--			WHEN 'CAPEXPEN' THEN 318
--			WHEN 'DSOPEX' THEN 319
--			WHEN 'TILCDRAW' THEN 320
--			WHEN 'OTHER' THEN 321
--			WHEN 'AMORT' THEN 351
--			END
--			)[PurposeID]
--			,(CASE [PurposeID]
--			WHEN 'PROPREL' THEN 'Property Release'
--			WHEN 'PAYOFF' THEN 'Payoff/Paydown'
--			WHEN 'ADDCOLLPUR' THEN 'Additional Collateral Purchase'
--			WHEN 'CAPEXPEN' THEN 'Capital Expenditure'
--			WHEN 'DSOPEX' THEN 'Debt Service / Opex'
--			WHEN 'TILCDRAW' THEN 'TILC Draw'
--			WHEN 'OTHER' THEN 'Other'
--			WHEN 'AMORT' THEN 'Amortization'
--			END
--			)[PurposeBI]
--           ,[Amount]
--           ,[DrawFundingID]
--           ,[Comments]
--           ,[AuditAddUserId]
--           ,[AuditAddDate]
--           ,[AuditUpdateUserId]
--           ,[AuditUpdateDate]
--		   from @BackshopProductionFF




SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportBSNoteFundingBI - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END



