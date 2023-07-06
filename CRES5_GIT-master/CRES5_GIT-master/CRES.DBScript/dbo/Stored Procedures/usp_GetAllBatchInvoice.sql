CREATE PROCEDURE [dbo].[usp_GetAllBatchInvoice] 
(
	@UserID NVARCHAR(256)
)
AS
BEGIN  
declare  @tInvoiceDetail table
(
 ID int identity(1,1),
 InvoiceDetailID int 
)

declare @total int,@count int=1,@TaskID nvarchar(256),@DrawFeeStatusName nvarchar(50),@Comment nvarchar(256)
select @DrawFeeStatusName= Name from core.lookup where LookupID = 696
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
--insert into @tInvoiceDetail
--select InvoiceDetailID from [CRE].[InvoiceDetail] i join Cre.Dealfunding df on i.TaskID = df.DealFundingID
--and df.Applied=1 and cast([Date] as date)=cast(getdate() as date) and  i.DrawFeeStatus in (696) and i.fileName is not null
--select @total = count(1) from @tInvoiceDetail




--update [CRE].[InvoiceDetail] set [DrawFeeStatus]=693 ,UpdatedDate=getdate() 
--where InvoiceDetailID in (select InvoiceDetailID from @tInvoiceDetail)

----log activity for each draw
--while (@count<=@total)
--Begin
--         select @TaskID = ObjectID from cre.InvoiceDetail where InvoiceDetailID=(select top 1 InvoiceDetailID from @tInvoiceDetail where ID=@count)
--         SET @Comment = 'Draw Fee '+ @DrawFeeStatusName
--	     exec [usp_InsertDrawFeeActivityLog] @TaskID,@Comment,'',''
--         set @count=@count+1
--End

SELECT [InvoiceDetailID]
      ,[InvoiceNo]
      ,i.[TaskID]
      ,[ObjectTypeID]
      ,[ObjectID]
      ,i.[Amount]
      ,[AmountPaid]
      ,[PaymentDate]
      ,[AmountAdj]
      ,[AdjComments]
      ,[DrawFeeStatus]
      ,i.[FirstName]
      ,i.[LastName]
      ,[Designation]
      ,i.[CompanyName]
      ,[Address]
      ,[City]
      ,sm.StatesName as [State]
      ,[Zip]
      ,[Email1]
      ,[Email2]
      ,[PhoneNo]
      ,[AlternatePhone]
      ,i.[Comment]
      ,[AutoSendInvoice]
      ,i.[CreatedBy]
      ,i.[CreatedDate]
      ,i.[UpdatedBy]
      ,i.[UpdatedDate]
      ,[FileName]
	  ,i.InvoiceDate
	  ,i.InvoiceDateOriginal
	  ,i.InvoiceDueDate
	  ,i.InvoiceTypeID
	  ,Getdate() as CurrentDate
	  ,SystemInvoiceNo as [InvoiceNoUI]
	  ,StateID
	  CREDealID,
	  DealName,
	  (select top 1 InvoiceCode from app.InvoiceConfig where InvoiceTypeID = i.InvoiceTypeID) as InvoiceCode,
      (select top 1 Template from app.InvoiceConfig where InvoiceTypeID = i.InvoiceTypeID ) as TemplateName,
	  --InvoiceCode=(case when InvoiceTypeID=558 then 'Draw Fees' else '' end), 
	  --TemplateName=(case when InvoiceTypeID=558 then 'm61 invoice template' else '' end), 
	  '' as DrawNo,
	  AMEmails = case when @AllowDrawFeeAMEmail=1 then 
	  REVERSE(SUBSTRING(REVERSE(SUBSTRING(replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',','), PATINDEX('%[^, ]%', replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',',')),99999)), 
	  PATINDEX('%[^, ]%', REVERSE(SUBSTRING(replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',','), PATINDEX('%[^, ]%', replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,'')+','+isnull(@GroupEmail,''),',,',',')),99999))),99999))
	  else '' end,
		u4.FirstName as SenderFirstName,
		u4.LastName as SenderLastName,
		u4.Email as SenderEmail,
		0 as FundingAmount,
		l.[Name] as InvoiceTypeName,
		i.ObjectID,
		i.ObjectTypeID
	  from [CRE].[InvoiceDetail] i 
	  join CRE.Deal d on i.ObjectID=d.DealID
	  left join app.[user] u1 on u1.UserID =d.AMUserID
	  left join app.[user] u2 on u2.UserID = d.AMTeamLeadUserID
	  left join app.[user] u3 on u3.UserID = d.AMSecondUserID
	  left join app.StatesMaster sm on sm.StatesID = i.StateID
	  left join app.[user] u4 on u4.UserID = i.UpdatedBy
	  left join core.[Lookup] l on l.LookupID = i.InvoiceTypeID

      where ObjectTypeID=697
	  --and cast(i.InvoiceDate as date)<=cast(getdate() as date) 
	  and  i.DrawFeeStatus = 692 and i.fileName is null
	  --and ObjectID='EEE354F0-B976-4E73-994B-5586C618396F'
END
GO

