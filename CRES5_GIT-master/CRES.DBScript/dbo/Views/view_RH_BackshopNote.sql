 

--CREATE VIEW [dbo].[view_RH_BackshopNote]
--AS

--Select 
--RTRIM(LTRIM(cm.ControlId)) as DealID,
--RTRIM(LTRIM(cm.DealName)) as DealName ,
--RTRIM(LTRIM(n.NoteId)) as [NoteID],
--RTRIM(LTRIM(n.NoteName)) as [NoteName]

--from dbo.EX_RH_tblNote n
--left join [dbo].[EX_RH_tblControlMaster] cm on cm.ControlId = n.ControlId_F
--left join(
--	Select n.crenoteid from cre.note n
--	inner join core.Account acc on acc.accountid = n.account_accountid
--	inner join cre.deal d on d.dealid = n.dealid
--	where acc.isdeleted <> 1 and n.actualpayoffdate is not null
--	and  d.status <> 325
--	and ISNUMERIC(n.crenoteid)= 1
--)tblpaidoff on tblpaidoff.crenoteid = n.noteid

--Left Join [dbo].[EX_RH_tblzCdLoanStatus] ls on ls.LoanStatusCd = cm.LoanStatusCd_F

--where tblpaidoff.crenoteid is null
--and ls.[LoanStatusDesc] in ('Funded', 'Securtized / Sold (partial)' ,'Paid Off')