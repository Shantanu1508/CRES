CREATE PROCEDURE [dbo].[usp_InsertIntoFileBatchLog]  
(
	@UserId nvarchar(256),
	@ServcerMasterID int,
	@OrigFileName nvarchar(256),
	@BlobFileName nvarchar(256),
	@ErrorMsg nvarchar(256)	,
	@NewBatchLogID int output
)
AS
BEGIN
Declare @NewBatchID int
insert into [IO].[FileBatchLog] (ServcerMasterID ,
							OrigFileName ,
							BlobFileName ,
							CreatedBy ,
							CreatedDate,
							UpdatedBy,
							UpdatedDate)
				Values(
							@ServcerMasterID,
							@OrigFileName,
							@BlobFileName,
							@UserId,
							GetDate(),
							@UserId,
							GetDate())
set @NewBatchID=@@identity
insert into [IO].[FileBatchDetail](BatchLogID ,
								ProcessName ,
								ErrorMsg ,	
								CreatedBy  ,
								CreatedDate,
								UpdatedBy,
								UpdatedDate)
			Values(
						@NewBatchID,
						'File Uploaded into blob',
						@ErrorMsg,
						@UserId,
						GetDate(),
						@UserId,
						GetDate())


select @NewBatchLogID=@NewBatchID


END
