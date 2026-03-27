CREATE PROCEDURE [dbo].[usp_Liability_Onetime_TransactionEntry_ACPI]   
(  
	@gCutoffdate Date
)   
  
AS  
BEGIN  
 SET NOCOUNT ON;  

Declare @cutoffdate Date= @gCutoffdate;  ----'01/24/2025';


Declare @L_EquityName nvarchar(256);
SET @L_EquityName = (Select top 1 EquityName from [Lib_11Trans])


Declare @equityAccountID UNIQUEIDENTIFIER;
SET @equityAccountID = (Select e.accountid from cre.equity e inner join core.account acc on acc.accountid = e.accountid where acc.name = @L_EquityName)


Declare @PortfolioEquityAccountID UNIQUEIDENTIFIER;
SET @PortfolioEquityAccountID = (Select PortfolioAccountID from cre.equity where AccountID = @equityAccountID)


Declare @SublineAccountID UNIQUEIDENTIFIER;
SET @SublineAccountID =(Select LinkedShortTermBorrowingFacility from cre.equity where AccountID = @equityAccountID)

Declare @PortfolioSublineAccountID UNIQUEIDENTIFIER;
SET @PortfolioSublineAccountID = (Select PortfolioAccountID from cre.debt where accountid = @SublineAccountID )



Declare @L_EquityNameAbbrevation nvarchar(256);
SET @L_EquityNameAbbrevation = (Select AbbreviationName from cre.equity where AccountID = @equityAccountID)

SET @L_EquityNameAbbrevation = @L_EquityNameAbbrevation + ' Portfolio';
----======================================

