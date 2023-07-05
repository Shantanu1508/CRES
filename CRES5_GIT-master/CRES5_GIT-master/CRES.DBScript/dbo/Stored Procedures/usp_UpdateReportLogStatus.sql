-- Procedure

CREATE PROCEDURE [dbo].[usp_UpdateReportLogStatus]
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256) ,
 @XMLUploadedDocumentLogID xml 
AS  
BEGIN  
    declare @TotalCount int = 0,@CurrCount int = 1,@Status int,@UploadedDocumentLogID nvarchar(256)
  
	SELECT @TotalCount = count(Pers.value('(Status)[1]', 'nvarchar(10)'))
	FROM @XMLUploadedDocumentLogID.nodes('/ArrayOfReportFileLogDataContract/ReportFileLogDataContract') as T(Pers)

 WHILE (@CurrCount<=@TotalCount)
 BEGIN
	SELECT @Status=Pers.value('(Status)[1]', 'nvarchar(10)'),
	@UploadedDocumentLogID = Pers.value('(UploadedDocumentLogID)[1]', 'nvarchar(256)')
	FROM @XMLUploadedDocumentLogID.nodes('/ArrayOfReportFileLogDataContract/ReportFileLogDataContract[position()=sql:variable("@CurrCount")]') as T(Pers)
	
	UPDATE App.ReportFileLog SET [Status]=@Status,UpdatedBy=@UserID,UpdatedDate=GETDATE()
	WHERE UploadedDocumentLogID = @UploadedDocumentLogID
	
	SET @CurrCount+=1
END

END


