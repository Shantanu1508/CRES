
CREATE PROCEDURE [DW].[usp_MergeUwNoteFunding]
@BatchLogId int

AS
BEGIN

SET NOCOUNT ON

UPDATE [DW].BatchDetail
SET
BITableName = 'UwNoteFundingBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteFundingBI'

--===================================
Declare @BSNoteFunding as Table(
FundingID int NULL,
Noteid_F int NULL,
Applied bit NULL,
FundingDate datetime NULL,
FundingAmount decimal(28, 15) NULL,
Comments nvarchar(max) NULL,
AuditAddDate datetime NULL,
AuditAddUserId nvarchar(150) NULL,
AuditUpdateDate datetime NULL,
AuditUpdateUserId nvarchar(150) NULL,
FundingCSPrincipal decimal(28, 15) NULL,
FundingLBInterest float NULL,
FundingLBLock bit NULL,
FundingPurposeCD_F nvarchar(256) NULL,
FundingDrawId nvarchar(256) NULL,
FundingExpense decimal(28, 15) NULL,
ExpenseComments nvarchar(max) NULL,
WireConfirm bit NULL,
SharedName nvarchar(max) NULL
)

Insert Into @BSNoteFunding(
FundingID,
Noteid_F,
Applied,
FundingDate,
FundingAmount,
Comments,
AuditAddDate,
AuditAddUserId,
AuditUpdateDate,
AuditUpdateUserId,
FundingCSPrincipal,
FundingLBInterest,
FundingLBLock,
FundingPurposeCD_F,
FundingDrawId,
FundingExpense,
ExpenseComments,
WireConfirm,
SharedName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'
Select 
NF.FundingID,
NF.Noteid_F,
NF.Applied,
NF.FundingDate,
NF.FundingAmount,
Cast(NF.Comments as nvarchar(256)) as Comments,
NF.AuditAddDate,
NF.AuditAddUserId,
NF.AuditUpdateDate,
NF.AuditUpdateUserId,
NF.FundingCSPrincipal,
NF.FundingLBInterest,
NF.FundingLBLock,
LFundingPurposeCD_F.FundingPurposeDesc FundingPurposeCD_F,
NF.FundingDrawId,
NF.FundingExpense,
Cast(NF.ExpenseComments as nvarchar(256)) as ExpenseComments,
NF.WireConfirm
from tblNoteFunding NF
left join tblzcdFundingPurpose LFundingPurposeCD_F
on LFundingPurposeCD_F.FundingPurposeCD = NF.FundingPurposeCD_F'
--===================================

Truncate table [DW].[UwNoteFundingBI];

INSERT INTO [DW].[UwNoteFundingBI](
FundingID,
Noteid_F,
Applied,
FundingDate,
FundingAmount,
Comments,
AuditAddDate,
AuditAddUserId,
AuditUpdateDate,
AuditUpdateUserId,
FundingCSPrincipal,
FundingLBInterest,
FundingLBLock,
FundingPurposeCD_F,
FundingDrawId,
FundingExpense,
ExpenseComments,
WireConfirm	
)
SELECT 
FundingID,
Noteid_F,
Applied,
FundingDate,
FundingAmount,
Comments,
AuditAddDate,
AuditAddUserId,
AuditUpdateDate,
AuditUpdateUserId,
FundingCSPrincipal,
FundingLBInterest,
FundingLBLock,
FundingPurposeCD_F,
FundingDrawId,
FundingExpense,
ExpenseComments,
WireConfirm	
FROM @BSNoteFunding

DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteFundingBI'

Print(char(9) +'usp_MergeUwNoteFunding - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END
