CREATE Procedure [dbo].[usp_GetAllDebtExt]  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 select   DebtExtID,DebtAccountID,AdditionalAccountID,'DebtExt'  as TableName,'' as LiabilityNoteID from   [CRE].[DebtExt]  
 union all

 select
  DebtID,AccountID as DebtAccountID,DebtGUID as AdditionalAccountID,'Debt'  as TableName,'' as LiabilityNoteID from  cre.debt
   union all

     select LiabilityNoteAutoID as DebtExtID,AccountID as  DebtAccountID ,'E16B9A2A-B9CC-439D-A6D2-516556DBA670' as AdditionalAccountID,'Note'  as TableName,  LiabilityNoteID as LiabilityNoteID from cre.LiabilityNote
	where LiabilityNoteID like '%LN_FIN%'

END  



 