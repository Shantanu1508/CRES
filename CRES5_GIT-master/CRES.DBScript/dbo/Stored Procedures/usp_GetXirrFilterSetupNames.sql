-- Procedure
CREATE PROCEDURE [dbo].[usp_GetXirrFilterSetupNames] 
AS  
BEGIN  
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
Select XIRRFilterSetupID,Name,SortOrder from
(
 Select XIRRFilterSetupID, Name,SortOrder from [CRE].[XIRRFilterSetup]
 union 
 select -1 as XIRRFilterSetupID,'N/A' as Name,999 as SortOrder
 ) tbl
order by SortOrder

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END 