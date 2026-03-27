-- Procedure
  
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntry]  
  
@TableTypeTransactionEntry [TableTypeTransactionEntry] READONLY,  
@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256) ,
@MaturityUsedInCalc Date
  
AS  
BEGIN  
    SET NOCOUNT ON;


Declare @StrCreatedBy nvarchar(256);
IF(@CreatedBy like REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
BEGIN
	SET @StrCreatedBy = (Select top 1 [Login] from app.[user] where userid = @CreatedBy)
END
ELSE
BEGIN
	SET @StrCreatedBy =  @CreatedBy
END



DECLARE @AccountID UNIQUEIDENTIFIER;  
SET @AccountID = (Select Account_AccountID from CRE.note n inner join Core.Account ac on n.Account_AccountID=ac.AccountID  where noteid = @NoteId and ac.IsDeleted=0)  

DECLARE @AnalysisID UNIQUEIDENTIFIER; 
SET @AnalysisID = (Select Top 1 AnalysisID from @TableTypeTransactionEntry)

DECLARE @UseActuals int; 
SET @UseActuals = (Select UseActuals from core.AnalysisParameter where AnalysisID = @AnalysisID)

--===============================
--Declare @feeName nvarchar(256);
--Declare @Comment nvarchar(256);

--Select top 1 @feeName = NULLIF(FeeName,''),@Comment = NULLIF(Comment,'') FROM @TableTypeTransactionEntry  where FeeName is not null  and TransactionType like 'PIK%'
--========================================


--================================
IF OBJECT_ID('tempdb..[#TableTypeTransactionEntry_g]') IS NOT NULL                                         
	 DROP TABLE [#TableTypeTransactionEntry_g]

CREATE TABLE [#TableTypeTransactionEntry_g](
	NoteID UNIQUEIDENTIFIER null,
	[Date]            DATE             NULL,
	[Amount]          DECIMAL (28, 15) NULL,
	[TransactionType] NVARCHAR (256)   NULL,
	CreatedBy NVARCHAR (256)   NULL,
	CreatedDate date   NULL,
	UpdatedBy NVARCHAR (256)   NULL,
	UpdatedDate date   NULL,		
	[AnalysisID]      UNIQUEIDENTIFIER NULL,
	[FeeName]         NVARCHAR (256)   NULL,
	StrCreatedBy	NVARCHAR (256)   NULL,
	GeneratedBy		NVARCHAR (256)   NULL,
	[FeeTypeName]     NVARCHAR (256)   NULL,
	[Comment]         NVARCHAR (MAX)   NULL,
	[PaymentDateNotAdjustedforWorkingDay] DATETIME         NULL,
	PurposeType NVARCHAR (256)   NULL,    
	TransactionDateByRule   DATE             NULL,	
	TransactionDateServicingLog DATE             NULL,
	RemittanceDate  DATE             NULL,
	AdjustmentType NVARCHAR (256)   NULL,
	AllInCouponRate decimal(28,15),
	IndexDeterminationDate DATE NULL,
	AccountID UNIQUEIDENTIFIER,
	BalloonRepayAmount decimal(28,15),
	IndexValue  decimal(28,15),
	SpreadValue  decimal(28,15),
	OriginalIndex  decimal(28,15),
	LiborPercentage decimal(28,15)
)
INSERT INTO [#TableTypeTransactionEntry_g]
(
	NoteID,
	[Date],
	[Amount],
	[TransactionType],
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,		
	[AnalysisID],
	[FeeName],
	StrCreatedBy,
	GeneratedBy,
	[FeeTypeName],
	[Comment],
	[PaymentDateNotAdjustedforWorkingDay],
	PurposeType,    
	TransactionDateByRule,	
	TransactionDateServicingLog,
	RemittanceDate,
	AdjustmentType,
	AllInCouponRate,
	IndexDeterminationDate,
	AccountID,
	BalloonRepayAmount,
	IndexValue ,
	SpreadValue ,
	OriginalIndex,
	LiborPercentage
)
Select  
@NoteId  
,[Date]  
,Amount  
,TransactionType  
,@CreatedBy  
,GETDATE()  
,@CreatedBy  
,GETDATE() 
,AnalysisID 
,nullIF(FeeName,'')
,@StrCreatedBy
,'Calculator' as GeneratedBy
,FeeTypeName
,NULLIF(Comment,'')
,PaymentDateNotAdjustedforWorkingDay
,PurposeType
,TransactionDateByRule
,TransactionDateServicingLog
,RemittanceDate
,AdjustmentType
,AllInCouponRate
,IndexDeterminationDate
,@AccountID
,BalloonRepayAmount
,IndexValue 
,SpreadValue 
,OriginalIndex 
,LiborPercentage
FROM @TableTypeTransactionEntry  
Where [Date] is not null

--=================================


IF (@AnalysisID is not null)
BEGIN
  
	Declare @ID uniqueidentifier;  
  
	DELETE FROM [CRE].[TransactionEntry] WHERE AccountID=@AccountID  and AnalysisID = @AnalysisID
  
	INSERT INTO [CRE].[TransactionEntry]  
	(  
		--NoteID  
		AccountID
		,[Date]  
		,Amount  
		,[Type]  
		,CreatedBy  
		,CreatedDate  
		,UpdatedBy  
		,UpdatedDate
		,AnalysisID  
		,FeeName
		,StrCreatedBy
		,GeneratedBy
		,FeeTypeName
		,Comment
		,PaymentDateNotAdjustedforWorkingDay
		,PurposeType
		,TransactionDateByRule
		,TransactionDateServicingLog
		,RemitDate
		,AdjustmentType
		,AllInCouponRate
		,IndexDeterminationDate
		--,Cash_NonCash
		,BalloonRepayAmount
		,IndexValue 
	,SpreadValue 
	,OriginalIndex 
	,LiborPercentage

	)  
	Select  
	---te.NoteID,
	te.AccountID,
	te.[Date],
	te.[Amount],
	te.[TransactionType],
	te.CreatedBy,
	te.CreatedDate,
	te.UpdatedBy,
	te.UpdatedDate,
	te.[AnalysisID],
	te.[FeeName],
	te.StrCreatedBy,
	te.GeneratedBy,
	te.[FeeTypeName],
	te.[Comment],
	te.[PaymentDateNotAdjustedforWorkingDay],
	te.PurposeType,    
	te.TransactionDateByRule,
	te.TransactionDateServicingLog,
	te.RemittanceDate,
	te.AdjustmentType,
	te.AllInCouponRate,
	te.IndexDeterminationDate,
	te.BalloonRepayAmount,
	te.IndexValue ,
	te.SpreadValue ,
	te.OriginalIndex,
	te.LiborPercentage
	--(CASE WHEN n.EnableM61Calculations = 3 THEN 
	--	(CASE WHEN te.[TransactionType] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
	--	WHEN te.[TransactionType] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer') and te.Amount < 0 THEN 'Funding'
	--	WHEN te.[TransactionType] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer') and te.Amount > 0 THEN 'Repayment'
	--	ELSE tym.Cash_NonCash END
	--	)
	--ELSE
	--	(CASE WHEN (te.[TransactionType] = 'FundingOrRepayment' and te.Cash_NonCash is not null) THEN te.Cash_NonCash
	--	WHEN (te.[TransactionType] = 'FundingOrRepayment' and te.Cash_NonCash is null and te.Amount < 0) THEN 'Funding'
	--	WHEN (te.[TransactionType] = 'FundingOrRepayment' and te.Cash_NonCash is null and te.Amount > 0) THEN 'Repayment'
	--	ELSE tym.Cash_NonCash END
	--	)
	--END
	--) as Cash_NonCash


	FROM [#TableTypeTransactionEntry_g]  te
	--inner join Cre.Note n on n.NoteID=te.NoteID	
	--left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.TransactionType)
  
 
	 --Insert or update transaction from servicing log
	IF(@UseActuals = 3) --'Y'
	BEGIN
		IF EXISTS(Select top 1 noteid from cre.noteTransactionDetail where noteid = @NoteId)
		BEGIN
			EXEC [dbo].[usp_InsertTransactionEntryOfServicingLogData]  @NoteId,@AnalysisID,@CreatedBy,@MaturityUsedInCalc
		END
	END

	IF(@UseActuals = 4) --'N'
	BEGIN
		IF EXISTS(Select top 1 noteid from cre.noteTransactionDetail where noteid = @NoteId)
		BEGIN
			EXEC [dbo].[usp_InsertTransactionEntryOfServicingLogDataUseActualsN]  @NoteId,@AnalysisID,@CreatedBy,@MaturityUsedInCalc
		END
	END

	----===========================handeled from calculator code===========================================
	--Declare @TranType nvarchar(256);
	--Select top 1 @TranType = TransactionType FROM [#TableTypeTransactionEntry_g]  where TransactionType like 'PIK%'

	--IF(@TranType like 'PIK%')
	--BEGIN
	--	IF(@feeName is null)
	--	BEGIN
	--		--Temp solution (11736,9242,9653)
	--		Select @feeName = LPIKReasonCode.name,@Comment = pik.PIKComments
	--		from [CORE].PikSchedule pik
	--		left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID
	--		left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID
	--		INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId
	--		LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID
	--		INNER JOIN (						
	--			Select 
	--			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	--			where EventTypeID = 12
	--			and n.NoteID = @NoteId
	--			and acc.IsDeleted = 0
	--			GROUP BY n.Account_AccountID,EventTypeID
	--		) sEvent
	--		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	--	END
	--END

	--Update [CRE].[TransactionEntry]   set FeeName = @feeName,Comment =@Comment where AccountID = @AccountID and AnalysisID = @AnalysisID and [type] like 'PIK%'
	
	----=======================================================================

	-------handeled in usp_UpdateTransactionEntry_ReferenceRateNote
	------Update for Reference Rate
	--IF OBJECT_ID('tempdb..[#tblSpreadRefRate]') IS NOT NULL                                         
	-- DROP TABLE [#tblSpreadRefRate]

	--CREATE TABLE [#tblSpreadRefRate](
	--	NoteID UNIQUEIDENTIFIER null,
	--	[date] Date null,
	--	ValueTypeID int null,
	--	Value decimal(28,15) null,
	--	TrType nvarchar(256) null,
	--	cnt int null
	--)
	--INSERT INTO [#tblSpreadRefRate](NoteID,[date],ValueTypeID,Value,TrType,cnt)
	--Select b.NoteID,b.date,b.ValueTypeID,b.Value,b.TrType,b.cnt 
	--from(
	--	Select n1.NoteID, rs.date,rs.ValueTypeID,rs.Value,
	--	(CASE when LValueTypeID.name ='Reference Rate' THen 'LIBORPercentage'
	--	when LValueTypeID.name ='Spread' THen 'SpreadPercentage' END)as TrType,
	--	count(rs.date) over (partition by n1.noteid,rs.date order by n1.noteid,rs.date) as cnt
	--	from [CORE].RateSpreadSchedule rs
	--	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
	--	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
	--	INNER JOIN(					
	--					Select 
	--						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	--						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
	--						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
	--						and n.NoteID = @NoteId
	--						and acc.IsDeleted = 0
	--						GROUP BY n.Account_AccountID,EventTypeID
	--				) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	--	inner join core.Account ac on ac.AccountID =e.AccountID
	--	inner join cre.Note n1 on n1.Account_AccountID = ac.AccountID
	--	where e.StatusID = 1
	--	and n1.RateType = 139
	--	and rs.ValueTypeID in (151,596)		
	--)b
	--where b.cnt = 2
	--order by b.date

	--IF EXISTS(SELECT NoteID FROM [#tblSpreadRefRate])
	--BEGIN
	--Declare @Liborpercentage decimal(28,15) = (select top 1 Value from [#tblSpreadRefRate] where TrType = 'LIBORPercentage'  order by date asc);
	--Declare @Spreadpercentage decimal(28,15) = (select top 1 Value from [#tblSpreadRefRate]  where TrType = 'SpreadPercentage'  order by date asc);

	--UPDATE CRe.TransactionEntry SET cre.TransactionEntry.Amount = z.Value
	--FROM(
	--		select tr.TransactionEntryID,n.NoteID,x.date,
	--		ISNULL(x.Value,(CASE WHEN Type = 'SpreadPercentage' THEN @Spreadpercentage	ELSE @Liborpercentage END)) as Value
	--		,tr.Type 
	--		from cre.TransactionEntry tr
	--		Inner Join cre.note n on n.account_accountid = tr.AccountID
	--		outer apply(
	--					select top 1 sp.Date,sp.Value from [#tblSpreadRefRate] sp where sp.TrType=tr.Type and sp.NoteID = n.NoteID and sp.Date < tr.Date 
	--					order by date desc
	--				) as x
	--		where 
	--		analysisid = @AnalysisID
	--		and tr.AccountID=@AccountID
	--		and tr.Type in ('SpreadPercentage','LIBORPercentage')


	--	)z
	--WHERE z.TransactionEntryID= CRe.TransactionEntry.TransactionEntryID


	--END
	

	
	

	DELETE FROM [CRE].[TransactionEntry] WHERE AccountID=@AccountID  and AnalysisID = @AnalysisID and Amount = 0 
	--=======================================================================

	---Update cash non cash column
	exec [CRE].[usp_UpdateTransactionEntryCash_NonCash] @NoteId,@AnalysisID


	----Export PIK Principal Funding to backshop
	IF(@AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F') --Export only for default scenario
	BEGIN
		--IF EXISTS(Select Amount FROM [#TableTypeTransactionEntry_g] tr where tr.TransactionType = 'PIKPrincipalFunding' and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.Amount <> 0)
		--BEGIN
			Declare @L_Crenoteid nvarchar(256)
			SET @L_Crenoteid = (Select crenoteid from cre.note where noteid = @NoteId)

			--exec [dbo].[usp_ExportPIKPrincipalFromCRES]  @L_Crenoteid,@CreatedBy,@CreatedBy

			exec [dbo].[usp_ExportPIKPrincipalFromCRES_API]  @L_Crenoteid,@CreatedBy,@CreatedBy
		--END	
	END
	---===============================

	--=====================Managing Note and Analysis wise calculator fields
	Delete From [CRE].[NoteExtentionCalcField] Where AccountID = @AccountID AND AnalysisID = @AnalysisID;

	INSERT INTO [CRE].[NoteExtentionCalcField] (AccountID,AnalysisID, SelectedMaturityDate,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) 
	Values (@AccountID, @AnalysisID, @MaturityUsedInCalc, @CreatedBy, GETDATE(), @CreatedBy, GETDATE());
END
 
  
  
END  