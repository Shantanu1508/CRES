-- Procedure
-- Procedure

CREATE PROCEDURE [DW].[usp_Calculations_AfterMerge]
	@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON;

	Print('usp_Calculations_AfterMerge - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	
	UPDATE BatchLog
	SET Status = 'POST-CALCULATIONS',
		LogText = 'Post Calculation Start: ' +  CONVERT(VARCHAR,GETDATE(),8) + CHAR(13) + CHAR(10)
	WHERE BatchLogId = @BatchLogId

--	EXEC [DW].[usp_ImportNoteCashflowPercentageColumns]	

	EXEC [DW].[usp_Calculations_CalendarPeriodBI]
	EXEC [DW].[usp_Calculations_CalendarBI]

	EXEC [DW].[usp_ImportFeeSchedule]	
	EXEC [DW].[usp_ImportFeeFunctionsDefinition]
	EXEC [DW].[usp_ImportFeeBaseAmountDetermination]
	EXEC [DW].[usp_ImportAnalysis]


	--Procedures depent if changed on Transaction entry and Noteperiodic tables
	IF EXISTS(Select top 1 NoteID from [DW].[L_TransactionEntryBI])
	BEGIN
		----EXEC [DW].[usp_ImportTransactionByEntity]
		----EXEC [DW].[usp_ImportNotePeriodicCalcByEntity]	

		-----Working on it optimization
		EXEC [DW].[usp_ImportTransactionEntryPivot]		--VV 10sec  ---1:24
		EXEC [DW].[usp_ImportEventBasedBalance]			--1:26 sec  ---5:10
		-----------

		EXEC [DW].[usp_ImportAdditionalFee_Balance]		--00:00 sec ---24
		EXEC [DW].[usp_ImportStaging_IntegartionCashFlow]
	END
	----------------------------------------------------------------
	
	--------from backshop nightly-----Working on it optimization
	--EXEC [DW].[usp_ImportReconciliationDetail]
	--------------------------------------


	EXEC [DW].[usp_ImportInterimDropDate]
	EXEC [DW].[usp_ImportTransactionActuals]

	--Deactivate User delegation if past away
	Update [App].[UserDelegateConfig] set [IsActive] = 0 where EndDate < Cast(getdate() as date)

	--Update M61Commitment,M61AdjustedCommitment
	Update DW.NoteBI set DW.NoteBI.M61Commitment = z.NoteTotalCommitment, DW.NoteBI.M61AdjustedCommitment = z.NoteAdjustedTotalCommitment
	From(
		Select CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment
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
			--and n.crenoteid in ( '10049')	
		)a
		where rno =  1
	)z
	where z.CRENoteID = DW.NoteBI.CRENoteID

	---Calc notes for DiscrepancyForDuplicatePIK_InBackshop
	--EXEC [dbo].[usp_QueueNoteForCalc_DiscrepancyForDuplicatePIK_InBackshop]


	/* Import for report Liability NoteCapRecon */
		EXEC [DW].[usp_ImportNPCEndingBalanceDefaultScenario]
	--------==============================================
	--Declare @tblTrNote as Table (NoteID UNIQUEIDENTIFIER, [Type] nvarchar(256))

	--INSERT INTO @tblTrNote (NoteID,[Type])
	--Select Distinct Noteid,[Type] from cre.TransactionEntry T 
	--where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
	--and [Type] in ('ScheduledPrincipalPaid','PIKPrincipalPaid','PIKInterestPaid')

	--Update [DW].[NoteBI] SET 
	--[DW].[NoteBI].HasScheduledPrincipal = a.HasScheduledPrincipal,
	--[DW].[NoteBI].HasPIkPrincipalpaid = a.HasPIkPrincipalpaid,
	--[DW].[NoteBI].HasPIkInterestpaid = a.HasPIkInterestpaid
	--From(
	--	Select
	--	n.[NoteID],
	--	(CASE WHEN tblHasScheduledPrincipal.Noteid is null THEN 'No' ELSE 'Yes' END) as HasScheduledPrincipal,
	--	(CASE WHEN tblHasPIkPrincipalpaid.Noteid is null THEN 'No' ELSE 'Yes' END) as HasPIkPrincipalpaid,
	--	(CASE WHEN tblHasPIkInterestpaid.Noteid is null THEN 'No' ELSE 'Yes' END) as HasPIkInterestpaid
	--	From CRE.Note n
	--	Inner Join CORE.Account ac ON ac.AccountID = n.Account_AccountID		
	--	Left JOIN(
	--		Select Noteid from @tblTrNote T where [Type] ='ScheduledPrincipalPaid'
	--	)tblHasScheduledPrincipal on tblHasScheduledPrincipal.noteid = n.noteid
	--	Left JOIN(
	--		Select Noteid from @tblTrNote T where [Type] ='PIKPrincipalPaid'
	--	)tblHasPIkPrincipalpaid on tblHasPIkPrincipalpaid.noteid = n.noteid
	--	Left JOIN(
	--		Select Noteid from @tblTrNote T where [Type] ='PIKInterestPaid'
	--	)tblHasPIkInterestpaid on tblHasPIkInterestpaid.noteid = n.noteid
	--	where ac.isdeleted <> 1
	--)a
	--where [DW].[NoteBI].noteid = a.noteid
	------============================================





	------Riya's view's tables
	--EXEC [dbo].[usp_ImportRunningBalance] 
	--EXEC [dbo].[usp_ImportBalanceRecTool1]
	--exec [dbo].[usp_ImportRunningbalance1] 

	--EXEC [dbo].[usp_ImportStaging_NotePeriodicCalc1]
	--EXEC [dbo].[usp_ImportDev_NotePeriodicCalc1] 
	--EXEC [dbo].[usp_ImportStg_ScheduledPrin] 
	--EXEC [dbo].[usp_ImportDev_ScheduledPrin] 
	--EXEC [dbo].[usp_ImportStg_Balloon]
	--EXEC [dbo].[usp_ImportDev_Balloon]
	--EXEC [dbo].[usp_ImportDev_PIK]
	--EXEC [dbo].[usp_ImportStg_PIK] 
	--EXEC [dbo].[usp_ImportSchedulePricIOterm] 


	------Update backshop current balance in noteperiodic calc "BSCurrentBalance"  --40 sec
	--Update DW.noteperiodiccalcBI set DW.noteperiodiccalcBI.BSCurrentBalance = a.CurrentBalance
	--From(
	--	Select tb.AnalysisID,tb.crenoteid,tb.PeriodEndDate,tb.endingbalance ,BSCash.CurrentBalance
	--	from DW.noteperiodiccalcBI np 
	--	left join [DW].[UwCashflowBI] BSCash on tb.CRENoteId = BSCash.noteid and tb.PeriodEndDate = BSCash.PeriodEndDate	
	--)a
	--Where 
	--DW.noteperiodiccalcBI.crenoteid = a.crenoteid
	--and DW.noteperiodiccalcBI.PeriodEndDate = a.PeriodEndDate
	--and DW.noteperiodiccalcBI.AnalysisID = a.AnalysisID





	exec [DW].[usp_ImportNoteCFPerFromDailyIntAccBI]



	UPDATE BatchLog
	SET LogText = LogText + ', Post Calculation End: ' +  CONVERT(VARCHAR,GETDATE(),8) + CHAR(13) + CHAR(10)
	WHERE BatchLogId = @BatchLogId

END