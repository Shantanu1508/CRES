
--[usp_ValidateInvoiceAPIParams] '','19-1166','1234','CA','Origination Fee'
CREATE PROCEDURE [dbo].[usp_ValidateInvoiceAPIParams]
(
	@UserID nvarchar(256),
	@CREDealID varchar(50),
	@SystemInvoiceNo nvarchar(256),
	@StateAbbr nvarchar(50),
	@InvoiceType nvarchar(256)
)
AS

 BEGIN
 	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @DealID varchar(50),@IsDuplicateInvoice bit=0,@StateID int,
	@InvoiceTypeID int,@DealName nvarchar(256),@AMEmails nvarchar(max)
	select @DealID = dealid from cre.Deal where CREDealID=@CREDealID
	if exists(select 1 from cre.InvoiceDetail where SystemInvoiceNo=@SystemInvoiceNo and ObjectTypeID= 697and DealID=@DealID)
	BEGIN
		set @IsDuplicateInvoice =1
	END

	select @StateID=StatesID from app.StatesMaster where StatesAbbreviation=@StateAbbr
	select @InvoiceTypeID=lookupid from Core.Lookup where [value]=@InvoiceType and ParentID=94
	select @DealName=DealName from cre.Deal where CREDealID=@CREDealID
	
	IF (@DealID is not null)
	BEGIN
		select @AMEmails =
		REVERSE(SUBSTRING(REVERSE(SUBSTRING(replace(isnull(u1.Email+',abc@gmail.com','') +','+isnull(u2.Email,'')+','+isnull(u3.Email,''),',,',','), PATINDEX('%[^, ]%', replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,''),',,',',')),99999)), 
				PATINDEX('%[^, ]%', REVERSE(SUBSTRING(replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,''),',,',','), PATINDEX('%[^, ]%', replace(isnull(u1.Email,'') +','+isnull(u2.Email,'')+','+isnull(u3.Email,''),',,',',')),99999))),99999))
		from cre.deal d
		left join app.[user] u1 on u1.UserID =d.AMUserID
		left join app.[user] u2 on u2.UserID = d.AMTeamLeadUserID
		left join app.[user] u3 on u3.UserID = d.AMSecondUserID
		where DealID=@DealID
	END

	select @IsDuplicateInvoice as IsDuplicateInvoice,Isnull(@StateID,0) StateID,
	isnull(@InvoiceTypeID,0) as InvoiceTypeID,@DealName as DealName,Isnull(@AMEmails,'') as AMEmails
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
