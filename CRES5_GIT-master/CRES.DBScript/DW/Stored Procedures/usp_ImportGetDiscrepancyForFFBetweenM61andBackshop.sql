CREATE PROCEDURE [DW].[usp_ImportGetDiscrepancyForFFBetweenM61andBackshop]
AS
BEGIN

	SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 

 	Declare @Cutoffdate date = CAST((select [Value] from app.appconfig where [key] = 'CutOffDate_BackshopExport') as date)

 
	DECLARE @BackshopNotes TABLE    
	(    
	crenoteid nvarchar(256) null,  
	ShardName nvarchar(256) null    
	)  
	DECLARE @query1 nvarchar(MAX) = N'Select Distinct noteid from [acore].[vw_AcctNote]'    
 
	INSERT INTO @BackshopNotes (CRENoteID,ShardName)    
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',@stmt = @query1  
	--==============================================================================  
 
	DECLARE @BackshopFF TABLE    
	(    
	 CRENoteID nvarchar(256) null,    
	 FundingDate Date null,    
	 FundingAmount decimal(28 ,15) null,    
	 Comments nvarchar(256) null,    
	 FundingPurpose nvarchar(256) null,    
	 Applied bit null,    
	 WireConfirm bit null,    
	 DrawFundingId nvarchar(256) null,    
	 ShardName nvarchar(256) null    
	)    
 
	DECLARE @query2 nvarchar(MAX) = N'Select CAST(NoteID_f as varchar(256)),FundingDate,FundingAmount,'''' as Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingDrawId     
	from [acore].[vw_AcctNoteFundings] where FundingDate > '''+ CAST(@Cutoffdate as nvarchar(256)) +''' and   FundingPurposeCD_F not in (''PIKNC'',''PIKPP'') and NoteID_f in (Select Distinct noteid from [acore].[vw_AcctNote])  '    
   
	---- 
 
	INSERT INTO @BackshopFF (CRENoteID,FundingDate,FundingAmount,Comments,FundingPurpose,Applied,WireConfirm,DrawFundingId,ShardName)    
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',     
	@stmt = @query2  
 
	--Select * from @BackshopFF  
	--=================================================  
 
	DECLARE @M61FF TABLE    
	(    
	 CRENoteID nvarchar(256) null,    
	 FundingDate Date null,    
	 FundingAmount decimal(28 ,15) null,    
	 Comments nvarchar(256) null,    
	 FundingPurpose nvarchar(256) null,    
	 Applied bit null,    
	 WireConfirm bit null,    
	 DrawFundingId nvarchar(256) null    
	)    
 
	INSERT INTO @M61FF (CRENoteID,FundingDate,FundingAmount,Comments,FundingPurpose,Applied,WireConfirm,DrawFundingId)   
  
	Select  CRENoteID,FundingDate,FundingAmount,Comments,[FundingPurpose],[Applied],[WireConfirm],DrawFundingId  
	From(  
	Select n.CRENoteID    
	 ,fs.[Date] as FundingDate    
	 ,fs.Value as FundingAmount    
	 ,fs.Comments    
	 ,(CASE LPurposeID.name  
	  WHEN 'Property Release' THEN 'PROPREL'  
	  WHEN 'Payoff/Paydown' THEN 'PAYOFF'  
	  WHEN 'Additional Collateral Purchase' THEN 'ADDCOLLPUR'  
	  WHEN 'Capital Expenditure' THEN 'CAPEXPEN'  
	  WHEN 'Debt Service / Opex' THEN 'DSOPEX'  
	  WHEN 'TI/LC' THEN 'TILCDRAW'  
	  WHEN 'Other' THEN 'OTHER'  
	  WHEN 'Amortization' THEN 'AMORT'  
	  --WHEN 'Capitalized Interest (Complex)' THEN 'CAPINTC'  
	  --WHEN 'Capitalized Interest (Non-Complex)' THEN 'CAPINTN'  
	  WHEN 'OpEx' THEN 'OPEX'  
	  WHEN 'Force Funding' THEN 'FORCEFUND'  
	  WHEN 'Capitalized Interest' THEN 'CAPINTC'  
	  WHEN 'Full Payoff' THEN 'FULLPAY'  
	  WHEN 'Note Transfer' THEN 'NOTETRAN'   
	  WHEN 'Paydown' THEN 'PAYDOWN'  
	  WHEN 'Principal Writeoff' THEN 'PWRITEOFF'
	  WHEN 'Net Property Income/Loss' THEN 'NETINCLOSS'	
	  WHEN 'Equity Distribution' THEN 'EQUITYDIST'
	  END  
	  )as [FundingPurpose]   
	 ,1 as [Applied]    
	 ,fs.[Applied] as [WireConfirm]    
	 ,fs.DrawFundingId    
	 ,(case when LPurposeID.name = 'PAYDOWN' and  fs.[GeneratedBy] = 747 then 1 else 0 end) as isIgnore  
	from [CORE].FundingSchedule fs    
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId    
	INNER JOIN     
	 (    
         
	 Select     
	  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID and ac.IsDeleted=0) AccountID ,    
	  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID    
	  from [CORE].[Event] eve    
	  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
	  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
	  where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')    
	  --and n.CRENoteID = @CRENoteId   
	  and acc.IsDeleted=0    
	  and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)    
	  GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID    
   
	 ) sEvent    
   
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID     
	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID    
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID     
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
	where sEvent.StatusID = e.StatusID and acc.IsDeleted=0    
	and fs.[Date] > @Cutoffdate
  
	and n.CRENoteID in (Select CRENoteID from @BackshopNotes) and n.Actualpayoffdate is null  
 
	)b where isIgnore = 0  


	TRUNCATE TABLE [DW].[tbl_GetDiscrepancyForFFBetweenM61andBackshop];

	INSERT INTO [DW].[tbl_GetDiscrepancyForFFBetweenM61andBackshop](
	[Deal Name]				
	,[Deal ID]				
	,[Note ID]				
	,[M61 Funding Date]		
	,[M61 Funding Amount]	
	,[BS Funding Date]		
	,[BS Funding Amount]		
	,[Delta])

	Select * from(
		Select  dealname as [Deal Name],  
		credealid as [Deal ID],  
		CRENoteID as [Note ID],  
		CONVERT(varchar, M61_FundingDate, 101) as [M61 Funding Date],  
		Cast(ROUND(M61_FundingAmount,2) as decimal(28,2))  as [M61 Funding Amount],  
		CONVERT(varchar, BS_FundingDate, 101) as [BS Funding Date],  
		Cast(ROUND(BS_FundingAmount,2) as decimal(28,2))  as [BS Funding Amount],  
		Cast(ROUND((M61_FundingAmount - BS_FundingAmount),2) as decimal(28,2)) Delta  
		From(  
			Select d.dealname,d.credealid  
			,m61.CRENoteID,m61.FundingDate as M61_FundingDate,SUM(m61.FundingAmount) as M61_FundingAmount,bs.FundingDate as BS_FundingDate,bs.FundingAmount as BS_FundingAmount  
			from @M61FF m61  
			left join (   
				Select CRENoteID,FundingDate,SUM(FundingAmount) FundingAmount  from @BackshopFF  
				group by CRENoteID,FundingDate  
			)  
			bs on m61.CRENoteID = bs.CRENoteID and m61.FundingDate = bs.FundingDate  
			inner join cre.note n on n.crenoteid = m61.CreNoteID  
			inner join cre.deal d on d.dealid = n.dealid  
  
			where d.IsDeleted <> 1 and d.[Status] = 323
			and  d.DealName NOT LIKE '%copy%'
			group by m61.CRENoteID,  
			m61.FundingDate,  
			bs.FundingDate ,d.dealname,d.credealid,bs.FundingAmount  
		)a  
	)b  
	where ROUND(isNuLL(Delta,1),2) <> 0;

	UPDATE [DW].[tbl_GetDiscrepancyForFFBetweenM61andBackshop] SET [LastUpdatedDate]=GETDATE();
END