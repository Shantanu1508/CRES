

CREATE PROCEDURE [dbo].[usp_GetAllTemplateMaster] 
	      
AS
BEGIN
    SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select JsonTemplateMasterID,TemplateName from [CRE].[JsonTemplateMaster]

END


