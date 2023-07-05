--select * from cre.invoicedetail
-- [usp_GetInvoiceDetailByObjectTypeID] 697,'A0A4AE01-2481-4109-BBD5-180DC8BE3492','A0A4AE01-2481-4109-BBD5-180DC8BE3492'

CREATE PROCEDURE [dbo].[usp_GetInvoiceDetailByObjectTypeID] 
(
	@ObjectTypeID int,
	@ObjectID UNIQUEIDENTIFIER,
	@UserID NVARCHAR(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	Declare @NewTaskID UNIQUEIDENTIFIER,@DealID UNIQUEIDENTIFIER
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
	If(@ObjectTypeID=697)
	BEGIN
	SELECT  
		InvoiceDetailID,
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
		DrawFeeStatus, 
		l.Name as DrawFeeStatusText,
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
	left join cre.deal d on d.DealID = i.ObjectID
	left join app.[user] u1 on u1.UserID =d.AMUserID
	left join app.[user] u2 on u2.UserID = d.AMTeamLeadUserID
	left join app.[user] u3 on u3.UserID = d.AMSecondUserID
	left join core.Lookup l on i.DrawFeeStatus = l.LookupID
	left join app.StatesMaster s on s.StatesID = i.StateID
	left join app.[user] u4 on u4.UserID = i.UpdatedBy
	WHERE ObjectTypeID=697 and ObjectID=@ObjectID
	END
	
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

