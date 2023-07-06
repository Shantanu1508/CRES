

CREATE PROCEDURE [DW].[usp_MergeBSNoteFunding]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'BSNoteFundingBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_BSNoteFundingBI'


DECLARE @BackshopProductionFF TABLE
(
[NoteID]	nvarchar(256) null,
[TransactionDate]	Date null,
[WireConfirm]	bit null,
[PurposeID]	nvarchar(256) null,
[Amount]	decimal(28 ,15) null,
[DrawFundingID] nvarchar(256) null,
[Comments]	nvarchar(max) null,
[AuditAddUserId]  nvarchar(256) null,
[AuditAddDate] DateTime null,
[AuditUpdateUserId]  nvarchar(256) null,
[AuditUpdateDate] DateTime null,
ShardName nvarchar(256) null
)

--DECLARE @query nvarchar(max) = N'Select vn.ControlId_F, CAST(BSFF.NoteID_f as varchar(256)),BSFF.FundingDate,BSFF.WireConfirm,BSFF.FundingPurposeCD_F,BSFF.FundingAmount,BSFF.FundingDrawId,Cast(BSFF.Comments as nvarchar(max)) as Comments,BSFF.AuditAddUserId,BSFF.AuditAddDate,BSFF.AuditUpdateUserId,BSFF.AuditUpdateDate
--from [acore].[vw_AcctNoteFundings] BSFF
--left join viewNote vn on BSFF.NoteID_f = vn.noteid '

DECLARE @query nvarchar(max) = N'Select CAST(NoteID_f as varchar(256)),FundingDate,WireConfirm,FundingPurposeCD_F,FundingAmount,FundingDrawId,Cast(Comments as nvarchar(max)) as Comments,AuditAddUserId,AuditAddDate,AuditUpdateUserId,AuditUpdateDate
from [acore].[vw_AcctNoteFundings] '



INSERT INTO @BackshopProductionFF
           ([NoteID]
           ,[TransactionDate]
           ,[WireConfirm]
           ,[PurposeID]
		   ,[Amount]
           ,[DrawFundingID]
           ,[Comments]
           ,[AuditAddUserId]
           ,[AuditAddDate]
           ,[AuditUpdateUserId]
           ,[AuditUpdateDate]
		   ,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
@stmt = @query

----------------------------------------------------------
truncate table [DW].[BSNoteFundingBI]

INSERT INTO [DW].[BSNoteFundingBI]
           ([NoteID]
           ,[TransactionDate]
           ,[WireConfirm]
           ,[PurposeID]
           ,[PurposeBI]
           ,[Amount]
           ,[DrawFundingID]
           ,[Comments]
           ,[AuditAddUserId]
           ,[AuditAddDate]
           ,[AuditUpdateUserId]
           ,[AuditUpdateDate])

		 Select  [NoteID]
           ,[TransactionDate]
           ,[WireConfirm]
			,(CASE [PurposeID]
			WHEN 'PROPREL' THEN 315
			WHEN 'PAYOFF' THEN 316
			WHEN 'ADDCOLLPUR' THEN 317
			WHEN 'CAPEXPEN' THEN 318
			WHEN 'DSOPEX' THEN 319
			WHEN 'TILCDRAW' THEN 320
			WHEN 'OTHER' THEN 321
			WHEN 'AMORT' THEN 351
			WHEN 'CAPINTC' THEN 517
			WHEN 'CAPINTN' THEN 518
			WHEN 'OPEX' THEN 519
			WHEN 'FORCEFUND' THEN 520
			END
			)[PurposeID]
			,(CASE [PurposeID]
			WHEN 'PROPREL' THEN 'Property Release'
			WHEN 'PAYOFF' THEN 'Payoff/Paydown'
			WHEN 'ADDCOLLPUR' THEN 'Additional Collateral Purchase'
			WHEN 'CAPEXPEN' THEN 'Capital Expenditure'
			WHEN 'DSOPEX' THEN 'Debt Service / Opex'
			WHEN 'TILCDRAW' THEN 'TILC Draw'
			WHEN 'OTHER' THEN 'Other'
			WHEN 'AMORT' THEN 'Amortization'
			WHEN  'CAPINTC' THEN 'Capitalized Interest (Complex)'
			WHEN 'CAPINTN' THEN 'Capitalized Interest (Non-Complex)' 
			WHEN 'OPEX' THEN 'Opex'
			WHEN 'FORCEFUND' THEN 'Force Funding'
			END
			)[PurposeBI]
           ,[Amount]
           ,[DrawFundingID]
           ,[Comments]
           ,[AuditAddUserId]
           ,[AuditAddDate]
           ,[AuditUpdateUserId]
           ,[AuditUpdateDate]
		   from @BackshopProductionFF 
		   where Noteid in (Select distinct crenoteid from cre.note)




		

DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_BSNoteFundingBI'

Print(char(9) +'usp_MergeBSNoteFunding - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

