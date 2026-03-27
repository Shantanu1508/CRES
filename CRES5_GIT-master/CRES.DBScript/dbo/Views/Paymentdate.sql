-- View
-- View
CREATE View [dbo].[Paymentdate]
As

Select N.Noteid, CreNoteid, N.Dealid, Date, InitialInterestAccrualEndDate, FirstPaymentDate
,crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110) NoteID_Date
, Includeservicingpaymentoverrideinlevelyield
, DealName,
[DeterminationDateLeadDays],[FirstRateIndexResetDate],[InitialIndexValueOverride],[DeterminationDateReferenceDayoftheMonth]
, MaturityDateBI =  (Case WHEN  ActualPayoffDate is not null and ActualPayoffDate< getdate() THEn ActualPayoffDate
						When ActualPayoffDate is not null and ActualPayoffDate>= Getdate() THEN ActualPayoffDate
						WHEN ActualPayoffDate is NULL Then (Case when ExtendedMaturityScenario1 >= Getdate()  THEN  ExtendedMaturityScenario1
																WHen ExtendedMaturityScenario2  >= Getdate()  THEN  ExtendedMaturityScenario2
																WHen ExtendedMaturityScenario3  >= Getdate()  THEN  ExtendedMaturityScenario3
																Else FullyExtendedMaturityDate End)
						end)
 from [CRE].[TransactionEntry] T
Inner Join Cre.Note N on N.Account_accountid = T.accountid
Inner join cre.deal D on D.DealID = N.DealID
Where [Type] = 'InterestPaid' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

--Group By Crenoteid, N.Noteid, Date, DealID, InitialInterestAccrualEndDate, FirstPaymentDate




