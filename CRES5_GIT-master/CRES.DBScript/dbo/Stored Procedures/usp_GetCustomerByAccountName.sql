CREATE PROCEDURE [dbo].[usp_GetCustomerByAccountName]
	@AccountName nvarchar(256)
AS
	BEGIN

SELECT [QuickBookCustomerID]
      ,[ID]
      ,[Name]
      ,[FullName]
      ,[FirstName]
      ,[LastName]
      ,[CompanyName]
      ,[IsActive]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[CustomerNo]
      ,[ContactID]
  FROM [App].[QuickBookCustomer]
  where FullName=@AccountName and IsActive=1

END
