
CREATE VIEW [dbo].[WF_Master] AS  
select

n.TaxVendorLoanNumber as VendorLoanNumber,  
d.Companyname,  
d.FirstName,  
'' as Lastname, --d.Lastname, 

null as EntityType,

'Y'  as IncludeinSearch  , 
LEFT(StreetName,(PATINDEX('% %',StreetName))) StreenNo ,
SUBString(StreetName,Charindex(' ',StreetName) + 1,LEN(StreetName)) StreetName,  
DealCityWells as City,  
DealStateWells as State,  
'DEF' as County,  
ZipCodePostal,  
PayeeName,  
TelephoneNumber1,  
'Y'  as '1098YN'  ,  
 'Dear Borrower'  as Salutation  ,  
 'E'  as Language  ,  
 'N'  as FedIDVerified  ,  
FederalID1,  
''  as CIFNumber  ,  
 'A'  as NegAmTaxBasis  ,  
 'N'  as IOEWithheld  ,  
 'Y'  as USCitizen  ,  
Cast(Format(ClosingDate,'MMddyyyy') as nvarchar(256)) as AccrualStartDate, 
 
(Case when n.IOTerm > 0 then 'I' else 'P' end) as PaymentType  ,  

 'A' as ContractType  ,
Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) FirstPaymentDate ,  

Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) as DueDateForDelinquency, 
 
 'N' as SimpleInterest  ,  

(case when tblNoteFF.IsFF > 0 then 'Y' Else 'N' end) LoanInProcess,  

tblInterestRate.allincouponrate as InterestRate,  
tblInterestRate.allincouponrate as AnnuallPercentageRate,  

 ''  as NegAmPerAllowed  ,  
 'N'  as SubSidy  ,  
 'N'  as ModPmtSched  ,  
 'v90'  as PmtAppString  ,  
 'N'  as PartialPayments  ,

(Case when n.IOTerm > 0 then 0 
when n.IOTerm = 0 then (Select SUM(tr.Amount) from cre.TransactionEntry tr where tr.[Date] = n.FirstPaymentDate and  tr.[Type] in ('InterestPaid','ScheduledPrincipalPaid') and tr.NoteID = n.NoteID) else null end ) PandIconstant,  



TaxEscrowConstant,  
InsEscrowConstant,  

 ''  as Escrow3Constant  ,  
 ''  as FHAPMIConstant  ,  
 ''  as Escrow5Constant  ,
 Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) as FirstBillingDate,  

'1' as BillPaymentFreq, 
8  as BillingCycleMethod  ,  
'N'  as PrintBills  ,  
 'N'  as PrintNotices  ,  
 'N'  as PrintStatements  , 
Cast(Format(SelectedMaturityDate,'MMddyyyy') as nvarchar(256))  as MaturityDate,

'' as InitialMaturityDate,
-- (Select TOP 1 Cast(Format(mat.[SelectedMaturityDate]  ,'MMddyyyy') as nvarchar(256))
--from [CORE].Maturity mat  
--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--INNER JOIN   
--   (  
        
--    Select   
--     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--     INNER JOIN [CORE].[Account] a ON a.AccountID = n.Account_AccountID  
--     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
--     and a.AccountID = acc.AccountID  
--     GROUP BY n.Account_AccountID,EventTypeID  
  
--   ) sEvent  
  
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  
--)InitialMaturityDate, 

 ''  as ReviewDate  ,  
 ''  as CallDate  ,  
 'Y'  as BillinFullMat  ,  
 'N'  as IntCompoundedFreq  ,  
InitialFundingAmount as AmountOfDisbursement,
''  as TaxEscrowBal  ,  
 ''  as InsEscrowBal  ,  
 ''  as Escrow3Balance  ,  
 ''  as FHAPMIBalance  , 
OddDaysIntAmount,
'B' as OddDaysIntMethod,
''  as NegetiveAmortBal  ,  
'WHSE BAL'  as GLMatrix  ,  

