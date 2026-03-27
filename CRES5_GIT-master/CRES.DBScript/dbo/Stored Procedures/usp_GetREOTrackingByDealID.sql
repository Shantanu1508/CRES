--[dbo].[usp_GetREOTrackingByDealID] '9DE73D71-B4B2-4CD8-B885-6F9817AD812B'  
--[dbo].[usp_GetREOTrackingByDealID] '830fb95c-61ff-45eb-ad25-16cbef7a196b'
CREATE PROCEDURE [dbo].[usp_GetREOTrackingByDealID]  
 @DealID as uniqueidentifier   
AS   
BEGIN   
    
	SET NOCOUNT ON;   
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
   
   
	IF OBJECT_ID('tempdb..#TempFundingSchedule') IS NOT NULL             
	DROP TABLE #TempFundingSchedule 	

	SELECT 
		n.NoteID,
		fs.date,
		fs.Value AS FFValue
	INTO #TempFundingSchedule 
	FROM [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e ON e.EventID = fs.EventId
	INNER JOIN (
		SELECT 
			(SELECT AccountID 
			 FROM [CORE].[Account] ac 
			 WHERE ac.AccountID = n.Account_AccountID) AS AccountID,
			MAX(EffectiveStartDate) AS EffectiveStartDate,
			EventTypeID, 
			eve.StatusID
		FROM [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		WHERE EventTypeID = (SELECT LookupID 
							  FROM CORE.[Lookup] 
							  WHERE Name = 'FundingSchedule')
		  AND acc.IsDeleted = 0
		  AND n.DealID = @DealID
		  AND eve.StatusID = (SELECT LookupID 
							   FROM Core.Lookup 
							   WHERE name = 'Active' 
								 AND ParentID = 1)
		GROUP BY n.Account_AccountID, EventTypeID, eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID
	   AND e.EffectiveStartDate = sEvent.EffectiveStartDate
	   AND e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	WHERE sEvent.StatusID = e.StatusID
	  AND acc.IsDeleted = 0
	  AND n.DealID = @DealID
	  AND fs.Date >= n.ClosingDate
	  AND fs.Date <= CAST(GETDATE() AS DATE)
	  AND fs.PurposeID != 875

	  Declare @AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from core.analysis where name = 'Default')  ;


	SELECT 
		n.DealID,
		n.NoteID,
		CRENoteID,
		acc.Name as 'NoteName',
		notetype.Name as 'NoteType' ,
		llienposition.LookupID as LienPositionID,
		llienposition.name as 'LienPosition',
		[Priority],
		FSW.[PriorityOverride],
		n.InitialFundingAmount,
		ISNULL(trpik.PikAmount, 0) + ISNULL(npc.EndingBalanceSum, 0) + ISNULL(tfs.TotalFFValue, 0) AS EstBls,
		n.UPBAtForeclosure,
		tf.FFValue,
		CASE
		WHEN EXISTS (SELECT 1 FROM [CRE].[Note] n2 WHERE n2.DealID = @DealID AND n2.NoteType = 901) 
        THEN ISNULL(n.UPBAtForeclosure, 0) + ISNULL(tf.FFValue, 0)
        ELSE NULL 
	   END AS NetCapitalInvested

	FROM CRE.Note n

	LEFT JOIN (
	Select noteid,SUM(ffvalue) ffvalue from #TempFundingSchedule group by noteid
	)tf ON tf.NoteID = n.NoteID 
	
	LEFT JOIN (
		SELECT 
			n.NoteID,
			SUM(tr.Amount * -1) AS PikAmount
		FROM cre.transactionEntry tr
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID
		INNER JOIN cre.note n ON n.Account_AccountID = acc.AccountID
		WHERE tr.analysisID = CONVERT(VARCHAR(MAX), @AnalysisID)
		  AND tr.[Type] IN ('PikPrincipalPaid', 'PIKPrincipalFunding')
		  AND tr.date = CAST(GETDATE() AS DATE)
		  AND n.dealid = @DealID
		  AND acc.AccounttypeID = 1
		GROUP BY n.NoteID
	) trpik ON trpik.NoteID = n.NoteID

	LEFT JOIN (
		SELECT 
			nn.NoteID,
			SUM(ISNULL(EndingBalance, 0)) AS EndingBalanceSum
		FROM [CRE].[NotePeriodicCalc] np
		INNER JOIN cre.note nn ON nn.account_accountid = np.accountid
		WHERE nn.dealid = @DealID
		  AND np.PeriodEndDate = CAST(GETDATE() - 1 AS DATE)
		  AND np.AnalysisID = @AnalysisID
		GROUP BY nn.NoteID
	) npc ON npc.NoteID = n.NoteID
	
	
	LEFT JOIN (
		SELECT 
			tf.NoteID,
			ISNULL(SUM(tf.FFValue), 0) AS TotalFFValue
		FROM #TempFundingSchedule tf
		WHERE tf.date = CAST(GETDATE() AS DATE)
		GROUP BY tf.NoteID  
	) tfs ON tfs.NoteID = n.NoteID

	
	LEFT JOIN Core.Lookup llienposition ON n.lienposition=llienposition.LookupID 
	LEFT JOIN [CRE].[FundingRepaymentSequenceWriteOff] FSW on FSW.DealID=n.DealID AND n.NoteID=FSW.NoteID
    LEFT JOIN Core.Lookup notetype ON n.NoteType=notetype.LookupID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID

	WHERE n.DealID = @DealID and acc.isdeleted = 0
	
	order by ISNULL(llienposition.LookupID,99999),[Priority],InitialFundingAmount desc, NoteName 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END