truncate table [CRE].[LiabilityFundingScheduleDeal] 

Insert into [CRE].[LiabilityFundingScheduleDeal] 
(
	[AccountID],
	[DealAccountID],
	[TransactionDate],
	[TransactionAmount],
	[TransactionTypes],
    [EndingBalance],
	[Applied],
	[Comments],
	[GeneratedByUserID],
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate]
)
 
Select AccountID
,DealAccountID
,TransactionDate
,SUM(a.TransactionAmount) AS TransactionAmount
,TransactionTypes
,EndingBalance
,Applied
,Comments
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as GeneratedByUserID
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as CreatedBy
,GetDate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,GetDate() as UpdatedDate
From(
	select 
	tr.AccountID,
	d.AccountID as DealAccountID
	,tr.TransactionDate as TransactionDate
	,tr.TransactionAmount as TransactionAmount
	,tr.TransactionTypes
	,Sum(tr.TransactionAmount) Over(Partition By tr.AccountID ORDER by tr.AccountID ,tr.TransactionDate) as EndingBalance
	,CAST(Applied as bit)  Applied             
	,tr.Comments
	From CRE.LiabilityFundingSchedule tr
	left join core.account acc on acc.accountid = tr.AssetAccountID
	left join cre.note n on n.account_accountid= acc.accountid
	Inner join cre.deal d on d.dealid = n.DealID
)a
GROUP BY 
	a.AccountID,
	a.DealAccountID
	,a.TransactionDate,
    a.TransactionTypes,
    a.EndingBalance,
    a.Applied,
    a.Comments
order by a.AccountID ,a.TransactionDate