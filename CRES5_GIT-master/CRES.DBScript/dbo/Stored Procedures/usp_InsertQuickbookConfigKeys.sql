
CREATE PROCEDURE [dbo].[usp_InsertQuickbookConfigKeys]
@Accesstokenexpiresin int,
@Accesstoken nvarchar(256),
@Code nvarchar(256),
@RealmId nvarchar(256),
@Refreshtoken nvarchar(256),
@Refreshtokenexpiresin int,
@UserID nvarchar(256)
 
AS
BEGIN
	
	INSERT INTO [App].[QuickbookConfig]([Code] 
										,[RealmID] 
										,[Accesstokenexpiresin]
										,RefreshToken 
										,AccessToken
										,Refreshtokenexpiresin
										,[CreatedBy] 
										,[CreatedDate]
										,[UpdatedBy] 
										,[UpdatedDate])
   VALUES(@Code,@RealmId,@Accesstokenexpiresin,@Refreshtoken,@Accesstoken,@Refreshtokenexpiresin,null,getdate(),null,getdate())
END
