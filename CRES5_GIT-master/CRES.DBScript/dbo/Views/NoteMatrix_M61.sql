-- View
--Select count(*) from [dbo].[NoteMatrix_M61]

CREATE view [dbo].[NoteMatrix_M61]
As
select
d.credealid as DealID ,  
DealGroupID as DealGroupID ,  
n.Crenoteid as NoteID ,  
n.[priority] as Pri ,  
d.dealname as DealName ,  
CAST(acc.name as Nvarchar(256)) as NoteName , 
 
--(CASE WHEN uwd.LoanStatusCd_F = 'Securitized / Sold / Paid' THEN 'Paid off' ELSE uwd.LoanStatusCd_F END)  as LoanStatus ,  
(CASE WHEN n.ActualPayOffDate is not null THEN 'Paid off' ELSE 'Active' END)  as LoanStatus , 

c.Clientname as Client ,  
f.FundName as Fund ,  
uAM.LastName +', '+uAM.FirstName as AssetManager ,  
CAST('' as Nvarchar(256)) as Banker ,  
CAST('' as Nvarchar(256)) as Credit ,  
lPool.name as [Pool] ,  
fs.FinancingSourceName as FinancingSource ,  
lDebtType.name as DebtType ,  
lCapStack.name as CapStack ,  
lBillingNote.name as BillingNote ,  
n.TotalCommitment as Commitment ,  

(CASE WHEN tblRateType.RateType = 'Fixed' THEN tblRateType.FIxedRate ELSE tblSpread.value END) as [Spread],  

--n.StubInterestRateOverride as [IndexforStub],  
n.Initialindexvalueoverride as [IndexforStub],  

tblIndexFloor.value as [Floor],  

---tblAllInRate.AllInCouponRate as [AllInRate],  
(CASE WHEN tblRateType.RateType = 'Fixed' THEN tblRateType.FIxedRate ELSE null END) as AllInRate,

tblRateType.RateType as [Type] ,  

n.ClosingDate as InitialFunding ,  
InitialMaturity.[SelectedMaturityDate] as InitialMaturity ,  

n.ExpectedMaturityDate as ExtendedMaturity ,  
--null as ExtendedMaturity ,  

tblExtendedMat.ExtendedMaturityScenario1 as ExtendedMaturity1,
tblExtendedMat.ExtendedMaturityScenario2 as ExtendedMaturity2,
tblExtendedMat.ExtendedMaturityScenario3 as ExtendedMaturity3,
tblExtendedMat.ExtendedMaturityScenario4 as ExtendedMaturity4,

ISNULL(n.ActualPayoffdate,n.FullyExtendedMaturityDate) as FullyExtendedMaturity,  

tblMat.MaturityDate as CurrentMaturityDate,  
CAST(tblMat.MaturityType as nvarchar(256)) as CurrentMaturity,  
(CASE WHEn tblMat.MaturityType = 'Realized' THEN tblMat.MaturityDate ELSE null END) as PaidOffSold ,  
CAST('' as nvarchar(256)) as FeesStart ,  
tblEntitiy.RSLIC as RSLIC ,  
tblEntitiy.SNCC as SNCC ,  
tblEntitiy.PIIC as PIIC ,  
tblEntitiy.TMR as TMR ,  
tblEntitiy.HCC as HCC ,  
tblEntitiy.USSIC as USSIC ,  
tblEntitiy.TMNF as TMNF ,  
tblEntitiy.HAIH as HAIH ,  
tblEntitiy.TotalParticipation as [Check] ,  
CAST('' as nvarchar(256)) as CAMRA ,  
svr.ServicerName as Servicer ,  
n.ServicerID as ServicerID ,  
n.Discount as PremDisc ,  
n.OriginationFeePercentageRP as OriginationFee ,  
CAST('' as nvarchar(256)) as FutureFundingsatParor99,  
CAST(lPaydown.value as int) as PaydownPayoffConvention,  
CAST(null as decimal(28,15)) as [Other],  
CAST('' as nvarchar(256)) as NoteClassification ,  
CAST(null as decimal(28,15))  as ExitFee ,  
CAST(tblWholeLoanSpread.DealWholeSpread as decimal(28,15))  as WholeLoanSpread,  
--(CASE WHEn tblExten.NumericValue = 1 THEN tblExten.Value End) as ExtensionFee1,  
--(CASE WHEn tblExten.NumericValue = 2 THEN tblExten.Value End) as ExtensionFee2,  
--(CASE WHEn tblExten.NumericValue = 3 THEN tblExten.Value End) as ExtensionFee3,  
--(CASE WHEn tblExten.NumericValue = 4 THEN tblExten.Value End) as ExtensionFee4,  
CAST(null as decimal(28,15))  as ExtensionFee1,  
CAST(null as decimal(28,15))  as ExtensionFee2,  
CAST(null as decimal(28,15))  as ExtensionFee3,  
CAST(null as decimal(28,15))  as ExtensionFee4,  
CAST(null as decimal(28,15))  as [SeniorLoanSpread],  
CAST(null as decimal(28,15))  as [SubLoanSpread],  

