-- Procedure
-- C848F020-2EE5-4BD4-9939-2E4B50C59744
-- 50F46CE5-B3FA-4C48-A390-3190A3B87D71
--  [dbo].[usp_GetAdjustmentCommitmentByDealID_forAPI]'b0e6697b-3534-4c09-be0a-04473401ab93','34da32a9-e774-4924-b1e2-85f214e3f1fd'
CREATE  PROCEDURE [dbo].[usp_GetAdjustmentCommitmentByDealID_forAPI]  
(
    @UserID UNIQUEIDENTIFIER,
    @DealID UNIQUEIDENTIFIER
)	

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare  @ColPivot nvarchar(max),@ColPivot1 nvarchar(max),@query nvarchar(max),@ColPivot2 nvarchar(max); --,@totalrequiredequity decimal(28,15),@totaladditionalequity decimal(28,15);
--SELECT @totalrequiredequity = SUM(ISNULL(TotalRequiredEquity,0)), @totaladditionalequity= SUM(ISNULL(TotalAdditionalEquity,0)) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID;

-- Declare @minclosingdate date = (SELECT min(ClosingDate) from cre.note where dealid = @DealID);
Declare @Analysisid uniqueidentifier = (SELECT AnalysisID from CORE.Analysis WHERE Name='Default');
Declare @userdate datetime = ([dbo].[ufn_GetTimeByTimeZone] ((SELECT getdate()),@UserID));

---------------========================Create Table for maturity-------============
IF OBJECT_ID('tempdb..[#tempMaturityTable]') IS NOT NULL                                         
		 DROP TABLE [#tempMaturityTable]

create table #tempMaturityTable(Maturity date) --,NoteID nvarchar(256))
INSERT INTO #tempMaturityTable(Maturity) --,NoteID )
Select max(ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate))) as Maturity
		from cre.note n1
		inner join cre.Deal d on d.dealid = n1.dealid
		Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
		Left Join(
			Select noteid,MaturityType,MaturityDate,Approved
			from (
					Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
					ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
					from [CORE].Maturity mat  
					INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
					INNER JOIN   
					(          
						Select   
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
						where EventTypeID = 11
						and n.DealID =  @DealID
						and acc.IsDeleted = 0  
						and eve.StatusID = 1
						GROUP BY n.Account_AccountID,EventTypeID    
					) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				
				where n.DealID =  @DealID
				and mat.MaturityDate > getdate()
				and lApproved.name = 'Y'
				)a where a.rno = 1
			)currMat on currMat.noteid = n1.noteid
			where acc1.IsDeleted <> 1
			and d.dealid =@DealID
			
	
		--ISNULL(
		--	(CASE WHEN InitialMaturity.SelectedMaturityDate > getdate() THEN InitialMaturity.SelectedMaturityDate
		--	WHEN n.ExtendedMaturityScenario1 > getdate() THEN n.ExtendedMaturityScenario1
		--	WHEN n.ExtendedMaturityScenario2 > getdate() THEN n.ExtendedMaturityScenario2
		--	WHEN n.ExtendedMaturityScenario3 > getdate() THEN n.ExtendedMaturityScenario3
		--	ELSE n.FullyExtendedMaturityDate END)
		--,InitialMaturity.SelectedMaturityDate)
		--)) as Maturity
		--,n.NoteID
		--from cre.Note n
		--inner join Core.Account a on n.Account_AccountID=a.AccountID
		--inner join cre.Deal d on d.dealid = n.dealid
		--left join(
		--	Select n.noteid,mat.[SelectedMaturityDate]  
		--	from [CORE].Maturity mat  
		--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		--	inner join core.account acc on acc.accountid = e.accountid
		--	inner join cre.note n on n.account_accountid =acc.accountid 
		--	INNER JOIN (Select   
		--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		--		inner join cre.Deal ddd on ddd.dealid = n.dealid
		--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID  
		--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
		--		and ddd.dealid = @DealID
		--		GROUP BY n.Account_AccountID,EventTypeID  
		--	) sEvent  
		--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		--)InitialMaturity on InitialMaturity.noteid = n.noteid
		
		--where d.dealid =@DealID
 

