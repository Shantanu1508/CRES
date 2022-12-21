Create View [dbo].[RealizeLoanExcelAndM61]
AS
Select DealID,Dealame,NoteID,NoteName,Date,Value,ValueType,ExcelTranType,Source
from(
	Select [Deal ID] as DealID,[Deal Name] as Dealame,NoteID,NoteName,Date,Value
	,(CASE WHEN ValueType = 'Yield Maintenance' THEN 'PrepaymentFeeExcludedFromLevelYield'
		WHEN ValueType = 'Unused Fee' THEN 'UnusedFeeExcludedFromLevelYield'
		WHEN ValueType = 'Acore Fee' THEN 'AcoreOriginationFeeExcludedFromLevelYield'
		WHEN ValueType = 'Mgmt Fee' THEN 'ManagementFee'
		WHEN ValueType = 'AdditionalFeeExcludedFromLevelYield' THEN 'AdditionalFeesExcludedFromLevelYield'    
		WHEN ValueType = 'AdditionalFeeStripReceivable' THEN 'AdditionalFeesStripReceivable'  
		ELSE ValueType END) as ValueType
	,ValueType as ExcelTranType
	,'Excel' as [Source]
	from [dbo].[RealizedCashFlow_IG$] --where noteid = '4346'

	UNION ALL
	
	Select CREDealID as DealID,DealName,CRENoteID as NoteID,NoteName as NoteName,Date,Amount,[Type] as ValueType,null as ExcelType,'M61' as [Source]
	from  [DW].[TransactionEntryBI_Realized]	--where crenoteid = '4346'
)a
--Order by Dealame,NoteID,Date,ValueType