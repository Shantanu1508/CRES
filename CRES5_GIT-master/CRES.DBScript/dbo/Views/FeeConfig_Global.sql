CREATE View
[dbo].[FeeConfig_Global]
AS
Select * from [CRE].[FeeSchedulesConfig] F
Outer Apply (Select L.Name As FeepPaymentFrequncy from core.Lookup L
			where F.FeePaymentFrequencyID =  L.LookupID) A
Outer Apply (Select Name as FeecoveragePeriod from Core.lookup L
			Where F.FeecoveragePeriodID = L.lookupid
			 
			)B

Outer apply (Select Name as Feefuction from Core.lookup L
			Where FeeFunctionID = Lookupid 

			) C
Outer apply (Select Name as TotaLCommitmentFlag from Core.lookup L
			Where TotalCommitmentID = Lookupid 
			
			)D
Outer apply (Select Name as UnscheduledPaydownFlag from Core.lookup L
			Where UnscheduledPaydownsID = Lookupid 

			)E


Outer apply (Select Name as LoanFundingsFlag from Core.lookup L
			Where F.LoanFundingsid = Lookupid

			)z
Outer apply (Select Name as Balloonpaymentflag from Core.lookup L
			Where BalloonPaymentid = Lookupid

			)G


--Outer apply (
--			Select Name as LoanFundingsFlag from Core.lookup L
--			Where LoanFundingsid = Lookupid

--			)H

Outer apply (
			Select Name as CurrentloanbalanceFlag from Core.lookup L
			Where CurrentLoanBalanceID = Lookupid

			)I


