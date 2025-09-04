CREATE PROCEDURE [dbo].[usp_GetIndexesMasterDetailByIndexesMaster]  --'538910c2-7f90-42e1-b2b6-aba5c2481aea'
    @IndexesMasterGuid UNIQUEIDENTIFIER,
	@UserID VARCHAR(5000)
AS

 BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT distinct im.IndexesMasterID,
im.IndexesMasterGuid,	
im.IndexesName	,
im.[Description],
im.CreatedBy,
im.CreatedDate,
im.UpdatedBy,
im.UpdatedDate,
lIndex.[LookupID] as 'Status',
lIndex.[Name] as 'StatusText',
CASE WHEN AP.IndexScenarioOverride IS NULL THEN 0 ELSE 1 END as 'IsAssignedToScenario', 
    STUFF(
        (
            SELECT ', ' + A1.[Name] AS [text()]
            FROM core.Analysis A1
			left join core.AnalysisParameter AP1 on A1.AnalysisID = AP1.AnalysisID
			left join core.IndexesMaster im1 on im1.IndexesMasterID = AP1.IndexScenarioOverride
			where im1.IndexesMasterGuid = im.IndexesMasterGuid
            ORDER BY A1.[Name]
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(max)'), 1, 1, '') [ScenarioList]
FROM core.IndexesMaster im
left join core.Lookup lIndex on lIndex.LookupID = im.[Status]
left join core.AnalysisParameter AP on im.IndexesMasterID = AP.IndexScenarioOverride
left join core.Analysis A on A.AnalysisID = AP.AnalysisID AND A.isDeleted=0
WHERE im.IndexesMasterGuid = @IndexesMasterGuid;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
 
END
