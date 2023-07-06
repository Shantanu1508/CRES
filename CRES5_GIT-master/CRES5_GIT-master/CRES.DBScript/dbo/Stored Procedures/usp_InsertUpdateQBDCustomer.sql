create PROCEDURE [DBO].[usp_InsertUpdateQBDCustomer] 
(
	@UserID nvarchar(256),
	@ID nvarchar(256),
	@CustomerAccountName nvarchar(256),
	@CustomerNo nvarchar(256),
	@ContactID nvarchar(256)
)
AS
BEGIN
	
	declare @quickbookcompany nvarchar(256);

	select @quickbookcompany=[Name] from app.quickbookcompany where IsActive=1
	
	IF Not Exists (select 1 from App.[QuickBookCustomer] where [FullName]=@CustomerAccountName and CompanyName=@quickbookcompany and IsActive=1)
	Begin
		insert into App.[QuickBookCustomer](
		[ID] ,
		[Name] ,
		[FullName] ,
		[CompanyName] ,
		[IsActive],
		[CreatedBy] ,
		[CreatedDate],
		[UpdatedBy] ,
		[UpdatedDate],
		[CustomerNo],
		[ContactID])
		values
		(
		@ID,
		@CustomerAccountName, --taking only 41 characters because quickbook allow only 41 charater,it will truncate characters after that
		@CustomerAccountName,
		@quickbookcompany,
		1,
		@UserID,
		getdate(),
		@UserID,
		getdate(),
		@CustomerNo,
		@ContactID
		)
end

END