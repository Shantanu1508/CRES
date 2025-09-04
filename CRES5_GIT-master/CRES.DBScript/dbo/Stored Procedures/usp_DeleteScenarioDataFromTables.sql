CREATE PROCEDURE [dbo].[usp_DeleteScenarioDataFromTables]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
AS
BEGIN
	
	IF EXISTS(Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2 OR ScenarioStatus = 2)
	BEGIN	
		Delete  from cre.TransactionEntry where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2 )
		Delete  from dw.TransactionEntryBI where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)

		Delete  from cre.NotePeriodicCalc where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from dw.NotePeriodicCalcBI where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)

		Delete  from cre.DailyInterestAccruals where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from dw.DailyInterestAccrualsBI where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)

		Delete  from cre.InterestCalculator where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from dw.InterestCalculatorBI where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)

		Delete  from CORE.CalculationRequests where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from cre.DailyGAAPBasisComponents where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from cre.YieldCalcInput where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)

		Delete  from core.FeeCouponStripReceivable where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from core.CalculatorOutputJsonInfo where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from core.BatchCalculationMaster where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from cre.CalculatorStatistics where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
		Delete  from cre.DealNoteRuleTypeSetup where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)

		Delete  from dw.EventBasedBalanceBI where AnalysisID in (Select AnalysisID from core.analysis where isDeleted = 1 OR ScenarioStatus = 2)
	END

END