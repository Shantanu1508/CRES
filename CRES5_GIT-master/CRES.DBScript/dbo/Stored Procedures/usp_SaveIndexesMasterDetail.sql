
CREATE PROCEDURE [dbo].[usp_SaveIndexesMasterDetail]
(
    @IndexesMasterGuid nvarchar(500),
	@IndexesMasterID int,   
    @IndexesName nvarchar(500),    
	@Description nvarchar(MAX), 
	@CreatedBy nvarchar(256) ,
	@CreatedDate datetime ,
	@UpdatedBy nvarchar(256) ,
	@UpdatedDate datetime ,
	@NewIndexesMasterGuid nvarchar(256) OUTPUT,
	@Status int
	)
  
AS
if(@IndexesMasterGuid='00000000-0000-0000-0000-000000000000' or @IndexesMasterGuid is null)
BEGIN


DECLARE @tIndexesMaster TABLE (tNewIndexesMasterGuid UNIQUEIDENTIFIER)

INSERT INTO core.IndexesMaster
           (
				IndexesName	,
				[Description],
				CreatedBy,
				CreatedDate,
				UpdatedBy,
				UpdatedDate,
				[Status]
				)
		OUTPUT inserted.IndexesMasterGuid INTO @tIndexesMaster(tNewIndexesMasterGuid)
		
     VALUES
           (    @IndexesName ,    
				@Description , 
				@CreatedBy  ,
				GETDATE(),
			 	@UpdatedBy  ,
				GETDATE()	,
				@Status
			)

			  SELECT @NewIndexesMasterGuid = tNewIndexesMasterGuid FROM @tIndexesMaster;	
	

END
ELSE
BEGIN

Update core.IndexesMaster
 set 
				IndexesName=@IndexesName,
				[Description]=@Description,
				UpdatedBy=	@UpdatedBy,
				UpdatedDate =GETDATE(),
				[Status]=@Status
				where IndexesMasterGuid=@IndexesMasterGuid;
				
				SELECT @NewIndexesMasterGuid = @IndexesMasterGuid 
	

END