-----=========================Create Table For Pivoting==========================================------
		IF OBJECT_ID('tempdb..[#TempDataTable]') IS NOT NULL                                         
		 DROP TABLE [#TempDataTable]

		CREATE TABLE #TempDataTable (  NoteAdjustedCommitmentMasterID int,
									   CRENoteID nvarchar(256),
									   NoteID uniqueidentifier,									 
									   [Type] int,
									   [Date] date,
									   [TypeText] nvarchar(256),
									   DealAdjustmentHistory decimal(28,15),
									   AdjustedCommitment decimal(28,15),
									   TotalCommitment decimal(28,15),
									   AggregatedCommitment decimal(28,15),
									   NoteAdjustedCommitment decimal(28,15),
									   NoteTotalCommitment decimal(28,15),
									   NoteAggregatedCommitment decimal(28,15),
									   Comments nvarchar(256),
									   lienposition int null ,
										[priority] int null,
										InitialFundingAmount decimal(28,15) NULL, 
										NoteName nvarchar(256),
										TotalRequiredEquity decimal(28,15) null,
										TotalAdditionalEquity decimal(28,15) null,
									    Amount decimal(28,15),
										CommitmentType nvarchar(256)
										--ExcludeFromCommitmentCalculation bit null
									)

-----=========================Create Table For Pivoting==========================================------
		IF OBJECT_ID('tempdb..[#TempDataPivotTable]') IS NOT NULL                                         
		 DROP TABLE [#TempDataPivotTable]

		CREATE TABLE #TempDataPivotTable (  NoteAdjustedCommitmentMasterID int,
											CRENoteID nvarchar(256),
											 DealID uniqueidentifier,
											[Type] int,
											[Date] date,
											[TypeText] nvarchar(256),
											DealAdjustmentHistory decimal(28,15),
											AdjustedCommitment decimal(28,15),
											TotalCommitment decimal(28,15),
											AggregatedCommitment decimal(28,15),
											Comments nvarchar(256),
											lienposition int null,
											[priority] int null,
											InitialFundingAmount decimal(28,15) NULL, 
											NoteName nvarchar(256),
											SortOrder int,
											TotalRequiredEquity decimal(28,15) NULL,
											TotalAdditionalEquity decimal(28,15) NULL,
											Amount decimal(28,15),
											CommitmentType nvarchar(256)
											--ExcludeFromCommitmentCalculation bit null
										 )

