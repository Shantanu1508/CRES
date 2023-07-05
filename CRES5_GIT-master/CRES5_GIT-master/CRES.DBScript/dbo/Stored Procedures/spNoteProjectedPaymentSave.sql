CREATE PROCEDURE dbo.spNoteProjectedPaymentSave
	@ProjectedPaymentId int,
	@NoteId_F int,	
	@PaymentDate DateTime,
	@Amount decimal(28,12),
	@FundingPurposeCD_F nvarchar(max),	
	@Comments nvarchar(max),
	@InactiveSw bit,
	@SortOrder int,
	@AuditUserName nvarchar(max),
	@GeneratedBy nvarchar(255)
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
@stmt = N'acore.spNoteProjectedPaymentSave @ProjectedPaymentId,
@NoteId_F,	
@PaymentDate,
@Amount,
@FundingPurposeCD_F,	
@Comments,
@InactiveSw,
@SortOrder,
@AuditUserName,
@GeneratedBy
', 
@params = N'@ProjectedPaymentId int,
	@NoteId_F int,	
	@PaymentDate DateTime,
	@Amount decimal(28,12),
	@FundingPurposeCD_F nvarchar(max),	
	@Comments nvarchar(max),
	@InactiveSw bit,
	@SortOrder int,
	@AuditUserName nvarchar(max),
	@GeneratedBy nvarchar(255)',

@ProjectedPaymentId = @ProjectedPaymentId,
@NoteId_F = @NoteId_F,
@PaymentDate = @PaymentDate,
@Amount = @Amount,
@FundingPurposeCD_F = @FundingPurposeCD_F,
@Comments = @Comments,
@InactiveSw = @InactiveSw,
@SortOrder = @SortOrder,
@AuditUserName = @AuditUserName,
@GeneratedBy = @GeneratedBy


END
GO

