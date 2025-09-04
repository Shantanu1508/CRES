--[usp_GetReportFileByGUID] 'A2ED63E8-3AB8-444A-8097-057CFC950865','96C3A0CD-1E96-48EE-BDB6-7D229BB2CD25'  
CREATE PROCEDURE [dbo].[usp_GetReportFileByGUID]   
(  
@ReportFileGUID UNIQUEIDENTIFIER,  
@UserID UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
 DECLARE @ReportFileID int  
 SELECT @ReportFileID =ReportFileID FROM [App].[ReportFile] WHERE [ReportFileGUID]=@ReportFileGUID  
  
SELECT r.[ReportFileID]  
    ,[ReportFileGUID]  
      ,[ReportFileName]  
   --,rs.[SheetName]  
   --   ,rs.[DataSourceProcedure]  
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
   ,[DownloadFileName]  
   FROM [App].[ReportFile] r   
  --join [App].[ReportFileSheet] rs on r.[ReportFileID] = rs.[ReportFileID]  
  WHERE r.ReportFileID =@ReportFileID  
  
  --get reportsheet detail  
  select ReportFileSheetID,ReportFileID,SheetName,DataSourceProcedure,HeaderPosition,IsIncludeHeader,AdditionalParameters  
  FROM app.reportfilesheet   
  WHERE ReportFileID = @ReportFileID  
  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
   
END







