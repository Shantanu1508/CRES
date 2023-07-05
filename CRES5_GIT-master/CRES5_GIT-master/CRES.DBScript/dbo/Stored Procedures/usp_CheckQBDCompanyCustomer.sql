CREATE PROCEDURE [DBO].[usp_CheckQBDCompanyCustomer] 
(
	@CustomerAccountName nvarchar(256),
	@CompanyName nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	Declare @IsExistCustomer int = 0,@IsExistCompany int = 1,@ID nvarchar(256),@quickbookcompany nvarchar(256);
	select @quickbookcompany=[Name] from app.quickbookcompany where IsActive=1

	IF Exists (select 1 from App.[QuickBookCustomer] where FullName = @CustomerAccountName and CompanyName=@quickbookcompany and IsActive=1)
	Begin
		set @IsExistCustomer =1
		select @ID = ID from App.[QuickBookCustomer] where FullName = @CustomerAccountName and IsActive=1
	end


SELECT @IsExistCustomer as IsExistCustomer,@IsExistCompany as IsExistCompany,@ID as ID
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
