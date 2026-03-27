

CREATE PROCEDURE [dbo].[usp_CopyDealFundingFromLegalToPhantom]
(
	@CREDealID nvarchar(256)
)
  
AS
  BEGIN
  SET NOCOUNT ON;  

IF EXISTS(Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0)
BEGIN
	Declare @PhtmDealid UNIQUEIDENTIFIER = (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0 )
	Declare @LegalDealid UNIQUEIDENTIFIER = (Select dealid from cre.Deal where CREDealID = @CREDealID and IsDeleted=0 )

	---Copy legal Auto Spread data into phantom-----------
	Delete from [CRE].[DealProjectedPayOffAccounting] where dealid = @PhtmDealid

	INSERT INTO [CRE].[DealProjectedPayOffAccounting](DealID,AsOfDate,CumulativeProbability,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
	SELECT @PhtmDealid as DealID,AsOfDate,CumulativeProbability,CreatedBy,getdate(),updatedBy,getdate() 
	FROM [CRE].[DealProjectedPayOffAccounting]  
	Where dealid = @LegalDealid

	Update CRE.Deal SET 
	CRE.Deal.RepaymentAutoSpreadMethodID = a.RepaymentAutoSpreadMethodID,
	CRE.Deal.PossibleRepaymentdayofthemonth	= a.PossibleRepaymentdayofthemonth,
	CRE.Deal.Repaymentallocationfrequency= a.Repaymentallocationfrequency,
	CRE.Deal.Blockoutperiod= a.Blockoutperiod,
	CRE.Deal.EnableAutoSpreadRepayments= a.EnableAutoSpreadRepayments,
	CRE.Deal.ApplyNoteLevelPaydowns= a.ApplyNoteLevelPaydowns,
	CRE.Deal.AutoUpdateFromUnderwriting= a.AutoUpdateFromUnderwriting,

	CRE.Deal.ExpectedFullRepaymentDate= a.ExpectedFullRepaymentDate,
	CRE.Deal.EarliestPossibleRepaymentDate= a.EarliestPossibleRepaymentDate,
	CRE.Deal.LatestPossibleRepaymentDate= a.LatestPossibleRepaymentDate,
	CRE.Deal.AutoPrepayEffectiveDate= a.AutoPrepayEffectiveDate

	From(
		Select RepaymentAutoSpreadMethodID
		,PossibleRepaymentdayofthemonth	
		,Repaymentallocationfrequency
		,Blockoutperiod
		,EnableAutoSpreadRepayments
		,ApplyNoteLevelPaydowns
		,AutoUpdateFromUnderwriting

		,ExpectedFullRepaymentDate
		,EarliestPossibleRepaymentDate
		,LatestPossibleRepaymentDate
		,AutoPrepayEffectiveDate
		From CRE.Deal where dealid = @LegalDealid
	)a
	where CRE.Deal.dealid = @PhtmDealid



	


	----Update wire confirm = 0 If....-------
	---1.If unwired any record in legal deal
	Update CRE.DealFunding set Applied = 0 where dealid = @PhtmDealid and Applied = 1 
	and LegalDeal_DealFundingID in (Select DealFundingID from [CRE].[DealFunding] where DealID =@LegalDealid and Applied = 0 )


	---2.If changes in amount/date/purpose in legal deal
	Update CRE.DealFunding set Applied = 0 where dealid = @PhtmDealid and Applied = 1 
	and LegalDeal_DealFundingID in (
		Select Ph.LegalDeal_DealFundingID 	--Ph.DealFundingID ,Ph.date,Ph.amount,Ph.purposeid,Ph.LegalDeal_DealFundingID ,Lg.DealFundingID
		from cre.DealFunding Ph 
		LEFT JOIN(
			Select L.DealFundingID ,L.date,L.amount,L.purposeid from cre.DealFunding L
			where L.dealid = @LegalDealid
			and L.Applied = 1
		)Lg on Ph.LegalDeal_DealFundingID = Lg.DealFundingID and Ph.date = Lg.date and Ph.amount = Lg.amount and Ph.purposeid = Lg.purposeid
		where Ph.dealid = @PhtmDealid
		and Ph.Applied = 1 
		and Lg.DealFundingID is null
	)

	----------------------------------------
	IF OBJECT_ID('tempdb..#tblBK_Phtm_DealFunding') IS NOT NULL             
	DROP TABLE #tblBK_Phtm_DealFunding          
            
	CREATE TABLE #tblBK_Phtm_DealFunding 
	(
		[DealFundingID] [uniqueidentifier] NOT NULL,
		[DealID] [uniqueidentifier] NOT NULL,
		[Date] [date] NULL,
		[Amount] [decimal](28, 15) NULL,
		[CreatedBy] [nvarchar](256) NULL,
		[CreatedDate] [datetime] NULL,
		[UpdatedBy] [nvarchar](256) NULL,
		[UpdatedDate] [datetime] NULL,
		[Comment] [nvarchar](max) NULL,
		[PurposeID] [int] NULL,
		[Applied] [bit] NULL,
		[DrawFundingId] [nvarchar](256) NULL,
		[Issaved] [bit] NULL,
		[DealFundingRowno] [int] NULL,
		[DeadLineDate] [date] NULL,
		[LegalDeal_DealFundingID] [uniqueidentifier] NULL,
		[SubPurposeType] [nvarchar](256) NULL,
		[EquityAmount] [decimal](28, 15) NULL,
		[RemainingFFCommitment] [decimal](28, 15) NULL,
		[RemainingEquityCommitment] [decimal](28, 15) NULL
	)
	INSERT INTO #tblBK_Phtm_DealFunding(
	DealFundingID
	,DealID
	,Date
	,Amount
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate
	,Comment
	,PurposeID
	,Applied
	,DrawFundingId
	,Issaved
	,DealFundingRowno
	,DeadLineDate
	,LegalDeal_DealFundingID
	,SubPurposeType
	,EquityAmount
	,RemainingFFCommitment
	,RemainingEquityCommitment)
	Select 
	DealFundingID
	,DealID
	,Date
	,Amount
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate
	,Comment
	,PurposeID
	,Applied
	,DrawFundingId
	,Issaved
	,DealFundingRowno
	,DeadLineDate
	,LegalDeal_DealFundingID
	,SubPurposeType
	,EquityAmount
	,RemainingFFCommitment
	,RemainingEquityCommitment
	FROM Cre.DealFunding where DealID in (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0 )
	---==================================================================

	
	
	--Delete WorkFlow of Phtm Deal
	Delete from cre.WFTaskDetail where TaskID in (Select DealFundingID FROM CRE.DealFunding where DealID = @PhtmDealID and Applied = 0)
	Delete from cre.WFTaskDetailArchive where TaskID in (Select DealFundingID FROM CRE.DealFunding where DealID = @PhtmDealID and Applied = 0)
	Delete from cre.WFCheckListDetail where TaskID in (Select DealFundingID FROM CRE.DealFunding where DealID = @PhtmDealID and Applied = 0)
	Delete from cre.WFTaskAdditionalDetail where TaskID in (Select DealFundingID FROM CRE.DealFunding where DealID = @PhtmDealID and Applied = 0)
	Delete from cre.[WFNotification] where TaskID in (Select DealFundingID FROM CRE.DealFunding where DealID = @PhtmDealID and Applied = 0)
	
	--need to change
	--Delete from [CRE].[DealFunding] where DealID in (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0 )
	Delete from [CRE].[DealFunding] where DealFundingAutoID in (Select DealFundingAutoID from [CRE].[DealFunding] where DealID in (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0) )
	and Applied = 0



	---Capture dealfundingid of leagal deal to copy in phantom deal
	Declare @tbl_Lagal_DealFundingID as Table(
		Legal_DealFundingID UNIQUEIDENTIFIER
	)

	INSERT INTO @tbl_Lagal_DealFundingID(Legal_DealFundingID)
	Select DealFundingID from(
		--Non Wired
		Select df.DealFundingID FROM CRE.DealFunding df
		where DealID in (Select dealid from cre.Deal where CREDealID = @CREDealID) and Applied = 0

		UNION

		--Newly added record
		Select df.DealFundingID FROM CRE.DealFunding df
		where DealID in (Select dealid from cre.Deal where CREDealID = @CREDealID)
		and df.DealFundingID not in (Select df_bk.LegalDeal_DealFundingID from #tblBK_Phtm_DealFunding df_bk)

		UNION

		--New wired confirm record from legal
		Select df.DealFundingID FROM CRE.DealFunding df
		where DealID in (Select dealid from cre.Deal where CREDealID = @CREDealID)
		and df.DealFundingID not in (Select df_bk.LegalDeal_DealFundingID from #tblBK_Phtm_DealFunding df_bk where Applied = 1)

	)a

	

	--insert Delafunding in phtm deal
	INSERT INTO CRE.DealFunding
	(
		DealID,
		[Date],
		Amount,
		Comment,
		PurposeID,
		Applied	,
		DrawFundingId,
		Issaved,
		DealFundingRowno,
		CreatedBy,
		CreatedDate,
		UpdatedBy,
		UpdatedDate,
		LegalDeal_DealFundingID,
		AdjustmentType
	)
	Select 
	(Select dealid from cre.Deal where LinkedDealID = (Select CREDealID from cre.Deal where DealID = df.DealID) and IsDeleted=0),
	[Date],
	Amount,
	Comment,
	PurposeID,
	Applied	,
	DrawFundingId,
	Issaved,
	DealFundingRowno,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate ,
	df.DealFundingID,
	df.AdjustmentType
	FROM CRE.DealFunding df
	where DealID in (Select dealid from cre.Deal where CREDealID = @CREDealID) 
	and df.DealFundingID in (Select Legal_DealFundingID from @tbl_Lagal_DealFundingID)

	----======Remove all wire confirmed=============
	--Update CRE.DealFunding set CRE.DealFunding.Applied = 0 where DealID in (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0)

	--Update core.FundingSchedule set Applied = 0
	--	Where EventID in (
	--		Select b.EventID from(
	--			Select a.CrenoteID,a.EventID,a.EffectiveStartDate,ROW_NUMBER() OVER (PARTITION BY  a.crenoteid  ORDER BY a.crenoteid,a.EffectiveStartDate desc) AS SNO
	--			from(
	--				Select  Distinct e.EffectiveStartDate,E.eventid,n.crenoteid
	--				from [CORE].FundingSchedule fs
	--				INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
	--				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	--				where ISNULL(e.StatusID,1)= 1 
	--				and n.Dealid = @PhtmDealid
	--			)a
	--		)b where b.Sno = 1
	--)
	----===================

	--uncheck wire confirm if found new wire confirmed record in legal deal
	Update CRE.DealFunding set Applied = 0 where dealid = @PhtmDealid and Applied = 1 
	and LegalDeal_DealFundingID not in (Select df_bk.LegalDeal_DealFundingID from #tblBK_Phtm_DealFunding df_bk where df_bk.Applied = 1)


	--Update CRE.DealFunding set CRE.DealFunding.Applied = 0
	--From(
	--	Select df.DealFundingid,df.dealid,df.LegalDeal_DealFundingID 
	--	FROM CRE.DealFunding df	
	--	where df.DealID in (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0)
	--	and df.Applied = 1
	--	and df.LegalDeal_DealFundingID not in (Select df_bk.LegalDeal_DealFundingID from #tblBK_Phtm_DealFunding df_bk)
	--)a
	--where CRE.DealFunding.DealFundingID = a.DealFundingid and CRE.DealFunding.DealID = a.dealid and CRE.DealFunding.LegalDeal_DealFundingID = a.LegalDeal_DealFundingID


	---Update wire = 0 by date
	Update CRE.DealFunding set CRE.DealFunding.Applied = 0
	From(
		Select df.dealid,df.[Date] 
		FROM #tblBK_Phtm_DealFunding df	
		where df.Applied = 0		
	)a
	where CRE.DealFunding.dealid = a.dealid and CRE.DealFunding.[Date] = a.[Date] 

	

	---Update AdjustmentType from legal to phantom
	Update CRE.DealFunding set CRE.DealFunding.AdjustmentType = a.AdjustmentType
	From(
		Select dfPhtm.DealID,dfPhtm.DealFundingID,dfLg.AdjustmentType 
		from cre.DealFunding dfLg
		Inner Join(
			Select DealID,DealFundingID,LegalDeal_DealFundingID,AdjustmentType 
			from cre.DealFunding df
			where dealid= @PhtmDealid
		)dfPhtm on dfLg.DealFundingID = dfPhtm.LegalDeal_DealFundingID
		where dfLg.dealid= @LegalDealid
		and dfLg.AdjustmentType is not null

	)a
	where CRE.DealFunding.dealid = a.dealid and CRE.DealFunding.DealFundingID = a.DealFundingID 





	----INsert workflow for phtm deal
	EXEC [dbo].[usp_CopyWorkFlowToPhantom] @PhtmDealid
	----==================

END


END


