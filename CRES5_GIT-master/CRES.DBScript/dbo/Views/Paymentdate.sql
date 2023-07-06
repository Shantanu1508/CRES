-- View
CREATE View [dbo].[Paymentdate]
As

Select N.Noteid, CreNoteid, N.Dealid, Date, InitialInterestAccrualEndDate, FirstPaymentDate
,crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110) NoteID_Date
, Includeservicingpaymentoverrideinlevelyield
, DealName,
[DeterminationDateLeadDays],[FirstRateIndexResetDate],[InitialIndexValueOverride],[DeterminationDateReferenceDayoftheMonth]

--, MaturityDateBI =  (Case WHEN  ActualPayoffDate is not null and ActualPayoffDate< getdate() THEn ActualPayoffDate
--						When ActualPayoffDate is not null and ActualPayoffDate>= Getdate() THEN ActualPayoffDate
--						WHEN ActualPayoffDate is NULL Then (Case when ExtendedMaturityScenario1 >= Getdate()  THEN  ExtendedMaturityScenario1
--																WHen ExtendedMaturityScenario2  >= Getdate()  THEN  ExtendedMaturityScenario2
--																WHen ExtendedMaturityScenario3  >= Getdate()  THEN  ExtendedMaturityScenario3
--																Else FullyExtendedMaturityDate End)
--						end)

, MaturityDateBI = tblcurrMat.currMaturity

 from [CRE].[TransactionEntry] T
Inner Join Cre.Note N on N.Noteid = T.Noteid
Inner join cre.deal D on D.DealID = N.DealID
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
						where EventTypeID = 11	and eve.StatusID = 1				
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

)tblcurrMat on tblcurrMat.noteid = N.NoteID

Where [Type] = 'InterestPaid' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--Group By Crenoteid, N.Noteid, Date, DealID, InitialInterestAccrualEndDate, FirstPaymentDate




