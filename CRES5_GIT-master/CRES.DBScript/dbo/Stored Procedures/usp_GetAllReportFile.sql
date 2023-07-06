CREATE PROCEDURE [dbo].[usp_GetAllReportFile] 
(
@UserID UNIQUEIDENTIFIER,
@PgeIndex INT,
@PageSize INT,
@TotalCount INT OUTPUT 
)
AS
BEGIN
    SET NOCOUNT ON;
	SELECT @TotalCount = COUNT(1) FROM [App].[ReportFile];

SELECT [ReportFileID]
	   ,[ReportFileGUID]
      ,[ReportFileName]
      ,[ReportFileFormat]
      ,[ReportFileTemplate]
      ,[ReportFileJSON]
      --,[HeaderPosition]
      ,[SourceStorageTypeID]
      ,[SourceStorageLocation]
      ,[DestinationStorageTypeID]
      ,[DestinationStorageLocation]
      ,[Status]
      ,[Frequency]
      ,[FrequencyStatus]
	  ,[DocumentStorageID]
	 --,(select STUFF((Select Distinct  '|'  + cast(ReportFileSheetID as varchar)+','+SheetName+','+DefaultAttributes 
		--		from app.ReportFileSheet
		--		where reportFileID=4 and DefaultAttributes is not null
		--		FOR XML PATH('') ), 1, 1, ''
		--) ) ReportFileAttributes
	  ,DefaultAttributes
	  ,IsAllowInput

  FROM [App].[ReportFile] rf
  WHERE rf.[Status]=1
  ORDER BY ReportFileName
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
END








