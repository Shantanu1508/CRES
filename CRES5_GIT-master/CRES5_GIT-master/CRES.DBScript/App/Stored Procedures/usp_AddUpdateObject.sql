

CREATE PROCEDURE [App].[usp_AddUpdateObject] --'01541783-2806-4a1a-a8f9-acbb34cab4bf',283,'4fa9caaa-181d-42d2-9381-c888ff18b1b2','4fa9caaa-181d-42d2-9381-c888ff18b1b2'
(
	@ObjectID UNIQUEIDENTIFIER,
	@ObjectTypeID INT,
	@CreatedBy [nvarchar](256) ,
	@UpdatedBy [nvarchar](256) 
) 
AS
BEGIN


Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
Declare @LookupIdForFinancingFacility int= (Select lookupid from core.Lookup where name = 'Financing Facility');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');
Declare @LookupIdForProperty int= (Select lookupid from core.Lookup where name = 'Property');

--Search Object Type
Declare @ObjTy_CREDealID int = (Select lookupid from core.Lookup where name = 'CREDealID');
Declare @ObjTy_DealName int = (Select lookupid from core.Lookup where name = 'DealName');
Declare @ObjTy_CRENoteID int = (Select lookupid from core.Lookup where name = 'CRENoteID');
Declare @ObjTy_NoteName int = (Select lookupid from core.Lookup where name = 'NoteName');
Declare @ObjTy_PropertyName int = (Select lookupid from core.Lookup where name = 'PropertyName');
Declare @ObjTy_PropertyAddress int = (Select lookupid from core.Lookup where name = 'PropertyAddress');
Declare @ObjTy_FinancingFacilityName int = (Select lookupid from core.Lookup where name = 'FinancingFacilityName');
Declare @ObjTy_ClientNoteID int = (Select lookupid from core.Lookup where name = 'ClientNoteID');


Declare @ObjectName [nvarchar](256); 
Declare @StatusID INT;
Declare @ParentObjectID UNIQUEIDENTIFIER ;

--Declare @Object_ObjectAutoID UNIQUEIDENTIFIER = @ParentObjectID;


IF(@LookupIdForDeal = @ObjectTypeID) --Deal
BEGIN
	 
	Declare @CREDealID [nvarchar](256); 
	Declare @DealName [nvarchar](256); 

	Select 
	@CREDealID = CREDealID,
	@DealName = DealName ,
	@StatusID = NULL--[Status]
	from CRE.Deal where DealID = @ObjectID and IsDeleted=0

	-------------------------------------------------------------
	SET @ObjectName= @DealName;
	Declare @Object_ObjectAutoID UNIQUEIDENTIFIER = NULL;
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN

		--Update table [App].[SearchItem]
		Declare @l_objectautoid uniqueidentifier = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
		UPDATE [App].[SearchItem] SET [SearchText] = @CREDealID  WHERE  [SearchObjectType] = @ObjTy_CREDealID and Object_ObjectAutoID = @l_objectautoid
		UPDATE [App].[SearchItem] SET [SearchText] = @DealName  WHERE  [SearchObjectType] = @ObjTy_DealName and Object_ObjectAutoID = @l_objectautoid
		----------------------------------

		UPDATE [App].[Object]
		SET [ObjectName] = @ObjectName
			,[ObjectTypeID] = @ObjectTypeID
			,[StatusID] = @StatusID
			,[Object_ObjectAutoID] = @Object_ObjectAutoID
			,[UpdatedBy] = @UpdatedBy
			,[UpdatedDate] = GETDATE()
		WHERE [ObjectID] = @ObjectID


	END
	ELSE
	BEGIN
		DECLARE @ttable TABLE (tinsertedID UNIQUEIDENTIFIER)
		DECLARE @InsertedID uniqueidentifier;

		INSERT INTO [App].[Object]
					([ObjectID]
					,[ObjectName]
					,[ObjectTypeID]
					,[StatusID]
					,[Object_ObjectAutoID]
					,[CreatedBy]
					,[CreatedDate]
					,[UpdatedBy]
					,[UpdatedDate])
		OUTPUT inserted.ObjectAutoID INTO @ttable(tinsertedID)
		VALUES
		(
			@ObjectID,
			@ObjectName,
			@ObjectTypeID,
			@StatusID,
			@Object_ObjectAutoID,
			@CreatedBy,
			GETDATE() ,
			@UpdatedBy ,
			GETDATE()
		)
		SELECT @InsertedID = tinsertedID FROM @ttable;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID,@CREDealID,0,@ObjTy_CREDealID,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID,@DealName,0,@ObjTy_DealName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		----------------------------------
	END
	

	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal where IsDeleted=0) AND  ObjectTypeID = @ObjectTypeID)
	Update [App].[Object]  set Object_ObjectAutoID = null where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @ObjectTypeID)
	Delete from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @ObjectTypeID
