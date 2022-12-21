--  [dbo].[usp_GetAllJsonTemplateV1]  'B0E6697B-3534-4C09-BE0A-04473401AB93'            
CREATE PROCEDURE [dbo].[usp_GetAllJsonTemplateV1]              
@UserID UNIQUEIDENTIFIER              
               
AS              
BEGIN              
 SET NOCOUNT ON;              
    select 0 as  JsonTemplateID
	,'Select' as JsonTemplateName
	UNION
   SELECT  jt.[ID] as JsonTemplateID            
   ,jt.[key] + ' - ' + jt.[Type] +' ('+jtm.TemplateName+')'  as JsonTemplateName       
      
  FROM [CRE].[JsonTemplate] jt  
  inner join [CRE].[JsonTemplateMaster] jtm on jt.JsonTemplateMasterID = jtm.JsonTemplateMasterID  
END
GO

