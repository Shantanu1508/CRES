

--[dbo].[usp_RunTestCases] 1,'45696C0F-A73D-4F2D-AFBF-CCAA7718A707','Note',1,100
--[dbo].[usp_RunTestCases] 0,'45696C0F-A73D-4F2D-AFBF-CCAA7718A707','Note',1,50

--[dbo].[usp_RunTestCases] 1,'45696C0F-A73D-4F2D-AFBF-CCAA7718A707','Deal',1,50
--[dbo].[usp_RunTestCases] 0,'45696C0F-A73D-4F2D-AFBF-CCAA7718A707','Deal',1,50

CREATE PROCEDURE [dbo].[usp_RunTestCases]
(
	@IsRun bit,
	@userId nvarchar(256),
	@ModuleName  nvarchar(256),
	@PgeIndex INT,
	@PageSize INT 
)
AS
BEGIN

DECLARE @ModuleNote int
DECLARE @ModuleDeal int
SET @ModuleNote = (Select LookupID from core.Lookup where ParentID = 27 and name ='Note')
SET @ModuleDeal = (Select LookupID from core.Lookup where ParentID = 27 and name ='Deal')


Declare @TotalCount INT

--Note
DECLARE @RanPastInitialMaturity UNIQUEIDENTIFIER
DECLARE @RanPastExtendedMaturity UNIQUEIDENTIFIER
DECLARE @BalancePath UNIQUEIDENTIFIER
DECLARE @ForFundedNotesdifferencebetweenCommitmentandTotalFunding UNIQUEIDENTIFIER

SET @RanPastExtendedMaturity = (Select TestCasesID from [App].[TestCasesMaster] where TestCasesDBName = 'Ran Past Extended Maturity' and ModuleTypeID = @ModuleNote)
SET @BalancePath = (Select TestCasesID from [App].[TestCasesMaster] where TestCasesDBName = 'Balance Path' and ModuleTypeID = @ModuleNote)
SET @RanPastInitialMaturity = (Select TestCasesID from [App].[TestCasesMaster] where TestCasesDBName = 'Ran Past Initial Maturity' and ModuleTypeID = @ModuleNote)
SET @ForFundedNotesdifferencebetweenCommitmentandTotalFunding = (Select TestCasesID from [App].[TestCasesMaster] where TestCasesDBName = 'For Funded notes, difference between "Commitment" and "Total Funding" = Zero' and ModuleTypeID = @ModuleNote)


--Deal
DECLARE @NetCashFlowReconbetweenLegalandPhantomNotesinaDeal UNIQUEIDENTIFIER
SET @NetCashFlowReconbetweenLegalandPhantomNotesinaDeal = (Select TestCasesID from [App].[TestCasesMaster] where TestCasesDBName = 'Net Cash Flow Recon between Legal and Phantom Notes in a Deal' and ModuleTypeID = @ModuleDeal)


IF(@IsRun = 1)
BEGIN

