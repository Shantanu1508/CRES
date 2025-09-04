
--[dbo].[usp_GetAllTransactionsByNoteId] '06c6bc54-c898-4052-8228-3fc4b8075326','12/19/2018','ExitFeeStripReceivable','c10f3372-0fc2-4861-a9f5-148f1f80804f'
CREATE PROCEDURE [dbo].[usp_GetAllTransactionsByNoteId] 
(
 @NoteId varchar(100),
 @DueDate DateTime,
 @TransactionType varchar(100),
 @ScenarioId varchar(100)
 )
AS
BEGIN


Declare @tblTranType as table
( 
	trantype nvarchar(256)
)

IF(@TransactionType = 'InterestPaid' OR @TransactionType = 'FloatInterest' OR @TransactionType = 'StubInterest' OR @TransactionType = 'PurchasedInterest')
BEGIN
	INSERT INTO @tblTranType(trantype) VALUES( 'InterestPaid'),('FloatInterest'),('StubInterest'),('PurchasedInterest')
END
ELSE
BEGIN
	INSERT INTO @tblTranType(trantype) 
	Select TransactionName from cre.transactiontypes where TransactionName like '%'+@TransactionType+'%'
END
---========================================================================================================


SET @ScenarioId = (Select AnalysisID from Core.analysis where name = 'Default')

IF OBJECT_ID('tempdb..[#tblInception]') IS NOT NULL                                         
 DROP TABLE [#tblInception]

CREATE TABLE #tblInception(
CRENoteID nvarchar(256) null,
NoteID UNIQUEIDENTIFIER null, 
NoteTransactionDetailID UNIQUEIDENTIFIER null,
DueDate Date null,
TransactionDate Date null,
TransactionType  nvarchar(256) null,
ServicingAmount decimal(28,15) null,
CalculatedAmount decimal(28,15) null,
CalculatedDelta decimal(28,15) null,
OverrideValue decimal(28,15) null,
Adjustment decimal(28,15) null,
ActualDelta decimal(28,15) null,
ReconType  nvarchar(256) null
)
INSERT INTO #tblInception(CRENoteID,NoteID,NoteTransactionDetailID,DueDate,TransactionDate,TransactionType,ServicingAmount,CalculatedAmount,CalculatedDelta,OverrideValue,ReconType,Adjustment,ActualDelta)



Select CRENoteID,NoteID,NoteTransactionDetailID,DueDate,TransactionDate,TransactionType,ServicingAmount,CalculatedAmount,
Delta,

