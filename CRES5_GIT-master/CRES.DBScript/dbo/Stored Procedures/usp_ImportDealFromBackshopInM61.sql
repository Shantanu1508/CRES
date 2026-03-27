-- Procedure

---[dbo].[usp_ImportDealFromBackshopInM61] '25-1930','B0E6697B-3534-4C09-BE0A-04473401AB93'


CREATE PROCEDURE [dbo].[usp_ImportDealFromBackshopInM61] 
@CREDealID nvarchar(256),
@CreatedBy nvarchar(256)
AS
BEGIN
    SET NOCOUNT ON;



IF not EXISTS(Select * from CRE.Deal  where CREDealID = @CREDealID and IsDeleted=0)
BEGIN

	DECLARE @NewDealID nvarchar(256);

	---=====Insert into Account table=====
	DECLARE @insertedAccountID_deal uniqueidentifier; 
	DECLARE @tAccount_deal TABLE (tAccountID_deal UNIQUEIDENTIFIER)      

	DECLARE @tDeal TABLE (tNewDealId UNIQUEIDENTIFIER)

	INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)      
	OUTPUT inserted.AccountID INTO @tAccount_deal(tAccountID_deal) 
	Select 1 as [StatusID]
	,DealName 
	,10 as [AccountTypeID]
	,@CreatedBy as [CreatedBy]
	,getdate() as [CreatedDate]
	,@CreatedBy as [UpdatedBy]
	,getdate() as [UpdatedDate]
	,0 as isdeleted
	From [IO].[L_BackShopDeal]
	where controlid = @CREDealID

	SELECT @insertedAccountID_deal = tAccountID_deal FROM @tAccount_deal;      
	-------------------------------------------

	INSERT INTO CRE.Deal([DealName]
	,[CREDealID]	
	,[Status]
	,[GeneratedBy]   ---By BackShop
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	,loanstatusID
	,isDeleted
	,AccountID
	,AllowSizerUpload) 
	OUTPUT inserted.DealID INTO @tDeal(tNewDealId)
	Select dealname as [DealName]
	,ControlId as [CREDealID]	
	,323 as [Status]
	,256 as [GeneratedBy]   ---By BackShop
	,@CreatedBy as [CreatedBy]
	,getdate() as [CreatedDate]
	,@CreatedBy as [UpdatedBy]
	,getdate() as [UpdatedDate]
	,ls.loanstatusID
	,0 as isDeleted
	,@insertedAccountID_deal as AccountID
	,937 as AllowSizerUpload
	From [IO].[L_BackShopDeal] bd
	left join cre.loanstatus ls on bd.LoanStatusCd_F = ls.LoanStatuscd
	where controlid = @CREDealID

	SELECT @NewDealID = tNewDealId FROM @tDeal;



   -- Note--
	Declare @CRENoteID_New nvarchar(256);

	DECLARE Import_cursor CURSOR 
	FOR 
		Select distinct NoteID from [IO].[L_BackShopNote] where controlid = @CREDealID

	OPEN Import_cursor  
	FETCH NEXT FROM Import_cursor into   @CRENoteID_New
	WHILE @@FETCH_STATUS = 0  
	Begin
  
	
		DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)
		DECLARE @insertedAccountID uniqueidentifier;

		INSERT INTO [Core].[Account]([AccountTypeID]
		,[StatusID]
		,[Name]	
		,[BaseCurrencyID]
		,[PayFrequency]	
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate]
		,IsDeleted)
		OUTPUT inserted.AccountID INTO @tAccount(tAccountID)
		Select 1 as [AccountTypeID]
		,1 as [StatusID]
		,NoteName as [Name]	
		,187 as [BaseCurrencyID]
		,1 as [PayFrequency]	
		,@CreatedBy as [CreatedBy]
		,getdate() as [CreatedDate]
		,@CreatedBy as [UpdatedBy]
		,getdate() as [UpdatedDate]
		,0 as IsDeleted
		From [IO].[L_BackShopNote] where controlid = @CREDealID and NoteId = @CRENoteID_New

		SELECT @insertedAccountID = tAccountID FROM @tAccount;


		DECLARE @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)
		DECLARE @insertedNoteID uniqueidentifier;

		INSERT INTO [CRE].[Note]
		([Account_AccountID]
		,[DealID]
		,[CRENoteID]	
		,[ClosingDate]		
		,LienPosition
		,[priority]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate]	
		,TotalCommitment
		,OriginalTotalCommitment
		,FundingPriority
		,RepaymentPriority
		
		,DeterminationDateLeadDays
		,PaymentDateBusinessDayLag
		,DeterminationDateInterestAccrualPeriod
		,MonthlyDSOverridewhenAmortizing
		,AccrualFrequency
		,RateIndexResetFreq
		,FutureFundingBillingCutoffDay
		,CurtailmentBillingCutoffDay
		,StubPaidinAdvanceYN
		,IncludeServicingPaymentOverrideinLevelYield
		,BillingNotesID
		,StubPaidInArrears
		,SettleWithAccrualFlag
		,LoanPurchase
		,StubInterestPaidonFutureAdvances
		,DeterminationDateReferenceDayoftheMonth
		,LoanType
		,RateType
		,IndexNameID
		,RoundingMethod
		,AmortTerm
		,AmortIntCalcDayCount
		,DebtTypeID
		,CapStack
		,InterestCalculationRuleForPaydowns
		,InterestCalculationRuleForPaydownsAmort
		,IndexRoundingRule
		,IOTerm
		,OriginationFeePercentageRP
		,InitialInterestAccrualEndDate
		,FirstPaymentDate
		,EnableM61Calculations
		)
		OUTPUT inserted.NoteID INTO @tNote(tNewNoteId)
		select @insertedAccountID as [Account_AccountID]
		,@NewDealID as [DealID]
		,NoteID as [CRENoteID]	
		,FundingDate [ClosingDate]		
		,l.LookupID as LienPosition
		,[Priority] as [priority]
		,@CreatedBy as [CreatedBy]
		,getdate() as [CreatedDate]
		,@CreatedBy as [UpdatedBy]
		,getdate() as [UpdatedDate]
		,bn.TotalCommitment
		,bn.TotalCommitment
		,1 as FundingPriority
		,1 as RepaymentPriority
		
		,-2	  as DeterminationDateLeadDays
		,-1	  as PaymentDateBusinessDayLag
		,0	  as DeterminationDateInterestAccrualPeriod
		,0	  as MonthlyDSOverridewhenAmortizing
		,1	  as AccrualFrequency
		,1	  as RateIndexResetFreq
		,1	  as FutureFundingBillingCutoffDay
		,1	  as CurtailmentBillingCutoffDay
		,3	  as StubPaidinAdvanceYN
		,3	  as IncludeServicingPaymentOverrideinLevelYield
		,3	  as BillingNotesID
		,4	  as StubPaidInArrears
		,4	  as SettleWithAccrualFlag
		,4	  as LoanPurchase
		,4	  as StubInterestPaidonFutureAdvances
		,10	  as DeterminationDateReferenceDayoftheMonth
		,24	  as LoanType
		,140  as RateType
		,777  as IndexNameID
		,251  as RoundingMethod
		,360  as AmortTerm
		,360  as AmortIntCalcDayCount
		,442  as DebtTypeID
		,500  as CapStack
		,594  as InterestCalculationRuleForPaydowns
		,594  as InterestCalculationRuleForPaydownsAmort
		,1000 as IndexRoundingRule
		,bn.LoanTerm as IOTerm
		,bn.OriginationFeePct as OriginationFeePercentageRP
		,case when CAST(Concat(Month(bn.FundingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(bn.FundingDate)) as Date) > CAST(bn.FundingDate As Date) Then
			DateAdd(Day,-1, CAST(Concat(Month(bn.FundingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(bn.FundingDate)) as Date))
		ELSE
			DateAdd(Month,1, DateAdd(Day,-1, CAST(Concat(Month(bn.FundingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(bn.FundingDate)) as Date)))
		END As InitialInterestAccrualEndDate
		,case when CAST(Concat(Month(bn.FundingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(bn.FundingDate)) as Date) > CAST(bn.FundingDate As Date) Then
			DateAdd(Month,1, CAST(Concat(Month(bn.FundingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(bn.FundingDate)) as Date))
		ELSE
			DateAdd(Month,2, CAST(Concat(Month(bn.FundingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(bn.FundingDate)) as Date))
		END As FirstPaymentDate,
		3 as EnableM61Calculations
		From [IO].[L_BackShopNote] bn
		left join core.lookup l on l.[name] = bn.LienPosition and ParentID = 56
		where controlid = @CREDealID and NoteId = @CRENoteID_New

		SELECT @insertednoteID = tNewNoteId FROM @tNote;



	FETCH NEXT FROM Import_cursor into   @CRENoteID_New
	END
	CLOSE Import_cursor;  
	DEALLOCATE Import_cursor;  




	---INsert dealfunding + NoteFunding + funding rules grid
	DECLARE @noteFundingRepayment [TableTypeFundingRepaymentSequence]

	INSERT INTO @noteFundingRepayment(NoteID,SequenceNo,SequenceType,[Value])
	Select NoteID,SequenceNo,SequenceType,[Value]
	From(
		Select n.NoteID as [NoteID]
		,1 as [SequenceNo]
		,258 as [SequenceType]
		,SUM(FundingAmount) as [Value]
		from [IO].[L_BackShopNoteFunding] nff
		Inner join cre.note n on n.crenoteid = nff.NoteID_f
		inner join cre.deal d on d.credealid = nff.ControlID
		Where ControlID = @CREDealID
		and FundingAmount >= 0
		Group by n.NoteID

		UNION ALL

		Select n.NoteID as [NoteID]
		,1 as [SequenceNo]
		,259 as [SequenceType]
		,SUM(FundingAmount) as [Value]
		from [IO].[L_BackShopNoteFunding] nff
		Inner join cre.note n on n.crenoteid = nff.NoteID_f
		inner join cre.deal d on d.credealid = nff.ControlID
		Where ControlID = @CREDealID
		and FundingAmount < 0
		Group by n.NoteID
	)a

	exec [dbo].[usp_InsertUpdateFundingRepaymentSequence]  @noteFundingRepayment,@CreatedBy,@CreatedBy
	---------------------------

	---Delete funding
	Create Table #TempNotes_DeleteFF(AccountID uniqueidentifier,NoteID uniqueidentifier )

	insert into #TempNotes_DeleteFF 
	SELECT Account_AccountID,NoteID 
	FROM CRE.Note n 
	Inner JOIN CORE.ACCOUNT AC ON n.Account_AccountID = AC.AccountID 
	WHERE n.DealID = @NewDealID

	Delete from [CRE].DealFunding WHERE DealID = @NewDealID

	IF EXISTS(Select AccountID from #TempNotes_DeleteFF)
	BEGIN
		delete from core.FundingSchedule where eventId in (Select eventID from core.event where EventTypeID = 10  and accountid in (Select AccountID from #TempNotes_DeleteFF) )
		delete from core.event where EventTypeID = 10 and accountid in (Select AccountID from #TempNotes_DeleteFF)

		delete from core.Maturity where eventId in (Select eventID from core.event where EventTypeID = 11  and accountid in (Select AccountID from #TempNotes_DeleteFF) )
		delete from core.event where EventTypeID = 11 and accountid in (Select AccountID from #TempNotes_DeleteFF)
	END


	Declare @XMLDealFunding XML;

	SET @XMLDealFunding = (
	Select '00000000-0000-0000-0000-000000000000' as DealFundingID,
	d.DealID
	,nff.FundingDate as Date
	,nff.FundingAmount Value
	,nff.Comments as Comment
	,lpurpose.lookupid as PurposeID
	,nff.WireConfirm as Applied
	,null as NonCommitmentAdj
	,null as DrawFundingId
	,ROW_NUMBER() Over(Partition By ControlID Order by ControlID,nff.FundingDate) as DealFundingRowno
	,0 as EquityAmount
	,@createdBy as CreatedBy
	,0 as RequiredEquity
	,0 as AdditionalEquity
	,746 as GeneratedBy
	,@createdBy as GeneratedByUserID
	,lFundingAdjustmentType.LookupID as AdjustmentType
	,nff.WireConfirm as Issaved
	from (
		Select ControlID,FundingDate,SUM(FundingAmount) as FundingAmount ,Comments,Applied,WireConfirm,FundingAdjustmentTypeCd_F
		,(CASE FundingPurposeCD_F
		WHEN 'PROPREL' THEN 'Property Release'  
		WHEN 'PAYOFF' THEN 'Payoff/Paydown'
		WHEN 'ADDCOLLPUR' THEN 'Additional Collateral Purchase'
		WHEN 'CAPEXPEN' THEN 'Capital Expenditure'
		WHEN 'DSOPEX' THEN 'Debt Service / Opex' 
		WHEN 'TILCDRAW' THEN 'TI/LC'
		WHEN 'OTHER' THEN 'Other'
		WHEN 'AMORT' THEN 'Amortization'
		WHEN 'OPEX' THEN 'OpEx'
		WHEN 'FORCEFUND' THEN 'Force Funding'
		WHEN 'CAPINTC' THEN 'Capitalized Interest'
		WHEN 'FULLPAY' THEN 'Full Payoff'
		WHEN 'NOTETRAN' THEN 'Note Transfer'
		WHEN 'PAYDOWN' THEN 'Paydown'
		WHEN 'PWRITEOFF' THEN 'Principal Writeoff'
		WHEN 'EQUITYDIST' THEN 	'Equity Distribution'
		END
		) as FundingPurposeCD_F
		from [IO].[L_BackShopNoteFunding]
		group by ControlID,FundingDate,Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingAdjustmentTypeCd_F
	)nff
	inner join cre.deal d on d.credealid = nff.ControlID
	Left join core.lookup lpurpose on lpurpose.name = nff.FundingPurposeCD_F and lpurpose.parentid = 50
	Left join core.lookup lFundingAdjustmentType on lFundingAdjustmentType.[Value] = nff.FundingAdjustmentTypeCd_F and lFundingAdjustmentType.parentid = 141
	where controlid = @CREDealID

	FOR XML PATH('PayruleDealFundingDataContract'), ROOT('ArrayOfPayruleDealFundingDataContract')
	)

	exec [CRE].[usp_SaveDealFunding] @XMLDealFunding

	---=========================

	DECLARE @noteFundingSchedule [TableTypeFundingSchedule]

	INSERT INTO @noteFundingSchedule(NoteID
	,Value
	,Date
	,PurposeID
	,AccountId
	,Applied
	,AdjustmentType
	,DrawFundingId
	,Comments
	,DealFundingRowno
	,isDeleted
	,WF_CurrentStatus
	,GeneratedBy
	)
	Select 
	n.noteid as [NoteID]          
	,nff.FundingAmount as [Value]           
	,nff.FundingDate as [Date]            
	,lpurpose.lookupid as [PurposeID]       
	,n.Account_AccountID as [AccountId]       
	,nff.WireConfirm as [Applied]         
	,lFundingAdjustmentType.LookupID as [AdjustmentType]   
	,null as [DrawFundingId]   
	,nff.Comments as [Comments]        
	,ROW_NUMBER() Over(Partition By ControlID,n.noteid Order by ControlID,n.noteid,nff.FundingDate) as [DealFundingRowno]
	,0 as [isDeleted]       
	,null as [WF_CurrentStatus]
	,746 as [GeneratedBy]  
	from (
		Select ControlID,NoteID_f,FundingDate,FundingAmount,Comments,Applied,WireConfirm,FundingAdjustmentTypeCd_F
		,(CASE FundingPurposeCD_F
		WHEN 'PROPREL' THEN 'Property Release'  
		WHEN 'PAYOFF' THEN 'Payoff/Paydown'
		WHEN 'ADDCOLLPUR' THEN 'Additional Collateral Purchase'
		WHEN 'CAPEXPEN' THEN 'Capital Expenditure'
		WHEN 'DSOPEX' THEN 'Debt Service / Opex' 
		WHEN 'TILCDRAW' THEN 'TI/LC'
		WHEN 'OTHER' THEN 'Other'
		WHEN 'AMORT' THEN 'Amortization'
		WHEN 'OPEX' THEN 'OpEx'
		WHEN 'FORCEFUND' THEN 'Force Funding'
		WHEN 'CAPINTC' THEN 'Capitalized Interest'
		WHEN 'FULLPAY' THEN 'Full Payoff'
		WHEN 'NOTETRAN' THEN 'Note Transfer'
		WHEN 'PAYDOWN' THEN 'Paydown'
		WHEN 'PWRITEOFF' THEN 'Principal Writeoff'
		WHEN 'EQUITYDIST' THEN 	'Equity Distribution'
		END
		) as FundingPurposeCD_F
		from [IO].[L_BackShopNoteFunding]
		Where ControlID = @CREDealID
	
	)nff
	Inner join cre.note n on n.crenoteid = nff.NoteID_f
	inner join cre.deal d on d.credealid = nff.ControlID
	Left join core.lookup lpurpose on lpurpose.name = nff.FundingPurposeCD_F and lpurpose.parentid = 50
	Left join core.lookup lFundingAdjustmentType on lFundingAdjustmentType.[Value] = nff.FundingAdjustmentTypeCd_F and lFundingAdjustmentType.parentid = 141
	where controlid = @CREDealID
	
	exec [dbo].[usp_InsertUpdateFundingSchedule] @noteFundingSchedule,@CreatedBy,@CreatedBy,0


	---save maturity
	
	Declare @TableTypeMaturityDataForNote [TableTypeMaturityDataForNote]
	INSERT INTO @TableTypeMaturityDataForNote(
	NoteID
	,EffectiveDate
	,MaturityDate
	,MaturityType
	,Approved
	,IsDeleted
	,ActualPayoffDate 
	,ExpectedMaturityDate 
	,OpenPrepaymentDate
	,ExtensionType 
	)
	Select
	 n.noteid as NoteID
	,bn.FundingDate as EffectiveDate
	,bn.StatedMaturityDate as MaturityDate
	,708 as MaturityType
	,3 as Approved
	,0 as IsDeleted
	,null as ActualPayoffDate 
	,null as ExpectedMaturityDate 
	,null as OpenPrepaymentDate
	,null as ExtensionType 
	From [IO].[L_BackShopNote] bn
	Inner join cre.note n on n.crenoteid = bn.NoteId
	where controlid = @CREDealID
	and bn.StatedMaturityDate is not null

	EXEC [dbo].[usp_InsertUpdateMaturitySchedule] @TableTypeMaturityDataForNote,@CreatedBy



	--Import propety from backshop
	exec [dbo].[usp_ImportPropertyFromBackshopByDealID] @credealid
	exec [dbo].[usp_UpdateNoteMatrixFieldsByDealID] @credealid
	
END
Else
Begin
	
	Declare @dealid UNIQUEIDENTIFIER;
	SET @dealid = (Select dealid from cre.deal where CREDealID = @CREDealID and IsDeleted <> 1)


	--Update deal
	Update cre.deal set cre.deal.DealName = z.dealname,
	cre.deal.LoanStatusID = z.LoanStatusID
	From(
		Select d.AccountID,bd.dealname,ls.LoanStatusID from [IO].[L_BackShopDeal] bd
		Inner join cre.deal d on d.CREDealID = bd.ControlId
		left join cre.LoanStatus ls on ls.LoanStatusCd = bd.LoanStatusCd_F
		where ControlId = @CREDealID
	)z
	where cre.deal.AccountID = z.AccountID
	and cre.deal.CREDealID = @CREDealID


	
	---update note data
	Update CORE.Account SET CORE.Account.Name = z.NoteName,
	CORE.Account.PayFrequency = z.PaymentFreqCd_F
	From(
		Select n.noteid,n.Account_AccountID,bn.NoteName,PaymentFreqCd_F
		from [IO].[L_BackShopNote] bn
		Inner join cre.note n on n.crenoteid = bn.noteid
		Inner join cre.deal d on d.credealid = bn.controlid
		where bn.controlid = @CREDealID
	)z
	where CORE.Account.AccountID = z.Account_AccountID



	Update cre.note SET cre.note.ClosingDate = z.FundingDate,
	cre.note.TotalCommitment = z.TotalCommitment,	
	cre.note.lienposition = z.LienPosition,
	cre.note.[Priority] = z.[Priority],
	cre.note.OriginalTotalCommitment = z.TotalCommitment,
	cre.note.FundingPriority = 1,
	cre.note.RepaymentPriority = 1,

	cre.note.DeterminationDateLeadDays=-2,
	cre.note.PaymentDateBusinessDayLag=-1,
	cre.note.DeterminationDateInterestAccrualPeriod=0,
	cre.note.MonthlyDSOverridewhenAmortizing=0,
	cre.note.AccrualFrequency=1,
	cre.note.RateIndexResetFreq=1,
	cre.note.FutureFundingBillingCutoffDay=1,
	cre.note.CurtailmentBillingCutoffDay=1,
	cre.note.StubPaidinAdvanceYN=3,
	cre.note.IncludeServicingPaymentOverrideinLevelYield=3,
	cre.note.BillingNotesID=3,
	cre.note.StubPaidInArrears=4,
	cre.note.SettleWithAccrualFlag=4,
	cre.note.LoanPurchase=4,
	cre.note.StubInterestPaidonFutureAdvances=4,
	cre.note.DeterminationDateReferenceDayoftheMonth=10,
	cre.note.LoanType=24,
	cre.note.RateType=140,
	cre.note.IndexNameID=777,
	cre.note.RoundingMethod=251,
	cre.note.AmortTerm=360,
	cre.note.AmortIntCalcDayCount=360,
	cre.note.DebtTypeID=442,
	cre.note.CapStack=500,
	cre.note.InterestCalculationRuleForPaydowns=594,
	cre.note.InterestCalculationRuleForPaydownsAmort=594,
	cre.note.IndexRoundingRule=1000,
	cre.note.IOTerm = z.LoanTerm,
	cre.note.OriginationFeePercentageRP = z.OriginationFeePct,
	cre.note.FirstPaymentDate = DateAdd(Day,1, DateAdd(month,1,z.InitialInterestAccrualEndDate)),
	cre.note.InitialInterestAccrualEndDate = z.InitialInterestAccrualEndDate,
	cre.note.EnableM61Calculations = 3
	
	From(
		Select n.noteid,n.Account_AccountID,bn.NoteName,bn.fundingdate,bn.TotalCommitment,PaymentFreqCd_F,l.lookupid as LienPosition,bn.[Priority]
		,bn.LoanTerm, bn.OriginationFeePct, bn.FirstPIPaymentDate,
		case when CAST(Concat(Month(n.ClosingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(n.ClosingDate)) as Date) > CAST(n.ClosingDate As Date) Then
			DateAdd(Day,-1, CAST(Concat(Month(n.ClosingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(n.ClosingDate)) as Date))
		ELSE
			DateAdd(Month,1, DateAdd(Day,-1, CAST(Concat(Month(n.ClosingDate),'/',Day(bn.FirstPIPaymentDate),'/',Year(n.ClosingDate)) as Date)))
		END As InitialInterestAccrualEndDate,
		3 as EnableM61Calculations
		from [IO].[L_BackShopNote] bn
		Inner join cre.note n on n.crenoteid = bn.noteid
		Inner join cre.deal d on d.credealid = bn.controlid
		left join core.lookup l on l.[name] = bn.LienPosition and ParentID = 56
		where bn.controlid = @CREDealID
	)z
	where cre.note.NoteID = z.NoteID
	---------------------------------------------




	---Insert dealfunding + NoteFunding + funding rules grid
	DECLARE @noteFundingRepayment1 [TableTypeFundingRepaymentSequence]

	INSERT INTO @noteFundingRepayment1(NoteID,SequenceNo,SequenceType,[Value])
	Select NoteID,SequenceNo,SequenceType,[Value]
	From(
		Select n.NoteID as [NoteID]
		,1 as [SequenceNo]
		,258 as [SequenceType]
		,SUM(FundingAmount) as [Value]
		from [IO].[L_BackShopNoteFunding] nff
		Inner join cre.note n on n.crenoteid = nff.NoteID_f
		inner join cre.deal d on d.credealid = nff.ControlID
		Where ControlID = @CREDealID
		and FundingAmount >= 0
		Group by n.NoteID

		UNION ALL

		Select n.NoteID as [NoteID]
		,1 as [SequenceNo]
		,259 as [SequenceType]
		,SUM(FundingAmount) as [Value]
		from [IO].[L_BackShopNoteFunding] nff
		Inner join cre.note n on n.crenoteid = nff.NoteID_f
		inner join cre.deal d on d.credealid = nff.ControlID
		Where ControlID = @CREDealID
		and FundingAmount < 0
		Group by n.NoteID
	)a

	exec [dbo].[usp_InsertUpdateFundingRepaymentSequence]  @noteFundingRepayment1,@CreatedBy,@CreatedBy


	---Delete funding
	Create Table #TempNotes_DeleteFF_1(AccountID uniqueidentifier,NoteID uniqueidentifier )

	insert into #TempNotes_DeleteFF_1 
	SELECT Account_AccountID,NoteID 
	FROM CRE.Note n 
	Inner JOIN CORE.ACCOUNT AC ON n.Account_AccountID = AC.AccountID 
	WHERE n.DealID = @dealid

	Delete from [CRE].DealFunding WHERE DealID = @dealid

	IF EXISTS(Select AccountID from #TempNotes_DeleteFF_1)
	BEGIN
		delete from core.FundingSchedule where eventId in (Select eventID from core.event where EventTypeID = 10  and accountid in (Select AccountID from #TempNotes_DeleteFF_1) )
		delete from core.event where EventTypeID = 10 and accountid in (Select AccountID from #TempNotes_DeleteFF_1)

		delete from core.Maturity where eventId in (Select eventID from core.event where EventTypeID = 11  and accountid in (Select AccountID from #TempNotes_DeleteFF_1) )
		delete from core.event where EventTypeID = 11 and accountid in (Select AccountID from #TempNotes_DeleteFF_1)
	END


	Declare @XMLDealFunding_1 XML;

	SET @XMLDealFunding_1 = (
	Select '00000000-0000-0000-0000-000000000000' as DealFundingID,
	d.DealID
	,nff.FundingDate as Date
	,nff.FundingAmount Value
	,nff.Comments as Comment
	,lpurpose.lookupid as PurposeID
	,nff.WireConfirm as Applied
	,null as NonCommitmentAdj
	,null as DrawFundingId
	,ROW_NUMBER() Over(Partition By ControlID Order by ControlID,nff.FundingDate) as DealFundingRowno
	,0 as EquityAmount
	,@createdBy as CreatedBy
	,0 as RequiredEquity
	,0 as AdditionalEquity
	,746 as GeneratedBy
	,@createdBy as GeneratedByUserID
	,lFundingAdjustmentType.LookupID as AdjustmentType
	,nff.WireConfirm as Issaved
	from (
		Select ControlID,FundingDate,SUM(FundingAmount) as FundingAmount ,Comments,Applied,WireConfirm,FundingAdjustmentTypeCd_F
		,(CASE FundingPurposeCD_F
		WHEN 'PROPREL' THEN 'Property Release'  
		WHEN 'PAYOFF' THEN 'Payoff/Paydown'
		WHEN 'ADDCOLLPUR' THEN 'Additional Collateral Purchase'
		WHEN 'CAPEXPEN' THEN 'Capital Expenditure'
		WHEN 'DSOPEX' THEN 'Debt Service / Opex' 
		WHEN 'TILCDRAW' THEN 'TI/LC'
		WHEN 'OTHER' THEN 'Other'
		WHEN 'AMORT' THEN 'Amortization'
		WHEN 'OPEX' THEN 'OpEx'
		WHEN 'FORCEFUND' THEN 'Force Funding'
		WHEN 'CAPINTC' THEN 'Capitalized Interest'
		WHEN 'FULLPAY' THEN 'Full Payoff'
		WHEN 'NOTETRAN' THEN 'Note Transfer'
		WHEN 'PAYDOWN' THEN 'Paydown'
		WHEN 'PWRITEOFF' THEN 'Principal Writeoff'
		WHEN 'EQUITYDIST' THEN 	'Equity Distribution'
		END
		) as FundingPurposeCD_F
		from [IO].[L_BackShopNoteFunding]
		group by ControlID,FundingDate,Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingAdjustmentTypeCd_F
	)nff
	inner join cre.deal d on d.credealid = nff.ControlID
	Left join core.lookup lpurpose on lpurpose.name = nff.FundingPurposeCD_F and lpurpose.parentid = 50
	Left join core.lookup lFundingAdjustmentType on lFundingAdjustmentType.[Value] = nff.FundingAdjustmentTypeCd_F and lFundingAdjustmentType.parentid = 141
	where controlid = @CREDealID

	FOR XML PATH('PayruleDealFundingDataContract'), ROOT('ArrayOfPayruleDealFundingDataContract')
	)

	exec [CRE].[usp_SaveDealFunding] @XMLDealFunding_1

	----=====================


	DECLARE @noteFundingSchedule_1 [TableTypeFundingSchedule]

	INSERT INTO @noteFundingSchedule_1(NoteID
	,Value
	,Date
	,PurposeID
	,AccountId
	,Applied
	,AdjustmentType
	,DrawFundingId
	,Comments
	,DealFundingRowno
	,isDeleted
	,WF_CurrentStatus
	,GeneratedBy
	)
	Select 
	n.noteid as [NoteID]          
	,nff.FundingAmount as [Value]           
	,nff.FundingDate as [Date]            
	,lpurpose.lookupid as [PurposeID]       
	,n.Account_AccountID as [AccountId]       
	,nff.WireConfirm as [Applied]         
	,lFundingAdjustmentType.LookupID as [AdjustmentType]   
	,null as [DrawFundingId]   
	,nff.Comments as [Comments]        
	,ROW_NUMBER() Over(Partition By ControlID,n.noteid Order by ControlID,n.noteid,nff.FundingDate) as [DealFundingRowno]
	,0 as [isDeleted]       
	,null as [WF_CurrentStatus]
	,746 as [GeneratedBy]  
	from (
		Select ControlID,NoteID_f,FundingDate,FundingAmount,Comments,Applied,WireConfirm,FundingAdjustmentTypeCd_F
		,(CASE FundingPurposeCD_F
		WHEN 'PROPREL' THEN 'Property Release'  
		WHEN 'PAYOFF' THEN 'Payoff/Paydown'
		WHEN 'ADDCOLLPUR' THEN 'Additional Collateral Purchase'
		WHEN 'CAPEXPEN' THEN 'Capital Expenditure'
		WHEN 'DSOPEX' THEN 'Debt Service / Opex' 
		WHEN 'TILCDRAW' THEN 'TI/LC'
		WHEN 'OTHER' THEN 'Other'
		WHEN 'AMORT' THEN 'Amortization'
		WHEN 'OPEX' THEN 'OpEx'
		WHEN 'FORCEFUND' THEN 'Force Funding'
		WHEN 'CAPINTC' THEN 'Capitalized Interest'
		WHEN 'FULLPAY' THEN 'Full Payoff'
		WHEN 'NOTETRAN' THEN 'Note Transfer'
		WHEN 'PAYDOWN' THEN 'Paydown'
		WHEN 'PWRITEOFF' THEN 'Principal Writeoff'
		WHEN 'EQUITYDIST' THEN 	'Equity Distribution'
		END
		) as FundingPurposeCD_F
		from [IO].[L_BackShopNoteFunding]
		Where ControlID = @CREDealID
	
	)nff
	Inner join cre.note n on n.crenoteid = nff.NoteID_f
	inner join cre.deal d on d.credealid = nff.ControlID
	Left join core.lookup lpurpose on lpurpose.name = nff.FundingPurposeCD_F and lpurpose.parentid = 50
	Left join core.lookup lFundingAdjustmentType on lFundingAdjustmentType.[Value] = nff.FundingAdjustmentTypeCd_F and lFundingAdjustmentType.parentid = 141
	where controlid = @CREDealID
	
	exec [dbo].[usp_InsertUpdateFundingSchedule] @noteFundingSchedule_1,@CreatedBy,@CreatedBy,0




	---save maturity	
	Declare @TableTypeMaturityDataForNote_1 [TableTypeMaturityDataForNote]
	INSERT INTO @TableTypeMaturityDataForNote_1(
	NoteID
	,EffectiveDate
	,MaturityDate
	,MaturityType
	,Approved
	,IsDeleted
	,ActualPayoffDate 
	,ExpectedMaturityDate 
	,OpenPrepaymentDate
	,ExtensionType 
	)
	Select
	 n.noteid as NoteID
	,bn.FundingDate as EffectiveDate
	,bn.StatedMaturityDate as MaturityDate
	,708 as MaturityType
	,3 as Approved
	,0 as IsDeleted
	,null as ActualPayoffDate 
	,null as ExpectedMaturityDate 
	,null as OpenPrepaymentDate
	,null as ExtensionType 
	From [IO].[L_BackShopNote] bn
	Inner join cre.note n on n.crenoteid = bn.NoteId
	where controlid = @CREDealID
	and bn.StatedMaturityDate is not null

	EXEC [dbo].[usp_InsertUpdateMaturitySchedule] @TableTypeMaturityDataForNote_1,@CreatedBy

	--Import propety from backshop
	exec [dbo].[usp_ImportPropertyFromBackshopByDealID] @credealid
	exec [dbo].[usp_UpdateNoteMatrixFieldsByDealID] @credealid
END
	
	
----Add into searchitem table
Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');
PRINT('Start - Add into search item table')
DECLARE @DealIDt nvarchar(256) = @NewDealID
exec [App].[usp_AddUpdateObject] @DealIDt,@LookupIdForDeal,null,null

-----Save Note----------------------------
Declare @ObjectIDNote UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorNote')>=-1
BEGIN
	DEALLOCATE CursorNote
END

DECLARE CursorNote CURSOR 
for
(
	Select NoteID from cre.Note where dealid = @DealIDt
)
OPEN CursorNote 
FETCH NEXT FROM CursorNote
INTO @ObjectIDNote

WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC [App].[usp_AddUpdateObject] @ObjectIDNote,@LookupIdForNote ,'Kbaderia','Kbaderia'
					 
FETCH NEXT FROM CursorNote
INTO @ObjectIDNote
END
CLOSE CursorNote   
DEALLOCATE CursorNote
PRINT('END - Add into search item table')


END
GO

