CREATE PROCEDURE [dbo].[usp_UpdateParentFund]
	@TableTypeFund [TableTypeFund] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

update cre.Fund set cre.Fund.ParentFund=tbl.ParentFund
from 
(
 select FundID,ParentFund from @TableTypeFund
)tbl

WHERE CRE.Fund.FundID = tbl.FundID

END