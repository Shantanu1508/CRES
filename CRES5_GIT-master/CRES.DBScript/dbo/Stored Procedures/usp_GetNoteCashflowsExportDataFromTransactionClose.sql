
 
--[dbo].[usp_GetNoteCashflowsExportDataFromTransactionClose] '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','C10F3372-0FC2-4861-A9F5-148F1F80804F', 'CCDAD439-C996-45DE-81B6-0CA928079AA8'


CREATE PROCEDURE [dbo].[usp_GetNoteCashflowsExportDataFromTransactionClose] 

@NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@ScenarioId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@tagMasterID UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
 
AS
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
	UNION ALL
	Select 'ManagementFee' as TransType
)a


----===============================================================
--IF OBJECT_ID('tempdb..[#FeeNameMaster]') IS NOT NULL                                         
-- DROP TABLE [#FeeNameMaster]  

--Create table [#FeeNameMaster]
--(     
--	FeeName	nvarchar(255),
--	FeeNameDownload    nvarchar(255),                          
--)  

--INSERT INTO [#FeeNameMaster](FeeName,FeeNameDownload)
--Select Distinct FeeName ,
--(Select ISNULL(l.name,te.FeeName) from cre.FeeSchedulesConfig fc 
--left join core.lookup l on l.lookupid = fc.FeeNameTransID 
--where CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeName,' ','')) = 1) as FeeNameDownload

--from  CRE.TransactionEntry te 
--inner join Cre.Note n on n.NoteID=te.NoteID
--inner join core.Account acc on acc.AccountID=n.Account_AccountID
--left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
--where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
--AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
--AND acc.IsDeleted=0
--AND te.AnalysisID = @ScenarioId
--AND Feename is not null
----===============================================================
--SELECT @ScenarioId



CREATE TABLE #tmpTransactionEntryClose(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	NoteID UNIQUEIDENTIFIER,
	--AnalysisID UNIQUEIDENTIFIER,
	--TagMasterID UNIQUEIDENTIFIER,
	[Date] DATETIME NULL,
	Amount DECIMAL(28,15) NULL,
	[Type] NVARCHAR(500),
	TransactionDateByRule date null,
	TransactionDateServicingLog date null,
	IsFeeTransaction bit null,
	RemitDate date null,
	[FeeName] VARCHAR(500),
	[Comment] nVARCHAR(max),
	PurposeType nvarchar(256),
	Mst_Cash_NonCash nVARCHAR(256),
	manual_Cash_NonCash nVARCHAR(256),
	tr_Cash_NonCash nVARCHAR(256)
)


INSERT INTO #tmpTransactionEntryClose(NoteID, [Date], Amount, [Type],TransactionDateByRule,TransactionDateServicingLog,IsFeeTransaction,RemitDate,[FeeName],[Comment],PurposeType,Mst_Cash_NonCash,manual_Cash_NonCash,tr_Cash_NonCash)  --
SELECT 
te.NoteID,
te.[Date],
te.Amount ,
te.[Type] ,
TransactionDateByRule,
TransactionDateServicingLog,
(CASE
		WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(te.[Type],' ','')) = 1) > 0 THEN 1
		ELSE 0 END
) as IsFeeTransaction,
te.RemitDate,
te.FeeName,
te.Comment,
te.PurposeType,
tym.Cash_NonCash as Mst_Cash_NonCash,
te.Cash_NonCash as manual_Cash_NonCash,
te.Cash_NonCash as tr_Cash_NonCash

FROm CRE.TransactionEntryClose te 
left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])

where TagMasterID = @tagMasterID
--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
and tym.IncludeCashflowDownload = 3
--=======================================================================


Select Noteid,NoteName,
(CASE WHEN IsFeeTransaction = 1 THEN LEFT(CONVERT(VARCHAR, ISNULL(TransactionDateByRule,TransDate), 101), 10) 
		ELSE LEFT(CONVERT(VARCHAR, TransDate, 101), 10)
END) AS [Date],
Value,ValueType,
ISNULL(SpreadPercentage,'') [Spread], -- [Cash Interest Spread ], --[Rate Or Spread %] 
--ISNULL(PIKInterestPercentage,'') [Additional PIK Spread], --[PIK Interest %],
ISNULL(LIBORPercentage,'') as [Index Value], -- [Index %],
ISNULL(LEFT(CONVERT(VARCHAR,TransactionDateServicingLog, 101), 10),'') as [Transaction Date],
ISNULL(LEFT(CONVERT(VARCHAR,TransDate, 101), 10),'') as [Due Date],
ISNULL(LEFT(CONVERT(VARCHAR,RemitDate, 101), 10),'') as [Remit Date],
ISNULL(FeeName,'') as [Fee Name],
ISNULL(Comment,'') as [Description],

tr_Cash_NonCash as [Cash / Non Cash]

--(CASE WHEN EnableM61Calculations = 3 THEN 
--		(CASE WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
--		WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value < 0 THEN 'Funding'
--		WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value > 0 THEN 'Repayment'
--		ELSE Mst_Cash_NonCash END
--		)
--	ELSE
--		(CASE WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is not null) THEN manual_Cash_NonCash
--		WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value < 0) THEN 'Funding'
--		WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value > 0) THEN 'Repayment'
--		ELSE Mst_Cash_NonCash END
--		)
--	END
--) as [Cash / Non Cash]

from
(
	select 
	n.CRENoteID Noteid,
	acc.Name NoteName,
	te.[Date] AS [TransDate],
	te.Amount Value,
	te.[Type] ValueType,
	(case 
	when te.[Type] = 'InterestPaid' then Cast(tblTr.LIBORPercentage  as nvarchar(256))
	when te.[Type] = 'StubInterest' then Cast(n.InitialIndexValueOverride  as nvarchar(256))
	when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
	else null end) as LIBORPercentage,
	(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as nvarchar(256)) else '' end) as PIKInterestPercentage,
	(case 
		when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
		when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))  
		else null 
		end
	) as SpreadPercentage,
	TransactionDateByRule,
	TransactionDateServicingLog,
	IsFeeTransaction,
	te.RemitDate,
	te.FeeName,
	te.Comment,
	te.PurposeType,
	n.EnableM61Calculations,
	te.Mst_Cash_NonCash,
	te.manual_Cash_NonCash,
	te.tr_Cash_NonCash
	from #tmpTransactionEntryClose te
	inner join Cre.Note n on n.NoteID=te.NoteID
	inner join core.Account acc on acc.AccountID=n.Account_AccountID
	LEFT JOIN
	(
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage
		from(
			select 
			te.Noteid,
			te.[Date] ,
			te.Amount,
			te.[Type] ValueType
			from  #tmpTransactionEntryClose te 			
			where te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
		)a
		PIVOT (
		SUM(Amount)
		FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
		) pvt

	)tblTr on tblTr.noteid = te.noteid and tblTr.[Date] = te.[Date]
	where  te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')

)a
order by a.NoteID,Transdate  asc


DROP TABLE #tmpTransactionEntryClose
	 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
END
