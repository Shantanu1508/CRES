-- Procedure

CREATE PROCEDURE [DW].[usp_MergeInterestCalculator]
@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

UPDATE [DW].BatchDetail
SET
BITableName = 'InterestCalculatorBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_InterestCalculatorBI'


IF EXISTS(Select top 1 NoteID from [DW].[L_InterestCalculatorBI])
BEGIN
	Delete ncBI from [DW].[InterestCalculatorBI] ncBI
	inner join 
	(
		Select Distinct NoteID,AnalysisID from [DW].[L_InterestCalculatorBI]

	)L on L.Noteid = ncBI.Noteid and ncBI.AnalysisID = L.AnalysisID




IF OBJECT_ID('tempdb..[#Note_TrPivot]') IS NOT NULL                                         
DROP TABLE [#Note_TrPivot] 

Create table [#Note_TrPivot]
(
[NoteID]	UNIQUEIDENTIFIER null,
[AnalysisID] UNIQUEIDENTIFIER null,	
[Crenoteid]	nvarchar(256) null,
[Date] Date null,
[Funding] decimal(28,15) null,	
[Repayment]	 decimal(28,15) null,
[ScheduledPrincipalPaid]	 decimal(28,15) null,
[PIKInterest]	 decimal(28,15) null,
[LIBORPercentage]	 decimal(28,15) null,
[SpreadPercentage]	 decimal(28,15) null,
[AllInOneCoupon]  decimal(28,15) null,
)
INSERT INTO [#Note_TrPivot](NoteID,AnalysisID,Crenoteid,Date,Funding,Repayment,ScheduledPrincipalPaid,PIKInterest,LIBORPercentage,SpreadPercentage,AllInOneCoupon)
Select NoteID,AnalysisID,Crenoteid,Date,Funding,Repayment,ScheduledPrincipalPaid,PIKInterest,LIBORPercentage,SpreadPercentage,(ISNULL(LIBORPercentage,0) + ISNULL(SpreadPercentage,0)) as AllInOneCoupon
	From(
		Select 	
		n.NoteID	
		,tr.AnalysisID
		,n.Crenoteid
		,tr.Date	
		,ISNULL(tr.Amount,0) as Amount
		,(CASE 
			WHEN tr.Type = 'FundingOrRepayment' and tr.Amount > 0 THEN 'Repayment' 
			WHEN tr.Type = 'FundingOrRepayment' and tr.Amount <= 0 THEN 'Funding'
			ELSE tr.Type
			END
		) as [Type]		
		
		from cre.transactionentry tr
		 Inner join core.account acc on acc.accountid = tr.AccountID
         Inner join cre.note n on n.account_accountid = acc.accountid
 
		--inner join cre.note n on n.noteid = tr.noteid
		where tr.[type] in ('LIBORPercentage','SpreadPercentage','FundingOrRepayment','ScheduledPrincipalPaid','PIKInterest')
		and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and n.noteid in (Select distinct noteid from [DW].[L_InterestCalculatorBI])
		and acc.AccounttypeID = 1
	)AS SourceTable 
	PIVOT  
	(  
		SUM(Amount)  
		FOR [Type] IN (LIBORPercentage,SpreadPercentage,Funding,Repayment,ScheduledPrincipalPaid,PIKInterest)  

	) AS PivotTable
--===============================================


	INSERT INTO [DW].[InterestCalculatorBI]
           ([InterestCalculatorID]
		   ,[InterestCalculatorAutoID]
           ,[NoteID]
           ,[CRENoteID]
           ,[AccrualStartDate]
           ,[AccrualEndDate]
           ,[PaymentDate]
           ,[BeginningBalance]
           ,[AnalysisID]
           ,[LIBOR]
           ,[Spread]
           ,[AllInOnecoupon]
           ,[EndingBalance]
           ,[Repayment]
           ,[Funding]
           ,[ScheduledPrincipal]
           ,[PikInterest]
           ,[InterestExcludePrepayDate]
           ,[InterestFullAccrual]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

SELECT 
b.[InterestCalculatorID]
,b.[InterestCalculatorAutoID]
,b.[NoteID]
,b.[CRENoteID]
,b.[AccrualStartDate]
,b.[AccrualEndDate]
,b.[PaymentDate]
,b.[BeginningBalance]
,b.[AnalysisID]
,b.[LIBOR]
,b.[Spread]
,b.[AllInOnecoupon]
,b.[EndingBalance]
,b.[Repayment]
,b.[Funding]
,b.[ScheduledPrincipal]
,b.[PikInterest]
,(b.InterestOnInterestAccrualStartDate + b.InterestOnRepayment + b.InterestOnFunding) as [InterestExcludePrepayDate]
,(b.InterestOnInterestAccrualStartDate + b.InterestOnFunding)  as [InterestFullAccrual]
,b.[CreatedBy]
,b.[CreatedDate]
,b.[UpdatedBy]
,b.[UpdatedDate]
From(
	SELECT 
	[InterestCalculatorID]
	,a.[InterestCalculatorAutoID]
	,a.[NoteID]
	,a.[CRENoteID]
	,a.[AccrualStartDate]
	,a.[AccrualEndDate]
	,a.[PaymentDate]
	,a.[BeginningBalance]
	,a.[AnalysisID]
	,a.[LIBOR]
	,a.[Spread]
	,a.[AllInOnecoupon]
	,a.[EndingBalance]
	,a.Repayment_AccrualStartEndDate as [Repayment]
	,a.Funding_AccrualStartEndDate as [Funding]
	,a.ScheduledPrincipalPaidAmount as [ScheduledPrincipal]
	,a.PIKInterestAmount as  [PikInterest]
	,a.Repayment_AccrualStartEndDate
	,a.Funding_AccrualStartEndDate
	,a.AccrualDateDiff
	,a.AllInOneCoupon_360
	,(a.[EndingBalance] * a.AllInOneCoupon_360 * (a.AccrualDateDiff + 1)) as InterestOnInterestAccrualStartDate
	,(a.Repayment_AccrualStartEndDate * a.AllInOneCoupon_360 * a.AccrualDateDiff) as InterestOnRepayment
	,(a.Funding_AccrualStartEndDate * a.AllInOneCoupon_360 * (a.AccrualDateDiff + 1)) as InterestOnFunding
	,null as [InterestExcludePrepayDate]
	,null as [InterestFullAccrual]
	,a.[CreatedBy]
	,a.[CreatedDate]
	,a.[UpdatedBy]
	,a.[UpdatedDate]
	From(

	SELECT 
	[InterestCalculatorID]
	,icalc.[InterestCalculatorAutoID]
	,icalc.[NoteID]
	,n.[CRENoteID]
	,icalc.[AccrualStartDate]
	,icalc.[AccrualEndDate]
	,icalc.[PaymentDate]
	,icalc.[BeginningBalance]
	,icalc.[AnalysisID]
	,TrEntryLibor.LIBORPercentage as [LIBOR]
	,TrEntryLibor.SpreadPercentage as [Spread]
	,TrEntryLibor.AllInOneCoupon as [AllInOnecoupon]
	
	,(ISNULL(icalc.[BeginningBalance],0) + ISNULL(TrEntryFunding.FundingAmount,0) + ISNULL(TrEntryRepayment.RepaymentAmount,0) + ISNULL(TrEntryScheduledPrincipalPaid.ScheduledPrincipalPaidAmount,0) + ISNULL(TrEntryPIKInterest.PIKInterestAmount,0)) as [EndingBalance]
	
	,TrEntryRepayment.RepaymentAmount as Repayment_AccrualStartEndDate
	,TrEntryFunding.FundingAmount as Funding_AccrualStartEndDate
	,TrEntryScheduledPrincipalPaid.ScheduledPrincipalPaidAmount
	,TrEntryPIKInterest.PIKInterestAmount

	,DAteDIFF(day,icalc.[AccrualEndDate],icalc.[AccrualStartDate]) as AccrualDateDiff
	,TrEntryLibor.AllInOneCoupon/360   as AllInOneCoupon_360
	,icalc.[CreatedBy]
	,icalc.[CreatedDate]
	,icalc.[UpdatedBy]
	,icalc.[UpdatedDate]
	FROM [cre].[InterestCalculator] icalc
	inner join dw.noteBI n on n.NoteID = icalc.NoteID
	LEFT Join [#Note_TrPivot] TrEntryLibor on icalc.[NoteID] = TrEntryLibor.NoteID and icalc.[PaymentDate] = TrEntryLibor.Date and TrEntryLibor.AnalysisID = icalc.AnalysisID
	Outer apply (
		Select 	
			tr.NoteID		
			,SUM(ISNULL(tr.Repayment,0)) as RepaymentAmount	
			from [#Note_TrPivot] tr
			inner join cre.note n on n.noteid = tr.noteid
			where n.noteid = icalc.NoteID and tr.AnalysisID = icalc.AnalysisID
			and (tr.[Date] > icalc.[AccrualStartDate]  and tr.[Date] <= icalc.[AccrualEndDate])		
			group by tr.NoteID
	)as TrEntryRepayment
	Outer apply (
		Select 	
			tr.NoteID		
			,SUM(ISNULL(tr.Funding,0)) as FundingAmount	
			from [#Note_TrPivot] tr
			inner join cre.note n on n.noteid = tr.noteid
			where n.noteid = icalc.NoteID and tr.AnalysisID = icalc.AnalysisID
			and (tr.[Date] > icalc.[AccrualStartDate]  and tr.[Date] <= icalc.[AccrualEndDate])		
			group by tr.NoteID
	)as TrEntryFunding
	Outer apply (
		Select 	
			tr.NoteID		
			,SUM(ISNULL(tr.ScheduledPrincipalPaid,0)) as ScheduledPrincipalPaidAmount	
			from [#Note_TrPivot] tr
			inner join cre.note n on n.noteid = tr.noteid
			where n.noteid = icalc.NoteID and tr.AnalysisID = icalc.AnalysisID
			and (tr.[Date] > icalc.[AccrualStartDate]  and tr.[Date] <= icalc.[AccrualEndDate])		
			group by tr.NoteID
	)as TrEntryScheduledPrincipalPaid
	Outer apply (
		Select 	
			tr.NoteID		
			,SUM(ISNULL(tr.PIKInterest,0)) as PIKInterestAmount	
			from [#Note_TrPivot] tr
			inner join cre.note n on n.noteid = tr.noteid
			where n.noteid = icalc.NoteID and tr.AnalysisID = icalc.AnalysisID
			and (tr.[Date] > icalc.[AccrualStartDate]  and tr.[Date] <= icalc.[AccrualEndDate])		
			group by tr.NoteID
	)as TrEntryPIKInterest	
	
	Where icalc.NoteID in (Select distinct noteid from [DW].[L_InterestCalculatorBI])

	)a
)b


END

DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_InterestCalculatorBI'

Print(char(9) +'usp_MergeInterestCalculatorBI - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


truncate table DW.L_InterestCalculatorBI


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


