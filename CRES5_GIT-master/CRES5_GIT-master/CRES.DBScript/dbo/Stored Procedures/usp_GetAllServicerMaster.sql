
CREATE PROCEDURE [dbo].[usp_GetAllServicerMaster]
	
AS
BEGIN
	SET NOCOUNT ON;

   SELECT [ServicerMasterID]
      ,[ServicerName]
      ,[Staus]
      ,[ServicerDisplayName]
      ,[ServicerNamecss]
	  ,(SELECT ISNULL(MAX(EndDate),'1/1/2014') FROM [Core].[Period] where AnalysisID=(select AnalysisID from core.Analysis where Name='Default') and IsDeleted
=0)EndDate
	  ,ServicerFile
	  ,DownloadDisplayName
  FROM [CRE].[ServicerMaster]
  where Staus=1

END


