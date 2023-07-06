-- [dbo].[usp_GetFundingRepaymentSequenceHistroyByDealID] '8918EE99-EF41-4B9B-BEF0-EF466D6960D8'

CREATE PROCEDURE [dbo].[usp_GetFundingRepaymentSequenceHistroyByDealID] --'F160E8FD-C5F5-4D6F-8F0A-09D338BCA4C1'  
 @DealID as uniqueidentifier   
AS   
BEGIN   
 -- SET NOCOUNT ON added to prevent extra result sets from   
 -- interfering with SELECT statements.   
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
   
  
Declare @AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from core.analysis where name = 'Default')  
  
DECLARE @ColPivot AS NVARCHAR(MAX),   
 @query AS NVARCHAR(MAX),   
 @query1 as nvarchar(MAX) ,  
 @query2 as nvarchar(MAX)   
   
Declare @UseRuletoDetermineNoteFundingAsNo int=(Select LookupID from CORE.Lookup where Name = 'N' and Parentid = 2)   
Declare @InActive as nvarchar(256);   
Declare @Active as nvarchar(256);   
set @InActive=(select LookupID from core.lookup where name ='InActive' and ParentID=1);   
set @Active=(select LookupID from core.lookup where name ='Active' and ParentID=1);   
   
 --,@DealID as nvarchar(MAX)='5e29a13a-a205-46ab-89f1-e7d819bce3ed'   
 set @query1=N'Select * from(    
SELECT n.NoteID  
,CRENoteID   
,a.Name Name  
,tblMat.currMaturityDate as Maturity 
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
    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = ''FundingSchedule'')  
    and n1.dealid = '''+convert(varchar(MAX),@DealID)+''' and acc.IsDeleted = 0  
    and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and ParentID = 1)  
    GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID  
   ) sEvent  
   
 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID  
   
 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
 left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 --INNER JOIN [CRE].[Note] n2 ON n2.Account_AccountID = acc.AccountID  
 where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0  
 and fs.Date = Cast(getdate() AS DATE))    
 +    
 ISNULL((select SUM((ISNULL(EndingBalance,0)))  
 from [CRE].[NotePeriodicCalc] np  
 where np.noteid = n.noteid and n.dealid = '''+convert(varchar(MAX),@DealID)+''' and PeriodEndDate = CAST(getdate() - 1 as Date) and AnalysisID = '''+convert(varchar(MAX),@AnalysisID)+'''),0)   
  
,0) + ISNULL(trpik.PikAmount,0) as EstBls  
 '  
   
SET @query2='  
,ISNULL(  
(select SUM((ISNULL(EndingBalance,0)))  
from [CRE].[NotePeriodicCalc] np  
where np.noteid = n.noteid and n.dealid = '''+convert(varchar(MAX),@DealID)+''' and PeriodEndDate = CAST(getdate() - 1 as Date) and AnalysisID = '''+convert(varchar(MAX),@AnalysisID)+''')    
,0) EndingBalance  
 