END


IF(@LookupIdForNote = @ObjectTypeID) --Note
BEGIN
	
	Declare @CRENoteID [nvarchar](256); 
	Declare @NoteName [nvarchar](256); 
	Declare @ClientNoteID [nvarchar](256); 
	Declare @DealID UNIQUEIDENTIFIER; 
 

	 Select 
	@CRENoteID = CREnoteID,
	@NoteName = acc.Name ,
	@ClientNoteID = n.ClientNoteID,
	@StatusID = acc.StatusID,
	@DealID = n.DealID
	from CRE.Note n 
	INNER JOIN CORE.Account acc on acc.AccountID = n.Account_AccountID
	where NoteID = @ObjectID and acc.IsDeleted=0

	-------------------------------------------------------------
	SET @ObjectName= @NoteName;
	 
	SET @Object_ObjectAutoID = (Select ObjectAutoID From [App].[Object] where [ObjectID] = @DealID)
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN


		UPDATE [App].[Object]
		SET [ObjectName] = @ObjectName
			,[ObjectTypeID] = @ObjectTypeID
			,[StatusID] = @StatusID
			,[Object_ObjectAutoID] = @Object_ObjectAutoID
			,[UpdatedBy] = @UpdatedBy
			,[UpdatedDate] = GETDATE()
		WHERE [ObjectID] = @ObjectID


		--Update table [App].[SearchItem]
		SET @l_objectautoid  = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )

		--CRENoteID
		IF EXISTS(Select Object_ObjectAutoID from [App].[SearchItem] where [SearchObjectType] = @ObjTy_CRENoteID and Object_ObjectAutoID = @l_objectautoid)
		BEGIN
			PRINT('Update - CRENoteID')
			UPDATE [App].[SearchItem] SET [SearchText] = @CRENoteID  WHERE  [SearchObjectType] = @ObjTy_CRENoteID and Object_ObjectAutoID = @l_objectautoid
		END
		ELSE
		BEGIN
			PRINT('Insert - CRENoteID')
			INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
			VALUES(GETDATE(),@l_objectautoid,@CRENoteID,0,@ObjTy_CRENoteID,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		END
		

		--NoteName
		IF EXISTS(Select Object_ObjectAutoID from [App].[SearchItem] where [SearchObjectType] = @ObjTy_NoteName and Object_ObjectAutoID = @l_objectautoid)
		BEGIN
			PRINT('Update - NoteName')
			UPDATE [App].[SearchItem] SET [SearchText] = @NoteName  WHERE  [SearchObjectType] = @ObjTy_NoteName and Object_ObjectAutoID = @l_objectautoid
		END
		ELSE
		BEGIN
			PRINT('Insert - NoteName')
			INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
			VALUES(GETDATE(),@l_objectautoid,@NoteName,0,@ObjTy_NoteName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		END

		----ClientNoteID		
		--IF EXISTS(Select Object_ObjectAutoID from [App].[SearchItem] where  [SearchObjectType] = @ObjTy_ClientNoteID and Object_ObjectAutoID = @l_objectautoid)
		--BEGIN
		--	PRINT('Update - ClientNoteID')
		--	UPDATE [App].[SearchItem] SET [SearchText] = @ClientNoteID  WHERE  [SearchObjectType] = @ObjTy_ClientNoteID and Object_ObjectAutoID = @l_objectautoid
		--END
		--ELSE
		--BEGIN
		--	PRINT('Insert - ClientNoteID')
		--	INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		--	VALUES(GETDATE(),@l_objectautoid,@ClientNoteID,0,@ObjTy_ClientNoteID,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		--END
		----------------------------------

	END
	ELSE
	BEGIN
		DECLARE @ttable1 TABLE (tinsertedID1 UNIQUEIDENTIFIER)
		DECLARE @InsertedID1 uniqueidentifier;

		INSERT INTO [App].[Object]
					([ObjectID]
					,[ObjectName]
					,[ObjectTypeID]
					,[StatusID]
					,[Object_ObjectAutoID]
					,[CreatedBy]
					,[CreatedDate]
					,[UpdatedBy]
					,[UpdatedDate])
		OUTPUT inserted.ObjectAutoID INTO @ttable1(tinsertedID1)
		VALUES
		(
			@ObjectID,
			@ObjectName,
			@ObjectTypeID,
			@StatusID,
			@Object_ObjectAutoID,
			@CreatedBy,
			GETDATE() ,
			@UpdatedBy ,
			GETDATE()
		)
		SELECT @InsertedID1 = tinsertedID1 FROM @ttable1;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID1,@CRENoteID,0,@ObjTy_CRENoteID,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID1,@NoteName,0,@ObjTy_NoteName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())

		--INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		--VALUES(GETDATE(),@InsertedID1,@ClientNoteID,0,@ObjTy_ClientNoteID,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		----------------------------------
	END
	

	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @ObjectTypeID)
	Delete from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @ObjectTypeID
END

 
IF(@LookupIdForProperty = @ObjectTypeID) --Property
BEGIN
	--SET @Object_ObjectAutoID = (Select Object_ObjectAutoID From [App].[Object] where [ObjectID] = @ParentObjectID)

	 
	Declare @PropertyName [nvarchar](256); 
	Declare @Address [nvarchar](256); 
	
 

	 Select 
	@PropertyName = p.PropertyName,
	@Address = p.[Address],
	@StatusID = NULL,
	@DealID = p.Deal_DealID
	from CRE.Property p
	INNER JOIN CRE.Deal D on d.DealID = p.Deal_DealID
	where PropertyID = @ObjectID

	-------------------------------------------------------------
	SET @ObjectName= @PropertyName;
	 
	SET @Object_ObjectAutoID = (Select ObjectAutoID From [App].[Object] where [ObjectID] = @DealID)
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN

		--Update table [App].[SearchItem]
		SET @l_objectautoid  = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
		UPDATE [App].[SearchItem] SET [SearchText] = @PropertyName  WHERE  [SearchObjectType] = @ObjTy_PropertyName and Object_ObjectAutoID = @l_objectautoid
		UPDATE [App].[SearchItem] SET [SearchText] = @Address  WHERE  [SearchObjectType] = @ObjTy_PropertyAddress and Object_ObjectAutoID = @l_objectautoid
		----------------------------------

		UPDATE [App].[Object]
		SET [ObjectName] = @ObjectName
			,[ObjectTypeID] = @ObjectTypeID
			,[StatusID] = @StatusID
			,[Object_ObjectAutoID] = @Object_ObjectAutoID
			,[UpdatedBy] = @UpdatedBy
			,[UpdatedDate] = GETDATE()
		WHERE [ObjectID] = @ObjectID


	END
	ELSE
	BEGIN
		DECLARE @ttable2 TABLE (tinsertedID2 UNIQUEIDENTIFIER)
		DECLARE @InsertedID2 uniqueidentifier;

		INSERT INTO [App].[Object]
					([ObjectID]
					,[ObjectName]
					,[ObjectTypeID]
					,[StatusID]
					,[Object_ObjectAutoID]
					,[CreatedBy]
					,[CreatedDate]
					,[UpdatedBy]
					,[UpdatedDate])
		OUTPUT inserted.ObjectAutoID INTO @ttable2(tinsertedID2)
		VALUES
		(
			@ObjectID,
			@ObjectName,
			@ObjectTypeID,
			@StatusID,
			@Object_ObjectAutoID,
			@CreatedBy,
			GETDATE() ,
			@UpdatedBy ,
			GETDATE()
		)
		SELECT @InsertedID2 = tinsertedID2 FROM @ttable2;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID2,@PropertyName,0,@ObjTy_PropertyName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID2,@Address,0,@ObjTy_PropertyAddress,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		----------------------------------
	END

	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select PropertyID from CRE.Property) AND  ObjectTypeID = @ObjectTypeID)
	Delete from [App].[Object] where ObjectID not in (Select PropertyID from CRE.Property) AND  ObjectTypeID = @ObjectTypeID
