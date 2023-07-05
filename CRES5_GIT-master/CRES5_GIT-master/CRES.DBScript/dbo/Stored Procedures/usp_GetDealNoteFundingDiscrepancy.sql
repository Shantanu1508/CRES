CREATE PROCEDURE [dbo].[usp_GetDealNoteFundingDiscrepancy] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
SELECT DealName as [Deal Name], 
       CREDealID as [CREDealID], 
	   CONVERT(varchar, DealFundingDate, 101)  as [Deal Funding Date], 
	   REPLACE('$' + CONVERT(varchar, CAST(DealFundingAmount AS money), 1),'$-','-$') as [Deal Funding Amount],
	   CONVERT(varchar, NoteFundingDate, 101) as [Note Funding Date], 
	   REPLACE('$' + CONVERT(varchar, CAST(NoteFundingAmount AS money), 1),'$-','-$') as [Note Funding Amount],
	   REPLACE('$' + CONVERT(varchar , Delta ,1), '$-','-$') as [Delta]
FROM (		
		SELECT  dd.DealID
			   ,dd.DealName 
			   ,dd.CREDealID
			   ,NoteFundingDate
			   ,df.Date as DealFundingDate
			   ,CAST(SUM(Amount) AS DECIMAL(18,2)) as DealFundingAmount
			   ,CAST(NoteFundingAmount AS DECIMAL(18,2)) as NoteFundingAmount
			   ,CAST(CAST((SUM(Amount) - NoteFundingAmount)AS DECIMAL(18,2)) as money) as Delta
		FROM  [CRE].[DealFunding] df
		inner join cre.deal dd on dd.dealid = df.dealid
		LEFT JOIN 
			(
			Select 
			 d.DealID,
			 fs.Date as NoteFundingDate,
			 SUM(fs.Value) as NoteFundingAmount
			from [CORE].FundingSchedule fs
			INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
			INNER JOIN 
						(
							Select 
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
								MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
								from [CORE].[Event] eve
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
								where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
								--and n.CRENoteID = '3394' 
								and acc.IsDeleted = 0
								and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
						) sEvent
			
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
			left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
			left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			INNER JOIN [CRE].[Deal] d ON d.DealID = n.DealID
			where sEvent.StatusID = e.StatusID  
			and acc.IsDeleted = 0
			GROUP BY d.DealID, fs.Date
			) notefunding ON notefunding.DealID = dd.DealID and notefunding.NoteFundingDate = df.Date
			where dd.DealName <> 'Sizer test 01' and df.amount <> 0
		GROUP BY dd.DealID,dd.DealName, NoteFundingAmount,dd.credealid,NoteFundingDate, df.Date
     ) _delta
WHERE abs(ISNULL(Delta,1))<>0

and dealid in (
	Select Distinct d.dealid from cre.deal d
	inner join cre.note n on n.dealid = d.dealid
	where n.actualpayoffdate is null and d.isdeleted <> 1
)
order by  dealname,dealfundingdate, notefundingdate

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END     
