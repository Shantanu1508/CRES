 CREATE PROCEDURE [dbo].[usp_GetLoanCashFlowValues_DE] 
   @StartDate datetime,
   @EndDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
     
		SELECT  --ot.NoteID
			  --,n.Account_AccountID
			  n.CRENoteID NoteID
			  ,a.Name NoteName
			  ,ot.NPVDate
			  ,ot.CashFlowAdjustedForServicingInfo
  FROM CRE.OutputNPVdata ot inner join CRE.Note n on n.NoteID=ot.NoteID
   inner join Core.Account a on n.Account_AccountID=a.AccountID
   where ot.NPVDate between  (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min(NPVDate)FROM CRE.OutputNPVdata) ELSE @StartDate END )
   and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max(NPVDate)FROM CRE.OutputNPVdata) ELSE @EndDate END )
   and a.IsDeleted=0
  ORDER BY ot.NPVDate DESC	
  	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    
END      