--n.DeterminationDateReferenceDayoftheMonth as [PaymentDate],  
ISNULL(ISNULL(tblPaymentDay.PaymentDay,n.DeterminationDateReferenceDayoftheMonth),31) as [PaymentDate],  

---tblDealItem.PropertyTypeBS as ProductType,  
ptm.PropertyTypeMajorDesc as ProductType, 

CAST(d.MSA_NAME as nvarchar(256)) as MSA,  

---CAST(d.BSCity as nvarchar(256)) as State,   
CAST(ISNULL(mp.[state],tblPCitynull.havingnull_state) as nvarchar(256)) as State,

---(CASE WHEN dtm.DealTypeName = 'Moderate Renovation' THEN 'Moderate Rehab' WHEN dtm.DealTypeName = 'Heavy Renovation' THEN 'Heavy Rehab' ELSE dtm.DealTypeName END) as DealType,  
d.BS_CollateralStatusDesc as DealType,  

CAST('' as nvarchar(256)) as CurrentEntity,  
YEAR(d.[InquiryDate]) as [InquiryYear],  
--NULLIF(d.BSCity,'') +', '+NULLIF(d.BSState,'') as [Location],  
NULLIF(ISNULL(mp.City,tblPCitynull.havingnull_City),'') +', '+NULLIF(ISNULL(mp.[State],tblPCitynull.havingnull_state),'') as [Location],  

CAST(null as decimal(28,15))  as [UnderwrittenReturn],  
CAST(null as decimal(28,15))  as [AcoreOrig] ,


mp.BSPropertyID as BS_PropertyID,
mp.PropertyRollUpSW


from cre.note n
Inner join core.account acc on n.account_accountid =acc.accountid
Inner join cre.deal d on d.dealid = n.dealid
Left join cre.client c on c.ClientID = n.ClientID
Left join cre.Fund f on f.FundID = n.FundID
Left Join App.[User] uAM on uAM.UserId = d.AMUserID
Left JOin core.lookup lPool on lPool.lookupid = n.poolid
Left JOin cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
Left JOin core.lookup lDebtType on lDebtType.lookupid = n.DebtTypeID
Left JOin core.lookup lCapStack on lCapStack.lookupid = n.CapStack
Left JOin core.lookup lBillingNote on lBillingNote.lookupid = n.BillingNotesID
Left Join cre.Servicer svr on svr.ServicerID = n.ServicerNameID
Left JOin dw.UWDealBI uwd on uwd.controlid = d.credealid
left join cre.DealTypeMaster dtm on dtm.DealTypeMasterID = d.DealTypeMasterID
Left JOin core.lookup lratetype on lratetype.lookupid = n.ratetype 
left join [CRE].[PropertyTypeMajor]  ptm on ptm.PropertyTypeMajorID = d.PropertyTypeMajorID
left join(
		Select  n.noteid,mat.maturityDate as SelectedMaturityDate
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11  and eve.StatusID = 1
			and acc.IsDeleted = 0  			
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 		
		where mat.maturityType = 708 
		and	mat.Approved = 3
)InitialMaturity on InitialMaturity.noteid = n.noteid

