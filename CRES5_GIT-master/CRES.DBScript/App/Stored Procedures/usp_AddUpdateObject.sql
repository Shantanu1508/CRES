-- Procedure


CREATE PROCEDURE [App].[usp_AddUpdateObject] --'01541783-2806-4a1a-a8f9-acbb34cab4bf',283,'4fa9caaa-181d-42d2-9381-c888ff18b1b2','4fa9caaa-181d-42d2-9381-c888ff18b1b2'
(
	@ObjectID UNIQUEIDENTIFIER,
	@ObjectTypeID INT,
	@CreatedBy [nvarchar](256) ,
	@UpdatedBy [nvarchar](256) 
) 
AS
BEGIN


Declare @LookupIdForNote int = (Select lookupid from core.Lookup where parentid = 27 and  name = 'Note');
Declare @LookupIdForFinancingFacility int= (Select lookupid from core.Lookup where parentid = 27 and  name = 'Financing Facility');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where parentid = 27 and  name = 'Deal');
Declare @LookupIdForProperty int= (Select lookupid from core.Lookup where parentid = 27 and  name = 'Property');

Declare @LookupIdForEquity int = (Select lookupid from core.Lookup where  parentid = 27 and name = 'Equity')
Declare @LookupIdForLiabilityNote int = (Select lookupid from core.Lookup where  parentid = 27 and name = 'LiabilityNote')
Declare @LookupIdForDebt int = (Select lookupid from core.Lookup where  parentid = 27 and name = 'Debt')
Declare @LookupIdForEquityShortName int = (Select lookupid from core.Lookup where  parentid = 27 and name = 'EquityShortName')
Declare @LookupIdForDebtFinancialInstitution int = (Select lookupid from core.Lookup where  parentid = 27 and name = 'DebtFinancialInstitution')



--Search Object Type
Declare @ObjTy_CREDealID int = (Select lookupid from core.Lookup where parentid = 45 and name = 'CREDealID');
Declare @ObjTy_DealName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'DealName');
Declare @ObjTy_CRENoteID int = (Select lookupid from core.Lookup where parentid = 45 and name = 'CRENoteID');
Declare @ObjTy_NoteName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'NoteName');
Declare @ObjTy_PropertyName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'PropertyName');
Declare @ObjTy_PropertyAddress int = (Select lookupid from core.Lookup where parentid = 45 and name = 'PropertyAddress');
Declare @ObjTy_FinancingFacilityName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'FinancingFacilityName');
Declare @ObjTy_ClientNoteID int = (Select lookupid from core.Lookup where parentid = 45 and name = 'ClientNoteID');

Declare @ObjTy_DebtName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'DebtName');
Declare @ObjTy_EquityName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'EquityName');
Declare @ObjTy_LiabilityNoteID int = (Select lookupid from core.Lookup where parentid = 45 and name = 'LiabilityNoteID');

Declare @ObjTy_EquityShortName int = (Select lookupid from core.Lookup where parentid = 45 and name = 'EquityShortName');
Declare @ObjTy_DebtFinancialInstitution int = (Select lookupid from core.Lookup where parentid = 45 and name = 'DebtFinancialInstitution');


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


--IF(@LookupIdForFinancingFacility = @ObjectTypeID) --FinancingFacility
--BEGIN
	
--	Declare @FinancingFacilityName [nvarchar](256); 
	

--	Select 
--	@FinancingFacilityName = acc.Name ,
--	@StatusID = StatusID
--	from CRE.FinancingWarehouse n 
--	INNER JOIN CORE.Account acc on acc.AccountID = n.Account_AccountID
--	where FinancingWarehouseID = @ObjectID

--	-------------------------------------------------------------
--	SET @ObjectName= @FinancingFacilityName;
--	SET @Object_ObjectAutoID = NULL;
--	-------------------------------------------------------------

	
--	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
--	BEGIN

--		--Update table [App].[SearchItem]
--		Declare @l_objectautoid1 uniqueidentifier = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
--		UPDATE [App].[SearchItem] SET [SearchText] = @FinancingFacilityName  WHERE  [SearchObjectType] = @ObjTy_FinancingFacilityName and Object_ObjectAutoID = @l_objectautoid1
--		----------------------------------

--		UPDATE [App].[Object]
--		SET [ObjectName] = @ObjectName
--			,[ObjectTypeID] = @ObjectTypeID
--			,[StatusID] = @StatusID
--			,[Object_ObjectAutoID] = @Object_ObjectAutoID
--			,[UpdatedBy] = @UpdatedBy
--			,[UpdatedDate] = GETDATE()
--		WHERE [ObjectID] = @ObjectID


--	END
--	ELSE
--	BEGIN
--		DECLARE @ttable3 TABLE (tinsertedID3 UNIQUEIDENTIFIER)
--		DECLARE @InsertedID3 uniqueidentifier;

