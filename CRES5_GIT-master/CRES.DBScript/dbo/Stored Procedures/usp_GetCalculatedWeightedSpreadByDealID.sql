
--[dbo].[usp_GetCalculatedWeightedSpreadByDealID]	'60f536c8-f553-4693-97ba-b2ddaff14d66'

CREATE PROCEDURE [dbo].[usp_GetCalculatedWeightedSpreadByDealID]	
	@DealID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;
	
	Select 
		nt.NoteID,
		ISNULL(tblDaily.CurrentSpread,0) as WeightedSpread,
		tblDaily.EffectiveRate,
		nt.TotalCommitment,
		0.00 as CalcWeightedSpread,
		0.00 as CalcWeightedEffectiveRate,

		ISNULL(tblDaily.CurrentSpread,0) as SpreadNextPayDt
	From [CRE].[Note] nt 
	Inner Join core.account acc1 on nt.account_accountid = acc1.AccountID
	LEFT JOIN (
		Select 
			NoteID,
			SUM(SpreadOrRate + PikSpreadOrRate) as CurrentSpread, 
			SUM(AllInCouponRate + AllInPikRate) as EffectiveRate 
			FROM
			(Select 
				te.NoteID,
				te.SpreadOrRate,
				te.PikSpreadOrRate, 
				te.AllInCouponRate,
				te.AllInPikRate,
				ROW_NUMBER() OVER (Partition By te.NoteID Order by te.[Date] Desc) as Sno
				FROM [CRE].[DailyInterestAccruals] te
				Inner join cre.note n on n.NoteID = te.NoteID
				Inner Join core.account acc on n.account_accountid = acc.AccountID
				where te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and acc.accounttypeid = 1
				and N.DealID=@DealId
				AND CAST(te.[Date] as Date) <= CAST(GETDATE() AS Date)
				and acc.IsDeleted <> 1
			)Res Where Res.Sno=1
			GROUP BY Res.NoteID
	) tblDaily ON tblDaily.NoteID=nt.NoteID 
	
	Where nt.DealID=@DealID
	and acc1.IsDeleted <> 1
	Order by nt.crenoteID

END

