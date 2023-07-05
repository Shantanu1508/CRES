CREATE PROCEDURE [dbo].usp_GetFileImportMaster
AS
BEGIN
SELECT [FileImportMasterID]
      ,Replace(FileName,'{CurrentDate}','_'+format(cast(getdate() as date),'yyyyMMdd')) as [FileName]
      ,[ObjectTypeID]
      ,[SourceStorageTypeID]
      ,[SourceStorageLocation]
	  ,[HeaderPosition]
      ,[Status]
      ,[Frequency]
      ,[LastExecutionTime]
  FROM [CRE].[FileImportMaster]
  WHERE [Status]=1
END
