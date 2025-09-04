-- Procedure
  
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryLiability]
  	@tblTypeTransactionEntryLiability [tblTypeTransactionEntryLiability] READONLY  
AS  
BEGIN  
    SET NOCOUNT ON;

	--Select * into dbo.tmplib from @tblTypeTransactionEntryLiability


	Declare @UserID UNIQUEIDENTIFIER = (Select top 1 UserID from @tblTypeTransactionEntryLiability where AnalysisID is not null); 

	Declare @AnalysisID UNIQUEIDENTIFIER = (Select top 1 AnalysisID from @tblTypeTransactionEntryLiability where AnalysisID is not null);
  
	--DELETE FROM [CRE].[TransactionEntryLiability] WHERE AnalysisID = @AnalysisID and LiabilityAccountID in (Select LiabilityAccountID from @tblTypeTransactionEntryLiability)



	Declare @EquityAccountID UNIQUEIDENTIFIER = (Select Distinct AccountID from cre.Equity where AccountID in (Select LiabilityAccountID from @tblTypeTransactionEntryLiability))



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
	-------------------

	

	----New logic for delete associate data for equity
	Declare @tbldebtAssociateWithEquity as Table(
		LiabilityTypeID UNIQUEIDENTIFIER
	)

	INSERT INTO @tbldebtAssociateWithEquity(LiabilityTypeID)
	Select distinct ln.LiabilitytypeID
	from cre.LiabilityNote ln  
	Inner Join core.Account acc on acc.AccountID = ln.AccountID  
	Where acc.IsDeleted <> 1  
	and ln.AssetAccountID  in (
		Select ln.AssetAccountID
		from cre.LiabilityNote ln  
		Inner Join core.Account acc on acc.AccountID = ln.AccountID  
		Where acc.IsDeleted <> 1  
		and ln.LiabilityTypeID  = @EquityAccountID		
		--in (
		--	Select Distinct AccountID from cre.Equity 
		--	where AccountID in (Select LiabilityAccountID from @tblTypeTransactionEntryLiability)
		--) 
	)
	and ln.accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)


	DELETE FROM [CRE].[TransactionEntryLiability] WHERE AnalysisID = @AnalysisID and LiabilityAccountID in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq)
	and isnull([ParentAccountId],@EquityAccountID) = @EquityAccountID
	---==============================================

  
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
	)  
	Select  @EquityAccountID
	,te.[LiabilityAccountID]	
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

	,'LiabilityCalculator' as Flag
	FROM @tblTypeTransactionEntryLiability  te
	



	------insert from additional transaction
	
		INSERT INTO [CRE].[TransactionEntryLiability]  
		(  
			[ParentAccountId]
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
		)

	select 	
	@EquityAccountID
	,LiabilityTypeID	
	,AccountID	
	,LiabilityNoteID	
	,Date	
	,Amount	
	,TransactionType	
	,AnalysisID	

	
	--,ROUND(SUM(ISNULL(a.Amount,0)) OVER(PARTITION BY a.AnalysisID,a.LiabilityTypeID,a.[AccountID] ORDER BY a.AnalysisID,a.LiabilityTypeID,a.[AccountID],a.[Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance	
	,ROUND(SUM(ISNULL(a.Amount,0)) over (partition by a.AnalysisID,a.LiabilityTypeID,a.[AccountID] order by a.AnalysisID,a.LiabilityTypeID,a.[AccountID],a.[Date]) ,2) AS AccumaltedEndingBalance
	
	,AssetAccountID	
	,AssetDate	
	,AssetAmount	
	,AssetTransactionType
	,CreatedBy  
	,CreatedDate  
	,UpdatedBy  
	,UpdatedDate
	,Flag
	From(

		Select  
		atr.AccountID as LiabilityTypeID
		,atr.LiabilityNoteAccountID as [AccountID]
		,ln.LiabilityNoteID		 
		,atr.TransactionDate as [Date]
		,atr.[TransactionAmount] as [Amount]
		,atr.TransactionTypes as [TransactionType]
		,@AnalysisID as AnalysisID
		,null as EndingBalance
		---,atr.EndingBalance as EndingBalance
		,atr.AssetAccountID			
		,null as AssetDate				
		,null as AssetAmount				
		,null as AssetTransactionType
		,@UserID as CreatedBy
		,getdate() as CreatedDate
		,@UserID as UpdatedBy
		,getdate() as UpdatedDate
		,'LiabilityFundingSchedule' as Flag
		From [CRE].LiabilityFundingSchedule atr
		inner join cre.liabilitynote ln on ln.accountid = atr.LiabilityNoteAccountID
		
		WHERE atr.AccountID in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq) ---(Select LiabilityAccountID from @tblTypeTransactionEntryLiability)
		and ln.accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)
		
		
		--Select  
		--atr.LiabilityTypeID
		--,atr.[AccountID]
		--,ln.LiabilityNoteID		 
		--,atr.[Date]
		--,sum(atr.[Amount]) as [Amount]
		--,atr.[type] as [TransactionType]
		--,atr.[AnalysisID] 		
		--,sum(atr.EndingBalance) as EndingBalance
		--,atr.AssetAccountID			
		--,null as AssetDate				
		--,null as AssetAmount				
		--,null as AssetTransactionType
		--,@UserID as CreatedBy
		--,getdate() as CreatedDate
		--,@UserID as UpdatedBy
		--,getdate() as UpdatedDate		
		--From [CRE].[AdditionalTransactionEntry] atr
		--inner join cre.liabilitynote ln on ln.accountid = atr.accountid
		--WHERE atr.AnalysisID = @AnalysisID and atr.LiabilityTypeID in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq) ---(Select LiabilityAccountID from @tblTypeTransactionEntryLiability)
		--and atr.LiabilityTypeID is not null
		--GROUP BY atr.LiabilityTypeID
		--,atr.[AccountID]
		--,ln.LiabilityNoteID		 
		--,atr.[Date]
		--,atr.[type] 
		--,atr.[AnalysisID] 
		--,atr.AssetAccountID	
	)a





	

  
END  