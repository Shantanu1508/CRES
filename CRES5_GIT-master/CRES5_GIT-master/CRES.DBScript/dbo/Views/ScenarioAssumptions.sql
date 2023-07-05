-- View
-- View
CREATE View [dbo].[ScenarioAssumptions]
As

Select 
Name
,ExcludedForcastedPrePayment= Case when ExcludedForcastedPrePayment = 4 Then 'N' else 'Y' end 
, UseActuals = Case when UseActuals = 4 Then 'N' else 'Y' end 
from [Core].[BatchCalculationMaster] B
inner join  (Select MAX(Endtime)Endtime from  [Core].[BatchCalculationMaster] 
			
			) X
		on X.endtime = B.Endtime
Inner join [Core].[Analysis] A on A.Analysisid = B.Analysisid
Inner join  [Core].[AnalysisParameter] Ap on B.Analysisid = AP.analysisid