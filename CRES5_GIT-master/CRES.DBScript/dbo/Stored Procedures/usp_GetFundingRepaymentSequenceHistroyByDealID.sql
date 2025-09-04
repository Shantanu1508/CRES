-- [dbo].[usp_GetFundingRepaymentSequenceHistroyByDealID] '38C8C163-D0BC-4017-B56C-FC053C53F13B'

CREATE PROCEDURE [dbo].[usp_GetFundingRepaymentSequenceHistroyByDealID] 
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

----======================
IF OBJECT_ID('tempdb..#tblNPC') IS NOT NULL         
	DROP TABLE #tblNPC

CREATE TABLE #tblNPC(              
   AnalysisID  UNIQUEIDENTIFIER,
   AccountID  UNIQUEIDENTIFIER,
   PeriodEndDate Date,
   RemainingUnfundedCommitment   decimal(28,15),
   EndingBalance      decimal(28,15)    
)   

INSERT INTO #tblNPC (AnalysisID,AccountID,PeriodEndDate,RemainingUnfundedCommitment,EndingBalance)
Select nc.AnalysisID,nc.AccountID,PeriodEndDate,RemainingUnfundedCommitment,nc.EndingBalance
from cre.NotePeriodicCalc nc
inner join cre.note n on n.Account_AccountID =nc.AccountID 
Inner join core.account acc on acc.AccountID = n.Account_AccountID
where acc.IsDeleted <> 1
and Analysisid = @AnalysisID
and n.dealid = @DealID

---===================
IF OBJECT_ID('tempdb..#tblTranEntry') IS NOT NULL         
	DROP TABLE #tblTranEntry

CREATE TABLE #tblTranEntry(              
   AnalysisID  UNIQUEIDENTIFIER,
   AccountID  UNIQUEIDENTIFIER,
   [Type] nvarchar(256),
   [Date] Date,
   Amount   decimal(28,15)
)   

INSERT INTO #tblTranEntry (AnalysisID,AccountID,[Type],[date],Amount)
Select tr.analysisID,tr.AccountID,tr.[Type],tr.date,tr.Amount
from cre.transactionEntry Tr
Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID
Inner join cre.note n on n.Account_AccountID = acc.AccountID
where tr.analysisID =  @AnalysisID 
and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding','Balloon')
and n.dealid = @DealID
and acc.AccounttypeID = 1
and acc.IsDeleted <> 1
----=========================

 
SET @ColPivot = STUFF((SELECT ',' + QUOTENAME(cast(a.SeqName as nvarchar(256)) +' '+ cast(a.SequenceNo as nvarchar(256)))
				from (
					Select Distinct LSequenceTypeID.Name as SeqName,SequenceNo
					from [CRE].[FundingRepaymentSequence] fs
					INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID
					inner join Core.Account a on a.AccountID=n.Account_AccountID 
					LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType
					where a.isdeleted <> 1 and n.DealID =@DealID
				)a
				Order by a.SeqName,a.SequenceNo

				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)')
				,1,1,'') 


IF (@ColPivot is null)
BEGIN
	SET @query1=N'Select  a.NoteID,a.CRENoteID,a.Name,a.Maturity,a.WeightedSpread,a.EffectiveRate,a.NetCapitalInvested,a.EstBls,a.EndingBalance,a.lienposition,a.LienPositionText,a.Priority,a.FinancingSource,a.UseRuletoDetermineNoteFunding,a.UseRuletoDetermineNoteFundingText,a.FundingPriority,a.RepaymentPriority,a.TotalCommitment,a.AdjustedTotalCommitment,a.AggregatedTotal,a.UnfundedCommitment,ISNULL(a.InitialFundingAmount,0) as InitialFundingAmount,a.CurrentPIKBalance,a.BalloonPayment,a.CommitmentUsedInFFDistribution,a.FundingSeq1,a.FundingSeq2,a.FundingSeq3,a.FundingSeq4,a.FundingSeq5,a.RepaymentSeq1,a.RepaymentSeq2,a.RepaymentSeq3,a.RepaymentSeq4,a.RepaymentSeq5'
END
ELSE
BEGIN
	SET @query1=N'Select  a.NoteID,a.CRENoteID,a.Name,a.Maturity,a.WeightedSpread,a.EffectiveRate,a.NetCapitalInvested,a.EstBls,a.EndingBalance,a.lienposition,a.LienPositionText,a.Priority,a.FinancingSource,a.UseRuletoDetermineNoteFunding,a.UseRuletoDetermineNoteFundingText,a.FundingPriority,a.RepaymentPriority,a.TotalCommitment,a.AdjustedTotalCommitment,a.AggregatedTotal,a.UnfundedCommitment,ISNULL(a.InitialFundingAmount,0) as InitialFundingAmount,a.CurrentPIKBalance,a.BalloonPayment,a.CommitmentUsedInFFDistribution,a.FundingSeq1,a.FundingSeq2,a.FundingSeq3,a.FundingSeq4,a.FundingSeq5,a.RepaymentSeq1,a.RepaymentSeq2,a.RepaymentSeq3,a.RepaymentSeq4,a.RepaymentSeq5
	,b.*' 
