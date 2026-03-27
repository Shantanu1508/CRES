Create PROCEDURE [dbo].[usp_GetAllServicerMasterLiability]
	
AS
BEGIN
	SET NOCOUNT ON;
 
 SELECT [ServicerMasterID]
      ,[ServicerName]
      ,[Staus]
      ,[ServicerDisplayName]
      ,[ServicerNamecss]
	  --,(SELECT ISNULL(MAX(CloseDate),'1/1/2014') FROM [Core].[Period] where AnalysisID=(select AnalysisID from core.Analysis where Name='Default') and IsDeleted=0)EndDate
	  ,'1/1/1900' as EndDate
	  ,ServicerFile
	  ,DownloadDisplayName
  FROM [CRE].[ServicerMasterLiability]
  where Staus=1
  ORDER BY ServicerMasterID

END



