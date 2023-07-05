CREATE View [dbo].[StagingInterest_withoutFinalPayoffinterest]
as 
select 
t.NoteID as NoteKey,
T.CRENoteID as NoteID,
Date =  Case when T.Date = '10/8/2018'  then '10/5/2018'  
				When T.Date = '10/10/2022' then '10/7/2022'
				else T.Date end,
Amount,
--Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate, 
Case WHEN Type = 'OriginationFee' THEN 'OriginationFeeIncludedInLevelYield' ELSE Type  End as Type
, AnalysisID
From [DW].[Staging_TransactionEntry] T
outer apply (Select MAX(T1.Date) Date, T1.NoteID from [Staging_TransactionEntry] T1
				Where Type = 'InterestPaid' and T.CRENoteID =  T1.NoteID
				and T.AnalysisID =  T1.AnalysisID
				and  T.Type =  T1.Type 
				Group by T1.NoteID

				)X

			
where Type = 'InterestPaid' and T.Date < x.Date
