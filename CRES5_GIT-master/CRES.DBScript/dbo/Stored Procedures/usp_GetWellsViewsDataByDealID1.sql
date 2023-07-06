
CREATE Procedure [dbo].[usp_GetWellsViewsDataByDealID1] --'17-54321'
@CREDealID nvarchar(255)

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


--IF(@ViewName = 'Master')
BEGIN
	Select VendorLoanNumber,ISNULL(Companyname,'') as Companyname,ISNULL(FirstName,'') as FirstName,ISNULL(Lastname,'') as Lastname,EntityType,IncludeinSearch,StreenNo,ISNULL(StreetName,'') as StreetName,ISNULL(City,'') as City,ISNULL(State,'') as State,County,ZipCodePostal,ISNULL(PayeeName,'') as PayeeName,ISNULL(TelephoneNumber1,'') as TelephoneNumber1,1098YN,Salutation,Language,FedIDVerified,ISNULL(FederalID1,'') as FederalID1,CIFNumber,NegAmTaxBasis,IOEWithheld,USCitizen,AccrualStartDate,ISNULL(PaymentType,'') as PaymentType,ContractType,FirstPaymentDate,DueDateForDelinquency,SimpleInterest,ISNULL(LoanInProcess,'') as LoanInProcess ,InterestRate,AnnuallPercentageRate,NegAmPerAllowed,SubSidy,ModPmtSched,PmtAppString,PartialPayments,PandIconstant,TaxEscrowConstant,InsEscrowConstant,Escrow3Constant,FHAPMIConstant,Escrow5Constant,FirstBillingDate,BillPaymentFreq,BillingCycleMethod,PrintBills,PrintNotices,PrintStatements,MaturityDate,InitialMaturityDate,ReviewDate,CallDate,BillinFullMat,IntCompoundedFreq,AmountOfDisbursement,TaxEscrowBal,InsEscrowBal,Escrow3Balance,FHAPMIBalance,OddDaysIntAmount,OddDaysIntMethod,NegetiveAmortBal,GLMatrix,OrigPrinBalOrLOC,TermOfLoan,OriginalLoantoValue,OriginalLoanDate,ISNULL(InterestBasisCode,'') as InterestBasisCode,AcctualBasisMethod,ISNULL(CollectTaxEscrow,'') as CollectTaxEscrow,ISNULL(CollectInsEscrow,'') as CollectInsEscrow,NextEscAnalysisDate,EscrowAnalysisFreq,PayIntOnEscrow,IntonEscrowPlanCode,AcessLateCharge,BusinessCalendar,UseBusinessCalendarforDueDate,ISNULL(BusinessCalendarOptions,'') as BusinessCalendarOptions,NoDaysbeforeAssessment,LateChargeMethodCode,LateChargeRateorFee,DefaultIndicator,DefaultStatus,DefaultRate,DefaultRateAtMaturity,DefaultBalUsedAccCode,DefaultThroughDate,DefaultHoldCodeDays,DefaultOldestRecieveable,DefaultOfDaystoDefault,DialType,OfficerCode,Broker,Assessor,Source,Processor,PropertyType,LoanPurposeCode,EmployeeRelationship,LoanType,LoanClassCode,InvestorSoldLoan,BranchOffice,Servicer,CostCenter,CurrencyCode,MBSLoan,OutofDebtPeriodReq,BalloonLoan,BalloonNoticeType,BalloonAmortizeToDate,BalloonBillBalloon,BalloonPrintNotice,BalloonNoticePrtDate,BalloonRecStatusCode,EmployeeID,CreditBureauStatcode,CBPIPayoffDisposition,BorrowingType,NoteType,HoldCode1,HoldCode2,HoldCode3,GLCompany,WrapCode,LoanStatus1,LoanStatus2,LockboxLocCode,MarketValue,MarketRegion,MarketType,CrossRefFieldA,CrossRefFieldB,CrossRefFieldC,CrossRefFieldD,CrossRefFieldE,SubServicerFeeRate,AutoBasisChange,UseBusCalforLC,AcrfollowsBusCal,NextPMTDueWoBusCal,PmtFreqInd,Warehoused,CorrespondentIBC,NAICSCode 
	from 
	(
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
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   and e.StatusID = 1
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

		where d.credealid in (@CREDealID)
	)a	
	order by a.VendorLoanNumber
END

