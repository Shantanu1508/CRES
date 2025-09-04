 

CREATE VIEW [dbo].[view_RH_NoteEntityM61]    
AS    
Select     
RTRIM(LTRIM(d.CREDealID)) DealID,  
RTRIM(LTRIM(d.DealName)) as DealName,  
RTRIM(LTRIM(n.noteid)) as [NoteID],    
RTRIM(LTRIM(n.name)) as [NoteName],    
RTRIM(LTRIM(Replace(FinancingSource,'Delphi Warehouse LIne','Delphi Warehouse Line'))) as [FinancingSource],    
RTRIM(LTRIM(ISNULL(RateTypeBI,'Floating'))) as [RateType],    
  
(CASE WHEN CAST(ROUND(n.InitialFundingAmount,2) as decimal(28,2)) = 0.01 THEN 0.0 ELSE  CAST(ROUND(n.InitialFundingAmount,2) as decimal(28,2)) END) as [InitialFunding],    
  
--M61Commitment as [OriginalCommitmentAmount],    
  
--CAST(ROUND(tblCurrNPC.EndingBalance,2) as decimal(28,2)) as [CurrentUPB],    
--CAST(ROUND(M61AdjustedCommitment,2) as decimal(28,2)) as [CurrentCommitment],    
(CASE WHEN CAST(ROUND(n.InitialFundingAmount,2) as decimal(28,2)) = 0.01 THEN CAST(ROUND(tblCurrNPC.EndingBalance,2) as decimal(28,2)) - 0.01 ELSE CAST(ROUND(tblCurrNPC.EndingBalance,2) as decimal(28,2)) END)  as [CurrentUPB],    
(CASE WHEN CAST(ROUND(n.InitialFundingAmount,2) as decimal(28,2)) = 0.01 THEN CAST(ROUND(tblcomm.NoteAdjustedTotalCommitment,2) as decimal(28,2)) - 0.01 ELSE CAST(ROUND(tblcomm.NoteAdjustedTotalCommitment,2) as decimal(28,2)) END) as [CurrentCommitment],    
  
  
RTRIM(LTRIM(lienpositionBI)) as [LienPosition],    
n.Priority as [Priority],    
ISNULL(n.IOTerm,0) as [IOTerm],    
RTRIM(LTRIM(tblIndexName.IndexName)) as [IndexName],    
  
--tblCurrSpread.Value  as [CurrentSPREAD],    
(CASE WHEN tblFixedrate_spread.crenoteid is not null THEN tblFixedrate_spread.Fix_Spread ELSE tblCurrSpread.Value END) as [CurrentSPREAD],    



---ISNULL(CAST(tblCurrFloor.Value as decimal(28,9)),0) as [CurrentFloorPercent],     
(CASE WHEN tblpik.crenoteid is not null THEN ISNULL(CAST(tblpik.IndexFloor as decimal(28,9)),0) ELSE ISNULL(CAST(tblCurrFloor.Value as decimal(28,9)),0) END) as [CurrentFloorPercent],

CAST(tblAllinCoupon.AllinCouponRate as decimal(28,9)) as [CurrentInterestRate],    
    
CAST(ISNULL(nn.OriginationFeePercentageRP,ISNULL(tblOrig.OrigFeePer,0)) as decimal(28,9)) as [OriginationFeePercent],    
    
tblMaturity.Maturity as [CurrentMaturity],     
n.FullyExtendedMaturityDate as [FullyExtendedMaturityDate],  
  
tblRss.IntCalcMethodText as DayCountinthecalculator,  
ISNULL(n.DeterminationDateReferenceDayoftheMonth,0) as PaymentDate,  
isnulL(trpik.SumPikAmount,0) as PIKBalance,  
n.ClosingDate as OriginationDate,  
  
d.BS_CollateralStatusDesc as LoanType,  
ptm.PropertyTypeMajorDesc as PropertyType,  
d.BSCity as City,  
d.BSState as [State],  
  
REPLACE(d.MSA_NAME,',','-') as MSA_NAME,  
d.InquiryDate as InquiryDate  

