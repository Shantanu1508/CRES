-- Procedure

CREATE PROCEDURE [DW].[usp_ImportNPCEndingBalanceDefaultScenario]
AS
BEGIN
	Truncate Table [DW].[NPCEndingBalanceDefaultScenario]

	INSERT INTO [DW].[NPCEndingBalanceDefaultScenario](AnalysisID,NoteID,EndingBalance,PeriodEndDate)
	select Distinct nc.AnalysisID,n.crenoteid as Noteid,nc.endingbalance,nc.date as periodenddate   
	from cre.[DailyInterestAccruals]   nc
	Inner join cre.note n on n.noteid = nc.noteid
	where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and nc.noteid in (
		Select Distinct n.noteid 
		from dw.liabilitynotebi ln
		Inner join cre.note n on n.dealid =ln.dealid
	)
END
GO

