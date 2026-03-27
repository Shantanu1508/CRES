CREATE view DailyBalDefault
as
Select * from [CRE].[DailyInterestAccruals] di
Where di.AnalysisID= 'c10f3372-0fc2-4861-a9f5-148f1f80804f'