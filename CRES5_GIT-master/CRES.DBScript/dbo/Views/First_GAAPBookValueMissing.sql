-- View
CREATE View [dbo].[First_GAAPBookValueMissing]
As
Select n.noteid
,n.crenoteid
,n.ClosingDate
,EOMONTH(n.ClosingDate) ClosingDate_EOMONTH,

 Maturity_DateBI =  (Case WHEN  ActualPayoffDate is not null and ActualPayoffDate< getdate() THEn ActualPayoffDate
						When ActualPayoffDate is not null and ActualPayoffDate>= Getdate() THEN ActualPayoffDate
						WHEN ActualPayoffDate is NULL Then (Case when ExtendedMaturityScenario1 >= Getdate()  THEN  ExtendedMaturityScenario1
																WHen ExtendedMaturityScenario2  >= Getdate()  THEN  ExtendedMaturityScenario2
																WHen ExtendedMaturityScenario3  >= Getdate()  THEN  ExtendedMaturityScenario3
																Else FullyExtendedMaturityDate End)
						end)




,SUM(ISNULL(EndingGAAPBookValue,0)) 

as EndingGAAPBookValue

from cre.NotePeriodicCalc np
Inner join core.account acc on acc.accountid = np.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid
 
--inner join cre.note nn on nn.Account_accountid = np.accountid
where  np.periodenddate <= EOMONTH(n.ClosingDate) and acc.AccounttypeID = 1
and n.crenoteid not in ( Select Distinct CreNoteid
					from Cre.Note N
					inner JOin cre.transactionEntry tr on N.Account_Accountid = tr.Accountid


					where tr.type not in ( 'FundingOrRepayment')  and 
					Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate)))  
					and InitialFundingAmount < 1
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

					)

and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

group by n.noteid,n.crenoteid
,n.ClosingDate
, ActualPayoffDate
, ExtendedMaturityScenario1
, ExtendedMaturityScenario2
, ExtendedMaturityScenario3
, FullyExtendedMaturityDate

having SUM(ISNULL(EndingGAAPBookValue,0)) = 0


