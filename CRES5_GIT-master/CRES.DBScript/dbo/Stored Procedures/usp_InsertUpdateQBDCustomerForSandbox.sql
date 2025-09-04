create PROCEDURE [DBO].[usp_InsertUpdateQBDCustomerForSandbox] 
(
	@UserID nvarchar(256),
	@CustomerAccountName nvarchar(256),
	@CustomerNo nvarchar(256),
	@ContactID nvarchar(256)
)
AS
BEGIN

	update App.[QuickBookCustomer] set ContactID=@ContactID,CustomerNo=@CustomerNo where [FullName]=@CustomerAccountName

END