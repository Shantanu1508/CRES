CREATE PROCEDURE [dbo].[usp_InsertIntoM61AddinLanding]   
@UserID  nvarchar(256) , 
@XMLGenericEntity xml
AS  
BEGIN  
    SET NOCOUNT ON;  

Declare @CreatedBy nvarchar(256);
Declare @ServicerMasterID int;
Declare @BatchLogID int;
Declare @RowCount int;

SEt @CreatedBy = (Select top 1 UserID from App.[User] where [login] = @UserID)
SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')
	

BEGIN TRY

	INSERT INTO [IO].[BatchLogGeneric] (BatchName,BatchStartTime,StartedBy,[Status])
	VALUES ('M61AddinProcess',GETDATE(),@CreatedBy,'Process Running')

	SET @BatchLogID = @@IDENTITY

	--======Write your insert into Landing table query here =======

	INSERT INTO [IO].[L_M61AddinLanding]
           ([NoteID]
           ,[NoteName]
           ,[DueDate]
           ,[TransactionDate]
           ,[RemitDate]
           ,[Value]
           ,[TransactionTypeID]
		   ,TableName
		   ,EffectiveDate
           ,[ServicerMasterID]
           ,[Status]
		   ,BatchLogGenericID
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,[Cash_NonCash])

     SELECT Pers.value('(NoteID)[1]', 'nvarchar(256)'),
		 Pers.value('(NoteName)[1]', 'nvarchar(256)'),
		 Pers.value('(DueDate)[1]', 'DateTime'),
		 Pers.value('(DueDate)[1]', 'DateTime'),
		 Pers.value('(RemitDate)[1]', 'DateTime'),
		 Pers.value('(Value)[1]', 'decimal(28, 15)'),
		 Pers.value('(TransactionTypeID)[1]', 'int'),
		 Pers.value('(TableName)[1]', 'nvarchar(256)'),
		 Pers.value('(EffectiveDate)[1]', 'DateTime'),	  
		 @ServicerMasterID,
		 'InProcess',
		 @BatchLogID,
		 @CreatedBy,
		 getdate(),
		 @CreatedBy,
		 getdate(),
		 Pers.value('(Cash_NonCash)[1]', 'nvarchar(256)')		
	FROM @XMLGenericEntity.nodes('/ArrayOfGenericEntityDataContract/GenericEntityDataContract') as T(Pers)

	

	Update [IO].[L_M61AddinLanding] set [Status] = 'Ignore',Comment = 'Note does not exist in M61' where BatchLogGenericID = @BatchLogID and NoteID not in (Select crenoteid from cre.note)


	--=============================================================

	SET @RowCount = @@ROWCOUNT
	UPDATE [IO].[BatchLogGeneric] SET RecordCount = @RowCount WHERE [BatchLogGenericID] = @BatchLogID	 

	--======Import landing to main =======		
	
	exec [dbo].[usp_ImportInActualFromM61AddinLanding] @BatchLogID,@CreatedBy
	exec [dbo].[usp_ImportInNoteAttributesbyDateFromM61AddinLanding] @BatchLogID,@CreatedBy	   
	exec [dbo].[usp_InsertTransactionEntryManual]  @BatchLogID,@CreatedBy
	--====================================

	UPDATE [IO].[BatchLogGeneric] SET [Status] = 'Process Complete',BatchEndTime = GETDATE() WHERE [BatchLogGenericID] = @BatchLogID	

	select @BatchLogID

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT,@ErrorProc NVARCHAR(4000)

	SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE(),@ErrorProc = ERROR_PROCEDURE();

	UPDATE [IO].[BatchLogGeneric]
	SET Status =  'Process Incomplete',
		BatchEndTime = GETDATE(),
		ErrorMessage = @ErrorMessage + 'Occurred in ' + @ErrorProc
	WHERE [BatchLogGenericID] = @BatchLogID

	RAISERROR (@ErrorMessage, -- Message text.
        @ErrorSeverity, -- Severity.
        @ErrorState -- State.
        );

END CATCH



END  
