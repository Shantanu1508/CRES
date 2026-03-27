  
CREATE VIEW [dbo].[WF_Investor] AS  

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

	(Select cf.AllInCouponRate * 100 from cre.NotePeriodicCalc cf 
	Inner join core.account acc on acc.accountid = cf.AccountID
    Inner join cre.note nn on nn.account_accountid = acc.accountid    
	where cf.AccountID  = n.Account_AccountID and acc.AccounttypeID = 1 
	and cf.PeriodEndDate = EOMonth(DateAdd(Month,-1,n.InitialInterestAccrualEndDate))) as NetYield,

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



