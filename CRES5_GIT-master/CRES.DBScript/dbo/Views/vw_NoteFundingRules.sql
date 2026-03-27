-- View
Create View dbo.vw_NoteFundingRules as  
SELECT   
 D.CREDealID  
 ,D.DealName  
 ,CRENoteID     
 ,a.Name NoteName    
 , n.ActualPayoffDate  
 ,ISNULL(    
  (    
    Select ISNULL(SUM(ISNULL(FS.Value,0)),0)    
    from [CORE].FundingSchedule fs    
    INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId    
    INNER JOIN    
    (    
    Select    
    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n1.Account_AccountID) AccountID ,    
    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID    
    from [CORE].[Event] eve    
    INNER JOIN [CRE].[Note] n1 ON n1.Account_AccountID = eve.AccountID and n1.noteid=n.noteid    
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n1.Account_AccountID    
    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')    
    and n1.dealid = n.dealID and acc.IsDeleted = 0    
    and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)    
    GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID    
    ) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID    
    left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID    
    left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID    
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
    where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0    
    and fs.Date = Cast(getdate() AS DATE)  
  )      
  +      
  ISNULL(  
    (select SUM((ISNULL(EndingBalance,0)))    
    from [CRE].[NotePeriodicCalc] np    
    where np.AccountID = n.Account_AccountID  --and np.DealID = n.DealID    
    and PeriodEndDate = CAST(getdate() - 1 as Date)   
    and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'),0)     
   ,0  
  ) + ISNULL(trpik.PikAmount,0)   
 as EstimatedCurrentBalance    
 ,isnull((CASE WHEN tr.SumPikAmount > 0 THEN tr.SumPikAmount ELSE (tr.SumPikAmount * -1) END),0) as CurrentPIKBalance   
 ,isnull(n.TotalCommitment,0) TotalCommitment  
 ,isnull(n.AdjustedTotalCommitment,0) AdjustedTotalCommitment      
 ,isnull(tblUnfundComm.RemainingUnfundedCommitment,0) UnfundedCommitment    
 ,isnull(InitialFundingAmount,0) InitialFundingAmount    
  
   
FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID    
INNER JOIN CRE.Deal D ON D.DealID = N.DealID  
OUTER APPLY(  
 Select nt.noteid,SUM(tr.Amount) as SumPikAmount  
 from cre.transactionEntry Tr  
 Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID  
 Inner join cre.note nt on nt.Account_AccountID = acc.AccountID  
 where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')  
 and tr.date <= CAST(getdate() as date)  
 and nt.DealID = n.DealID   
 AND nt.noteid = n.noteid  
 and acc.AccounttypeID = 1  
 group by nt.noteid  
)tr  
  
OUTER APPLY(  
 Select nt.noteid,SUM(tr.Amount * -1)  as PikAmount  
 from cre.transactionEntry Tr  
 Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID  
 Inner join cre.note nt on nt.Account_AccountID = acc.AccountID  
 where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')  
 and tr.date = CAST(getdate() as date)  
 and nt.DealID = n.DealID   
 AND nt.noteid = n.noteid  
 and acc.AccounttypeID = 1  
 group by nt.noteid  
)trpik  
  
OUTER APPLY(      
 Select noteid,RemainingUnfundedCommitment from(      
  Select nt.noteid,RemainingUnfundedCommitment ,ROW_NUMBER() Over(Partition by nt.noteid order by nt.noteid,PeriodEndDate desc) rno      
  from cre.NotePeriodicCalc nc  
  inner join cre.note nt on nt.Account_AccountID =nc.AccountID   
  where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  and nc.RemainingUnfundedCommitment is not null       
  and nc.PeriodEndDate <= Cast(getdate() as Date)    
  and nt.DealID = n.DealID   
  and nt.noteid = n.noteid  
 )a where rno = 1      
)tblUnfundComm    
where a.isdeleted=0   
--ORDER BY D.DealName,N.CRENoteID