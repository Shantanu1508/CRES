CREATE PROCEDURE [dbo].[usp_GetBalanceReport]  

AS
BEGIN
SET NOCOUNT ON; 
select 
d.credealid
,d.DealName
,n.creNoteID
,acc.Name NoteName
,BeginningBalance from cre.Note n inner join cre.deal d on d.dealid=n.dealid
inner join core.Account acc on acc.AccountID=n.Account_AccountID
inner join cre.NotePeriodicCalc cal on cal.NoteID=n.NoteID
where cal.PeriodEndDate=EOMONTH(getdate()) 
order by 2,4
END