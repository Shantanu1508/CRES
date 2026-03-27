CREATE PROCEDURE [dbo].[usp_DeleteDailyGAAPBasisComponents]
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
	
	Delete from CRE.DailyGAAPBasisComponents Where NoteID in (
		Select n.NoteID 
		from cre.note n 
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		where acc.isdeleted <> 1
		and d.IsDeleted <> 1 
		and ISNULL(d.AllowGaapComponentInCashflowDownload,4) <> 3
	)
	


	
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  

