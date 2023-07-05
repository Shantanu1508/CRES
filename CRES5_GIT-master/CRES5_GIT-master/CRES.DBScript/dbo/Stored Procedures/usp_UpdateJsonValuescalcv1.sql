-- Procedure

CREATE PROCEDURE [dbo].[usp_UpdateJsonValuescalcv1]   
@Key nvarchar(256),  
@Value nvarchar(MAX),  
@Templatename nvarchar(256),
@Type nvarchar(50)  
AS  
BEGIN  
  
SET NOCOUNT ON;    
  
  Declare @JsonTemplateMasterID int;  
  
  
Select @JsonTemplateMasterID = JsonTemplateMasterID
from cre.jsontemplatemaster   
where TemplateName = @Templatename 
  
  
IF(@Key = 'rules')  
BEGIN  
 Update CRE.JsonTemplate set [Value] = @Value where [Key] = 'rules' and [Type] = @Type  and [JsonTemplateMasterID]=@JsonTemplateMasterID
END  
  
  
IF(@Key = 'accounts')  
BEGIN  
 Update CRE.JsonTemplate set [Value] = @Value where [Key] = 'accounts' and [JsonTemplateMasterID]=@JsonTemplateMasterID --and [Type] = @Type  
END  
  
IF(@Key = 'config')  
BEGIN  
 Update CRE.JsonTemplate set [Value] = @Value where [Key] = 'config' and [JsonTemplateMasterID]=@JsonTemplateMasterID --and [Type] = @Type  
END  
  
  
IF(@Key = 'calc_basis')  
BEGIN  
 Update CRE.RootV1Calc set calc_basis = @Value where RootV1CalcID = 1  
END  




  
  
END
GO