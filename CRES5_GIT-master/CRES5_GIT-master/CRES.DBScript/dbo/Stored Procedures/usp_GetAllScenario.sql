


CREATE PROCEDURE [dbo].[usp_GetAllScenario]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 
   SELECT @TotalCount = COUNT(AnalysisID) FROM  Core.Analysis;
     
		 select 
       a.[AnalysisID]
      ,a.[Name]
      ,a.[StatusID]
      ,a.[Description]
      ,a.[CreatedBy]
      ,a.[CreatedDate]
      ,a.[UpdatedBy]
      ,a.[UpdatedDate]
	  ,l1.Name as StatusIDtext
	  ,ap.JsonTemplateMasterID
	  ,jt.TemplateName as TemplateName
from Core.Analysis a
	left join Core.AnalysisParameter ap on a.AnalysisID = ap.AnalysisID
   LEFT Join Core.Lookup l1 on a.StatusID=l1.LookupID
  LEFT Join [CRE].[JsonTemplateMaster] jt on ap.JsonTemplateMasterID=jt.JsonTemplateMasterID
  where isnull(a.isDeleted,0)=0
    --ORDER BY a.UpdatedDate DESC
	ORDER BY CASE WHEN a.[Name] = 'Default' THEN 'a'
	ELSE a.[Name] END ASC
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END      


