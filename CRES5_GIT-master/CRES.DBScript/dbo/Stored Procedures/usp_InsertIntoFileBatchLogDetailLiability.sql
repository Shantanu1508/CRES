Create PROCEDURE [dbo].[usp_InsertIntoFileBatchLogDetailLiability]  
(
	@UserId nvarchar(256),
	@BatchLogID int,	
	@ProcessName nvarchar(256)	,
	@ErrorMsg nvarchar(256)	
)
AS
BEGIN

insert into [IO].[FileBatchDetailLiability](BatchLogID ,
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
