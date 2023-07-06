--[usp_GetJsonTemplateByKey] 1  
CREATE PROCEDURE [dbo].[usp_GetJsonTemplateByKey]           
(          
@Key int           
)          
AS          
BEGIN          
    SET NOCOUNT ON;          
         
SELECT [Value]        
   FROM [CRE].[JsonTemplate]          
          
  WHERE [ID]=@key  
          
         
           
END    