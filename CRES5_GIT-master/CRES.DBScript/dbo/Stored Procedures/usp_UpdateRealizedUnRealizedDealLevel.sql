CREATE PROCEDURE [dbo].[usp_UpdateRealizedUnRealizedDealLevel]
	@DealID nvarchar(256) = null
AS
BEGIN
	SET NOCOUNT OFF;	


	--IF(@DealID IS NULL)
	
	Update cre.deal set cre.deal.RealizedUnRealized = a.LoanStatus
	From(
		Select Distinct d.dealid,(CASE WHEN tblActivedeal.dealid IS NOT NULL THEN 'Unrealized' ELSE 'Realized' END) as LoanStatus
		from cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		Left Join(
			Select Distinct d.dealid,n.actualPayoffdate
			from cre.note n
			Inner Join core.account acc on acc.accountid = n.account_accountid
			Inner join cre.deal d on d.dealid = n.dealid
			Where acc.isdeleted <> 1 and n.actualPayoffdate is null
		)tblActivedeal on tblActivedeal.DealID = d.DealID
		Where acc.isdeleted <> 1
		and (CASE WHEN @DealID IS NULL THEN 1 WHEN  d.DealID = @DealID THEN 1 ELSE 0 END) = 1
	)a
	Where cre.deal.DealID = a.DealID

END