,lienposition  
,llienposition.name as LienPositionText  
,[priority] as Priority  
--,(case when isnull(a.StatusID,'''+convert(varchar(MAX),@Active)+''')='''+convert(varchar(MAX),@InActive)+''' Then '''+convert(varchar(MAX),@UseRuletoDetermineNoteFundingAsNo)+''' else n.UseRuletoDetermineNoteFunding END) UseRuletoDetermineNoteFunding  
,n.UseRuletoDetermineNoteFunding as UseRuletoDetermineNoteFunding 
,lUseRuletoDetermineNoteFunding.Name as UseRuletoDetermineNoteFundingText  
--,NoteFundingRule  
--,lNoteFundingRule.Name NoteFundingRuleText  
,FundingPriority  
--,isnull(NoteBalanceCap,0) NoteBalanceCap  
,RepaymentPriority  
,isnull(n.TotalCommitment,0) TotalCommitment
,isnull(n.AdjustedTotalCommitment,0) AdjustedTotalCommitment    
--,(case when isnull(n.AggregatedTotal,0) =''0'' then n.TotalCommitment
-- else n.AggregatedTotal end) AS AggregatedTotal
,isnull(n.AggregatedTotal,0) AS AggregatedTotal
,isnull(InitialFundingAmount,0) InitialFundingAmount  
,isnull((CASE WHEN tr.SumPikAmount > 0 THEN tr.SumPikAmount ELSE (tr.SumPikAmount * -1) END),0) as CurrentPIKBalance 
--,n.InitialRequiredEquity
--,n.InitialAdditionalEquity
,ISNULL(BalloonPayment,0) as BalloonPayment
,ISNULL((Case When isnulL(CommitmentUsedInFFDistribution,0) = 0 THEN originaltotalcommitment ELSE CommitmentUsedInFFDistribution END),0) CommitmentUsedInFFDistribution
,0 FundingSeq1  
,0 FundingSeq2  
,0 FundingSeq3  
,0 FundingSeq4  
,0 FundingSeq5  
,0 RepaymentSeq1  
,0 RepaymentSeq2  
,0 RepaymentSeq3  
,0 RepaymentSeq4  
,0 RepaymentSeq5 
FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID  
left join Core.Lookup l ON n.RateType=l.LookupID  
--left join Core.Lookup lUseRuletoDetermineNoteFunding ON (case when isnull(a.StatusID,'''+convert(varchar(MAX),@Active)+''')='''+convert(varchar(MAX),@InActive)+''' Then '''+convert(varchar(MAX),@UseRuletoDetermineNoteFundingAsNo)+'''    else n.UseRuletoDetermineNoteFunding END)=lUseRuletoDetermineNoteFunding.LookupID  
left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID  
left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID  
left join Core.Lookup llienposition ON n.lienposition=llienposition.LookupID 
left join (Select dealid,NoteID,SUM(Amount) Amount
			From(
				SELECT nac.dealid,nacd.NoteID,SUM(nacd.[Value]) as Amount
				FROM CRE.NoteAdjustedCommitmentMaster nac
				left join CRE.NoteAdjustedCommitmentDetail nacd on nacd.NoteAdjustedCommitmentMasterID = nac.NoteAdjustedCommitmentMasterID
				WHERE nac.dealid='''+convert(varchar(MAX),@DealID)+'''  
				and nac.type not in (637,638)
				group by nac.dealid,nacd.NoteID
		
				UNION ALL

				SELECT  d1.dealid,n.noteid,ISNULL(n.TotalCommitment,0) as Amount
				FROM CRE.Note n 
				inner join cre.deal d1 on d1.dealid = n.dealid
				where d1.DealID = '''+convert(varchar(MAX),@DealID)+''' 

				UNION ALL

				Select d.dealid,n.noteid, SUM(fs.value) as Amount from [CORE].FundingSchedule fs
				INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
				INNER JOIN (						
					Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = ''FundingSchedule'')
					and n.DealID = '''+convert(varchar(256),@DealID)+'''    
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
				) sEvent
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
				left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				Inner join cre.deal d on d.dealid = n.dealid
				where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
				and fs.Date <= getdate()
				and fs.Applied = 1
				and fs.PurposeID in (315,629,630,631)
				and fs.value < 0
				group by d.dealid,n.noteid
			)x
			group by dealid,NoteID
	)f on f.NoteID= n.NoteID
left join(
	Select tr.noteid,SUM(tr.Amount) as SumPikAmount
	from cre.transactionEntry Tr
	inner join cre.note n on n.noteid=tr.noteid 
	where tr.analysisID =  '''+convert(varchar(MAX),@AnalysisID)+''' and tr.[Type] in (''PikPrincipalPaid'',''PIKPrincipalFunding'')
	and tr.date <= CAST(getdate() as date)
	and n.dealid = '''+convert(varchar(256),@DealID)+'''    
	group by tr.noteid
)tr on tr.noteid = n.noteid
left join(
	Select tr.noteid,(CASE WHEN SUM(tr.Amount) < 0 THEN SUM(tr.Amount) * -1 ELSE SUM(tr.Amount) END)  as PikAmount
	from cre.transactionEntry Tr
	inner join cre.note n on n.noteid=tr.noteid 
	where tr.analysisID =  '''+convert(varchar(MAX),@AnalysisID)+''' and tr.[Type] in (''PikPrincipalPaid'',''PIKPrincipalFunding'')
	and tr.date = CAST(getdate() as date)
	and n.dealid = '''+convert(varchar(256),@DealID)+'''    
	group by tr.noteid
)trpik on trpik.noteid = n.noteid
left Join(
	Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as currMaturityDate
	from cre.note n1
	Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
	Left Join(
		Select noteid,MaturityType,MaturityDate,Approved
		from (
				Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
				ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = ''Initial'' THEN 0 WHEN lMaturityType.name = ''Fully extended'' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
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
					and n.DealID = '''+convert(varchar(MAX),@DealID)+'''     
					and acc.IsDeleted = 0  
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				where n.dealid = '''+convert(varchar(MAX),@DealID)+'''   
				and mat.MaturityDate > getdate()
				and lApproved.name = ''Y''
		)a where a.rno = 1
	)currMat on currMat.noteid = n1.noteid
	where acc1.IsDeleted <> 1
	and n1.dealid = '''+convert(varchar(MAX),@DealID)+'''   
)tblMat on tblMat.noteid = n.noteid

