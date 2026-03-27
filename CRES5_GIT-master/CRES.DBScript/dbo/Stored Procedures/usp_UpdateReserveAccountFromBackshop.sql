-- Procedure
CREATE PROCEDURE [dbo].[usp_UpdateReserveAccountFromBackshop]
(
@DealIDOrCREDealID NVARCHAR(256) = null,
@userID NVARCHAR(256) = null
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CREDealID NVARCHAR (256) 
	
	--Declare @userID UniqueIdentifier;
	IF (@userID is null or @userID='')
	BEGIN
		SET @userID = '3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50';
	END

	IF (@DealIDOrCREDealID!='') 
	BEGIN
	 IF (len(@DealIDOrCREDealID)=36)
		SELECT @CREDealID=CREDealID from cre.Deal where DealID=@DealIDOrCREDealID
	 ELSE 
		SET @CREDealID=@DealIDOrCREDealID
	END
	
	IF OBJECT_ID('tempdb..#tblEscrow') IS NOT NULL         
	DROP TABLE #tblEscrow

	CREATE TABLE #tblEscrow( 
		[EscrowId_F]	int NULL,
		[EscrowTransactionId]	int NULL,
		[ControlId]	nvarchar(256) NULL,
		[Source]	int NULL,
		[EscrowTypeCode]	nvarchar(256) NULL,
		[EscrowTypeDesc] 	nvarchar(256) NULL,
		[AccountName]		nvarchar(256) NULL,
		[Date]	date NULL,	
		[InitialBalance]	nvarchar(256) NULL,--decimal(28,15) NULL,
		[CurrentBalance]	nvarchar(256) NULL,--decimal(28,15) NULL,
		[ShardName]	nvarchar(256) NULL,
		[DealID] UNIQUEIDENTIFIER
	)
	IF OBJECT_ID('tempdb..#tblCREDealID') IS NOT NULL         
	DROP TABLE #tblCREDealID

	CREATE TABLE #tblCREDealID( 
		[CREDealID]	nvarchar(256) NULL,
	)

	IF(isnull(@CREDealID,'')<>'')
	BEGIN
	    INSERT INTO #tblCREDealID
		SELECT Distinct CREDealID FROM CRE.Deal d inner join cre.note n on n.dealid =d.DealID
		where IsDeleted=0 and CREDealID = @CREDealID
	END
	ELSE
	BEGIN
	    INSERT INTO #tblCREDealID
		SELECT Distinct CREDealID FROM CRE.Deal d inner join cre.note n on n.dealid =d.DealID
		where IsDeleted=0 and n.ActualPayoffDate is null
	END

	Declare @param nvarchar(256);
	Declare @DealID nvarchar(256)
	DECLARE cur CURSOR FOR

	SELECT Distinct CREDealID FROM #tblCREDealID

	OPEN cur  
	FETCH NEXT FROM cur INTO @DealID

		WHILE @@Fetch_Status = 0 
		BEGIN
			Set @param  = N'EXEC [acore].[spEscrowBalancesForM61] @controlid = ''' + @DealID + '''';
  
			INSERT INTO #tblEscrow (EscrowId_F,EscrowTransactionId,ControlId,Source,EscrowTypeCode,EscrowTypeDesc,AccountName,Date,InitialBalance,CurrentBalance,ShardName)
			EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @param;

			FETCH NEXT FROM cur INTO @DealID

		End 

	Close cur
	Deallocate cur

	Update temp Set 
	temp.InitialBalance = (CASE When temp.InitialBalance = 'NULL' Then NULL ELSE temp.InitialBalance END),
	temp.CurrentBalance = (CASE When temp.CurrentBalance = 'NULL' Then NULL ELSE temp.CurrentBalance END)
	From #tblEscrow temp INNER JOIN tblEscrow esc ON temp.EscrowId_F = esc.EscrowId;

	Update temp Set temp.DealID = D.DealID
	From #tblEscrow temp INNER JOIN CRE.Deal D ON temp.ControlId = D.CREDealID;

	INSERT INTO [CRE].[ReserveAccountMaster] (ReserveAccountName)
	SELECT AccountName FROM #tblEscrow WHERE AccountName NOT IN (SELECT ReserveAccountName FROM [CRE].[ReserveAccountMaster])


	Update R Set 
	R.EstimatedReserveBalance = CAST(t.CurrentBalance as Decimal(28,15)),
	R.AsofDate = t.[Date]
	From CRE.ReserveAccount R 
	INNER JOIN [CRE].[ReserveAccountMaster] RM ON R.ReserveAccountMasterID = RM.ReserveAccountMasterID
	INNER JOIN #tblEscrow t ON t.DealID = R.DealID 
	AND t.AccountName = RM.ReserveAccountName

	INSERT INTO CRE.ReserveAccount(CREReserveAccountID,DealID,ReserveAccountMasterID,InitialBalanceDate,InitialFundingAmount,EstimatedReserveBalance,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AsofDate)
	Select 0,DealID,ReserveAccountMasterID,[Date],CAST(InitialBalance as Decimal(28,15)),CAST(CurrentBalance as Decimal(28,15)),@userID,GETDATE(),@userID,GETDATE(),[Date]
	from (
		Select E.DealID,RM.ReserveAccountMasterID,E.[Date],ISNULL(E.InitialBalance, E.CurrentBalance) as InitialBalance,E.CurrentBalance,R.DealID as 'NULLDeal'
		from #tblEscrow E LEFT JOIN CRE.ReserveAccount R ON E.DealID = R.DealID
		LEFT JOIN [CRE].[ReserveAccountMaster] RM ON E.AccountName = RM.ReserveAccountName
	) Res WHERE NULLDeal IS NULL
END