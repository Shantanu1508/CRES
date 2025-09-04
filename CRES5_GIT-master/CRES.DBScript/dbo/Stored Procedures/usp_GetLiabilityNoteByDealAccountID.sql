-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLiabilityNoteByDealAccountID]   ---'C5C2CD90-2321-4B2A-8BA4-9E3C273ED3AC'
	@DealAccountID UNIQUEIDENTIFIER 
AS
BEGIN

Select 
 ln.LiabilityNoteAutoID
,ln.DealAccountID
,ln.LiabilityNoteGUID
,ln.LiabilityNoteID
,ln.AccountID as LiabilityNoteAccountID
,acc.Name as LiabilityNoteName
,acc.StatusID as [Status]
,lStatus.name as StatusText
,ln.LiabilityTypeID
,tblLibtype.Text as LiabilityTypeText

,ln.AssetAccountID
,acca.AssetName as AssetName
,acca.AccountTypeID
,gsetupLia.PledgeDate
,gsetupLia.EffectiveStartDate as EffectiveDate
,gsetupLia.MaturityDate
,gsetupLia.PaydownAdvanceRate
,gsetupLia.FundingAdvanceRate
,gsetupLia.TargetAdvanceRate
,gsetupLia.LiabilitySourceID as LiabilitySource 
,gsetupLia.LiabilitySourceText

,CASE 
    WHEN tblLoanUPB.CurrentLoanUPB <> 0 THEN (tblCurrentBal.EndingBalance / tblLoanUPB.CurrentLoanUPB)
    ELSE NULL
END AS CurrentAdvanceRate

,tblCurrentBal.EndingBalance as CurrentBalance

,CASE 
	WHEN (gsetupLia.TargetAdvanceRate * (tblCommitment.TotalCommitment - tblLoanUPB.CurrentLoanUPB)) < 0 
	THEN 0 
	ELSE (gsetupLia.TargetAdvanceRate * (tblCommitment.TotalCommitment - tblLoanUPB.CurrentLoanUPB)) 
END AS UndrawnCapacity

,ln.[CreatedBy]
,ln.[CreatedDate]
,ln.[UpdatedBy]
,ln.[UpdatedDate]

,CASE WHEN Debt_EquityType='Repo' Then NoteComm.CalculatedCommitment ELSE NULL END as ThirdPartyOwnership

,tblLibtype.[Type] as LiabilityType
,tblLibtype.LiabilityTypeGUID
,ln.DebtEquityTypeID
,lBanker.BankerName as BankerText
,CASE 
        WHEN ln.LiabilityNoteID LIKE '%[_]Fin[_]%' AND ln.AccountID = ActiveLN.AccountID THEN 1 
        ELSE 0 
 END AS ActiveLiabilityNote

from cre.LiabilityNote ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID

Left Join [CRE].[Debt] d on d.AccountID = ln.LiabilityTypeID
Left Join [CRE].[LiabilityBanker] lBanker on lBanker.LiabilityBankerID = d.LiabilityBankerID
Left Join(
	Select acc.AccountID as AccountID,acc.name as [Text] ,'debt' as [Type], ac.[Name] Debt_EquityType, d.DebtGUID as LiabilityTypeGUID
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1
	UNION ALL
	Select acc.AccountID as AccountID,acc.name as [Text] ,'equity' as [Type], ac.[Name] Debt_EquityType, d.EquityGUID as LiabilityTypeGUID
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1

	UNION ALL
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Cash' as [Type], ac.[Name] Debt_EquityType, d.CashGUID as LiabilityTypeGUID
	from cre.Cash d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1
)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID


left Join (
	Select AssetAccountID,AssetName,AccountTypeID
	From(
		SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID,acc.AccountTypeID
		FROM CRE.Deal AS d
		INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID
		WHERE acc.IsDeleted <> 1 and acc.AccountID = @DealAccountID

		UNION ALL

		SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID,acc.AccountTypeID
		FROM CRE.Note AS n
		INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
		WHERE acc.IsDeleted <> 1
		and n.DealID = (Select dealid from cre.deal where AccountID= @DealAccountID)
	)z
)acca on acca.AssetAccountID = ln.AssetAccountID

