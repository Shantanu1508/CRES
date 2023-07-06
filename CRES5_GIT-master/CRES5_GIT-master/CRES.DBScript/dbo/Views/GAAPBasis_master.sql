-- View
-- View
CREATE View [dbo].[GAAPBasis_master]
as
With GAAPBasis as
(
Select * from

(
Select 
N.Noteid
, DealName
, Dl.DealID
--, NC.Periodenddate
--, EndingGAAPBookValue
--, CleanCost
--,  PVAmortForThePeriod as GAAPAmort
--,PVAmortTotalIncomeMethod As PVAmort
--,SLAmortForThePeriod
--,SLAmortOfTotalFeesInclInLY
--, SLAmortofCapCost
--, SLAmortofDiscountPremium
, OriginationFeeIncludedInLevelYield
, OriginationFeeStripReceivable
,B.AdditionalFeesIncludedInLevelYield
,CapitalizedClosingCost
,Discount_Premium
,Y.Name CalcStatus
, N.Pik_NonPIK
, ExtensionFeeIncludedInLevelYield
, Tobeamortized = ISNULL(OriginationFeeIncludedInLevelYield,0)
+ISNULL(B.AdditionalFeesIncludedInLevelYield,0)
+ ISNULL(Discount_Premium,0)+ ISNULL(CapitalizedClosingCost,0)
+ ISNULL(ExtensionFeeIncludedInLevelYield,0)
+ ISNULL(OriginationFeeStripping,0)
+ISNULL(ExitFeeIncludedInLevelYield,0)
+ISNULL(CouponFeeIncludedInLevelYield,0)

--, DeltaGAAPAmort = PVAmortForThePeriod- iSNULL(OriginationFeeIncludedInLevelYield,0)+ISNULL(OriginationFeeStripReceivable,0)+ISNULL(B.AdditionalFeesIncludedInLevelYield,0)+ ISNULL(Discount_Premium,0)+ ISNULL(CapitalizedClosingCost,0)
,N.StatusBI
,o.StubInterestCalc
, StubInterest
,StubIntCalc_Minus_StubInt = ISNULL(o.StubInterestCalc,0) - ISNULL(StubInterest,0)
,isPayofflessthan2017= Case When ISNULL(ActualPayoffdate, Fullyextendedmaturitydate) <'12/31/2017' then 'yes' else 'no' end
from Note N
Left join Deal Dl on Dl.Dealkey = N.dealkey

Outer apply (Select T.Noteid
					,OriginationFeeIncludedInLevelYield = Case when MAX(Type) = 'OriginationFeeIncludedInLevelYield' or Type = '' then SUM(ISNULL(Amount,0))  End
					
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('OriginationFeeIncludedInLevelYield' )
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)X

Outer apply (Select T.Noteid
				
					, OriginationFeeStripReceivable = Case when MAX(Type) = 'OriginationFeeStripReceivable' then SUM(ISNULL(Amount,0)) ENd
				
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('OriginationFeeStripReceivable')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)A

Outer apply (Select T.Noteid
					
					, AdditionalFeesIncludedInLevelYield = Case when MAX(Type) = 'AdditionalFeesIncludedInLevelYield' THEN SUM(ISNULL(Amount,0)) ENd

				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ( 'AdditionalFeesIncludedInLevelYield')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)B

Outer apply (Select T.Noteid
					
					, CapitalizedClosingCost = Case WHEN (TYPE) = 'CapitalizedClosingCost' THEN SUM(ISNULL(Amount,0)) end
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('CapitalizedClosingCost')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)C
	Outer apply (Select T.Noteid, Discount_Premium = Case WHEN (TYPE) = 'Discount/Premium' THEN SUM(ISNULL(Amount,0)) end
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in (  'Discount/Premium')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)D
	Outer apply (Select T.Noteid, OriginationFeeStripping = Case WHEN (TYPE) = 'OriginationFeeStripping' THEN SUM(ISNULL(Amount,0)) end
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in (  'OriginationFeeStripping')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)E

				
				Outer apply (Select T.Noteid, ExtensionFeeIncludedInLevelYield = Case WHEN (TYPE) = 'ExtensionFeeIncludedInLevelYield' THEN SUM(ISNULL(Amount,0)) end
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('ExtensionFeeIncludedInLevelYield')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)P
									
				Outer apply (Select T.Noteid, ExitFeeIncludedInLevelYield = Case WHEN (TYPE) = 'ExitFeeIncludedInLevelYield' THEN SUM(ISNULL(Amount,0)) end
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('ExitFeeIncludedInLevelYield')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)q
				
						Outer apply (Select T.Noteid, CouponFeeIncludedInLevelYield = Case WHEN (TYPE) = 'CouponFeeIncludedInLevelYield' THEN SUM(ISNULL(Amount,0)) end
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('CouponFeeIncludedInLevelYield')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)s

				
Outer apply (Select C.Noteid, Max(Name) Name from [dbo].[Calcuationstatus] C
				where C.Noteid = N.Noteid
				 --and c.analysisID = '1B1AFBDB-7075-48F9-B3B0-EDDD8792731A'
				Group By Noteid
				)Y
				--Where Analysisid = '1B1AFBDB-7075-48F9-B3B0-EDDD8792731A'
				--And NC.Periodenddate = EOMONTH(NC.Periodenddate,0)

			--Outer apply (Select T.Noteid, SUM(Amount) StubInterestCalc
			--	From TransactionENtry T
			--	Where T.Noteid = N.Noteid  and Type in ('StubInterestCalc')
			--	and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			--	Group by T.Noteid, T.Type
			--	)w
							
		Outer apply (Select T.Noteid, SUM(Amount) StubInterestCalc
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('StubInterestCalc')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)o

				Outer apply (Select T.Noteid, SUM(Amount) StubInterest
				From TransactionENtry T
				Where T.Noteid = N.Noteid  and Type in ('StubInterest')
				and  Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				Group by T.Noteid, T.Type
				)i

)z


)
Select * from GAAPBasis

--where Noteid = '13181'