left join (Select noteid,BalloonPayment 
			from(  
				select Distinct np.noteid,Date,ISNULL(Amount,0) BalloonPayment,  
				ROW_NUMBER() Over (Partition by np.noteid Order by np.noteid,np.Date desc) as rno  
				from [CRE].[TransactionEntry] np  
				Inner join cre.note nn on nn.NoteID = np.NoteID  
				and Type = ''Balloon'' 
				and Amount <> 0.01
				where nn.dealid = '''+convert(varchar(MAX),@DealID)+'''   
				and Date <= CAST(getdate() as Date)   
				and AnalysisID = '''+convert(varchar(MAX),@AnalysisID)+'''  
				)a 
			where a.rno = 1
)bp on bp.noteid = n.noteid

where n.DealID = '''+convert(varchar(MAX),@DealID)+'''   
and a.isdeleted=0   
-- ORDER BY Account_AccountID DESC   
) a  
'   
  
SET @ColPivot = STUFF((SELECT ',' + QUOTENAME(cast(a.SeqName as nvarchar(256)) +' '+ cast(a.SequenceNo as nvarchar(256)))
from (
Select Distinct LSequenceTypeID.Name as SeqName,SequenceNo
from [CRE].[FundingRepaymentSequence] fs
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID
LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType
where n.DealID =@DealID
)a
Order by a.SeqName,a.SequenceNo

FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)')
,1,1,'') 
       
  
set @query = 'left join( SELECT NoteName, ' + @ColPivot + ' from    
(   
Select   
a.Name NoteName   
,cast(LSequenceTypeID.Name as nvarchar(256)) +'' ''+ cast(SequenceNo as nvarchar(256)) col    
,isnull(fs.Value,0) Value   
from [CRE].[FundingRepaymentSequence] fs   
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID   
inner join Core.Account a on a.AccountID=n.Account_AccountID   
LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType   
where n.DealID = '''+convert(varchar(MAX),@DealID)+'''   
) x    
pivot    
(  
 sum(Value)   
 for    
 col in (' + @ColPivot + ')   
  
) p '-- order by Name'   
   
   
--set @query=@query + ') b on a.Name=b.NoteName order by ISNULL(a.lienposition,99999), a.Priority,a.InitialFundingAmount desc, a.Name '   

IF (@ColPivot is null)
BEGIN
	set @query= ' order by ISNULL(a.lienposition,99999), a.Priority,a.InitialFundingAmount desc, a.Name '   
END
ELSE
BEGIN
	set @query=@query + ') b on a.Name=b.NoteName order by ISNULL(a.lienposition,99999), a.Priority,a.InitialFundingAmount desc, a.Name '   
END

   


exec(@query1+@query2+@query);   
   
print @query1   
print @query2  
print @query   

SET TRANSACTION ISOLATION LEVEL READ COMMITTED   


 
--,case when n.ActualPayoffDate is not null then n.ActualPayoffDate  
--when (select SelectedMaturityDate from core.Maturity where EventID=   
--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
--) >getdate() or (n.ExtendedMaturityScenario1 is null and n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null)   
-- then (select SelectedMaturityDate from core.Maturity where EventID=   
--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
--) else   
--case when n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else   
--case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else   
--case when n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario3 else  
----case when n.ExtendedMaturityScenario3 >GETDATE() then n.FullyExtendedMaturityDate else   
-- n.FullyExtendedMaturityDate end --end   
-- end end end as Maturity    







END
GO

