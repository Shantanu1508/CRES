CREATE View [dbo].[First_GAAPBookValueMissing]
As
Select nn.noteid
,nn.crenoteid
,nn.ClosingDate
,EOMONTH(nn.ClosingDate) ClosingDate_EOMONTH

 --,Maturity_DateBI =  (Case WHEN  ActualPayoffDate is not null and ActualPayoffDate< getdate() THEn ActualPayoffDate
	--					When ActualPayoffDate is not null and ActualPayoffDate>= Getdate() THEN ActualPayoffDate
	--					WHEN ActualPayoffDate is NULL Then (Case when ExtendedMaturityScenario1 >= Getdate()  THEN  ExtendedMaturityScenario1
	--															WHen ExtendedMaturityScenario2  >= Getdate()  THEN  ExtendedMaturityScenario2
	--															WHen ExtendedMaturityScenario3  >= Getdate()  THEN  ExtendedMaturityScenario3
	--															Else FullyExtendedMaturityDate End)
	--					end)


, MaturityDateBI = tblcurrMat.currMaturity

,SUM(ISNULL(EndingGAAPBookValue,0)) 

as EndingGAAPBookValue

from cre.NotePeriodicCalc np
inner join cre.note nn on nn.noteid = np.noteid
Left Join(
	Select n1.noteid, ISNULL(n1.ActualPayOffDate,currMat.MaturityDate) as currMaturity
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
						where EventTypeID = 11		and eve.StatusID = 1			
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

)tblcurrMat on tblcurrMat.noteid = nn.NoteID


where  np.periodenddate <= EOMONTH(nn.ClosingDate)
and nn.crenoteid not in ( Select Distinct CreNoteid
					from Cre.Note N
					inner JOin cre.transactionEntry tr on N.Noteid = tr.Noteid
					where tr.type not in ( 'FundingOrRepayment')  and 
					Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate)))  
					and InitialFundingAmount < 1
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
					)

and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

group by nn.noteid,nn.crenoteid
,nn.ClosingDate
, ActualPayoffDate
--, ExtendedMaturityScenario1
--, ExtendedMaturityScenario2
--, ExtendedMaturityScenario3
--, FullyExtendedMaturityDate
,tblcurrMat.currMaturity
having SUM(ISNULL(EndingGAAPBookValue,0)) = 0


