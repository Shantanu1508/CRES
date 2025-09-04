-- Procedure
  
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryLiabilityForFeeAndInterest](
  	@tblTypeTransactionEntryLiability [tblTypeTransactionEntryLiabilityForFeeAndInterest] READONLY  
)
AS  
BEGIN  
    SET NOCOUNT ON;

	--Select * INTO dbo.tempdata  from @tblTypeTransactionEntryLiability

	Declare @UserID UNIQUEIDENTIFIER = (Select top 1 UserID from @tblTypeTransactionEntryLiability where AnalysisID is not null); 

	Declare @AnalysisID UNIQUEIDENTIFIER = (Select top 1 AnalysisID from @tblTypeTransactionEntryLiability where AnalysisID is not null);
	Declare @CalcType  INT =(Select top 1 CalcType from @tblTypeTransactionEntryLiability where AnalysisID is not null);
  
	Declare @EquityAccountID UNIQUEIDENTIFIER = (Select top 1 LiabilityAccountID from @tblTypeTransactionEntryLiability)



	----------------------------------------------
	Declare @tblliabilityNoteAccountID as table(
	liabilityNoteAccountID UNIQUEIDENTIFIER
	)

	INSERT INTO @tblliabilityNoteAccountID(liabilityNoteAccountID)

	SELECT Distinct ln.AccountID
	FROM cre.liabilitynote ln
	INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
	INNER JOIN (
		SELECT am.AssetAccountId AS assetnotesid
		FROM cre.liabilitynote l
		INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
		WHERE l.LiabilityTypeID = @EquityAccountID
	) sub ON la.AssetAccountId = sub.assetnotesid
	LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
	where a.IsDeleted <> 1
	and ln.LiabilityTypeID in (Select accountid from cre.Debt)
	-------------------

	--delete for libility in TransactionEntryLiability
	DELETE FROM [CRE].[TransactionEntryLiability] WHERE AnalysisID = @AnalysisID and LiabilityNoteAccountID in (Select aseq.LiabilityNoteAccountID from @tblTypeTransactionEntryLiability aseq)
	and isnull([ParentAccountId],@EquityAccountID) = @EquityAccountID
	and CalcType=@CalcType


	DELETE FROM [CRE].[TransactionEntryLiability] WHERE AnalysisID = @AnalysisID 
	and LiabilityNoteAccountID is null
	and TransactionType = 'InterestPaid'
	and LiabilityNoteID like '%unallocatedbls_%'
	and isnull([ParentAccountId],@EquityAccountID) = @EquityAccountID
	and CalcType=@CalcType


	delete from [CRE].[TransactionEntry] where AnalysisID = @AnalysisID  and CalcType = @CalcType and ParentAccountId = @EquityAccountID
	and AccountId in 
	(
		--Select  te.LiabilityAccountID
		--FROM [CRE].TransactionEntryLiability  te
		--join @tblliabilityNoteAccountID ln on te.[LiabilityNoteAccountID]=ln.liabilityNoteAccountID
		--where CalcType=@CalcType

		--union

		--Select  te.LiabilityAccountID
		--FROM [CRE].TransactionEntryLiability  te		
		--where CalcType=@CalcType
		--and te.[LiabilityNoteAccountID] is null
		--and [ParentAccountId] = @EquityAccountID

		--union

		--select @EquityAccountID 

		Select Distinct LiabilityTypeID from @tblTypeTransactionEntryLiability
		UNION
		Select Distinct LiabilityAccountID from @tblTypeTransactionEntryLiability	
	)  

	---==============================================

	
	

  --all transactions of fund

	INSERT INTO [CRE].[TransactionEntryLiability]  
	(  [ParentAccountId]
		,[LiabilityAccountID]	
		,[LiabilityNoteAccountID]
		,[LiabilityNoteID]
		,[Date]					
		,[Amount]				
		,[TransactionType]					
		,[AnalysisID]			
		,EndingBalance			
		,AssetAccountID			
		,AssetDate				
		,AssetAmount				
		,AssetTransactionType
		,CreatedBy  
		,CreatedDate  
		,UpdatedBy  
		,UpdatedDate
		,Flag
		,CalcType
		,AllInCouponRate,
		SpreadValue,
		OriginalIndex
	)  
	Select  @EquityAccountID
	,te.[LiabilityTypeID]	
	,te.[LiabilityNoteAccountID]
	,te.[LiabilityNoteID]
	,te.[Date]					
	,te.[Amount]				
	,te.[TransactionType]					
	,te.[AnalysisID]			
	,te.EndingBalance			
	,te.AssetAccountID			
	,te.AssetDate				
	,te.AssetAmount				
	,te.AssetTransactionType		
	,te.UserID as CreatedBy
	,getdate() as CreatedDate
	,te.UserID as UpdatedBy
	,getdate() as UpdatedDate

	,'LiabilityFeeInterestCalculator' as Flag
	,CalcType
	,AllInCouponRate
	,SpreadValue
	,OriginalIndex
	FROM @tblTypeTransactionEntryLiability  te
	
	-- transactions based on libility type
	INSERT INTO [CRE].[TransactionEntry]  
	(  [ParentAccountId],
		[AccountId],
		[Date],
		[Amount],
		[Type]     		
		,[AnalysisID]			
		,CreatedBy  
		,CreatedDate  
		,UpdatedBy  
		,UpdatedDate
		,Flag
		,CalcType
		,AllInCouponRate
		,SpreadValue
		,OriginalIndex
		,DealAccountId
	)  
	
	 select @EquityAccountID,LiabilityAccountID,[Date],Amount,TransactionType,@AnalysisID,@UserID,getdate(),@UserID,getdate()
	,'LiabilityFeeInterestCalculator' as Flag
	,@CalcType
	,AllInCouponRate
	,SpreadValue
	,OriginalIndex
	,DealAccountID
	from
	(
		select AnalysisID,LiabilityAccountID
		,[Date]					
		,sum([Amount]) as Amount			
		,[TransactionType]
		,[AllInCouponRate]
		,[SpreadValue]
		,[OriginalIndex]
		,DealAccountID
		from
		(
			select te.AnalysisID,te.LiabilityAccountID
			,te.[Date]					
			,te.[Amount]			
			,te.[TransactionType]
			,null as [AllInCouponRate]
			,null as [SpreadValue]
			,null as [OriginalIndex]
			,libn.DealAccountID
			FROM [CRE].TransactionEntryLiability  te
			join @tblliabilityNoteAccountID ln on te.[LiabilityNoteAccountID]=ln.liabilityNoteAccountID
			Inner Join cre.LiabilityNote libn on libn.AccountID = te.LiabilityNoteAccountID
			where CalcType=@CalcType

			union

			select AnalysisID,LiabilitytypeID as LiabilityAccountID
			,[Date]					
			,Amount			
			,[TransactionType]
			,null as [AllInCouponRate]
			,null as [SpreadValue]
			,null as [OriginalIndex]
			,null as DealAccountID
			from @tblTypeTransactionEntryLiability where liabilityNoteAccountID is null
		) tin
		group by AnalysisID,[LiabilityAccountID],[Date],[TransactionType],[AllInCouponRate]
		,[SpreadValue]
		,[OriginalIndex]	
		,DealAccountID
	) tbl
	
	
	
	-- aggregate transaction of fund

	INSERT INTO [CRE].[TransactionEntry]  
	(  
		[ParentAccountId],
		[AccountId],
		[Date],
		[Amount],
		[Type]     		
		,[AnalysisID]			
		,CreatedBy  
		,CreatedDate  
		,UpdatedBy  
		,UpdatedDate
		,Flag
		,CalcType
		,AllInCouponRate
		,SpreadValue
		,OriginalIndex
		,DealAccountId
	)  

	select @EquityAccountID,@EquityAccountID,[Date],Amount,TransactionType,@AnalysisID,@UserID,getdate(),@UserID,getdate()
	,'LiabilityFeeInterestCalculator' as Flag
	,@CalcType
	,[AllInCouponRate]
	,[SpreadValue]
	,[OriginalIndex]
	,DealAccountID
	from
	(
		select AnalysisID
		,[Date]					
		,sum([Amount]) as Amount			
		,[TransactionType]
		,[AllInCouponRate]
		,[SpreadValue]
		,[OriginalIndex]
		,DealAccountID
		from
		(
			Select  te.AnalysisID,
			te.[Date]					
			,te.[Amount]
			,te.[TransactionType]
			,null as [AllInCouponRate]
			,null as [SpreadValue]
			,null as [OriginalIndex]
			,libn.DealAccountID
			FROM [CRE].TransactionEntryLiability  te
			join @tblliabilityNoteAccountID ln on te.[LiabilityNoteAccountID]=ln.liabilityNoteAccountID
			Inner Join cre.LiabilityNote libn on libn.AccountID = te.LiabilityNoteAccountID
			where CalcType=@CalcType

			union

			select AnalysisID,[Date],Amount,[TransactionType]
			,null as [AllInCouponRate]
			,null as [SpreadValue]
			,null as [OriginalIndex]
			,null as DealAccountID
			from @tblTypeTransactionEntryLiability where liabilityNoteAccountID is null
		)tin
		group by AnalysisID,[Date],[TransactionType],[AllInCouponRate]
		,[SpreadValue]
		,[OriginalIndex]	
		,DealAccountID
	) tbl1
  
END  