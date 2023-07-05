
CREATE PROCEDURE [dbo].[usp_InsertReportFileLog] 
 @CreatedBy nvarchar(max),
 @FileName  nvarchar(max),
 @OriginalFileName nvarchar(max),
 @storagetypeid nvarchar(50),
 @ObjectGUID nvarchar(50),
 @ObjectID int, 
 @ObjectTypeID nvarchar(max),
 @Comment nvarchar(max),
 @DocumentStorageID nvarchar(256)=null,
 @StorageLocation  nvarchar(max),
 @ReportFileAttributes nvarchar(max),
 @NewUploadedDocumentLogID nvarchar(256) OUTPUT
AS
BEGIN

   --DECLARE @storagetypeid int = (Select LookupID from core.lookup where name = @storagetype and parentid in (63,75));
   DECLARE @tUploadedDocumentLogID TABLE (tNewUploadedDocumentLogID UNIQUEIDENTIFIER)

	--Managing generic table for fileupload
	INSERT INTO [App].[ReportFileLog]([ObjectTypeID],[ObjectGUID],[ObjectID],[FileName],[OriginalFileName],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate], StorageTypeID, Comment,DocumentStorageID,ReportFileAttributes,StorageLocation)
	OUTPUT inserted.UploadedDocumentLogID INTO @tUploadedDocumentLogID(tNewUploadedDocumentLogID)
	VALUES(@ObjectTypeID,@ObjectGUID,@ObjectID,@FileName,@OriginalFileName,@CreatedBy,getdate(),@CreatedBy,getdate(), @storagetypeid, @Comment,@DocumentStorageID,@ReportFileAttributes,@StorageLocation);

	SELECT @NewUploadedDocumentLogID = tNewUploadedDocumentLogID FROM @tUploadedDocumentLogID;

 --log activity
 IF (@ObjectTypeID=643)
 BEGIN
	exec dbo.usp_InsertActivityLog @ObjectGUID,643,@NewUploadedDocumentLogID,417,'Updated',@CreatedBy
 END
 
END

