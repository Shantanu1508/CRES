
CREATE PROCEDURE [dbo].[usp_GetTagFileNameForAzureUpload] 

AS
BEGIN
    SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @StatusActive int

select @StatusActive = Lookupid from core.Lookup where Name='Active' and ParentID=1
SELECT [TagMasterID]
      ,[TagName]
      ,[TagDesc]
	  ,TagName +'_' + replace(convert(varchar, getdate(), 8),':','') + '.csv' as TagFileName,
       t.[CreatedBy]
      ,t.[CreatedDate]
      ,t.[UpdatedBy]
      ,t.[UpdatedDate]
      ,t.[AnalysisID]
	  ,an.Name as AnalysisName
      ,t.[StatusID]
      ,[PeriodID]
      ,t.[IsDeleted]
      
  FROM [CRE].[TagMaster] t
  left join core.Analysis an
  on t.AnalysisID=an.AnalysisID
  WHERE TagFileName is null and t.IsDeleted=0 and t.StatusID=@StatusActive

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
END







