-- Procedure  
    
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryLiabilityLine]  
   @TableTypeTransactionEntry_LiabilityLine [TableTypeTransactionEntry_LiabilityLine] READONLY    
AS    
BEGIN    
    SET NOCOUNT ON;  
  
 IF EXISTS(Select LiabilityAccountID from @TableTypeTransactionEntry_LiabilityLine)  
 BEGIN  
  Declare @AnalysisID UNIQUEIDENTIFIER = (Select top 1 AnalysisID from @TableTypeTransactionEntry_LiabilityLine where AnalysisID is not null);  
  Declare @UserID UNIQUEIDENTIFIER = (Select top 1 UserID from @TableTypeTransactionEntry_LiabilityLine where AnalysisID is not null);  
    
  --DELETE FROM [CRE].[TransactionEntry] WHERE AnalysisID = @AnalysisID and AccountID in (Select LiabilityAccountID from @TableTypeTransactionEntry_LiabilityLine)  
  
  
  Declare @EquityAccountID UNIQUEIDENTIFIER = (Select Distinct AccountID from cre.Equity where AccountID in (Select LiabilityAccountID from @TableTypeTransactionEntry_LiabilityLine))  
  
  --Declare @AbbreviationName nvarchar(256) = (Select Replace(AbbreviationName,' ','') from cre.equity where accountid = @EquityAccountID)

  
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
	----------------------------------------------


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
	)  
	and ln.accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)
  
  -------CASH transactions  
  --INSERT INTO @tbldebtAssociateWithEquity(LiabilityTypeID)  
  --Select acc.accountid  
  --from cre.debt dt  
  --inner join core.account acc on acc.accountid = dt.accountid  
  --Where acc.IsDeleted<>1  
  --and acc.[name] in ('Portfolio Subline','Portfolio Equity')  
  
  
  ----================================================  
  DELETE FROM [CRE].[TransactionEntry] WHERE AnalysisID = @AnalysisID   
  and AccountID in (  
   Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq  
   UNION  
   Select ll.LiabilityAccountID from @TableTypeTransactionEntry_LiabilityLine ll  
  )  
  and isnull([ParentAccountId],@EquityAccountID) = @EquityAccountID  
  ---==============================================  
  
  
  
  INSERT INTO [CRE].[TransactionEntry]    
  (    
   [ParentAccountId]  
   ,AnalysisID  
   ,AccountID  
   ,[Date]    
   ,Amount    
   ,[Type]    
   ,EndingBalance  
   ,CreatedBy    
   ,CreatedDate    
   ,UpdatedBy    
   ,UpdatedDate  
   ,Flag  
     
  )    
  Select    
  @EquityAccountID  
  ,te.[AnalysisID]   
  ,te.[LiabilityAccountID]  
  ,te.[Date]  
  ,te.[Amount]  
  ,te.[TransactionType]  
  ,te.EndingBalance  
  ,te.UserID as CreatedBy  
  ,getdate() as CreatedDate  
  ,te.UserID as UpdatedBy  
  ,getdate() as UpdatedDate  
  ,'LiabilityCalculator' as Flag  
  FROM @TableTypeTransactionEntry_LiabilityLine  te  
    
  
  ------insert from additional transaction  
  INSERT INTO [CRE].[TransactionEntry]    
  (    
  [ParentAccountId]  
   ,AnalysisID  
   ,AccountID  
   ,[Date]    
   ,Amount    
   ,[Type]    
   ,EndingBalance  
   ,CreatedBy    
   ,CreatedDate    
   ,UpdatedBy    
   ,UpdatedDate  
   ,Flag  
  )   
    
 select   
 @EquityAccountID  
 ,AnalysisID   
 ,AccountID   
 ,[Date]  
 ,Amount   
 ,TransactionType   
 ,ROUND(SUM(ISNULL(a.Amount,0)) OVER(PARTITION BY a.AnalysisID,a.[AccountID] ORDER BY a.AnalysisID,a.[AccountID],a.Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),0) AS AccumaltedEndingBalance  
 ,CreatedBy    
 ,CreatedDate    
 ,UpdatedBy    
 ,UpdatedDate  
 ,Flag  
 from(  
  
  Select    
  @AnalysisID as AnalysisID  
  ,atr.[AccountID]  
  ,atr.[TransactionDate] as [Date]  
  ,atr.[TransactionAmount] as Amount  
  ,atr.[TransactionTypes] as TransactionType  
  ,null as EndingBalance  
  ,@UserID as CreatedBy  
  ,getdate() as CreatedDate  
  ,@UserID as UpdatedBy  
  ,getdate() as UpdatedDate  
  ,'LiabilityFundingScheduleAggregate' as Flag  
  From [CRE].LiabilityFundingScheduleAggregate atr  
  WHERE  atr.AccountID  in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq) 
  and atr.ParentAccountID = @EquityAccountID
    
  --UNION ALL  
  
  --Select    
  --@AnalysisID as AnalysisID  
  --,atr.[AccountID]  
  --,atr.Date as [Date]  
  --,atr.Amount as Amount  
  --,atr.[Type] as TransactionType  
  --,null as EndingBalance  
  --,@UserID as CreatedBy  
  --,getdate() as CreatedDate  
  --,@UserID as UpdatedBy  
  --,getdate() as UpdatedDate  
  --,'Transaction from manual entries' as Flag  
  --From [CRE].TransactionEntryManual atr  
  --WHERE  atr.AccountID  in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq)   
  
  --Select    
  -- atr.[AnalysisID]   
  --,atr.[AccountID]  
  --,atr.[Date]  
  --,sum(atr.[Amount]) as [Amount]  
  --,atr.[type] as [TransactionType]  
  --,sum(atr.EndingBalance) as EndingBalance  
  --,@UserID as CreatedBy  
  --,getdate() as CreatedDate  
  --,@UserID as UpdatedBy  
  --,getdate() as UpdatedDate  
  --,'AdditionalTransaction' as Flag  
  --From [CRE].[AdditionalTransactionEntry] atr  
  --WHERE atr.AnalysisID = @AnalysisID and atr.AccountID in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq) ---(Select LiabilityAccountID from @TableTypeTransactionEntry_LiabilityLine)  
  --and atr.liabilityTypeID is null  
  --GROUP BY atr.[AnalysisID]   
  --,atr.[AccountID]  
  --,atr.[Date]  
  --,atr.[type]  
 )a  
 order by a.date  
  
  
  


	Update [CRE].LiabilityFundingScheduleAggregate set [CRE].LiabilityFundingScheduleAggregate.EndingBalance = z.AccumaltedEndingBalance
	From(
		Select  LiabilityFundingScheduleAggregateID
		,atr.[AccountID]  
		,atr.[TransactionDate] as [Date]  
		,atr.[TransactionAmount] as Amount  
		,atr.[TransactionTypes] as TransactionType  
		,ROUND(SUM(ISNULL(atr.[TransactionAmount],0)) OVER(PARTITION BY atr.[AccountID] ORDER BY atr.[AccountID],atr.[TransactionDate] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),0) AS AccumaltedEndingBalance  
		From [CRE].LiabilityFundingScheduleAggregate atr  
		WHERE  atr.AccountID  in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq)  
	)z
	Where [CRE].LiabilityFundingScheduleAggregate.LiabilityFundingScheduleAggregateID = z.LiabilityFundingScheduleAggregateID



	Update cre.transactionentry set cre.transactionentry.EndingBalance = z.AccumaltedEndingBalance
	From(
		Select tr.transactionentryID,accP.name as ParentAccount,acc.name as account,date,[type],amount,endingbalance 
		,ROUND(SUM(ISNULL(tr.[Amount],0)) OVER(PARTITION BY tr.[AccountID] ORDER BY tr.[AccountID],tr.[Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),0) AS AccumaltedEndingBalance  
		from cre.transactionentry tr
		inner join core.account acc on acc.accountid = tr.accountid
		left join core.account accP on accP.accountid = tr.ParentAccountId
		where analysisid = @AnalysisID
		and tr.accountid in (Select aseq.LiabilityTypeID from @tbldebtAssociateWithEquity aseq)  
		and tr.[type] <> 'InterestPaid'
	)z
	Where cre.transactionentry.transactionentryID = z.transactionentryID



 ----EXEC [dbo].[usp_UpdateLiabilityBalanceColumns] @EquityAccountID,@AnalysisID  
  
 END  
  
    
END
GO

