  
CREATE VIEW [dbo].[WF_ARM] AS  
select

n.TaxVendorLoanNumber as VendorLoanNumber,  
'' as ActualPAnDIPmtNeeded  ,  
'IL' as AdjustableLoanDesc  ,  
'IX' as IndexDesc ,
InterestRateFloor,  
InterestRateCeiling, 
'' as RateReviewIncCap,
'M' as MonthlyOrDayReview,
1 as RateChangeFreq, --RateIndexResetFreq as RateChangeFreq,
Upper(LEFT( lRoundingMethod.name, 1 ))  as IndexRoundingMethod,
'B' as UseLookBackFwd  ,  
'' as MinPymtAdjAllow  ,

tblInterestRate.allincouponrate as OriginationInterestRate,  
tblInterestRate.allincouponrate as NewInterestRate,  

IndexRoundingRule as IndexRoundingRule ,

'' as PrevIntRate  ,  
'' as NewPandIPayment,
'' as PrevPandIPayment,
1 as PrintNotice  ,  

'' as SYSUSE  , 

Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) as ReviewDateMDCY,
Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) as RateChgDateMDCY,

'' as OptionalDateMDCY,
Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) as PrintNoticeDate,

'' as MinRateAdjAll  ,  
'A' as AdjLoanMethod  ,  

'' as RateRoundFactor  ,  
'' as EffecPrinBalance  ,  
'' as PAndIPmtIncrCapPer  ,  
'' as RatFloorCeilEXPDT  ,  
'' as PAndIPMTCapExpir  ,  
'' as RateRoundingM  ,  
'' as PAndIPmtAmortToDt  ,  
'' as PrevIndex  ,  
'' as OrigIndexDial  ,  

tblindex.Value * 100 as NewIndexPer  ,  

'' as NewRateWOcap  ,  
'' as ExceptionCondit  ,  
'' as PerRateCap  ,  
'' as Status  ,  
'' as DiffRatePAndI  ,  

'N' as RateSchPAndI  ,  
'' as RateRevDecrCap  ,  
'' as PAndIPmtDecrPer  ,  
'' as PAndIPmtIncr  ,  
'' as PAndIPmtDecr  ,  
'' as SystemUse  ,  
 '' as SystemUse1  ,  
'' as BackdateRateExc  ,  

Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256))  as RateChgAnDate  ,  --====

'' as MthodPOpr1  ,  
'' as MthodPOpr2  ,  
'' as MthodPMarPer1  ,  
'' as MthodPMarPer2  ,  

 tblnoteRate.PerValue *100 as IntRateMarginPer  ,  

'Y' as UseBusCalREVW  ,  
'N' as UseBusCalChg  ,  
'EUR' as BusCalDesc  ,  
'' as PAndIMortchgFreq  ,  
'' as PAndIReamortfreq  ,  

1 as Dayslookback  ,  
1 as Noticedaysfrreview  , 
 
'' as PAndIRecastMthd  ,  
'' as NoorPaymReviews  ,  
'' as PAndIPmtchgdate  ,  
'' as PAndIReamtChg  ,  
'' as StartRate4per  ,  
'' as RateReviews2dte  ,  
'' as MaxNoRateRev  ,  
'' as PAndIPayRnd  ,  
'' as PrevReview  ,  
'' as PAndIPayRate  ,  
'' as EffDateofIndex  ,  
'' as AvailNo  ,  
'' as SYSTEM  , 
'' as SYSTEM1  ,  
'' as IntBasisCode ,

CreDealID,  
dealname, 
n.CRENoteID as CRENoteID

from cre.note n 
inner join  cre.deal d  on n.DealID=d.DealID 
 left JOin core.lookup lRoundingMethod on lRoundingMethod.lookupid = n.RoundingMethod and lRoundingMethod.ParentID = 33
 left join
(
	Select rno,Noteid,PeriodEndDate,(allincouponrate*100) as allincouponrate
	From(
		Select  ROW_NUMBER() OVER (PARTITION BY  n.Noteid  ORDER BY n.Noteid,PeriodEndDate) AS rno,
		n.Noteid,
		PeriodEndDate,
		allincouponrate 
		from cre.noteperiodiccalc nc
		Inner Join cre.note n on n.account_accountID = nc.AccountID
	)a
	where a.rno = 1
)tblInterestRate on tblInterestRate.NoteId= n.NoteId

left join 
(
	Select CRENoteID,noteid,Value as PerValue,RNO from(
	Select nn.CRENoteID,
	nn.noteid,ROW_NUMBER() OVER (PARTITION BY nn.noteid  ORDER BY rs.date) AS RNO,
	rs.date,rs.IntCalcMethodID,LValueTypeID.name,LIntCalcMethodID.value as CalcMethodIDtext,rs.Value
	from [CORE].RateSpreadSchedule rs
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
	LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
	INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
					and acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID

			) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	left join cre.note nn on nn.Account_AccountID = e.AccountID


	where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
	and LValueTypeID.name in ('Spread')
	)a
	where a.RNO = 1
) tblnoteRate on tblnoteRate.NoteId= n.NoteId

left join 
(	
	Select Distinct [Date],AnalysisID,Value from core.indexes  where IndexType = 245 and AnalysisID = (Select AnalysisID from core.Analysis where StatusID = 3)
)tblindex on tblindex.Date = n.ClosingDate