Delete from [CRE].[TransactionEntry] where ParentAccountId = @equityAccountID


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
@equityAccountID as ParentID
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID] 
,@equityAccountID as [LiabilityAccountID]
,te.[Date]
,te.[Transaction] as Amount
,(CASE WHEN ROUND(([Transaction]),2)  >= 0 THEN 'EquityCapitalCall' ELSE 'EquityCapitalDistribution' END) as [TransactionType]
,ROUND(SUM(ISNULL(te.[Transaction],0)) OVER(PARTITION BY @equityAccountID ORDER BY @equityAccountID,te.[Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'LiabilityCalculator' as Flag

From(
Select [Date],SUM(ROUND([Transaction],2)) as [Transaction] 
From(
	Select [Date],SUM([Transaction]) as [Transaction],'SumOfDetailTran (Aggregare)' as TranType
	from [dbo].[Lib_11Trans]
	where [deal id] = 'Portfolio'
	and [Deal Name] = @L_EquityNameAbbrevation  ----'ACP II Portfolio'
	and [Transaction Type] = 'Equity'
	and [Date] <= @cutoffdate
	group by [Date]

UNION ALL

Select [Date],SUM([Transaction]) as [Transaction],'SumOfDetailTran (Aggregare)' as TranType
from [dbo].[Lib_11Trans]
where [deal id] <> 'Portfolio'
and [Deal Name] <> @L_EquityNameAbbrevation  ----'ACP II Portfolio'
and [Transaction Type] = 'Equity'
--and [date] not in (
--	Select [Date]
--	from [dbo].[Lib_11Trans]
--	where [deal id] = 'Portfolio'
--	and [Deal Name] = @L_EquityNameAbbrevation  ----'ACP II Portfolio'
--	and [Transaction Type] = 'Equity'
--	and [Date] <= @cutoffdate
--)
and [Date] <= @cutoffdate
group by [Date]

UNION ALL

Select [Date],SUM([Transaction]) as [Transaction],'SumOfDetailTran (Aggregare)' as TranType
from [dbo].[Lib_11Trans]
where [deal id] = 'Portfolio'
and [Deal Name] <> @L_EquityNameAbbrevation  ----'ACP II Portfolio'
and [Transaction Type] = 'Equity'
and [Date] <= @cutoffdate
--and [date] not in (
--	Select [Date]
--	from [dbo].[Lib_11Trans]
--	where [deal id] = 'Portfolio'
--	and [Deal Name] = @L_EquityNameAbbrevation  ----'ACP II Portfolio'
--	and [Transaction Type] = 'Equity'
--	and [Date] <= @cutoffdate
--)
group by [Date]

)a
group by date,TranType

)te

UNION ALL


-----Subline

Select  
@equityAccountID as ParentID
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID] 
,@SublineAccountID as [LiabilityAccountID]
,te.[Date]
,te.[Transaction] as Amount
,(CASE WHEN ROUND(([Transaction]),2)  >= 0 THEN 'SublineAdvance' ELSE 'SublinePaydown' END) as [TransactionType]
,ROUND(SUM(ISNULL(te.[Transaction],0)) OVER(PARTITION BY @SublineAccountID ORDER BY @SublineAccountID,te.[Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'LiabilityCalculator' as Flag
From(
Select [Date],SUM(ROUND([Transaction],0)) as [Transaction] 
From(
Select [Date],SUM([Transaction]) as [Transaction],'SumOfDetailTran (Aggregare)' as TranType
from [dbo].[Lib_11Trans]
where [deal id] = 'Portfolio'
and [Deal Name] = @L_EquityNameAbbrevation  ----'ACP II Portfolio'
and [Transaction Type] = 'Subline'
and [Date] <= @cutoffdate

group by [Date]

UNION ALL

Select [Date],SUM([Transaction]) as [Transaction],'SumOfDetailTran (Aggregare)' as TranType
from [dbo].[Lib_11Trans]
where [deal id] <> 'Portfolio'
and [Deal Name] <> @L_EquityNameAbbrevation  ----'ACP II Portfolio'
and [Transaction Type] = 'Subline'
--and [date] not in (
--	Select [Date]
--	from [dbo].[Lib_11Trans]
--	where [deal id] = 'Portfolio'
--	and [Deal Name] = @L_EquityNameAbbrevation  ----'ACP II Portfolio'
--	and [Transaction Type] = 'Subline'
--	and [Date] <= @cutoffdate
--)
and [Date] <= @cutoffdate
group by [Date]

UNION ALL

Select [Date],SUM([Transaction]) as [Transaction],'SumOfDetailTran (Aggregare)' as TranType
from [dbo].[Lib_11Trans]
where [deal id] = 'Portfolio'
and [Deal Name] <> @L_EquityNameAbbrevation  ----'ACP II Portfolio'
and [Transaction Type] = 'Subline'
and [Date] <= @cutoffdate
--and [date] not in (
--	Select [Date]
--	from [dbo].[Lib_11Trans]
--	where [deal id] = 'Portfolio'
--	and [Deal Name] = @L_EquityNameAbbrevation  ----'ACP II Portfolio'
--	and [Transaction Type] = 'Subline'
--	and [Date] <= @cutoffdate
--)
group by [Date]

)a
group by date,TranType

)te



-----Repos

UNION ALL


Select 
ParentID	
,AnalysisID	
,LiabilityAccountID	
,[Date]	
,SUM(Amount) as Amount	
,(CASE WHEN SUM(Amount) >= 0 THEN 'RepoAdvance' ELSE 'RepoPaydown' END) TransactionType
,ROUND(SUM(ISNULL(SUM(Amount),0)) OVER(PARTITION BY [LiabilityAccountID] ORDER BY [LiabilityAccountID],[Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance			

,'B0E6697B-3534-4C09-BE0A-04473401AB93' CretaedBy
,GETDATE() CretaedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdateBy
,GETDATE() as UpdateDate
,'LiabilityCalculator' as Flag
from(
Select  
@equityAccountID as ParentID
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID] 
,(Select e.accountid from cre.debt e inner join core.account acc on acc.accountid = e.accountid where acc.name = [financing facility]) as [LiabilityAccountID]
,te.[Date]
,te.[Transaction] as Amount
,(CASE WHEN ROUND(([Transaction]),2)  >= 0 THEN 'SublineAdvance' ELSE 'SublinePaydown' END) as [TransactionType]


from [dbo].[Lib_11Trans] te
where [financing facility] in (Select Distinct [Financing Facility] from [dbo].[Lib_11Trans] Where [Financing Facility] <> '' and [Transaction Type] in ('Repo','Sale','NoN')) ---( 'MS Repo','WF Repo')
and [Date] <= @cutoffdate
)a
group by ParentID	
,AnalysisID	
,LiabilityAccountID	
,[Date]	
,TransactionType


UNION ALL

-----Unallocated Cash
Select  
@equityAccountID as ParentID
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID] 
,@PortfolioEquityAccountID as [LiabilityAccountID]
,te.[Date]
,te.[Transaction] as Amount
,'EquityCashDeposite'  as [TransactionType]
,null AS AccumaltedEndingBalance			
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'LiabilityCalculator' as Flag
From(
	Select Distinct [Date],ROUND([Unallocated Equity],4) as [Transaction]
	from  [dbo].[Lib_11Trans]
	Where [Transaction Type] = 'Equity'
	and [Date] <= @cutoffdate
)te


UNION ALL


Select  
@equityAccountID as ParentID
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID] 
,@PortfolioSublineAccountID as [LiabilityAccountID]
,te.[Date]
,te.[Transaction] as Amount
,'SublineCashDeposite'  as [TransactionType]
,null AS AccumaltedEndingBalance			
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'LiabilityCalculator' as Flag
From(
	Select Distinct [Date],ROUND([Unallocated Subline],4) as [Transaction]
	from  [dbo].[Lib_11Trans]
	Where [Transaction Type] = 'Subline'
	and [Date] <= @cutoffdate
)te



END