--IF OBJECT_ID('tempdb..#tblEscrow') IS NOT NULL         
--DROP TABLE #tblEscrow

--CREATE TABLE #tblEscrow( 
--	[EscrowId_F]	int NULL,
--	[EscrowTransactionId]	int NULL,
--	[ControlId]	nvarchar(256) NULL,
--	[Source]	int NULL,
--	[EscrowTypeCode]	nvarchar(256) NULL,
--	[EscrowTypeDesc] 	nvarchar(256) NULL,
--	[AccountName]		nvarchar(256) NULL,
--	[Date]	date NULL,	
--	[InitialBalance]	nvarchar(256) NULL,--decimal(28,15) NULL,
--	[CurrentBalance]	nvarchar(256) NULL,--decimal(28,15) NULL,
--	[ShardName]	nvarchar(256) NULL,
--	[DealID] UNIQUEIDENTIFIER
--)
--Declare @param nvarchar(256);
		
--Declare @DealID nvarchar(256)
--DECLARE cur CURSOR FOR

--SELECT CREDealID FROM CRE.Deal
--where DealID IN (Select Distinct DealID from CRE.ReserveAccount)

--OPEN cur  
--FETCH NEXT FROM cur INTO @DealID

--	WHILE @@Fetch_Status = 0 
--	BEGIN
			
--		Set @param  = N'EXEC [acore].[spEscrowBalancesForM61] @controlid = ''' + @DealID + '''';

--		INSERT INTO #tblEscrow (EscrowId_F,EscrowTransactionId,ControlId,Source,EscrowTypeCode,EscrowTypeDesc,AccountName,Date,InitialBalance,CurrentBalance,ShardName)
--		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @param;

--		FETCH NEXT FROM cur INTO @DealID

--	End 

--Close cur
--Deallocate cur

--Update temp Set temp.DealID = D.DealID
--From #tblEscrow temp INNER JOIN CRE.Deal D ON temp.ControlId = D.CREDealID;

--Update R Set R.ReserveAccountName = E.AccountName
--from #tblEscrow E INNER JOIN CRE.ReserveAccount R ON E.DealID = R.DealID 
--AND R.ReserveAccountName = ISNULL(E.EscrowTypeDesc,E.EscrowTypeCode)
--AND E.AccountName <> R.ReserveAccountName