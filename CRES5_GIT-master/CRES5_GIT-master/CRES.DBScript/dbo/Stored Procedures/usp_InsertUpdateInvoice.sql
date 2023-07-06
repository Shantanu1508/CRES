--[usp_GetDrawFeeInvoiceDetailByTaskID]
create PROCEDURE [dbo].[usp_InsertUpdateInvoice] 
(
	@UserID NVARCHAR(256),
	@XMLDrawFeeInvoice xml
)
	
AS
BEGIN
    declare @DealID uniqueidentifier,@Credealid nvarchar(256),@ObjectTypeID int,@InvoiceDeatilID int

	if(@UserID is null or @UserID='')
		 set @UserID='B0E6697B-3534-4C09-BE0A-04473401AB93'
	
	select @ObjectTypeID=Pers.value('(ObjectTypeID)[1]', 'int') FROM @XMLDrawFeeInvoice.nodes('/DrawFeeInvoiceDataContract') as T(Pers)
	declare @tblInvoiceDetail as table
	(
	 InvoiceDetailID int
	)

	if (@ObjectTypeID=698)
	BEGIN
	
		declare @InvoiceDetail as table(
	InvoiceDetailID int,
	InvoiceNo [nvarchar](256) NULL,
	TaskID Uniqueidentifier NULL,
	ObjectTypeID int null,
	ObjectID [nvarchar](256) NULL,
	Amount decimal(28,15)  NULL,
	FirstName [nvarchar](256) NULL,
	LastName [nvarchar](256) NULL,
	Designation [nvarchar](256) NULL,
	CompanyName [nvarchar](256) NULL,
	[Address] [nvarchar](256) NULL,
	City [nvarchar](256) NULL,
	[StateID] [int] NULL,
	Zip [nvarchar](256) NULL,
	Email1 [nvarchar](256) NULL,
	Email2 [nvarchar](256) NULL,
	PhoneNo [nvarchar](256) NULL,
	AlternatePhone [nvarchar](256) NULL,
	Comment [nvarchar](256) NULL,
	AutoSendInvoice int,
	InvoiceTypeID int,
	SystemInvoiceNo nvarchar(256) null
	)
	declare @tInvoiceDetailID int,@AutoSendInvoice int,@tAutoSendInvoice int,@DrawFeeStatus int,@TaskID nvarchar(256)

	insert into @InvoiceDetail
	SELECT 
	Pers.value('(DrawFeeInvoiceDetailID)[1]', 'int'),
	Pers.value('(InvoiceNo)[1]', '[nvarchar](256)'),
	Pers.value('(TaskID)[1]', 'Uniqueidentifier'),
	Pers.value('(ObjectTypeID)[1]', 'int'),
	Pers.value('(ObjectID)[1]', '[nvarchar](256)'),
	--Case
 --       when Pers.value('(Amount)[1]','[nvarchar](256)') IS null then 0
	--	 when Pers.value('(Amount)[1]','[nvarchar](256)') ='' then 0
 --       Else Pers.value('(Amount)[1]','decimal(28,15)')
 --   End as Amount,
	Pers.value('(Amount)[1]', 'decimal(28,15)'),
	Pers.value('(FirstName)[1]', '[nvarchar](256)'),
	Pers.value('(LastName)[1]', '[nvarchar](256)'),
	Pers.value('(Designation)[1]', '[nvarchar](256)'),
	Pers.value('(CompanyName)[1]', '[nvarchar](256)'),
	Pers.value('(Address)[1]', '[nvarchar](256)'),
	Pers.value('(City)[1]', '[nvarchar](256)'),
	Pers.value('(StateID)[1]', 'int'),
	Pers.value('(Zip)[1]', '[nvarchar](256)'),
	Pers.value('(Email1)[1]', '[nvarchar](256)'),
	Pers.value('(Email2)[1]', '[nvarchar](256)'),
	Pers.value('(PhoneNo)[1]', '[nvarchar](256)'),
	Pers.value('(AlternatePhone)[1]', '[nvarchar](256)'),
	Pers.value('(Comment)[1]', '[nvarchar](256)'),
	Pers.value('(AutoSendInvoice)[1]', '[nvarchar](256)'),
	Pers.value('(InvoiceTypeID)[1]', 'int'),
	Pers.value('(InvoiceNoUI)[1]', '[nvarchar](256)')

	FROM @XMLDrawFeeInvoice.nodes('/DrawFeeInvoiceDataContract') as T(Pers)

	
	
	
	IF ((select InvoiceDetailID from @InvoiceDetail)>0)
	BEGIN
	   
	   select @tInvoiceDetailID=InvoiceDetailID,@tAutoSendInvoice=AutoSendInvoice from @InvoiceDetail
	   select @AutoSendInvoice = AutoSendInvoice,@DrawFeeStatus=DrawFeeStatus,@TaskID =ObjectID  from Cre.InvoiceDetail where InvoiceDetailID=@tInvoiceDetailID

	   -- if someone change the autosend invoice option from yes to no and status is invoice queued
	   if (@DrawFeeStatus = 696 and @AutoSendInvoice<> @tAutoSendInvoice and @AutoSendInvoice=571 and @tAutoSendInvoice=572)
	   begin
	        update CRE.InvoiceDetail set DrawFeeStatus=692, FileName=null,InvoiceNo=null where InvoiceDetailID=@tInvoiceDetailID
			if (@DrawFeeStatus is not null and @DrawFeeStatus>0)
				Begin
				 exec [usp_InsertDrawFeeActivityLog] @TaskID,'Invoice Removed from Queue','',''
				End
	   end
	   
	   
	   update CRE.InvoiceDetail set
	    
		Amount = tbldi.Amount ,
		FirstName = tbldi.FirstName ,
		LastName = tbldi.LastName ,
		Designation = tbldi.Designation ,
		CompanyName = tbldi.CompanyName ,
		[Address] = tbldi.[Address] ,
		City = tbldi.City ,
		[StateID] = tbldi.[StateID],
		Zip = tbldi.Zip,
		Email1 = tbldi.Email1,
		Email2 = tbldi.Email2,
		PhoneNo = tbldi.PhoneNo,
		AlternatePhone = tbldi.AlternatePhone,
		Comment = tbldi.Comment,
		AutoSendInvoice=tbldi.AutoSendInvoice,
		[UpdatedBy]=@UserID,
		[UpdatedDate] = getdate()
		
		from 
		(
		 select 
		 InvoiceDetailID,
		 Amount ,
		FirstName ,
		LastName ,
		Designation ,
		CompanyName ,
		[Address] ,
		City ,
		[StateID] ,
		Zip ,
		Email1 ,
		Email2 ,
		PhoneNo ,
		AlternatePhone ,
		Comment,
		AutoSendInvoice
		from @InvoiceDetail
		) tbldi 
		where  tbldi.InvoiceDetailID = CRE.InvoiceDetail.InvoiceDetailID
		SET @InvoiceDeatilID= @tInvoiceDetailID
	
	END
	ELSE IF NOT EXISTS(
		select 1 from cre.invoicedetail i join @InvoiceDetail t on  i.InvoiceTypeID =t.InvoiceTypeID
		and i.ObjectTypeID = t.ObjectTypeID and i.ObjectID=t.ObjectID
	)
	BEGIN
		select @DealID = dealid from cre.dealfunding where DealFundingID = (SELECT ObjectID from @InvoiceDetail)
		select @Credealid =credealid from cre.deal where dealid=@DealID
		DECLARE @maxinvoicesysno nvarchar(256);
		declare @invoicetypeid int = (SELECT invoicetypeid from @InvoiceDetail) ;
		declare @invoicetype nvarchar(20);
		IF(@invoicetypeid = 558)
		BEGIN
			SET @invoicetype = '-DR-';
		END
		--select @maxinvoicesysno =  max(SystemInvoiceNo) 
		--						FROM(
		--						SELECT REVERSE ((SELECT TOP 1 VALUE FROM STRING_SPLIT(REVERSE(i.SystemInvoiceNo), '-'))) as SystemInvoiceNo
		--						from 
		--						cre.InvoiceDetail i
		--						left join cre.dealfunding df on df.DealFundingID = i.ObjectID 
		--						where df.DealID = @DealID
		--						and i.ObjectTypeID = 698
		--						and invoicetypeid = 558
		--						and SystemInvoiceNo is not null
		--						)a ;

	 select @maxinvoicesysno =  max(SystemInvoiceNo) 
								FROM(
								SELECT REVERSE ((SELECT TOP 1 VALUE FROM STRING_SPLIT(REVERSE(i.SystemInvoiceNo), '-'))) as SystemInvoiceNo
								from 
								cre.InvoiceDetail i
								join cre.Deal d on d.DealID = i.DealID 
								where d.DealID = @DealID
								and i.ObjectTypeID = 698
								and invoicetypeid = 558
								and SystemInvoiceNo is not null
								)a ;
		
		set @maxinvoicesysno = isnull(@maxinvoicesysno,0000) + 0001;
		
		declare @invocie nvarchar(256) = @CredealId + @invoicetype + RIGHT('0000' + LTRIM(STR(@maxinvoicesysno)), 4) 
	 insert into CRE.InvoiceDetail
	 (
		 --InvoiceNo,
		 TaskID,
		 ObjectTypeID,
		 ObjectID,
		 Amount ,
		FirstName ,
		LastName ,
		Designation ,
		CompanyName ,
		[Address] ,
		City ,
		[StateID] ,
		Zip ,
		Email1 ,
		Email2 ,
		PhoneNo ,
		AlternatePhone ,
		Comment,
		AutoSendInvoice,
		DrawFeeStatus,
		[CreatedBy],
		[CreatedDate],
		[UpdatedBy],
		[UpdatedDate],
		[InvoiceTypeID],
		SystemInvoiceNo,
		DealID
	 )
	 OUTPUT inserted.InvoiceDetailID INTO @tblInvoiceDetail(InvoiceDetailID)
	 select 
	 --InvoiceNo,
		 TaskID,
		 ObjectTypeID,
		 ObjectID,
		 Amount ,
		FirstName ,
		LastName ,
		Designation ,
		CompanyName ,
		[Address] ,
		City ,
		[StateID] ,
		Zip ,
		Email1 ,
		Email2 ,
		PhoneNo ,
		AlternatePhone ,
		Comment,
		AutoSendInvoice,
		692,
		@UserID,
		getdate(),
		@UserID,
		getdate(),
		InvoiceTypeID,
		@invocie,
		@DealID
		from @InvoiceDetail
		SELECT @InvoiceDeatilID = InvoiceDetailID FROM @tblInvoiceDetail;
	END
	END
	ELSE IF (@ObjectTypeID=697)
	BEGIN
	    select @CreDealID=Pers.value('(CreDealID)[1]', 'nvarchar(256)') FROM @XMLDrawFeeInvoice.nodes('/DrawFeeInvoiceDataContract') as T(Pers)
		select @DealID =DealID from cre.Deal where CREDealID=@CreDealID
		 
		 declare @InvoiceDetail1 as table(
	InvoiceDetailID int,
	InvoiceNo [nvarchar](256) NULL,
	TaskID Uniqueidentifier NULL,
	ObjectTypeID int null,
	ObjectID [nvarchar](256) NULL,
	Amount decimal(28,15)  NULL,
	FirstName [nvarchar](256) NULL,
	LastName [nvarchar](256) NULL,
	Designation [nvarchar](256) NULL,
	CompanyName [nvarchar](256) NULL,
	[Address] [nvarchar](256) NULL,
	City [nvarchar](256) NULL,
	[StateID] [int] NULL,
	Zip [nvarchar](256) NULL,
	Email1 [nvarchar](256) NULL,
	Email2 [nvarchar](256) NULL,
	PhoneNo [nvarchar](256) NULL,
	AlternatePhone [nvarchar](256) NULL,
	Comment [nvarchar](256) NULL,
	InvoiceTypeID int,
	SystemInvoiceNo nvarchar(256) null,
	InvoiceDate	Date NULL, --if past then current
	InvoiceDueDate	Date NULL,
	InvoiceComment NVARCHAR (MAX)  NULL,
	UploadedFrom NVARCHAR (100),
	EmailCC NVARCHAR (256)   NULL,
    SenderFirstName NVARCHAR (256)   NULL,
    SenderLastName NVARCHAR (256)   NULL,
    SenderEmail NVARCHAR (256)   NULL
	)
	insert into @InvoiceDetail1
	SELECT 
	Pers.value('(DrawFeeInvoiceDetailID)[1]', 'int'),
	Pers.value('(InvoiceNo)[1]', '[nvarchar](256)'),
	Pers.value('(TaskID)[1]', 'Uniqueidentifier'),
	Pers.value('(ObjectTypeID)[1]', 'int'),
	Pers.value('(ObjectID)[1]', '[nvarchar](256)'),
	--Case
 --       when Pers.value('(Amount)[1]','[nvarchar](256)') IS null then 0
	--	 when Pers.value('(Amount)[1]','[nvarchar](256)') ='' then 0
 --       Else Pers.value('(Amount)[1]','decimal(28,15)')
 --   End as Amount,
	Pers.value('(Amount)[1]', 'decimal(28,15)'),
	Pers.value('(FirstName)[1]', '[nvarchar](256)'),
	Pers.value('(LastName)[1]', '[nvarchar](256)'),
	Pers.value('(Designation)[1]', '[nvarchar](256)'),
	Pers.value('(CompanyName)[1]', '[nvarchar](256)'),
	Pers.value('(Address)[1]', '[nvarchar](256)'),
	Pers.value('(City)[1]', '[nvarchar](256)'),
	Pers.value('(StateID)[1]', 'int'),
	Pers.value('(Zip)[1]', '[nvarchar](256)'),
	Pers.value('(Email1)[1]', '[nvarchar](256)'),
	Pers.value('(Email2)[1]', '[nvarchar](256)'),
	Pers.value('(PhoneNo)[1]', '[nvarchar](256)'),
	Pers.value('(AlternatePhone)[1]', '[nvarchar](256)'),
	Pers.value('(Comment)[1]', '[nvarchar](256)'),
	Pers.value('(InvoiceTypeID)[1]', 'int'),
	Pers.value('(InvoiceNoUI)[1]', '[nvarchar](256)'),
	case when Pers.value('(InvoiceDate)[1]', 'varchar(256)')='0001-01-01T00:00:00' then null
	else Pers.value('(InvoiceDate)[1]', 'datetime') end,
	case when Pers.value('(InvoiceDueDate)[1]', 'varchar(256)')='0001-01-01T00:00:00' then null
	else Pers.value('(InvoiceDueDate)[1]', 'datetime') end,
	Pers.value('(InvoiceComment)[1]', '[nvarchar](MAX)'),
	Pers.value('(UploadedFrom)[1]', '[nvarchar](256)'),
	Pers.value('(EmailCC)[1]', '[nvarchar](256)'),
	Pers.value('(SenderFirstName)[1]', '[nvarchar](256)'),
	Pers.value('(SenderLastName)[1]', '[nvarchar](256)'),
	Pers.value('(SenderEmail)[1]', '[nvarchar](256)')
	FROM @XMLDrawFeeInvoice.nodes('/DrawFeeInvoiceDataContract') as T(Pers)

		 
		 IF ((select InvoiceDetailID from @InvoiceDetail1)>0)
		 BEGIN
		 update CRE.InvoiceDetail set
	    
			Amount = tbldi.Amount ,
			FirstName = tbldi.FirstName ,
			LastName = tbldi.LastName ,
			Designation = tbldi.Designation ,
			CompanyName = tbldi.CompanyName ,
			[Address] = tbldi.[Address] ,
			City = tbldi.City ,
			[StateID] = tbldi.[StateID],
			Zip = tbldi.Zip,
			Email1 = tbldi.Email1,
			Email2 = tbldi.Email2,
			PhoneNo = tbldi.PhoneNo,
			AlternatePhone = tbldi.AlternatePhone,
			Comment = tbldi.Comment,
			InvoiceComment=tbldi.InvoiceComment,
			[UpdatedBy]=@UserID,
			[UpdatedDate] = getdate()
		
			from 
			(
			 select 
			 InvoiceDetailID,
			 Amount ,
			FirstName ,
			LastName ,
			Designation ,
			CompanyName ,
			[Address] ,
			City ,
			[StateID] ,
			Zip ,
			Email1 ,
			Email2 ,
			PhoneNo ,
			AlternatePhone ,
			Comment,
			InvoiceComment
			from @InvoiceDetail1
			) tbldi 
			where  tbldi.InvoiceDetailID = CRE.InvoiceDetail.InvoiceDetailID
			select @InvoiceDeatilID=InvoiceDetailID from @InvoiceDetail1
		 END
		 ELSE IF NOT EXISTS(
		select 1 from cre.invoicedetail i join @InvoiceDetail1 t on i.ObjectTypeID = t.ObjectTypeID
		and i.ObjectID=t.ObjectID where i.SystemInvoiceNo=t.SystemInvoiceNo
		)
		 BEGIN
		 

		  INSERT INTO CRE.InvoiceDetail
	(
	ObjectTypeID,
	ObjectID,
	Amount,
	FirstName,
	LastName,
	Designation,
	CompanyName,
	Address,
	City,
	Zip,
	Email1,
	Email2,
	PhoneNo,
	AlternatePhone,
	Comment,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	DrawFeeStatus,
	InvoiceTypeID,
	StateID,
	SystemInvoiceNo,
	DealID,
	InvoiceDate,
	InvoiceDateOriginal,
	InvoiceDueDate,
	InvoiceComment,
	UploadedFrom,
	EmailCC, 
    SenderFirstName,
    SenderLastName,
    SenderEmail
	)
	OUTPUT inserted.InvoiceDetailID INTO @tblInvoiceDetail(InvoiceDetailID)
	Select 
	ObjectTypeID,
	@DealID,
	Amount,
	FirstName,
	LastName,
	Designation,
	CompanyName,
	Address,
	City,
	Zip,
	Email1,
	Email2,
	PhoneNo,
	AlternatePhone,
	Comment,
	@UserID,
	GETDATE(),
	@UserID,
	GETDATE(),
	692,
	InvoiceTypeID,
	StateID,
	SystemInvoiceNo,
	@DealID,
	(CASE WHEN InvoiceDate < CAST(getdate() as date) THEN CAST(getdate() as date) ELSE InvoiceDate END),
	InvoiceDate,
	InvoiceDueDate,
	InvoiceComment,
	UploadedFrom,
	EmailCC, 
    SenderFirstName,
    SenderLastName,
    SenderEmail
	From @InvoiceDetail1
	SELECT @InvoiceDeatilID = InvoiceDetailID FROM @tblInvoiceDetail;
		 END
	
	END

	select @InvoiceDeatilID as InvoiceDetailID
END

