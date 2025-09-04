print('update scenario/Note new column')
go
update [Core].[AnalysisParameter] set [CalculationFrequency]  = 793
go
update CRE.NOTE set PIKCalculationRuleForPaydowns = InterestCalculationRuleForPaydowns
go
update CRE.NOTE set PIKCalculationRuleForPaydownsAmort = InterestCalculationRuleForPaydownsAmort
go
update [Core].[AnalysisParameter] set [CalcEngineType]  = 797
go
update [Core].[CalculationRequests] set [CalcEngineType]  = 797