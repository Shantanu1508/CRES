--[usp_GetQuickBookCompany] '',null,'softtech'
create PROCEDURE [DBO].[usp_GetQuickBookCompany] 
(
	@UserID nvarchar(256),
	@QuickBookCompanyID int,
	@Name nvarchar(256)
)
AS
BEGIN
SELECT [QuickBookCompanyID]
      ,[Name]
      ,[EndPointID]
      ,[AutofyCompanyID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [App].[QuickBookCompany]
  where (QuickBookCompanyID=@QuickBookCompanyID and @QuickBookCompanyID is not null) or 
  (name=@Name and @Name is not null)
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END