--IF(@ViewName = 'Investor')
BEGIN
	Select VendorLoanNumber,InvestorSeq,InvestorNumber,ProgramID,GroupPool,InvestorLoan,InvestorforEsrow,Participation,Notneeded,CurrentPrincipalBalance,NetYield,NetYieldMethod,ServiceFeeRate,GuaranteeFeeMth,GuaranteeFeeRate,ActiveReporting,NextCutoffDate,LastCutoffDate,SettlementDate,IntPurchaseDate,BalanceDate,IntAdjMthdforCurtailments,RIScheduledPrincipal,RIScheduledInterest,RIScheduledTaxEscrow,RIScheduledInsEscrow,RIScheduledReserves,RemitFHAPA,RIMisc,RIScheduledLateChrg,GroupReport,RIMisc1,PrincipalBalanceLastrpt,PrincipalRepurchase,LoanStatusLastRep,LoanStatusPriorRep,MethodDorM,Frequency,ARMFormulaCode
	from 
	(
		Select VendorLoanNumber,InvestorSeq,InvestorNumber,ProgramID,GroupPool,InvestorLoan,InvestorforEsrow,Participation,Notneeded,CurrentPrincipalBalance,NetYield,NetYieldMethod,
		(Select top 1 FeePct from CRE.ServicingFeeSchedule where ROUND(MinimumBalance,5) <= ROUND(a.CurrentPrincipalBalance,5) and 	ROUND(MaximumBalance,5) >= ROUND(a.CurrentPrincipalBalance,5)) * 100 as ServiceFeeRate,
		GuaranteeFeeMth,GuaranteeFeeRate,ActiveReporting,NextCutoffDate,LastCutoffDate,SettlementDate,IntPurchaseDate,BalanceDate,IntAdjMthdforCurtailments,RIScheduledPrincipal,RIScheduledInterest,
		RIScheduledTaxEscrow,RIScheduledInsEscrow,RIScheduledReserves,RemitFHAPA,RIMisc,RIScheduledLateChrg,GroupReport,RIMisc1,PrincipalBalanceLastrpt,PrincipalRepurchase,LoanStatusLastRep,
		LoanStatusPriorRep,MethodDorM,Frequency,ARMFormulaCode,CreDealID,dealname,CRENoteID 
		FROM(

		select
		n.TaxVendorLoanNumber as VendorLoanNumber,
		1 as InvestorSeq,
		InvMap.WellsInvestorID  as InvestorNumber,
		'D2' as ProgramID,
		'000000001' as GroupPool,
		n.crenoteid as InvestorLoan,
		InvMap.WellsInvestorID as InvestorforEsrow,
		'100' as Participation,
		'' as Notneeded,

		InitialFundingAmount as CurrentPrincipalBalance,
		--(Select np.EndingBalance from cre.NotePeriodicCalc np where np.noteid = n.noteid and np.PeriodEndDate = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)) as CurrentPrincipalBalance,

		(Select cf.AllInCouponRate * 100 from cre.NotePeriodicCalc cf where cf.noteid  = n.noteid and cf.PeriodEndDate = EOMonth(DateAdd(Month,-1,n.InitialInterestAccrualEndDate))) as NetYield,

		'L' as NetYieldMethod,
		'' as ServiceFeeRate,
		'' as GuaranteeFeeMth,
		'' as GuaranteeFeeRate,
		'Y' as ActiveReporting,

		CAST(MONTH(GETDATE())+1 as nvarchar(50))+'11'+CAST(YEAR(GETDATE()) as nvarchar(50)) as NextCutoffDate,
		CAST(MONTH(GETDATE()) as nvarchar(50))+'11'+CAST(YEAR(GETDATE()) as nvarchar(50)) as LastCutoffDate,

		Cast(Format(n.closingdate,'MMddyyyy') as nvarchar(256)) as SettlementDate,
		Cast(Format(n.closingdate,'MMddyyyy') as nvarchar(256)) as IntPurchaseDate,
		Cast(Format(n.closingdate,'MMddyyyy') as nvarchar(256)) as BalanceDate,

		'1' as IntAdjMthdforCurtailments,

		'N' as RIScheduledPrincipal,
		'N' as RIScheduledInterest,
		'N' as RIScheduledTaxEscrow,
		'N' as RIScheduledInsEscrow,
		'N' as RIScheduledReserves,
		'N' as RemitFHAPA,
		'N' as RIMisc,
		'N' as RIScheduledLateChrg,

		'Y' as GroupReport,
		'N' as RIMisc1,
		n.InitialFundingAmount as PrincipalBalanceLastrpt,
		n.InitialFundingAmount as PrincipalRepurchase,
		'C' as LoanStatusLastRep,
		'C' as LoanStatusPriorRep,
		'M' as MethodDorM,
		acc.payfrequency as Frequency,
		'1' as ARMFormulaCode,
		CreDealID,  
		dealname, 
		n.CRENoteID as CRENoteID
 
		from cre.note n  
		inner join Core.Account acc on acc.AccountID=n.Account_AccountID  
		inner join cre.Deal d on d.DealId=n.DealId  
		left join CRE.[InvestorFinancingSourceMapping] InvMap on InvMap.clientid =n.clientid and InvMap.FinancingSourceID =n.FinancingSourceID
		)a
		where a.credealid in (@CREDealID)
	)b	
	order by VendorLoanNumber