OverrideValue,ReconType,
Adjustment,  
ActualDelta
from(
	Select n.CRENoteID ,
	n.NoteID	,
	nt.NoteTransactionDetailID, 
	cast(nt.RelatedtoModeledPMTDate  as Date)as DueDate, 
	cast(nt.TransactionDate  as Date)as TransactionDate,
	nt.TransactionTypeText as TransactionType,
	nt.ServicingAmount ,
	nt.CalculatedAmount ,
	(Case
--	When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.CalculatedAmount,0)-ISNULL(nt.ServicingAmount,0)),2)
	When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(nt.CalculatedAmount,0)),2)
	When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(nt.CalculatedAmount,0),2)
	END) as Delta,
	nt.OverrideValue,
	Case 
	When (isnull(nt.M61Value,0) <> 0 ) Then 'M61'
	When (isnull(nt.ServicerValue,0) <>0 ) Then 'Servicer'
	When (isnull(nt.Ignore,0) <>0 ) Then 'Ignore'
	When (isnull(nt.OverrideValue,0) <>0 ) Then 'Override'
	END as ReconType,
	nt.Adjustment,
	nt.ActualDelta
	from cre.NoteTransactionDetail nt
	left join cre.note n on n.NoteID=nt.NoteID
	where 	nt.NoteID=@NoteId 
	and nt.[TransactionTypeText] in (select trantype from @tblTranType)
	

	--where 	(nt.[TransactionTypeText] like '%'+@TransactionType+'%' or nt.[TransactionTypeText]  in ('PurchasedInterest','StubInterest'))
	--and nt.NoteID=@NoteId 
	--and  IIF(@TransactionType like '%interestpaid%' ,1 ,(CASE WHEN nt.[TransactionTypeText] in ('PurchasedInterest','StubInterest') THEN 0 ELSE 1 END) ) = 1
	

	UNION ALL

	Select n.CRENoteID ,
	n.NoteID	,
	'00000000-0000-0000-0000-000000000000' as NoteTransactionDetailID, 
	cast(nt.Date as Date) as DueDate, 
	cast(nt.Date as Date) as TransactionDate, 	
	nt.[Type] as TransactionType,

	null as ServicingAmount ,
	nt.Amount as CalculatedAmount ,
	null as Delta,
	null as OverrideValue,
	'M61' as ReconType,
	null Adjustment,
	null ActualDelta

	from cre.TransactionEntry nt
	Inner Join core.account acc on acc.accountid = nt.accountid
	Inner join cre.note n on n.account_accountid = acc.AccountID
	--left join cre.note n on n.NoteID=nt.NoteID
	
	Where n.NoteID = @NoteId and acc.AccountTypeID = 1
	and nt.AnalysisID = @ScenarioId
	and nt.[Type] in (select trantype from @tblTranType)
	and nt.Date not in (
		Select RelatedtoModeledPMTDate 
		from cre.NoteTransactionDetail ntt 
		left join cre.note n on n.NoteID=ntt.NoteID 
		where ntt.TransactionTypeText in (select trantype from @tblTranType)
		and ntt.NoteID=@NoteId
	)
	
	
	--Where 
	--(nt.[Type] like '%'+@TransactionType+'%' or nt.[Type]  in ('PurchasedInterest','StubInterest'))
	--and nt.NoteID = @NoteId
	--and nt.AnalysisID = @ScenarioId
	--and nt.Date not in (Select RelatedtoModeledPMTDate from cre.NoteTransactionDetail ntt left join cre.note n on n.NoteID=ntt.NoteID where ntt.TransactionTypeText = @TransactionType and ntt.NoteID=@NoteId)
	--and  IIF(@TransactionType like '%interestpaid%' ,1 ,(CASE WHEN nt.[Type] in ('PurchasedInterest','StubInterest') THEN 0 ELSE 1 END) ) = 1
)a
Where a.DueDate <= getdate() --@MaturityDate
order by a.DueDate



Select CRENoteID,NoteID,NoteTransactionDetailID,DueDate,TransactionDate,TransactionType,ServicingAmount,CalculatedAmount,CalculatedDelta as Delta,OverrideValue,ReconType,Adjustment,ActualDelta
from #tblInception
order by DueDate
















--Declare @InterestLookupId int = (Select lookupid from core.Lookup where  name = 'Interest Received' and parentid=39)
----Declare @PrincipalLookupId int = (Select lookupid from core.Lookup where  name = 'Principal Received' and parentid=39)

--Declare @MaturityDate Date;
--Declare @MaturityType nvarchar(256) = (select top 1 l.Name from core.Lookup  l inner join core.AnalysisParameter ap on l.lookupid=ap.MaturityScenarioOverrideID  inner join core.Analysis a on a.AnalysisID=ap.AnalysisID where a.AnalysisID = @ScenarioId )

--SET @MaturityDate = (Select 
--						(select  
--								isnull(n.ActualPayoffDate, isnull(  
--									 case when @MaturityType ='Initial or Actual Payoff Date' then n.ActualPayoffDate   
--									 when @MaturityType ='Expected Maturity Date' then n.ExpectedMaturityDate   
--									 when @MaturityType ='Extended Maturity Date #1' then n.ExtendedMaturityScenario1   
--									 when @MaturityType ='Extended Maturity Date #2' then n.ExtendedMaturityScenario2   
--									 when @MaturityType ='Extended Maturity Date #3' then n.ExtendedMaturityScenario3   
--									 when @MaturityType ='Open Prepayment Date' then n.OpenPrepaymentDate   
--									 when @MaturityType ='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,    
--										(
--											Select TOP 1 mat.[SelectedMaturityDate]  
--											 from [CORE].Maturity mat  
--											 INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--											 INNER JOIN (Select   
--											 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--											 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--											 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--											 INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID  
--											 where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
--											 and accSub.AccountID = n.Account_AccountID
--											 GROUP BY n.Account_AccountID,EventTypeID  
--											) sEvent  
--											ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
--										)  
--									)
--								) 
--						)as Maturity
--						from cre.note n 
--						where n.NoteID = @NoteId
--					)



END





