--[usp_GetDrawFeeInvoiceDetailByTaskID]
CREATE PROCEDURE [dbo].[usp_InsertUpdateInvoiceDetail] 
(
	@UserID NVARCHAR(256),
	@XMLDrawFeeInvoice xml
)
	
AS
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
	
	END
	ELSE IF NOT EXISTS(
		select 1 from cre.invoicedetail i join @InvoiceDetail t on  i.InvoiceTypeID =t.InvoiceTypeID
		and i.ObjectTypeID = t.ObjectTypeID and i.ObjectID=t.ObjectID
	)
	BEGIN
		declare @DealID uniqueidentifier = (select dealid from cre.dealfunding where DealFundingID = (SELECT ObjectID from @InvoiceDetail));
		declare @Credealid nvarchar(256) = (select credealid from cre.deal where dealid=@DealID);
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
								SELECT REVERSE ((SELECT TOP 1 VALUE FROM dbo.fn_Split_str(REVERSE(i.SystemInvoiceNo), '-'))) as SystemInvoiceNo
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
	END

END

