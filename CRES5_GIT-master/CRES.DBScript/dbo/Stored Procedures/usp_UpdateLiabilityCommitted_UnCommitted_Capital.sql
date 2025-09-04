  
CREATE PROCEDURE [dbo].[usp_UpdateLiabilityCommitted_UnCommitted_Capital]  
	@EquityAccountID UNIQUEIDENTIFIER = null
AS  
BEGIN  
 SET NOCOUNT ON;  
  
Declare @fundAccountID UNIQUEIDENTIFIER  
Declare @CapitalReserveRequirement decimal(28,15)  
Declare @ReserveRequirement decimal(28,15)  
  
  
    
  
Select @fundAccountID = eq.accountid ,@CapitalReserveRequirement = CapitalReserveRequirement  ,@ReserveRequirement = ReserveRequirement
from cre.equity eq  
Inner join core.account acc on acc.accountid = eq.Accountid  
where eq.AccountID = @EquityAccountID

---acc.[name] = 'ACORE Credit Partners II'  
  

Declare @tblliabilityNoteAccountID as table(
	liabilityNoteAccountID UNIQUEIDENTIFIER
)

INSERT INTO @tblliabilityNoteAccountID(liabilityNoteAccountID)

SELECT Distinct ln.AccountID
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @fundAccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
where a.IsDeleted <> 1


  
Declare @CalcAsOfDate date  
SET @CalcAsOfDate = ISNULL((Select Dateadd(day,1,MAX(TransactionDate)) from CRE.LiabilityFundingScheduleAggregate where AccountID in (  
 Select distinct ln.LiabilitytypeID  
 from cre.LiabilityNote ln    
 Inner Join core.Account acc on acc.AccountID = ln.AccountID    
 Where acc.IsDeleted <> 1    
 and ln.AccountID in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)
 and ln.AssetAccountID  in (  
  Select ln.AssetAccountID  
  from cre.LiabilityNote ln    
  Inner Join core.Account acc on acc.AccountID = ln.AccountID    
  Where acc.IsDeleted <> 1    
  and ln.LiabilityTypeID  = @fundAccountID   
 )  
)  
),getdate())  
  
  
Declare @InvestorCapital decimal(28,15) = (Select SUM(Commitment) from [CRE].[LiabilityInvestor] where AccountID = @fundAccountID)  

Update cre.equity set InvestorCapital = @InvestorCapital where AccountID = @fundAccountID
  
  
Declare @tblDealTargetAdvanceRate as Table(  
DealAccountID UNIQUEIDENTIFIER,  
TargetAdvanceRate decimal(28,15),  
CategoryName nvarchar(256)  
)  
  
INSERT INTO @tblDealTargetAdvanceRate(DealAccountID,TargetAdvanceRate,CategoryName)  
Select DealAccountID,ROUND(TargetAdvanceRate,2) as TargetAdvanceRate,CategoryName  
from(  
Select d.dealname,ln.DealAccountID  
,tblLibtype.Text as LiabilityTypeText  
,tblLibtype.Type as LiabilityType  
,gsetupLia.TargetAdvanceRate  
,tblLibtype.CategoryName  
from cre.LiabilityNote ln  
Inner join cre.deal d on d.AccountID = ln.DealAccountID  
Inner Join core.Account acc on acc.AccountID = ln.AccountID  
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID  
Left Join(  
 Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type],acat.Name as CategoryName  
 from cre.Debt d   
 Inner Join core.Account acc on acc.AccountID =  d.AccountID   
 Inner join core.AccountCategory acat on acat.AccountCategoryID = acc.AccountTypeID  
 where IsDeleted<> 1  
 UNION ALL  
 Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type],acat.Name as CategoryName  
 from cre.Equity d   
 Inner Join core.Account acc on acc.AccountID =  d.AccountID   
 Inner join core.AccountCategory acat on acat.AccountCategoryID = acc.AccountTypeID  
 where IsDeleted<> 1  
 UNION ALL  
 Select acc.AccountID as AccountID,acc.name as [Text] ,'cash' as [Type],acat.Name as CategoryName  
 from cre.cash d   
 Inner Join core.Account acc on acc.AccountID =  d.AccountID   
 Inner join core.AccountCategory acat on acat.AccountCategoryID = acc.AccountTypeID  
 where IsDeleted<> 1  
  
)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
left Join (  
 Select acc.AccountID,e.EffectiveStartDate,PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate  
 from [CORE].GeneralSetupDetailsLiabilityNote gslia  
 INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId  
 INNER JOIN   
 (        
  Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
  from [CORE].[Event] eve   
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
  where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsLiabilityNote')  
  and acc.IsDeleted <> 1  
  and eve.StatusID = 1  
  GROUP BY eve.AccountID,EventTypeID,eve.StatusID  
  
 ) sEvent  
 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 where e.StatusID = 1 and acc.IsDeleted <> 1  
)gsetupLia on gsetupLia.AccountID = ln.AccountID  
  
Where acc.IsDeleted <> 1  
and DealAccountID in (Select Distinct ln.DealAccountID from cre.liabilitynote ln where LiabilityTypeId = @fundAccountID)  
and ln.AccountID in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)
and ISNULL(tblLibtype.CategoryName,'a') not in ('Subline','Fund','Cash')  
)a  
-----=============================  
  
  
Declare @tbldata as Table(  
fundAccountID UNIQUEIDENTIFIER,  
InvestorCapital    decimal(28,15),  
CommittedCapital   decimal(28,15),  
RepoReserved decimal(28,15),  
CapitalReserve decimal(28,15),  
UncommittedCapital decimal(28,15)  
)  
  
