CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForExitAndExtentionStripReceiveable] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Select  DealName as [Deal Name],
			DealID as [CREDealID],
			REPLACE('$' + ISNULL(CONVERT(varchar , CAST(ExtentionFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [ExtentionFeeStrip + Receivable],
			REPLACE('$' + ISNULL(CONVERT(varchar , CAST(ExitFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [ExitFeeStrip + Receivable] ,
			REPLACE('$' + ISNULL(CONVERT(varchar , CAST(OriginationFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [OriginationFeeStrip + Receivable]
			
	from (

		Select Distinct d.dealid,d.dealname,tblExtentionfee.ExtentionFee,tblExitfee.ExitFee,tblOriginationFee.OriginationFee from dbo.Transactionentry tr
		inner join note n on n.noteid =tr.noteid
		inner join deal d on N.DealKey = D.DealKey

		left join(
		Select d.dealid,SUM(tr.amount) as ExtentionFee from dbo.Transactionentry tr
		inner join note n on n.noteid =tr.noteid
		inner join deal d on N.DealKey = D.DealKey
		where scenario = 'Default' 
		and type in ('ExtensionFeeStrippingExcldfromLevelYield','ExtensionFeeStripReceivable')
		group by d.dealid
		)as tblExtentionfee on tblExtentionfee.dealid = d.dealid

		left join(
		Select d.dealid,SUM(tr.amount) as ExitFee from dbo.Transactionentry tr
		inner join note n on n.noteid =tr.noteid
		inner join deal d on N.DealKey = D.DealKey
		where scenario = 'Default' --and type like '%exten%'
		and type in ('ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable')
		group by d.dealid
		)as tblExitfee on tblExitfee.dealid = d.dealid

		left join(
			Select d.dealid,SUM(tr.amount) as OriginationFee from dbo.Transactionentry tr
			inner join note n on n.noteid =tr.noteid
			inner join deal d on N.DealKey = D.DealKey
			where scenario = 'Default' --and type like '%exten%'
			and type in ('OriginationFeeStripping','OriginationFeeStripReceivable')
			group by d.dealid
		)as tblOriginationFee on tblOriginationFee.dealid = d.dealid

		where scenario = 'Default' --and type like '%exten%'
		and  d.dealid in (Select Distinct d1.credealid from cre.deal d1
		inner join cre.note n on n.dealid = d1.dealid
		where n.Actualpayoffdate is null)

	)a
	where ROUND(ExtentionFee,2) <> 0 or ROUND(ExitFee,2) <> 0 or ROUND(OriginationFee,2) <> 0 
	order by DealName


 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END     