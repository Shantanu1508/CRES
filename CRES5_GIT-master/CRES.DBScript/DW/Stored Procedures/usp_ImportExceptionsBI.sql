
CREATE PROCEDURE [DW].[usp_ImportExceptionsBI]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_ExceptionsBI',GETDATE())


	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)



	Truncate table [DW].[L_ExceptionsBI]

	INSERT INTO [DW].[L_ExceptionsBI]
	(
		[ExceptionID],
		[ObjectID],
		[ObjectTypeID],
		[ObjectTypeBI],
		[FieldName],
		[Summary],
		[ActionLevelID],
		[ActionLevelBI],
		[CreatedBy],
		[CreatedDate],
		[UpdatedBy],
		[UpdatedDate]
	)
	Select  
	[ExceptionID],  
	[ObjectID],  
	[ObjectTypeID],  
	LObjectTypeID.[Name] as [ObjectTypeBI],  
	[FieldName],  
	[Summary],  
	[ActionLevelID],  
	LActionLevelID.[Name] as [ActionLevelBI],  
	ex.[CreatedBy],  
	ex.[CreatedDate],  
	ex.[UpdatedBy],  
	ex.[UpdatedDate]  
	From CORE.Exceptions ex  
	left join Core.Lookup  LObjectTypeID ON ex.ObjectTypeID = LObjectTypeID .LookupID  
	left join Core.Lookup  LActionLevelID ON ex.ActionLevelID = LActionLevelID .LookupID  
	Where ex.objectid in (
		SELECT DISTINCT objectid 
		FROM 
		(
			SELECT tdn.objectid,[ObjectTypeID], tdn.CreatedDate, tdn.UpdatedDate FROM CORE.Exceptions tdn where tdn.[ObjectID] not in (Select noteid from cre.note n inner join core.account acc on acc.accountid = n.account_accountid where acc.isdeleted = 1)
			EXCEPT 
			SELECT dwtd.objectid,[ObjectTypeID], dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].[ExceptionsBI] dwtd
		)b
	)




SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportExceptionsBI - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



	UPDATE [DW].BatchDetail	SET	LandingEndTime = GETDATE(),	LandingRecordCount = @RowCount	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


