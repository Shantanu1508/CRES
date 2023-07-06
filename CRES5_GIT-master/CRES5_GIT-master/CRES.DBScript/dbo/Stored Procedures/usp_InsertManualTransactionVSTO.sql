

CREATE PROCEDURE [dbo].[usp_InsertManualTransactionVSTO]   
@XMLGenericEntity xml, 
@UserID  nvarchar(256)  
AS  
BEGIN  
    SET NOCOUNT ON;  

	Declare @CreatedBy nvarchar(256) = (Select top 1 UserID from App.[User] where [login] = @UserID)


	Declare @ServicerMasterID int;
	SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')
	
	INSERT INTO [IO].[L_ManualTransactionVSTO]
           ([NoteID]
           ,[NoteName]
           ,[DueDate]
           ,[TransactionDate]
           ,[RemitDate]
           ,[Value]
           ,[TransactionTypeID]
           ,[ServicerMasterID]
           ,[Status]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

     SELECT Pers.value('(NoteID)[1]', 'nvarchar(256)'),
		 Pers.value('(NoteName)[1]', 'nvarchar(256)'),
		 Pers.value('(DueDate)[1]', 'DateTime'),
		 Pers.value('(DueDate)[1]', 'DateTime'),
		 Pers.value('(DueDate)[1]', 'DateTime'),
		 Pers.value('(Value)[1]', 'decimal(28, 15)'),
		 Pers.value('(TransactionTypeID)[1]', 'int'),
		 @ServicerMasterID,
		 'InProcess',
		 @CreatedBy,
		 getdate(),
		 @CreatedBy,
		 getdate()
	FROM @XMLGenericEntity.nodes('/ArrayOfGenericEntityDataContract/GenericEntityDataContract') as T(Pers)
	
	--where cast(Pers.value('(DueDate)[1]', 'DateTime') as date)>=cast(getdate() as date)
	--and cast(Pers.value('(DueDate)[1]', 'DateTime') as date)<=cast(dateadd(d,30 ,getdate()) as date)

	--import from landing to actual 
	exec [dbo].[usp_ImportInActualFromManualTransactionVSTO] @CreatedBy

END  