---------------======================================================================-----------------------
--IF EXISTS(SELECT 1 FROM CRE.NoteAdjustedCommitmentMaster WHERE DealID = @DealID)
--BEGIN
--	INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,
--		AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity, Amount)
--   SELECT nm.NoteAdjustedCommitmentMasterID,
--		  n.CRENoteID,
--		  n.NoteID,
--		  nm.Type,
--		  nm.Date,
--		  l.name as TypeText,
--		  nm.DealAdjustmentHistory,
--		  nm.AdjustedCommitment,
--		  nm.TotalCommitment,
--		  nm.AggregatedCommitment,
--		  nd.NoteAdjustedTotalCommitment,
--		  nd.NoteTotalCommitment,
--		  nd.NoteAggregatedTotalCommitment,
--		  nm.Comments,
--		  n.lienposition,
--		  n.[priority],
--		  n.InitialFundingAmount,
--		  acc.Name,
--		  nm.TotalRequiredEquity,
--		  nm.TotalAdditionalEquity, 
--		  nd.Value as Amount
--    FROM CRE.NoteAdjustedCommitmentMaster nm
--	left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID and nd.type = nm.type
--	inner join cre.deal d on d.DealID=nm.DealID
--	left join cre.note n on n.NoteID = nd.NoteID
--	left join core.account acc on acc.AccountID = n.Account_AccountID
--	left join core.lookup l on l.lookupid = nd.Type
--	WHERE d.DealID = @DealID
--END
--ELSE
--BEGIN

		IF OBJECT_ID('tempdb..[#TempFutureFudningDataTable]') IS NOT NULL                                         
		 DROP TABLE [#TempFutureFudningDataTable]

		CREATE TABLE #TempFutureFudningDataTable
												(DealID nvarchar(256) null,
												 NoteID nvarchar(256) null,
												 CRENoteID nvarchar(256) null,
												 NoteName nvarchar(256) null,
												 EffectiveStartDate date null,
												 FundingDate date null,
												 FundingAmount decimal(28,15) null,
												 PurposeID int null,
												 PurposeText nvarchar(256) null,
												 Applied int null,
												 ActualPayoffdate Date
												)
		INSERT INTO #TempFutureFudningDataTable (DealID,NoteID,CRENoteID,NoteName,EffectiveStartDate,FundingDate,FundingAmount,PurposeID,PurposeText, Applied,ActualPayoffdate)
		Select
				d.dealid,
				n.noteid,
				n.crenoteid,
				acc.name as notename, 
				e.EffectiveStartDate,
				fs.[Date] as FundingDate,
				fs.value as FundingAmount,
				fs.PurposeID,
				LPurposeID.Name as PurposeText,
				fs.Applied,
				n.ActualPayoffdate
				from [CORE].FundingSchedule fs
				INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
				INNER JOIN(						
					Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					and n.DealID = @DealID
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
				) sEvent
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
				left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				Inner join cre.deal d on d.dealid = n.dealid
				where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
				and ISNULL(fs.AdjustmentType,836) not in (834,835,896)

		---=========================ClosingDate Query==============================------------
		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,
		AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity, Amount,CommitmentType)  ---,ExcludeFromCommitmentCalculation
																																								
		SELECT  0,
				n.CRENoteID,
				n.NoteID,
				'637' as Type,
				CAST(c.ClosingDate as Date),
				'Closing' as TypeText,
				0,
				0,
				0,
				0,
				c.OriginalTotalCommitment,
				c.OriginalTotalCommitment,
				c.OriginalTotalCommitment,
				null,
				n.lienposition,
				n.priority,
				n.InitialFundingAmount,
				acc.name,
				(SELECT top 1 ISNULL(TotalRequiredEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = c.ClosingDate and Type = '637'),
				(SELECT top 1 ISNULL(TotalAdditionalEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = c.ClosingDate and Type = '637'),
				ISNULL(c.OriginalTotalCommitment,0) as Amount,
				'Closing' as CommitmentType
				--(SELECT top 1 ISNULL(ExcludeFromCommitmentCalculation,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = c.ClosingDate and Type = '637')
		FROM CRE.Note n 
		inner join cre.deal d1 on d1.dealid = n.dealid
		left join core.account acc on acc.AccountID = n.Account_AccountID
		inner join (SELECT b.ClosingDate,b.OriginalTotalCommitment,b.CRENoteID 
				   FROM
						(SELECT DISTINCT ClosingDate,ISNULL(OriginalTotalCommitment,0) as OriginalTotalCommitment,CRENoteID from cre.note n
						 left join core.account acc on acc.AccountID = n.Account_AccountID
						 where DealID = @DealID and acc.IsDeleted <> 1
						) b
				  left join cre.note n1 on n1.ClosingDate = b.ClosingDate and n1.CRENoteID = b.CRENoteID
				  ) c on c.CRENoteID = n.CRENoteID
		left join #TempFutureFudningDataTable t on t.DealID = d1.DealID and n.noteid = t.noteid and c.ClosingDate = t.FundingDate 
		where d1.DealID = @DealID
		group by n.CRENoteID,c.OriginalTotalCommitment,c.ClosingDate, n.NoteID,n.lienposition,n.priority,n.InitialFundingAmount,acc.name,n.InitialRequiredEquity,n.InitialAdditionalEquity
		
		----===========PrePaymentQuery=====================--------
		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,
		TotalCommitment,AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType)  --,ExcludeFromCommitmentCalculation
		SELECT  0,
				n.CRENoteID, 
				n.NoteID,
				(CASE WHEN t.PurposeID = 840 THEN '876' ELSE '638' END) as Type,
				CAST(t.FundingDate as Date),
				(CASE WHEN t.PurposeID = 840 THEN 'Principal Writeoff Curtailment' ELSE 'Prepayment' END)  as Typetext,				
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				null,
				n.lienposition,
				n.priority,
				n.InitialFundingAmount,
				acc.name,
				(SELECT top 1 ISNULL(TotalRequiredEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = t.FundingDate and Type = '638'),
				(SELECT top 1 ISNULL(TotalAdditionalEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = t.FundingDate and Type = '638'),
				SUM(ISNULL(t.FundingAmount,0)) as Amount,
				(CASE WHEN t.PurposeID = 840 THEN 'Principal Writeoff Curtailment' ELSE 'Prepayment' END) as CommitmentType
				--(SELECT top 1 ISNULL(ExcludeFromCommitmentCalculation,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = t.FundingDate and Type = '638')
		FROM CRE.Note n 
		inner join cre.deal d1 on d1.dealid = n.dealid
		left join core.account acc on acc.AccountID = n.Account_AccountID
		inner join #TempFutureFudningDataTable t on t.DealID = d1.DealID and n.noteid = t.noteid
		--left join #tempMaturityTable tm on tm.NoteID = n.NoteID
		where d1.DealID = @DealID
		and t.FundingDate <= (SELECT Maturity FROM #tempMaturityTable)
		and t.FundingDate <= @userdate
		--and t.Applied = 1
		and t.PurposeID in (315,630,631,840)
		and t.FundingAmount < 0
		group by n.CRENoteID, t.FundingDate,n.NoteID,n.lienposition,n.priority,n.InitialFundingAmount,acc.name,t.PurposeID
		order by t.FundingDate asc

		-------==============Prepayment Query for Balloon Payment======------------
		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,
		TotalCommitment,AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType) ---ExcludeFromCommitmentCalculation
		SELECT  0,
				n.CRENoteID, 
				n.NoteID,
				'638' as Type,
				CAST(Date as Date),
				'Prepayment' as Typetext,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				null,
				n.lienposition,
				n.priority,
				n.InitialFundingAmount,
				acc.name,
				(SELECT top 1 ISNULL(TotalRequiredEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638'),
				(SELECT top 1 ISNULL(TotalAdditionalEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638'),
				---ISNULL(-1 * (a.BalloonPayment + ISNULL(FFRepay_OnActualPayOff,0)),0) as Amount,
				ISNULL(-1 * (a.BalloonPayment - ISNULL(BalloonRepayAmount,0)),0) as Amount,
				'BalloonPayment' as CommitmentType
				--(SELECT top 1 ISNULL(ExcludeFromCommitmentCalculation,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638')
		FROM CRE.Note n 
		left join core.account acc on acc.AccountID = n.Account_AccountID
		inner join (
						select Distinct nn.noteid,Date
						,(CASE WHEN nn.InitialFundingAmount = 0.01 THEN (ISNULL(Amount,0) - 0.01) ELSE ISNULL(Amount,0) END )  BalloonPayment
						,BalloonRepayAmount
						from [CRE].[TransactionEntry] np
						Inner join cre.note nn on nn.Account_Accountid = np.Accountid
						where nn.dealid = @DealID


						and type='Balloon'
						and Date <= getdate()
						--and Amount <> 0.01
						and AnalysisID = @Analysisid
						)a on a.NoteID = n.NoteID
		--Left join(
		--	Select NoteID,FundingDate,SUM(FundingAmount) as FFRepay_OnActualPayOff
		--	from [#TempFutureFudningDataTable] t
		--	where FundingDate = ActualPayoffdate 		
		--	and t.FundingDate <= (SELECT Maturity FROM #tempMaturityTable)
		--	and t.FundingDate <= @userdate
		--	and t.PurposeID in (315,630,631)
		--	and t.FundingAmount < 0
		--	Group By NoteID,FundingDate
		--)ff on ff.NoteID = n.NoteID
		--inner join (Select noteid,(-1 * BalloonPayment) as BalloonPayment,PeriodEndDate from(
		--			select Distinct np.noteid,PeriodEndDate,ISNULL(BalloonPayment,0) BalloonPayment,
		--			ROW_NUMBER() Over (Partition by np.noteid Order by np.noteid,np.PeriodEndDate desc) as rno
		--			from [CRE].[NotePeriodicCalc] np
		--			Inner join cre.note nn on nn.NoteID = np.NoteID
		--			where nn.dealid = @DealID
		--			and BalloonPayment<>0
		--			--and PeriodEndDate <= CAST(@todaysDate as Date) 
		--			and PeriodEndDate <= ([dbo].[ufn_GetTimeByTimeZone] (@todaysDate,@UserID))
		--			and AnalysisID = @Analysisid and np.[Month] is not null
		--			)a where a.rno = 1)bp on bp.NoteId = n.NoteID
		where n.DealID = @DealID
		

		--------================================PIK PIK principal funding========================== 
		
		
		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,
		TotalCommitment,AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType) ---ExcludeFromCommitmentCalculation
		SELECT  0,
				n.CRENoteID, 
				n.NoteID,
				'638' as Type,
				CAST(Date as Date),
				'Upsize/Mod' as Typetext,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				null,
				n.lienposition,
				n.priority,
				n.InitialFundingAmount,
				acc.name,
				(SELECT top 1 ISNULL(TotalRequiredEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638'),
				(SELECT top 1 ISNULL(TotalAdditionalEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638'),
				ISNULL(-1 * a.BalloonPayment,0) as Amount,
				'PIKPrincipalFunding' as CommitmentType
				--(SELECT top 1 ISNULL(ExcludeFromCommitmentCalculation,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638')
		FROM CRE.Note n 
		left join core.account acc on acc.AccountID = n.Account_AccountID
		inner join (
						select Distinct nn.noteid,Date,ISNULL(Amount,0) BalloonPayment
						from [CRE].[TransactionEntry] np
						Inner join cre.note nn on nn.Account_Accountid = np.Accountid
						where nn.dealid = @DealID


						and type='PIKPrincipalFunding'
						and Date <= getdate()
						and Amount <> 0.01
						and AnalysisID = @Analysisid
						)a on a.NoteID = n.NoteID
		
		where n.DealID = @DealID and n.ImpactCommitmentCalc=3

		---=====================================PIKPrincipalPaid====================================

		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,
		TotalCommitment,AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType) ---ExcludeFromCommitmentCalculation
		SELECT  0,
				n.CRENoteID, 
				n.NoteID,
				'638' as Type,
				CAST(Date as Date),
				'Prepayment' as Typetext,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				null,
				n.lienposition,
				n.priority,
				n.InitialFundingAmount,
				acc.name,
				(SELECT top 1 ISNULL(TotalRequiredEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638'),
				(SELECT top 1 ISNULL(TotalAdditionalEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638'),
				ISNULL(-1 * a.BalloonPayment,0) as Amount,
				'PIKPrincipalPaid' as CommitmentType
				--(SELECT top 1 ISNULL(ExcludeFromCommitmentCalculation,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = a.Date and Type = '638')
		FROM CRE.Note n 
		left join core.account acc on acc.AccountID = n.Account_AccountID
		inner join (
						select Distinct nn.noteid,Date,ISNULL(Amount,0) BalloonPayment
						from [CRE].[TransactionEntry] np
						Inner join cre.note nn on nn.Account_Accountid = np.Accountid
						where nn.dealid = @DealID


						and type='PIKPrincipalPaid'
						and Date <= getdate()
						and Amount <> 0.01
						and AnalysisID = @Analysisid
						)a on a.NoteID = n.NoteID
		
		where n.DealID = @DealID and n.ImpactCommitmentCalc=3

		----===========Scheduled Principal Query=====================--------
		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,
		TotalCommitment,AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType) --,ExcludeFromCommitmentCalculation
		SELECT  0,
				n.CRENoteID, 
				n.NoteID,
				'691' as Type,
				CAST(t.FundingDate as Date),
				'Scheduled Principal' as Typetext,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				null,
				n.lienposition,
				n.priority,
				n.InitialFundingAmount,
				acc.name,
				(SELECT top 1 ISNULL(TotalRequiredEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = t.FundingDate and Type = '691'),
				(SELECT top 1 ISNULL(TotalAdditionalEquity,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = t.FundingDate and Type = '691'),
				(SUM(ISNULL(t.FundingAmount,0))) as Amount,
				'ScheduledPrincipal' as CommitmentType
				--(SELECT top 1 ISNULL(ExcludeFromCommitmentCalculation,0) from cre.NoteAdjustedCommitmentMaster where dealid=@DealID and Date = t.FundingDate and Type = '691')
		--FROM CRE.Note n 
		--inner join cre.deal d1 on d1.dealid = n.dealid
		--left join core.account acc on acc.AccountID = n.Account_AccountID
		--left join CRE.TransactionEntry t on t.NoteID = n.NoteID and AnalysisID=@Analysisid and type='ScheduledPrincipalPaid' and t.Date <= @userdate  
		--where d1.DealID = @DealID and t.Date is not null
		--group by n.CRENoteID,t.Date,n.NoteID,n.lienposition,n.priority,n.InitialFundingAmount,acc.name
		--order by t.Date asc
		FROM CRE.Note n 
		inner join cre.deal d1 on d1.dealid = n.dealid
		left join core.account acc on acc.AccountID = n.Account_AccountID
		inner join #TempFutureFudningDataTable t on t.DealID = d1.DealID and n.noteid = t.noteid 
		where d1.DealID = @DealID
		and t.FundingDate <= (SELECT Maturity FROM #tempMaturityTable)
		and t.FundingDate <= @userdate
		and t.PurposeID  = 351
		and t.FundingAmount < 0
		group by n.CRENoteID, t.FundingDate,n.NoteID,n.lienposition,n.priority,n.InitialFundingAmount,acc.name
		order by t.FundingDate asc
		----===========Note Transfer Query=====================--------
		--INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,
		--TotalCommitment,AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount)
		--SELECT  0,
		--		n.CRENoteID, 
		--		n.NoteID,
		--		'649' as Type,
		--		CAST(t.FundingDate as Date),
		--		'Note Transfer' as Typetext,
		--		0,
		--		0,
		--		0,
		--		0,
		--		0,
		--		0,
		--		0,
		--		null,
		--		n.lienposition,
		--		n.priority,
		--		n.InitialFundingAmount,				
		--		acc.name,
		--		0,
		--		0,
		--		ISNULL(t.FundingAmount,0) as Amount
		--FROM CRE.Note n 
		--inner join cre.deal d1 on d1.dealid = n.dealid
		--left join core.account acc on acc.AccountID = n.Account_AccountID
		--inner join #TempFutureFudningDataTable t on t.DealID = d1.DealID and n.noteid = t.noteid 
		--left join (SELECT b.ClosingDate,b.OriginalTotalCommitment,b.CRENoteID 
		--		   FROM
		--				(	SELECT DISTINCT ClosingDate,ISNULL(OriginalTotalCommitment,0) as OriginalTotalCommitment,CRENoteID from cre.note 
		--				    where DealID =  @DealID) b
		--					left join cre.note n1 on n1.ClosingDate = b.ClosingDate and n1.CRENoteID = b.CRENoteID
		--				) c on c.CRENoteID = n.CRENoteID
		--where d1.DealID = @DealID
		--and t.FundingDate <= CAST(getdate() as date)
		--and t.Applied = 1
		--and t.PurposeID = 629
		--and t.FundingAmount < 0
		----group by n.CRENoteID, t.FundingDate,n.NoteID,n.lienposition,n.priority,n.InitialFundingAmount,acc.name
		--order by t.FundingDate asc
				
		----=======================Upsize/Mod ,NoteTranser and Curtailment Query======================-------
		INSERT INTO #TempDataTable(NoteAdjustedCommitmentMasterID,CRENoteID,NoteID,[Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,
		AggregatedCommitment,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType)
		SELECT   nac.NoteAdjustedCommitmentMasterID,
				 n.CRENoteID,
				 n.NoteID,
				 nac.Type,
				 CAST(nac.[Date] as Date),
				 l.name  as [TypeText],
				 nac.DealAdjustmentHistory,
				 nac.AdjustedCommitment,
				 nac.TotalCommitment,
				 nac.AggregatedCommitment,
				 nacd.NoteAdjustedTotalCommitment,
				 nacd.NoteTotalCommitment,
				 nacd.NoteAggregatedTotalCommitment,
				 nac.Comments,
				 n.lienposition,
				 n.priority,
				 n.InitialFundingAmount,
				acc.name,
				ISNULL(nac.TotalRequiredEquity,0),
				ISNULL(nac.TotalAdditionalEquity,0),
				nacd.[Value] as Amount,
				'Others' as CommitmentType
		FROM CRE.NoteAdjustedCommitmentMaster nac
		left join CRE.NoteAdjustedCommitmentDetail nacd on nacd.NoteAdjustedCommitmentMasterID = nac.NoteAdjustedCommitmentMasterID
		left join cre.Note n on n.NoteID = nacd.NoteID
		left join core.account acc on acc.AccountID = n.Account_AccountID
		left join cre.deal d2 on d2.dealid = n.dealid
		left join core.lookup l on l.lookupid = nac.[Type]
		WHERE nacd.NoteID = n.NoteID
		and nacd.NoteAdjustedCommitmentMasterID = nac.NoteAdjustedCommitmentMasterID
		and d2.dealid=@DealID
		and nac.[type] in(639,640,690,649)
		and nac.Date <= (SELECT Maturity FROM #tempMaturityTable)
	--	group by n.CRENoteID,nac.NoteAdjustedCommitmentMasterID, nacd.[Value],nacd.noteid,n.NoteID,nac.Type,l.name,nac.[Date], nacd.NoteAdjustedTotalCommitment, nac.Comments,  nacd.NoteAggregatedTotalCommitment, nacd.NoteTotalCommitment,nacd.NoteTotalCommitment,nac.AdjustedCommitment, nac.TotalCommitment,  nac.AggregatedCommitment,nac.DealAdjustmentHistory,n.lienposition,n.priority,n.InitialFundingAmount,acc.name,n.InitialRequiredEquity,n.InitialAdditionalEquity
		Order By nac.[Date] asc
	
	
	-----insert into noteadjustedcommitment table if deal not exists
		--IF NOT EXISTS(SELECT DealID FROM CRE.NoteAdjustedCommitmentMaster WHERE DealId = @DealID)
		--BEGIN
		--declare @TableAdjustedTotalCommitment [TableAdjustedTotalCommitment]
		--insert into @TableAdjustedTotalCommitment(NoteAdjustedCommitmentMasterID, DealID,[Date],[Type],Rownumber,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,NoteID,Amount,NoteAdjustedTotalCommitment,NoteAggregatedTotalCommitment,NoteTotalCommitment)
		--Select NoteAdjustedCommitmentMasterID,@DealID,[Date],[Type],1,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,NoteID,Amount,NoteAdjustedCommitment,NoteTotalCommitment,NoteAggregatedCommitment
		--FROM #TempDataTable 
		--exec [dbo].[usp_InsertUpdateAdjustedTotalCommitment] @TableAdjustedTotalCommitment,@UserID
		--END
	-----------==================================-------------------
--	END

	INSERT INTO #TempDataPivotTable(CRENoteID,DealId,NoteAdjustedCommitmentMasterID,[Type],[Date],[TypeText],DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,SortOrder,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType)   --,ExcludeFromCommitmentCalculation

	
	SELECT DISTINCT  CAST(NoteID as nvarchar(256))+'_Noteid',@Dealid as DealId,NoteAdjustedCommitmentMasterID,[Type],[Date],[TypeText],DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,1,TotalRequiredEquity,TotalAdditionalEquity,Amount,CommitmentType --,isnull(ExcludeFromCommitmentCalculation,0)
	FROM #TempDataTable	 		
	
	UNION ALL

	SELECT DISTINCT CRENoteID +'_AdjustedCommitment' as CRENoteID,@Dealid as DealId, NoteAdjustedCommitmentMasterID,[Type],[Date],[TypeText],DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,2,TotalRequiredEquity,TotalAdditionalEquity,NoteAdjustedCommitment as Amount,CommitmentType--,isnull(ExcludeFromCommitmentCalculation,0)
	FROM #TempDataTable
	

	UNION ALL

	SELECT DISTINCT CRENoteID +'_AggregateCommitment' as CRENoteID,@Dealid as DealId, NoteAdjustedCommitmentMasterID,[Type],[Date],[TypeText],DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,3,TotalRequiredEquity,TotalAdditionalEquity,NoteAggregatedCommitment as Amount,CommitmentType--,isnull(ExcludeFromCommitmentCalculation,0)
	FROM #TempDataTable
	

	UNION ALL
	SELECT  DISTINCT CRENoteID +'_TotalCommitment' as CRENoteID,@Dealid as DealId,NoteAdjustedCommitmentMasterID,[Type],[Date],[TypeText],DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,Comments,lienposition,[priority],InitialFundingAmount,NoteName,4,TotalRequiredEquity,TotalAdditionalEquity,NoteTotalCommitment as Amount,CommitmentType--,ExcludeFromCommitmentCalculation
	FROM #TempDataTable 

	
	----===========PivotingTempTable====================--------------
		SET @ColPivot = STUFF((SELECT  ',' +  QUOTENAME(x.CRENoteID)               
								from (SELECT DISTINCT CRENoteID,SortOrder,lienposition,priority, InitialFundingAmount, NoteName FROM #TempDataPivotTable) x
								order by SortOrder, ISNULL(lienposition,99999), [priority],InitialFundingAmount desc, NoteName 
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')
								print(@ColPivot);

		SET @ColPivot1 = STUFF((SELECT  ',ISNULL(' + QUOTENAME(x.CRENoteID) +',0) as ' + QUOTENAME(cast(x.CRENoteID as nvarchar(256)))               
								from  (SELECT DISTINCT CRENoteID,SortOrder,lienposition,priority, InitialFundingAmount, NoteName FROM #TempDataPivotTable) x
								order by SortOrder, ISNULL(lienposition,99999),[priority],InitialFundingAmount desc, NoteName 
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')

		
								
		SET @query =N'
					SELECT NoteAdjustedCommitmentMasterID,DealId,Type,Date,TypeText,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,TotalRequiredEquity,TotalAdditionalEquity,Comments,' + @ColPivot1 + ',CommitmentType
					FROM (
					SELECT CRENoteID,NoteAdjustedCommitmentMasterID,DealId, [Type],[Date],TypeText,DealAdjustmentHistory,AdjustedCommitment,TotalCommitment,AggregatedCommitment,TotalRequiredEquity,TotalAdditionalEquity,Comments,
					ISNULL(Amount,0) as Amount,CommitmentType
					FROM #TempDataPivotTable
					) temptable
					PIVOT(SUM(Amount) For CRENoteID IN(' + @ColPivot + ')) as tab
					Order By Date asc
					'
					
		PRINT @query
		EXEC (@query)


		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

