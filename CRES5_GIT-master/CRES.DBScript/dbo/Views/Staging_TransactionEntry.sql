CREATE View [dbo].[Staging_TransactionEntry]  
as   
select   
NoteID as NoteKey,  
CRENoteID as NoteID,  
Date = Case when Type = 'InterestPaid' and Date = '10/8/2018' Then '10/05/2018'
			when Type = 'InterestPaid' and Date = '10/10/2022' Then '10/07/2022'
		else T.Date end  ,
Amount,  
Type,  
CreatedBy,  
CreatedDate,  
UpdatedBy,  
UpdatedDate,
AnalysisID

--Case WHEN Type = 'OriginationFee' THEN 'OriginationFeeIncludedInLevelYield' ELSE Type  End as Type  
From [DW].[Staging_TransactionEntry]  T
  
