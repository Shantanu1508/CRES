-- [dbo].[usp_GetPropertyTypeMajor] 'd4cb7189-0b71-48c0-93e1-b81fde38da59'
CREATE Procedure [dbo].[usp_GetPropertyTypeMajor]  
@UserID NVarchar(255)  
  
AS  
  
BEGIN  
  
 SET NOCOUNT ON;  
  
 Select   
 PropertyTypeMajorID,
 PropertyTypeMajorDesc
 from cre.[PropertyTypeMajor]
 order by OrderKey  
END
GO

