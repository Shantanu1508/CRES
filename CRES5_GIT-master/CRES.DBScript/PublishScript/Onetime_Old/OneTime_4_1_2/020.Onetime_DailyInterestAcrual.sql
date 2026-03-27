Select * into dbo.DailyInterestAccruals_07212023
from cre.DailyInterestAccruals where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

 go

Truncate table cre.DailyInterestAccruals

 go


INSERT INTO cre.DailyInterestAccruals(
[NoteID]                    
,[Date]                      
,[DailyInterestAccrual]      
,[AnalysisID]                
,[CreatedBy]                 
,[CreatedDate]               
,[UpdatedBy]                 
,[UpdatedDate]               
,[EndingBalance]  
)
SELECT [NoteID]                    
,[Date]                      
,[DailyInterestAccrual]      
,[AnalysisID]                
,[CreatedBy]                 
,[CreatedDate]               
,[UpdatedBy]                 
,[UpdatedDate]               
,[EndingBalance]  FROM dbo.DailyInterestAccruals_07212023

 go

 Drop table dbo.DailyInterestAccruals_07212023

 go


 Truncate table [DW].[DailyInterestAccrualsBI]

INSERT INTO [DW].[DailyInterestAccrualsBI]
([DailyInterestAccrualsID]
,[DailyInterestAccrualsGUID]
,[NoteID]
,[Date]
,[DailyInterestAccrual]
,[AnalysisID]
,[CRENoteID]
,[AnalysisName]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])
Select
te.[DailyInterestAccrualsID]
,te.[DailyInterestAccrualsGUID]
,te.[NoteID]
,te.[Date]
,te.[DailyInterestAccrual]
,te.[AnalysisID]
,n.[CRENoteID]
,an.name [AnalysisName]
,te.[CreatedBy]
,te.[CreatedDate]
,te.[UpdatedBy]
,te.[UpdatedDate]
From cre.DailyInterestAccruals te
inner join cre.note n on n.noteid = te.noteid
inner join core.Account acc on acc.AccountID = n.Account_AccountID
left join core.Analysis an on an.AnalysisID = te.AnalysisID
WHERE acc.IsDeleted <> 1