IF(@ModuleName = 'Note')
BEGIN
	Declare @Column nvarchar(256)=(select top 1 l.Name from core.Lookup  l inner join core.AnalysisParameter ap on l.lookupid=ap.MaturityScenarioOverrideID 
	inner join core.Analysis a on a.AnalysisID=ap.AnalysisID where a.StatusID=(select LookupID from core.Lookup where ParentID =2 and  Name = 'Y'))

	Delete from [App].[TestCasesDetails] where TestCasesID in (Select TestCasesID from app.TestCasesMaster where ModuleTypeID = @ModuleNote)

	INSERT INTO [App].[TestCasesDetails]
				   ([ObjectID]
				   ,[TestCasesID]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate])

	Select  noteid ,[TestCasesID], @userId,getdate(),@userId,getdate()
	from
	(
		--Ran Past Initial Maturity	
		Select DISTINCT n1.NoteID,@RanPastInitialMaturity as [TestCasesID] 
		from cre.transactionentry te
		 Inner join core.account acc on acc.accountid = te.AccountID
        Inner join cre.note n1 on n1.account_accountid = acc.accountid
 
		where ROUND(Amount ,0) <> 0 and [type] not in ('EndingGAAPBookValue','TotalGAAPIncomeforthePeriod')
		and acc.AccounttypeID = 1 
		and		[Date] > 
		(

			Select  mat.maturityDate as SelectedMaturityDate
			from [CORE].Maturity mat  
			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			INNER JOIN   
			(          
				Select   
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
				where EventTypeID = 11  and eve.statusID = 1
				and acc.IsDeleted = 0  
				and n.noteid = n1.NoteID
				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   and e.statusID = 1
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	
			where mat.maturityType = 708 
			and	mat.Approved = 3
			and n.noteid = n1.NoteID

			--Select TOP 1 mat.[SelectedMaturityDate]
			--		from [CORE].Maturity mat
			--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
			--		INNER JOIN (
			--			Select 
			--			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			--			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
			--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			--			INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
			--			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
			--			and n.noteid = te.NoteID and accSub.IsDeleted=0
			--			GROUP BY n.Account_AccountID,EventTypeID
			--	) sEvent
			--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		)


	
		UNION ALL

		--Ran Past Extended Maturity	
		Select DISTINCT n2.NoteID,@RanPastExtendedMaturity as [TestCasesID]
		from cre.transactionentry  te
		 Inner join core.account acc on acc.accountid = te.AccountID
        Inner join cre.note n2 on n2.account_accountid = acc.accountid
 
		--left Join cre.Note n On n.NoteID = te.Noteid	 
		where ROUND(Amount ,0) <> 0 and [type] not in ('EndingGAAPBookValue','TotalGAAPIncomeforthePeriod') 
		and acc.AccounttypeID = 1
		and te.Date > (

			Select isnull(n1.ActualPayoffDate,
				ISNULL(
					(CASE WHEN @Column ='Initial or Actual Payoff Date' then n1.ActualPayoffDate   
					WHEN @Column ='Expected Maturity Date' then n1.ExpectedMaturityDate   
					WHEN @Column ='Extended Maturity Date' then n1.ExtendedMaturityCurrent 
					WHEN @Column ='Open Prepayment Date' then n1.OpenPrepaymentDate   
					WHEN @Column ='Fully Extended Maturity Date' then n1.FullyExtendedMaturityDate 
					Else ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate))  end) 
				,tblInitialMaturity.InitialMaturityDate)
				)as maturity
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
							where EventTypeID = 11  and eve.statusID = 1
							and n.noteid = n2.NoteID
							and acc.IsDeleted = 0  
							GROUP BY n.Account_AccountID,EventTypeID    
						) sEvent    
						ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   and e.statusID = 1 
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
						Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
						Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
						where mat.MaturityDate > getdate()
						and lApproved.name = 'Y'
						and n.noteid = n2.NoteID
				)a where a.rno = 1
			)currMat on currMat.noteid = n1.noteid
			Left JOin(
				Select n.noteid,mat.MaturityDate as InitialMaturityDate
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11   and eve.statusID = 1
					and acc.IsDeleted = 0  
					and n.noteid = n2.NoteID
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   and e.statusID = 1
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where mat.MaturityType = 708 and mat.Approved = 3
			)tblInitialMaturity on tblInitialMaturity.noteid = n1.noteid
			where acc1.IsDeleted <> 1
			and n1.noteid = n2.NoteID
			--select
			--isnull(n.ActualPayoffDate, isnull(
			--	case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
			--	when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
			--	when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
			--	when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
			--	when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
			--	when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
			--	when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

			--(Select TOP 1 mat.[SelectedMaturityDate]
			--	from [CORE].Maturity mat
			--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
			--	INNER JOIN (Select 
			--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
			--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			--	INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
			--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
			--	and n.NoteID = te.NoteID and accSub.IsDeleted=0
			--	GROUP BY n.Account_AccountID,EventTypeID
			--) sEvent
			--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
			--))



		)
	   

		UNION ALL

		--Balance Path	
		Select DISTINCT NoteID,
		@BalancePath as [TestCasesID]
		 from (
		Select n.NoteID,ROUND(SUM(Amount),0) amount 
		from cre.transactionentry tr
		Inner JOin core.account acc on acc.accountID = tr.AccountID
		Inner JOin cre.note n on n.Account_Accountid = acc.AccountID
		where [Type] in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid')
		group by n.NoteID
		)a
		where a.amount <> 0


		UNION ALL

		--For Funded notes, difference between "Commitment" and "Total Funding" = Zero	
		Select Distinct Noteid,@ForFundedNotesdifferencebetweenCommitmentandTotalFunding as [TestCasesID]
		from(
		Select n.NoteID,(ROUND(ISNULL(n.TotalCommitment,0),0) + ROUND(SUM(te.Amount),0)) amount 
		from cre.transactionentry  te
		 Inner join core.account acc on acc.accountid = te.AccountID
         Inner join cre.note n on n.account_accountid = acc.accountid
 
		--left Join cre.Note n On n.NoteID = te.Noteid
		where Type in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid')
		and te.Amount < 0 and acc.AccounttypeID = 1
		group by n.NoteID,n.TotalCommitment
		)a
		where a.amount <> 0
	)b

