


CREATE PROCEDURE dbo.usp_InsertUpdateFinancingWarehouse 
(
	@FinancingWarehouseid UNIQUEIDENTIFIER ,
	@AccountId UNIQUEIDENTIFIER ,
    @Name varchar(256),
	@StatusId int,
	@BaseCurrency int,
	@PayFrequency int,	
	@IsRevolvingId int,
	@OriginationFee decimal(28,15),
	@TotalConstraint decimal(28,15),
	@CreatedBy  varchar(256) ,
	@CreatedDate datetime,
	@UpdatedBy varchar(256) ,
	@UpdatedDate datetime,
	@NewFinancingWarehouseid Varchar(50) OUTPUT
)
	
AS
BEGIN
    SET NOCOUNT ON;
    declare @AccountTypeID int
	
	DECLARE @insertedAccountID uniqueidentifier;
	DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)

	DECLARE @insertedFinancingWarehouseId uniqueidentifier;
	DECLARE @tFinancing TABLE (colFinancingWarehouseid UNIQUEIDENTIFIER)

	set @AccountTypeID=(select LookupID from Core.Lookup where Name like '%Financing Facility%')
	
	if @FinancingWarehouseid='00000000-0000-0000-0000-000000000000'
	Begin
	INSERT INTO Core.Account
	 (StatusID
	,Name
	,BaseCurrencyID	
	,PayFrequency
	,AccountTypeID
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate)
	OUTPUT inserted.AccountID INTO @tAccount(tAccountID)
	VALUES
	(@statusID,
	@Name,
	@BaseCurrency,
	@PayFrequency,
	@AccountTypeID,	
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GetDATE())


	SELECT @insertedAccountID = tAccountID FROM @tAccount;

	INSERT INTO CRE.FinancingWarehouse(
	Account_AccountID,
	IsRevolving ,
	OriginationFee ,
	TotalConstraint ,
	CreatedBy,
	CreatedDate ,
	UpdatedBy ,
	UpdatedDate)
		OUTPUT inserted.FinancingWarehouseID INTO @tFinancing(colFinancingWarehouseid)
	VALUES
	(
	 @insertedAccountID,
	 @IsRevolvingId,
	 @OriginationFee,
	 @TotalConstraint,
	 @CreatedBy,
	 GETDATE(),
	 @UpdatedBy,
	  GETDATE())

	  SELECT @NewFinancingWarehouseid = colFinancingWarehouseid FROM @tFinancing;
	--  SET @NewFinancingWarehouseid =SELECT  colFinancingWarehouseid FROM @tFinancing;

	END


	ELSE

	BEGIN


	update Core.Account 
	Set
	StatusID=@statusID,
	Name=@Name,
	BaseCurrencyID=@BaseCurrency,
	PayFrequency=@PayFrequency,
	UpdatedBy=@UpdatedBy,
	updateddate=GETDATE()
	where AccountID=@AccountId


	update	CRE.FinancingWarehouse
	set 	
	IsRevolving=@IsRevolvingId,
	OriginationFee=@OriginationFee,
	TotalConstraint =@TotalConstraint,	
	UpdatedBy=@UpdatedBy ,
	UpdatedDate=GETDATE()
	where FinancingWarehouseid=@FinancingWarehouseid

	  SET @NewFinancingWarehouseid =@FinancingWarehouseid
	END
	 
END






