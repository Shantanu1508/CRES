-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLiabilityNoteByLiabilityNoteID]  --'08064F3A-DE16-4009-AA93-7C665766EEAB'  
 @LiabilityNoteGUID nvarchar(256)   
AS  
BEGIN  
  
Select   
 ln.AccountID  
,ln.DealAccountID  
,ln.LiabilityNoteID  
,ln.LiabilityNoteAutoID
,acc.Name as LiabilityNoteName  
,acc.StatusID as [Status]  
,lStatus.name as StatusText  
,ln.LiabilityTypeID  
,tblLibtype.Text as LiabilityTypeText 
,tblLibtype.LiabilityTypeGUID
,ln.AccountID as LiabilityNoteAccountID
,ln.AssetAccountID
,acca.name as AssetName
,ln.UseNoteLevelOverride
,gsetupLia.PledgeDate
,gsetupLia.EffectiveStartDate as EffectiveDate
,gsetupLia.MaturityDate
,gsetupLia.PaydownAdvanceRate
,gsetupLia.FundingAdvanceRate
,gsetupLia.TargetAdvanceRate
,gsetupLia.LiabilitySourceID as LiabilitySource  
,ln.CurrentAdvanceRate 
,ln.CurrentBalance  
,ln.UndrawnCapacity
,ln.[CreatedBy]  
,ln.[CreatedDate]  
,ln.[UpdatedBy]  
,ln.[UpdatedDate]  
,ln.LiabilityNoteGUID
,tblLibtype.[Type]
,CASE WHEN Debt_EquityType='Repo' Then NoteComm.CalculatedCommitment ELSE NULL END as ThirdPartyOwnership
,ln.PaymentFrequency                        
,ln.AccrualEndDateBusinessDayLag			  
,ln.AccrualFrequency                        
,ln.Roundingmethod                          
,ln.IndexRoundingRule                       
,ln.FinanacingSpreadRate                    
,ln.IntActMethod                            
,ln.DefaultIndexName     
,tblLibtype.Debt_EquityType
,ln.DebtEquityTypeID
,ln.pmtdtaccper  
,ln.ResetIndexDaily  
,lpmtdtaccper.name as pmtdtaccperText  
,lResetIndexDaily.name as ResetIndexDailyText  

from cre.LiabilityNote ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID

Left Join core.lookup lpmtdtaccper on lstatus.lookupid = ln.pmtdtaccper
Left Join core.lookup lResetIndexDaily on lstatus.lookupid = ln.ResetIndexDaily

Left Join(
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type], ac.[Name] as Debt_EquityType, d.DebtGUID as LiabilityTypeGUID  
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1
	
	UNION ALL
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type], ac.[Name] as Debt_EquityType, d.EquityGUID as LiabilityTypeGUID 
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1

	UNION ALL
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Cash' as [Type], ac.[Name] as Debt_EquityType,d.CashGUID as LiabilityTypeGUID  
	from cre.Cash d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1
)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID

Left Join CORE.Account acca on acca.AccountID = ln.AssetAccountID

left Join (
	Select acc.AccountID,e.EffectiveStartDate,PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate,PledgeDate,LiabilitySourceID
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


Where acc.IsDeleted <> 1  
and LiabilityNoteGUID = @LiabilityNoteGUID  
  
  
END
GO

