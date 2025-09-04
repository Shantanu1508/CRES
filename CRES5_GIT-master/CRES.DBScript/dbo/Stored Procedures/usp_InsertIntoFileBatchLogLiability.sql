CREATE PROCEDURE [dbo].[usp_InsertIntoFileBatchLogLiability]  
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
insert into [IO].[FileBatchLogLiability] (ServcerMasterID ,
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
insert into [IO].[FileBatchDetailLiability](BatchLogID ,
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