END


IF(@LookupIdForFinancingFacility = @ObjectTypeID) --FinancingFacility
BEGIN
	
	Declare @FinancingFacilityName [nvarchar](256); 
	

	Select 
	@FinancingFacilityName = acc.Name ,
	@StatusID = StatusID
	from CRE.FinancingWarehouse n 
	INNER JOIN CORE.Account acc on acc.AccountID = n.Account_AccountID
	where FinancingWarehouseID = @ObjectID

	-------------------------------------------------------------
	SET @ObjectName= @FinancingFacilityName;
	SET @Object_ObjectAutoID = NULL;
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN

		--Update table [App].[SearchItem]
		Declare @l_objectautoid1 uniqueidentifier = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
		UPDATE [App].[SearchItem] SET [SearchText] = @FinancingFacilityName  WHERE  [SearchObjectType] = @ObjTy_FinancingFacilityName and Object_ObjectAutoID = @l_objectautoid1
		----------------------------------

		UPDATE [App].[Object]
		SET [ObjectName] = @ObjectName
			,[ObjectTypeID] = @ObjectTypeID
			,[StatusID] = @StatusID
			,[Object_ObjectAutoID] = @Object_ObjectAutoID
			,[UpdatedBy] = @UpdatedBy
			,[UpdatedDate] = GETDATE()
		WHERE [ObjectID] = @ObjectID


	END
	ELSE
	BEGIN
		DECLARE @ttable3 TABLE (tinsertedID3 UNIQUEIDENTIFIER)
		DECLARE @InsertedID3 uniqueidentifier;

		INSERT INTO [App].[Object]
					([ObjectID]
					,[ObjectName]
					,[ObjectTypeID]
					,[StatusID]
					,[Object_ObjectAutoID]
					,[CreatedBy]
					,[CreatedDate]
					,[UpdatedBy]
					,[UpdatedDate])
		OUTPUT inserted.ObjectAutoID INTO @ttable3(tinsertedID3)
		VALUES
		(
			@ObjectID,
			@ObjectName,
			@ObjectTypeID,
			@StatusID,
			@Object_ObjectAutoID,
			@CreatedBy,
			GETDATE() ,
			@UpdatedBy ,
			GETDATE()
		)
		SELECT @InsertedID3 = tinsertedID3 FROM @ttable3;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID3,@FinancingFacilityName,0,@ObjTy_FinancingFacilityName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		 
		----------------------------------
	END


	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select FinancingWarehouseID from CRE.FinancingWarehouse) AND  ObjectTypeID = @ObjectTypeID)
	Delete from [App].[Object] where ObjectID not in (Select FinancingWarehouseID from CRE.FinancingWarehouse) AND  ObjectTypeID = @ObjectTypeID
END





END






