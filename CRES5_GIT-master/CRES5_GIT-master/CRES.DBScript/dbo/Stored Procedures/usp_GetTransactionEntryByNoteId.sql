CREATE Procedure [dbo].[usp_GetTransactionEntryByNoteId] --'7ADE7167-8605-4766-8083-9886C38BDB98','C10F3372-0FC2-4861-A9F5-148F1F80804F'
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
LIBORPercentage,PIKInterestPercentage,SpreadPercentage,FeeName,TransactionDateByRule,
DueDate,RemitDate,TransactionCategory,Comment 
From
(
	Select 
	tt.NoteID, 
	--ISNULL(TransactionDateByRule,tt.Date) as Date,
	(CASE WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(tt.[Type],' ','')) = 1) > 0 
		THEN ISNULL(TransactionDateByRule,tt.[Date])
		ELSE tt.[Date]
	END) AS [Date],

	tt.Amount,
	tt.Type,	
	(case 
	when tt.[Type] = 'InterestPaid' then tblTr.LIBORPercentage 
	when tt.[Type] = 'StubInterest' then n.InitialIndexValueOverride --n.StubInterestRateOverride 
	when tt.[Type] in ('PIKInterest','PIKInterestPaid') then tblTr.PIKLiborPercentage  
	else null end) as LIBORPercentage,

	(case when tt.[Type] = 'PIKInterest' then tblTr.PIKInterestPercentage else null end) as PIKInterestPercentage,

	(case 
		when tt.[Type] in ('InterestPaid','StubInterest') then tblTr.SpreadPercentage 
		when tt.[Type] in ('PIKInterest','PIKInterestPaid') then tblTr.PIKInterestPercentage 
		else null 
		end
	) as SpreadPercentage,

	FeeName,
	tt.TransactionDateServicingLog as TransactionDateByRule,
	tt.[Date] as DueDate,
	tt.RemitDate as RemitDate,
	tym.TransactionCategory,
	tt.comment
	from cre.transactionentry tt
	LEFT JOIN
	(
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage
		from(
			select 
			te.Noteid,
			te.[Date] ,
			te.Amount,
			te.[Type] ValueType
			from  CRE.TransactionEntry te
			where te.analysisID= @ScenarioId and te.NoteID=@NoteId
			AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
		)a
		PIVOT (
		SUM(Amount)
		FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
		) pvt

	)tblTr on tblTr.noteid = tt.noteid and tblTr.[Date] = tt.[Date]
	left join cre.note n on n.noteid = tt.noteid
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(tt.[Type])

	where tt.analysisID= @ScenarioId and tt.NoteID=@NoteId
	AND tt.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
	
	
)a

order by a.[Date]  asc,a.Type
	

	END
