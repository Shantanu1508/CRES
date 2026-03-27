CREATE view [dbo].[vw_NotePeriodicCalcPosition]         
AS        
select notekey,periodenddate ,adj.NoteAdjustedTotalCommitment,adj.NoteTotalCommitment       
,nc.NoteID      
,CREDealID as DealId      
,DealName      
,(select [Value]+'#/dealdetail/'+CREDealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl
,EndingBalance      
,AmortizedCost      
,PIKInterestAppliedForThePeriod      
,PIKInterestPaidForThePeriod      
,InterestReceivedinCurrentPeriod      
,PIKInterestAccrualforthePeriod      
,CurrentPeriodInterestAccrual    
,InterestSuspenseAccountActivityforthePeriod      
,TotalAmortAccrualForPeriod      
,DiscountPremiumAccrual      
,CapitalizedCostAccrual      
,AccumulatedAmort     
,[AccumulatedAmort]+[AccumaltedDiscountPremium]+[AccumalatedCapitalizedCost] as [Accumulated Amortization]    
,EndingGAAPBookValue      
,ISNULL(pik.PIKPrincipalFundingorPaid,0) as PIKPrincipalFundingorPaid      
,nc.CurrentPeriodPIKInterestAccrual
from noteperiodiccalc nc        
Outer apply            
(          
         
 Select NoteID,NoteAdjustedTotalCommitment ,NoteTotalCommitment        
 From(           
  SELECT        
       
  NoteID as notekey        
  ,CRENoteID as NoteID        
  ,Date        
  ,TypeBI as [type]        
  ,value as [Value]        
  ,NoteAdjustedTotalCommitment        
  ,NoteTotalCommitment        
  ,Rowno        
  ,CREDealID as DealID        
  ,dealid as DealKey        
  ,[CreatedBy]        
  ,[CreatedDate]        
  ,[UpdatedBy]        
  ,[UpdatedDate]        
  ,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno         
  From [DW].[TotalCommitmentDataBI] nd        
        
  where noteid =  nc.notekey --'16361'        
  and [Date] <= CAST(nc.periodenddate as Date)        
 )a        
 where rno =  1         
        
) adj          
      
Outer apply (       
 Select noteid,(SUM(Amount)*-1) as PIKPrincipalFundingorPaid from dbo.transactionEntry t      
 where analysisid = 'c10f3372-0fc2-4861-a9f5-148f1f80804f'      
 and [Type] in ('PIKPrincipalFunding','PIKPrincipalPaid')      
 and date <= CAST(nc.PeriodEndDate as Date)      
  and t.NoteKey =  nc.notekey     
  and t.AccountTypeID  = 1
 group by noteid      
)pik 
GO


