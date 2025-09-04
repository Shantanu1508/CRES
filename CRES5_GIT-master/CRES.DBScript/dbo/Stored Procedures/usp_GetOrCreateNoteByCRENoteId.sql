


CREATE PROCEDURE [dbo].[usp_GetOrCreateNoteByCRENoteId] --'789'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B'
(
    @CRENoteID nvarchar(256),
	@DealID uniqueidentifier,
	@UserName nvarchar(256)
)
	
AS
BEGIN
     SET NOCOUNT ON;
     Declare @NoteID uniqueidentifier;

     set @NoteID= (SELECT n.NoteID	FROM CRE.Note n inner join Core.Account ac on n.Account_AccountID=ac.AccountID WHERE CRENoteID = @CRENoteID and ac.isdeleted=0)


	 if @NoteID is null
	  Begin
	  
DECLARE @insertedAccountID uniqueidentifier;
DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)

	  INSERT INTO [Core].[Account]
           (
            [AccountTypeID]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
		   OUTPUT inserted.AccountID INTO @tAccount(tAccountID)
     VALUES
           (
			1 ---(select LookupID from core.Lookup where Name='Note')
			,(select LookupID from core.Lookup where Name='Active'  and Parentid = 1)
			,@UserName
			,getdate()
			,@UserName
			,getdate()	   
		   )
		
		SELECT @insertedAccountID = tAccountID FROM @tAccount;

		insert into cre.Note( CRENoteID,DealID,Account_AccountID, CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
		values(@CRENoteID,@DealID,@insertedAccountID,@UserName,getdate(),@UserName,getdate())

		set @NoteID= (SELECT n.NoteID	FROM CRE.Note n inner join Core.Account ac on n.Account_AccountID=ac.AccountID WHERE CRENoteID = @CRENoteID and ac.isdeleted=0)

		


	  End

	  select @NoteID	NoteID	  

END

