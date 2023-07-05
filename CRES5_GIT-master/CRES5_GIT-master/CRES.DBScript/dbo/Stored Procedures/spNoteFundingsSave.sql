CREATE PROCEDURE dbo.spNoteFundingsSave
	@FundingID int,
	@NoteId_F int,
	@Applied bit,
	@FundingDate DateTime,
	@FundingAmount decimal(28,12),
	@Comments nvarchar(max),
	@FundingPurposeCD_F nvarchar(max),
	@FundingDrawId  nvarchar(max),
	@FundingExpense  decimal(28,12),
	@ExpenseComments  nvarchar(max),
	@WireConfirm bit,
	@AuditUserName nvarchar(max),
	@Status nvarchar(256),
	@NoteFundingReasonCD_F nvarchar(10),
	@GeneratedBy nvarchar(255)

AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
@stmt = N'dbo.spNoteFundingsSave @FundingID,
@NoteId_F,
@Applied,
@FundingDate,
@FundingAmount,
@Comments,
@FundingPurposeCD_F,
@FundingDrawId,
@FundingExpense,
@ExpenseComments,
@WireConfirm,
@AuditUserName,
@Status,
@NoteFundingReasonCD_F,
@GeneratedBy
', 
@params = N'@FundingID int,
	@NoteId_F int,
	@Applied bit,
	@FundingDate DateTime,
	@FundingAmount decimal(28,12),
	@Comments nvarchar(max),
	@FundingPurposeCD_F nvarchar(max),
	@FundingDrawId  nvarchar(max),
	@FundingExpense  decimal(28,12),
	@ExpenseComments  nvarchar(max),
	@WireConfirm bit,
	@AuditUserName nvarchar(max),
	@Status nvarchar(256),
	@NoteFundingReasonCD_F nvarchar(10),
	@GeneratedBy nvarchar(255)',

@FundingID  = @FundingID ,
@NoteId_F  = @NoteId_F ,
@Applied  = @Applied ,
@FundingDate  = @FundingDate ,
@FundingAmount  = @FundingAmount ,
@Comments  = @Comments ,
@FundingPurposeCD_F  = @FundingPurposeCD_F ,
@FundingDrawId  = @FundingDrawId ,
@FundingExpense  = @FundingExpense ,
@ExpenseComments  = @ExpenseComments ,
@WireConfirm  = @WireConfirm ,
@AuditUserName  = @AuditUserName,
@Status  = @Status,
@NoteFundingReasonCD_F = @NoteFundingReasonCD_F,
@GeneratedBy = @GeneratedBy

END
GO

