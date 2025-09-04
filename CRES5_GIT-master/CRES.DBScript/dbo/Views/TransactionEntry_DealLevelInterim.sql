CREATE View [dbo].[TransactionEntry_DealLevelInterim]
AS

		SELECT 
			
			--DATE
			 t.Dealid 
			,SUM(t.Amount)Amount
			
			--,  ExitFeeGreaterThenToday = Case when Date > getdate() then SUM(T.Amount) end
			,AnalysisID
			,Scenario
			,T.DealName
			,T. Dealkey
		FROM [TransactionEntry] T
		inner join note n on n.noteid = T.noteid
		where Scenario = 'Default' and type like'%Exit%' 
		and Financingsource <>'3rd Party Owned' and Financingsource<>'Co-Fund'	
		and T.AccountTypeID = 1
		--and T.DealID = '19-12
		Group by DealName,T.DealID,AnalysisID,Scenario,T.Dealid,t.Dealkey