END
IF(@ModuleName = 'Deal')
BEGIN
	
	Delete from [App].[TestCasesDetails] where TestCasesID in (Select TestCasesID from app.TestCasesMaster where ModuleTypeID = @ModuleDeal)

	INSERT INTO [App].[TestCasesDetails]
				   ([ObjectID]
				   ,[TestCasesID]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate])

	Select  dealid ,[TestCasesID], @userId,getdate(),@userId,getdate()
	from
	(
		Select DealID,@NetCashFlowReconbetweenLegalandPhantomNotesinaDeal as [TestCasesID]
		from
		(
			Select (Select dealid from cre.deal dd where dd.credealid = ISNULL(d.LinkedDealID,d.CREDealID))as DealID,
			ISNULL(d.LinkedDealID,CREDealID) CREDealID,ROUND(SUM(Amount),0) as Amount
			from cre.Deal d 
			left join cre.Note n on d.DealID = n.DealID
			left join cre.TransactionEntry tr on tr.AccountID = n.Account_accountid
			where CREDealID  in (Select Distinct LinkedDealID from cre.deal where NULLIF(LinkedDealID,'') is not null)
			or LinkedDealID  in (Select Distinct LinkedDealID from cre.deal where NULLIF(LinkedDealID,'') is not null) 
			group by ISNULL(d.LinkedDealID,CREDealID)
		)a
		Where a.Amount <> 0

	)b
END


