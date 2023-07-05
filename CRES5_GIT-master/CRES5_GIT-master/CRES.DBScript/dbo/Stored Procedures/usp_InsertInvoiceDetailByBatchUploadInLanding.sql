
CREATE PROCEDURE [dbo].[usp_InsertInvoiceDetailByBatchUploadInLanding] 
(
	@UserID NVARCHAR(256),
	@XMLDrawFeeInvoice xml
)
	
AS
BEGIN
   
Declare @CreatedBy nvarchar(256);
Declare @BatchLogID int;
Declare @RowCount int;

SEt @CreatedBy = (Select top 1 UserID from App.[User] where [login] = @UserID)

	

BEGIN TRY

	INSERT INTO [IO].[BatchLogGeneric] (BatchName,BatchStartTime,StartedBy,[Status])
	VALUES ('DrawFee_M61AddinProcess',GETDATE(),@CreatedBy,'Process Running')

	SET @BatchLogID = @@IDENTITY

	--======Write your insert into Landing table query here =======

	INSERT INTO [IO].[L_InvoiceDetail]
	(CreDealID	,
	InvoiceDate	,
	InvoiceNo	,
	InvoiceDueDate	,
	Amount	,
	InvoiceTypeID	,	
	FirstName	,
	LastName	,
	Designation	,
	CompanyName	,
	Address	,
	City	,
	State	,
	Zip	,
	Email1	,
	Email2	,
	PhoneNo	,
	AlternatePhone	,
	Comment	,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	[Status] ,	
	[BatchLogGenericID],
	DrawFeeStatus	
	)


   SELECT 
	Pers.value('(CreDealID)[1]', '[nvarchar](256)'),
	Pers.value('(InvoiceDate)[1]', 'DateTime'), --new
	Pers.value('(InvoiceNo)[1]', '[nvarchar](256)'),
	Pers.value('(InvoiceDueDate)[1]', 'DateTime'), --new
	Pers.value('(Amount)[1]', 'decimal(28,15)'),
	Pers.value('(InvoiceTypeID)[1]', 'int'),
	--Pers.value('(DrawFeeStatus)[1]', 'int'),
	Pers.value('(FirstName)[1]', '[nvarchar](256)'),
	Pers.value('(LastName)[1]', '[nvarchar](256)'),
	Pers.value('(Designation)[1]', '[nvarchar](256)'),
	Pers.value('(CompanyName)[1]', '[nvarchar](256)'),
	Pers.value('(Address)[1]', '[nvarchar](256)'),
	Pers.value('(City)[1]', '[nvarchar](256)'),
	Pers.value('(State)[1]', 'int'),
	Pers.value('(Zip)[1]', '[nvarchar](256)'),
	Pers.value('(Email1)[1]', '[nvarchar](256)'),
	Pers.value('(Email2)[1]', '[nvarchar](256)'),
	Pers.value('(PhoneNo)[1]', '[nvarchar](256)'),
	Pers.value('(AlternatePhone)[1]', '[nvarchar](256)'),
	Pers.value('(Comment)[1]', '[nvarchar](256)'),	
	@CreatedBy,
	getdate(),
	@CreatedBy,
	getdate(),	
	'InProcess',
	@BatchLogID,
	692 as DrawFeeStatus	
	FROM @XMLDrawFeeInvoice.nodes('ArrayOfDrawFeeInvoiceBatchUploadDataContract/DrawFeeInvoiceBatchUploadDataContract') as T(Pers)

	SET @RowCount = @@ROWCOUNT
	

	Update [IO].[L_InvoiceDetail] set [Status] = 'Ignore',[StatusComment] = 'Deal does not exist in M61' where BatchLogGenericID = @BatchLogID and CreDealID not in (Select credealid from cre.deal)


	Update [IO].[L_InvoiceDetail] set [Status] = 'Ignore',[StatusComment] = 'Invoice number already exists' 
	where L_InvoiceDetailID in (
		Select L_InvoiceDetailID 
		from  [IO].[L_InvoiceDetail] l 
		inner join cre.deal d on d.credealid = l.credealid
		inner join CRE.InvoiceDetail id on id.ObjectID = d.dealid and id.SystemInvoiceNo = l.InvoiceNo and id.ObjectTypeID = 697
		where l.BatchLogGenericID = @BatchLogID
	)
	--=============================================================

	
	UPDATE [IO].[BatchLogGeneric] SET RecordCount = @RowCount WHERE [BatchLogGenericID] = @BatchLogID	 



	--======Import landing to main =======		
	exec [dbo].[usp_InsertInvoiceDetailByBatchUploadInMain] @BatchLogID,@CreatedBy	
	--====================================

	UPDATE [IO].[BatchLogGeneric] SET [Status] = 'Process Complete',BatchEndTime = GETDATE() WHERE [BatchLogGenericID] = @BatchLogID	

	select @BatchLogID

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT,@ErrorProc NVARCHAR(4000)

	SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE(),@ErrorProc = ERROR_PROCEDURE();

	UPDATE [IO].[BatchLogGeneric]
	SET Status =  'Process Incomplete',
		BatchEndTime = GETDATE(),
		ErrorMessage = @ErrorMessage + 'Occurred in ' + @ErrorProc
	WHERE [BatchLogGenericID] = @BatchLogID

	RAISERROR (@ErrorMessage, -- Message text.
        @ErrorSeverity, -- Severity.
        @ErrorState -- State.
        );

END CATCH


END

