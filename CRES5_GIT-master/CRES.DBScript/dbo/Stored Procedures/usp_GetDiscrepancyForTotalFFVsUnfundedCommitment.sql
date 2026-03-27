CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForTotalFFVsUnfundedCommitment]   
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
  
declare @tblunfundedComm as Table  
(  
 NoteID UNIQUEIDENTIFIER,  
 RemainingUnfundedCommitment decimal(28,15)    
)  
  
insert INTO @tblunfundedComm (NoteID,RemainingUnfundedCommitment)  
  
Select noteid,RemainingUnfundedCommitment from(      
    
 Select n.noteid,RemainingUnfundedCommitment ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno      
 from cre.NotePeriodicCalc nc  
 Inner join core.account acc on acc.accountid = nc.AccountID
 Inner join cre.note n on n.account_accountid = acc.accountid
 inner join cre.deal d on d.DealID = n.DealID  
 where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     and acc.AccounttypeID = 1   
 and nc.RemainingUnfundedCommitment is not null       
 and nc.PeriodEndDate <= Cast(getdate() as Date)    
 and n.ActualPayoffDate is null   
 and d.[Status]= 323  
 and d.DealName NOT LIKE '%copy%'
)a where rno = 1    

---------------------------------

declare @tblFF as Table  
(  
 NoteID UNIQUEIDENTIFIER,  
 FundingAmount decimal(28,15)    
)  
  
insert INTO @tblFF (NoteID,FundingAmount)  

Select n.noteid ,CAST(ROUND(ISNULL(SUM(fs.Value),0),2) as decimal(28,2))  as FundingAmount    
from [CORE].FundingSchedule fs  
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
INNER JOIN   
(    
	Select   
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
	from [CORE].[Event] eve  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
	and acc.IsDeleted = 0  
	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
	GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
) sEvent  
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  
left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
Inner Join cre.deal d on d.dealid = n.dealid  
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0  
and fs.Value > 0  
and fs.Date > CAST(getdate() as date)  
and n.ActualPayoffDate is null
and d.[Status] = 323
and  d.DealName NOT LIKE '%copy%'
and iSNULL(fs.AdjustmentType,836) <> 834  ---Exclude Non-Commitment Adjustment
Group by n.noteid 

-------------------------

Select [Deal Name],[Deal ID],[Note ID],[Note Name],[Financing Source],FundingAmount,RemainingUnfundedCommitment, (FundingAmount - RemainingUnfundedCommitment) as Delta  
From( 

	Select d.dealname as [Deal Name]  
	,d.credealid as [Deal ID]  
	,n.Crenoteid as [Note ID]  
	,acc.name as [Note Name]   
	,lFinancingSource.FinancingSourceName as [Financing Source]  
	,CAST(ROUND(ISNULL(fs.FundingAmount,0),2) as decimal(28,2))  as FundingAmount  
	,CAST(ROUND(ISNULL(tblUnfundComm.RemainingUnfundedCommitment,0),2) as decimal(28,2))  as RemainingUnfundedCommitment

	from cre.Note n
	Inner join core.account acc on acc.accountid =n.account_accountid
	inner join cre.deal d on d.dealid = n.dealid
	Left Join cre.FinancingSourceMaster lFinancingSource on lFinancingSource.FinancingSourceMasterID = n.FinancingSourceID  
	Left Join @tblFF fs on fs.NoteID =n.noteid
	Left Join @tblunfundedComm tblUnfundComm on tblUnfundComm.NoteID =n.noteid

	where acc.isdeleted <> 1
	and n.ActualPayoffDate is null
	and lFinancingSource.FinancingSourceName not in ('Co-Fund','3rd Party Owned')
	and d.[Status] = 323
	and d.DealName NOT LIKE '%copy%'
)a  
where ABS(FundingAmount - RemainingUnfundedCommitment) > 1
ORDER BY [Deal Name],[Deal ID],[Note ID]  
  
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
END