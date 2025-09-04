CREATE PROCEDURE [dbo].[usp_InsertIntoM61AddinLandingTagXIRR]   
@UserID  nvarchar(256) , 
@XMLGenericEntity xml
AS  
BEGIN  
    SET NOCOUNT ON;  

Declare @CreatedBy nvarchar(256);
Declare @BatchLogID int;
Declare @RowCount int;

SEt @CreatedBy = (Select top 1 UserID from App.[User] where [login] = @UserID)
	

BEGIN TRY

	INSERT INTO [IO].[BatchLogGeneric] (BatchName,BatchStartTime,StartedBy,[Status])
	VALUES ('M61AddinTagXIRR',GETDATE(),@CreatedBy,'Process Running')

	SET @BatchLogID = @@IDENTITY

	--======Write your insert into Landing table query here =======

	INSERT INTO [IO].[L_M61AddinLandingTagXIRR]
           ([TableName]
	       ,[ObjectID]
	       ,[TagID] 
		   ,[TagName]
	       ,[Status]
		   ,[BatchLogGenericID]
           ,[CreatedDate]
	       ,[CreatedBy]
           ,[UpdatedDate] 
	       ,[UpdatedBy])

     SELECT 
	     Pers.value('(TableName)[1]', 'nvarchar(256)'),
		 Pers.value('(ObjectID)[1]', 'nvarchar(256)'),
		 Pers.value('(TagID)[1]', 'int'),
		 Pers.value('(TagName)[1]', 'nvarchar(256)'),
		 'InProcess',
		 @BatchLogID,
		 getdate(),
		 @CreatedBy,
		 getdate(),
		 @CreatedBy
	FROM @XMLGenericEntity.nodes('/ArrayOfTagXIRREntityDataContract/TagXIRREntityDataContract') as T(Pers)

	SET @RowCount = @@ROWCOUNT

	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Ignore', Comment = 'Note does not exist in M61' where BatchLogGenericID = @BatchLogID and TableName = 'M61.Tables.TagXIRR_Note' and ObjectID Not in (Select n.CRENoteID from CRE.Note n Inner Join core.Account acc on acc.AccountID =  n.Account_AccountID where acc.IsDeleted = 0)
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Ignore', Comment = 'Deal does not exist in M61' where BatchLogGenericID = @BatchLogID and TableName = 'M61.Tables.TagXIRR_Deal' and ObjectID Not in (Select D.CREDealID from CRE.Deal D Inner Join core.Account acc on acc.AccountID =  D.AccountID where acc.IsDeleted = 0)
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Ignore', Comment = 'Debt does not exist in M61' where BatchLogGenericID = @BatchLogID and TableName = 'M61.Tables.TagXIRR_Debt' and ObjectID Not in (Select acc.name as DebtName from CRE.Debt d Inner Join core.Account acc on acc.AccountID =  d.AccountID where acc.IsDeleted = 0)
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Ignore', Comment = 'Equity does not exist in M61' where BatchLogGenericID = @BatchLogID and TableName = 'M61.Tables.TagXIRR_Equity' and ObjectID Not in (Select acc.name as EquityName from CRE.Equity e Inner Join core.Account acc on acc.AccountID =  e.AccountID where acc.IsDeleted = 0)
    Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Ignore', Comment = 'LiabilityNote does not exist in M61' where BatchLogGenericID = @BatchLogID and TableName = 'M61.Tables.TagXIRR_LiabilityNote' and ObjectID Not in (Select ln.LiabilityNoteID from CRE.LiabilityNote ln Inner Join core.Account acc on acc.AccountID =  ln.AccountID where acc.IsDeleted = 0)

	--=============================================================

	UPDATE [IO].[BatchLogGeneric] SET RecordCount = @RowCount WHERE [BatchLogGenericID] = @BatchLogID	 

	--======Import landing to main =======		


	IF Exists(SELECT Distinct t.[TagID] from  [IO].[L_M61AddinLandingTagXIRR] t where TagID = 0)
	Begin
     Declare @TabletypXIRR [TableTypeTagMasterXIRR]  
     Insert into @TabletypXIRR(TagMasterXIRRID, Name)  
     Select Distinct TagID, TagName From [IO].[L_M61AddinLandingTagXIRR]  where TagID = 0 and
	 TagName Not in (Select Name from cre.TagMasterXIRR)
	 
	 exec [dbo].[usp_InsertUpdateTagMasterXIRR]  @TabletypXIRR, @CreatedBy

	End

	exec [dbo].[usp_InsertIntoTagAccountMappingXIRRByM61Addin] @BatchLogID

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