END

--IF(@ViewName = 'Property')
BEGIN
	Select VendorLoanNumber,SequenceNumber,CollateralType,ProjectName,HOUSESTREET1,HOUSESTREET2,ISNULL(StreetName1,'') as StreetName1,StreetName2,ISNULL(VILLAGE,'') as VILLAGE,ISNULL(TownCode,'') as TownCode,County,ISNULL(StateCode,'') as StateCode,ZIPCODE,ISNULL(OwnerOccupied,'') as OwnerOccupied,ISNULL(PROPDESCCODE,'') as PROPDESCCODE,OVERALLRATING,ISNULL(CollectTaxEscrow,'') as CollectTaxEscrow,SMSA,SALESPRICE,AppraisedValueSF,AppraisedValueUN,ConstructionDate,NextInspectionDate,NumberofStories,MeasuredIn,TotalSquareFeet,TotalRentableSqFt,GroundLease,TotalNumberofUnits,NumberOfTenants,OverallCondition,VacancyFactor,CommNRA,ResdNRA,RenovationDate,ProjectNameOptional,SecuritizationID,ProspectusID,PropertyStatus,Allocation,LIENPosition,AllocofLoanatContra,ApprasialValueatContribution,ApprasialDateatContribution,LastPropContrbutionDT,NCFatContribution,AllocLoanAmount,CollectINSEscrow,DefeasedDate,PropertyDescCode2,ResdNRA1,CountryCode,CMSAProperyType
	from 
	(
		select

		n.TaxVendorLoanNumber as VendorLoanNumber,  
		ROW_NUMBER() OVER (PARTITION BY n.TaxVendorLoanNumber  ORDER BY n.TaxVendorLoanNumber) AS  SequenceNumber,
		'CRE' as CollateralType  ,  
		PropertyName as ProjectName,  
		LEFT(HOUSESTREET1,(PATINDEX('% %',HOUSESTREET1))) HOUSESTREET1, 
		'' as HOUSESTREET2, 
		SUBString(HOUSESTREET1,Charindex(' ',HOUSESTREET1) + 1,LEN(HOUSESTREET1)) as StreetName1,
		'' as StreetName2,
		VILLAGE,  
		lTownCode.Value as TownCode,

		'DEF' as County,

		p.pState as StateCode,
		LEFT(CONVERT(NVARCHAR, ZIPCODE) + '000000000', 9) as ZIPCODE,  
		OwnerOccupied,  
		lPropertyType.value1 as PROPDESCCODE,  
		'G' as OVERALLRATING  ,  
		CollectTaxEscrow,  
		'' as SMSA  ,  
		SALESPRICE,  
		'' as AppraisedValueSF  ,  
		'' as AppraisedValueUN  ,
		Cast(Format(ConstructionDate,'MMddyyyy') as nvarchar(256)) as ConstructionDate, 

		p.NextInspectionDate as NextInspectionDate  , 
  
		NumberofStories,  
		(CASE when MeasuredIn = 'Rooms' then 'S' when MeasuredIn = 'Units' then 'U' else 'M' END) as MeasuredIn,  
		TotalSquareFeet,  
		TotalRentableSqFt,  

		p.GroundLease as GroundLease,

		(CASE when MeasuredIn = 'Rooms' then 0 else TotalNumberofUnits END) TotalNumberofUnits,

		p.NumberOfTenants as NumberOfTenants  ,
		OverallCondition,
		p.VacancyFactor as VacancyFactor  ,  
		'' as CommNRA  ,  
		'' as ResdNRA  ,
		Cast(Format(RenovationDate,'MMddyyyy') as nvarchar(256)) as RenovationDate,

		ProjectName as ProjectNameOptional ,
		null as SecuritizationID ,
		null as ProspectusID ,
		null as PropertyStatus ,

		p.DealAllocationAmtPCT as Allocation ,

		1 as LIENPosition , --p.LIENPosition as LIENPosition ,

		null as AllocofLoanatContra ,
		null as ApprasialValueatContribution ,
		null as ApprasialDateatContribution ,
		null as LastPropContrbutionDT ,
		null as NCFatContribution ,
		null as AllocLoanAmount ,
		d.CollectInsEscrow as CollectINSEscrow ,
		'' as DefeasedDate ,
		lPropertyType.value1 as PropertyDescCode2 ,
		'' as ResdNRA1 ,
		(CASE when p.Country = 'USA' then 'US' ELSE p.Country END ) as CountryCode ,
		p.CMSAProperyType as CMSAProperyType ,

		CreDealID,  
		dealname, 
		n.CRENoteID as CRENoteID

		from cre.Property p 
		inner join cre.deal d on p.deal_dealid=d.dealid 
		inner join cre.note n on n.dealid =d.dealid
		left join core.lookup lPropertyType on lPropertyType.Name = d.DealPropertyType and lPropertyType.ParentID = 15
		left join CRE.[Town] lTownCode on lTownCode.Name = p.VILLAGE 
		where d.credealid in (@CREDealID)
	)a	
	order by VendorLoanNumber
