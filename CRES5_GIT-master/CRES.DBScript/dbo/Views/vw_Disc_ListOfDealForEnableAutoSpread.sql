

CREATE View [dbo].[vw_Disc_ListOfDealForEnableAutoSpread]     as

	Select DealName as [Deal Name],CREDealID as [Deal ID],FullPayOffDate as [Full PayOff Date]  ,[Pool] 
	From(
		Select Distinct d.DealName,d.CREDealID,CONVERT(varchar, tblFullPayOff.FullPayOffDate , 101) FullPayOffDate  , 
		STUFF(
			(
				SELECT ', ' + lPool.[Name] AS [text()]
				FROM (
					Select Distinct DealID, PoolID FROM cre.Note 
				) N1
				left join core.Lookup lPool on lPool.LookupID = N1.PoolID
				where N1.DealID = n.DealID 
				ORDER BY lPool.[Name]
				FOR XML PATH (''), TYPE
			).value('text()[1]','nvarchar(max)'), 1, 1, '') [Pool]
		--,n.CRENoteID,acc.name as NoteName,CONVERT(varchar, p.Payoffdate, 101) as Payoffdate    
		from cre.Note n    
		inner join core.account acc on acc.accountid = n.account_accountid    
		inner join cre.Deal d on n.DealID = d.DealID    
		left join dbo.Payoffdate p on p.notekey = n.noteid    
		left join(  select Distinct dealid,MAX([date]) as FullPayOffDate   from cre.DealFunding where purposeid = 630  group by dealid  )tblFullPayOff on tblFullPayOff.dealid = d.dealid  
		where n.ActualPayoffdate is null     
		and acc.IsDeleted <> 1 and d.isdeleted <> 1    
		and d.Status in (323,325)    
		--and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff    
		and ISNULL(EnableAutoSpreadRepayments,0) <> 1   
		and d.DealName NOT LIKE '%copy%'
	)a
 
GO