--		INSERT INTO [App].[Object]
--					([ObjectID]
--					,[ObjectName]
--					,[ObjectTypeID]
--					,[StatusID]
--					,[Object_ObjectAutoID]
--					,[CreatedBy]
--					,[CreatedDate]
--					,[UpdatedBy]
--					,[UpdatedDate])
--		OUTPUT inserted.ObjectAutoID INTO @ttable3(tinsertedID3)
--		VALUES
--		(
--			@ObjectID,
--			@ObjectName,
--			@ObjectTypeID,
--			@StatusID,
--			@Object_ObjectAutoID,
--			@CreatedBy,
--			GETDATE() ,
--			@UpdatedBy ,
--			GETDATE()
--		)
--		SELECT @InsertedID3 = tinsertedID3 FROM @ttable3;

--		--Insert Into [App].[SearchItem]
--		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
--		VALUES(GETDATE(),@InsertedID3,@FinancingFacilityName,0,@ObjTy_FinancingFacilityName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		 
--		----------------------------------
--	END


--	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select FinancingWarehouseID from CRE.FinancingWarehouse) AND  ObjectTypeID = @ObjectTypeID)
--	Delete from [App].[Object] where ObjectID not in (Select FinancingWarehouseID from CRE.FinancingWarehouse) AND  ObjectTypeID = @ObjectTypeID
--END



IF(@LookupIdForLiabilityNote = @ObjectTypeID) --LiabilityNote
BEGIN
	 
	Declare @liabilityNoteID [nvarchar](256); 
	--Declare @LiabilityName [nvarchar](256); 
	--Declare @DealID UNIQUEIDENTIFIER; 

	Select 
	@liabilityNoteID = LiabilityNoteID,
	--@LiabilityName = acc.name ,
	@StatusID = acc.StatusID,
	@DealID = d.DealID
	from CRE.LiabilityNote li
	INNER JOIN CORE.Account acc on acc.AccountID = li.AccountID
	Inner Join CRE.Deal d on d.AccountID = li.DealAccountID
	where LiabilityNoteGUID = @ObjectID and acc.IsDeleted <> 1

	
	-------------------------------------------------------------
	SET @ObjectName= @liabilityNoteID;
	SET @Object_ObjectAutoID = (Select ObjectAutoID From [App].[Object] where [ObjectID] = @DealID)
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN

		--Update table [App].[SearchItem]
		Declare @l_objectautoid_lib uniqueidentifier = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
		UPDATE [App].[SearchItem] SET [SearchText] = @liabilityNoteID  WHERE  [SearchObjectType] = @ObjTy_LiabilityNoteID and Object_ObjectAutoID = @l_objectautoid_lib
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
		DECLARE @ttable_lib TABLE (tinsertedID_lib UNIQUEIDENTIFIER)
		DECLARE @InsertedID_lib uniqueidentifier;

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
		OUTPUT inserted.ObjectAutoID INTO @ttable_lib(tinsertedID_lib)
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
		SELECT @InsertedID_lib = tinsertedID_lib FROM @ttable_lib;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID_lib,@liabilityNoteID,0,@ObjTy_LiabilityNoteID,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())		
		----------------------------------
	END
	

	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (
		Select LiabilityNoteGUID
		from CRE.LiabilityNote li
		INNER JOIN CORE.Account acc on acc.AccountID = li.AccountID		
		where acc.IsDeleted = 0
	) AND  ObjectTypeID = @ObjectTypeID)

	Update [App].[Object]  set Object_ObjectAutoID = null where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (
		Select LiabilityNoteGUID from CRE.LiabilityNote
	) AND  ObjectTypeID = @ObjectTypeID)
	Delete from [App].[Object] where ObjectID not in (Select LiabilityNoteGUID from CRE.LiabilityNote) AND  ObjectTypeID = @ObjectTypeID
END