END

--IF(@ViewName = 'Tax')
BEGIN	
	Select VendorLoanNumber,PROPERTYSEQ,PARCELNUMBER,TYPEOFTAX,TAXAUTHID,TAXBILLSTATUS,FREQOFDISB,NEXTDISBDATE,TAXAMTDUE,LASTBILLTYPEPAID,LASTTAXAMOUNTPAID,CURRTAXCONSTANT,TAXSERVICECODE,TaxServiceAgencyID,TAXSERVICECONTRACT,TaxServiceOrigOffice,TaxServiceContractMod,AutoBillEntry,OverrideNegetiveBal
	from 
	(
		select
		TaxVendorLoanNumber as VendorLoanNumber,  
		'1' as PROPERTYSEQ  ,  
		'' as PARCELNUMBER  ,  
		'C' as TYPEOFTAX  ,  
		'CMBS' as TAXAUTHID  ,
		TAXBILLSTATUS,  
		12 as FREQOFDISB  ,  
		'1/01/2010' as NEXTDISBDATE  ,  
		'' as TAXAMTDUE  ,  
		'FL' as LASTBILLTYPEPAID  ,  
		'' as LASTTAXAMOUNTPAID  ,  
		d.TaxEscrowConstant as CURRTAXCONSTANT,  
		4 as TAXSERVICECODE  ,  
		'' as TaxServiceAgencyID  ,  
		'' as TAXSERVICECONTRACT  ,  
		'007' as TaxServiceOrigOffice  ,  
		'' as TaxServiceContractMod  ,  
		'N' as AutoBillEntry  ,  
		'N' as OverrideNegetiveBal,
 
		CreDealID,  
		dealname, 
		n.CRENoteID as CRENoteID
  
		from cre.note n  
		inner join Core.Account acc on acc.AccountID=n.Account_AccountID  
		inner join cre.Deal d on d.DealId=n.DealId 
		where d.credealid in (@CREDealID) 
	)a	
	order by VendorLoanNumber
END

--IF(@ViewName = 'Insurance')
BEGIN
	Select VendorLoanNumber,InsuranceCompanyID,InsuranceAgentID,InsuranceType,EffectiveDate,PolicyExpRsvMature,PolicyFHACase,PropertyLocSeq,PendingLossesProcessed,DocNoticeCode,BillStatusCode,NextRemitDate,PremiumFHAAmountDue,MonthlyPayment,Numberofmonthstoremit,FreqOfDisbursement,AutoBillEntry,RollExpDate,OverNegBalance
	from 
	(
		select
		n.TaxVendorLoanNumber as VendorLoanNumber,  
		'GRO' as InsuranceCompanyID  ,  
		'GRO' as InsuranceAgentID  ,  
		'HZ' as InsuranceType,
		Cast(Format( eomonth(ClosingDate,-1) ,'MMddyyyy') as nvarchar(256)) as EffectiveDate,
		Cast(Format( eomonth(ClosingDate,-1) ,'MMddyyyy') as nvarchar(256))  as PolicyExpRsvMature, 
		'' as PolicyFHACase  ,  
		1 as PropertyLocSeq  ,  
		'' as PendingLossesProcessed  ,  
		'' as DocNoticeCode  ,   
		InsuranceBillStatusCode as BillStatusCode,
		Cast(Format( eomonth(ClosingDate,-1) ,'MMddyyyy') as nvarchar(256))  as NextRemitDate,
		'' as PremiumFHAAmountDue,

		InsEscrowConstant as MonthlyPayment,

		12 as Numberofmonthstoremit  ,  
		12 as FreqOfDisbursement  ,  
		'N' as AutoBillEntry  ,  
		'' as RollExpDate  ,  
		'N' as OverNegBalance ,

		CreDealID,  
		dealname, 
		n.CRENoteID as CRENoteID

		from cre.note n 
		inner join  cre.deal d  on n.DealID=d.DealID 
		where d.credealid in (@CREDealID)
	)a	
	order by VendorLoanNumber
