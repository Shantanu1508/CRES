CREATE PROCEDURE [dbo].[usp_GetFundFacilityLiabilityRelationSummary]
	
AS
BEGIN

	Select 
		 Eq.FundName as Fund_Name
		,tblLibtype.Text as Liability_Name
		,gsetupLia.Liability_Source as  Liability_Type 
		,lBanker.BankerName as 'Financial_Institution'
		,dl.DealName as Deal_Name
		,acc.Name as Liability_Note
		,lStatus.name as 'Status'
		,gsetupLia.PledgeDate as Pledge_Date
		,gsetupLia.EffectiveStartDate as Effective_Date
		,gsetupLia.MaturityDate as Maturity_Date
		,gsetupLia.PaydownAdvanceRate as Paydown_Advance_Rate
		,gsetupLia.FundingAdvanceRate as Funding_Advance_Rate 
		,gsetupLia.TargetAdvanceRate as Target_Advance_Rate
		,ln.CurrentAdvanceRate as Current_Advance_Rate
		,ln.CurrentBalance as Current_Balance
		,ln.UndrawnCapacity as Undrawn_Capacity
		,CASE WHEN Debt_EquityType='Repo' Then NoteComm.CalculatedCommitment ELSE NULL END as Third_Party_Ownership
		,RSIndexFloor.IndexFloor
		,RSIndexName.IndexName

	from cre.LiabilityNote ln
	LEFT JOIN (
		SELECT Distinct sub.FundName,sub.LiabilityTypeID as Fund,ln.LiabilityNoteID,ln.AccountID
		FROM cre.liabilitynote ln
		Inner join cre.deal d on d.AccountID = ln.DealAccountID
		INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
		INNER JOIN (
			SELECT acceq.name as FUndName,LiabilityTypeID,am.AssetAccountId AS assetnotesid
			FROM cre.liabilitynote l
			INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
			Inner join cre.equity eq on eq.accountid = l.LiabilityTypeID
			Inner JOIN core.Account acceq on eq.accountid = acceq.AccountID
		) sub ON la.AssetAccountId = sub.assetnotesid
		LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID	
		where a.IsDeleted <> 1
	) Eq on Eq.AccountID = ln.AccountID
	Inner Join core.Account acc on acc.AccountID = ln.AccountID
	Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
	
	LEFT JOIN CRE.Deal Dl ON Dl.AccountID = ln.DealAccountID
	Left Join [CRE].[Debt] d on d.AccountID = ln.LiabilityTypeID
	Left Join [CRE].[LiabilityBanker] lBanker on lBanker.LiabilityBankerID = d.LiabilityBankerID
	
	Left Join(
		Select acc.AccountID as AccountID,acc.name as [Text] ,ac.[Name] Debt_EquityType
		from cre.Debt d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
		where IsDeleted<> 1
		
		UNION ALL
		
		Select acc.AccountID as AccountID,acc.name as [Text] ,ac.[Name] Debt_EquityType
		from cre.Equity d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
		where IsDeleted<> 1

		UNION ALL
		
		Select acc.AccountID as AccountID,acc.name as [Text] , ac.[Name] Debt_EquityType
		from cre.Cash d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
		where IsDeleted<> 1
	)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID
	
	left Join (
		Select acc.AccountID,e.EffectiveStartDate,PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate,PledgeDate,lLiabilitySource.Name as Liability_Source
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
			GROUP BY D.DealID
		) NT ON NT.DealID = N.DealID
		INNER JOIN CRE.FinancingSourceMaster FS ON FS.FinancingSourceMasterID = N.FinancingSourceID AND FS.IsThirdParty=1
		GROUP BY D.AccountID, NT.TotalCommitment
	)NoteComm on NoteComm.AccountID = ln.DealAccountID

	LEFT JOIN(
		Select Ev.AccountID, RSL.[Value] as IndexFloor
		from core.RateSpreadScheduleLiability RSL 
		INNER JOIN Core.Event Ev ON Ev.EventID = RSL.EventID
		INNER JOIN 
		(						
			Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
			from [CORE].[Event] eve	
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadScheduleLiability')
			and acc.IsDeleted <> 1
			and eve.StatusID = 1
			GROUP BY eve.AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = ev.AccountID and ev.EffectiveStartDate = sEvent.EffectiveStartDate  and ev.EventTypeID = sEvent.EventTypeID
		Where RSL.ValueTypeID in (154)
	) RSIndexFloor ON RSIndexFloor.AccountID = acc.AccountID

	LEFT JOIN(
		Select Ev.AccountID, LName.[Name] as IndexName
		from core.RateSpreadScheduleLiability RSL 
		INNER JOIN Core.Event Ev ON Ev.EventID = RSL.EventID
		INNER JOIN COre.Lookup LName ON LName.LookupID = RSL.IndexNameID
		INNER JOIN 
		(						
			Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
			from [CORE].[Event] eve	
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadScheduleLiability')
			and acc.IsDeleted <> 1
			and eve.StatusID = 1
			GROUP BY eve.AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = ev.AccountID and ev.EffectiveStartDate = sEvent.EffectiveStartDate  and ev.EventTypeID = sEvent.EventTypeID
		Where RSL.ValueTypeID in (778)
	) RSIndexName ON RSIndexName.AccountID = acc.AccountID

	Where acc.IsDeleted <> 1
	and (ln.LiabilityNoteID not like '%LN_PE%' AND ln.LiabilityNoteID not like '%LN_PS%')
	ORDER BY Eq.FundName
		,tblLibtype.Text
		,Liability_Source
		,lBanker.BankerName
		,dl.DealName
		,acc.Name


END
GO