left Join (
	Select acc.AccountID,e.EffectiveStartDate,PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate,PledgeDate,LiabilitySourceID
			,lLiabilitySource.Name as LiabilitySourceText
	from [CORE].GeneralSetupDetailsLiabilityNote gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsLiabilityNote')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	Left Join core.lookup lLiabilitySource on lLiabilitySource.lookupid = gslia.LiabilitySourceID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupLia on gsetupLia.AccountID = ln.AccountID

left Join(
	SELECT D.AccountID, (SUM(N.TotalCommitment) / NT.TotalCommitment) CalculatedCommitment
	FROM CRE.Deal D
	INNER JOIN CRE.NOTE N ON N.DealID = D.DealID
	INNER JOIN (
		SELECT D.DealID, SUM(NT.TotalCommitment) TotalCommitment 
		FROM CRE.NOTE NT 
		INNER JOIN CRE.Deal D ON NT.DealID = D.DealID 
		WHERE D.AccountID = @DealAccountID GROUP BY D.DealID
	) NT ON NT.DealID = N.DealID
	INNER JOIN CRE.FinancingSourceMaster FS ON FS.FinancingSourceMasterID = N.FinancingSourceID AND FS.IsThirdParty=1
	WHERE D.AccountID = @DealAccountID
	GROUP BY D.AccountID, NT.TotalCommitment
)NoteComm on NoteComm.AccountID = ln.DealAccountID

Left Join(
	Select tel.LiabilityNoteAccountID, tel.EndingBalance, tel.[Date]
	,ROW_NUMBER() OVER (PARTITION BY tel.LiabilityNoteAccountID ORDER BY tel.Date DESC) AS rn
	from cre.TransactionEntryLiability tel
	where tel.Date <= GETDATE()
)tblCurrentBal on tblCurrentBal.LiabilityNoteAccountID = ln.AccountID AND tblCurrentBal.rn = 1

Left Join(
	SELECT 
		ln.AccountID, 
		ln.LiabilityNoteID,
		SUM(n.TotalCommitment) as TotalCommitment
	FROM 
		CRE.LiabilityNote ln
	Inner JOIN cre.LiabilityNoteAssetMapping la on la.LiabilityNoteAccountId = ln.AccountId
	Left Join cre.Note n on n.account_accountid = la.AssetAccountID
	Inner join core.account acc on acc.accountid = n.Account_AccountID
	where acc.isdeleted <> 1 and ln.dealaccountid = @DealAccountID
	Group By  ln.AccountID, ln.LiabilityNoteID
)tblCommitment on tblCommitment.AccountID = ln.AccountID

Left Join(
	SELECT 
		ln.AccountID,
		ln.LiabilityNoteID,	
		SUM(tblEndingBalance.EndingBalance) as CurrentLoanUPB	
	from cre.LiabilityNote ln 
	Inner Join cre.LiabilityNoteAssetMapping la on la.LiabilityNoteAccountId = ln.AccountId
	Left Join(
		Select * from(
			SELECT 
			n.Account_AccountID,
			npc.periodenddate,
			npc.endingbalance,
			ROW_NUMBER() OVER (PARTITION BY npc.AccountId ORDER BY PeriodEndDate DESC) AS rn
			FROM cre.NotePeriodicCalc npc
			Left Join cre.note n on n.Account_AccountID = npc.AccountId
			Inner join core.account acc on acc.accountid = n.Account_AccountID
			Inner join cre.deal d on d.dealid = n.dealid
			WHERE acc.isdeleted <> 1
			and d.accountid = @DealAccountID
			AND npc.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			AND npc.PeriodEndDate <= GETDATE()
			and n.account_accountid in (Select AssetAccountId from cre.LiabilityNoteAssetMapping where DealAccountId = @DealAccountID)
		)z where z.rn = 1
 
	)tblEndingBalance on tblEndingBalance.Account_AccountID = la.AssetAccountId 
	where ln.dealaccountid = @DealAccountID
	group by ln.dealaccountid,ln.AccountID,ln.LiabilityNoteID
)tblLoanUPB on tblLoanUPB.AccountID = ln.AccountID

LEFT JOIN (
    SELECT top 1 ln_inner.AccountID,e.EffectiveStartDate,
	ROW_NUMBER() OVER (PARTITION BY ln_inner.LiabilityNoteID ORDER BY e.EffectiveStartDate DESC) AS rn
    FROM cre.LiabilityNote ln_inner
    Inner JOIN core.event e ON ln_inner.accountid = e.accountid
    WHERE ln_inner.LiabilityNoteID LIKE '%[_]Fin[_]%' and ln_inner.DealAccountID = @DealAccountID
) ActiveLN ON ln.AccountID = ActiveLN.AccountID AND ActiveLN.rn = 1


Where acc.IsDeleted <> 1
and DealAccountID = @DealAccountID

Order by ln.LiabilityNoteID

END
GO