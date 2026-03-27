-- [usp_GetInvoiceDetailByTaskID] 'a670a6b7-9993-40cd-a6e2-48d9bd47e794','b4718098-fbab-46b6-8d0a-4905b80f6493'

CREATE PROCEDURE [dbo].[usp_GetInvoiceDetailByTaskID] 
(
	@TaskID UNIQUEIDENTIFIER,
	@UserID NVARCHAR(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	Declare @NewTaskID UNIQUEIDENTIFIER,@DealID UNIQUEIDENTIFIER,@IsDrawExist int=1,@DeafultDrawStatus int =692,@DeafultDrawStatusText nvarchar(256)
	select @DeafultDrawStatusText = Name from Core.Lookup where lookupID=@DeafultDrawStatus
	set @NewTaskID = @TaskID
	select @DealID = DealID from CRE.DealFunding where DealFundingID=@TaskID;
	DECLARE @AllowDrawFeeAMEmail nvarchar(10)=(select [Value] from app.AppConfig WHERE [key]='AllowDrawFeeAMEmail')
	DECLARE @GroupEmail nvarchar(256)
	if(@AllowDrawFeeAMEmail=1)
	begin
		SET @GroupEmail = (
		Select STUFF((
		Select Distinct  ', '  + EmailId
		from app.EmailNotification
		where moduleid=703 and [status] =1
		FOR XML PATH('') ), 1, 2, '') as GroupEmail
	)
	end
	
	IF NOT EXISTS(SELECT InvoiceDetailID FROM CRE.[InvoiceDetail] WHERE TaskID=@TaskID)
	BEGIN
	    set @IsDrawExist = 0
		----get first positiove draw
		--Select  top 1 @NewTaskID=df.DealFundingID from cre.DealFunding df left join core.lookup l  on df.PurposeID =l.LookupID 
		--join 
		--(
		--	Select distinct taskid  from [CRE].WFTaskDetail t  
		--	join cre.dealfunding df on t.taskid=df.dealfundingid
		--	join cre.deal d on d.dealid=df.dealid
		--	where df.dealid=@DealID
		--	and d.[Status]<>325
		--) wfallow on wfallow.taskid = df.DealFundingID
		--where dealid = @DealID 
		--and ((l.Value ='Positive' and l.Value <>'Both') or (l.Value ='Both' and df.Amount>0))
		--and df.Amount>0
		--order by Date,DealFundingRowno	

		--get most recent invoice detail
		 select top 1 @NewTaskID = i.ObjectID from CRE.InvoiceDetail i join cre.DealFunding df on i.ObjectID=df.DealFundingID
		 where ObjectTypeID=698 and df.DealID=@DealID
		 order by i.updateddate desc
		 
	END
	
	SELECT  
		InvoiceDetailID =case when @IsDrawExist=1 then InvoiceDetailID else 0 end,
		InvoiceNo,
		TaskID,
		ObjectTypeID,
		ObjectID,
		i.Amount,
		i.FirstName,
		i.LastName,
		Designation,
		i.CompanyName,
		[Address],
		City,
		s.[StatesName] as [State],
		Zip,
		Email1,
		Email2,
		PhoneNo,
		AlternatePhone,
		i.Comment,
		AutoSendInvoice,
		i.[CreatedBy],
		i.[CreatedDate],
		i.[UpdatedBy],
		i.[UpdatedDate],
		[FileName],
		DrawFeeStatus = case when @IsDrawExist=1 then DrawFeeStatus else @DeafultDrawStatus end,
		DrawFeeStatusText = case when @IsDrawExist=1 then l.Name else @DeafultDrawStatusText end,
		StateID,
		SystemInvoiceNo,
		AMEmails = case when @AllowDrawFeeAMEmail=1 then 
	    REVERSE(SUBSTRING(REVERSE(SUBSTRING(replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',','), PATINDEX('%[^, ]%', replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',',')),99999)), 
	    PATINDEX('%[^, ]%', REVERSE(SUBSTRING(replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',','), PATINDEX('%[^, ]%', replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',',')),99999))),99999))
	    else '' end,
		u4.FirstName as SenderFirstName,
		u4.LastName as SenderLastName,
		u4.Email as SenderEmail

		
	FROM CRE.[InvoiceDetail] i 
	left join cre.dealfunding df on i.ObjectID = df.DealFundingID
	left join cre.deal d on d.DealID = df.DealID
	left join app.[user] u1 on u1.UserID =d.AMUserID
	left join app.[user] u2 on u2.UserID = d.AMTeamLeadUserID
	left join app.[user] u3 on u3.UserID = d.AMSecondUserID
	left join core.Lookup l on i.DrawFeeStatus = l.LookupID
	left join app.StatesMaster s on s.StatesID = i.StateID
	left join app.[user] u4 on u4.UserID = i.UpdatedBy
	
	WHERE ObjectTypeID=698 and ObjectID=@NewTaskID
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

