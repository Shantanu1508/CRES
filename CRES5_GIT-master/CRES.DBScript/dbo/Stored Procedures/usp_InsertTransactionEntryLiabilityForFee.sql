CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryLiabilityForFee](
  	@tblTypeTransactionEntryLiability [tblTypeTransactionEntryLiabilityForFee] READONLY  
)
AS  
BEGIN  
    SET NOCOUNT ON;

	--Select * into dbo.temp_tblTypeTransactionEntryLiability
	--from @tblTypeTransactionEntryLiability


	Declare @UserID UNIQUEIDENTIFIER = (Select top 1 UserID from @tblTypeTransactionEntryLiability where AnalysisID is not null); 

	Declare @AnalysisID UNIQUEIDENTIFIER = (Select top 1 AnalysisID from @tblTypeTransactionEntryLiability where AnalysisID is not null);
	Declare @CalcType  INT =(Select top 1 CalcType from @tblTypeTransactionEntryLiability where AnalysisID is not null);
  
	Declare @EquityAccountID UNIQUEIDENTIFIER = (Select top 1 LiabilityAccountID from @tblTypeTransactionEntryLiability)


	--delete fee transactions from TransactionEntry
	delete from [CRE].[TransactionEntry] where AnalysisID = @AnalysisID and  ParentAccountId = @EquityAccountID
	and AccountId in (select LiabilityTypeID from @tblTypeTransactionEntryLiability)
	and [Type] in (Select transactionname from cre.TransactionTypes where transactionname like '%fee%')
	and CalcType=@CalcType


	delete from [CRE].[TransactionEntry] where AnalysisID = @AnalysisID and  ParentAccountId = @EquityAccountID
	and AccountId = @EquityAccountID
	and [Type] in (Select transactionname from cre.TransactionTypes where transactionname like '%fee%')
	and CalcType=@CalcType
	---==============================================

	-----Insert for Facility
	INSERT INTO [CRE].[TransactionEntry]  
	(  [ParentAccountId]
	,[AccountId]
	,[Date]					
	,[Amount]				
	,[Type]
	,[FeeName]
	,[AnalysisID]			
	,CreatedBy  
	,CreatedDate  
	,UpdatedBy  
	,UpdatedDate
	,Flag
	,CalcType
	)  
	Select  @EquityAccountID
	,te.LiabilityTypeID
	,te.[Date]					
	,te.[Amount]				
	,te.[TransactionType]
	,te.[FeeName]
	,te.[AnalysisID]			
	,te.UserID as CreatedBy
	,getdate() as CreatedDate
	,te.UserID as UpdatedBy
	,getdate() as UpdatedDate
	,'LiabilityFeeCalculator' as Flag
	,CalcType
	FROM @tblTypeTransactionEntryLiability  te


	-----Insert for Fund
	INSERT INTO [CRE].[TransactionEntry]  
	( [ParentAccountId]
	,[AccountId]
	,[Date]					
	,[Amount]				
	,[Type]
	,[FeeName]
	,[AnalysisID]			
	,CreatedBy  
	,CreatedDate  
	,UpdatedBy  
	,UpdatedDate
	,Flag
	,CalcType
	)  
	Select  @EquityAccountID
	,@EquityAccountID
	,te.[Date]					
	,SUM(te.[Amount]) as [Amount]			
	,te.[TransactionType]
	,te.[FeeName]
	,te.[AnalysisID]			
	,te.UserID as CreatedBy
	,getdate() as CreatedDate
	,te.UserID as UpdatedBy
	,getdate() as UpdatedDate
	,'LiabilityFeeCalculator' as Flag
	,CalcType
	FROM @tblTypeTransactionEntryLiability  te  
	group by te.[Date],te.[TransactionType]	,te.[FeeName],te.[AnalysisID],CalcType,te.UserID

END  
