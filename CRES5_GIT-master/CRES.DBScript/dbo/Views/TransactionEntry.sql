
CREATE View [dbo].[TransactionEntry]
AS
/*  Commented by Anurag - 02/26/2021
WITH TransactionEntryTemp
AS (
	SELECT *
	FROM (
*/
		SELECT T.NoteID AS NoteKey
			,T.CRENoteID AS NoteID
			,DATE
			,Amount
			,Type
			,T.CreatedBy
			,T.CreatedDate
			,T.UpdatedBy
			,T.UpdatedDate
			,(T.crenoteid + '_' + Type + '_' + CONVERT(VARCHAR(10), DATE, 110)) Note_Type_Date
			,T.crenoteid + '_' + CONVERT(VARCHAR(10), DATE, 110) + AnalysisName NoteID_Date_Scenario
			,AnalysisID
			,isExitFee = CASE 
				WHEN type LIKE 'Exit%'
					THEN 'Yes'
				ELSE 'No'
				END
			,n.dealid Dealkey
			--ExitFee = Case when type like 'Exit%' Then Amount End,
			,AnalysisName AS Scenario
			,FeeName
			,InitialIndexValueOverride
			,T.crenoteid + '_' + CONVERT(VARCHAR(10), DATE, 110) NoteID_Date
			,T.DealName
			,T.CreDealID AS DealID
			,N.Name AS NoteName
			,M61Commitment
			,ISNULL(TransactionDateByRule, DATE) AS TR_CashFlow_Date
			,TransactionDateServicingLog AS TR_TransactionDate
			,DATE AS TR_DueDate
			,[FinancingSourceBI]
			,ClientBI
			,N.name
			,RemitDate AS TR_RemitDate
			,T.[PaymentDateNotAdjustedforWorkingDay]
			,T.PurposeType	
			,T.Cash_NonCash
		FROM [DW].[TransactionEntryBI] T
		LEFT JOIN DW.NoteBI N ON N.Noteid = T.NoteID
			--Left join dw.dealBI d on d.dealid = n.noteid

/*		) x Commented by Anurag - 02/26/2021
	)
SELECT *
FROM TransactionEntryTemp
*/



