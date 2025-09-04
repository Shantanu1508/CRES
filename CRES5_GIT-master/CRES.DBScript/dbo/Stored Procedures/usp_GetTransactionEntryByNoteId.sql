-- Procedure
-- Procedure

---[dbo].[usp_GetTransactionEntryByNoteId] '5e1f9de5-3a0e-43b4-b33b-d6b85f177b1d','C10F3372-0FC2-4861-A9F5-148F1F80804F'
CREATE Procedure [dbo].[usp_GetTransactionEntryByNoteId]
(
 @NoteId uniqueidentifier,
 @ScenarioId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @tblTranType as Table(
TransType nvarchar(256)
)

INSERT INTO @tblTranType(TransType)
Select TransType from(
	Select [Name] as TransType from core.Lookup where ParentID = 94
	UNION ALL
	Select 'InterestPaid' as TransType
	UNION ALL
	Select 'FloatInterest' as TransType
	UNION ALL
	Select 'PIKInterestPaid' as TransType
)a



Select NoteID,Date,Amount,Type,
--NULLIF((ISNULL(LIBORPercentage,0) + ISNULL(PIKInterestPercentage,0) + ISNULL(SpreadPercentage,0)),0) as Total,
LIBORPercentage,PIKInterestPercentage,
SpreadPercentage,FeeName,TransactionDateByRule,
DueDate,RemitDate,TransactionCategory,Comment ,[AdjustmentType],AllInCouponRate,RawIndexPercentage,AccountingCloseDate,nuLLIF(PurposeType,'0') as PurposeType
From
(
	Select 
	n.NoteID, 
	--ISNULL(TransactionDateByRule,tt.Date) as Date,
	(CASE WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(tt.[Type],' ','')) = 1) > 0 
		THEN ISNULL(TransactionDateByRule,tt.[Date])
		ELSE tt.[Date]
	END) AS [Date],

	tt.Amount,
	tt.Type,	
	IndexValue as LIBORPercentage,
	NULL as PIKInterestPercentage,
	--(case when tt.[Type] = 'PIKInterest' then tblTr.PIKInterestPercentage else null end) as PIKInterestPercentage,

	SpreadValue as SpreadPercentage,

	FeeName,
	tt.TransactionDateServicingLog as TransactionDateByRule,
	tt.[Date] as DueDate,
	tt.RemitDate as RemitDate,
	tym.TransactionCategory,
	tt.comment,
	tt.[AdjustmentType],	
	tt.AllInCouponRate,
	OriginalIndex as RawIndexPercentage	,

	tt.accountingclosedate as AccountingCloseDate,
	tt.PurposeType
	from cre.transactionentry tt
	Inner Join core.account acc on acc.accountid = tt.accountid
	Inner join cre.note n on n.account_accountid = acc.AccountID
	/*LEFT JOIN
	(
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage
		from(
			select 
			n.Noteid,
			te.[Date] ,
			te.Amount,
			te.[Type] ValueType
			from  CRE.TransactionEntry te
			Inner Join core.account acc on acc.accountid = te.accountid
			Inner join cre.note n on n.account_accountid = acc.AccountID
			where te.analysisID= @ScenarioId and acc.accounttypeid = 1
			and n.NoteID=@NoteId
			AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
		)a
		PIVOT (
		SUM(Amount)
		FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
		) pvt

	)tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = tt.[Date]	
	*/
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(tt.[Type])

	where tt.analysisID= @ScenarioId and n.NoteID=@NoteId and acc.accounttypeid = 1
	AND tt.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
	
	
)a

order by a.[Date]  asc,a.Type


--spread/Rate
--	Interest Paid/ Stub Interest - (tran type = LIBORPercentage)	
--	PIKInterest/ PIKInterestPaid - (tran type =  PIKLiborPercentage)
 
--Original Index
--	Interest Paid - (tran type = RawIndexPercentage)
--	PIKInterest/ PIKInterestPaid - (tran type =  RawPIKIndexPercentage)
 
--Index Value
--	Interest Paid - (tran type = LIBORPercentage)
--	Stub Interest - (InitialIndexValueOverride for floting rate notes)
--	PIKInterest - (tran type =  PIKLiborPercentage)
--	PIKInterestPaid - (tran type =  PIKLiborPercentage)
 
--Effective Rate
--	IntrestPaid
--	PIKPrincipalFunding
	

	END