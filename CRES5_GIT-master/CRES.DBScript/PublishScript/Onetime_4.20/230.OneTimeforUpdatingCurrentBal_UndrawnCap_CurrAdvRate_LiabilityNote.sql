
UPDATE cre.LiabilityNote
SET
    cre.LiabilityNote.CurrentAdvanceRate = z.CurrentAdvanceRate,
    cre.LiabilityNote.CurrentBalance = z.CurrentBalance,
    cre.LiabilityNote.UndrawnCapacity = z.UndrawnCapacity
FROM 
    (
	
	Select 
		ln.DealAccountID
		,ln.LiabilityNoteID
		,ln.AccountID as LiabilityNoteAccountID
		,acc.Name as LiabilityNoteName

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

		from cre.LiabilityNote ln
		Inner Join core.Account acc on acc.AccountID = ln.AccountID

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
					AND npc.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
					AND npc.PeriodEndDate <= GETDATE()
					and n.account_accountid in (Select AssetAccountId from cre.LiabilityNoteAssetMapping)
				)z where z.rn = 1
 
			)tblEndingBalance on tblEndingBalance.Account_AccountID = la.AssetAccountId 
			group by ln.dealaccountid,ln.AccountID,ln.LiabilityNoteID
		)tblLoanUPB on tblLoanUPB.AccountID = ln.AccountID

		Where acc.IsDeleted <> 1

)z
where  cre.LiabilityNote.AccountID = z.LiabilityNoteAccountID