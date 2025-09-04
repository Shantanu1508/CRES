

CREATE PROCEDURE [DW].[usp_ImportTransactionActuals]	

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int

	Truncate table [DW].[TransactionActuals]
	
	INSERT INTO [DW].[TransactionActuals](
	NoteId	,
	Name	,
	DealID	,
	DealName	,
	Date	,
	DueDate	,
	RemitDate	,
	TransactionDate	,
	TransactionType	,
	CalculatedAmount	,
	ServicingAmount	,
	OverrideValue	,
	CalculateDelta	,
	Adjustment	,
	M61	,
	Servicer	,
	Ignore	,
	Exception	,
	comments	,
	SourceType	,
	UsedInCalc	,
	ActualDelta	,
	ServicerName	,
	Status	,
	OverrideReason	,
	CapitalizedInterest	,
	CashInterest	,
	BatchLogID	,
	FileName	,
	FinancingSource	,
	IndexValue,
	SpreadPercentage,
	[OriginalIndex],
	EffectiveRate,
	WatchlistStatus
	)
 
	Select 
	ac.NoteId	,
	ac.Name	,
	ac.DealID	,
	ac.DealName	,
	ac.Date	,
	ac.DueDate	,
	ac.RemitDate	,
	ac.TransactionDate	,
	ac.TransactionType	,
	ac.CalculatedAmount	,
	ac.ServicingAmount	,
	ac.OverrideValue	,
	ac.CalculateDelta	,
	ac.Adjustment	,
	ac.M61	,
	ac.Servicer	,
	ac.Ignore	,
	ac.Exception	,
	ac.comments	,
	ac.SourceType	,
	ac.UsedInCalc	,
	ac.ActualDelta	,
	ac.ServicerName	,
	ac.Status	,
	ac.OverrideReason	,
	ac.CapitalizedInterest	,
	ac.CashInterest	,
	ac.BatchLogID	,
	ac.FileName	,
	ac.FinancingSource	,
	ac.IndexValue,
	ac.SpreadPercentage,
	ac.[OriginalIndex],
	ac.EffectiveRate,
	ac.WatchlistStatus
	FROM [dbo].[vwTransactionActuals_ForImport]  ac
	



	---New logic for 'PIKInterest','PIKInterestPaid'  ---Date: 09232024
	Update  [DW].[TransactionActuals] set  [DW].[TransactionActuals].CashInterest = a.CashInterest 
	,[DW].[TransactionActuals].CapitalizedInterest = a.CapitalizedInterest
	From(
		Select t.TransactionActualsID,
		---TransactionType,CalculatedAmount,CashInterest,CapitalizedInterest,
		ISNULL((CASE WHEN TransactionType = 'PIKInterestPaid' THEN CalculatedAmount ELSE CashInterest END ) ,0) AS CashInterest, 
		ISNULL((CASE WHEN TransactionType = 'PIKInterest' THEN CalculatedAmount ELSE CapitalizedInterest END ) ,0) AS CapitalizedInterest

		from [DW].[TransactionActuals] t
		where (ISNULL(CashInterest,0) = 0 AND ISNULL(CapitalizedInterest,0) = 0)
		and TransactionType in ('PIKInterest','PIKInterestPaid')
		and (SourceType is not NULL and SourceType <> 'Modified')

	)a
	Where [DW].[TransactionActuals].TransactionActualsID = a.TransactionActualsID





	Update  [DW].[TransactionActuals] set  [DW].[TransactionActuals].PIKType = a.PIKType 
	From(

		Select distinct TransactionActualsID,
		ac.NoteId
		,ac.DueDate
		,tblpik.[StartDate]  
		,tblpik.EndDate
		,(CASE When ac.TransactionType like '%PIK%' THEN tblpik.PIKSetUp  ELSE NULL END) as PIKType
		FROM [DW].[TransactionActuals]  ac
		Left Join (
			Select n.CRENoteID, 
			e.EffectiveStartDate as EffectiveDate  
			,pik.[StartDate]  
			,pik.[EndDate] as EndDate 
			,LPIKSetUp.name as PIKSetUp
			from [CORE].PikSchedule pik  
			left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID  
			left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID  
			INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
			LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID  
			LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID  
			LEFT JOIN [CORE].[Lookup] LPIKSetUp ON LPIKSetUp.LookupID = pik.PIKSetUp  
			LEFT JOIN [CORE].[Lookup] lPIKSeparateCompounding ON pik.PIKSeparateCompounding=lPIKSeparateCompounding.LookupID 

			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
			where ISNULL(e.StatusID,1) = 1  and acc.IsDeleted = 0
			and (pik.[StartDate]  is not null OR pik.[EndDate]   is not null)	

		)tblpik on tblpik.CRENoteID = ac.NoteId and ac.DueDate >= tblpik.StartDate and ac.DueDate <= DATEADD(day,1,tblpik.EndDate)
		where  ac.TransactionType like '%PIK%'	

	)a
	Where [DW].[TransactionActuals].TransactionActualsID = a.TransactionActualsID
	and [DW].[TransactionActuals].TransactionType  like '%PIK%'	




	SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportTransactionActuals - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
GO