END

	
	DECLARE @query AS NVARCHAR(MAX)
	DECLARE @cols AS NVARCHAR(MAX)
	DECLARE @cols1 AS NVARCHAR(MAX)
	DECLARE @lastexcuted AS VARCHAR(100)

	


	IF(@ModuleName = 'Note')
	BEGIN
		
		set @TotalCount =(select COUNT(DISTINCT ObjectID) FROM app.TestCasesDetails where TestCasesID in (Select TestCasesID from app.TestCasesMaster where ModuleTypeID = @ModuleNote));
		set @lastexcuted=(select top 1(format(UpdatedDate,'MM/dd/yyyy HH:mm:ss tt')) FROM app.TestCasesDetails where TestCasesID in (Select TestCasesID from app.TestCasesMaster where ModuleTypeID = @ModuleNote));

		SET @cols = (Select distinct  
						stuff((select ',REPLACE([' + u.TestCasesName +'],''1'',''X'') as [' + u.TestCasesName +']' from app.TestCasesMaster u	where u.TestCasesName = TestCasesName and  StatusID = 1 and ModuleTypeID= @ModuleNote for xml path('')),1,1,'') as list
					from app.TestCasesMaster where StatusID = 1 and ModuleTypeID= @ModuleNote)

		SET @cols1 = (Select distinct  
						stuff((select ',[' + u.TestCasesName +']' from app.TestCasesMaster u	where u.TestCasesName = TestCasesName and  StatusID = 1 and ModuleTypeID= @ModuleNote for xml path('')),1,1,'') as list
					from app.TestCasesMaster where StatusID = 1 and ModuleTypeID= @ModuleNote)


		SET @query = N'
		SELECT TotalCount,LastExcuted,NoteID,CRENoteID,NoteName, ' + @cols + N'
		FROM (
			Select 
			 CAST('+cast(@TotalCount as varchar(50)) +' as varchar(5))  as TotalCount,
			 Convert (nvarchar(MAX),'''+ @lastexcuted +''',101) as LastExcuted,	
			n.NoteID,
			n.CRENoteID,
			acc.Name as NoteName,
			tm.testcasesname,
			1 as Result	
			from 
			app.TestCasesMaster tm
			inner join app.TestCasesDetails td on tm.TestCasesID = td.TestCasesID
			inner join cre.note n on n.NoteID = td.ObjectID
			inner join core.account acc on acc.AccountID = n.Account_AccountID
			where tm.StatusID = 1 and acc.IsDeleted=0 and tm.ModuleTypeID = '+CAST(@ModuleNote as varchar(20)) +'
		) as s
		PIVOT
		(
			SUM(Result)
			FOR testcasesname IN (' + @cols1 + N')
		)AS pvt
		order by pvt.NoteID
		 	OFFSET (' + CAST(@PgeIndex as varchar(5))  +' - 1)*'+  CAST(@PageSize as varchar(5)) +' ROWS
		FETCH NEXT  '+ CAST(@PageSize as varchar(5))  + ' ROWS ONLY';
	END


	IF(@ModuleName = 'Deal')
	BEGIN
		
		set @TotalCount =(select distinct COUNT(TestCasesID) FROM app.TestCasesDetails where TestCasesID in (Select TestCasesID from app.TestCasesMaster where ModuleTypeID = @ModuleDeal));
		set @lastexcuted=(select top 1(format(UpdatedDate,'MM/dd/yyyy HH:mm:ss tt')) FROM app.TestCasesDetails where TestCasesID in (Select TestCasesID from app.TestCasesMaster where ModuleTypeID = @ModuleDeal));

		SET @cols = (Select distinct  
						stuff((select ',REPLACE([' + u.TestCasesName +'],''1'',''X'') as [' + u.TestCasesName +']' from app.TestCasesMaster u	where u.TestCasesName = TestCasesName and  StatusID = 1 and ModuleTypeID= @ModuleDeal for xml path('')),1,1,'') as list
					from app.TestCasesMaster where StatusID = 1 and ModuleTypeID= @ModuleDeal)

		SET @cols1 = (Select distinct  
						stuff((select ',[' + u.TestCasesName +']' from app.TestCasesMaster u	where u.TestCasesName = TestCasesName and  StatusID = 1 and ModuleTypeID= @ModuleDeal for xml path('')),1,1,'') as list
					from app.TestCasesMaster where StatusID = 1 and ModuleTypeID= @ModuleDeal)


		SET @query = N'
		SELECT TotalCount,LastExcuted,DealID,CREDealID,DealName, ' + @cols + N'
		FROM (
			Select 
			 CAST('+cast(@TotalCount as varchar(50)) +' as varchar(5))  as TotalCount,
			 Convert (nvarchar(MAX),'''+ @lastexcuted +''',101) as LastExcuted,	
			n.DealID,
			n.CREDealID,
			n.DealName as DealName,
			tm.testcasesname,
			1 as Result	
			from 
			app.TestCasesMaster tm
			inner join app.TestCasesDetails td on tm.TestCasesID = td.TestCasesID
			inner join cre.Deal n on n.DealID = td.ObjectID			
			where tm.StatusID = 1 and n.IsDeleted=0 and tm.ModuleTypeID = '+CAST(@ModuleDeal as varchar(20)) +'
		) as s
		PIVOT
		(
			SUM(Result)
			FOR testcasesname IN (' + @cols1 + N')
		)AS pvt
		order by pvt.DealID';
		--OFFSET (' + @PgeIndex +' - 1)*@PageSize ROWS
		--FETCH NEXT  '+ @PageSize  + 'ROWS ONLY';
	END

	
	PRINT(@cols1)
	PRINT(@query)
	EXEC(@query)





END