Left JOin(
	Select noteid, crenoteid,value,ValueType,StartDate
	From(
		Select noteid,crenoteid,value,ValueType,StartDate,Row_number() over (Partition BY noteid,crenoteid order by crenoteid,StartDate desc) as rowno
		from 
		(
			Select n1.noteid,n1.crenoteid,rs.value,LValueTypeID.name as ValueType,rs.Date as StartDate
			from [CORE].RateSpreadSchedule rs
				INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
				inner join core.account acc1 on acc1.AccountID =e.accountid
				inner join cre.Note n1 on n1.account_accountid = acc1.accountid
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
				INNER JOIN (						
					Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
					--and n.creNoteID in (Select noteid from #tblListNotes where noteid not in ('9809','9810'))
					and acc.IsDeleted = 0		
					GROUP BY n.Account_AccountID,EventTypeID
				) sEvent
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				and LValueTypeID.Name = 'Spread'
				and rs.Date <= ISNULL(n1.ActualPayoffDate,CAST(getdate() as date))
				--and n1.crenoteid = '15927'
		)a
	)b where b.rowno = 1
)tblSpread on tblSpread.noteid = n.noteid

Left JOin(
	Select noteid, crenoteid,value,ValueType,StartDate
	From(
		Select noteid,crenoteid,value,ValueType,StartDate,
		row_number() over (Partition BY noteid,crenoteid order by crenoteid,StartDate desc) as rowno
		from 
		(
			Select n1.noteid,n1.crenoteid,rs.value,LValueTypeID.name as ValueType,rs.Date as StartDate
			from [CORE].RateSpreadSchedule rs
				INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
				inner join core.account acc1 on acc1.AccountID =e.accountid
				inner join cre.Note n1 on n1.account_accountid = acc1.accountid
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
				INNER JOIN (						
					Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
					--and n.creNoteID in (Select noteid from #tblListNotes where noteid not in ('9809','9810'))
					and acc.IsDeleted = 0		
					GROUP BY n.Account_AccountID,EventTypeID
				) sEvent
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				and LValueTypeID.Name = 'Index Floor'
				and rs.Date <= CAST(getdate() as date)
				--and n1.crenoteid = '15927'
		)a
	)b where b.rowno = 1
)tblIndexFloor on tblIndexFloor.noteid = n.noteid

Left Join(
	SELECT CRENoteId ,ISNULL(RSLIC,0) as RSLIC,ISNULL(SNCC,0) as SNCC,ISNULL(PIIC,0) as PIIC,
	ISNULL(TMR,0) as TMR,ISNULL(HCC,0) as HCC,ISNULL(USSIC,0) as USSIC,ISNULL(TMNF,0) as TMNF,ISNULL(HAIH,0) as HAIH,
	(ISNULL(RSLIC,0)+ISNULL(SNCC,0)+ISNULL(PIIC,0)+ISNULL(TMR,0)+ISNULL(HCC,0)+ISNULL(USSIC,0)+ISNULL(TMNF,0)+ISNULL(HAIH,0)) TotalParticipation
	FROM   
	(
		Select CRENoteId,TrancheName,PercentofNote  from CRE.NoteTranchePercentage
	) t 
	PIVOT(
		SUM(PercentofNote) 
		FOR TrancheName IN (RSLIC,SNCC,PIIC,TMR,HCC,USSIC,TMNF,HAIH)
	) AS pivot_table
)tblEntitiy on tblEntitiy.creNoteid = n.crenoteid

left join Core.lookup lPaydown on lPaydown.lookupid = n.InterestCalculationRuleForPaydowns and lPaydown.parentid = 99

Left Join(

	Select n1.noteid,n1.crenoteid, ISNULL(n1.ActualPayOffDate,currMat.MaturityDate) as MaturityDate,	
	(CASE WHEN n1.ActualPayoffDate is not null Then 'Realized' 
	Else
	ISNULL((CASE WHEN currMat.MaturityTypeID = 708 THEN 'Initial Maturity'
			WHEN (currMat.MaturityTypeID = 709 and Extended_Rno = 1) THEN 'Extended Maturity 1'
			WHEN (currMat.MaturityTypeID = 709 and Extended_Rno = 2) THEN 'Extended Maturity 2'
			WHEN (currMat.MaturityTypeID = 709 and Extended_Rno = 3) THEN 'Extended Maturity 3'
			ELSE 'Fully Extended Maturity' END),'Initial Maturity')
		END)as MaturityType
	from cre.note n1
	Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
	Left Join(
		Select noteid,MaturityType,MaturityDate,Approved,MaturityTypeID,Extended_Rno
		from (
				Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,mat.MaturityType as MaturityTypeID,
				ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
				,ROW_NUMBER() over(Partition by noteid,mat.MaturityType order by noteid,MaturityDate) as Extended_Rno
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11
					--and n.noteid = @NoteID     
					and acc.IsDeleted = 0  
					and eve.StatusID = 1
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				where mat.MaturityDate > getdate()
				and lApproved.name = 'Y'
				and e.StatusID = 1
				--n.noteid =  @NoteID   
		)a where a.rno = 1
	)currMat on currMat.noteid = n1.noteid
	where acc1.IsDeleted <> 1
)tblMat on tblMat.noteid = n.noteid

--Left Join(
--	Select noteid,AllInCouponRate
--	From(
--		Select noteid,Date,AllInCouponRate ,
--		ROW_NUMBER() Over (Partition by noteid order by noteid,Date desc) rno
--		from [CRE].[PeriodicInterestRateUsed]
--		where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--		--and noteid = '06C834F6-7822-4B65-A054-013634D650F7'
--		and CAST([date] as date) <= CAST(getdate() as date)
--	)a
--	where a.rno = 1
--)tblAllInRate on tblAllInRate.noteid = n.noteid

Left JOin(
	SELECT dealid,DealName, SUM(ValOriginalCommitment)/SUM(OriginalTotalCommitment) as DealWholeSpread
	FROM
	(
		SELECT dealid,DealName,( Value * OriginalTotalCommitment ) as ValOriginalCommitment, OriginalTotalCommitment,CRENoteID
		FROM (
			Select sEvent.CRENoteID, rs.Value, sEvent.OriginalTotalCommitment,sEvent.DealName ,sEvent.dealid
			from [CORE].RateSpreadSchedule rs
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
			INNER JOIN (
				Select
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,n.CRENoteID,n.OriginalTotalCommitment,d.DealName,d.dealid,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID 
				from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				inner join cre.deal d on d.dealid = n.dealid
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = 14
				and eve.StatusID = 1
				--and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) = @ObjectValue
				and acc.IsDeleted <> 1
				GROUP BY n.Account_AccountID,EventTypeID,n.CRENoteID,n.OriginalTotalCommitment,d.DealName,d.dealid
			) sEvent
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID
			where e.StatusID = 1
			and LValueTypeID.name = 'spread'
			and rs.Date <= getdate()
		)a
		where OriginalTotalCommitment > 0
		group by a.Value,a.OriginalTotalCommitment,CRENoteID,DealName,dealid
	)b
	group by DealName,dealid
)tblWholeLoanSpread  on tblWholeLoanSpread.dealid = n.noteid

left join(
	Select noteid,ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10
	From(
		Select  n.noteid,
		'ExtendedMaturityScenario' + CAST(ROW_NUMBER() Over(Partition BY Noteid order by noteid,MaturityDate) as nvarchar(256))  as MaturityType
		,mat.MaturityDate			
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11  
			and acc.IsDeleted = 0  		
			and eve.StatusID = 1		
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
		where mat.MaturityType in (709)
		and e.StatusID = 1
		--and n.crenoteid = '2230'

	) AS SourceTable  
	PIVOT  
	(  
		MIN(MaturityDate)  
		FOR MaturityType IN (ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10)  
	) AS PivotTable

)tblExtendedMat on tblExtendedMat.noteid = n.noteid

LEFT JOIN(
	Select noteid,[Rate],[Spread],[Reference Rate],RateType,ISNULL([Rate],([Spread] + [Reference Rate])) as FixedRate 
	from(
		Select noteid,[Rate],[Spread],[Reference Rate] ,(CASE WHEN (Spread is not null and [Reference Rate] is not null) OR ([Rate] is not null and Spread is null and [Reference Rate] is null) THEN 'Fixed' ELSE 'ARM' END ) as RateType
		from(	
			Select n1.NoteID, LValueTypeID.name as ValueType,rs.value
			from [CORE].RateSpreadSchedule rs
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
			INNER JOIN(					
				Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = 14
				and eve.StatusID = 1
				--and n.creNoteID = '6659'
				and acc.IsDeleted = 0
				GROUP BY n.Account_AccountID,EventTypeID
			) sEvent
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
			inner join core.Account ac on ac.AccountID =e.AccountID
			inner join cre.Note n1 on n1.Account_AccountID = ac.AccountID
			where e.StatusID = 1
			and rs.Date <= ISNULL(n1.ActualPayoffDate,CAST(getdate() as date))
		) AS SourceTable  
		PIVOT  
		(  
			MIN(value)  
			FOR ValueType IN ([Rate],[Spread],[Reference Rate])  
		) AS PivotTable
	)z
)tblRateType on tblRateType.noteid = n.noteid
Left Join(
	Select noteid,PaymentDay
	From(
		Select noteid,PaymentDay,ROW_NUMBER() OVER (Partition by NoteID order by NoteID,PaymentDay desc) as Rno
		From(
			Select Distinct n.noteid,DAY(tr.PaymentDateNotAdjustedforWorkingDay) PaymentDay
			from cre.transactionEntry tr
			Inner Join cre.note n on n.account_accountid = tr.accountid

			where [Type] = 'InterestPaid' and Analysisid  = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and PaymentDateNotAdjustedforWorkingDay is not null		

		)a
	)z where z.Rno = 1
)tblPaymentDay on tblPaymentDay.noteid = n.noteid

left join(
	--Select  credealid,city,[State],[M61_location]
	--From(
	--	Select Distinct d.credealid,p.city,p.PState as [State],(city + ', ' +PState) as [M61_location],
	--	ROW_NUMBER() Over(Partition by credealid order by credealid,Allocation desc) as rno
	--	from cre.Property p
	--	inner join cre.deal d on d.dealid = p.deal_dealid
	--	 where city is not null
	--)b where rno = 1


	Select Distinct credealid,city,[State],[M61_location],BSPropertyID,PropertyRollUpSW
	From(
		Select Distinct d.credealid,p.city,p.PState as [State],Allocation,(city + ', ' +PState) as [M61_location],
		ROW_NUMBER() Over(Partition by credealid order by credealid,PropertyRollUpSW desc,Allocation desc) as rno,
		BSPropertyID,PropertyRollUpSW
		from cre.Property p
		inner join cre.deal d on d.dealid = p.deal_dealid
		where p.isdeleted <> 1 
	)b where rno = 1

)mp on mp.credealid = d.credealid

left join(
	Select Distinct dealid,credealid,
	(CASE WHEN (Select COUNT(city) FROM (SELECT city FROM cre.Property  WHERE isdeleted <> 1 and dealid= b.dealid and city is not null GROUP BY city )a) = 1
	THEN (SELECT DISTINCT city FROM cre.Property  WHERE dealid= b.dealid and city is not null)
	ELSE 'Various'
	END) as havingnull_City	,
	(CASE WHEN (Select COUNT(pState) FROM (SELECT pState FROM cre.Property  WHERE isdeleted <> 1 and dealid= b.dealid and pState is not null GROUP BY pState )a) = 1
	THEN (SELECT DISTINCT pState FROM cre.Property  WHERE dealid= b.dealid and pState is not null)
	ELSE 'Various'
	END) as havingnull_State
	From(
		Select Distinct d.dealid,d.credealid,p.city,p.PState,Allocation,(city + ', ' +PState) as [M61_location],
		ROW_NUMBER() Over(Partition by credealid order by credealid,PropertyRollUpSW desc,Allocation desc) as rno,
		BSPropertyID,PropertyRollUpSW
		from cre.Property p
		inner join cre.deal d on d.dealid = p.deal_dealid
		where p.isdeleted <> 1 and d.isdeleted <> 1 and d.status = 323
	)b where rno = 1 and city is null
)tblPCitynull on tblPCitynull.credealid = d.credealid



--Left Join(
--	Select  dealid,dm.DealTypeName,d.PropertyTypeBS 
--	from cre.deal d
--	left join cre.DealTypeMaster dm on dm.DealTypeMasterID = d.DealTypeMasterID
--)tblDealItem on tblDealItem.dealid = d.dealid


--Left Join(
--	Select n.noteid,n.crenoteid,LValueTypeID.FeeTypeNameText,pafs.Value,pafs.Feename,
--	SUBSTRING(pafs.Feename, PATINDEX('%[0-9]%', pafs.Feename), LEN(pafs.Feename)) as NumericValue
--	from [CORE].PrepayAndAdditionalFeeSchedule pafs  
--	INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId 
--	LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID 
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--	INNER JOIN(          
--		Select   
--		 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--		 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--		 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--		 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--		 where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')  
--		 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)      
--		 and acc.IsDeleted = 0  
--		 GROUP BY n.Account_AccountID,EventTypeID  
--	  ) sEvent  
--	  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--	where e.StatusID = 1 
--	and LValueTypeID.FeeTypeNameText like '%Extension%'
--)tblExten on tblExten.noteid = n.noteid

where acc.isdeleted <> 1 and d.isdeleted <> 1
GO