from note n    
inner join cre.note nn on nn.noteid = n.notekey  
inner join core.account acc on acc.accountid = nn.account_accountid  
inner join cre.deal d on d.dealid = nn.dealid  
left join [CRE].[PropertyTypeMajor]  ptm on ptm.PropertyTypeMajorID = d.PropertyTypeMajorID  
Left Join(    
 Select noteid,Date,ValueType,Value from(    
  Select  noteid,Date,ValueType,Value ,ROW_NUMBER() Over(Partition by noteid order by noteid,date desc) rno    
  from [RateSpreadSchedule] where ScheduleText = 'Latest Schedule' and ValueType = 'Spread' and [Date] <= Cast(getdate() as Date)    
 )a    
 where rno = 1    
)tblCurrSpread on tblCurrSpread.NoteID = n.NoteID    
Left Join(    
 Select noteid,Date,ValueType,Value from(    
  Select  noteid,Date,ValueType,Value ,ROW_NUMBER() Over(Partition by noteid order by noteid,date desc) rno    
  from [RateSpreadSchedule] where ScheduleText = 'Latest Schedule' and ValueType = 'Index Floor' and [Date] <= Cast(getdate() as Date)    
 )a    
 where rno = 1    
)tblCurrFloor on tblCurrFloor.NoteID = n.NoteID    
Left Join(    
	Select noteid,EndingBalance from(    
		Select n.noteid,EndingBalance ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
		from cre.NotePeriodicCalc nc
		Inner join core.account acc on acc.accountid = nc.AccountID
        Inner join cre.note n on n.account_accountid = acc.accountid        
		--inner join cre.note n on n.Account_AccountID =nc.AccountID 
		where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'    and acc.AccounttypeID = 1  
		--and [Month] is not null     
		and PeriodEndDate <= Cast(getdate() as Date)  		
	)a where rno = 1    
)tblCurrNPC on tblCurrNPC.NoteID = nn.NoteID    

Left JOin(
	Select noteid,AllinCouponRate from(    
		Select n.noteid,AllinCouponRate,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
		from cre.NotePeriodicCalc nc
		Inner join core.account acc on acc.accountid = nc.AccountID
        Inner join cre.note n on n.account_accountid = acc.accountid        
		--inner join cre.note n on n.Account_AccountID =nc.AccountID 
		where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   and acc.AccounttypeID = 1  
		and [Month] is not null     
		and PeriodEndDate <= Cast(getdate() as Date)   	
	)a where rno = 1  
)tblAllinCoupon on tblAllinCoupon.noteid = nn.noteid  


   
Left Join(    
  Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as Maturity  
 from cre.note n1  
 Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid  
 Left Join(  
  Select noteid,MaturityType,MaturityDate,Approved  
  from (  
    Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,  
    ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno  
    from [CORE].Maturity mat    
    INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
    INNER JOIN     
    (            
     Select     
     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
     where EventTypeID = 11 and eve.StatusID = 1  
     --and n.DealID = ''+convert(varchar(MAX),@DealID)+''       
     and acc.IsDeleted = 0    
     GROUP BY n.Account_AccountID,EventTypeID      
    ) sEvent      
    ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
    Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
    Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
    where mat.MaturityDate > getdate()  
    and lApproved.name = 'Y'  
  )a where a.rno = 1  
 )currMat on currMat.noteid = n1.noteid  
 where acc1.IsDeleted <> 1  
    
)tblMaturity on tblMaturity.noteid = n.notekey    
  
left join(  
  Select n.noteid,SUM(tr.Amount) as SumPikAmount  
  from cre.transactionEntry Tr  
  inner join cre.note n on n.Account_AccountID=tr.AccountID   
  where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')   
  group by n.noteid  
)trpik on trpik.noteid = nn.noteid  
Left Join(  
 Select noteid,IntCalcMethodText  
 From(  
  Select   
   n.NoteID  
   ,rs.date  
  ,LValueTypeID.Name as ValueTypeText    
  ,LIntCalcMethodID.Name as IntCalcMethodText   
  ,ROW_NUMBER() over (Partition by n.NoteID ORDER by n.NoteID,rs.date desc) as rno  
  from [CORE].RateSpreadSchedule rs    
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
  LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID    
  LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID    
  INNER JOIN     
  (            
   Select     
   (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
   MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
   where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')    
   and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)    
   --and n.NoteID = @NoteID    
   and acc.IsDeleted = 0    
   GROUP BY n.Account_AccountID,EventTypeID      
  ) sEvent      
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted <> 1  
  and LValueTypeID.Name in ('Rate','Spread')  
  and rs.date <= getdate()  
 )a where a.rno = 1  
)tblRss on tblRss.noteid = nn.noteid  
  
