
CREATE PROCEDURE [DW].[usp_ImportEventBasedBalance]	
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int


Delete ncBI from [DW].[EventBasedBalanceBI] ncBI
inner join 
(
	Select Distinct NoteID,AnalysisID from [DW].[L_TransactionEntryBI]
)L on L.Noteid = ncBI.Noteid and ncBI.AnalysisID = L.AnalysisID



IF OBJECT_ID('tempdb..#tmpTransactionEntry') IS NOT NULL             
DROP TABLE #tmpTransactionEntry  

CREATE TABLE #tmpTransactionEntry(
  ID INT IDENTITY(1,1) PRIMARY KEY,
  noteid UNIQUEIDENTIFIER,
  AnalysisID UNIQUEIDENTIFIER,
  [Date] DATETIME NULL,
  Amount DECIMAL(28,15) NULL,
  [Type] NVARCHAR(500)
)

INSERT INTO #tmpTransactionEntry(NoteID, AnalysisID, [Date], Amount, [Type])
Select  tr.noteid,tr.analysisid,Date,Amount,Type		
from [DW].TransactionEntryBI 	tr
Inner JOin(
	Select Distinct NoteID,AnalysisID from [DW].[L_TransactionEntryBI]
)ltr on ltr.noteid =tr.noteid and ltr.AnalysisID =tr.AnalysisID

Where [Type] in ('FundingorRepayment', 'ScheduledPrincipalPaid') and Amount > 0

--================================================================================

--Truncate table [DW].[EventBasedBalanceBI]	

INSERT INTO [DW].[EventBasedBalanceBI]
           ([analysisid]
           ,[analysisName]
           ,[Noteid]
           ,[PeriodEndDate]
           ,[EventDate]
           ,[EndingBalance]
           ,[Amount]
           ,[EstimatedEndingBalance])
Select 
N.analysisid,
N.analysisName,
N.Noteid, 
N.PeriodEndDate, 
ISnull(X.Date,N.PeriodEndDate) EventDate, 
N.EndingBalance, 
X.Amount, 
(ISNULL(EndingBalance,0) - ISNULL(Amount,0)) EstimatedEndingBalance

from [DW].[NotePeriodicCalcBI] N
Inner JOin(
	Select Distinct NoteID,AnalysisID from [DW].[L_TransactionEntryBI]
)ltr on ltr.noteid =N.noteid and ltr.AnalysisID =N.AnalysisID
outer apply (

	Select T.Date, SUM(ISNUll(T.Amount,0)) As Amount 
	from #tmpTransactionEntry T			
	Where N.Noteid =  T.noteid and Date > N.PeriodendDate and Date < EOmOnth (N.PeriodendDate, 1) 	 
	and N.analysisid =  T.analysisid 
	
	--and Type in ('FundingorRepayment', 'ScheduledPrincipalPaid')
	--and Amount >0
	
	Group by T.Noteid, Date

 )X
where PeriodEndDate <> '0001-01-31'


SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportEventBasedBalance - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


