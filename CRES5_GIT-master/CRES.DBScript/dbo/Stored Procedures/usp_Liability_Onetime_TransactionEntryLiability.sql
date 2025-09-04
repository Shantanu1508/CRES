
CREATE PROCEDURE [dbo].[usp_Liability_Onetime_TransactionEntryLiability]   
(  
	@gCutoffdate Date
)   
  
AS  
BEGIN  
 SET NOCOUNT ON;  


--truncate table CRE.LiabilityFundingScheduleAggregate
--Truncate table CRE.LiabilityFundingSchedule

--go
------Insert TransactionEntryLiability--------------

Declare @cutoffdate Date= @gCutoffdate ;------'01/24/2025';

Declare @L_EquityName nvarchar(256);
Declare @equityAccountID UNIQUEIDENTIFIER;


SET @L_EquityName = (Select top 1 EquityName from [Lib_11Trans])
SET @equityAccountID = (Select e.accountid from cre.equity e inner join core.account acc on acc.accountid = e.accountid where acc.name = @L_EquityName)

---============================================



Delete from [CRE].[TransactionEntryLiability] where ParentAccountId = @equityAccountID


----Equity liability note transaction----------------------------
Declare @EquityCapitalTransactions as table(
	[Equity  Name] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[CRENoteID] [nvarchar](255) NULL,
	[Transaction Date] [datetime] NULL,
	[Transaction Amount] decimal(28,15) NULL,
	[Confirmed] [bit] NOT NULL,
	[Comments] [nvarchar](255) NULL
)

