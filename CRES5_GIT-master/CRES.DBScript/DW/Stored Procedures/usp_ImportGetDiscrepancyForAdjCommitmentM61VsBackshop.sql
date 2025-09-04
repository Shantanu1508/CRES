CREATE PROCEDURE [DW].[usp_ImportGetDiscrepancyForAdjCommitmentM61VsBackshop]
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
    
	
	TRUNCATE TABLE [DW].[tbl_GetDiscrepancyForAdjCommitmentM61VsBackshop];

	INSERT INTO [DW].[tbl_GetDiscrepancyForAdjCommitmentM61VsBackshop](
	[Deal Name]						
	,[Deal ID]						
	,[Note ID]						
	,[Note Name]						
	,[Financing Source]				
	,[Enable M61 Calculation]		
	,[M61_NoteAdjustedTotalCommitment]	
	,[TotalCurrentAdjustedCommitment]
	,[Delta]							
	,[Deal Type]						
	,[Payoff Date])
	Select [Deal Name],[Deal ID],[Note ID],[Note Name],[Financing Source],EnableM61Calculation as [Enable M61 Calculation],[M61_NoteAdjustedTotalCommitment],[TotalCurrentAdjustedCommitment], ([M61_NoteAdjustedTotalCommitment] - TotalCurrentAdjustedCommitment) as Delta,[Deal Type],[Payoff Date]    
	From(    
		Select d.dealname as [Deal Name]    
		,d.credealid as [Deal ID]    
		,n.Crenoteid as [Note ID]    
		,acc.name as [Note Name]     
		,lFinancingSource.FinancingSourceName as [Financing Source]    
		,CAST(ROUND(ISNULL(tblNtAdjusted.NoteAdjustedTotalCommitment,0),2) as decimal(28,2)) as [M61_NoteAdjustedTotalCommitment]    
		,CAST(ROUND(ISNULL(bs.TotalCurrentAdjustedCommitment,0),2) as decimal(28,2)) as TotalCurrentAdjustedCommitment    
		,l.Name as EnableM61Calculation    
		,ldealStatus.name as [Deal Type]    
		,n.ActualPayoffDate as [Payoff Date]    
		from cre.note n     
		inner join core.account acc on acc.accountid = n.account_accountid      
		inner join cre.deal d on d.dealid = n.dealid      
		Left Join core.lookup l on l.lookupid = ISNULL(n.EnableM61Calculations,3)    
		Left Join cre.FinancingSourceMaster lFinancingSource on lFinancingSource.FinancingSourceMasterID = n.FinancingSourceID    
		Left Join core.lookup ldealStatus on ldealStatus.lookupid = d.[status]    
		Left Join(        
			Select NoteID,CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment    
			From(       
				SELECT d.CREDealID    
				,n.CRENoteID    
				,Date as Date    
				,nd.Type as Type    
				,NoteAdjustedTotalCommitment    
				,NoteTotalCommitment    
				,nd.NoteID    
				,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,    
				nd.Rowno    
				from cre.NoteAdjustedCommitmentMaster nm    
				left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID    
				right join cre.deal d on d.DealID=nm.DealID    
				Right join cre.note n on n.NoteID = nd.NoteID    
				inner join core.account acc on acc.AccountID = n.Account_AccountID    
				where d.IsDeleted<>1 and acc.IsDeleted<>1    
				and d.[status] = 323  
				and date <= cast(getdate() as date)    
				AND d.DealName NOT LIKE '%copy%'
				--and n.crenoteid in ( '10049')     
			)a    
			where rno =  1    
		)tblNtAdjusted on tblNtAdjusted.NoteID = n.NoteID    
 
		Left Join(    
		--Select Distinct ControlId,NoteId,TotalCommitment,TotalCurrentAdjustedCommitment    
		--from [EX_RH_vw_AcctNote]     
   
			Select ControlID,bs.NoteId,TotalCurrentCommitment as TotalCurrentAdjustedCommitment,CurrentUnpaidBalance as [BS_CurrentBls]     
			from @tblBSdata bs    
			inner join cre.note n on n.crenoteid = bs.noteid    
			Inner join core.account acc on acc.accountid = n.account_accountid    
			where acc.isdeleted <> 1    
   
		)bs on CAST(bs.NoteID as nvarchar(256)) = n.crenoteid    
 
		Where acc.isdeleted <> 1    
		and d.[status] = 323  
		and n.ActualPayoffDate is null
		AND d.DealName NOT LIKE '%copy%'
	)a    
	where 
	ABS([M61_NoteAdjustedTotalCommitment] - TotalCurrentAdjustedCommitment) > 1
	ORDER BY [Deal Name],[Deal ID],[Note ID];

	UPDATE [DW].[tbl_GetDiscrepancyForAdjCommitmentM61VsBackshop] SET [LastUpdatedDate]=GETDATE();
END
GO