

CREATE Procedure [dbo].[usp_GetTagMaster]
	@UserID NVarchar(255),
	@AnalysisID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;


	SELECT tm.[TagMasterID]
		  ,tm.[TagName]
		  ,tm.[TagDesc]
		  ,tm.[CreatedBy]
		  ,tm.[CreatedDate]
		  ,tm.[UpdatedBy]
		  ,tm.[UpdatedDate]
		  ,u.FirstName +' '+u.LastName as FullName
		  ,tm.AnalysisID
		  ,a.Name as AnalysisName
		  ,l.Name as StatusText
		  ,tm.TagFileName
		  ,tm.TagName + '_' + replace(convert(varchar, getdate(), 8),':','') + '.csv' as NewTagFileName
	  FROM [CRE].[TagMaster] tm
	  left join app.[user] u on u.UserID = tm.CreatedBy
	  left join core.Analysis a on a.AnalysisID = tm.AnalysisID
	  left join core.Lookup l on l.LookupID=tm.StatusID
	  Where ISNULL(tm.IsDeleted,0) <> 1
	  order by tm.[CreatedDate] desc

END
