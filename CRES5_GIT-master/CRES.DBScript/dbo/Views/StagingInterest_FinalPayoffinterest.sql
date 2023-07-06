CREATE View [dbo].[StagingInterest_FinalPayoffinterest]
as 
select 
t.NoteID as NoteKey,
T.CRENoteID as NoteID,
T.Date,
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
				and  T.Type =  T1.Type  and T1.AnalysisID =  T.AnalysisID
				Group by T1.NoteID

				)X

			
where Type = 'InterestPaid' and T.Date = x.Date