END

--IF(@ViewName = 'Reserve')
BEGIN
	Select VendorLoanNumber,RESERVETYPE,ResDescOwnName,MONTHLYPAYMENTAMT,REMITIOR,IORPLANCODE,IORPRINTCHK,BANKNUMBER,DDANumber,MATURITYDATE,RATE,INVPOOLNUMBER,InvestmentS
	from 
	(
		select
		n.TaxVendorLoanNumber as VendorLoanNumber,  
		lResDescOwnName.Value as RESERVETYPE,  
		ResDescOwnName,  
		MONTHLYPAYMENTAMT,  
		'N' as REMITIOR  ,  
		IORPLANCODE,  
		'N' as IORPRINTCHK  ,  
		1 as BANKNUMBER  ,  
		'' as DDANumber  ,  
		'' as MATURITYDATE  ,  
		'' as RATE  ,  
		'' as INVPOOLNUMBER  ,  
		'' as InvestmentS  ,

		CreDealID,  
		dealname, 
		n.CRENoteID as CRENoteID

		from cre.note n  
		inner join Core.Account acc on acc.AccountID=n.Account_AccountID  
		inner join cre.Deal d on d.DealId=n.DealId  
		left join core.lookup lResDescOwnName on lResDescOwnName.name = n.ResDescOwnName  and ParentID = 76
		where d.credealid in (@CREDealID)
	)a
	order by VendorLoanNumber
END


--IF(@ViewName = 'ARM')
BEGIN
	Select VendorLoanNumber,ActualPAnDIPmtNeeded,AdjustableLoanDesc,IndexDesc,InterestRateFloor,InterestRateCeiling,RateReviewIncCap,MonthlyOrDayReview,RateChangeFreq,IndexRoundingMethod,UseLookBackFwd,MinPymtAdjAllow,OriginationInterestRate,NewInterestRate,IndexRoundingRule,PrevIntRate,NewPandIPayment,PrevPandIPayment,PrintNotice,SYSUSE,ReviewDateMDCY,RateChgDateMDCY,OptionalDateMDCY,PrintNoticeDate,MinRateAdjAll,AdjLoanMethod,RateRoundFactor,EffecPrinBalance,PAndIPmtIncrCapPer,RatFloorCeilEXPDT,PAndIPMTCapExpir,RateRoundingM,PAndIPmtAmortToDt,PrevIndex,OrigIndexDial,NewIndexPer,NewRateWOcap,ExceptionCondit,PerRateCap,Status,DiffRatePAndI,RateSchPAndI,RateRevDecrCap,PAndIPmtDecrPer,PAndIPmtIncr,PAndIPmtDecr,SystemUse,SystemUse1,BackdateRateExc,RateChgAnDate,MthodPOpr1,MthodPOpr2,MthodPMarPer1,MthodPMarPer2,IntRateMarginPer,UseBusCalREVW,UseBusCalChg,BusCalDesc,PAndIMortchgFreq,PAndIReamortfreq,Dayslookback,Noticedaysfrreview,PAndIRecastMthd,NoorPaymReviews,PAndIPmtchgdate,PAndIReamtChg,StartRate4per,RateReviews2dte,MaxNoRateRev,PAndIPayRnd,PrevReview,PAndIPayRate,EffDateofIndex,AvailNo,[SYSTEM],SYSTEM1,IntBasisCode
	from 
	(
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
		Select  ROW_NUMBER() OVER (PARTITION BY  Noteid  ORDER BY Noteid,PeriodEndDate) AS rno,Noteid,PeriodEndDate,allincouponrate from cre.noteperiodiccalc 
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

		where d.credealid in (@CREDealID)
	)a	
	order by VendorLoanNumber
END

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
End

