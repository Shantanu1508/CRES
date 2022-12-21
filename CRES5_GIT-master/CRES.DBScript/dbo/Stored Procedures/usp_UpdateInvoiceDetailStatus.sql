CREATE PROCEDURE [dbo].[usp_UpdateInvoiceDetailStatus] 
(
	@UserID NVARCHAR(256),
	@InvoiceDetailID int,
	@DrawFeeStatus int,
	@FileName nvarchar(256),
	@InvoiceNumber nvarchar(256),
	@AmountPaid decimal(28,15),
	@PaymentDate datetime,
	@InvoiceGuid nvarchar(256),
	@PreAssignedInvoiceNo nvarchar(256),
	@IsLogActivity bit=0
)
	
AS
BEGIN
 declare @TaskID nvarchar(256),@DrawFeeStatusName nvarchar(50),@Comment nvarchar(256),
 @InvoiceTypeID int,@InvoiceTypeName nvarchar(100),@ObjectTypeID int,@DealID uniqueidentifier
	if (@DrawFeeStatus is not null and @DrawFeeStatus>0)
	begin
	update CRE.InvoiceDetail set DrawFeeStatus = @DrawFeeStatus
	where  InvoiceDetailID = @InvoiceDetailID
	end
	if(@FileName is not null and @FileName<>'')
	begin
		update CRE.InvoiceDetail set [FileName] = @FileName
		where  InvoiceDetailID = @InvoiceDetailID
	end
	if(@InvoiceNumber is not null and @InvoiceNumber<>'')
	begin
		update CRE.InvoiceDetail set [InvoiceNo] = @InvoiceNumber
		where  InvoiceDetailID = @InvoiceDetailID
	end
	
	if(@AmountPaid is not null and @AmountPaid<>0)
	begin
		update CRE.InvoiceDetail set [AmountPaid] = @AmountPaid,[PaymentDate]=@PaymentDate
		where  InvoiceDetailID = @InvoiceDetailID
	end

	if(@InvoiceGuid is not null and @InvoiceGuid<>'')
	begin
		update CRE.InvoiceDetail set [InvoiceGuid] = @InvoiceGuid
		where  InvoiceDetailID = @InvoiceDetailID
	end
	if(@PreAssignedInvoiceNo is not null and @PreAssignedInvoiceNo<>'')
	begin
		update CRE.InvoiceDetail set [PreAssignedInvoiceNo] = @PreAssignedInvoiceNo
		where  InvoiceDetailID = @InvoiceDetailID
	end

	select @ObjectTypeID = ObjectTypeID from cre.InvoiceDetail where InvoiceDetailID=@InvoiceDetailID

	--deal level activity
	if (@ObjectTypeID=697 and @IsLogActivity=1 and @DrawFeeStatus is not null and @DrawFeeStatus>0)
		begin
			if (@UserID is null or @UserID='')
			  begin
			   set @UserID='3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
			  end
		 select @DrawFeeStatusName= Name from core.lookup where LookupID = @DrawFeeStatus
		 select @DealID=DealID,@InvoiceTypeID=InvoiceTypeID from cre.InvoiceDetail where InvoiceDetailID=@InvoiceDetailID
		 SET @Comment = @DrawFeeStatusName
		 exec [usp_InsertActivityLog] @DealID,283,@DealID,@InvoiceTypeID, @Comment,@UserID,@InvoiceDetailID
		end
	--deal funding level activity
	else if (@ObjectTypeID=698 and @IsLogActivity=1 and @DrawFeeStatus is not null and @DrawFeeStatus>0)
		Begin
		 select @DrawFeeStatusName= Name from core.lookup where LookupID = @DrawFeeStatus
		 select @TaskID = ObjectID,@InvoiceTypeID=InvoiceTypeID from cre.InvoiceDetail where InvoiceDetailID=@InvoiceDetailID
		 select @InvoiceTypeName = Name from core.lookup where LookupID = @InvoiceTypeID
		 SET @Comment = @InvoiceTypeName+' '+ @DrawFeeStatusName
		 exec [usp_InsertDrawFeeActivityLog] @TaskID,@Comment,'',''
		End
END
GO