n.TotalCommitment as OrigPrinBalOrLOC,--FirstPeriodPrincipalPaymentOverride as  OrigPrinBalOrLOC,  

	(
			Select  TOP 1  
			RIGHT('00' + CONVERT(NVARCHAR, (DateDiff(MONTH,n.FirstPaymentDate,mat.[MaturityDate]) + (1* ISNULL(acc1.PayFrequency ,1))) / 12), 2) +  RIGHT('00' + CONVERT(NVARCHAR, (DateDiff(MONTH,n.FirstPaymentDate,mat.[MaturityDate]) + (1* ISNULL(acc1.PayFrequency ,1))) % 12), 2)
			from [CORE].Maturity mat  
			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			INNER JOIN   
			(          
				Select   
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
				INNER JOIN [CORE].[Account] a ON a.AccountID = n.Account_AccountID  
				where EventTypeID = 11  and eve.StatusID = 1
				and a.IsDeleted = 0  	
				and a.AccountID = acc.AccountID  		
				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1 
			INNER JOIN [CORE].[Account] acc1 ON acc1.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc1.AccountID 	
			where mat.maturityType = 708 
			and	mat.Approved = 3
			and acc1.AccountID = acc.AccountID  

			--Select  TOP 1  
			--RIGHT('00' + CONVERT(NVARCHAR, (DateDiff(MONTH,n.FirstPaymentDate,mat.[SelectedMaturityDate]) + (1* ISNULL(acc.PayFrequency ,1))) / 12), 2) +  RIGHT('00' + CONVERT(NVARCHAR, (DateDiff(MONTH,n.FirstPaymentDate,mat.[SelectedMaturityDate]) + (1* ISNULL(acc.PayFrequency ,1))) % 12), 2)
			--from [CORE].Maturity mat  
			--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			--INNER JOIN   
			--(         
			--	Select   
			--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			--	INNER JOIN [CORE].[Account] a ON a.AccountID = n.Account_AccountID  
			--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
			--	and a.AccountID = acc.AccountID  
			--	GROUP BY n.Account_AccountID,EventTypeID   
			--) sEvent    
			--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  
		) as TermOfLoan, 

 '0'  as OriginalLoantoValue  ,
 Cast(Format(ClosingDate ,'MMddyyyy') as nvarchar(256)) as OriginalLoanDate,
 
tblInterestBasisCode.value as InterestBasisCode,  

'A' as AcctualBasisMethod,  
CollectTaxEscrow,  
CollectInsEscrow,  

Cast(est.ANALYSISDATEINT as nvarchar(30))+'25'+Cast(Year(getdate()) +1 as nvarchar(30)) as NextEscAnalysisDate,

'12'  as EscrowAnalysisFreq  ,  
 'N'  as PayIntOnEscrow  ,  
 ''  as IntonEscrowPlanCode  ,  
 'Y'  as AcessLateCharge  ,  

'USA' as BusinessCalendar, --(Case when lDeterminationDateHolidayList.name = 'US' then 'USA' else lDeterminationDateHolidayList.name end) as BusinessCalendar,  

 'Y'  as UseBusinessCalendarforDueDate  ,  

 (Case when ISNULL(n.PaymentDateBusinessDayLag,-1) < 0 then 'B' ELSE 'F' end) as BusinessCalendarOptions ,

(Case when ISNULL(n.NoDaysbeforeAssessment,0) > 0 then n.NoDaysbeforeAssessment Else 1 end)  as NoDaysbeforeAssessment,  

'F' as LateChargeMethodCode,
(n.LateChargeRateorFee * 100) as LateChargeRateorFee,  
2 as DefaultIndicator,  
0 as DefaultStatus,  
(n.DefaultOfDaysto * 100) as DefaultRate,  

(n.DefaultOfDaysto * 100) as DefaultRateAtMaturity,  

 ''  as DefaultBalUsedAccCode  ,  
'' as DefaultThroughDate,
 ''  as DefaultHoldCodeDays  ,  
 ''  as DefaultOldestRecieveable  ,  

1 as DefaultOfDaystoDefault,   --(n.DefaultOfDaysto*100)

'0'  as DialType  ,  
 'D0'  as OfficerCode  ,  
''  as [Broker]  ,  
'SDM'  as Assessor  ,  
 'DRE'  as [Source]  ,  
 'OBJ'  as Processor ,

lPropertyType.[value] as PropertyType, 

'RE' as LoanPurposeCode,
 ''  as EmployeeRelationship  ,  
 'A'  as LoanType  ,  
 'CO'  as LoanClassCode  ,  
 'Y'  as InvestorSoldLoan  ,  
 '3P'  as BranchOffice  ,  
 'BJ'  as Servicer  ,  
 '3PHB'  as CostCenter  ,  
 'USD'  as CurrencyCode  ,  
 'N'  as MBSLoan  ,  
 'N'  as OutofDebtPeriodReq  ,  
'N' as BalloonLoan,  

''  as BalloonNoticeType  ,  
'' as BalloonAmortizeToDate,  
''  as BalloonBillBalloon  ,  
''  as BalloonPrintNotice  ,  
''  as BalloonNoticePrtDate  ,  
''  as BalloonRecStatusCode  ,  
''  as EmployeeID  ,  
''  as CreditBureauStatcode  ,  
''  as CBPIPayoffDisposition  , 


(case when tblNoteFF.IsFF > 0 then 'O' Else '' end) as BorrowingType,
 '1N' as NoteType,
  ''  as HoldCode1  ,  
 ''  as HoldCode2  ,  
 ''  as HoldCode3  , 
  
1  as GLCompany  ,  
 ''  as WrapCode  ,  
 ''  as LoanStatus1  ,  
 ''  as LoanStatus2  ,  
 '101'  as LockboxLocCode  , 
  
 ''  as MarketValue  ,  
 ''  as MarketRegion  ,  
 ''  as MarketType  ,  
 ''  as CrossRefFieldA  ,  
 ''  as CrossRefFieldB  ,  
 ''  as CrossRefFieldC  ,  
 ''  as CrossRefFieldD  ,  
 ''  as CrossRefFieldE  ,  
 ''  as SubServicerFeeRate  ,  

 'Y'  as AutoBasisChange  ,  
 'Y'  as UseBusCalforLC  ,  

 ''  as AcrfollowsBusCal  , 
  
  Cast(Format(FirstPaymentDate,'MMddyyyy') as nvarchar(256)) as NextPMTDueWoBusCal, --NextPMTDueWoBusCal as NextPmtDueWoBusCal,

 'M' as PmtFreqInd , --(CAse when acc.PayFrequency=1 then 'M' else Cast(acc.PayFrequency as nvarchar(256)) end) as PmtFreqInd,

 'N'  as Warehoused  ,  
 ''  as CorrespondentIBC  ,  
 ''  as NAICSCode  ,


 CreDealID,  
dealname, 
n.CRENoteID as CRENoteID

from cre.note n 
inner join  cre.deal d  on n.DealID=d.DealID 
left join
(
	Select * from(
	Select ROW_NUMBER() OVER (PARTITION BY  p.deal_dealid  ORDER BY p.deal_dealid) rn,p.* 
	from cre.property p
	inner  join cre.deal d on d.dealid = p.deal_dealid
	)a where a.rn = 1
)p on p.deal_dealid=d.dealid 

inner join Core.Account acc on acc.AccountID=n.Account_AccountID  
left join core.lookup lDeterminationDateHolidayList on lDeterminationDateHolidayList.lookupid = n.DeterminationDateHolidayList and lDeterminationDateHolidayList.ParentID = 17
left join core.lookup lPropertyType on lPropertyType.lookupid = p.PropertyType and lPropertyType.ParentID = 15
left join
(
	Select rno,Noteid,PeriodEndDate,(allincouponrate*100) as allincouponrate
	From(
		Select  ROW_NUMBER() OVER (PARTITION BY  Noteid  ORDER BY Noteid,PeriodEndDate) AS rno,Noteid,PeriodEndDate,allincouponrate from cre.noteperiodiccalc 
		where allincouponrate is not null
	)a
	where a.rno = 1
)tblInterestRate on tblInterestRate.NoteId= n.NoteId

left join 
(
	Select CRENoteID,noteid,Value,RNO from(
	Select nn.CRENoteID,nn.noteid,ROW_NUMBER() OVER (PARTITION BY nn.noteid  ORDER BY rs.date) AS RNO,
	rs.date,rs.IntCalcMethodID,LValueTypeID.name,LIntCalcMethodID.value
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
	and LValueTypeID.name in ('Rate','Spread')
	)a
	where a.RNO = 1
) tblInterestBasisCode on tblInterestBasisCode.NoteId= n.NoteId

left join Core.LookupEscrowAnalysisSchedulebyState est on p.pState = est.StateCode

left join (
	select n.noteid,
	(Case when
		(Select count(FF.Date) from core.FundingSchedule FF
		inner join core.Event e on e.EventID = FF.EventId
		inner join core.Account acc on acc.AccountID = e.AccountID
		where e.EventTypeID = 10 and e.StatusID = 1
		and acc.AccountID = n.account_accountid) > 0 then 1 else 0 end)IsFF
	from cre.Note n
)tblNoteFF on tblNoteFF.noteid = n.noteid


