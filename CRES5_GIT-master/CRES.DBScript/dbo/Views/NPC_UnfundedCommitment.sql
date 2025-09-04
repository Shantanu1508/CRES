CREATE view [dbo].[NPC_UnfundedCommitment]                  
as                    
select          
N.NoteID as NoteKey,                  
N.CRENoteID as NoteID,         
n.CreatedDate,                               
n.UpdatedDate,                           
PeriodEndDate,                                       
CREDealID,                  
DealName ,                                                      
PeriodendDateBI = Case WHEN  PeriodEndDate = Convert(Date,(GetDate()-1)) THEN 'Last Close'                 
     Else Convert (varchar,PeriodendDate) End                   
    
,ISNULL(N.RemainingUnfundedCommitment  ,0) as RemainingUnfundedCommitment    
      
From [DW].[NotePeriodicCalcBI] N              
Where analysisid in ('C10F3372-0FC2-4861-A9F5-148F1F80804F')           
and N.RemainingUnfundedCommitment   is not null     
and N.PeriodEndDate >= EOMONTH(Dateadd(month,-1,getdate())) and N.PeriodEndDate <= EOMONTH(getdate())
        

