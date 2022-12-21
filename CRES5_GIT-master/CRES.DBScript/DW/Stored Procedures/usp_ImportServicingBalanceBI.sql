
CREATE PROCEDURE [DW].[usp_ImportServicingBalanceBI]
	
AS
BEGIN
	SET NOCOUNT ON;

truncate table DW.ServicingBalanceBI

INSERT INTO DW.ServicingBalanceBI
select N.CRENoteID as NoteID,C.ReportDate,X.EndingBalance
from DW.NoteBI N
cross join (
	select distinct PriorMonthEnd as [ReportDate]
	from dw.CalendarBI
	where Date > '06/01/2006' and Date < GETDATE()
) C
outer apply(
	SELECT TOP 1 BalanceAfterFundingTransacton as EndingBalance
	FROM DW.ServicingTransactionBI
	WHERE TransactionDate <= C.ReportDate and NoteID = N.CRENoteID
	ORDER BY TransactionDate DESC,[EntryNo] DESC
) X




END


