truncate table [CRE].[LiabilityBanker] 

Insert into  [CRE].[LiabilityBanker] (BankerName)
Select Distinct FinancialInstitution 
from [dbo].[FacilityNameUpdate$]


Update  [CRE].[LiabilityBanker] set  CreatedBy	='B0E6697B-3534-4C09-BE0A-04473401AB93',CreatedDate=getdate(),	UpdatedBy='B0E6697B-3534-4C09-BE0A-04473401AB93',	UpdatedDate=getdate()


Update  cre.debt set  cre.debt.LiabilityBankerID = z.LiabilityBankerID
From(
	Select dt.accountid,acc.name as DebtName,t.FinancialInstitution,lb.LiabilityBankerID
	from cre.debt dt
	Inner join core.account acc on acc.accountid =dt.accountid
	left join dbo.[FacilityNameUpdate$] t on acc.name = t.LiabilityID
	left join cre.LiabilityBanker lb on lb.BankerName = t.FinancialInstitution
	Where t.FinancialInstitution is not null
)z
Where cre.debt.AccountID = z.AccountID


Update  cre.debt set  cre.debt.LiabilityBankerID = z.LiabilityBankerID
From(
	Select Accountid,DebtName,FinancialInstitution,lb.LiabilityBankerID
	From(
		Select dt.accountid,acc.name as DebtName
		,(CASE WHEN acc.name like '%CONA%' THEN 'Capital One'
			WHEN acc.name like '%OZK%' THEN 'Bank OZK'
			WHEN acc.name like '%TBD%' THEN 'TBD'
			WHEN acc.name like '%TBK%' THEN 'TBK Bank'
			WHEN acc.name like '%SWB%' THEN 'Sunwest Bank' 
			ELSE null END
		) FinancialInstitution
		,lb.LiabilityBankerID
		from cre.debt dt
		Inner join core.account acc on acc.accountid =dt.accountid
		left join dbo.[FacilityNameUpdate$] t on acc.name = t.LiabilityID
		left join cre.LiabilityBanker lb on lb.BankerName = t.FinancialInstitution
		Where t.FinancialInstitution is null
	)a
	left join cre.LiabilityBanker lb on lb.BankerName = a.FinancialInstitution
)z
Where cre.debt.AccountID = z.AccountID
