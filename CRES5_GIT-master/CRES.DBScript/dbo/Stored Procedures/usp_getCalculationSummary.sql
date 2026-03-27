CREATE PROCEDURE [dbo].[usp_GetCalculationSummary]    
AS    
BEGIN    
	SELECT    
	ScenarioName,    
	ISNULL(Running,0) as Running,    
	ISNULL(Processing, 0) as Processing,    
	ISNULL(Failed,0) as Failed,    
	ISNULL(Completed,0) as Completed    ,
	ISNULL(Dependents,0) as Dependents    ,
	ISNULL(Pause,0) + 	ISNULL(Pause_Dependents,0) as Pause    ,
	  
	ISNULL(Running, 0) + ISNULL(Processing, 0) + ISNULL(Failed, 0) + 
        ISNULL(Completed, 0) + ISNULL(Dependents, 0) + ISNULL(Pause, 0) + ISNULL(Pause_Dependents, 0) AS Total
	FROM (    
		SELECT    
		a.Name AS ScenarioName,
            CASE
                WHEN l.Name IN ('Processing', 'CalcSubmit', 'SaveDBPending','Dependents') THEN 'Processing'
                ELSE l.Name
            END AS StatusName,
            COUNT(cr.accountid) AS cnt   
		FROM  Core.Analysis a    
		LEFT JOIN  Core.CalculationRequests cr ON a.AnalysisID = cr.AnalysisID    
		LEFT JOIN   Core.Lookup l ON l.LookupID = cr.StatusID 
		LEFT JOIN   Core.Lookup lScenario on lScenario.LookupID = a.ScenarioStatus 
		WHERE lScenario.[Name]='Active'
		and a.isDeleted <> 1
		 GROUP BY a.Name, CASE
            WHEN l.Name IN ('Processing', 'CalcSubmit', 'SaveDBPending','Dependents') THEN 'Processing'
            ELSE l.Name
        END

		UNION 

		SELECT a.Name AS ScenarioName,'Pause' As StatusName, COUNT(cr.Noteid) AS cnt   
		FROM  Core.Analysis a    
		LEFT JOIN [CORE].[CalculationRequests_Hold] cr ON a.AnalysisID = cr.AnalysisID    
		LEFT JOIN   Core.Lookup lScenario on lScenario.LookupID = a.ScenarioStatus 
		WHERE lScenario.[Name]='Active'
		and a.isDeleted <> 1
		GROUP BY a.Name
	) AS SourceData    
	PIVOT (    
		SUM(cnt)
		FOR StatusName IN (Running, Processing, Failed, Completed, Dependents, [Pause],Pause_Dependents)    
	) AS PivotTable    
    ORDER BY Processing desc,Running desc
END; 