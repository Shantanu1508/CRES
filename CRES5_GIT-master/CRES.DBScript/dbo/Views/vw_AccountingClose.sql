
CREATE VIEW [dbo].[vw_AccountingClose]
AS
	Select d.DealName,d.CREDealID as DealID
	,tbldd.ClosingDate
	,tbldd.Maturity
	,P.CloseDate as AccountingCloseDate
	,p.OpenDate as AccountingOpenDate
	,(u.FirstName + ' ' + u.LastName) as UpdatedBy
	,p.UpdatedDate as UpdatedOn
	,tbllastAct.LastActivityType
	from cre.deal d
	Inner join CORE.[Period] p on d.dealid = p.dealid 
	Left join App.[User] u on u.UserID = p.UpdatedBy
	Left Join(
		Select d.dealid,MAX(n.ClosingDate) as ClosingDate,MAX(ISNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate)) as Maturity
		from cre.Deal d
		Inner Join cre.note n on n.dealid = d.dealid
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		--and d.dealid = @DealID
		Group by d.dealid
	)tbldd on tbldd.dealid = d.dealid
	
	Left Join(
		Select dealid,LastActivityType
		From(
			Select 
			p.dealid 
			,LastActivityType
			,ROW_NUMBER() OVER (Partition BY p.dealid order by p.dealid,p.PeriodAutoID desc) rno
			from CORE.[Period] p 
		)a
		Where rno = 1
	)tbllastAct on tbllastAct.dealid = d.dealid

	where  d.isdeleted <> 1 
	--and d.dealid = @DealID
	--Order by d.dealname,P.CloseDate desc

