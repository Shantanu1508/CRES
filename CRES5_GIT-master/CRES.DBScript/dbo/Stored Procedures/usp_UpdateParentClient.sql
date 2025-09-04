CREATE PROCEDURE [dbo].usp_UpdateParentClient
	@TableTypeFinancingSourceMaster [TableTypeFinancingSourceMaster] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

update cre.FinancingSourceMaster set cre.FinancingSourceMaster.ParentClient=tbl.ParentClient
from 
(
 select FinancingSourceMasterID,ParentClient from @TableTypeFinancingSourceMaster
)tbl

WHERE CRE.FinancingSourceMaster.FinancingSourceMasterID = tbl.FinancingSourceMasterID

END