INSERT INTO @tbldata(fundAccountID,InvestorCapital,CommittedCapital,RepoReserved,CapitalReserve,UncommittedCapital)  
  
Select fundAccountID  
,InvestorCapital  
,CommittedCapital  
,RepoReserved  
,CapitalReserve  
,(ROUND(@InvestorCapital,0) - CommittedCapital - @ReserveRequirement - CapitalReserve) [UncommittedCapital]  
From(  
 Select fundAccountID  
 ,ROUND(@InvestorCapital,0) as InvestorCapital  
 ,SUM(Equity) as CommittedCapital   
 ,@ReserveRequirement as RepoReserved  
 ,@CapitalReserveRequirement as CapitalReserveRequirement  
 ,(ROUND(@InvestorCapital,0) * @CapitalReserveRequirement - @ReserveRequirement)  as CapitalReserve  
 From(  
  
  
  Select fundAccountID
  ,DealName
  ,[Source]
  ,AdvanceRate
  ,LoanAmount
  ,PIK
  ,Debt
  ,(LoanAmount + PIK - Debt) Equity    
  From(     
	Select fundAccountID	
	,DealName	
	,[Source]	
	,AdvanceRate	
	,SUM(LoanAmount) as LoanAmount  	
	,SUM(PIK) as PIK	
	,ROUND((CASE WHEN ISNULL([Source],'Whole Loan') in ('Whole Loan','Sub Debt','Sale') THEN 0 ELSE (AdvanceRate * (SUM(LoanAmount))) END),0) as Debt		
	From(
		Select @fundAccountID  as fundAccountID   
		,DealName  
		,CategoryName as [Source]  
		,TargetAdvanceRate as AdvanceRate  
		,ROUND((AdjustedTotalCommitment),0)  as LoanAmount  
		,ROUND((SUM(PIKBalance)) *-1 ,0) as PIK  
		--,ROUND((CASE WHEN CategoryName IS NULL THEN 0 ELSE (TargetAdvanceRate * (AdjustedTotalCommitment)) END),0) as Debt  
		from(  
			Select d.dealname   
			,n.CRENoteID  
			,dadv.CategoryName  
			,ISNULL(dadv.TargetAdvanceRate,0) as TargetAdvanceRate  
			,ISNULL(tblCommAdj.NoteAdjustedTotalCommitment,0) as AdjustedTotalCommitment  
			,ISNULL(tblPIK.SumPikAmount ,0) as PIKBalance  
			from cre.note n   
			Left Join cre.deal d on d.dealid = n.dealid  
			left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID =n.FinancingSourceID  
			Left Join (  
				Select NoteID,NoteAdjustedTotalCommitment  
				From(     
				SELECT n.noteid, d.CREDealID  
				,n.CRENoteID  
				,Date as Date  
				,nd.Type as Type  
				,NoteAdjustedTotalCommitment  
				,NoteTotalCommitment   
				,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,  
				nd.Rowno  
				from cre.NoteAdjustedCommitmentMaster nm  
				left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID  
				right join cre.deal d on d.DealID=nm.DealID  
				Right join cre.note n on n.NoteID = nd.NoteID  
				inner join core.account acc on acc.AccountID = n.Account_AccountID  
				where d.IsDeleted<>1 and acc.IsDeleted<>1   
				and [date]  < @CalcAsOfDate  
				)a  
				where rno =  1  
			)tblCommAdj on tblCommAdj.noteid = n.noteid  
			left join(  
				Select n.noteid,SUM(tr.Amount) as SumPikAmount  
				from cre.transactionEntry Tr  
				Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID  
				Inner join cre.note n on n.Account_AccountID = acc.AccountID  
				where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')  
				and tr.date < CAST(@CalcAsOfDate as date)  
				and acc.AccounttypeID = 1  
				group by n.noteid  
			)tblPIK on tblPIK.noteid = n.noteid  
			Left join @tblDealTargetAdvanceRate dadv on dadv.DealAccountID = d.AccountID  
			where n.Account_AccountID in (  
				Select lm.AssetAccountId from cre.liabilitynote ln  
				Inner join cre.LiabilityNoteAssetMapping lm on lm.liabilitynoteAccountID = ln.Accountid  
				where LiabilityTypeId = @fundAccountID  
			)  
			and n.ActualPayoffDate is null
  
		)y  
		Where ROUND(y.AdjustedTotalCommitment,0) <> 0
		Group by y.dealname,TargetAdvanceRate,CategoryName  ,y.AdjustedTotalCommitment
	)c
	Group by fundAccountID,DealName,[Source],AdvanceRate		
   
  )a  
  




  
 )z  
 Group by z.fundAccountID  
  
)b  
  
  
Update cre.equity set InvestorCapital = @InvestorCapital,cre.equity.CommittedCapital =a.CommittedCapital,cre.equity.CapitalReserve = a.CapitalReserve ,cre.equity.UncommittedCapital =a.UncommittedCapital  
From(  
	Select fundAccountID,InvestorCapital,CommittedCapital,RepoReserved,CapitalReserve,UncommittedCapital from @tbldata  
)a  
where cre.equity.accountid = a.fundAccountID  
  
  
END