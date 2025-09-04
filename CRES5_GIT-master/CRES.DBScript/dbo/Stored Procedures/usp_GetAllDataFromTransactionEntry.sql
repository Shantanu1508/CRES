
CREATE PROCEDURE [dbo].[usp_GetAllDataFromTransactionEntry] --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,100,''
     
AS
BEGIN
      SET NOCOUNT ON;	 
        

declare @NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'



	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select 
	n.CRENoteID Noteid,
	acc.Name NoteName,
	LEFT(CONVERT(VARCHAR, te.[Date], 101), 10) AS [Date],
	te.Amount Value,
	te.[Type] ValueType
	 from  CRE.TransactionEntry te 
	 Inner Join core.account acc on acc.accountid = te.accountid
	inner join cre.note n on n.account_accountid = acc.AccountID
	--inner join Cre.Note n on n.NoteID=te.NoteID
	--inner join core.Account acc on acc.AccountID=n.Account_AccountID
	where acc.AccounttypeID = 1
	AND ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
and  n.NoteID  in (select NoteID from core.calculationRequests where StatusID=266)
order by n.CRENoteID,te.[Date]  asc



SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	



 
	
    
END      


