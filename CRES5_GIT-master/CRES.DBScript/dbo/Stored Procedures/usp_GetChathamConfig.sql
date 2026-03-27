
CREATE PROCEDURE [dbo].[usp_GetChathamConfig]  
(
 @FrequencyType NVARCHAR (256)
)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	
	Select cc.URL,cc.RatesCode,l.Name as IndexType,cc.[IndexesMasterGuid],cc.IndexTypeID,Description
	from [App].[ChathamConfig] cc
	left join core.lookup l on l.lookupid = cc.IndexTypeID
	Where cc.IsActive = 1
	and FrequencyType=@FrequencyType
END  