INSERT @EquityCapitalTransactions ([Equity  Name], [Description], [CRENoteID], [Transaction Date], [Transaction Amount], [Confirmed], [Comments])
Select EquityName as [Equity Name]
,[Description]	
,[Note ID] CRENoteID	
,[Date] as [Transaction Date]	
,[Transaction] as [Transaction Amount]
,1 as Confirmed	
,(CASE WHEN [Transaction] >= 0 THEN 'EquityCapitalCall' ELSE 'EquityCapitalDistribution' END) Comments	 
from [dbo].[Lib_11Trans]
where [deal id] <> 'Portfolio'
--and [Deal Name] not in ( 'ACP II Portfolio','ACP II')
and [Transaction Type] = 'Equity'
and date <= @cutoffdate


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
Select @equityAccountID  as EquityAccountID
,ln.LiabilityTypeID as [LiabilityAccountID]	
,lmapp.LiabilityNoteAccountId as [LiabilityNoteAccountID]
,ln.LiabilityNoteID [LiabilityNoteID]
,[Transaction Date] as [Date]					
,[Transaction Amount] as [Amount]				
,eq.Comments as [TransactionType]					
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' [AnalysisID]			
,ROUND(SUM(ISNULL(eq.[Transaction Amount],0)) OVER(PARTITION BY [AccountID] ORDER BY [AccountID],eq.[Transaction Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
,lmapp.AssetAccountId as AssetAccountID			
,[Transaction Date] as AssetDate				
,null as AssetAmount				
,null as AssetTransactionType		
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'History data Equity' as Flag
From @EquityCapitalTransactions eq
left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
where ln.LiabilityTypeID = @equityAccountID

----Equity liability note transaction----------------------------


----INSert Repo or subline  liability note transaction---------------------------------
Declare @DebtDrawsPaydowns as table(
	EquityName [nvarchar](255) NULL,  
	[Liability  Name] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[CRENoteID] [nvarchar](255) NULL,
	[Transaction Date] [datetime] NULL,
	[Transaction Amount] [float] NULL,
	[Confirmed] [bit] NOT NULL,
	[Comments] [nvarchar](255) NULL,
	[Asset ID (Deal or Note ID)] [nvarchar](255) NULL,
	[Transaction Type] [nvarchar](255) NULL
) 


Delete from @DebtDrawsPaydowns


INSERT @DebtDrawsPaydowns (EquityName,[Liability  Name], [Description], [CRENoteID], [Transaction Date], [Transaction Amount], [Confirmed], [Comments],[Transaction Type])

Select EquityName
,[Financing Facility] as [Liability  Name]
,[Description]
,[Note ID] as [CRENoteID]
,[Date] as [Transaction Date]
,[Transaction] as [Transaction Amount]
,1 as [Confirmed]
,(CASE WHEN [Transaction] >= 0 THEN 'SublineAdvance' ELSE 'SublinePaydown' END) Comments
,[Transaction Type]
from [dbo].[Lib_11Trans] 
where 
--[Financing Facility] = 'Cap One 2022-01' 
[Financing Facility] in (Select Distinct [Financing Facility] from [dbo].[Lib_11Trans] Where [Transaction Type] = 'Subline')
and [deal id] <> 'Portfolio'
and [Note ID] is not NULL
and [Date] <= @cutoffdate 

UNION ALL

Select EquityName
,[Financing Facility] as [Liability  Name]
,[Description]
,[Note ID] as [CRENoteID]
,[Date] as [Transaction Date]
,[Transaction] as [Transaction Amount]
,1 as [Confirmed]
,(CASE WHEN [Transaction] >= 0 THEN 'RepoAdvance' ELSE 'RepoPaydown' END) Comments
,[Transaction Type]
from [dbo].[Lib_11Trans] 
where --[Financing Facility] in ('MS Repo','WF Repo')
[Financing Facility] in (Select Distinct [Financing Facility] from [dbo].[Lib_11Trans] Where [Transaction Type] in ('Repo','NoN'))
and [deal id] <> 'Portfolio'
and [Note ID] is not NULL
and [Date] <= @cutoffdate 


UNION ALL

Select EquityName
,[Financing Facility] as [Liability  Name]
,[Description]
,[Note ID] as [CRENoteID]
,[Date] as [Transaction Date]
,[Transaction] as [Transaction Amount]
,1 as [Confirmed]
,(CASE WHEN [Transaction] >= 0 THEN 'RepoAdvance' ELSE 'RepoPaydown' END) Comments
,[Transaction Type]
from [dbo].[Lib_11Trans] 
where --[Financing Facility] in ('MS Repo','WF Repo')
 [Transaction Type] in ('Sale')
and [deal id] <> 'Portfolio'
and [Note ID] is not NULL
and [Date] <= @cutoffdate 

UNION ALL


Select EquityName
,'Portfolio Equity' as [Liability  Name]
,[Description]
,[Note ID] as [CRENoteID]
,[Date] as [Transaction Date]
,[Transaction] as [Transaction Amount]
,1 as [Confirmed]
,(CASE WHEN [Transaction] >= 0 THEN 'EquityCapitalCall' ELSE 'EquityCapitalDistribution' END) Comments
,'Portfolio Equity'  [Transaction Type]
from [dbo].[Lib_11Trans] 
where [deal id] = 'Portfolio'
and [Note ID] is not NULL
and [transaction type] ='Equity'
and [Date] <= @cutoffdate 


UNION ALL


Select EquityName
,'Portfolio Subline' as [Liability  Name]
,[Description]
,[Note ID] as [CRENoteID]
,[Date] as [Transaction Date]
,[Transaction] as [Transaction Amount]
,1 as [Confirmed]
,(CASE WHEN [Transaction] >= 0 THEN 'SublineAdvance' ELSE 'SublinePaydown' END) Comments
,'Portfolio Subline'  [Transaction Type]
from [dbo].[Lib_11Trans] 
where [deal id] = 'Portfolio'
and [Note ID] is not NULL
and [transaction type] ='Subline'
and [Date] <= @cutoffdate 
------------------------



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



Select 
EquityAccountID
,LiabilityAccountID
,LiabilityNoteAccountID
,LiabilityNoteID
,Date
,Amount
,TransactionType
,AnalysisID
,AccumaltedEndingBalance
,AssetAccountID
,AssetDate
,AssetAmount
,AssetTransactionType
,CreatedBy
,CreatedDate
,UpdateBy
,UpdatedDate
,Flag
From(

	Select @equityAccountID  as EquityAccountID
	,ln.LiabilityTypeID as [LiabilityAccountID]	
	,lmapp.LiabilityNoteAccountId as [LiabilityNoteAccountID]
	,ln.LiabilityNoteID [LiabilityNoteID]
	,[Transaction Date] as [Date]					
	,[Transaction Amount] as [Amount]				
	,eq.Comments as [TransactionType]					
	,'C10F3372-0FC2-4861-A9F5-148F1F80804F' [AnalysisID]			
	,ROUND(SUM(ISNULL(eq.[Transaction Amount],0)) OVER(PARTITION BY [AccountID] ORDER BY [AccountID],eq.[Transaction Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
	,lmapp.AssetAccountId as AssetAccountID			
	,[Transaction Date] as AssetDate				
	,null as AssetAmount				
	,null as AssetTransactionType		
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
	,GETDATE() as CreatedDate
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdateBy
	,GETDATE() as UpdatedDate
	,'History data Equity' as Flag

	From @DebtDrawsPaydowns eq
	left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
	left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
	
	--left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
	left join (
		Select ln.AccountID ,acc.name as LibTypeName,ln.LiabilityTypeID,LiabilityNoteID
		from cre.liabilityNote ln
		left Join core.account acc on acc.accountid = ln.liabilitytypeid
	)ln on ln.AccountID = lmapp.LiabilityNoteAccountId and eq.[Liability  Name] = ln.LibTypeName

	left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
	where [Transaction Type] in ('Repo','NoN','Sale')
	and  ln.LiabilityTypeID  in (Select e.accountid from cre.debt e inner join core.account acc on acc.accountid = e.accountid where acc.name in (
		Select Distinct [Financing Facility] from [dbo].[Lib_11Trans] Where [Financing Facility] <> '' and [Transaction Type] in ('Repo','NoN','Sale'))
	)
	and [Transaction Date] <= @cutoffdate


	UNION ALL


	Select @equityAccountID  as EquityAccountID
	,ln.LiabilityTypeID as [LiabilityAccountID]	
	,lmapp.LiabilityNoteAccountId as [LiabilityNoteAccountID]
	,ln.LiabilityNoteID [LiabilityNoteID]
	,[Transaction Date] as [Date]					
	,[Transaction Amount] as [Amount]				
	,eq.Comments as [TransactionType]					
	,'C10F3372-0FC2-4861-A9F5-148F1F80804F' [AnalysisID]			
	,ROUND(SUM(ISNULL(eq.[Transaction Amount],0)) OVER(PARTITION BY [AccountID] ORDER BY [AccountID],eq.[Transaction Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
	,lmapp.AssetAccountId as AssetAccountID			
	,[Transaction Date] as AssetDate				
	,null as AssetAmount				
	,null as AssetTransactionType		
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
	,GETDATE() as CreatedDate
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdateBy
	,GETDATE() as UpdatedDate
	,'History data Equity' as Flag

	From @DebtDrawsPaydowns eq
	left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
	left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
	left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
	left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
	where [Transaction Type] = 'Subline'
	and  ln.LiabilityTypeID  in (Select e.accountid from cre.debt e inner join core.account acc on acc.accountid = e.accountid where acc.name in (
		Select Distinct [Financing Facility] from [dbo].[Lib_11Trans] Where [Financing Facility] <> '' and [Transaction Type] in ('Subline'))
	)
	and [Transaction Date] <= @cutoffdate


	UNION ALL


	Select @equityAccountID  as EquityAccountID
	,ln.LiabilityTypeID as [LiabilityAccountID]	
	,lmapp.LiabilityNoteAccountId as [LiabilityNoteAccountID]
	,ln.LiabilityNoteID [LiabilityNoteID]
	,[Transaction Date] as [Date]					
	,[Transaction Amount] as [Amount]				
	,eq.Comments as [TransactionType]					
	,'C10F3372-0FC2-4861-A9F5-148F1F80804F' [AnalysisID]			
	,ROUND(SUM(ISNULL(eq.[Transaction Amount],0)) OVER(PARTITION BY [AccountID] ORDER BY [AccountID],eq.[Transaction Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
	,lmapp.AssetAccountId as AssetAccountID			
	,[Transaction Date] as AssetDate				
	,null as AssetAmount				
	,null as AssetTransactionType		
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
	,GETDATE() as CreatedDate
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdateBy
	,GETDATE() as UpdatedDate
	,'History data Equity' as Flag

	From @DebtDrawsPaydowns eq
	left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
	left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
	left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
	left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
	where [Transaction Type] = 'Portfolio Equity'
	and  ln.LiabilityTypeID  in (Select PortfolioAccountID from cre.equity where AccountID = @equityAccountID)
	and [Transaction Date] <= @cutoffdate


	UNION ALL


	Select @equityAccountID  as EquityAccountID
	,ln.LiabilityTypeID as [LiabilityAccountID]	
	,lmapp.LiabilityNoteAccountId as [LiabilityNoteAccountID]
	,ln.LiabilityNoteID [LiabilityNoteID]
	,[Transaction Date] as [Date]					
	,[Transaction Amount] as [Amount]				
	,eq.Comments as [TransactionType]					
	,'C10F3372-0FC2-4861-A9F5-148F1F80804F' [AnalysisID]			
	,ROUND(SUM(ISNULL(eq.[Transaction Amount],0)) OVER(PARTITION BY [AccountID] ORDER BY [AccountID],eq.[Transaction Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
	,lmapp.AssetAccountId as AssetAccountID			
	,[Transaction Date] as AssetDate				
	,null as AssetAmount				
	,null as AssetTransactionType		
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
	,GETDATE() as CreatedDate
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdateBy
	,GETDATE() as UpdatedDate
	,'History data Equity' as Flag

	From @DebtDrawsPaydowns eq
	left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
	left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
	left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
	left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
	where [Transaction Type] = 'Portfolio Subline'
	and  ln.LiabilityTypeID  in (Select PortfolioAccountID from cre.Debt where AccountID = (Select LinkedShortTermBorrowingFacility from cre.equity where AccountID = @equityAccountID))
	and [Transaction Date] <= @cutoffdate

)z
----INSert Repo or subline  liability note transaction---------------------------------



END