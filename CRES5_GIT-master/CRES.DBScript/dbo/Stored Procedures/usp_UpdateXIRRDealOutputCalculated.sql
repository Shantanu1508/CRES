-- Procedure

CREATE PROCEDURE [dbo].[usp_UpdateXIRRDealOutputCalculated] --3,371327,'4214D765-289F-4EE6-8716-085428CDE39E','B0E6697B-3534-4C09-BE0A-04473401AB93',''
	@XIRRConfigID int,
	@XIRRReturnGroupID int,
	@DealAccountID nvarchar(256),
	@UserID UNIQUEIDENTIFIER,
	@CutOffDate Date = NULL

AS  
BEGIN    
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @FinancingSource nvarchar(256); 

	select @FinancingSource = finsrcforwholeloaninvcalc
	from cre.xirrconfig where xirrconfigid = @XIRRConfigID;

	IF(@CutOffDate is null)
	BEGIN
		SET @CutOffDate = (Select CutoffDateOverride from Cre.XIRRConfig Where XIRRConfigID=@XIRRConfigID)
		
		IF(@CutOffDate is null)
		BEGIN
			SET @CutOffDate = (Select EOMONTH(GETDATE(), -1) LastMonthEndDate)
		END
	END
	

	
	Declare @AnalysisID UNIQUEIDENTIFIER;

	SET @AnalysisID = (Select AnalysisID  from cre.XIRRConfig Where XIRRConfigID = @XIRRConfigID);



	IF OBJECT_ID('TempDB..#tmp_RateSpread') IS NOT NULL
		Drop Table #tmp_RateSpread;

	Create Table #tmp_RateSpread(
		DealID uniqueidentifier,
		CREDealID nvarchar(256),
		NoteID uniqueidentifier,
		CRENoteID nvarchar(256),
		NoteName nvarchar(256),
		RateType nvarchar(256) NULL,
		Spread decimal(28,15) NULL,
		FixedRate decimal(28,15) NULL,
		Commitment decimal(28,15) NULL,
		DebtTypeID int NULL,
		BillingNotesID int NULL,
		FinancingSourceName nvarchar(256) NULL
	);

	INSERT INTO #tmp_RateSpread (DealID,CREDealID,NoteId,CRENoteID,NoteName,RateType,[Spread],FixedRate,Commitment,DebtTypeID,BillingNotesID,FinancingSourceName)
	SELECT DealID,CREDealID,NoteId,CRENoteID,NoteName,RateType,[Spread],ISNULL([Rate],([Spread] + [Reference Rate])) AS FixedRate,Commitment,DebtTypeID,BillingNotesID,FinancingSourceName
	FROM(
		SELECT DealID,CREDealID,NoteId,CRENoteID,[Rate],[Spread],[Reference Rate],NoteName,Commitment,DebtTypeID,BillingNotesID,FinancingSourceName,
		(CASE WHEN (Spread IS NOT NULL AND [Reference Rate] IS NOT NULL) OR ([Rate] IS NOT NULL AND Spread IS NULL AND [Reference Rate] IS NULL) THEN 'Fixed' ELSE 'ARM' END) AS RateType
		FROM(	
			Select * from (
				SELECT n1.NoteID, LValueTypeID.[NAME] AS ValueType,rs.[Value], ac.[Name] AS 'NoteName',NtAdj.NoteTotalCommitment as 'Commitment'
				,D.DealID,CREDealID,CRENoteID,n1.DebtTypeID,n1.BillingNotesID,FinancingSourceName,
					ROW_NUMBER() Over (Partition by n1.noteid,rs.ValueTypeID order by n1.noteid,rs.ValueTypeID,rs.date desc) as rno
				FROM [CORE].RateSpreadSchedule rs
				INNER JOIN [CORE].[Event] e ON e.EventID = rs.EventId
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				INNER JOIN(					
					SELECT 
					(SELECT AccountID FROM [CORE].[Account] ac WHERE ac.AccountID = n.Account_AccountID) AccountID,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID,FSM.FinancingSourceName
					FROM [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					INNER JOIN CRE.Deal D1 ON D1.DealID=N.DealID
					LEFT JOIN [CRE].[FinancingSourceMaster] FSM ON FSM.FinancingSourceMasterID = N.FinancingSourceID
					WHERE EventTypeID = 14 AND D1.AccountID = @DealAccountID AND eve.StatusID = 1 AND acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID,FSM.FinancingSourceName
				) sEvent
				ON sEvent.AccountID = e.AccountID AND e.EffectiveStartDate = sEvent.EffectiveStartDate AND e.EventTypeID = sEvent.EventTypeID
				INNER JOIN core.Account ac ON ac.AccountID =e.AccountID
				INNER JOIN cre.Note n1 ON n1.Account_AccountID = ac.AccountID
				INNER JOIN [CRE].[Deal] D ON D.DealID = n1.DealID
				LEFT JOIN (
					Select NoteID,NoteTotalCommitment
					From(			
						SELECT NoteTotalCommitment
						,nd.NoteID
						,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,
						nd.Rowno
						from cre.NoteAdjustedCommitmentMaster nm
						left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
						right join cre.deal d on d.DealID=nm.DealID
						Right join cre.note n on n.NoteID = nd.NoteID
						inner join core.account acc on acc.AccountID = n.Account_AccountID
						where d.IsDeleted<>1 and acc.IsDeleted<>1 AND D.AccountID = @DealAccountID
					)a
					where rno =  1
				) NtAdj ON NtAdj.NoteID = N1.NoteID
				WHERE e.StatusID = 1 AND D.AccountID = @DealAccountID 
				AND rs.[Date] <= ISNULL(n1.ActualPayoffDate,CAST(GETDATE() AS Date))
			)z Where rno=1
		) AS SourceTable
		PIVOT  
		(
			MIN([Value])  
			FOR ValueType IN ([Rate],[Spread],[Reference Rate])  
		) AS PivotTable
	)z

	
	---Associate notes with tag
	Declare @tblNoteIDTags as table
	(
		DealID UNIQUEIDENTIFIER,
		NoteID UNIQUEIDENTIFIER
	)
	INSERT INTO @tblNoteIDTags(DealID,NoteID)
	Select d.dealid,n.noteid 
	from [CRE].[TagAccountMappingXIRR] tm
	Inner join cre.note n on n.account_accountid= tm.Accountid
	Inner join cre.deal d on d.dealid = n.dealid
	where TagMasterXIRRID in (
		Select objectID from cre.XIRRConfigDetail where xirrconfigid = @XIRRConfigID and ObjectType = 'Tag'
	)
	and d.accountid = @DealAccountID

	Declare @tblNoteIDDelphi as table
	(
		DealID UNIQUEIDENTIFIER,
		NoteID UNIQUEIDENTIFIER
	)
	INSERT INTO @tblNoteIDDelphi(DealID,NoteID)
	Select d.dealid,n.noteid
	from cre.note n 
	Inner join cre.deal d on d.dealid = n.dealid
	left join cre.financingsourcemaster f on n.financingsourceid = f.financingsourcemasterid
	where f.financingsourcename LIKE '%' + @FinancingSource + '%'
	and d.accountid = @DealAccountID

	UPDATE Dout SET
	Dout.WholeLoanInvestment=ROUND(ISNULL(NWhole.TotalCommitment, 0),2),
	Dout.SubordinateDebtInvestment=ROUND(ISNULL(NSub.TotalCommitment, 0),2),
	Dout.SeniorDebtInvestment=ROUND((ISNULL(NWhole.TotalCommitment, 0) - ISNULL(NSub.TotalCommitment, 0)),2),
	Dout.OutstandingBalance=ROUND(ISNULL(NOut.OutstandingBalance, 0),2),
	Dout.CapitalInvested=ROUND(ISNULL(NCap.CapitalInvested, 0),2),
	Dout.ProjCapitalInvested=ROUND(ISNULL(NProj.ProjCapitalInvested, 0),2),
	Dout.RealizedProceeds=ROUND((ISNULL(NCap.CapitalInvested, 0) + ISNULL(NTotalCF.TotalCF, 0)),2),
	Dout.UnrealizedProceeds=ROUND(((ISNULL(NProj.ProjCapitalInvested, 0) + ISNULL(NTotalProj.ProjectedTotalCF, 0)) - (ISNULL(NCap.CapitalInvested, 0) + ISNULL(NTotalCF.TotalCF, 0))),2),
	Dout.TotalProceeds=ROUND((ISNULL(NProj.ProjCapitalInvested, 0) + ISNULL(NTotalProj.ProjectedTotalCF, 0)),2),
	Dout.WholeLoanSpread=ISNULL(NWholeLoanSpread.WholeLoanSpread, 0),
	Dout.SubDebtSpread=ISNULL(NSubDebtSpread.SubDebtSpread, 0),
	Dout.SeniorDebtSpread=ISNULL(NSeniorDebtSpread.SeniorDebtSpread, 0),
	Dout.UpdatedBy=@UserID,
	Dout.UpdatedDate=GETDATE(),
	Dout.CutoffDateOverride=@CutOffDate,
	Dout.MultipleCalculation = 
    CASE 
        WHEN ROUND(ISNULL(NProj.ProjCapitalInvested, 0), 2) = 0 THEN NULL
        ELSE ROUND((ISNULL(NProj.ProjCapitalInvested, 0) + ISNULL(NTotalProj.ProjectedTotalCF, 0)),2)/ROUND(ISNULL(NProj.ProjCapitalInvested, 0),2)
    END

	From [CRE].[XIRROutputDealLevel] Dout INNER JOIN [CRE].[Deal] DL ON DL.AccountID=Dout.DealAccountID
	Left Join (
				Select DealID,SUM(NoteTotalCommitment) AS 'TotalCommitment'
				FROM(       
					SELECT 
					d.dealid
					,NoteTotalCommitment    
					,ROW_NUMBER() OVER (PARTITION BY nd.NoteID ORDER BY nd.NoteID,nd.RowNo DESC ,[DATE]) as RNo
					FROM CRE.NoteAdjustedCommitmentMaster nm
					LEFT JOIN CRE.NoteAdjustedCommitmentDetail nd ON nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID    
					RIGHT JOIN CRE.Deal d ON d.DealID = nm.DealID    
					RIGHT JOIN CRE.Note n ON n.NoteID = nd.NoteID    
					INNER JOIN CORE.LOOKUP L ON L.LookupID = n.BillingNotesID 
					INNER JOIN CORE.account acc ON acc.AccountID = n.Account_AccountID    
					INNER JOIN (
						SELECT DealID, NoteID FROM @tblNoteIDDelphi WHERE @FinancingSource IS NOT NULL

						UNION ALL

						SELECT DealID, NoteID FROM @tblNoteIDTags WHERE @FinancingSource IS NULL
					) AS tn ON tn.DealID = d.DealID AND tn.NoteID = n.NoteID

					WHERE d.IsDeleted<>1 AND acc.IsDeleted<>1 AND [Date] <= CAST(GETDATE() AS DATE)
					AND D.AccountID = @DealAccountID 	
				)a    
				WHERE RNo =  1  
				GROUP BY DealID
	) as NWhole ON NWhole.DealID=DL.DealID
	Left Join (
				Select DealID,SUM(NoteTotalCommitment) AS 'TotalCommitment'
				FROM(       
					SELECT 
					d.dealid
					,NoteTotalCommitment    
					,ROW_NUMBER() OVER (PARTITION BY nd.NoteID ORDER BY nd.NoteID,nd.RowNo DESC ,[DATE]) as RNo
					FROM CRE.NoteAdjustedCommitmentMaster nm
					LEFT JOIN CRE.NoteAdjustedCommitmentDetail nd ON nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID    
					RIGHT JOIN CRE.Deal d ON d.DealID = nm.DealID    
					RIGHT JOIN CRE.Note n ON n.NoteID = nd.NoteID    
					INNER JOIN CORE.LOOKUP L ON L.LookupID = n.DebtTypeID 
					INNER JOIN CORE.account acc ON acc.AccountID = n.Account_AccountID  
					INNER JOIN (
						SELECT DealID, NoteID FROM @tblNoteIDDelphi WHERE @FinancingSource IS NOT NULL

						UNION ALL

						SELECT DealID, NoteID FROM @tblNoteIDTags WHERE @FinancingSource IS NULL
					) AS tn ON tn.DealID = d.DealID AND tn.NoteID = n.NoteID

					WHERE d.IsDeleted<>1 AND acc.IsDeleted<>1 AND [Date] <= CAST(GETDATE() AS DATE)
					AND D.AccountID = @DealAccountID 
				)a    
				WHERE RNo =  1  
				GROUP BY DealID
	) as NSub ON NSub.DealID=DL.DealID
	Left Join (
			Select dealid,SUM(EndingBalance) as OutstandingBalance
			From(  
				Select d.dealid,n.noteid,AllinCouponRate,EndingBalance ,ROW_NUMBER() Over(Partition by d.dealid,n.noteid order by d.dealid,n.noteid,PeriodEndDate desc) rno  
				from cre.NotePeriodicCalc  nc
				Inner join cre.note n on n.account_accountid = nc.accountid
				Inner join cre.deal d on d.dealid = n.dealid

				Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
				where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  		 
				and PeriodEndDate <= Cast(@CutOffDate as Date) 
				---and nc.EndingBalance is not null
				and d.AccountID = @DealAccountID
			)a where rno = 1  
			group by DealID
	) as NOut ON NOut.DealID=DL.DealID
	Left Join (
				Select DealID,ABS(SUM(Amount)) as 'CapitalInvested' From 
				(
					Select DealAccountId as DealID,Amount as 'Amount' From 
					[CRE].[XIRRInputCashflow] xc
					Inner join cre.note n on n.account_accountid = xc.NoteAccountID
					Inner join cre.deal d on d.dealid = n.dealid
					Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
					WHERE XIRRConfigID=@XIRRConfigID
					AND [TransactionDate]<=@CutOffDate 
					AND [TransactionType] in ('FundingOrRepayment')
					AND Amount < 0

					UNION ALL

					Select DealAccountId as DealID, Amount as 'Amount' From 
					[CRE].[XIRRInputCashflow] xc
					Inner join cre.note n on n.account_accountid = xc.NoteAccountID
					Inner join cre.deal d on d.dealid = n.dealid
					Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
					WHERE XIRRConfigID=@XIRRConfigID
					and [TransactionDate]<=@CutOffDate 
					AND [TransactionType] in ('InitialFunding','PIKPrincipalFunding')
				) RES
				GROUP BY DealID
	) as NCap ON NCap.DealID=DL.AccountID
	Left Join (
				Select DealID,ABS(SUM(Amount)) as 'ProjCapitalInvested' From 
				(
					Select DealAccountId as DealID,Amount as 'Amount' 
					From [CRE].[XIRRInputCashflow] xc
					Inner join cre.note n on n.account_accountid = xc.NoteAccountID
					Inner join cre.deal d on d.dealid = n.dealid
					Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
					WHERE XIRRConfigID=@XIRRConfigID
					AND [TransactionType] in ('FundingOrRepayment')
					AND Amount < 0

					UNION ALL

					Select DealAccountId as DealID,Amount as 'Amount'
					From [CRE].[XIRRInputCashflow] xc
					Inner join cre.note n on n.account_accountid = xc.NoteAccountID
					Inner join cre.deal d on d.dealid = n.dealid
					Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
					WHERE XIRRConfigID=@XIRRConfigID
					and [TransactionType] in ('InitialFunding','PIKPrincipalFunding')
				) Res
				GROUP BY DealID
	) as NProj ON NProj.DealID=DL.AccountID
	Left Join (
				Select DealID,SUM(Amount) as 'ProjectedTotalCF' From 
				(
					Select xc.DealAccountId as DealID,xc.Amount 
					From [CRE].[XIRRInputCashflow] xc
					Inner join cre.note n on n.account_accountid = xc.NoteAccountID
					Inner join cre.deal d on d.dealid = n.dealid
					Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
					Where XIRRConfigID=@XIRRConfigID AND DealAccountID=@DealAccountID 
					AND AnalysisID=@AnalysisID
				) RES
				GROUP BY DealID
	) as NTotalProj ON NTotalProj.DealID=DL.AccountID
	Left Join (
				Select DealID,SUM(Amount) as 'TotalCF' From 
				(
					Select DealAccountId as DealID,Amount 
					From [CRE].[XIRRInputCashflow] xc
					Inner join cre.note n on n.account_accountid = xc.NoteAccountID
					Inner join cre.deal d on d.dealid = n.dealid
					Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
					Where XIRRConfigID=@XIRRConfigID AND DealAccountID=@DealAccountID 
					AND AnalysisID=@AnalysisID
					AND TransactionDate<=@cutoffDate
				) RES
				GROUP BY DealID
	) as NTotalCF ON NTotalCF.DealID=DL.AccountID
	Left Join (

		Select n.DealID,SUM(n.WeightedSpread) as 'WholeLoanSpread' 
		from CRE.Note n
		Inner join cre.deal d on d.dealid = n.dealid
		Inner Join @tblNoteIDTags tn on tn.DealID = d.DealID and tn.NoteID = n.NoteID
		Group By n.DealID

	) as NWholeLoanSpread ON NWholeLoanSpread.DealID=DL.DealID
	Left Join (
		Select DealID,(Sum(RateValue)/Sum(TotalCommitment)) as 'SubDebtSpread' from (
			Select rs.DealID,rs.CREDealID,
			Commitment*Spread as 'RateValue',
			Commitment as 'TotalCommitment'
			from #tmp_RateSpread rs
			INNER Join @tblNoteIDTags tn on tn.NoteID = rs.NoteID  ----instead of billing note
			LEFT JOIN CORE.LOOKUP L ON L.LookupID = rs.DebtTypeID  ----- rs.BillingNotesID  change by vishal
			Where  Commitment IS NOT NULL AND Commitment<>0
			--AND CREDealID NOT IN ('15-0218','15-0051','15-0151P','15-0140P','16-0443P','15-0244','17-0601')
			AND L.[Name] = 'Sub'			
			AND FinancingSourceName = 'Delphi ACORE'
		) Res Group By DealID
	) as NSubDebtSpread ON NSubDebtSpread.DealID=DL.DealID
	Left Join (
		Select DealID,(Sum(RateValue)/Sum(TotalCommitment)) as 'SeniorDebtSpread' from (
			Select DealID,CREDealID,
			Commitment*Spread as 'RateValue',
			Commitment as 'TotalCommitment'
			from #tmp_RateSpread rs
			LEFT JOIN CORE.LOOKUP L ON L.LookupID = rs.DebtTypeID
			Where  Commitment IS NOT NULL AND Commitment<>0
			AND L.[Name] = 'Senior'
		) Res Group By DealID
	) as NSeniorDebtSpread ON NSeniorDebtSpread.DealID=DL.DealID
	Where DOut.XIRRConfigID = @XIRRConfigID and DOut.XIRRReturnGroupID = @XIRRReturnGroupID and DOut.DealAccountID = @DealAccountID
END