-- View

CREATE VIEW [dbo].[vw_Recon_Final_TransactionEntry_Int_Vs_Stg_Default_vs_Default]

AS
SELECT ISNULL(Test.DealName, Stg.DealName) AS DealName,
	ISNULL(Test.CreNoteID, Stg.CreNoteID) AS NoteID,
	ISNULL(Test.NoteName, Stg.NoteName) AS NoteName,
	ISNULL(Test.DevType, Stg.stgType) AS TransactionType,
	CAST(ISNULL(Test.DevDate, stg.stgDate) AS DATE) AS TransactionDate,
	SUM(test.DevAmount) AS DevAmount,
	SUM(Stg.StgAmount) AS StgAmount,
	SUM((ISNULL(Test.DevAmount, 0)) - (ISNULL(Stg.StgAmount, 0))) AS Delta,
	ABS(SUM((ISNULL(Test.DevAmount, 0)) - (ISNULL(Stg.StgAmount, 0)))) AS ABS_Delta,
	CAST(Test.ClosingDate AS DATE) AS ClosingDate,
	CAST(Test.ActualPayoffDate AS DATE) AS ActualPayoffDate,
	ISNULL(Test.CalcEngineType, stg.CalcEngineType) AS DevCalcEngine,
	ISNULL(Test.CalcStatus, Stg.CalcStatus) AS CalcStatus,
	LastCalculatedDate_UTC,
	ISNULL(Test.DealID, Stg.CREDealID) AS DealID,
	ISNULL(DealStatus, stg.STATUS) AS DealStatus--, EnableM61Calculations  
FROM (
	SELECT CREDealID AS DealID,
		DealName,
		lds.name AS DealStatus,
		CRENoteID,
		acc.name AS NoteName,
		n.ClosingDate,
		n.ActualPayoffDate,
		cr.Calc_Status AS CalcStatus,
		cr.CalcEngineType,
		Type AS DevType,
		DATE AS DevDate,
		SUM(Amount) AS DevAmount,
		a.Name AS DevScenario,
		n.EnableM61Calculations AS EnableM61Calculations,
		LastCalculatedDate as LastCalculatedDate_UTC
	FROM Cre.TransactionEntry te
	LEFT JOIN cre.Note n ON n.Account_AccountID = te.AccountId
	INNER JOIN core.account acc ON acc.AccountID = n.Account_AccountID
	INNER JOIN core.Analysis a ON a.AnalysisID = te.AnalysisID
	INNER JOIN cre.Deal d ON d.dealid = n.DealID
	LEFT JOIN core.lookup lds ON lds.lookupid = d.STATUS
	LEFT JOIN (
		SELECT Accountid,
			l.name AS [Calc_Status],
			leng.name AS CalcEngineType,
			EndTime AS LastCalculatedDate
		FROM core.CalculationRequests cr
		LEFT JOIN core.Lookup l ON l.LookupID = cr.StatusID
		LEFT JOIN core.Lookup leng ON leng.LookupID = cr.CalcEngineType
		WHERE cr.AnalysisID = 'c10f3372-0fc2-4861-a9f5-148f1f80804f'
		) cr ON cr.AccountId = n.Account_AccountID
	WHERE acc.isdeleted <> 1
		AND d.IsDeleted <> 1
		AND n.EnableM61Calculations = 3
		AND te.AnalysisID = 'c10f3372-0fc2-4861-a9f5-148f1f80804f' ---and CRENoteID = '10640'   
	GROUP BY NoteID,
		Type,
		DATE,
		te.AnalysisID,
		a.Name,
		CREDealID,
		DealName,
		CRENoteID,
		acc.name,
		cr.Calc_Status,
		cr.CalcEngineType,
		n.ClosingDate,
		n.ActualPayoffDate,
		lds.name,
		EnableM61Calculations,
		LastCalculatedDate
	) Test
FULL OUTER JOIN (
	SELECT d.credealid,
		d.dealname,
		acc.name AS NoteName,
		l.Name AS STATUS,
		n.CreNoteID AS CreNoteID,
		DATE AS StgDate,
		SUM(Amount) AS StgAmount,
		Type AS StgType,
		a.Name AS StgScenario,
		lcr.Name AS CalcEngineType,
		lsts.Name AS CalcStatus
	FROM Dw.Staging_TransactionEntry ste
	INNER JOIN cre.note n ON n.crenoteid = ste.crenoteid
	INNER JOIN cre.deal d ON d.dealid = n.dealid
	INNER JOIN core.account acc ON acc.accountid = n.Account_AccountID
	INNER JOIN core.lookup l ON l.LookupID = d.STATUS
	INNER JOIN core.Analysis a ON a.AnalysisID = ste.AnalysisID
	LEFT JOIN core.CalculationRequests cr ON cr.AccountId = n.Account_AccountID
		AND cr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	LEFT JOIN core.lookup lcr ON lcr.LookupID = cr.CalcEngineType
	LEFT JOIN core.lookup lsts ON lsts.LookupID = cr.StatusID
	WHERE ste.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		AND n.EnableM61Calculations = 3
	GROUP BY d.credealid,
		d.dealname,
		acc.name,
		l.Name,
		n.CreNoteID,
		DATE,
		Type,
		a.Name,
		lcr.Name,
		lsts.Name
	) stg ON Test.CRENoteID = Stg.CreNoteID
	AND Test.devDate = Stg.stgDate
	AND Test.DevType = Stg.stgType
WHERE ABS(ISNULL(Test.DevAmount, 0) - ISNULL(Stg.StgAmount, 0)) > 0.01
	AND Test.DealName NOT LIKE ('%Copy')
--and test.CalcEngineType = 'V1 (New)'   
--and DealID='20-1525'   
--and ISNULL(Test.CreNoteID,Stg.CreNoteID)='24824'  
GROUP BY ISNULL(Test.DealID, Stg.CREDealID),
	ISNULL(Test.DealName, Stg.DealName),
	ISNULL(DealStatus, stg.STATUS),
	ISNULL(Test.CreNoteID, Stg.CreNoteID),
	ISNULL(Test.NoteName, Stg.NoteName),
	ISNULL(Test.DevDate, stg.stgDate),
	ISNULL(Test.DevType, Stg.stgType),
	Test.ClosingDate,
	Test.ActualPayoffDate,
	ISNULL(Test.CalcStatus, Stg.CalcStatus),
	ISNULL(Test.CalcEngineType, stg.CalcEngineType),
	EnableM61Calculations,
	Test.DevDate,
	stg.stgDate,
	LastCalculatedDate_UTC
	--Order By ISNULL(Test.DealName,Stg.DealName),ISNULL(Test.CreNoteID,Stg.CreNoteID), ISNULL(Test.DevDate,Stg.stgDate), ISNULL(Test.DevType,Stg.stgType)  