Left JOin(
	Select  crenoteid,noteid,OrigFeePer
	From(
	Select Distinct n.noteid,n.crenoteid,ISNULL(pafs.[Value],0) as OrigFeePer
	,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,pafs.StartDate desc) rno  
	from [CORE].PrepayAndAdditionalFeeSchedule pafs  
	INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId  
	LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID  
	LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature  
	INNER JOIN   
	(          
		Select   
		 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		 where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')  
		 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
     
		 and acc.IsDeleted = 0  
		 GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = 1 and acc.isdeleted <> 1
	and pafs.StartDate <= getdate()
	and FeeTypeNameText = 'Origination Fee'
	)a
	where rno = 1
)tblOrig on tblOrig.noteid = nn.noteid  

LEFT JOIN(

Select distinct n.noteid,n.crenoteid,e.EffectiveStartDate, pik.IndexFloor
from [CORE].PikSchedule pik 
INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId 
INNER JOIN   
(        
	Select   
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
	where EventTypeID = 12	
	and acc.IsDeleted = 0  
	GROUP BY n.Account_AccountID,EventTypeID    
) sEvent    
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where acc.isdeleted <> 1

)tblpik on tblpik.noteid = nn.noteid

LEFT JOIN(
	Select noteid,crenoteid, [Value] as Fix_Spread
	from(    
		Select n.noteid,n.crenoteid,rs.[value] ,ROW_NUMBER() Over(Partition by noteid order by noteid,rs.date desc) rno 
		from [CORE].RateSpreadSchedule rs  
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID 

		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 14
			and eve.StatusID = 1
			and acc.IsDeleted = 0  
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] Lratetype ON Lratetype.LookupID = n.RateType
 
		where e.StatusID = 1 and acc.isdeleted <> 1
		and LValueTypeID.name = 'Rate' 
		and rs.[Date] <= Cast(getdate() as Date)    
		and Lratetype.name = 'Fixed'
	)a    
	where rno = 1    
)tblFixedrate_spread on tblFixedrate_spread.noteid = nn.noteid
Left Join(
	Select noteid,crenoteid,IndexName
	from(    
		Select n.noteid,n.crenoteid,lindex.Name as IndexName ,ROW_NUMBER() Over(Partition by noteid order by noteid,rs.date desc) rno 
		from [CORE].RateSpreadSchedule rs  
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID 
		LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID  
		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 14
			and eve.StatusID = 1
			and acc.IsDeleted = 0  
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] Lratetype ON Lratetype.LookupID = n.RateType
 
		where e.StatusID = 1 and acc.isdeleted <> 1
		and LValueTypeID.name = 'Index Name' 
		and rs.[Date] <= Cast(getdate() as Date)  
	)a    
	where rno = 1   
)tblIndexName on tblIndexName.noteid = nn.noteid

Left JOin(
	Select noteid,CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment
	From(			
		SELECT d.CREDealID
		,n.CRENoteID
		,Date as Date
		,nd.Type as Type
		,NoteAdjustedTotalCommitment
		,NoteTotalCommitment
		,nd.NoteID
		,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,
		nd.Rowno
		from cre.NoteAdjustedCommitmentMaster nm
		left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
		right join cre.deal d on d.DealID=nm.DealID
		Right join cre.note n on n.NoteID = nd.NoteID
		inner join core.account acc on acc.AccountID = n.Account_AccountID
		where d.IsDeleted<>1 and acc.IsDeleted<>1
		--and n.crenoteid in ( '10049')	
	)a
	where rno =  1 
)tblcomm on tblcomm.noteid = nn.noteid



--Left Join(    
-- Select Noteid,StartDate,Value,FeeAmountOverride,FeeType     
-- from(    
--  Select Noteid,StartDate,Value,FeeAmountOverride,FeeType,ROW_NUMBER() Over(Partition by noteid order by noteid,StartDate desc) rno    
--  from [dbo].[FeeSchedule]     
--  where FeeType = 'Origination Fee' and StartDate <= Cast(getdate() as Date)      
-- )a where rno = 1    
--)tblOriginationFee on tblOriginationFee.NoteID = n.NoteID    
    
    
where acc.isdeleted <> 1  
and d.status not in (325,324)  
--and nn.ActualPayOffDate is null  
--and FinancingSource not in ('3rd Party Owned','Co-Fund')
--and d.DealName not like 'sop%'

 
GO