IF(@LookupIdForDebt = @ObjectTypeID) --debt
BEGIN
	 
	Declare @Debtname [nvarchar](256); 
	Declare @DebtFinancialInstitution [nvarchar](256); 
	

	Select 
	@Debtname = acc.Name,
	@StatusID = acc.StatusID,
	@DebtFinancialInstitution = lb.BankerName + ' (' + acc.name + ')' ---Eq.AbbreviationName 
	from CRE.Debt li
	INNER JOIN CORE.Account acc on acc.AccountID = li.AccountID	
	Left Join cre.LiabilityBanker lb on lb.LiabilityBankerID = li.LiabilityBankerID
	--Left join cre.Equity Eq on Eq.AccountID = li.LinkedFundID
	where DebtGUID = @ObjectID and acc.IsDeleted <> 1

	
	-------------------------------------------------------------
	SET @ObjectName= @Debtname;
	SET @Object_ObjectAutoID = null
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN

		--Update table [App].[SearchItem]
		Declare @l_objectautoid_debt uniqueidentifier = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
		UPDATE [App].[SearchItem] SET [SearchText] = @Debtname  WHERE  [SearchObjectType] = @ObjTy_DebtName and Object_ObjectAutoID = @l_objectautoid_debt
		UPDATE [App].[SearchItem] SET [SearchText] = @DebtFinancialInstitution  WHERE  [SearchObjectType] = @ObjTy_DebtFinancialInstitution and Object_ObjectAutoID = @l_objectautoid_debt
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
		DECLARE @ttable_debt TABLE (tinsertedID_debt UNIQUEIDENTIFIER)
		DECLARE @InsertedID_debt uniqueidentifier;

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
		OUTPUT inserted.ObjectAutoID INTO @ttable_debt(tinsertedID_debt)
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
		SELECT @InsertedID_debt = tinsertedID_debt FROM @ttable_debt;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID_debt,@Debtname,0,@ObjTy_DebtName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())		

		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID_debt,@DebtFinancialInstitution,0,@ObjTy_DebtFinancialInstitution,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())		
		----------------------------------
	END
	

	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (
		Select DebtGUID
		from CRE.Debt li
		INNER JOIN CORE.Account acc on acc.AccountID = li.AccountID		
		where acc.IsDeleted = 0
	) AND  ObjectTypeID = @ObjectTypeID)

	Update [App].[Object]  set Object_ObjectAutoID = null where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (
		Select DebtGUID from CRE.Debt
	) AND  ObjectTypeID = @ObjectTypeID)
	Delete from [App].[Object] where ObjectID not in (Select DebtGUID from CRE.Debt) AND  ObjectTypeID = @ObjectTypeID
END


IF(@LookupIdForEquity = @ObjectTypeID) --Equity
BEGIN
	 
	Declare @Equityname [nvarchar](256); 
	Declare @EquityShortName [nvarchar](256); 


	Select 
	@Equityname = acc.Name,
	@StatusID = acc.StatusID,
	@EquityShortName = Replace(li.AbbreviationName,' ','')
	from CRE.Equity li
	INNER JOIN CORE.Account acc on acc.AccountID = li.AccountID	
	where EquityGUID = @ObjectID and acc.IsDeleted <> 1

	
	-------------------------------------------------------------
	SET @ObjectName= @Equityname;
	SET @Object_ObjectAutoID = null
	-------------------------------------------------------------

	
	IF EXISTS(Select ObjectID from [App].[Object] where ObjectID = @ObjectID)
	BEGIN

		--Update table [App].[SearchItem]
		Declare @l_objectautoid_Equity uniqueidentifier = (Select ObjectAutoID from [App].[Object] where ObjectID = @ObjectID )
		UPDATE [App].[SearchItem] SET [SearchText] = @Equityname  WHERE  [SearchObjectType] = @ObjTy_EquityName and Object_ObjectAutoID = @l_objectautoid_Equity
		UPDATE [App].[SearchItem] SET [SearchText] = @EquityShortName  WHERE  [SearchObjectType] = @ObjTy_EquityShortName and Object_ObjectAutoID = @l_objectautoid_Equity
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
		DECLARE @ttable_Equity TABLE (tinsertedID_Equity UNIQUEIDENTIFIER)
		DECLARE @InsertedID_Equity uniqueidentifier;

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
		OUTPUT inserted.ObjectAutoID INTO @ttable_Equity(tinsertedID_Equity)
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
		SELECT @InsertedID_Equity = tinsertedID_Equity FROM @ttable_Equity;

		--Insert Into [App].[SearchItem]
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID_Equity,@Equityname,0,@ObjTy_EquityName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())	
		
		INSERT INTO [App].[SearchItem]([SearchDate],[Object_ObjectAutoID],[SearchText],[Rank] ,[SearchObjectType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES(GETDATE(),@InsertedID_Equity,@EquityShortName,0,@ObjTy_EquityShortName,@CreatedBy,GETDATE() ,@UpdatedBy ,GETDATE())
		----------------------------------
	END
	

	Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (
		Select EquityGUID
		from CRE.Equity li
		INNER JOIN CORE.Account acc on acc.AccountID = li.AccountID		
		where acc.IsDeleted = 0
	) AND  ObjectTypeID = @ObjectTypeID)

	Update [App].[Object]  set Object_ObjectAutoID = null where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (
		Select EquityGUID from CRE.Equity
	) AND  ObjectTypeID = @ObjectTypeID)

	Delete from [App].[Object] where ObjectID not in (Select EquityGUID from CRE.Equity) AND  ObjectTypeID = @ObjectTypeID
END

END






GO