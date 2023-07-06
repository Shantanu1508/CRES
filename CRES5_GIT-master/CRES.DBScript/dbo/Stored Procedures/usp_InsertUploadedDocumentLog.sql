



CREATE PROCEDURE [dbo].[usp_InsertUploadedDocumentLog] 
 @CreatedBy nvarchar(max),
 @FileName  nvarchar(max),
 @OriginalFileName nvarchar(max),
 @storagetype nvarchar(50),
 @ObjectID nvarchar(max), 
 @ObjectTypeID nvarchar(max),
 @DocumentTypeID nvarchar(max),
 @Comment nvarchar(max),
 @DocumentStorageID nvarchar(256),
 @NewUploadedDocumentLogID nvarchar(256) OUTPUT
AS
BEGIN

   DECLARE @storagetypeid int = (Select LookupID from core.lookup where name = @storagetype and parentid in (63,75));
   DECLARE @tUploadedDocumentLogID TABLE (tNewUploadedDocumentLogID UNIQUEIDENTIFIER)

	--Managing generic table for fileupload
	INSERT INTO [App].[UploadedDocumentLog]([ObjectTypeID],[ObjectID],[FileName],[OriginalFileName],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate], StorageTypeID, [DocumentTypeID], Comment,DocumentStorageID)
	OUTPUT inserted.UploadedDocumentLogID INTO @tUploadedDocumentLogID(tNewUploadedDocumentLogID)
	VALUES(@ObjectTypeID,@ObjectID,@FileName,@OriginalFileName,@CreatedBy,getdate(),@CreatedBy,getdate(), @storagetypeid, @DocumentTypeID, @Comment,@DocumentStorageID);

	SELECT @NewUploadedDocumentLogID = tNewUploadedDocumentLogID FROM @tUploadedDocumentLogID;

 --log activity
 IF (@ObjectTypeID=283)
 BEGIN

 exec dbo.usp_InsertActivityLog @ObjectID,283,@NewUploadedDocumentLogID,417,'Updated',@CreatedBy
 END
 ELSE IF (@ObjectTypeID=182)
 BEGIN
  exec dbo.usp_InsertActivityLog @ObjectID,182,@NewUploadedDocumentLogID,417,'Updated',@CreatedBy
 END

END

