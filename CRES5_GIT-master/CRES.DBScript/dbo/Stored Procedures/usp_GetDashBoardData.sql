-- Procedure

CREATE PROCEDURE [DBO].[usp_GetDashBoardData]
	@DealID uniqueidentifier = null,
	@UserId  NVARCHAR (256) = null
AS
BEGIN
	SET NOCOUNT ON;


	IF @UserId Is NOT NULL
	BEGIN
		Select D.DealID
		,D.CREDealID
		,D.DealName
		,D.AccountID
		,(u.FirstName+' '+u.LastName) as AssetManager  
		,SUM(N.TotalCommitment) as TotalCommitment
		,SUM(N.AdjustedTotalCommitment) as AdjustedTotalCommitment
		,xd.XIRRValue
		,UpD.[FileName]
		,FFEqt.FullyFundedEquity
		,ReqEqt.EquityContributedToDate
		,BEqt.BorrowerEquity
		,NextFunding.NextFundingDate
		,NextPaydown.NextPaydownDate
		,CASE WHEN ISNULL(UseRule.UserRulesCount,0) = 0 Then 'N' ELSE 'Y' END as UseRules
		,D.PrimaryBankerName as Banker
		,D.UpdatedDate
		,Round(FundPer.FundedPercentage * 100, 0) as FundedPercentage

		from cre.deal D 
		INNER JOIN cre.note N ON D.DealID = N.DealID
		left join app.[User] u on d.AMUserID = u.UserID    
		Left Join CRE.XIRROutputDealLevel xd on xd.DealAccountID=D.AccountID and xd.XIRRConfigID=(select XIRRConfigID from cre.XIRRConfig where ReturnName='Whole Loan Return (Excl. 3rd Party)')
		LEFT JOIN (
			select ObjectID,FileName, 
			ROW_NUMBER() Over(Partition By ObjectID order by UpdatedDate desc) Sno 
			FROM [App].[UploadedDocumentLog] 
			where FileName like '%jpg%' or FileName like '%jpeg%'
		) UpD ON CAST(D.DealID as NVARCHAR(255)) = UpD.ObjectID AND Sno=1
		LEFT JOIN (  
			Select d.dealid, ISNULL(d.EquityAtClosing,0) + SUM(ISNULL(NCM.TotalRequiredEquity,0)) + SUM(ISNULL(NCM.TotalAdditionalEquity,0)) as FullyFundedEquity
			from cre.deal d  
			LEFT JOIN cre.NoteAdjustedCommitmentMaster  NCM on ncm.dealid = d.dealid
			where NCM.date <= CAST(getdate() as date)  
			AND d.dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)
			group by D.dealid, d.EquityAtClosing  
		) FFEqt ON FFEqt.DealID = D.DealID
		LEFT JOIN (
			Select d.dealid, SUM(ISNULL(DF.RequiredEquity,0)) as EquityContributedToDate
			from cre.deal d  
			LEFT JOIN cre.dealfunding  DF on D.DealID = DF.DealID 
			where DF.date <= CAST(getdate() as date)  
			AND d.dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)
			group by D.dealid     
		) ReqEqt ON  ReqEqt.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Min(Date) as NextFundingDate
			from cre.DealFunding 
			Where [date]>GETDATE() AND Amount>0 
			AND dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)
			group by dealid   
		) NextFunding ON NextFunding.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Min(Date) as NextPaydownDate
			from cre.DealFunding 
			Where [date]>GETDATE() AND Amount<0 
			AND dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)
			group by dealid   
		) NextPaydown ON NextPaydown.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Count(UseRuletoDetermineNoteFunding) UserRulesCount
			from cre.note Where UseRuletoDetermineNoteFunding = 3
			AND dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)
			Group By DealID 
		) UseRule ON UseRule.DealID = D.DealID
		LEFT JOIN (
			Select dealid,SUM(ISNULL(AdditionalEquity,0))  as BorrowerEquity  
			from cre.dealfunding  
			where date <= CAST(getdate() as date)  
			AND dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)  
			group by dealid  
		) BEqt on BEqt.DealID = D.DealID
		LEFT JOIN (
			Select a.DealID, (SUM(N.TotalCommitment)-SUM(RemainingUnfundedCommitment))/SUM(N.TotalCommitment) as FundedPercentage
			from cre.deal d  
			INNER JOIN cre.Note N on N.dealid = d.dealid
			LEFT JOIN(    
				Select n.DealID,n.NoteID,RemainingUnfundedCommitment ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
				from cre.NotePeriodicCalc nc
				inner join cre.note n on n.Account_AccountID =nc.AccountID 
				where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and nc.PeriodEndDate <= Cast(getdate() as Date)  
				and n.dealid in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)  
			)a on D.dealid = a.dealid and N.NoteID = a.NoteID where rno = 1    
			Group By a.DealID
		) FundPer on D.DealID = FundPer.DealID

		where d.isdeleted <> 1 AND D.DealID in (Select DealID from cre.Deal d INNER JOIN cre.BookMark b on b.AccountID = d.AccountID where UserID = @UserId)

		Group By D.DealID
		,D.CREDealID
		,D.DealName
		,D.AccountID
		,D.AssetManager
		,xd.XIRRValue
		,UpD.[FileName]
		,FFEqt.FullyFundedEquity
		,ReqEqt.EquityContributedToDate
		,NextFunding.NextFundingDate
		,NextPaydown.NextPaydownDate
		,UseRule.UserRulesCount
		,BEqt.BorrowerEquity
		,D.UpdatedDate
		,u.FirstName
		,u.LastName
		,FundPer.FundedPercentage
		,D.PrimaryBankerName
		ORDER BY D.UpdatedDate Desc
	END

	Else IF @DealID Is NULL
	BEGIN
		Select TOP 100 D.DealID
		,D.CREDealID
		,D.DealName
		,D.AccountID
		,(u.FirstName+' '+u.LastName) as AssetManager  
		,SUM(N.TotalCommitment) as TotalCommitment
		,SUM(N.AdjustedTotalCommitment) as AdjustedTotalCommitment
		,xd.XIRRValue
		,UpD.[FileName]
		,FFEqt.FullyFundedEquity
		,ReqEqt.EquityContributedToDate
		,BEqt.BorrowerEquity
		,NextFunding.NextFundingDate
		,NextPaydown.NextPaydownDate
		,CASE WHEN ISNULL(UseRule.UserRulesCount,0) = 0 Then 'N' ELSE 'Y' END as UseRules
		,D.PrimaryBankerName as Banker
		,D.UpdatedDate
		,NULL as FundedPercentage

		from cre.deal D 
		INNER JOIN cre.note N ON D.DealID = N.DealID
		left join app.[User] u on d.AMUserID = u.UserID    
		Left Join CRE.XIRROutputDealLevel xd on xd.DealAccountID=D.AccountID and xd.XIRRConfigID=(select XIRRConfigID from cre.XIRRConfig where ReturnName='Whole Loan Return (Excl. 3rd Party)')
		LEFT JOIN (
			select ObjectID,FileName, 
			ROW_NUMBER() Over(Partition By ObjectID order by UpdatedDate desc) Sno 
			FROM [App].[UploadedDocumentLog] 
			where FileName like '%jpg%' or FileName like '%jpeg%'
		) UpD ON CAST(D.DealID as NVARCHAR(255)) = UpD.ObjectID AND Sno=1
		LEFT JOIN (  
			Select d.dealid, ISNULL(d.EquityAtClosing,0) + SUM(ISNULL(NCM.TotalRequiredEquity,0)) + SUM(ISNULL(NCM.TotalAdditionalEquity,0)) as FullyFundedEquity
				from cre.deal d  
				LEFT JOIN cre.NoteAdjustedCommitmentMaster  NCM on ncm.dealid = d.dealid
				where NCM.date <= CAST(getdate() as date)  
				group by D.dealid, d.EquityAtClosing  
		) FFEqt ON FFEqt.DealID = D.DealID
		LEFT JOIN (
			Select d.dealid, SUM(ISNULL(DF.RequiredEquity,0)) as EquityContributedToDate
			 from cre.deal d  
			 LEFT JOIN cre.dealfunding  DF on D.DealID = DF.DealID 
			 where DF.date <= CAST(getdate() as date)  
			 group by D.dealid     
		) ReqEqt ON  ReqEqt.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Min(Date) as NextFundingDate
			from cre.DealFunding 
			Where [date]>GETDATE() AND Amount>0 
			group by dealid   
		) NextFunding ON NextFunding.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Min(Date) as NextPaydownDate
			from cre.DealFunding 
			Where [date]>GETDATE() AND Amount<0 
			group by dealid   
		) NextPaydown ON NextPaydown.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Count(UseRuletoDetermineNoteFunding) UserRulesCount
			from cre.note Where UseRuletoDetermineNoteFunding = 3
			Group By DealID 
		) UseRule ON UseRule.DealID = D.DealID
		LEFT JOIN (
			Select dealid,SUM(ISNULL(AdditionalEquity,0))  as BorrowerEquity  
			from cre.dealfunding  
			where date <= CAST(getdate() as date)  
			--AND dealid = @dealid  
			group by dealid  
		) BEqt on BEqt.DealID = D.DealID

		where d.isdeleted <> 1 

		Group By D.DealID
		,D.CREDealID
		,D.DealName
		,D.AccountID
		,D.AssetManager
		,xd.XIRRValue
		,UpD.[FileName]
		,FFEqt.FullyFundedEquity
		,ReqEqt.EquityContributedToDate
		,NextFunding.NextFundingDate
		,NextPaydown.NextPaydownDate
		,UseRule.UserRulesCount
		,BEqt.BorrowerEquity
		,D.UpdatedDate
		,u.FirstName
		,u.LastName
		,D.PrimaryBankerName
		ORDER BY D.UpdatedDate Desc
	END
	ELSE
	BEGIN
		Select D.DealID
		,D.CREDealID
		,D.DealName
		,D.AccountID
		,(u.FirstName+' '+u.LastName) as AssetManager  
		,SUM(N.TotalCommitment) as TotalCommitment
		,SUM(N.AdjustedTotalCommitment) as AdjustedTotalCommitment
		,xd.XIRRValue
		,UpD.[FileName]
		,FFEqt.FullyFundedEquity
		,ReqEqt.EquityContributedToDate
		,BEqt.BorrowerEquity
		,NextFunding.NextFundingDate
		,NextPaydown.NextPaydownDate
		,CASE WHEN ISNULL(UseRule.UserRulesCount,0) = 0 Then 'N' ELSE 'Y' END as UseRules
		,D.PrimaryBankerName as Banker
		,D.UpdatedDate
		,Round(FundPer.FundedPercentage * 100, 0) as FundedPercentage

		from cre.deal D 
		INNER JOIN cre.note N ON D.DealID = N.DealID
		left join app.[User] u on d.AMUserID = u.UserID    
		Left Join CRE.XIRROutputDealLevel xd on xd.DealAccountID=D.AccountID and xd.XIRRConfigID=(select XIRRConfigID from cre.XIRRConfig where ReturnName='Whole Loan Return (Excl. 3rd Party)')
		LEFT JOIN (
			select ObjectID,FileName, 
			ROW_NUMBER() Over(Partition By ObjectID order by UpdatedDate desc) Sno 
			FROM [App].[UploadedDocumentLog] 
			where FileName like '%jpg%' or FileName like '%jpeg%'
		) UpD ON CAST(D.DealID as NVARCHAR(255)) = UpD.ObjectID AND Sno=1
		LEFT JOIN (  
			Select d.dealid, ISNULL(d.EquityAtClosing,0) + SUM(ISNULL(NCM.TotalRequiredEquity,0)) + SUM(ISNULL(NCM.TotalAdditionalEquity,0)) as FullyFundedEquity
			from cre.deal d  
			LEFT JOIN cre.NoteAdjustedCommitmentMaster  NCM on ncm.dealid = d.dealid
			where NCM.date <= CAST(getdate() as date)  
			AND d.dealid = @dealid
			group by D.dealid, d.EquityAtClosing  
		) FFEqt ON FFEqt.DealID = D.DealID
		LEFT JOIN (
			Select d.dealid, SUM(ISNULL(DF.RequiredEquity,0)) as EquityContributedToDate
			from cre.deal d  
			LEFT JOIN cre.dealfunding  DF on D.DealID = DF.DealID 
			where DF.date <= CAST(getdate() as date)  
			AND d.dealid = @dealid
			group by D.dealid     
		) ReqEqt ON  ReqEqt.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Min(Date) as NextFundingDate
			from cre.DealFunding 
			Where [date]>GETDATE() AND Amount>0 
			AND dealid = @dealid
			group by dealid   
		) NextFunding ON NextFunding.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Min(Date) as NextPaydownDate
			from cre.DealFunding 
			Where [date]>GETDATE() AND Amount<0 
			AND dealid = @dealid
			group by dealid   
		) NextPaydown ON NextPaydown.DealID = D.DealID
		LEFT JOIN (
			Select DealID, Count(UseRuletoDetermineNoteFunding) UserRulesCount
			from cre.note Where UseRuletoDetermineNoteFunding = 3
			AND dealid = @dealid
			Group By DealID 
		) UseRule ON UseRule.DealID = D.DealID
		LEFT JOIN (
			Select dealid,SUM(ISNULL(AdditionalEquity,0))  as BorrowerEquity  
			from cre.dealfunding  
			where date <= CAST(getdate() as date)  
			AND dealid = @dealid  
			group by dealid  
		) BEqt on BEqt.DealID = D.DealID
		LEFT JOIN (
			Select a.DealID, (SUM(N.TotalCommitment)-SUM(RemainingUnfundedCommitment))/SUM(N.TotalCommitment) as FundedPercentage
			from cre.deal d  
			INNER JOIN cre.Note N on N.dealid = d.dealid
			LEFT JOIN(    
				Select n.DealID,n.NoteID,RemainingUnfundedCommitment ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
				from cre.NotePeriodicCalc nc
				inner join cre.note n on n.Account_AccountID =nc.AccountID 
				where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and nc.PeriodEndDate <= Cast(getdate() as Date)  
				and n.dealid = @DealID  
			)a on D.dealid = a.dealid and N.NoteID = a.NoteID where rno = 1    
			Group By a.DealID
		) FundPer on D.DealID = FundPer.DealID
		where d.isdeleted <> 1 AND D.DealID = @DealID

		Group By D.DealID
		,D.CREDealID
		,D.DealName
		,D.AccountID
		,D.AssetManager
		,xd.XIRRValue
		,UpD.[FileName]
		,FFEqt.FullyFundedEquity
		,ReqEqt.EquityContributedToDate
		,NextFunding.NextFundingDate
		,NextPaydown.NextPaydownDate
		,UseRule.UserRulesCount
		,BEqt.BorrowerEquity
		,D.UpdatedDate
		,u.FirstName
		,u.LastName
		,FundPer.FundedPercentage
		,D.PrimaryBankerName
		ORDER BY D.UpdatedDate Desc
	END
END
GO