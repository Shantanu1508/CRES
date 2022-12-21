
CREATE PROCEDURE [dbo].[usp_GetQuickbookConfigKeys]
@UserId nvarchar(256)
 
AS
BEGIN
	
	SELECT top 1 Code
		  ,RealmID
		  ,ISNULL(Accesstokenexpiresin,0) as Accesstokenexpiresin
		  ,RefreshToken,AccessToken
		  ,ISNULL(Refreshtokenexpiresin,0) as Refreshtokenexpiresin 
	FROM [App].[QuickbookConfig]
	order by updateddate desc
   
END
