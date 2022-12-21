
CREATE PROCEDURE [dbo].[usp_ImportIndexes] 
@UserID uniqueidentifier,
@IndexFrom uniqueidentifier,
@IndexTo uniqueidentifier,
@IndexesName nvarchar(500),    
@Description nvarchar(MAX), 
@ImportType int
AS
BEGIN

	SET NOCOUNT ON;
	declare @IndexFromID int, @IndexToID int

	   if (@IndexTo ='00000000-0000-0000-0000-000000000000'	or @IndexTo is null)
	   BEGIN

			INSERT INTO [Core].[IndexesMaster]
				   ([IndexesName]
				   ,[Description]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate])
			 VALUES
				   (@IndexesName
				   ,@Description
				   ,@UserID
				   ,getdate()
				   ,@UserID
				   ,getdate())

				   set @IndexToID=SCOPE_IDENTITY()

	   END
	   ELSE
	   BEGIN
			select  @IndexToID = IndexesMasterID from  core.IndexesMaster where IndexesMasterGuid = @IndexTo
	   END
	
	
	select  @IndexFromID = IndexesMasterID from  core.IndexesMaster where IndexesMasterGuid = @IndexFrom
	
	
	--replace indexes
	IF (@ImportType=1)
	BEGIN
		Delete from core.Indexes where IndexesMasterID = @IndexToID

		INSERT INTO [Core].[Indexes]
				   ([AnalysisID]
				   ,[Date]
				   ,[IndexType]
				   ,[Value]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate]
				   ,[IndexesMasterID])
			SELECT  [AnalysisID]
				   ,[Date]
				   ,[IndexType]
				   ,[Value]
				   ,@UserID
				   ,getdate()
				   ,@UserID
				   ,getdate()
				   ,@IndexToID
		    FROM core.Indexes where IndexesMasterID = @IndexFromID

	END
	ELSE
	BEGIN
			---Insert Values
			INSERT into core.Indexes ([Date],IndexType,Value,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,IndexesMasterID)
			SELECT tmpindex.Date,tmpindex.IndexType,tmpindex.Value,@UserID,GETDATE(),@UserID,GETDATE(),@IndexToID FROM 
			(
			SELECT tind.Date,tind.IndexType ,tind.value
			FROM core.Indexes tind where tind.IndexesMasterID = @IndexFromID
			) tmpindex
			left outer join  core.Indexes ind on tmpindex.IndexType=ind.IndexType and tmpindex.Date=ind.Date and ind.IndexesMasterID=@IndexToID
			where ind.Date is null and ind.IndexType is null 


			---Update Values

			UPDATE Core.Indexes 
			Set
			Core.Indexes.Value = tmpindex.Value,
			Core.Indexes.UpdatedBy= @UserID,
			Core.Indexes.UpdatedDate=GETDATE()
			FROM 
			(
			SELECT tind.Date,tind.IndexType ,tind.value
			FROM core.Indexes tind where tind.IndexesMasterID = @IndexFromID
			) tmpindex
			inner join  core.Indexes ind on tmpindex.IndexType=ind.IndexType and tmpindex.Date=ind.Date and ind.IndexesMasterID = @IndexToID
	END
END





