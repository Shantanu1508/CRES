 

CREATE PROCEDURE [Core].[usp_AddUpdatePortfolio] 
(
@PortfolioID uniqueidentifier,   
@PortfoliName nvarchar(256),   
@Description nvarchar(2000),   
@PoolIDs nvarchar(1000),
@ClientIDs nvarchar(1000),
@FundIDs nvarchar(1000),
@UserID nvarchar(256),
@AllowWholeDeal bit,
@FinancingSourceIDs nvarchar(1000),
@Status int OUTPUT
)	
AS
BEGIN
DECLARE @PortfolioMasterID int

BEGIN TRY
BEGIN TRANSACTION 
--@Status  1- already exist, 0-success,2-fail
IF EXISTS(select 1 from [Core].[PortfolioMaster] where RTRIM(LTRIM(PortfoliName)) = RTRIM(LTRIM(@PortfoliName)))
  and
 (@PortfolioID='00000000-0000-0000-0000-000000000000' or @PortfolioID is null)
 BEGIN
   SET @Status = 1 
 END
--insert
ELSE 
BEGIN
if(@PortfolioID='00000000-0000-0000-0000-000000000000' or @PortfolioID is null)
BEGIN
	INSERT INTO [Core].[PortfolioMaster]
           ([PortfoliName]
           ,[Description]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,[AllowWholeDeal])
     VALUES
           (@PortfoliName
           ,@Description
           ,@UserID
           ,getdate()
           ,@UserID
           ,getdate()
		   ,@AllowWholeDeal)
   select @PortfolioMasterID = scope_identity()
 END
   ELSE --update
BEGIN

	UPDATE [Core].[PortfolioMaster]
	SET 
	PortfoliName = @PortfoliName,
	Description = @Description,
	UpdatedBy = @UserID ,
	UpdatedDate = getdate(),
	AllowWholeDeal = @AllowWholeDeal
	WHERE PortfolioMasterGuid = @PortfolioID
	SELECT @PortfolioMasterID =(select top 1 PortfolioMasterID from [Core].[PortfolioMaster] where PortfolioMasterGuid = @PortfolioID)
END

	--delete existing entries

	delete from [Core].[PortfolioDetail] where PortfolioMasterID=@PortfolioMasterID and ObjectTypeID in ('511','510','574','633')
	
	--insert for pool
	IF (@PoolIDs IS NOT NULL AND @PoolIDs<>'')
	BEGIN
	INSERT INTO [Core].[PortfolioDetail]
           ([PortfolioMasterID]
           ,[ObjectTypeID]
           ,[ObjectID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     select 
            @PortfolioMasterID
           ,511
           ,Value
           ,@UserID
           ,getdate()
           ,@UserID
           ,getdate()
		   from dbo.fn_Split(@PoolIDs)
     END
	 --insert for client
	 IF (@ClientIDs IS NOT NULL AND @ClientIDs<>'')
	 BEGIN
	INSERT INTO [Core].[PortfolioDetail]
           ([PortfolioMasterID]
           ,[ObjectTypeID]
           ,[ObjectID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     select 
            @PortfolioMasterID
           ,510
           ,Value
           ,@UserID
           ,getdate()
           ,@UserID
           ,getdate()
		   from dbo.fn_Split(@ClientIDs)
	 END
	  --insert for fund
	 IF (@FundIDs IS NOT NULL AND @FundIDs<>'')
	 BEGIN
	INSERT INTO [Core].[PortfolioDetail]
           ([PortfolioMasterID]
           ,[ObjectTypeID]
           ,[ObjectID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     select 
            @PortfolioMasterID
           ,574
           ,Value
           ,@UserID
           ,getdate()
           ,@UserID
           ,getdate()
		   from dbo.fn_Split(@FundIDs)
	 END
	  --insert for financing source
	 IF (@FinancingSourceIDs IS NOT NULL AND @FinancingSourceIDs<>'')
	 BEGIN
	INSERT INTO [Core].[PortfolioDetail]
           ([PortfolioMasterID]
           ,[ObjectTypeID]
           ,[ObjectID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     select 
            @PortfolioMasterID
           ,633
           ,Value
           ,@UserID
           ,getdate()
           ,@UserID
           ,getdate()
		   from dbo.fn_Split(@FinancingSourceIDs)
	 END
    SET @Status = 0
END

COMMIT
END TRY
BEGIN CATCH
        ROLLBACK
		SET @Status=2
END CATCH
END

