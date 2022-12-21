Create PROCEDURE [dbo].[usp_InsertIntoFileBatchLogDetail]  
(
	@UserId nvarchar(256),
	@BatchLogID int,	
	@ProcessName nvarchar(256)	,
	@ErrorMsg nvarchar(256)	
	
)
AS
BEGIN

insert into [IO].[FileBatchDetail](BatchLogID ,
								ProcessName ,
								ErrorMsg ,	
								CreatedBy  ,
								CreatedDate,
								UpdatedBy,
								UpdatedDate)
			Values(
						@BatchLogID,
						@ProcessName,
						@ErrorMsg,
						@UserId,
						GetDate(),
						@UserId,
						GetDate())


END
