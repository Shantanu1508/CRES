CREATE PROCEDURE [DW].[usp_ImportGetDiscrepancyForExportPaydown]
AS
BEGIN

	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
	Declare @M61FFTable as table(  
	DealName nvarchar(256) null,  
	DealId nvarchar(256) null,  
	NoteID nvarchar(256) null,  
	notename nvarchar(256) null,  
	Date [date] null,  
	Purposetype nvarchar(256) null,  
	GeneratedBy nvarchar(256) null,  
	updatedTimeStamp datetime null,  
	PayoffDate date null,  
	AMount decimal(28,15) null  
 
	)  
 
 
	INSERT INTO @M61FFTable(DealName,DealId,NoteID,notename,Date,Purposetype,GeneratedBy,updatedTimeStamp,PayoffDate,AMount)  
	Select  Distinct d.DealName ,  
	d.credealid DealId,  
	n.crenoteid as NoteID,  
	acc.name as notename,  
	fs.date as [Date] ,  
	LPurposeID.Name Purposetype,  
	Lgb.name as  GeneratedBy,  
	fs.updateddate updatedTimeStamp,  
	pd.payoffdate as PayoffDate,  
	SUM(fs.value) AMount  
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
		 --and n.NoteID = @NoteId    
		 and acc.IsDeleted = 0  
		 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
		 GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
 
	) sEvent  
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
	left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = fs.generatedby   
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
	Inner Join cre.deal d on d.dealid= n.dealid  
	left join(  
	 Select noteid,payoffdate from payoffdate  
	)pd on pd.noteid = n.crenoteid  
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0  
	and LPurposeID.Name = 'paydown'  
	and Lgb.name = 'Auto Spread'  
	and dealname not in ('NorthStar ALTO Portfolio Copy','Northstar ALTO Portfolio Copy X','Northstar ALTO Portfolio Test')  
	and d.status = 323  
	AND  d.DealName NOT LIKE '%copy%'
	group by d.DealName ,  
	d.credealid ,  
	n.crenoteid,  
	acc.name,  
	fs.date ,  
	LPurposeID.Name ,  
	Lgb.name,  
	fs.updateddate,  
	pd.payoffdate  
	---==========================================  
	Declare @tblBSPaydown as table  
	(  
 
	DealName nvarchar(256) null,  
	DealId nvarchar(256) null,  
	NoteID nvarchar(256) null,  
	Date date null,  
	Amount decimal(28,15) null,  
	Purposetype nvarchar(256) null,  
	GeneratedBy nvarchar(256) null,  
	updatedTimeStamp datetime null,  
	ShardName nvarchar(256) null  
	)  
 
	INSERT INTO @tblBSPaydown(DealName,DealId,NoteID,Date,Amount,Purposetype,GeneratedBy,updatedTimeStamp,ShardName)  
 
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',     
	@stmt = N'Select cm.DealName DealName,cm.ControlId DealId,np.NoteId_F as NoteID,np.PaymentDate as [Date] ,np.Amount as Amount,np.FundingPurposeCd_F Purposetype, GeneratedBy,np.AuditAddDate updatedTimeStamp  
	from  [acore].[tblNoteProjectedPayment] np  
	left join tblNote n on n.NoteId = np.NoteId_F  
	left join tblControlMaster cm on cm.ControlId = n.ControlId_F  
	order by cm.DealName,np.NoteId_F,np.PaymentDate'    
	---========================================  



	TRUNCATE TABLE [DW].[tbl_GetDiscrepancyForExportPaydown];

	INSERT INTO [DW].[tbl_GetDiscrepancyForExportPaydown](
	[Deal Name]	
	,[Deal ID]	
	,[Note ID]	
	,[Note Name]	
	,[Date]		
	,[M61 Amount]
	,[BS Amount]	
	,[Delta])
	Select * from(  
		Select m61.DealName as [Deal Name]
		,m61.DealID as [Deal ID]
		,m61.NoteID as [Note ID]
		,m61.notename as [Note Name]
		,CONVERT(varchar, m61.Date, 101) as Date
		,CAST(ROUND(m61.AMount,2) as decimal(28,2)) as [M61 Amount]
		,CAST(ROUND(bs.AMount,2)  as decimal(28,2)) as [BS Amount]
		,CAST(ROUND( (round(m61.AMount,4) - ROUND(bs.AMount,4)) ,2) as decimal(28,2)) as Delta  
		from @M61FFTable m61  
		left Join (  
			Select DealName,DealId,NoteID,Date,SUM(Amount) as Amount,Purposetype  
			from @tblBSPaydown   
			group by DealName,DealId,NoteID,Date,Purposetype  
		)bs on bs.NoteID = m61.NoteID and bs.Date = m61.Date
	)a  
	where ISNULL(delta,1) <> 0;

	UPDATE [DW].[tbl_GetDiscrepancyForExportPaydown] SET [LastUpdatedDate]=GETDATE();
END