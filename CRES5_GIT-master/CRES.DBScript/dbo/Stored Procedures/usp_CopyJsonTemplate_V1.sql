---[dbo].[usp_CopyJsonTemplate_V1]  'Default Template','Test Template','B0E6697B-3534-4C09-BE0A-04473401AB93'  
  
CREATE PROCEDURE [dbo].[usp_CopyJsonTemplate_V1]   
--@copyfrom_TemplateName nvarchar(256), 
@copyfrom_JsonTemplateMasterID int,
@new_TemplateName nvarchar(256),  
@UserID nvarchar(256)  
  
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 --Declare @JsonTemplateMasterID int;  
 Declare @Identity int;  
 --SET @JsonTemplateMasterID = (Select JsonTemplateMasterID from [CRE].[JsonTemplateMaster] where [TemplateName] = @copyfrom_TemplateName)  
  
  
 INSERT INTO [CRE].[JsonTemplateMaster]([TemplateName],[Comment],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])   
 Select @new_TemplateName,[Comment],@UserID as [CreatedBy],getdate() as [CreatedDate],@UserID as [UpdatedBy],getdate() as [UpdatedDate]  
 from [CRE].[JsonTemplateMaster] where JsonTemplateMasterID = @copyfrom_JsonTemplateMasterID  
  
 SET @Identity = @@IDENTITY  
  
 INSERT INTO [CRE].[JsonTemplate]([Key],[Value],[Type],[FileName],[JsonTemplateMasterID])  
 Select [Key],[Value],[Type],[FileName],@Identity as [JsonTemplateMasterID]  
 From [CRE].[JsonTemplate]  
 where JsonTemplateMasterID = @copyfrom_JsonTemplateMasterID  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

