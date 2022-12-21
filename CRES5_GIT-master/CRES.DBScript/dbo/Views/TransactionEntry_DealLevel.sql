
CREATE View [dbo].[TransactionEntry_DealLevel]
AS

		SELECT 
			
			DATE
			, Dealid 
			,SUM(Amount)Amount

			,AnalysisID

			,
			--ExitFee = Case when type like 'Exit%' Then Amount End,
			Scenario

			,T.DealName
			,T. Dealkey
		


		FROM [TransactionEntry] T
		where Scenario = 'Default' and type like'Exit%' 
		Group by DealName,DealID,AnalysisID,Scenario,Date,Dealid,Dealkey