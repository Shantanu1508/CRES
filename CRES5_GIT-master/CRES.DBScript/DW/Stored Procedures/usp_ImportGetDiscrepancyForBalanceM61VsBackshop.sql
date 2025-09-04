CREATE PROCEDURE [DW].[usp_ImportGetDiscrepancyForBalanceM61VsBackshop]
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Declare @tblBSdata as table
	(
		ControlId nvarchar(256) null,
		noteid nvarchar(256) null,
		TotalCurrentCommitment money null,  
		CurrentUnpaidBalance money null,  
		ShardName nvarchar(256) null
	)
	INSERT INTO @tblBSdata (ControlId,noteid,TotalCurrentCommitment,CurrentUnpaidBalance,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
	@stmt = N'SELECT ControlId_F,noteid_F,TotalCurrentCommitment,CurrentUnpaidBalance 
	FROM acorelib.udf_NoteMetrics(NULL, NULL, GETDATE(), 1) '


	Declare @tblNPC as table
	(
		NoteID UNIQUEIDENTIFIER,
		EndingBalance  decimal(28,15) null,
		PeriodEndDate Date
	)
	INSERT INTO @tblNPC (NoteID,PeriodEndDate,EndingBalance)
	Select n.noteid,nc.PeriodEndDate,nc.EndingBalance 
	from cre.NotePeriodicCalc nc
	Inner join core.account acc on acc.accountid = nc.AccountID
	Inner join cre.note n on n.account_accountid = acc.accountid
	inner join cre.deal d on d.DealID = n.DealID
	--Inner join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1  and acc.AccounttypeID = 1 and d.[Status] = 323
	and Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     
	and n.ActualPayoffDate is null	
	AND d.DealName NOT LIKE '%copy%'
  
	----======================================================


	TRUNCATE TABLE [DW].[tbl_GetDiscrepancyForBalanceM61VsBackshop];

	INSERT INTO [DW].[tbl_GetDiscrepancyForBalanceM61VsBackshop](
	[Deal Name]		
	,[Deal ID]		
	,[Note ID]		
	,[Note Name]		
	,[Financing Source]
	,[M61_CurrentBls]
	,[BS_CurrentBls]	
	,[Delta]			
	,[Payoff Date])
		Select [Deal Name],[Deal ID],[Note ID],[Note Name],[Financing Source],[M61_CurrentBls],[BS_CurrentBls], ([M61_CurrentBls] - [BS_CurrentBls]) as Delta,ActualPayoffDate as [Payoff Date]
	From(
	Select d.dealname as [Deal Name]
	,d.credealid as [Deal ID]
	,n.Crenoteid as [Note ID]
	,acc.name as [Note Name]
	,lFinancingSource.FinancingSourceName as [Financing Source]

	,CAST(ROUND(tblCurrNPC.EndingBalance,2) as decimal(28,2)) as [M61_CurrentBls]
	--,(CASE WHEN CAST(ROUND(n.InitialFundingAmount,2) as decimal(28,2)) = 0.01 THEN CAST(ROUND(tblCurrNPC.EndingBalance,2) as decimal(28,2)) - 0.01 ELSE CAST(ROUND(tblCurrNPC.EndingBalance,2) as decimal(28,2)) END)  as [M61_CurrentBls]
	,CAST(ROUND(bs.[BS_CurrentBls],2) as decimal(28,2)) [BS_CurrentBls]
	,n.ActualPayoffDate
	from cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid  
	inner join cre.deal d on d.dealid = n.dealid  
	Left Join cre.FinancingSourceMaster lFinancingSource on lFinancingSource.FinancingSourceMasterID = n.FinancingSourceID
	Left Join(    
		
		---Select noteid,EndingBalance from @tblNPC
		Select noteid,EndingBalance from(    
			Select nc.noteid,EndingBalance ,ROW_NUMBER() Over(Partition by nc.noteid order by nc.noteid,PeriodEndDate desc) rno    
			from @tblNPC nc			
			where EndingBalance is not null   
			and PeriodEndDate <= Cast(getdate() as Date)  				
		)a where rno = 1   


	)tblCurrNPC on tblCurrNPC.NoteID = n.NoteID
	Left Join(
		--Select Distinct ControlId,NoteId,[Current UPB] as [BS_CurrentBls]
		--from [EX_RH_vw_AcctNote] 

		Select ControlID,bs.NoteId,TotalCurrentCommitment as TotalCurrentAdjustedCommitment,CurrentUnpaidBalance as [BS_CurrentBls] 
		from @tblBSdata bs
		inner join cre.note n on n.crenoteid = bs.noteid
		Inner join core.account acc on acc.accountid = n.account_accountid
		where acc.isdeleted <> 1

	)bs on CAST(bs.NoteID as nvarchar(256)) = n.crenoteid

	Where acc.isdeleted <> 1
	and n.ActualPayoffDate is null
	and d.[Status] = 323
	AND d.DealName NOT LIKE '%copy%'
	)a

	where ABS([M61_CurrentBls] - [BS_CurrentBls]) > 1

	ORDER BY [Deal Name],[Deal ID],[Note ID];

	UPDATE [DW].[tbl_GetDiscrepancyForBalanceM61VsBackshop] SET [LastUpdatedDate]=GETDATE();
END