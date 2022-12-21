CREATE PROCEDURE [dbo].[usp_GetConsolidatWFEmailNotification] 
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @AllowWFConsolidatNotification nvarchar(10)=(select [Value] from app.AppConfig WHERE [key]='AllowWFConsolidatNotification')
--Enable/Disbale wf consolidated notification based on app.AppConfig flage
if (@AllowWFConsolidatNotification='1') 
BEGIN
	
	
	
	--Preliminary	
	IF OBJECT_ID('tempdb..#tblWFPrelim') IS NOT NULL             
	DROP TABLE #tblWFPrelim      
	
	--get consolidated email group
	 declare @ConsolidatedEmails nvarchar(1000)
	 select @ConsolidatedEmails = stuff((
			select Distinct ',' +  wf.EmailID
			from [CRE].WFNotificationMasterEmail wf join Core.Lookup l on wf.LookupID=l.LookupID 
			where  l.LookupID=607
			and wf.ParentClient ='TRE ACR'
			for xml path('')
		),1,1,'')
            
	create table #tblWFPrelim     
	( 
	dealid	UNIQUEIDENTIFIER Null,
	credealid	nvarchar(256) null,
	dealname	nvarchar(256) null,	
	dealfundingid	UNIQUEIDENTIFIER Null,
	ClientID int null,	
	ClientName	nvarchar(256) null,	
	lookupID int null,	
	Amount	decimal(28,15) null,
	FundingDate	date null,
	CreatedBy		nvarchar(256) null,
	CreatedDate	datetime null,
	EmailID		nvarchar(256) null,
	NotificationType		nvarchar(256) null,
	NoteClientName		nvarchar(256) null,
	ClientWiseAmount	decimal(28,15) null,
	Client_FF_Amount 	nvarchar(256) null,
	Ntype 	nvarchar(256) null,

	ActivityLog	nvarchar(256) null,
	MessageHTML 	nvarchar(MAX) null,
	[MessageData] [nvarchar](max) NULL
	)


	INSERT INTO #tblWFPrelim (dealid,credealid,dealname,dealfundingid,ClientID,ClientName,lookupID,Amount,FundingDate,CreatedBy,CreatedDate,EmailID,NotificationType,NoteClientName ,ClientWiseAmount,Client_FF_Amount,MessageHTML,[MessageData])
	
	Select dealid,credealid,dealname,tbl.dealfundingid,tbl.ClientID,tbl.ClientName,lookupID,Amount,tbl.[Date] as FundingDate, tbl.CreatedBy,tbl.CreatedDate,EmailID,tbl.NotificationType
	,FF.ClientName as  NoteClientName , ROUND(FF.ClientWiseAmount,2) as ClientWiseAmount,FF.ClientName +'#'+ Cast(Cast(ROUND(FF.ClientWiseAmount,2)  as decimal(28,2)) as nvarchar(256)) Client_FF_Amount,MessageHTML,[MessageData]
	FROM (
			SELECT distinct d.dealid,d.credealid,d.dealname,dealfundingid,null as ClientID,ISNULL(l.ParentClient,l.FinancingSourceName) as ClientName,wf.LookupID,wf.EmailID,df.Amount,df.[Date],
			(u.FirstName+ ' '+u.LastName) CreatedBy,wn.CreatedDate,wn.NotificationType,wn.MessageHTML,wn.MessageData
			FROM cre.deal d
			inner join cre.note n ON d.dealid = n.dealid
			--left join [CRE].WFNotificationMasterEmail wf ON wf.ClientID = n.ClientID and wf.clientid = 2
			--left join [CRE].Client l on l.ClientID = wf.ClientID
			left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
			left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
			join cre.dealfunding df on df.dealid = d.dealid
			join cre.WFNotification wn on wn.TaskID=df.DealFundingID
			left join app.[User] u on u.UserID = ISNULL(NULLIF(wn.CreatedBy,''),'00000000-0000-0000-0000-000000000000')
		  
			WHERE 
			wf.LookupID in (607)
			and wn.WFNotificationMasterID=1
			and wn.NotificationType = 'Preliminary'
			and wn.CreatedDate between DateADD(HOUR,-24,GETDATE()) and  GETDATE()
	) tbl
	Cross Apply(
		Select  
		fs.DealFundingID
		,ISNULL(l.ParentClient,l.FinancingSourceName) as ClientName
		,SUM(fs.Value) as ClientWiseAmount
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN (						
			Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
				from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
				and n.DealID = tbl.DealID 
				and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
				GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
	    left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0	
		and fs.DealFundingID = tbl.DealFundingID
		--and n.clientid in (Select clientid from [CRE].WFNotificationMasterEmail where LookupID = 607)
		group by fs.DealFundingID,ISNULL(l.ParentClient,l.FinancingSourceName)

	)FF	
	--where credealid = '17-0436C2'
	--and tbl.dealfundingID ='57CAD7E2-427E-4C7C-8E2C-325E38D122F5'
	order by tbl.NotificationType,dealname
	--======================================================================================
	--Revised
	IF OBJECT_ID('tempdb..#tblWFRevised') IS NOT NULL             
	DROP TABLE #tblWFRevised           
            
	create table #tblWFRevised     
	( 
	dealid	UNIQUEIDENTIFIER Null,
	credealid	nvarchar(256) null,
	dealname	nvarchar(256) null,	
	dealfundingid	UNIQUEIDENTIFIER Null,
	ClientID int null,	
	ClientName	nvarchar(256) null,	
	lookupID int null,	
	Amount	decimal(28,15) null,
	FundingDate	date null,
	CreatedBy		nvarchar(256) null,
	CreatedDate	datetime null,
	EmailID		nvarchar(256) null,
	NotificationType		nvarchar(256) null,
	NoteClientName		nvarchar(256) null,
	ClientWiseAmount	decimal(28,15) null,
	Client_FF_Amount 	nvarchar(256) null,
	Ntype 	nvarchar(256) null,

	ActivityLog	nvarchar(256) null,
	MessageHTML nvarchar(MAX) null,
	[MessageData] [nvarchar](max) NULL
	)
	INSERT INTO #tblWFRevised (dealid,credealid,dealname,dealfundingid,ClientID,ClientName,lookupID,Amount,FundingDate,CreatedBy,CreatedDate,EmailID,NotificationType,NoteClientName ,ClientWiseAmount,Client_FF_Amount,Ntype,MessageHTML,[MessageData])
	
	Select dealid,credealid,dealname,tbl.dealfundingid,tbl.ClientID,tbl.ClientName,lookupID,Amount,tbl.[Date] as FundingDate, tbl.CreatedBy,tbl.CreatedDate,EmailID,tbl.NotificationType
	,FF.ClientName as  NoteClientName , ROUND(FF.ClientWiseAmount,2) as ClientWiseAmount,FF.ClientName +'#'+ Cast(Cast(ROUND(FF.ClientWiseAmount,2)  as decimal(28,2)) as nvarchar(256)) Client_FF_Amount,Ntype,MessageHTML,[MessageData]
	FROM (

			Select dealid,credealid,dealname,dealfundingid,ClientID,ClientName,LookupID,EmailID,Amount,Date,CreatedBy,CreatedDate,NotificationType,'old' as Ntype,MessageHTML,[MessageData]
			From(
				SELECT distinct d.dealid,d.credealid,d.dealname,df.dealfundingid,null as ClientID,ISNULL(l.ParentClient,l.FinancingSourceName) as ClientName,wf.LookupID,wf.EmailID,df.Amount,df.[Date],
				(u.FirstName+ ' '+u.LastName) CreatedBy,wn.CreatedDate,wn.NotificationType,wn.MessageHTML,wn.MessageData,
				ROW_NUMBER() OVER (PARTITION BY  d.dealid,df.dealfundingid ORDER BY d.dealid,df.dealfundingid,wn.createddate desc) AS SNO
				FROM cre.deal d
				inner join cre.note n ON d.dealid = n.dealid
				left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
	            left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
				join cre.dealfunding df on df.dealid = d.dealid
				join cre.WFNotification wn on wn.TaskID=df.DealFundingID
				left join app.[User] u on u.UserID = ISNULL(NULLIF(wn.CreatedBy,''),'00000000-0000-0000-0000-000000000000')
				inner join(
					Select dealfundingid,CreatedDate
					From(
						SELECT distinct d.dealid,d.credealid,d.dealname,dealfundingid,null as ClientID,ISNULL(l.ParentClient,l.FinancingSourceName) as ClientName,wf.LookupID,wf.EmailID,df.Amount,df.[Date],
						(u.FirstName+ ' '+u.LastName) CreatedBy,wn.CreatedDate,wn.NotificationType,wn.MessageHTML,
						ROW_NUMBER() OVER (PARTITION BY  d.dealid,dealfundingid ORDER BY d.dealid,dealfundingid,wn.createddate desc) AS SNO
						FROM cre.deal d
						inner join cre.note n ON d.dealid = n.dealid
						left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
						left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
						join cre.dealfunding df on df.dealid = d.dealid
						join cre.WFNotification wn on wn.TaskID=df.DealFundingID
						left join app.[User] u on u.UserID = wn.CreatedBy		  
						WHERE 
						wf.LookupID in (607)
						and wn.WFNotificationMasterID=1
						and wn.NotificationType in ('Preliminary Revised')
						and wn.CreatedDate between DateADD(HOUR,-24,GETDATE()) and  GETDATE()
						)a Where a.SNO in (1)
				)currentData on currentData.dealfundingid = df.dealfundingid 
					  
				WHERE n.ClientID is not null
				and wf.LookupID in (607)
				and wn.WFNotificationMasterID=1
				and wn.NotificationType in ('Preliminary', 'Preliminary Revised')

				and wn.CreatedDate < currentData.CreatedDate 
				--and wn.CreatedDate < DateADD(HOUR,-24,GETDATE())
			)a Where a.SNO = 1	

			UNION ALL

			Select dealid,credealid,dealname,dealfundingid,ClientID,ClientName,LookupID,EmailID,Amount,Date,CreatedBy,CreatedDate,NotificationType,'New' as Ntype,MessageHTML,[MessageData]
			From(
				SELECT distinct d.dealid,d.credealid,d.dealname,dealfundingid,null as ClientID,ISNULL(l.ParentClient,l.FinancingSourceName) as  ClientName,wf.LookupID,wf.EmailID,df.Amount,df.[Date],
				(u.FirstName+ ' '+u.LastName) CreatedBy,wn.CreatedDate,wn.NotificationType,wn.MessageHTML,wn.MessageData,
				ROW_NUMBER() OVER (PARTITION BY  d.dealid,dealfundingid ORDER BY d.dealid,dealfundingid,wn.createddate desc) AS SNO
				FROM cre.deal d
				inner join cre.note n ON d.dealid = n.dealid
				left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
				left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
				join cre.dealfunding df on df.dealid = d.dealid
				join cre.WFNotification wn on wn.TaskID=df.DealFundingID
				left join app.[User] u on u.UserID = wn.CreatedBy		  
				WHERE 
				wf.LookupID in (607)
				and wn.WFNotificationMasterID=1
				and wn.NotificationType in ('Preliminary Revised')
				and wn.CreatedDate between DateADD(HOUR,-24,GETDATE()) and  GETDATE()
			)a Where a.SNO in (1)

		
	) tbl
	outer Apply(
		Select  
		fs.DealFundingID
		,ISNULL(l.ParentClient,l.FinancingSourceName) ClientName
		,SUM(fs.Value) as ClientWiseAmount
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN (						
			Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
				from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
				and n.DealID = tbl.DealID 
				and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
				GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
		left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0	
		and fs.DealFundingID = tbl.DealFundingID
		--and n.clientid in (Select clientid from [CRE].WFNotificationMasterEmail where LookupID = 607)
		group by fs.DealFundingID,ISNULL(l.ParentClient,l.FinancingSourceName) 

	)FF	
	--where credealid = '17-0436C2'
	--and tbl.dealfundingID ='57CAD7E2-427E-4C7C-8E2C-325E38D122F5'
	order by tbl.NotificationType,dealname
	--======================================================================================



	--Preliminary
	select Distinct dealid,credealid,dealname,dealfundingid,ClientID,ClientName,lookupID,Cast(ROUND(Amount,2) as decimal(28,2)) as Amount,FundingDate,CreatedBy,CreatedDate,

	--stuff((
	--		select Distinct ',' +  t.EmailID
	--		from #tblWFPrelim t
	--		where t.dealid = t1.dealid and t.dealfundingid = t1.dealfundingid and t.NotificationType = t1.NotificationType and t.CReatedDate = t1.CReatedDate
	--		for xml path('')
	--	),1,1,'') as EmailID
		@ConsolidatedEmails as EmailID,
		

	NotificationType,
	stuff((
			select '|' + t.Client_FF_Amount
			from #tblWFPrelim t
			where t.dealid = t1.dealid and t.dealfundingid = t1.dealfundingid and t.NotificationType = t1.NotificationType and t.CReatedDate = t1.CReatedDate
			for xml path('')
		),1,1,'') as Client_FF_Amount,
		t1.Ntype,null as ActivityLog,t1.MessageHTML,t1.MessageData
	from #tblWFPrelim t1

	UNION ALL

	--Revised

	select Distinct dealid,credealid,dealname,dealfundingid,ClientID,ClientName,lookupID,Cast(ROUND(Amount,2) as decimal(28,2)) as Amount,FundingDate,CreatedBy,t1.CreatedDate,

	--stuff((
	--		select Distinct ',' +  t.EmailID
	--		from #tblWFRevised t
	--		where t.dealid = t1.dealid and t.dealfundingid = t1.dealfundingid and t.NotificationType = t1.NotificationType and t.CReatedDate = t1.CReatedDate
	--		for xml path('')
	--	),1,1,'') as EmailID
		@ConsolidatedEmails as EmailID,

	'Preliminary Revised' as NotificationType,

	stuff((
			select '|' + t.Client_FF_Amount
			from #tblWFRevised t
			where t.dealid = t1.dealid and t.dealfundingid = t1.dealfundingid and t.NotificationType = t1.NotificationType and t.CReatedDate = t1.CReatedDate and t.Ntype = t1.Ntype 
			--group by t.dealid,t.dealfundingid,t.CreatedDate,t.NotificationType,t.Client_FF_Amount
			for xml path('')
		),1,1,'') as Client_FF_Amount,t1.Ntype,
		REPLACE(REPLACE(tblActivity.Comment,'Changed the funding amount from ','fundingamount '),'Changed the funding date from ','fundingdate ') as ActivityLog,t1.MessageHTML,t1.MessageData
	from #tblWFRevised t1
	Outer apply(   
		Select top 1 TaskID,CreatedDate,Comment,UpdatedDate
		From(
			Select 
			td.TaskID,	
			td.CreatedDate,	
			ISNULL(td.Comment,'') as Comment,
			td.UpdatedDate
			from cre.WFTaskDetail td
			Where TaskID = t1.dealfundingid and CAst(td.UpdatedDate as Date) = CAst(t1.CreatedDate as Date)

			UNION ALL 

			Select 	
			td.TaskID,
			td.CreatedDate,
			ISNULL(td.Comment,'') as Comment,
			td.UpdatedDate
			from cre.WFTaskDetailArchive td
			Where TaskID = t1.dealfundingid and CAst(td.UpdatedDate as Date) = CAst(t1.CreatedDate as Date)
		)a
		where Comment like 'Changed the funding%'
		order by a.UpdatedDate DESC
	)tblActivity

	order by t1.FundingDate,t1.dealid,t1.dealfundingid,t1.NotificationType,t1.CreatedDate

 END




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END



