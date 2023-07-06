CREATE View [dbo].StagingInterest
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
From [DW].[Staging_TransactionEntry] T

where Type = 'InterestPaid' 
