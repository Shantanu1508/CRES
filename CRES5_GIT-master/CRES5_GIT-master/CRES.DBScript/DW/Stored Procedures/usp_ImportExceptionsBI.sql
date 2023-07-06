
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





--Declare @IsDiff bit;
--Declare @ChangedNoteId table(
--	ObjectID UNIQUEIDENTIFIER
--)

--DECLARE @CRES_Exceptions int, @DW_Exceptions int, @countAll int;

--Select @CRES_Exceptions = COUNT(ExceptionID) From CORE.Exceptions 
--Select @DW_Exceptions = COUNT(ExceptionID) From DW.ExceptionsBI

-- --Comparing both tables
--SELECT @countAll = COUNT(ExceptionID) from
--(
--	Select ExceptionID  From CORE.Exceptions 
--	UNION
--	Select ExceptionID  From DW.ExceptionsBI 
--)a
   
--IF(@CRES_Exceptions = @DW_Exceptions and @CRES_Exceptions = @countAll )
--BEGIN
--	PRINT('Same')
--	SEt @IsDiff = 0;
--END
--ELSE
--BEGIN
--	PRINT('Diff')
--	SEt @IsDiff = 1;
--END

--IF(@IsDiff= 1)
--BEGIN

--	INSERT INTO @ChangedNoteId (ObjectID)
--	SELECT Distinct ObjectID from
--	(
--		(
--			Select ExceptionID,[ObjectID]  From CORE.Exceptions 
--			EXCEPT
--			Select ExceptionID,[ObjectID]  From DW.ExceptionsBI 
--		)
--		UNION
--		(
--			Select ExceptionID,[ObjectID]  From DW.ExceptionsBI
--			EXCEPT 
--			Select ExceptionID,[ObjectID]  From CORE.Exceptions 
--		)
--	)a

--END


-----=======================================================

--IF(@IsDiff= 1)
--BEGIN
--	Truncate table [DW].[L_ExceptionsBI]

--	INSERT INTO [DW].[L_ExceptionsBI]
--	(
--		[ExceptionID],
--		[ObjectID],
--		[ObjectTypeID],
--		[ObjectTypeBI],
--		[FieldName],
--		[Summary],
--		[ActionLevelID],
--		[ActionLevelBI],
--		[CreatedBy],
--		[CreatedDate],
--		[UpdatedBy],
--		[UpdatedDate]
--	)
--	Select
--		ex.[ExceptionID],
--		ex.[ObjectID],
--		ex.[ObjectTypeID],
--		LObjectTypeID.[Name] as [ObjectTypeBI],
--		ex.[FieldName],
--		ex.[Summary],
--		ex.[ActionLevelID],
--		LActionLevelID.[Name] as [ActionLevelBI],
--		ex.[CreatedBy],
--		ex.[CreatedDate],
--		ex.[UpdatedBy],
--		ex.[UpdatedDate]
--	From core.[Exceptions] ex
--	left join Core.Lookup  LObjectTypeID ON ex.ObjectTypeID = LObjectTypeID .LookupID
--	left join Core.Lookup  LActionLevelID ON ex.ActionLevelID = LActionLevelID .LookupID
--	where ObjectID in (Select ObjectID from @ChangedNoteId)

	
--END


SET @RowCount = 0  ---@@ROWCOUNT
	Print(char(9) +'usp_ImportExceptionsBI - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



	UPDATE [DW].BatchDetail	SET	LandingEndTime = GETDATE(),	LandingRecordCount = @RowCount	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


