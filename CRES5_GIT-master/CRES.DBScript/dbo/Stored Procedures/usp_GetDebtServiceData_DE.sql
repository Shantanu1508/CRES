 CREATE PROCEDURE [dbo].[usp_GetDebtServiceData_DE] 
   @StartDate datetime,
   @EndDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
     
		SELECT  --pc.NoteID
			  --,n.Account_AccountID
			  n.CRENoteID NoteID
			  ,a.name NoteName
			  ,pc.PeriodEndDate
			  ,pc.InterestPaidonPaymentDate
			  ,pc.PrincipalPaid
			  ,pc.EndingGAAPBookValue
  FROM CRE.NotePeriodicCalc pc 
  Inner join core.account acc on acc.accountid = pc.AccountID
  Inner join cre.note n on n.account_accountid = acc.accountid 
  --inner join CRE.Note n on n.NoteID=pc.NoteID
   inner join Core.Account a on n.Account_AccountID=a.AccountID
  where pc.PeriodEndDate between  (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min(PeriodEndDate)FROM CRE.NotePeriodicCalc) ELSE @StartDate END )
  and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max(PeriodEndDate)FROM CRE.NotePeriodicCalc) ELSE @EndDate END )
 and a.IsDeleted=0
 and acc.AccounttypeID = 1
  ORDER BY pc.PeriodEndDate DESC
  	
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      
     
