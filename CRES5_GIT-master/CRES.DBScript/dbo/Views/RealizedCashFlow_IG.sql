

CREATE View [dbo].[RealizedCashFlow_IG]    
as 
Select NoteID,
NoteName,
Date,
SUM(Value) [Value],
--ValueType,
TransactionTypeBI,
DealID,
DelaName,
--Comments,
Client,
(noteid+'_'+ TransactionTypeBI + '_' + CONVERT (VARCHAR(10),Date, 110)  ) Note_Type_Date ,
NoteID_Date_Scenario,
NoteID_Date,
DAY(Date) Day_Part

From(
	Select 
	NoteID
	,NoteName
	,[Date]
	,value = case when valuetype = 'Acore Fee' then [Value]*-1 else value end 
	,ValueType
	,(CASE WHEN TransactionTypeBI like 'AdditionalFee%' THEN 'AdditionalFee'
	 WHEN TransactionTypeBI like 'OriginationFee%' THEN 'OriginationFee'
	 WHEN TransactionTypeBI like 'ExitFee%' THEN 'ExitFee'
	ELSE TransactionTypeBI END)TransactionTypeBI
	,DealID
	,DelaName
	,Comments
	,Client
	,Note_Type_Date
	,NoteID_Date_Scenario
	,NoteID_Date
	From(

		Select NoteID	
		,NoteName	
		,Date	
		,Value	
		,ValueType	
		,(CASE WHEN ValueType = 'Yield Maintenance' THEN 'PrepaymentFeeExcludedFromLevelYield'
		WHEN ValueType = 'Unused Fee' THEN 'UnusedFeeExcludedFromLevelYield'
		WHEN ValueType = 'Acore Fee' THEN 'AcoreOriginationFeeExcludedFromLevelYield'
		WHEN ValueType = 'Mgmt Fee' THEN 'ManagementFee'
		WHEN ValueType = 'AdditionalFeeExcludedFromLevelYield' THEN 'AdditionalFeesExcludedFromLevelYield'    
		WHEN ValueType = 'AdditionalFeeStripReceivable' THEN 'AdditionalFeesStripReceivable'  
		ELSE  ValueType END) as TransactionTypeBI

		,[Deal ID] as DealID	
		,[Deal Name] as DelaName
		,Comments	
		,Client 
		,(noteid+'_'+ ValueType + '_' + CONVERT (VARCHAR(10),Date, 110)  ) Note_Type_Date    
		,(noteid+'_'+CONVERT (VARCHAR(10),Date, 110) + 'Default')   NoteID_Date_Scenario
		,noteid+'_'+CONVERT (VARCHAR(10),Date, 110)  NoteID_Date
		from dbo.RealizedCashFlow_IG$

	)a

	)b
	group by NoteID,
NoteName,
Date,

--ValueType,
TransactionTypeBI,
DealID,
DelaName,
--Comments,
Client,
--Note_Type_Date,
NoteID_Date_Scenario,
NoteID_Date

