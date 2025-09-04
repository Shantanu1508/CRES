--[dbo].[usp_GetDiscrepancyForExport_ByDealID] '7e1af9ce-4354-4e06-bfcc-4bd1b8dd78d2',null,'B0E6697B-3534-4C09-BE0A-04473401AB93','Projection'
--[dbo].[usp_GetDiscrepancyForExport_ByDealID] '7e1af9ce-4354-4e06-bfcc-4bd1b8dd78d2',null,'B0E6697B-3534-4C09-BE0A-04473401AB93','FF'
--[dbo].[usp_GetDiscrepancyForExport_ByDealID] null,'77b6e8f8-4363-4b34-8850-08672774973e','B0E6697B-3534-4C09-BE0A-04473401AB93','pIK'


CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForExport_ByDealID]   
(  
 @DealID nvarchar(256),  
 @noteid nvarchar(256) = null,  
 @userID nvarchar(256),
 @verificationFor nvarchar(50)
)  
AS  
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	  	Declare @Cutoffdate date = CAST((select [Value] from app.appconfig where [key] = 'CutOffDate_BackshopExport') as date)


	Declare @CRENoteId nvarchar(256)
	Declare @credealid nvarchar(256);
	Declare @IsProjected int = 0;
	Declare @userName nvarchar(256);
	
	SET @userName = (Select top 1 [login] from app.[user] where UserID = @userID)
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

	DECLARE @query2 nvarchar(MAX);
	
	IF(@verificationFor = 'FF')
	BEGIN	
		SET @credealid = (Select top 1 credealid from cre.deal where dealid = @DealID)

		SET @query2 = N'Select CAST(NoteID_f as varchar(256)),FundingDate,FundingAmount,'''' as Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingDrawId   
		from [acore].[vw_AcctNoteFundings] where FundingDate > '''+ CAST(@Cutoffdate as nvarchar(256)) +''' and FundingPurposeCD_F not in (''PIKNC'',''PIKPP'') and NoteID_f in (Select Distinct noteid from [acore].[vw_AcctNote] where ControlId = '''+@credealid+''')  '  
	END
	IF(@verificationFor = 'Projection')
	BEGIN	
		SET @credealid = (Select top 1 credealid from cre.deal where dealid = @DealID)

		SET @query2 = N'Select  Distinct CAST(NoteID_f as varchar(256)) as NoteID_f
		,[PaymentDate] as FundingDate
		,[Amount] as FundingAmount
		,'''' as Comments
		,FundingPurposeCD_F
		,0 Applied
		,0 WireConfirm
		,'''' FundingDrawId   
		from [acore].[vw_AcctNoteProjectedPayments] 
		where PaymentDate > '''+ CAST(@Cutoffdate as nvarchar(256)) +'''
		and FundingPurposeCD_F not in (''PIKNC'',''PIKPP'')
		and NoteID_f in (Select Distinct noteid from [acore].[vw_AcctNote] where ControlId = '''+@credealid+''')  '
	END
	IF(@verificationFor = 'PIK')
	BEGIN	
		
		SET @CRENoteId = (Select crenoteid from cre.note where noteid = @noteid)
		
		SET @query2 = N'Select Distinct CAST(NoteID_f as varchar(256)),FundingDate,FundingAmount,'''' as Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingDrawId   
		from [acore].[vw_AcctNoteFundings] where FundingDate > '''+ CAST(@Cutoffdate as nvarchar(256)) +''' and FundingPurposeCD_F in (''PIKNC'',''PIKPP'')  and NoteID_f = '''+ @CRENoteId +''' ' 
	END



	INSERT INTO @BackshopFF (CRENoteID,FundingDate,FundingAmount,Comments,FundingPurpose,Applied,WireConfirm,DrawFundingId,ShardName)  
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',   
	@stmt = @query2

	--Select * from @BackshopFF
	--=================================================

	IF(@verificationFor = 'Projection')
	BEGIN	
		SET @IsProjected = 1;
	END

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

	IF(@verificationFor = 'PIK')
	BEGIN
		INSERT INTO @M61FF (CRENoteID,FundingDate,FundingAmount,Comments,FundingPurpose,Applied,WireConfirm,DrawFundingId)	
		Select 
		n.[CRENoteID]
		,tr.[Date] as FundingDate
		,(tr.[Amount] * -1) as FundingAmount
		,tr.Comment as Comments
		,(CASE [type]		
		WHEN 'PIKPrincipalFunding' THEN 'PIKNC'	
		WHEN 'PIKPrincipalPaid' THEN 'PIKPP'	
		END
		)as FundingPurpose		
		,1 as [Applied]
		,1 as [WireConfirm]
		,null as [DrawFundingId]
		from cre.transactionentry tr
		Inner join core.Account acc on acc.AccountID = tr.AccountID
		inner join cre.note n on n.Account_AccountID = acc.AccountID
		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid') 
		and n.noteid = @noteid
		and tr.[Date] > @Cutoffdate
		and acc.AccountTypeID =  1
	END
	ELSE
	BEGIN

		SET @credealid = (Select top 1 credealid from cre.deal where dealid = @DealID)

		DECLARE @BackshopNotes TABLE  
		(  
		crenoteid nvarchar(256) null,
		ShardName nvarchar(256) null  
		)
		DECLARE @query1 nvarchar(MAX) = N'Select Distinct noteid from [acore].[vw_AcctNote] where ControlId = '''+@credealid+''' '  

		INSERT INTO @BackshopNotes (CRENoteID,ShardName)  
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',   
		@stmt = @query1
		--=================================

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
				END
				)as [FundingPurpose] 
			,1 as [Applied]  
			,fs.[Applied] as [WireConfirm]  
			,fs.DrawFundingId  
			,(case when LPurposeID.name = 'PAYDOWN' and  fs.[GeneratedBy] = 747 then 1 else 0 end) as IsProjected
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
				and n.dealid = @DealID 
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
		and n.dealid = @DealID
	
		and n.CRENoteID in (Select CRENoteID from @BackshopNotes)

		)b where IsProjected = @IsProjected

	END

	---=============================
	Declare @tblDiscrepancy as Table(
		Dealname nvarchar(256),
		credealid nvarchar(256),
		CRENoteID nvarchar(256),
		noteid UNIQUEIDENTIFIER,
		M61_FundingDate Date,
		M61_FundingAmount decimal(28,15),
		BS_FundingDate date,
		BS_FundingAmount  decimal(28,15),
		Delta  decimal(28,15)
	)

	

	Insert into @tblDiscrepancy(Dealname,credealid,CRENoteID,noteid,M61_FundingDate,M61_FundingAmount,BS_FundingDate,BS_FundingAmount,Delta)
	Select Dealname,credealid,CRENoteID,noteid,M61_FundingDate,M61_FundingAmount,BS_FundingDate,BS_FundingAmount,Delta 
	from(
		Select  dealname,
				credealid,
				CRENoteID,
				noteid,
				M61_FundingDate,
				M61_FundingAmount,
				BS_FundingDate,
				BS_FundingAmount,(M61_FundingAmount - BS_FundingAmount) Delta
		From(
			Select d.dealname,d.credealid,n.noteid
			,m61.CRENoteID,m61.FundingDate as M61_FundingDate,SUM(m61.FundingAmount) as M61_FundingAmount,bs.FundingDate as BS_FundingDate,bs.FundingAmount as BS_FundingAmount
			from @M61FF m61
			Left join ( 
				Select CRENoteID,FundingDate,SUM(FundingAmount) FundingAmount  from @BackshopFF
				group by CRENoteID,FundingDate
			)bs on m61.CRENoteID = bs.CRENoteID and m61.FundingDate = bs.FundingDate
			inner join cre.note n on n.crenoteid = m61.CreNoteID
			inner join cre.deal d on d.dealid = n.dealid
			WHERE d.DealName NOT LIKE '%copy%'
			--where m61.CRENoteID in (Select CRENoteID from @BackshopNotes) and n.Actualpayoffdate is null
			----and M61.crenoteid = '11837'

			group by m61.CRENoteID,n.noteid,
			m61.FundingDate,
			bs.FundingDate ,d.dealname,d.credealid,bs.FundingAmount
		)a
	)b
	where ROUND(ISNULL(Delta,1),2) <> 0


	
	
	select * from @M61FF
	select * from @BackshopFF	
	select * from @tblDiscrepancy


 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  
  