END


SET @query1=@query1 + N'
from(    
SELECT n.NoteID  
,CRENoteID   
,a.Name Name  
,tblMat.currMaturityDate as Maturity
,n.WeightedSpread
,0.00 as EffectiveRate
,n.UPBAtForeclosure as NetCapitalInvested
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
 ISNULL(tblBls.EndingBalance,0)   
,0) + ISNULL(trpik.PikAmount,0) as EstBls
,ISNULL(tblBls.EndingBalance,0) EndingBalance   
,lienposition  
,llienposition.name as LienPositionText  
,[priority] as Priority  
,FSM.FinancingSourceName as FinancingSource
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
,isnull(tblUnfundComm.RemainingUnfundedCommitment,0) UnfundedCommitment  
,InitialFundingAmount as InitialFundingAmount  
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

'SET @query2=' FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID  
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
	Select n.noteid,SUM(tr.Amount) as SumPikAmount
	from #tblTranEntry Tr
	Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID
	Inner join cre.note n on n.Account_AccountID = acc.AccountID
	where tr.analysisID =  '''+convert(varchar(MAX),@AnalysisID)+''' and tr.[Type] in (''PikPrincipalPaid'',''PIKPrincipalFunding'')
	and tr.date <= CAST(getdate() as date)
	and n.dealid = '''+convert(varchar(256),@DealID)+'''  
	and acc.AccounttypeID = 1
	group by n.noteid
)tr on tr.noteid = n.noteid
left join(
	Select n.noteid,SUM(tr.Amount * -1)  as PikAmount
	from #tblTranEntry Tr
	Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID
	Inner join cre.note n on n.Account_AccountID = acc.AccountID
	where tr.analysisID =  '''+convert(varchar(MAX),@AnalysisID)+''' and tr.[Type] in (''PikPrincipalPaid'',''PIKPrincipalFunding'')
	and tr.date = CAST(getdate() as date)
	and n.dealid = '''+convert(varchar(256),@DealID)+'''    
	and acc.AccounttypeID = 1
	group by n.noteid
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
				select Distinct nn.noteid,Date,ISNULL(Amount,0) BalloonPayment,  
				ROW_NUMBER() Over (Partition by nn.noteid Order by nn.noteid,np.Date desc) as rno  
				from #tblTranEntry np  
				Inner JOIN [CORE].[Account] acc ON acc.AccountID = np.AccountID
				Inner join cre.note nn on nn.Account_AccountID = acc.AccountID  
				and Type = ''Balloon'' 
				and Amount <> 0.01
				where nn.dealid = '''+convert(varchar(MAX),@DealID)+'''   
				and Date <= CAST(getdate() as Date)   
				and AnalysisID = '''+convert(varchar(MAX),@AnalysisID)+'''  
				)a 
			where a.rno = 1
)bp on bp.noteid = n.noteid
Left Join(    
	Select noteid,RemainingUnfundedCommitment from(    
		Select n.noteid,RemainingUnfundedCommitment ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
		from #tblNPC nc
		inner join cre.note n on n.Account_AccountID =nc.AccountID 
		where Analysisid = '''+convert(varchar(MAX),@AnalysisID)+'''
		and nc.PeriodEndDate <= Cast(getdate() as Date)  
		and n.dealid = '''+convert(varchar(MAX),@DealID)+'''   
	)a where rno = 1    
)tblUnfundComm on tblUnfundComm.NoteID = n.NoteID  
Left Join(    
	Select noteid,EndingBalance from(    
		Select n.noteid,EndingBalance ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
		from #tblNPC nc
		inner join cre.note n on n.Account_AccountID =nc.AccountID 
		where Analysisid = '''+convert(varchar(MAX),@AnalysisID)+'''
		and nc.PeriodEndDate <= Cast(getdate() - 1 as Date)  
		and n.dealid = '''+convert(varchar(MAX),@DealID)+'''   
	)a where rno = 1    
)tblBls on tblBls.NoteID = n.NoteID  
LEFT JOIN [CRE].[FinancingSourceMaster] FSM ON FSM.FinancingSourceMasterID = N.FinancingSourceID
where n.DealID = '''+convert(varchar(MAX),@DealID)+'''   
and a.isdeleted=0   
-- ORDER BY Account_AccountID DESC   
) a  
'   
 
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
where a.isdeleted <> 1 and n.DealID = '''+convert(varchar(MAX),@DealID)+'''   
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

END
GO

