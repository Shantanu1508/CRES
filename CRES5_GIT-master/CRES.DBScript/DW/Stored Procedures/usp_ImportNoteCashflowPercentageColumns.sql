CREATE PROCEDURE [DW].[usp_ImportNoteCashflowPercentageColumns]	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

Truncate table [DW].[NoteCashflowPercentageColumns]

INSERT INTO [DW].[NoteCashflowPercentageColumns](
analysisID	
,Noteid	
,date_dt	
,LIBORPercentage	
,PIKInterestPercentage	
,SpreadPercentage	
,PIKLiborPercentage	
,RawIndexPercentage	
,RawPIKIndexPercentage
,EffectiveRate
)

Select analysisID,Noteid,date_dt,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage,EffectiveRate
from(    
	select te.analysisID,    
	n.Noteid,    
	te.AllInCouponRate as EffectiveRate,
	te.[Date] date_dt ,    
	te.Amount,    
	te.[Type] ValueType    
	from [cre].[TransactionEntry] te  
	Inner join cre.note n on n.Account_AccountID = te.AccountId
	where  te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')  
	--and te.AnalysisID = 'c10f3372-0fc2-4861-a9f5-148f1f80804f'   
)a    
PIVOT (    
	SUM(Amount)    
	FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)  
) pvt     



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END